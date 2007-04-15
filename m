Return-Path: <linux-kernel-owner+w=401wt.eu-S1751130AbXDOG15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130AbXDOG15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 02:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbXDOG14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 02:27:56 -0400
Received: from [212.12.190.101] ([212.12.190.101]:32812 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751130AbXDOG14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 02:27:56 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
Date: Sun, 15 Apr 2007 09:31:42 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704150931.42268.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III wrote:
> On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
> > [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler
> > [CFS] i'm pleased to announce the first release of the "Modular
> > Scheduler Core and Completely Fair Scheduler [CFS]" patchset:
> >    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
> > This project is a complete rewrite of the Linux task scheduler. My goal
> > is to address various feature requests and to fix deficiencies in the
> > vanilla scheduler that were suggested/found in the past few years, both
> > for desktop scheduling and for server scheduling workloads.
> > [ QuickStart: apply the patch to v2.6.21-rc6, recompile, reboot. The
> >   new scheduler will be active by default and all tasks will default
> >   to the new SCHED_FAIR interactive scheduling class. ]
>
> A pleasant surprise, though I did see it coming.

Same here, but I didn't expect it so soon.  Thanks!

> >    The CFS patch uses a completely different approach and implementation
> >    from RSDL/SD. My goal was to make CFS's interactivity quality exceed
> >    that of RSDL/SD, which is a high standard to meet :-) Testing
> >    feedback is welcome to decide this one way or another.

I slammed this patch on 2.6.20.6 with some ugly rejects but it did compile, 
then tested, so my results may be affected by the rejects.

Boot into /bin/sh.
Run chew.c on three different VT's with different nice each.  Observe.

Console 1:
pid 615, prio  19, out for   19 ms, ran for    0 ms, load   4%
pid 615, prio  19, out for   19 ms, ran for    0 ms, load   4%
pid 615, prio  19, out for   19 ms, ran for    0 ms, load   4%
pid 615, prio  19, out for   19 ms, ran for    0 ms, load   4%
pid 615, prio  19, out for   77 ms, ran for    0 ms, load   1%
pid 615, prio  19, out for  125 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for  209 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for  346 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for  552 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for  882 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for 1231 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for 1335 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for 1218 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for 1254 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for 1774 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for 1946 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for 1942 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for 2749 ms, ran for    0 ms, load   0%
pid 615, prio  19, out for 3217 ms, ran for    0 ms, load   0%

Console 2:
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  26%
pid 616, prio   0, out for    9 ms, ran for    2 ms, load  24%
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  26%
pid 616, prio   0, out for    9 ms, ran for    2 ms, load  24%
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  26%
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  26%
pid 616, prio   0, out for    9 ms, ran for    2 ms, load  24%
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  26%
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  24%
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  26%
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  26%
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  24%
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  26%
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  24%
pid 616, prio   0, out for    7 ms, ran for    2 ms, load  26%
pid 616, prio   0, out for    8 ms, ran for    2 ms, load  26%
pid 616, prio   0, out for    9 ms, ran for    2 ms, load  24%
pid 616, prio   0, out for    5 ms, ran for    2 ms, load  26%

Console 3:
pid 617, prio -10, out for    3 ms, ran for    8 ms, load  74%
pid 617, prio -10, out for    3 ms, ran for    7 ms, load  72%
pid 617, prio -10, out for    3 ms, ran for    7 ms, load  72%
pid 617, prio -10, out for    3 ms, ran for    8 ms, load  74%
pid 617, prio -10, out for    3 ms, ran for    7 ms, load  72%
pid 617, prio -10, out for    3 ms, ran for    8 ms, load  74%
pid 617, prio -10, out for    3 ms, ran for    7 ms, load  72%
pid 617, prio -10, out for    3 ms, ran for    7 ms, load  72%
pid 617, prio -10, out for    3 ms, ran for    8 ms, load  74%
pid 617, prio -10, out for    3 ms, ran for    7 ms, load  72%
pid 617, prio -10, out for    3 ms, ran for    8 ms, load  74%
pid 617, prio -10, out for    3 ms, ran for    7 ms, load  72%
pid 617, prio -10, out for    3 ms, ran for    7 ms, load  72%
pid 617, prio -10, out for    3 ms, ran for    8 ms, load  74%
pid 617, prio -10, out for    3 ms, ran for    7 ms, load  72%
pid 617, prio -10, out for    3 ms, ran for    8 ms, load  74%
pid 617, prio -10, out for    3 ms, ran for    7 ms, load  72%
pid 617, prio -10, out for    3 ms, ran for    7 ms, load  72%

It looks like negative nice affects positive nice adversely.

> >    CFS's design is quite radical: it does not use runqueues, it uses a
> >    time-ordered rbtree to build a 'timeline' of future task execution,
> >    and thus has no 'array switch' artifacts (by which both the vanilla
> >    scheduler and RSDL/SD are affected).

Sounds interresting, but it looks like CPU-bound procs easily steal sleeping 
proc timeslices, thus making it rather unfair, affecting interactivity.

The latencies look great, though.

Also, it may be useful to lower-bound timeslices, as they become ridiculously 
small ( < 1ms ).


Thanks!

--
Al

