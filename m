Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbXJOORk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbXJOORk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 10:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbXJOORc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 10:17:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55368 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751173AbXJOORb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 10:17:31 -0400
Date: Mon, 15 Oct 2007 16:17:23 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] scheduler updates for v2.6.24
Message-ID: <20071015141723.GA29486@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Linus, please pull the latest scheduler git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git

It contains lots of scheduler updates from lots of people - hopefully 
the last big one for quite some time. Most of the focus was on 
performance (both micro-performance and scalability/balancing), but 
there's the fair-scheduling feature now Kconfig selectable too. Find the 
shortlog below.

Code that is touched outside of the scheduler: the KVM bits were acked 
by Avi, the net/unix change is trivial and only affects sync wakeups, 
ditto the fs/pipe.c changes - but i can push those separately if it 
needs an ack from David first.

ABI/API changes:

 - new CONFIG_FAIR_USER_SCHED and /sys/kernel/uids/ + uevent API.
 - /proc/stat and /proc/<pid>/stat changes for guest-CPU usage [KVM]
 - /proc/sched_debug formats changed/enhanced

Testing status: the changes are chronological and all the 
interactivity-impacting changes are near the head of the queue and most 
of them were done weeks ago, and were thus part of the CFS-v22 backport 
series - which was tested by many people. There are no known regressions 
at the moment. It's all fully bisectable.

Thanks,

	Ingo

------------------>
Alexey Dobriyan (1):
      sched: uninline scheduler

Andi Kleen (4):
      sched: cleanup: remove unnecessary gotos
      sched: cleanup: refactor common code of sleep_on / wait_for_completion
      sched: cleanup: refactor normalize_rt_tasks
      sched: remove stale comment from sched_group_set_shares()

Arjan van de Ven (1):
      Make scheduler debug file operations const

Dhaval Giani (1):
      sched: group scheduling, sysfs tunables

Dmitry Adamushko (14):
      sched: clean up struct load_stat
      sched: clean up schedstat block in dequeue_entity()
      sched: sched_setscheduler() fix
      sched: add set_curr_task() calls
      sched: do not keep current in the tree and get rid of sched_entity::fair_key
      sched: optimize task_new_fair()
      sched: simplify sched_class::yield_task()
      sched: rework enqueue/dequeue_entity() to get rid of set_curr_task()
      sched: yield fix
      sched: fix __pick_next_entity()
      sched: tidy up SCHED_RR
      sched: cleanup, remove calc_weighted()
      sched: cleanup, make dequeue_entity() and update_stats_wait_end() similar
      sched: fix group scheduling for SCHED_BATCH

Gautham R Shenoy (1):
      sched: fix rt ptracer monopolizing CPU

Hiroshi Shimamoto (1):
      sched: clean up sched_fork()

Ingo Molnar (71):
      sched: fix sysctl_sched_child_runs_first flag
      sched: resched task in task_new_fair()
      sched: small sched_debug cleanup
      sched: debug: track maximum 'slice'
      sched: uniform tunings
      sched: use constants if !CONFIG_SCHED_DEBUG
      sched: remove stat_gran
      sched: remove precise CPU load
      sched: remove precise CPU load calculations #2
      sched: track cfs_rq->curr on !group-scheduling too
      sched: cleanup: simplify cfs_rq_curr() methods
      sched: uninline __enqueue_entity()/__dequeue_entity()
      sched: speed up update_load_add/_sub()
      sched: clean up calc_weighted()
      sched: introduce se->vruntime
      sched: move sched_feat() definitions
      sched: optimize vruntime based scheduling
      sched: simplify check_preempt() methods
      sched: wakeup granularity increase
      sched: add se->vruntime debugging
      sched: remove SCHED_FEAT_SKIP_INITIAL
      sched: add more vruntime statistics
      sched: debug: update exec_clock only when SCHED_DEBUG
      sched: remove wait_runtime limit
      sched: remove wait_runtime fields and features
      sched: x86: allow single-depth wchan output
      sched: fix delay accounting performance regression
      sched: prettify /proc/sched_debug output
      sched: enhance debug output
      sched: kernel/sched_fair.c whitespace cleanups
      sched: fair-group sched, cleanups
      sched: enable CONFIG_FAIR_GROUP_SCHED=y by default
      sched debug: BKL usage statistics
      sched: remove unneeded tunables
      sched debug: print settings
      sched debug: more width for parameter printouts
      sched: entity_key() fix
      sched: remove condition from set_task_cpu()
      sched: remove last_min_vruntime effect
      sched: undo some of the recent changes
      sched: fix sign check error in place_entity()
      sched: fix sched_fork()
      sched: remove set_leftmost()
      sched: clean up schedstats, cnt -> count
      sched: cleanup, remove stale comment
      sched: mark scheduling classes as const
      sched: whitespace cleanups
      sched: vslice fixups for non-0 nice levels
      sched: optimize schedule() a bit on SMP
      sched: tweak wakeup granularity
      sched: run sched_domain_debug() if CONFIG_SCHED_DEBUG=y
      sched: break out if printing a warning in sched_domain_debug()
      sched: style cleanup
      sched: kfree(NULL) is valid
      sched: cleanup: rename SCHED_FEAT_USE_TREE_AVG to SCHED_FEAT_TREE_AVG
      sched: cleanup: rename task_grp to task_group
      sched: cleanup: function prototype cleanups
      sched: fix: move the CPU check into ->task_new_fair()
      sched: update comment
      sched: clean up is_migration_thread()
      sched: do not normalize kernel threads via SysRq-N
      sched: do not wakeup-preempt with SCHED_BATCH tasks
      sched: speed up context-switches a bit
      sched: reintroduce cache-hot affinity
      sched: debug: increase width of debug line
      sched: debug, improve migration statistics
      sched: allow the immediate migration of cache-cold tasks
      sched: reintroduce topology.h tunings
      sched: enable wake-idle on CONFIG_SCHED_MC=y
      sched: affine sync wakeups
      sched: sync wakeups preempt too

