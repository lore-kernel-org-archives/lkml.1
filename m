Return-Path: <linux-kernel-owner+w=401wt.eu-S1758581AbXKLM6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581AbXKLM6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 07:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbXKLM6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 07:58:44 -0500
Received: from web32610.mail.mud.yahoo.com ([68.142.207.237]:43573 "HELO
	web32610.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758260AbXKLM6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 07:58:44 -0500
X-YMail-OSG: tN0d5NkVM1kzmlXJ0ML8Gb_ynNfBMkca7pcz.mq7xpZ8qrm8O2e_P0jQZ5EQQGxg4aGzypcIwt3IHDkrza6JXjoL.GMwDvoe5Oc4
X-Mailer: YahooMailRC/818.27 YahooMailWebService/0.7.152
Date: Mon, 12 Nov 2007 04:58:42 -0800 (PST)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: a.p.zijlstra@chello.nl, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <413167.31385.qm@web32610.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message ----
> From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> To: Martin Knoblauch <knobi@knobisoft.de>
> Cc: a.p.zijlstra@chello.nl; LKML <linux-kernel@vger.kernel.org>
> Sent: Monday, November 12, 2007 1:45:57 AM
> Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
> 
> On Fri, 2007-11-09 at 04:36 -0800, Martin Knoblauch wrote:
> > ----- Original Message ----
> > > From: "Zhang, Yanmin" 
> > > To: a.p.zijlstra@chello.nl
> > > Cc: LKML 
> > > Sent: Friday, November 9, 2007 10:47:52 AM
> > > Subject: iozone write 50% regression in kernel 2.6.24-rc1
> > > 
> > > Comparing with 2.6.23, iozone sequential write/rewrite (512M) has
> > > 50%
> > > 
> >  regression
> > > in kernel 2.6.24-rc1. 2.6.24-rc2 has the same regression.
> > > 
> > > My machine has 8 processor cores and 8GB memory.
> > > 
> > > By bisect, I located patch
> >
> >
> 
 http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h
> =
> > > 04fbfdc14e5f48463820d6b9807daa5e9c92c51f.
> > > 
> > > 
> > > Another behavior: with kernel 2.6.23, if I run iozone for many
> > > times
> > > 
> >  after rebooting machine,
> > > the result looks stable. But with 2.6.24-rc1, the first run of
> > > iozone
> > > 
> >  got a very small result and
> > > following run has 4Xorig_result.
> > > 
> > > What I reported is the regression of 2nd/3rd run, because first run
> > > has
> > > 
> >  bigger regression.
> > > 
> > > I also tried to change
> > > /proc/sys/vm/dirty_ratio,dirty_backgroud_ratio
> > > 
> >  and didn't get improvement.
> >  could you tell us the exact iozone command you are using?
> iozone -i 0 -r 4k -s 512m
> 

 OK, I definitely do not see the reported effect.  On a HP Proliant with a RAID5 on CCISS I get:

2.6.19.2: 654-738 MB/sec write, 1126-1154 MB/sec rewrite
2.6.24-rc2: 772-820 MB/sec write, 1495-1539 MB/sec rewrite

 The first run is always slowest, all subsequent runs are faster and the same speed.

> 
> >  I would like to repeat it on my setup, because I definitely see
> the
> 
 opposite behaviour in 2.6.24-rc1/rc2. The speed there is much
> better
> 
 than in 2.6.22 and before (I skipped 2.6.23, because I was waiting
> for
> 
 the per-bdi changes). I definitely do not see the difference between
> 1st
> 
 and subsequent runs. But then, I do my tests with 5GB file sizes like:
> > 
> > iozone3_283/src/current/iozone -t 5 -F /scratch/X1
> /scratch/X2
> 
 /scratch/X3 /scratch/X4 /scratch/X5 -s 5000M -r 1024 -c -e -i 0 -i 1
> My machine uses SATA (AHCI) disk.
> 

 4x72GB SCSI disks building a RAID5 on a CCISS controller with battery backed write cache. Systems are 2 CPUs (64-bit) with 8 GB memory. I could test on some IBM boxes (2x dual core, 8 GB) with RAID5 on "aacraid", but I need some time to free up one of the boxes.

Cheers
Martin



