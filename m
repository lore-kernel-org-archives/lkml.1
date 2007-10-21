Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbXJULcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbXJULcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 07:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbXJULck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 07:32:40 -0400
Received: from thunk.org ([69.25.196.29]:48427 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbXJULcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 07:32:39 -0400
Date: Sun, 21 Oct 2007 07:32:25 -0400
From: Theodore Tso <tytso@mit.edu>
To: Helge Deller <deller@gmx.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH 1/2] UUID: set multicast bit in pseudo-random MAC
	address
Message-ID: <20071021113225.GA7045@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Helge Deller <deller@gmx.de>, Andrew Morton <akpm@osdl.org>,
	linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
References: <200710202139.25595.deller@gmx.de> <200710202158.40645.deller@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710202158.40645.deller@gmx.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 20, 2007 at 09:58:40PM +0200, Helge Deller wrote:
> Fix a bug in the current random UUID generator:
> 
> Section 4.1.6 of RFC 4122 states regarding the "NodeID" of a UUID:
> :  For systems with no IEEE address, a randomly or pseudo-randomly
> :  generated value may be used; see Section 4.5.  The multicast bit must
> :  be set in such addresses, in order that they will never conflict with
> :  addresses obtained from network cards. 
> 
> So up to now it was just pure ("random") luck if this bit was set or not.
> This tiny patch sets the bit explicitely.

NACK.  Your patch degrades the random UUID by a bit, for no good reason.

The part of Section 4.1.6 which you quoted only applies to version 1
UUID's --- i.e., MAC and time based UUID's.  Random uuids are version
4 UUID's, and are already distinguished from version 1 UUID's by the
high 4 bits of the time_hi_and_version field, in octets 6-7 of the
URL.  Hence, there is no danger of conflict.  If you had looked 3
paragraphs later section 4.1.6:

   For UUID version 4, the node field is a randomly or pseudo-randomly
   generated 48-bit value as described in Section 4.4.

And the summary can be found in Section 4.4 of RFRC 4122:

4.4.  Algorithms for Creating a UUID from Truly Random or
      Pseudo-Random Numbers

   The version 4 UUID is meant for generating UUIDs from truly-random or
   pseudo-random numbers.

   The algorithm is as follows:

   o  Set the two most significant bits (bits 6 and 7) of the
      clock_seq_hi_and_reserved to zero and one, respectively.

   o  Set the four most significant bits (bits 12 through 15) of the
      time_hi_and_version field to the 4-bit version number from
      Section 4.1.3.

   o  Set all the other bits to randomly (or pseudo-randomly) chosen
      values.

   See Section 4.5 for a discussion on random numbers.

   	     	    	     	       	  	  - Ted
