Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968461Ab0B0Ovo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 09:51:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968441Ab0B0Ovn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 09:51:43 -0500
Date: Sat, 27 Feb 2010 15:51:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] sched/core changes for v2.6.34
Message-ID: <20100227145133.GA29678@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-core-for-linus

The biggest change are further load-balancer cleanups. We expect no 
significant behavioral impact. (in theory that is.)

 Thanks,

	Ingo

------------------>

[ shortlog and diffstat done manually, relative to sched-fixes-for-linus. ]

Akinobu Mita (1):
      sched: Use for_each_bit

Anton Blanchard (3):
      percpu_counter: Make __percpu_counter_add an inline function on UP
      sched: cpuacct: Use bigger percpu counter batch values for stats counters
      kthread, sched: Remove reference to kthread_create_on_cpu

Dhaval Giani (1):
      sched: Remove USER_SCHED

Gautham R Shenoy (1):
      sched: Fix the place where group powers are updated

H Hartley Sweeten (1):
      sched: Don't expose local functions

Peter Zijlstra (10):
      sched: Move load balance code into sched_fair.c
      sched: Remove the sched_class load_balance methods
      sched: Remove rq_iterator usage from load_balance_fair
      sched: Remove rq_iterator from move_one_task
      sched: Remove from fwd decls
      sched: Add a lock break for PREEMPT=y
      sched: Unify load_balance{,_newidle}()
      sched: Remove load_balance_newidle()
      sched: Assume *balance is valid
      sched: Remove unused update_shares_locked()

Simon Kagstrom (1):
      sched: might_sleep(): Make file parameter const char *

Suresh Siddha (1):
      sched: Fix SCHED_MC regression caused by change in sched cpu_power

Thomas Gleixner (4):
      sched: Extend enqueue_task to allow head queueing
      sched: Implement head queueing for sched_rt
      sched: Queue a deboosted task to the head of the RT prio queue
      sched: Don't use possibly stale sched_class

Yong Zhang (2):
      sched: Change usage of rt_rq->rt_se to rt_rq->tg->rt_se[cpu]
      sched: Remove member rt_se from struct rt_rq

 Documentation/feature-removal-schedule.txt |   15 -
 include/linux/kernel.h                     |    5 +-
 include/linux/percpu_counter.h             |    9 +-
 include/linux/sched.h                      |   25 +-
 init/Kconfig                               |   81 +-
 kernel/ksysfs.c                            |    8 -
 kernel/kthread.c                           |    2 +-
 kernel/sched.c                             | 2125 ++--------------------------
 kernel/sched_cpupri.c                      |    4 +-
 kernel/sched_fair.c                        | 1699 +++++++++++++++++++++-
 kernel/sched_idletask.c                    |   23 +-
 kernel/sched_rt.c                          |   54 +-
 kernel/sys.c                               |    5 -
 kernel/user.c                              |  305 ----
 14 files changed, 1827 insertions(+), 2533 deletions(-)

