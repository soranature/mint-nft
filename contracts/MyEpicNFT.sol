// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  string[] colors = [
    "red",
    "orange",
    "yellow",
    "green",
    "blue",
    "indigo",
    "violet"
  ];
  string[] firstWords = [
    "Flying",
    "Crying",
    "Angry",
    "Sleepy",
    "Running",
    "Laughing",
    "Happy"
  ];
  string[] secondWords = [
    "Asparagus",
    "Avocado",
    "Kale",
    "Potato",
    "Spinach",
    "Broccoli",
    "Carrot"
  ];
  string[] thirdWords = [
    "Banana",
    "Kiwi",
    "Apple",
    "Peach",
    "Orange",
    "Grape",
    "Cherry"
  ];

  event NewEpicNFTMinted(address sender, uint256 tokenId);

  constructor() ERC721 ("SquareNFT", "SQUARE") {
    console.log("This is my NFT contract. Woah!");
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function pickRandomElement(uint256 tokenId, string[] memory arr, string memory fertilizer) internal pure returns (string memory) {
    uint256 rand = random(string(abi.encodePacked(fertilizer, Strings.toString(tokenId))));
    rand = rand % arr.length;
    return arr[rand];
  }

  function makeAnEpicNFT() public {
    uint256 newItemId = _tokenIds.current();

    string memory firstColor = pickRandomElement(newItemId, colors, "FIRST_COLOR");
    string memory secondColor = pickRandomElement(newItemId, colors, "SECOND_COLOR");
    string memory combinedWord = string(abi.encodePacked(
      pickRandomElement(newItemId, firstWords, "FIRST_WORD"),
      pickRandomElement(newItemId, secondWords, "SECOND_WORD"),
      pickRandomElement(newItemId, thirdWords, "THIRD_WORD")
    ));

    string memory beforeFirstColor = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><defs><linearGradient id="a" x1="0" x2="100%" y1="0" y2="0" gradientUnits="userSpaceOnUse"><stop stop-color="';
    string memory beforeSecondColor = '" offset="0%"/><stop stop-color="';
    string memory beforeCombinedWord = '" offset="100%"/></linearGradient></defs><rect width="100%" height="100%"/><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" fill="url(#a)" style="font-size:24px">';
    string memory closingSvg = '</text></svg>';

    string memory combinedSvg = string(abi.encodePacked(
      beforeFirstColor,
      firstColor,
      beforeSecondColor,
      secondColor,
      beforeCombinedWord,
      combinedWord,
      closingSvg
    ));

    string memory jsonString = string(
      abi.encodePacked(
        '{"name": "',
        combinedWord,
        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
        Base64.encode(bytes(combinedSvg)),
        '"}'
      )
    );

    string memory json = Base64.encode(
      bytes(jsonString)
    );

    string memory finalTokenUri = string(
      abi.encodePacked("data:application/json;base64,", json)
    );

    console.log(jsonString);
    console.log(combinedSvg);

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

    _safeMint(msg.sender, newItemId);

    _setTokenURI(newItemId, finalTokenUri);

    _tokenIds.increment();
    console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);

    emit NewEpicNFTMinted(msg.sender, newItemId);
  }
}