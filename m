Return-Path: <linux-kernel-owner+w=401wt.eu-S1752497AbXJUTK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbXJUTK0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 15:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbXJUTKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 15:10:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:59496 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751538AbXJUTKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 15:10:15 -0400
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX1/RO75jA9rRVzjeQTapfJwxk/4kV42lUh4wLfb3IN
	ZvAnOZrqRZOo/A
From: Helge Deller <deller@gmx.de>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] UUID: set multicast bit in pseudo-random MAC address
Date: Sun, 21 Oct 2007 21:09:18 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       Valdis.Kletnieks@vt.edu
References: <200710202139.25595.deller@gmx.de> <200710202158.40645.deller@gmx.de> <20071021113225.GA7045@thunk.org>
In-Reply-To: <20071021113225.GA7045@thunk.org>
X-Face: &[jmHH-Dw>Aj):"[/t-VasJu+(5eP`/LEckV7V"JV,!nBy[6(/?#8M>x`5xzg/7:FkM.l@=?utf-8?q?=0A=0913?=<&9'nfV3"OkD~P)@j{P2=(uB7J(){:CcrM2jZeA+IBq?FUTp3c8Y{t+k<95mZf~[v"=?utf-8?q?=27=3A=0A=09t?="f6wKtHUPFB&/]Z5^?9~IQs=16R;Pg"NS9JD=DK!ft&4b@=?utf-8?q?S=7E=26q/MfI3=3BqWqlg7Q1=3D=3DjS4=0A=099V5OJkm=24WQ=5Bdc=5E=5FY?=
 =?utf-8?q?=27=5DDvibvMjizUZ=5D+=27Jd4UnM?=><yrT}Rw(
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710212109.18559.deller@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 21 October 2007, Theodore Tso wrote:
> On Sat, Oct 20, 2007 at 09:58:40PM +0200, Helge Deller wrote:
> > Fix a bug in the current random UUID generator:
> > 
> > Section 4.1.6 of RFC 4122 states regarding the "NodeID" of a UUID:
> > :  For systems with no IEEE address, a randomly or pseudo-randomly
> > :  generated value may be used; see Section 4.5.  The multicast bit must
> > :  be set in such addresses, in order that they will never conflict with
> > :  addresses obtained from network cards. 
> > 
> > So up to now it was just pure ("random") luck if this bit was set or not.
> > This tiny patch sets the bit explicitely.
> 
> NACK.  Your patch degrades the random UUID by a bit, for no good reason.
> 
> The part of Section 4.1.6 which you quoted only applies to version 1
> UUID's --- i.e., MAC and time based UUID's.  Random uuids are version
> 4 UUID's, and are already distinguished from version 1 UUID's by the
> high 4 bits of the time_hi_and_version field, in octets 6-7 of the
> URL.  Hence, there is no danger of conflict.  If you had looked 3
> paragraphs later section 4.1.6:
> 
>    For UUID version 4, the node field is a randomly or pseudo-randomly
>    generated 48-bit value as described in Section 4.4.
> 
> And the summary can be found in Section 4.4 of RFRC 4122:
> 
> 4.4.  Algorithms for Creating a UUID from Truly Random or
>       Pseudo-Random Numbers
> 
>    The version 4 UUID is meant for generating UUIDs from truly-random or
>    pseudo-random numbers.
> 
>    The algorithm is as follows:
> 
>    o  Set the two most significant bits (bits 6 and 7) of the
>       clock_seq_hi_and_reserved to zero and one, respectively.
> 
>    o  Set the four most significant bits (bits 12 through 15) of the
>       time_hi_and_version field to the 4-bit version number from
>       Section 4.1.3.
> 
>    o  Set all the other bits to randomly (or pseudo-randomly) chosen
>       values.
> 
>    See Section 4.5 for a discussion on random numbers.

Hi Ted,

Thanks for looking into it and pointing to the important RFC pieces. 
Of course you are right and I mixed that up.

Herewith I withdraw this patch.

Helge
