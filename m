Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbXFLKd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbXFLKd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 06:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752501AbXFLKdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 06:33:49 -0400
Received: from mail36.syd.optusnet.com.au ([211.29.133.76]:48775 "EHLO
	mail36.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbXFLKds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 06:33:48 -0400
From: Con Kolivas <kernel@kolivas.org>
To: ck@vds.kolivas.org
Subject: Re: call for more SD versus CFS comparisons (was: Re: [ck]  Mainline plans)
Date: Tue, 12 Jun 2007 20:33:32 +1000
User-Agent: KMail/1.9.5
Cc: Ingo Molnar <mingo@elte.hu>, Tobias Gerschner <tobias.gerschner@gmail.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
References: <466DE921.9030709@debianpt.org> <20070612083620.GA10557@elte.hu> <20070612085730.GA17964@elte.hu>
In-Reply-To: <20070612085730.GA17964@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706122033.32883.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2007 18:57, Ingo Molnar wrote:
> * Ingo Molnar <mingo@elte.hu> wrote:
> > * Tobias Gerschner <tobias.gerschner@gmail.com> wrote:
> > > I did run massive_intr.c for 60 secs with increasing nproc (
> > > 10,20,30,40,50,60) waiting for effects.
> > >
> > > Below a small table of the results

Nice results. Thanks for taking the time to post them!

> > >
> > > 2.6.21.1-cfs-v16
> > >
> > > nproc ,  usability result
> > >
> > > 10 , serious frame drops , Firefox  hardly recognizes clicked links,
> > > but still usable
> > > 20 - 30, usability loss ( somehow under cfs firefox never finished
> > > user requests like displaying web pages or opening new pages , no
> > > feedback anymore, sudden changes on the desktop )
> >
> > ouch! The expected load-testing result under CFS should be something
> > like this:
> >
> >    http://bhhdoa.org.au/pipermail/ck/2007-June/007817.html
>
> i have just tried the same workload with cfs and with sd048 from -ck,
> and cannot reproduce this. To make sure it's not some other change in
> -ck, could you try the pure SD patches ontop of 2.6.21.1 too:

I'm pleased you think the rest of my patches may help there but only the SD 
patches affect scheduling unless you set a different scheduling policy or 
there is a vm issue.

List:
ck2-version.patch
2.6.21-sd-0.48.patch
sched-sd-0.48-interactive_tunable.patch
sched-range.patch
sched-iso-5.4.patch
track_mutexes-1.patch
sched-idleprio-2.3.patch
sched-limit_policy_changes.patch
sched-ck-add-above-background-load-function.patch
cfq-ioprio_inherit_rt_class.patch
cfq-iso_idleprio_ionice.patch
mm-swap_prefetch-35.patch 
mm-convert_swappiness_to_mapped.patch 
mm-lots_watermark.diff
mm-kswapd_inherit_prio-1.patch 
mm-prio_dependant_scan-2.patch
mm-background_scan-2.patch
mm-filesize_dependant_lru_cache_add.patch
mm-idleprio_prio.patch
kconfig-expose_vmsplit_option.patch
hz-default_1000.patch 
hz-no_default_250.patch 
hz-raise_max-2.patch
ck-desktop-tune.patch
mm-swap-prefetch-35-38.patch

apart from ck-desktop-tune.patch which is in total this:
-int rr_interval __read_mostly = 8;
+int rr_interval __read_mostly = 6;

which is already a tunable that's part of SD.

So unless there's a vm issue (which does not appear to be the case) I can't 
see how any of these will change Tobias' extensive testing results.

Thanks.

-- 
-ck
