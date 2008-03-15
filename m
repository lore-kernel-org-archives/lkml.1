Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbYCOVzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbYCOVzM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 17:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYCOVy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 17:54:58 -0400
Received: from 1wt.eu ([62.212.114.60]:2484 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbYCOVy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 17:54:57 -0400
Date: Sat, 15 Mar 2008 22:54:27 +0100
From: Willy Tarreau <w@1wt.eu>
To: Daniel Phillips <phillips@phunq.net>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Message-ID: <20080315215427.GC13012@1wt.eu>
References: <200803092346.17556.phillips@phunq.net> <200803131214.40321.phillips@phunq.net> <20080315205950.GA13012@1wt.eu> <200803151417.13899.phillips@phunq.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803151417.13899.phillips@phunq.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2008 at 01:17:13PM -0800, Daniel Phillips wrote:
> On Saturday 15 March 2008 13:59, Willy Tarreau wrote:
> > On Thu, Mar 13, 2008 at 11:14:39AM -0800, Daniel Phillips wrote:
> > > On Thursday 13 March 2008 06:22, Alan Cox wrote:
> > > > ...Ext3 cannot recover well from massive loss of intermediate
> > > > writes. It isn't a normal failure mode and there isn't sufficient fs
> > > > metadata robustness for this. A log structured backing store would deal
> > > > with that but all you apparently want to do is scream FUD at anyone who
> > > > doesn't agree with you.
> > > 
> > > Scream is an exaggeration, and FUD only applies to somebody who
> > > consistently overlooks the primary proposition in this design: that the
> > > battery backed power supply, computer hardware and Linux are reliable
> > > enough to entrust your data to them.  I say this is practical, you say
> > > it is impossible, I say FUD.
> > > 
> > > All you are proposing is that nobody can entrust their data to any
> > > hardware.  Good point.  There is no absolute reliability, only degrees
> > > of it.
> > > 
> > > Many raid controllers now have battery backed writeback cache, which
> > > is exactly the same reliability proposition as ramback, on a smaller
> > > scale.  Do you refuse to entrust your corporate data to such
> > > controllers?
> > 
> > RAID controllers do not have half a terabyte of RAM.
> 
> And?  Either you have battery backed ram with critical data in it or
> you do not.  Exactly how much makes little difference to the question.

It completely changes the method to power it and the time the data may
remain in RAM. The Smart 3200 I have right here simply has lithium
batteries directly connected to the static RAM chips. Very low risk of
power failure. The way your presented your work shows it rely on a UPS
to sustain the PC's power supply, which it turn maintains the PC alive,
which in turn tries not to reboot to keep its RAM consistent. There are
a lot of reasons here to get a failure.

Don't get me wrong, I still think your project has a lot of usages. But
you have to admit that there are huge differences between using it in
an appliance with battery-backed RAM which is able to recover data after
a system crash, power outage or anything, and the average Joe's PC setup
as an NFS server for the company with a cheap UPS to try not to lose the
data should a power outage occur.

I think it could get major adoption with ordered writes.

> > Also, you are always 
> > invited to choose between speed (write back) and reliability (write through).
> 
> As is the case with ramback.  Just echo 1 >/proc/driver/ramback/<name>.
> 
> > Also, please note that the problem here is not related to the number of
> > nines of availability. This number only counts the ratio between uptime
> > and downtime. We're more facing a problem of MTBF, where the consequences
> > of a failure are hard to predict.
> 
> That is why I keep recommending that a ramback setup be replicated or
> mirrored, which people in this thread keep glossing over.  When
> replicated or mirrored, you still get the microsecond-level transaction
> times, and you get the safety too.

I agree, but in this case, you should present it this way. You have been
insisting too much on the average PC's reliability, the fact that no kernel
ever crashed for you, etc... So you are demonstrating that your product is
good provided that everything goes perfectly. All people who have experienced
software or hardware problems in the past (ie mostly everyone here) will not
trust your code because it relies on pre-requisites they know they do not
have.

> Then there is a big class of applications where the data on the ramdisk
> can be reconstructed, it is just a pain and reduces uptime.  These are
> potential ramback users, and in fact I will be one of those, using it
> on my kernel hacking partition.
> 
> > What I'm thinking about is that considering the fact that storage
> > technologies are moving towards SSD (and I think 2008 will be the
> > year of SSD), you should implement ordered writes (I've not said
> > write through) since there's no seek time on those devices. Thus
> > you will have the speed of RAM with the reliability of a properly
> > synced FS. If your system crashes once a week, it will not be a
> > problem anymore.
> 
> There will be a whole bunch of patches from me that are SSD oriented,
> over time.  The fact is, enterprise scale ramdisks are here now, while
> enterprise scale flash is not.  Getting close, but not here.  And flash
> does not approach the write performance of RAM, not now and probably
> not ever.

My goal is not to replace RAM with flash, but disk with flash. You are
against ordered writes for a performance reason. Use SSD instead of
hard drives and it will be as fast as sequential writes. Also, when
you say that enterprise scale flash is not there, I don't agree. You
can already afford hundreds of gigs of flash in 3,5" form factor. An
1.6 TB SSD has even been presented at CES2008, with sales announced
for Q3. So clearly this will replace your hard drives soon, very soon.
Even if it costs $5k, that's a very acceptable solution to replace a
disk in a RAM-speed appliance.

Willy

