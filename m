Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbXFVXIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbXFVXIn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbXFVXIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:08:36 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:57602 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbXFVXIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:08:35 -0400
Date: Fri, 22 Jun 2007 19:08:04 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: [patch] CFS scheduler, -v18
In-reply-to: <20070622220202.GA16872@elte.hu>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Message-id: <200706221908.05460.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <20070622220202.GA16872@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 June 2007, Ingo Molnar wrote:
>i'm pleased to announce release -v18 of the CFS scheduler patchset.
>
>The rolled-up CFS patch against today's -git kernel, v2.6.22-rc5,
>v2.6.22-rc4-mm2, v2.6.21.5 or v2.6.20.14 can be downloaded from the
>usual place:
>
>   http://people.redhat.com/mingo/cfs-scheduler/
>
>The biggest change in -v18 are various performance related improvements.
>Thomas Gleixner has eliminated expensive 64-bit divisions by converting
>the arithmetics to scaled math (without impacting the quality of
>calculations). Srivatsa Vaddagiri and Dmitry Adamushko have continued
>the abstraction and cleanup work. Srivatsa Vaddagiri and Christoph
>Lameter fixed the NUMA balancing bug reported by Paul McKenney. There
>were also a good number of other refinements to the CFS code. (No
>reproducible behavioral regressions were reported against -v17 so far,
>so the 'behavioral' bits are mostly unchanged.)
>
>Changes since -v17:
>
> - implement scaled math speedups for CFS. (Thomas Gleixner)
>
> - lots of core code updates, cleanups and streamlining.
>   (Srivatsa Vaddagiri, Dmitry Adamushko, me.)
>
> - bugfix: fix NUMA balancing. (Srivatsa Vaddagiri, Christoph Lameter,
>   Paul E. McKenney)
>
> - feature: SCHED_IDLE now also implies block-scheduler (CFQ)
>   idle-IO-priority. (suggested by Thomas Sattler, picked up from -ck)
>
> - build fix for ppc32. (reported, tested and confirmed fixed by
>   Art Haas)
>
> - ARM fix. (reported and debugged by Thomas Gleixner)
>
> - cleanup: implemented idle_sched_class in kernel/sched_idletask.c as a
>   way to separate out rq->idle handling out of the core scheduler. This
>   made a good deal of idle-task related special-cases go away.
>
> - debug: make the sysctls safer by introducing high and low limits.
>
> - cleanup: move some of the debug counters to under CONFIG_SCHEDSTATS.
>
> - speedup: various micro-optimizations
>
> - various other small updates.
>
>As usual, any sort of feedback, bugreport, fix and suggestion is more
>than welcome!
>
Humm, problem methinks.  Applying the patch, with 2.6.22-rc5 applied to 2.6.21 
completed, from my script:

now applying patch sched-cfs-v2.6.22-rc5-v18.patch

patching file Documentation/kernel-parameters.txt
patching file Documentation/sched-design-CFS.txt
patching file Makefile
patching file arch/i386/kernel/smpboot.c
patching file arch/i386/kernel/tsc.c
patching file arch/ia64/kernel/setup.c
patching file arch/mips/kernel/smp.c
patching file arch/sparc/kernel/smp.c
patching file arch/sparc64/kernel/smp.c
patching file block/cfq-iosched.c
patching file fs/proc/array.c
patching file fs/proc/base.c
patching file include/asm-generic/bitops/sched.h
patching file include/linux/hardirq.h
patching file include/linux/sched.h
patching file include/linux/topology.h
patching file init/main.c
patching file kernel/delayacct.c
patching file kernel/exit.c
patching file kernel/fork.c
patching file kernel/posix-cpu-timers.c
patching file kernel/sched.c
patching file kernel/sched_debug.c
patching file kernel/sched_fair.c
patching file kernel/sched_idletask.c
patching file kernel/sched_rt.c
patching file kernel/sched_stats.h
patching file kernel/softirq.c
patching file kernel/sysctl.c
The next patch would delete the file l/kernel/sched.c,
which does not exist!  Assume -R? [n]

How to proceed?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Even more amazing was the realization that God has Internet access.  I
wonder if He has a full newsfeed?
	-- Matt Welsh