Laurent Vivier (4):
      sched: guest CPU accounting: add guest-CPU /proc/stat field
      sched: guest CPU accounting: add guest-CPU /proc/<pid>/stat fields
      sched: guest CPU accounting: maintain stats in account_system_time()
      sched: guest CPU accounting: maintain guest state in KVM

Matthias Kaehlcke (1):
      sched: use list_for_each_entry_safe() in __wake_up_common()

Mike Galbraith (4):
      sched: fix SMP migration latencies
      sched: fix formatting of /proc/sched_debug
      sched: cleanup, remove the TASK_NONINTERACTIVE flag
      sched: prevent wakeup over-scheduling

Milton Miller (5):
      sched: domain sysctl fixes: use kcalloc()
      sched: domain sysctl fixes: use for_each_online_cpu()
      sched: domain sysctl fixes: unregister the sysctl table before domains
      sched: domain sysctl fixes: do not crash on allocation failure
      sched: domain sysctl fixes: add terminator comment

Paul E. McKenney (1):
      sched: export cpu_clock()

Peter Williams (2):
      sched: reduce balance-tasks overhead
      sched: isolate SMP balancing code a bit more

Peter Zijlstra (16):
      sched: simplify SCHED_FEAT_* code
      sched: new task placement for vruntime
      sched: simplify adaptive latency
      sched: clean up new task placement
      sched: add tree based averages
      sched: handle vruntime 64-bit overflow
      sched: better min_vruntime tracking
      sched: add vslice
      sched debug: check spread
      sched: max_vruntime() simplification
      sched: clean up min_vruntime use
      sched: speed up and simplify vslice calculations
      sched: another wakeup_granularity fix
      sched: disable sleeper_fairness on SCHED_BATCH
      sched: disable forced preemption by default
      sched: activate task_hot() only on fair-scheduled tasks

S.Caglar Onur (1):
      sched debug: BKL usage statistics, fix

Srivatsa Vaddagiri (13):
      sched: group-scheduler core
      sched: revert recent removal of set_curr_task()
      sched: fix minor bug in yield
      sched: print nr_running and load in /proc/sched_debug
      sched: print &rq->cfs stats
      sched: clean up code under CONFIG_FAIR_GROUP_SCHED
      sched: add fair-user scheduler
      sched: group scheduler wakeup latency fix
      sched: group scheduler SMP migration fix
      sched: group scheduler, fix coding style issues
      sched: group scheduler, fix bloat
      sched: group scheduler, fix latency
      sched: generate uevents for user creation/destruction

Zou Nan hai (1):
      sched: some proc entries are missed in sched_domain sys_ctl debug code

 Documentation/sched-design-CFS.txt |   67 +
 arch/i386/Kconfig                  |   11 
 drivers/kvm/kvm.h                  |   10 
 drivers/kvm/kvm_main.c             |    2 
 fs/pipe.c                          |    9 
 fs/proc/array.c                    |   17 
 fs/proc/base.c                     |    2 
 fs/proc/proc_misc.c                |   15 
 include/linux/kernel_stat.h        |    1 
 include/linux/sched.h              |  108 +-
 include/linux/topology.h           |    5 
 init/Kconfig                       |   21 
 kernel/delayacct.c                 |    2 
 kernel/exit.c                      |    6 
 kernel/fork.c                      |    3 
 kernel/ksysfs.c                    |    8 
 kernel/sched.c                     | 1526 +++++++++++++++++++++----------------
 kernel/sched_debug.c               |  282 ++++--
 kernel/sched_fair.c                |  859 ++++++++------------
 kernel/sched_idletask.c            |   26 
 kernel/sched_rt.c                  |   51 -
 kernel/sched_stats.h               |   28 
 kernel/sysctl.c                    |   37 
 kernel/user.c                      |  249 +++++-
 net/unix/af_unix.c                 |    4 
 25 files changed, 1998 insertions(+), 1351 deletions(-)
