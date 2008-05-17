Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbYEQTRQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbYEQTRQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 15:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755034AbYEQTQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 15:16:56 -0400
Received: from server515g.exghost.com ([72.32.253.81]:4125 "EHLO
	server515.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754257AbYEQTQz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 15:16:55 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
x-cr-hashedpuzzle: Ayau BSv4 DbLf EWkI HOft Huqx IxDr KtkR MA/Q MftC NQti PE9X Pu9t S2NX T/DB YLgT;2;bABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAHIAYQBpAGQAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA=;Sosha1_v1;7;{B39F20A9-F604-417D-80AA-2209D967027A};ZABhAHYAaQBkAEAAcwBhAG4AdABvAG8AbABzAC4AYwBvAG0A;Sat, 17 May 2008 19:10:00 GMT;TQBlAGMAaABhAG4AaQBzAG0AIAB0AG8AIABzAGEAZgBlAGwAeQAgAGYAbwByAGMAZQAgAHIAZQBwAGEAaQByACAAbwBmACAAcwBpAG4AZwBsAGUAIABtAGQAIABzAHQAcgBpAHAAZQAgAHcALwBvACAAaAB1AHIAdABpAG4AZwAgAGQAYQB0AGEAIABpAG4AdABlAGcAcgBpAHQAeQAgAG8AZgAgAGYAaQBsAGUAIABzAHkAcwB0AGUAbQA=
x-cr-puzzleid: {B39F20A9-F604-417D-80AA-2209D967027A}
Content-class: urn:content-classes:message
Subject: Mechanism to safely force repair of single md stripe w/o hurting data integrity of file system
Date: Sat, 17 May 2008 14:10:00 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C6B3E91@34093-C3-EVS3.exchange.rackspace.com>
In-Reply-To: <482EF6A7.2020909@sandeen.net>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Mechanism to safely force repair of single md stripe w/o hurting data integrity of file system
Thread-Index: Aci4MYdPw9tbfNruRViIyv8sCMY+VwAGS7XQ
References: <482DC043.5000307@dgreaves.com> <482DD981.5070004@sandeen.net> <482EEFDA.50101@dgreaves.com> <482EF6A7.2020909@sandeen.net>
From: "David Lethe" <david@santools.com>
To: "LinuxRaid" <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 17 May 2008 19:16:50.0360 (UTC) FILETIME=[8EDAEB80:01C8B852]
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Primary: david@santools.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: david@santools.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 72.32.49.5
X-Note-Reverse-DNS: fe1.exchange.rackspace.com
X-Note-WHTLIST: david@santools.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: 81 82 128 
X-Note: Mail Class: ALLOWEDSENDER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to figure out a mechanism to safely repair a stripe of data
when I know a particular disk has a unrecoverable read error at a
certain physical block (for 2.6 kernels) 

My original plan was to figure out the range of blocks in md device that
utilizes the known bad block and force a raw read on physical device
that covers the entire chunk and let the md driver do all of the work.  

Well, this didn't pan out. Problems include issues where if bad block
maps to the parity block in a stripe then md won't necessarily
read/verify parity, and in cases where you are running RAID1, then load
balancing might result in the kernel reading the bad block from the good
disk.

So the degree of difficulty is much higher than I expected.  I prefer
not to patch kernels due to maintenance issues as well as desire for the
technique to work across numerous kernels and  patch revisions, and
frankly, the odds are I would screw it up.  An application-level program
that can be invoked as necessary would be ideal.

As such, anybody up to the challenge of writing the code?  I want it
enough to paypal somebody $500 who can write it, and will gladly open
source the solution.  

(And to clarify why, I know physical block x on disk y is bad before the
O/S reads the block, and just want to rebuild the stripe, not the entire
md device when this happens. I must not compromise any file system data,
cached or non-cached that is built on the md device.  I have system with
>100TB and if I did a rebuild every time I discovered a bad block
somewhere, then a full parity repair would never complete before another
physical bad block is discovered.)

Contact me offline for the financial details, but I would certainly
appreciate some thread discussion on an appropriate architecture.  At
least it is my opinion that such capability should eventually be native
Linux, but as long as there is a program that can be run on demand that
doesn't require rebuilding or patching kernels then that is all I need.

David @ santools.com


 

