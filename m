Return-Path: <linux-kernel-owner+w=401wt.eu-S1758413AbYEBDdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758413AbYEBDdU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 23:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754644AbYEBDdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 23:33:08 -0400
Received: from server515a.exghost.com ([72.32.253.70]:3732 "EHLO
	server515.appriver.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754462AbYEBDdH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 23:33:07 -0400
X-Greylist: delayed 3601 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2008 23:33:07 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Sharing disks amoung multiple software RAIDs
Date: Thu, 1 May 2008 21:31:07 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com>
In-Reply-To: <73000.21239.qm@web50212.mail.re2.yahoo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Sharing disks amoung multiple software RAIDs
Thread-Index: Acir+BNXGn1SsWfjRV+HUnqo86X/YAAAKOPg
References: <1209692359.16523.2.camel@localhost> <73000.21239.qm@web50212.mail.re2.yahoo.com>
From: "David Lethe" <david@santools.com>
To: <alex14641@yahoo.com>, "Justin Piszcz" <jpiszcz@lucidpixels.com>,
       "Kasper Sandberg" <lkml@metanurb.dk>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 May 2008 02:33:02.0544 (UTC) FILETIME=[D8154500:01C8ABFC]
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

In a perfect world, my expectation is that sharing a disk is safe and
even a reasonable thing to do. The shared disk is effectively a range of
addressable blocks in the same way an individual disk or even a hardware
RAID LUN is a range of blocks. From this limited perspective, the only
penalty is performance related, assuming you don't mind having to
explain yourself to an IT supervisor somewhere in your company.

However, consider what COULD happen in event of a drive failure, either
with the shared or an unshared disk. What are the odds all of the
failure scenarios have been tested for all ATA and SCSI command sets;
with threaded I/Os pending; with dirty cache; bus resets when hardware
dies; etc... ?

The odds are zero.  Look how many problems people post to the thread on
a weekly basis where people lose their data when md rebuilds go bad with
non-shared disks.  Why make the problem worse?

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Alex Davis
Sent: Thursday, May 01, 2008 8:52 PM
To: Justin Piszcz; Kasper Sandberg
Cc: linux-raid@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: Sharing disks amoung multiple software RAIDs

--- On Thu, 5/1/08, Kasper Sandberg <lkml@metanurb.dk> wrote:

> From: Kasper Sandberg <lkml@metanurb.dk>
> Subject: Re: Sharing disks amoung multiple software RAIDs
> To: "Justin Piszcz" <jpiszcz@lucidpixels.com>
> Cc: "Alex Davis" <alex14641@yahoo.com>, linux-raid@vger.kernel.org,
linux-kernel@vger.kernel.org
> Date: Thursday, May 1, 2008, 9:39 PM
> On Thu, 2008-05-01 at 08:50 -0400, Justin Piszcz wrote:
> > 
> > On Thu, 1 May 2008, Alex Davis wrote:
> > 
> > > Is this a bad thing? I'm guessing that it is,
> but I want independent
> > > confirmation before I spoke to someone I know
> who's doing this.
> > >
> > > Thanks
> > >
> > >
> > >     
>
________________________________________________________________________
____________
> > > Be a better friend, newshound, and
> > > know-it-all with Yahoo! Mobile.  Try it now. 
> http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
> > > --
> > > To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> > > the body of a message to
> majordomo@vger.kernel.org
> > > More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> > >
> > 
> > What is the use case, why would you want to do that?
> > I have seen people on the list do it before, for
> example are you going to 
> > be utilizing both raids at the same time?  If so, I
> would advise against 
> > it.
> > 
> > What is the reasoning?
> 
> I do this!
> 
> is this really bad? i would surely like a list of reasons
> why..
> 
> I do it because.. well.. first off, it allows me to have
> /boot on
> different raidlevel than / or /home without extra disks.
> secondly, it allows me to with the same disks use different
> filesystems.. for instance, it allows me to have /home
> encrypted with
> dm-crypt, while still raided.. Not that i would mind
> encrypting /
> and /home as 1 partition, but it creates a whole slew of
> issues with
> having to create initrd and stuff..
> 
> I realize that performance probably suffers abit from this,
> but well..
> is there any stability or security wise risk? i mostly use
> raid1 and
> raid5 only..
> 
I would guess if the RAIDs are heavily used simultaneously it could
cause the disk head actuators to jump around more, causing more wear
and tear.


 
________________________________________________________________________
____________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.
http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


