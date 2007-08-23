Return-Path: <linux-kernel-owner+w=401wt.eu-S1761252AbXHWJoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761252AbXHWJoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 05:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756623AbXHWJnx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 05:43:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46526 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115AbXHWJnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 05:43:52 -0400
Date: Thu, 23 Aug 2007 11:43:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Subject: [patch] CFS scheduler, -v20, for v2.6.22.5, v2.6.21.7, v2.6.20.16
Message-ID: <20070823094346.GA26281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.0.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4999]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


By popular demand, here is release -v20 of the CFS scheduler. It is a 
full backport of the latest & greatest v2.6.23-rc3 CFS code to 
v2.6.22.5, v2.6.21.7 and v2.6.20.16. The patches can be downloaded from 
the usual place:

    http://people.redhat.com/mingo/cfs-scheduler/

Changes since -v19: there have been lots of small regression fixes,
speedups, debug enhancements and tidy-ups - many of which can be
user-visible.

See the detailed shortlog below - there are nearly 100 changes - they do 
add up to a significant total linecount change. There was no crash bug 
or hang bug found in the CFS code since v19 was released. (in fact the 
last crash/hang bug in CFS was found and fixed in v7, more than 3 months 
ago, and even that crash only happened in an uncommon sw-suspend setup, 
not during normal use. So CFS has turned out to be a pretty robust 
codebase.)

Nevertheless, if you had any problems (performance or behavioral) with
v19 it's worth checking v20 out - and if v19 worked great for you it's
worth checking out that v20 still works great =B-)

Also, the backported CFS scheduler enables people to test suspected 
scheduler regressions on older codebases too, to filter out the effects 
of other changes.

v20 has been build and boot tested on both 32-bit and 64-bit x86, ontop 
of all 3 backport kernel bases. As usual, any sort of feedback, 
bugreport, fix and suggestion is more than welcome!

	Ingo

------------------->
Adrian Bunk (1):
      sched: make global code static

Al Viro (1):
      take sched_debug.c out of nasal demon territory

Alexey Dobriyan (2):
      Fix leaks on /proc/{*/sched,sched_debug,timer_list,timer_stats}
      sched: remove binary sysctls from kernel.sched_domain

Avi Kivity (1):
      sched: arch preempt notifier mechanism

Ingo Molnar (68):
      sched: make cpu_clock() not use the rq clock
      sched: remove cache_hot_time
      sched: calc_delta_mine(): use fixed limit
      sched: uninline calc_delta_mine()
      sched: uninline inc/dec_nr_running()
      sched: ->task_new cleanup
      sched: move load-calculation functions
      sched: add schedstat_set() API
      sched: use schedstat_set() API
      sched: reduce debug code
      sched: batch sleeper bonus
      sched: reorder update_cpu_load(rq) with the ->task_tick() call
      sched: uninline rq_clock()
      sched: schedule() speedup
      sched: clean up delta_mine
      sched: delta_exec accounting fix
      sched: add [__]update_rq_clock(rq)
      sched: eliminate rq_clock() use
      sched: remove rq_clock()
      sched: eliminate __rq_clock() use
      sched: remove __rq_clock()
      sched: remove 'now' use from assignments
      sched: remove the 'u64 now' parameter from print_cfs_rq()
      sched: remove the 'u64 now' parameter from update_curr()
      sched: remove the 'u64 now' parameter from update_stats_wait_start()
      sched: remove the 'u64 now' parameter from update_stats_enqueue()
      sched: remove the 'u64 now' parameter from __update_stats_wait_end()
      sched: remove the 'u64 now' parameter from update_stats_wait_end()
      sched: remove the 'u64 now' parameter from update_stats_curr_start()
      sched: remove the 'u64 now' parameter from update_stats_dequeue()
      sched: remove the 'u64 now' parameter from update_stats_curr_end()
      sched: remove the 'u64 now' parameter from __enqueue_sleeper()
      sched: remove the 'u64 now' parameter from enqueue_sleeper()
      sched: remove the 'u64 now' parameter from enqueue_entity()
      sched: remove the 'u64 now' parameter from dequeue_entity()
      sched: remove the 'u64 now' parameter from set_next_entity()
      sched: remove the 'u64 now' parameter from pick_next_entity()
      sched: remove the 'u64 now' parameter from put_prev_entity()
      sched: remove the 'u64 now' parameter from update_curr_rt()
      sched: remove the 'u64 now' parameter from ->enqueue_task()
      sched: remove the 'u64 now' parameter from ->dequeue_task()
      sched: remove the 'u64 now' parameter from ->pick_next_task()
      sched: remove the 'u64 now' parameter from pick_next_task()
      sched: remove the 'u64 now' parameter from ->put_prev_task()
      sched: remove the 'u64 now' parameter from ->task_new()
      sched: remove the 'u64 now' parameter from update_curr_load()
      sched: remove the 'u64 now' parameter from inc_load()
      sched: remove the 'u64 now' parameter from dec_load()
      sched: remove the 'u64 now' parameter from inc_nr_running()
      sched: remove the 'u64 now' parameter from dec_nr_running()
      sched: remove the 'u64 now' parameter from enqueue_task()
      sched: remove the 'u64 now' parameter from dequeue_task()
      sched: remove the 'u64 now' parameter from deactivate_task()
      sched: remove the 'u64 now' local variables
      sched debug: remove the 'u64 now' parameter from print_task()/_rq()
      sched: move the __update_rq_clock() call to scheduler_tick()
      sched: remove __update_rq_clock() call from entity_tick()
      sched: clean up set_curr_task_fair()
      sched: optimize activate_task()
      sched: optimize update_rq_clock() calls in the load-balancer
      sched: make the multiplication table more accurate
      sched: round a bit better
      sched: fix update_stats_enqueue() reniced codepath
      sched: refine negative nice level granularity
      sched: improve rq-clock overflow logic
      sched: fix typo in the FAIR_GROUP_SCHED branch
      sched debug: dont print kernel address in /proc/sched_debug
      sched: fix sleeper bonus

Josh Triplett (2):
      sched: mark sysrq_sched_debug_show() static
      sched: mark print_cfs_stats static

Nick Piggin (1):
      sched: debug feature - make the sched-domains tree runtime-tweakable

Oleg Nesterov (1):
      sched: run_rebalance_domains: s/SCHED_IDLE/CPU_IDLE/

Peter Williams (3):
      sched: tidy up left over smpnice code
      sched: simplify move_tasks()
      sched: fix bug in balance_tasks()

Randy Dunlap (1):
      sched: fix kernel-doc warnings

Satoru Takeuchi (1):
      sched: remove unused rq->load_balance_class

Ulrich Drepper (1):
      sched: clean up sched_getaffinity()
