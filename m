Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbXIYOpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbXIYOpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 10:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751554AbXIYOpA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 10:45:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41890 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbXIYOo7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 10:44:59 -0400
Date: Tue, 25 Sep 2007 16:44:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git] CFS-devel, latest code
Message-ID: <20070925144443.GA17858@elte.hu>
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


The latest sched-devel.git tree can be pulled from:
  
   git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
 
This is a quick iteration after yesterday's: a couple of group 
scheduling bugs were found/debugged and fixed by Srivatsa Vaddagiri and 
Mike Galbraith. There's also a yield fix from Dmitry Adamushko, a build 
fix from S.Ceglar Onur and Andrew Morton, a cleanup from Hiroshi 
Shimamoto and the usual stream of goodies from Peter Zijlstra. Rebased 
it to -rc8 as well.

there are no known regressions at the moment in the sched-devel.git 
codebase. (yay :)

	Ingo

----------------------------------------->
the shortlog relative to 2.6.23-rc8:
 
Dmitry Adamushko (9):
      sched: clean up struct load_stat
      sched: clean up schedstat block in dequeue_entity()
      sched: sched_setscheduler() fix
      sched: add set_curr_task() calls
      sched: do not keep current in the tree and get rid of sched_entity::fair_key
      sched: optimize task_new_fair()
      sched: simplify sched_class::yield_task()
      sched: rework enqueue/dequeue_entity() to get rid of set_curr_task()
      sched: yield fix

Hiroshi Shimamoto (1):
      sched: clean up sched_fork()

Ingo Molnar (44):
      sched: fix new-task method
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
      sched: wakeup granularity fix
      sched: add se->vruntime debugging
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
      sched: fix place_entity()
      sched: fix sched_fork()
      sched: remove set_leftmost()
      sched: clean up schedstats, cnt -> count
      sched: cleanup, remove stale comment

Matthias Kaehlcke (1):
      sched: use list_for_each_entry_safe() in __wake_up_common()

Mike Galbraith (2):
      sched: fix SMP migration latencies
      sched: fix formatting of /proc/sched_debug

Peter Zijlstra (12):
      sched: simplify SCHED_FEAT_* code
      sched: new task placement for vruntime
      sched: simplify adaptive latency
      sched: clean up new task placement
      sched: add tree based averages
      sched: handle vruntime overflow
      sched: better min_vruntime tracking
      sched: add vslice
      sched debug: check spread
      sched: max_vruntime() simplification
      sched: clean up min_vruntime use
      sched: speed up and simplify vslice calculations

S.Ceglar Onur (1):
      sched debug: BKL usage statistics, fix

Srivatsa Vaddagiri (9):
      sched: group-scheduler core
      sched: revert recent removal of set_curr_task()
      sched: fix minor bug in yield
      sched: print nr_running and load in /proc/sched_debug
      sched: print &rq->cfs stats
      sched: clean up code under CONFIG_FAIR_GROUP_SCHED
      sched: add fair-user scheduler
      sched: group scheduler wakeup latency fix
      sched: group scheduler SMP migration fix

 arch/i386/Kconfig       |   11 
 fs/proc/base.c          |    2 
 include/linux/sched.h   |   55 ++-
 init/Kconfig            |   21 +
 kernel/delayacct.c      |    2 
 kernel/sched.c          |  577 +++++++++++++++++++++++++-------------
 kernel/sched_debug.c    |  250 +++++++++++-----
 kernel/sched_fair.c     |  718 +++++++++++++++++-------------------------------
 kernel/sched_idletask.c |    5 
 kernel/sched_rt.c       |   12 
 kernel/sched_stats.h    |   28 -
 kernel/sysctl.c         |   31 --
 kernel/user.c           |   43 ++
 13 files changed, 954 insertions(+), 801 deletions(-)
