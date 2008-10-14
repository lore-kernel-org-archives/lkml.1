Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbYJNItv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbYJNItv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYJNItm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:49:42 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:53124 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752706AbYJNItl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:49:41 -0400
Date: Tue, 14 Oct 2008 10:48:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Alan Jenkins <aj504@student.cs.york.ac.uk>
Cc: jeff@garzik.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: QUEUE_FLAG_NONROT
Message-ID: <20081014084858.GZ19428@kernel.dk>
References: <20081014095017.265faf37@mjolnir.drzeus.cx> <20081014075407.GU19428@kernel.dk> <48F4539A.5000102@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F4539A.5000102@tuffmail.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14 2008, Alan Jenkins wrote:
> Jens Axboe wrote:
> > On Tue, Oct 14 2008, Pierre Ossman wrote:
> >> Hi Jeff,
> >>
> >> I noticed you've added a new flag to indicate that the drive has no
> >> seek costs and I figured it would be a good idea to use that on the
> >> MMC/SD cards.
> > 
> > That was me, actually...
> > 
> >> Since the name isn't entirely clear in what is implied, I just wanted
> >> to check that there are no plans to assume that there is negligable
> >> request overhead for queues with this flag. I.e. the flag should
> >> indicate that the elevator doesn't have to care about seeks, but it
> >> should still try to merge requests to reduce the transaction overhead.
> > 
> > Sounds about right. The flag is just meant to indicate zero-seek cost,
> > as devices will still have per-command overheads, merging is still
> > applicable.
> > 
> > So yes, you want to set that flag for mmc/sd cards, definitely.
> 
> Is there a way for users to get / set it manually?  Can hdparm /
> sdparm / sg_inq tell me whether my device sets the flag... I think you
> said it was word 0x217 in a recent draft, but I don't know how I could
> query that as a user.

It's word 217, not 0x217 (there aren't that many words :-)
hdparm can tell you full ID page, use hdparm --Istdout /dev/sdX to
retrieve it.

> I'd like to know whether the SSD in my netbook provides the right flag
> - and if not, set it manually, instead of having to force the noop io
> scheduler.

The flag isn't currently exposed through sysfs, but it does seem like a
good idea to do so.

> It might also be possible to write a udev test program, which would be
> guaranteed exclusive access, to measure seek times and set the flag
> appropriately.  I assume we wouldn't be able to rely on USB flash
> drives having the right flag set.

I'm sure that people would be pissed to have udev seeking all over the
place to determine this, so I think that'd be best deferred to a manual
run of some sort.

-- 
Jens Axboe

