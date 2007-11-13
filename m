Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbXKMCF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbXKMCF1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 21:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbXKMCFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 21:05:16 -0500
Received: from mga10.intel.com ([192.55.52.92]:48254 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751457AbXKMCFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 21:05:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,408,1188802800"; 
   d="scan'208";a="202079784"
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: a.p.zijlstra@chello.nl, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <413167.31385.qm@web32610.mail.mud.yahoo.com>
References: <413167.31385.qm@web32610.mail.mud.yahoo.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 13 Nov 2007 10:04:01 +0800
Message-Id: <1194919441.20251.147.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-12 at 04:58 -0800, Martin Knoblauch wrote:
> ----- Original Message ----
> > From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
> > To: Martin Knoblauch <knobi@knobisoft.de>
> > Cc: a.p.zijlstra@chello.nl; LKML <linux-kernel@vger.kernel.org>
> > Sent: Monday, November 12, 2007 1:45:57 AM
> > Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
> > 
> > On Fri, 2007-11-09 at 04:36 -0800, Martin Knoblauch wrote:
> > > ----- Original Message ----
> > > > From: "Zhang, Yanmin" 
> > > > To: a.p.zijlstra@chello.nl
> > > > Cc: LKML 
> > > > Sent: Friday, November 9, 2007 10:47:52 AM
> > > > Subject: iozone write 50% regression in kernel 2.6.24-rc1
> > > > 
> > > > Comparing with 2.6.23, iozone sequential write/rewrite (512M) has
> > > > 50%
> > > > 
> > >  regression
> > > > in kernel 2.6.24-rc1. 2.6.24-rc2 has the same regression.
> > > > 
> > > > My machine has 8 processor cores and 8GB memory.
> > > > 
> > > > By bisect, I located patch
> > >
> > >
> > 
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h
> > =
> > > > 04fbfdc14e5f48463820d6b9807daa5e9c92c51f.
> > > > 
> > > > 
> > > > Another behavior: with kernel 2.6.23, if I run iozone for many
> > > > times
> > > > 
> > >  after rebooting machine,
> > > > the result looks stable. But with 2.6.24-rc1, the first run of
> > > > iozone
> > > > 
> > >  got a very small result and
> > > > following run has 4Xorig_result.
> > > > 
> > > > What I reported is the regression of 2nd/3rd run, because first run
> > > > has
> > > > 
> > >  bigger regression.
> > > > 
> > > > I also tried to change
> > > > /proc/sys/vm/dirty_ratio,dirty_backgroud_ratio
> > > > 
> > >  and didn't get improvement.
> > >  could you tell us the exact iozone command you are using?
> > iozone -i 0 -r 4k -s 512m
> > 
> 
>  OK, I definitely do not see the reported effect.  On a HP Proliant with a RAID5 on CCISS I get:
> 
> 2.6.19.2: 654-738 MB/sec write, 1126-1154 MB/sec rewrite
> 2.6.24-rc2: 772-820 MB/sec write, 1495-1539 MB/sec rewrite
> 
>  The first run is always slowest, all subsequent runs are faster and the same speed.
Although the first run is always slowest, but if we compare 2.6.23 and 2.6.24-rc,
we could find the first run result of 2.6.23 is 7 times of the one of 2.6.24-rc.

Originally, my test suite is just to pick up the result of first run. I might
change my test suite to make it run for many times.

Now I run the the test manually for many times after machine reboots. Comparing 2.6.24-rc
with 2.6.23, 3rd and following run of 2.6.24-rc has about 50% regression.
