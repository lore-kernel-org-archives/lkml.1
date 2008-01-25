Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbYAYUiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbYAYUiM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 15:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbYAYUh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 15:37:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55189 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbYAYUhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 15:37:55 -0500
Date: Fri, 25 Jan 2008 21:37:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] scheduler changes for v2.6.25
Message-ID: <20080125203740.GA31784@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree for v2.6.25 from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

it contains various enhancements to the scheduler - find the full 
shortlog is below. 96 commits from 19 authors - scheduler developers 
have been busy again. :-/

The scheduling behavior of the kernel to normal users should not change 
over v2.6.24, but there are a good number of new features and 
enhancements under the hood:

 - various instrumentation and debugging enhancements from
   Arjan van de Ven. LatencyTOP support in the scheduler is one
   example.

 - Peter Zijlstra's RT time limit and RT throttling code for the RT 
   scheduling class. Both audio and RT folks have asked for this.

 - Paul E. McKenney's preemptible RCU code.

 - refcount based CPU-hotplug rework by Gautham R Shenoy. (The "Lukewarm
   IQ detected in hotplug locking" printout is now gone, forever i hope! :)

 - there's serious interest in running RT tasks on enterprise-class 
   hardware, so Steven Rostedt and Gregory Haskins wrote a large number 
   of enhancements to the RT scheduling class and load-balancer.

 - Peter Zijlstra's high-resolution scheduler tick code. We still have a
   HZ tick running for a few other odd things, but it's dwindling now.

 - Srivatsa Vaddagiri's next version of group scheduling. More accurate,
   more fair.

 - make printk robust against self-recursion, and use stable
   timestamps for printk-timestamps.

 - the softlockup detector will now detect hung, uninterruptible tasks
   automatically, and report them.

and a good number of other, smaller enhancements. Enjoy,

	Ingo

------------------>
Alexey Dobriyan (1):
      sched, futex: detach sched.h and futex.h

Arjan van de Ven (4):
      debug: show being-loaded/being-unloaded indicator for modules
      debug: track and print last unloaded module in the oops trace
      sched: latencytop support
      sched: keep total / count stats in addition to the max for

Dipankar Sarma (1):
      Preempt-RCU: Use softirq instead of tasklets for

Dmitry Adamushko (3):
      sched: no need for 'affine wakeup' balancing
      sched: get rid of 'new_cpu' in try_to_wake_up()
      sched: fix goto retry in pick_next_task_rt()

Gautham R Shenoy (3):
      cpu-hotplug: refcount based cpu hotplug
      cpu-hotplug: replace lock_cpu_hotplug() with get_online_cpus()
      cpu-hotplug: replace per-subsystem mutexes with get_online_cpus()

Gregory Haskins (15):
      sched: add RT-balance cpu-weight
      sched: clean up this_rq use in kernel/sched_rt.c
      sched: de-SCHED_OTHER-ize the RT path
      sched: break out search for RT tasks
      sched: RT balancing: include current CPU
      sched: pre-route RT tasks on wakeup
      sched: optimize RT affinity
      sched: wake-balance fixes
      sched: break out early if RT task cannot be migrated
      sched: RT-balance, optimize
      sched: add sched-domain roots
      sched: only balance our RT tasks within our domain
      sched: RT-balance, only adjust overload state when changing
      sched: remove some old cpuset logic
      sched: dynamically update the root-domain span/online maps

Guillaume Chazarain (2):
      sched: fix rq->clock warps on frequency changes
      sched: monitor clock underflows in /proc/sched_debug

Herbert Xu (1):
      sched: do not do cond_resched() when CONFIG_PREEMPT

Ingo Molnar (25):
      printk: make printk more robust by not allowing recursion
      sched: fix CONFIG_PRINT_TIME's reliance on sched_clock()
      sched: remove printk_clock()
      sched: remove printk_clock references from ia64
      cpu-hotplug: fix build on !CONFIG_SMP
      softlockup: automatically detect hung TASK_UNINTERRUPTIBLE tasks
      sched: clean up pick_next_highest_task_rt()
      sched: clean up find_lock_lowest_rq()
      sched: clean up overlong line in kernel/sched_debug.c
      sched: clean up kernel/sched_rt.c
      sched: remove rt_overload()
      sched: remove leftover debugging
      sched: clean up pull_rt_task()
      sched: clean up schedule_balance_rt()
      sched: fix sched_rt.c:join/leave_domain
      sched: remove unused JIFFIES_TO_NS() macro
      sched: style cleanup, #2
      sched: add credits for RT balancing improvements
      sched: reactivate fork balancing
      sched: whitespace cleanups in topology.h
      sched: documentation, whitespace fixes
      sched: make PREEMPT_BKL the default
      sched: remove the !PREEMPT_BKL code
      softlockup: fix signedness
      printk: use ktime_get()

Michal Schmidt (1):
      sched: fix, always create kernel threads with normal priority

Mike Galbraith (1):
      sched: pull_rt_task() cleanup

Nick Piggin (1):
      sched: print backtrace of running tasks too

Paolo Ciarrocchi (1):
      debug: clean up kernel/profile.c

Paul E. McKenney (5):
      Preempt-RCU: reorganize RCU code into rcuclassic.c and rcupdate.c
      Preempt-RCU: fix rcu_barrier for preemptive environment.
      Preempt-RCU: implementation
      Preempt-RCU: CPU Hotplug handling
      Preempt-RCU: update RCU Documentation.

Pavel Emelyanov (1):
      uids: merge multiple error paths in alloc_uid() into one

Pavel Machek (1):
      timers: don't #error on higher HZ values

Peter Zijlstra (13):
      sched: remove do_div() from __sched_slice()
      sched: sched_rt_entity
      sched: SCHED_FIFO/SCHED_RR watchdog timer
      sched: high-res preemption tick
      sched: rt time limit
      sched: rt group scheduling
      sched: rt throttling vs no_hz
      hrtimer: clean up cpu->base locking tricks
      hrtimer: fixup the HRTIMER_CB_IRQSAFE_NO_SOFTIRQ fallback
      hrtimer: unlock hrtimer_wakeup
      sched: rt-group: reduce rescheduling
      sched: rt-watchdog: fix .rlim_max = RLIM_INFINITY
      sched: fix: don't take a mutex from interrupt context

Srivatsa Vaddagiri (5):
      sched: group scheduling code cleanup
      sched: group scheduling, minor fixes
      sched: group scheduling, change how cpu load is calculated
      sched: introduce a mutex and corresponding API to serialize access to doms_curarray
      sched: group scheduler, fix fairness of cpu bandwidth allocation for task groups

Steven Rostedt (12):
      sched: count # of queued RT tasks
      sched: track highest prio task queued
      sched: add RT task pushing
      sched: add rt-overload tracking
      sched: pull RT tasks from overloaded runqueues
      sched: push RT tasks from overloaded CPUs
      sched: disable standard balancer for RT tasks
      sched: RT-balance, avoid overloading
      sched: RT-balance, optimize cpu search
      sched: RT-balance on new task
      sched: RT-balance, replace hooks with pre/post schedule and wakeup methods
      sched: RT-balance, add new methods to sched_class

 Documentation/RCU/RTFP.txt                   |  210 +++-
 Documentation/RCU/rcu.txt                    |   19 
 Documentation/RCU/torture.txt                |   11 
 Documentation/cpu-hotplug.txt                |   11 
 arch/arm/kernel/time.c                       |   11 
 arch/ia64/kernel/setup.c                     |    4 
 arch/ia64/kernel/time.c                      |   27 
 arch/ia64/sn/kernel/setup.c                  |   11 
 arch/mips/kernel/mips-mt-fpaff.c             |   10 
 arch/powerpc/platforms/pseries/hotplug-cpu.c |    8 
 arch/powerpc/platforms/pseries/rtasd.c       |    8 
 arch/x86/kernel/cpu/mtrr/main.c              |    8 
 arch/x86/kernel/entry_64.S                   |    6 
 arch/x86/kernel/microcode.c                  |   16 
 arch/x86/kernel/signal_32.c                  |    3 
 arch/x86/kernel/signal_64.c                  |    3 
 arch/x86/kernel/stacktrace.c                 |   27 
 drivers/lguest/x86/core.c                    |    8 
 drivers/s390/char/sclp_config.c              |    4 
 fs/Kconfig                                   |    1 
 fs/proc/base.c                               |   78 +
 include/asm-generic/resource.h               |    5 
 include/asm-x86/thread_info_32.h             |    2 
 include/asm-x86/thread_info_64.h             |    5 
 include/linux/cpu.h                          |   17 
 include/linux/debug_locks.h                  |    5 
 include/linux/futex.h                        |    6 
 include/linux/hardirq.h                      |    6 
 include/linux/hrtimer.h                      |   14 
 include/linux/init_task.h                    |    7 
 include/linux/interrupt.h                    |    1 
 include/linux/jiffies.h                      |    6 
 include/linux/kernel.h                       |    4 
 include/linux/latencytop.h                   |   44 
 include/linux/notifier.h                     |    4 
 include/linux/rcuclassic.h                   |  164 +++
 include/linux/rcupdate.h                     |  173 +--
 include/linux/rcupreempt.h                   |   86 +
 include/linux/rcupreempt_trace.h             |   99 +
 include/linux/sched.h                        |   83 +
 include/linux/smp_lock.h                     |   14 
 include/linux/stacktrace.h                   |    3 
 include/linux/topology.h                     |    5 
 init/Kconfig                                 |   28 
 init/main.c                                  |    1 
 kernel/Kconfig.hz                            |    2 
 kernel/Kconfig.preempt                       |   13 
 kernel/Makefile                              |    6 
 kernel/cpu.c                                 |  164 ++-
 kernel/cpuset.c                              |   14 
 kernel/fork.c                                |   11 
 kernel/hrtimer.c                             |  256 ++--
 kernel/kthread.c                             |   12 
 kernel/latencytop.c                          |  239 ++++
 kernel/lockdep.c                             |   12 
 kernel/module.c                              |   27 
 kernel/posix-cpu-timers.c                    |   30 
 kernel/printk.c                              |   57 -
 kernel/profile.c                             |   99 -
 kernel/rcuclassic.c                          |  575 +++++++++++
 kernel/rcupdate.c                            |  576 -----------
 kernel/rcupreempt.c                          |  953 ++++++++++++++++++
 kernel/rcupreempt_trace.c                    |  330 ++++++
 kernel/rcutorture.c                          |    6 
 kernel/sched.c                               | 1384 +++++++++++++++++++--------
 kernel/sched_debug.c                         |    5 
 kernel/sched_fair.c                          |  391 ++++++-
 kernel/sched_idletask.c                      |   42 
 kernel/sched_rt.c                            | 1112 +++++++++++++++++++--
 kernel/softlockup.c                          |  116 ++
 kernel/stop_machine.c                        |    4 
 kernel/sysctl.c                              |   77 +
 kernel/time/tick-sched.c                     |   13 
 kernel/timer.c                               |    3 
 kernel/user.c                                |   47 
 kernel/workqueue.c                           |   35 
 lib/Kconfig.debug                            |   14 
 lib/kernel_lock.c                            |  123 --
 mm/oom_kill.c                                |    2 
 mm/slab.c                                    |   18 
 net/core/flow.c                              |    4 
 81 files changed, 6262 insertions(+), 1776 deletions(-)

 [ delta patch too big to be sent to lkml ]
