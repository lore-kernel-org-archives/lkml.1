Return-Path: <linux-kernel-owner+w=401wt.eu-S936315AbYEBWZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936315AbYEBWZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 18:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757175AbYEBWZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 18:25:39 -0400
Received: from server515i.exghost.com ([72.32.253.75]:1246 "EHLO
	server515.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755780AbYEBWZi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 18:25:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Subject: RE: Sharing disks amoung multiple software RAIDs
Date: Fri, 2 May 2008 17:24:22 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C335960@34093-C3-EVS3.exchange.rackspace.com>
In-Reply-To: <1209764630.7827.15.camel@localhost>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Sharing disks amoung multiple software RAIDs
Thread-Index: AcisnaXkU6uk9DHZRxCM2vSQRIY1igAAPS6A
References: <1209692359.16523.2.camel@localhost> <73000.21239.qm@web50212.mail.re2.yahoo.com> <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com> <1209696179.16523.13.camel@localhost> <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com> <1209715763.7827.2.camel@localhost>  <481AD006.6050708@dgreaves.com> <1209764630.7827.15.camel@localhost>
From: "David Lethe" <david@santools.com>
To: "Kasper Sandberg" <lkml@metanurb.dk>, "David Greaves" <david@dgreaves.com>
Cc: "David Rees" <drees76@gmail.com>, <alex14641@yahoo.com>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>, <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 May 2008 22:25:17.0232 (UTC) FILETIME=[66146B00:01C8ACA3]
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Policy: GLOBAL
X-Primary: david@santools.com
X-Note: This Email was scanned by AppRiver SecureTide
X-ALLOW: david@santools.com ALLOWED
X-Virus-Scan: V-
X-Note: Spam Tests Failed: 
X-Country-Path: PRIVATE->UNITED STATES->UNITED STATES
X-Note-Sending-IP: 72.32.49.6
X-Note-Reverse-DNS: fe2.exchange.rackspace.com
X-Note-WHTLIST: david@santools.com
X-Note: User Rule Hits: 
X-Note: Global Rule Hits: 92 93 139 
X-Note: Mail Class: ALLOWEDSENDER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Kasper Sandberg [mailto:lkml@metanurb.dk] 
Sent: Friday, May 02, 2008 4:44 PM
To: David Greaves
Cc: David Rees; David Lethe; alex14641@yahoo.com; Justin Piszcz; linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: Sharing disks amoung multiple software RAIDs

On Fri, 2008-05-02 at 09:25 +0100, David Greaves wrote:
> Kasper Sandberg wrote:
> > Im not treating it as a backup, what i want, is to make sure that if 1
> > disk dies, the data is still intact and ill hopefully be able to run
> > with 1 disk till the newly ordered one arrives
> Probably one of the main design objectives behind RAID/md

Exactly, but once people start saying: "Look how many problems people
post to the thread on
a weekly basis where people lose their data when md rebuilds go bad with
non-shared disks" i begin to worry..

> 
> > So my question remains.. Is md raid1 not suited for this need? would it
> > be safer to run in non-raid1 mode and daily(maybe hourly) rsync
> > everything over to the second disk?
> 
> md is 100% guaranteed perfect or your money back...
> rsync is 100% guaranteed perfect or your money back...
> your backups are 100% guaranteed perfect or your money back...
> your hard drives are 100% guaranteed perfect or your money back...
> your CPU and RAM are 100% guaranteed perfect or your money back...
> your CPU and PSU fans are 100% guaranteed perfect or your money back...
> 
> Clearly if you want to panic over reliability you have lots of choices :)

I do not wish to panic, i merely wished to know if linux MD is believed
to work in most cases, or believed to do all sorts of weird stuff when
resyncing :)

> 
> David
> PS, FWIW md has saved my data* countless times over the past 'n' years in
> exactly the scenario you describe.

It has also been useful to people i know, i just wished to be sure :)
and as Keld Jørn Simonsen and Helge Hafting's comments seems to confirm,
linux md IS nice and stable :)

and as said, what im looking for isnt an in-box backup solution, merely
safety in case one disk burns :)

> 
> *(or more accurately has saved me from having to restore my data)
=======================
Since I am the person that wrote that "Look how many problems people
post to the thread on a weekly basis where people lose their data when md rebuilds go bad with
non-shared disks", I think need to clarify.
 
I was being too literal. md is a good solution (I use it myself).  However, the OP wanted to "Make sure that if one disk dies, the data is still in tact".  

Only way to do that is have a good offsite backup.

Nothing can prevent opportunity for data loss.  I don't care what RAID level (with single redundancy) you use or whether you have software or hardware-based RAID .. rebuilds can not reconstruct data if you are in degraded mode and have an unrecoverable read error on surviving disks.  It is not md's job or design point to insure data consistency check/repairs are run 24x7.  As such, by definition, there is no way to insure that a md rebuild will always be successful.

David
---------





