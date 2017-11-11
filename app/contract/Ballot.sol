pragma solidity ^0.4.0;


contract Ballot {
    
    // Ballot owner
    address gblChairman;

    // Voter class
    struct Voter {
        bool hasVoted;
        string adharNumber;
        bool isPresent;
    }
    
    // Participating party in the ballot
    struct Party {
        uint voteCount;
        bytes32 name;
    }
    
    // Parties
    uint[] gblpartyListArr;
    mapping(uint => Party) gblpartyList;
    
    // Parties
    mapping(string => Voter) gbl_voterList;
    
    // All global variables
    string gblballotName;
    uint gblvotingStartTime;
    uint gblvotingEndTime;
 
    /*** 
     * Function Name : Ballot() 
     * Function Use : Constructor to initialize gbl variables
     * Parameters:
     *  1. _ballotName : Name of election. e.g General Elections, State assembly, Local body elections etc.
     *  2. _votingEndTime : Time at which this voting will end (in seconds)
     */
    function Ballot(string _ballotName, 
                    uint _votingEndTime) public {
                        
        gblChairman = msg.sender;
        gblballotName = _ballotName;
        gblvotingEndTime = _votingEndTime;
        //gblvotingStartTime = now;
    }
    
    /*** 
     * Function Name : AddParty() 
     * Function Use : Admin will create a party
     * Parameters :
     *  1. _partyId : Id of a party, can be integer only
     *  2. _partyName : Party Name in string
     * Returns : True or False
     */
    function addParty(uint _partyId, bytes32 _partyName) public returns(bool){
        gblpartyList[_partyId].name = _partyName;
        gblpartyList[_partyId].voteCount = 0;
        gblpartyListArr.push(_partyId);
        return true;
    }
    
    /*** 
     * Function Name : AddVoter() 
     * Function Use : Add a voter to the list.
     * Parameters:
     *  1. _adharNumber : Adhar number of a voter
     * Returns : True or False
     */
    function addVoter(string _adharNumber) public returns(bool){
        gbl_voterList[_adharNumber].hasVoted = false;
        gbl_voterList[_adharNumber].adharNumber = _adharNumber;
        gbl_voterList[_adharNumber].isPresent = true;
        return true;
    }
    
    /*** 
     * Function Name : ValidateBallotVoter() 
     * Function Use : Check if a voter is avaliable in the list and hasVoted is false
     * Parameters:
     *  1. _adharNumber : Adhar number of a voter
     * Returns : True or False
     */
    function validateBallotVoter(string _adharNumber) public constant returns(bool){     
        if (gbl_voterList[_adharNumber].isPresent == true && gbl_voterList[_adharNumber].hasVoted == false) {        
            return true;
        }else {
            return false;
        }
        
    }
    
    /*** 
     * Function Name : GetListOfParties() 
     * Function Use : Get list of party names
     * Parameters:
     * Returns : Array of partyNames
     */  
    function getListOfParties() public constant returns(bytes32[]) {
        bytes32[] memory partyNamesArr =  new bytes32[](gblpartyListArr.length);
        for(uint i = 0; i < gblpartyListArr.length; i++){
            partyNamesArr[i] = gblpartyList[gblpartyListArr[i]].name;
        }
        return partyNamesArr;
    }
    
    /*** 
     * Function Name : DoVoting() 
     * Function Use : Actual method to do voting
     * Parameters:
     *  1. _partyId : Id of the party to which vote will be casted
     * Returns : True or False
     */
    function doVoting(uint _partyId) public  returns(bool){
        bool hasVoted = false;
        uint voteCnt = 0;
        voteCnt = gblpartyList[_partyId].voteCount;
        gblpartyList[_partyId].voteCount = voteCnt + 1;
        hasVoted = true;
        return hasVoted;
    }
    
    /*** 
     * Function Name : GetTotalVoteCountOfParty() 
     * Function Use : Get the total vote count
     * Parameters:
     *  1. _partyId : Id of the party for which total count is needed
     * Returns : total count of vote till now.
     */
    function getTotalVoteCountOfParty(uint _partyId) public constant returns(uint){
        uint totalVoteCnt =0;
        totalVoteCnt = gblpartyList[_partyId].voteCount;
        return totalVoteCnt;
    }
}