Return-Path: <linux-kernel-owner+w=401wt.eu-S1754694AbXDZDaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694AbXDZDaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 23:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754696AbXDZDaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 23:30:00 -0400
Received: from mail.suse.de ([195.135.220.2]:57968 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754694AbXDZD36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 23:29:58 -0400
Date: Thu, 26 Apr 2007 05:29:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
Subject: Re: [patch] CFS scheduler, -v6
Message-ID: <20070426032923.GB1548@wotan.suse.de>
References: <20070425214704.GA32572@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070425214704.GA32572@elte.hu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 11:47:04PM +0200, Ingo Molnar wrote:
> 
> i'm pleased to announce release -v6 of the CFS scheduler patchset. The 
> main goal of CFS is to implement "high quality desktop scheduling" as 
> well as technically possible.
> 
> The CFS patch against v2.6.21-rc7 or against v2.6.20.7 can be downloaded 
> from the usual place:
> 
>     http://redhat.com/~mingo/cfs-scheduler/
> 
> i got lots of -v5 feedback (thanks and please keep the reports coming!) 
> so the -v6 release includes many bugfixes and improvements:
> 
>     19 files changed, 317 insertions(+), 744 deletions(-)
> 
> the biggest user-visible changes in -v6 are various refinements to the 
> precise-scheduling infrastructure that should result in generally better 
> interactivity and a smoother desktop. In particular a number of "movie 
> playback lags/stutters" and "firefox lags under load" type of 
> regressions have been resolved. (Please re-report any regression that 
> might not be fixed yet.)
> 
> Changes since -v5:
> 
>  - feature: increase the preemption granularity value on SMP systems. 
>    Idea and code comes from the SD scheduler of Con Kolivas, with Con's
>    kind permission. (thanks Con!)
> 
>  - fix: the "privileged_nice_level=X" boot option should convert signed
>    integers. (Mike Galbraith)
> 
>  - build fix: yield_to unistd.h fix (Srivatsa Vaddagiri)
> 
>  - build fix: CONFIG_HEADERS_CHECK complained about sched.h.
>    (reported by Zach Carter)
> 
>  - build fix: normalize_rt_tasks() UP build fix. (Mike Galbraith)
> 
>  - interactivity fix: sched_clock() accuracy fixes. This should resolve 
>    certain types of interactivity regressions reported on systems that
>    change their CPU frequencies. (mainly laptops)
> 
>  - default settings tweak: changed the X renicing default from -19 to 
>    -10, based on tester feedback. (Might still be too much - more 
>    feedback is needed.)
> 
>  - feature: introduced "wakeup granularity" and added the 
>    /proc/sys/kernel/sched_wakeup_granularity_ns tunable, set to 0 by 
>    default for now. This is now distinct from the sched_granularity_ns
>    'preemption granularity' property of the scheduler - allowing a
>    more agressive increase in the preemption granularity without
>    jeopardizing interactivity.
> 
>  - debugging feature: SysRq-T now also shows the /proc/sched_debug 
>    output - useful to generate a dump of all relevant scheduler state in 
>    one easy step.
> 
>  - debugging feature: make SysRq-Nice normalize negative nice level 
>    tasks too and reset the CFS state.
> 
>  - debugging: extend /proc/sched_debug with a few more clock related 
>    fields, to be able to better debug problems caused by unstable 
>    clocks.
> 
>  - upstream fix: SysRq-T should show runnable tasks

BTW. can you send this upstream? It is very annoying how it currently works,
and I've had more than one bug that required seeing runnable tasks in order
to diagnose and fix...
