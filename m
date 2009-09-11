Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZIKTBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZIKTBD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZIKTBB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:01:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59156 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbZIKTAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:00:54 -0400
Date: Fri, 11 Sep 2009 21:00:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: [GIT PULL] core/rcu for v2.6.32
Message-ID: <20090911190033.GA11817@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-rcu-for-linus

The biggest highlight is the removal of classic RCU and the 
continued consolidation of RCU models.

 Thanks,

	Ingo

------------------>
Josh Triplett (1):
      rcu: Fix typo in rcu_irq_exit() comment header

Paul E. McKenney (27):
      rcu: Remove Classic RCU
      rcu: Add synchronize_sched_expedited() primitive
      rcu: Add synchronize_sched_expedited() torture tests
      rcu: Add synchronize_sched_expedited() rcutorture doc + updates
      rcu: Split hierarchical RCU initialization into boot-time and CPU-online pieces
      cpu hotplug: Introduce cpu_notifier() to handle !HOTPLUG_CPU case
      rcu: Simplify RCU CPU-hotplug notification
      rcu: Make preemptable RCU scan all CPUs when summing RCU counters
      rcu: Make rcupreempt_trace.c look at offline CPUs
      rcu: Delay rcu_barrier() wait until beginning of next CPU-hotunplug operation.
      rcu: Expunge lingering references to CONFIG_CLASSIC_RCU, optimize on !SMP
      rcu: Move private definitions from include/linux/rcutree.h to kernel/rcutree.h
      rcu: Renamings to increase RCU clarity
      rcu: Consolidate sparse and lockdep declarations in include/linux/rcupdate.h
      rcu: Fix online/offline indication for rcudata.csv trace file
      rcu: Merge per-RCU-flavor initialization into pre-existing macro
      rcu: Use debugfs_remove_recursive() simplify code.
      rcu: Simplify rcu_pending()/rcu_check_callbacks() API
      rcu: Merge preemptable-RCU functionality into hierarchical RCU
      rcu: Remove CONFIG_PREEMPT_RCU
      rcu: Add "notrace" to RCU function headers used by ftrace
      rcu: Add CPU-offline processing for single-node configurations
      rcu: Add #ifdef to suppress __rcu_offline_cpu() warning in !HOTPLUG_CPU builds
      rcu: Remove lockdep annotations from RCU's _notrace() API members
      rcu: Create rcutree plugins to handle hotplug CPU for multi-level trees
      rcu: Changes from reviews: avoid casts, fix/add warnings, improve comments
      rcu: Move end of special early-boot RCU operation earlier


 Documentation/RCU/RTFP.txt       |   77 ++
 Documentation/RCU/UP.txt         |   34 +-
 Documentation/RCU/checklist.txt  |   20 +-
 Documentation/RCU/rcu.txt        |   10 +-
 Documentation/RCU/rcubarrier.txt |    7 +
 Documentation/RCU/torture.txt    |   23 +-
 Documentation/RCU/trace.txt      |    7 +-
 Documentation/RCU/whatisRCU.txt  |   22 +-
 arch/ia64/xen/time.c             |    3 +-
 include/linux/cpu.h              |   17 +-
 include/linux/hardirq.h          |    4 +-
 include/linux/init_task.h        |   11 +
 include/linux/pagemap.h          |    4 +-
 include/linux/rcuclassic.h       |  178 -----
 include/linux/rcupdate.h         |   98 ++-
 include/linux/rcupreempt.h       |  127 ----
 include/linux/rcupreempt_trace.h |   97 ---
 include/linux/rcutree.h          |  262 +------
 include/linux/sched.h            |   32 +-
 init/Kconfig                     |   46 +-
 init/main.c                      |    2 +-
 kernel/Makefile                  |    4 +-
 kernel/exit.c                    |    1 +
 kernel/fork.c                    |    5 +-
 kernel/rcuclassic.c              |  807 --------------------
 kernel/rcupdate.c                |   44 +-
 kernel/rcupreempt.c              | 1539 --------------------------------------
 kernel/rcupreempt_trace.c        |  334 ---------
 kernel/rcutorture.c              |  202 +++---
 kernel/rcutree.c                 |  273 +++++---
 kernel/rcutree.h                 |  253 +++++++-
 kernel/rcutree_plugin.h          |  532 +++++++++++++
 kernel/rcutree_trace.c           |   88 ++-
 kernel/sched.c                   |  131 ++++-
 kernel/softirq.c                 |    4 +-
 kernel/timer.c                   |    3 +-
 lib/Kconfig.debug                |    2 +-
 37 files changed, 1636 insertions(+), 3667 deletions(-)
 delete mode 100644 include/linux/rcuclassic.h
 delete mode 100644 include/linux/rcupreempt.h
 delete mode 100644 include/linux/rcupreempt_trace.h
 delete mode 100644 kernel/rcuclassic.c
 delete mode 100644 kernel/rcupreempt.c
 delete mode 100644 kernel/rcupreempt_trace.c
 create mode 100644 kernel/rcutree_plugin.h

diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index 9f711d2..d2b8523 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -743,3 +743,80 @@ Revised:
 	RCU, realtime RCU, sleepable RCU, performance.
 "
 }
+
+@article{PaulEMcKenney2008RCUOSR
+,author="Paul E. McKenney and Jonathan Walpole"
+,title="Introducing technology into the {Linux} kernel: a case study"
+,Year="2008"
+,journal="SIGOPS Oper. Syst. Rev."
+,volume="42"
+,number="5"
+,pages="4--17"
+,issn="0163-5980"
+,doi={http://doi.acm.org/10.1145/1400097.1400099}
+,publisher="ACM"
+,address="New York, NY, USA"
+,annotation={
+	Linux changed RCU to a far greater degree than RCU has changed Linux.
+}
+}
+
+@unpublished{PaulEMcKenney2008HierarchicalRCU
+,Author="Paul E. McKenney"
+,Title="Hierarchical {RCU}"
+,month="November"
+,day="3"
+,year="2008"
+,note="Available:
+\url{http://lwn.net/Articles/305782/}
+[Viewed November 6, 2008]"
+,annotation="
+	RCU with combining-tree-based grace-period detection,
+	permitting it to handle thousands of CPUs.
+"
+}
+
+@conference{PaulEMcKenney2009MaliciousURCU
+,Author="Paul E. McKenney"
+,Title="Using a Malicious User-Level {RCU} to Torture {RCU}-Based Algorithms"
+,Booktitle="linux.conf.au 2009"
+,month="January"
+,year="2009"
+,address="Hobart, Australia"
+,note="Available:
+\url{http://www.rdrop.com/users/paulmck/RCU/urcutorture.2009.01.22a.pdf}
+[Viewed February 2, 2009]"
+,annotation="
+	Realtime RCU and torture-testing RCU uses.
+"
+}
+
+@unpublished{MathieuDesnoyers2009URCU
+,Author="Mathieu Desnoyers"
+,Title="[{RFC} git tree] Userspace {RCU} (urcu) for {Linux}"
+,month="February"
+,day="5"
+,year="2009"
+,note="Available:
+\url{http://lkml.org/lkml/2009/2/5/572}
+\url{git://lttng.org/userspace-rcu.git}
+[Viewed February 20, 2009]"
+,annotation="
+	Mathieu Desnoyers's user-space RCU implementation.
+	git://lttng.org/userspace-rcu.git
+"
+}
+
+@unpublished{PaulEMcKenney2009BloatWatchRCU
+,Author="Paul E. McKenney"
+,Title="{RCU}: The {Bloatwatch} Edition"
+,month="March"
+,day="17"
+,year="2009"
+,note="Available:
+\url{http://lwn.net/Articles/323929/}
+[Viewed March 20, 2009]"
+,annotation="
+	Uniprocessor assumptions allow simplified RCU implementation.
+"
+}
diff --git a/Documentation/RCU/UP.txt b/Documentation/RCU/UP.txt
index aab4a9e..90ec534 100644
--- a/Documentation/RCU/UP.txt
+++ b/Documentation/RCU/UP.txt
@@ -2,14 +2,13 @@ RCU on Uniprocessor Systems
 
 
 A common misconception is that, on UP systems, the call_rcu() primitive
-may immediately invoke its function, and that the synchronize_rcu()
-primitive may return immediately.  The basis of this misconception
+may immediately invoke its function.  The basis of this misconception
 is that since there is only one CPU, it should not be necessary to
 wait for anything else to get done, since there are no other CPUs for
 anything else to be happening on.  Although this approach will -sort- -of-
 work a surprising amount of the time, it is a very bad idea in general.
-This document presents three examples that demonstrate exactly how bad an
-idea this is.
+This document presents three examples that demonstrate exactly how bad
+an idea this is.
 
 
 Example 1: softirq Suicide
@@ -82,11 +81,18 @@ Quick Quiz #2: What locking restriction must RCU callbacks respect?
 
 Summary
 
-Permitting call_rcu() to immediately invoke its arguments or permitting
-synchronize_rcu() to immediately return breaks RCU, even on a UP system.
-So do not do it!  Even on a UP system, the RCU infrastructure -must-
-respect grace periods, and -must- invoke callbacks from a known environment
-in which no locks are held.
+Permitting call_rcu() to immediately invoke its arguments breaks RCU,
+even on a UP system.  So do not do it!  Even on a UP system, the RCU
+infrastructure -must- respect grace periods, and -must- invoke callbacks
+from a known environment in which no locks are held.
+
+It -is- safe for synchronize_sched() and synchronize_rcu_bh() to return
+immediately on an UP system.  It is also safe for synchronize_rcu()
+to return immediately on UP systems, except when running preemptable
+RCU.
+
+Quick Quiz #3: Why can't synchronize_rcu() return immediately on
+	UP systems running preemptable RCU?
 
 
 Answer to Quick Quiz #1:
@@ -117,3 +123,13 @@ Answer to Quick Quiz #2:
 	callbacks acquire locks directly.  However, a great many RCU
 	callbacks do acquire locks -indirectly-, for example, via
 	the kfree() primitive.
+
+Answer to Quick Quiz #3:
+	Why can't synchronize_rcu() return immediately on UP systems
+	running preemptable RCU?
+
+	Because some other task might have been preempted in the middle
+	of an RCU read-side critical section.  If synchronize_rcu()
+	simply immediately returned, it would prematurely signal the
+	end of the grace period, which would come as a nasty shock to
+	that other thread when it started running again.
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index accfe2f..51525a3 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -11,7 +11,10 @@ over a rather long period of time, but improvements are always welcome!
 	structure is updated more than about 10% of the time, then
 	you should strongly consider some other approach, unless
 	detailed performance measurements show that RCU is nonetheless
-	the right tool for the job.
+	the right tool for the job.  Yes, you might think of RCU
+	as simply cutting overhead off of the readers and imposing it
+	on the writers.  That is exactly why normal uses of RCU will
+	do much more reading than updating.
 
 	Another exception is where performance is not an issue, and RCU
 	provides a simpler implementation.  An example of this situation
@@ -240,10 +243,11 @@ over a rather long period of time, but improvements are always welcome!
 	instead need to use synchronize_irq() or synchronize_sched().
 
 12.	Any lock acquired by an RCU callback must be acquired elsewhere
-	with irq disabled, e.g., via spin_lock_irqsave().  Failing to
-	disable irq on a given acquisition of that lock will result in
-	deadlock as soon as the RCU callback happens to interrupt that
-	acquisition's critical section.
+	with softirq disabled, e.g., via spin_lock_irqsave(),
+	spin_lock_bh(), etc.  Failing to disable irq on a given
+	acquisition of that lock will result in deadlock as soon as the
+	RCU callback happens to interrupt that acquisition's critical
+	section.
 
 13.	RCU callbacks can be and are executed in parallel.  In many cases,
 	the callback code simply wrappers around kfree(), so that this
@@ -310,3 +314,9 @@ over a rather long period of time, but improvements are always welcome!
 	Because these primitives only wait for pre-existing readers,
 	it is the caller's responsibility to guarantee safety to
 	any subsequent readers.
+
+16.	The various RCU read-side primitives do -not- contain memory
+	barriers.  The CPU (and in some cases, the compiler) is free
+	to reorder code into and out of RCU read-side critical sections.
+	It is the responsibility of the RCU update-side primitives to
+	deal with this.
diff --git a/Documentation/RCU/rcu.txt b/Documentation/RCU/rcu.txt
index 7aa2002..2a23523 100644
--- a/Documentation/RCU/rcu.txt
+++ b/Documentation/RCU/rcu.txt
@@ -36,7 +36,7 @@ o	How can the updater tell when a grace period has completed
 	executed in user mode, or executed in the idle loop, we can
 	safely free up that item.
 
-	Preemptible variants of RCU (CONFIG_PREEMPT_RCU) get the
+	Preemptible variants of RCU (CONFIG_TREE_PREEMPT_RCU) get the
 	same effect, but require that the readers manipulate CPU-local
 	counters.  These counters allow limited types of blocking
 	within RCU read-side critical sections.  SRCU also uses
@@ -79,10 +79,10 @@ o	I hear that RCU is patented?  What is with that?
 o	I hear that RCU needs work in order to support realtime kernels?
 
 	This work is largely completed.  Realtime-friendly RCU can be
-	enabled via the CONFIG_PREEMPT_RCU kernel configuration parameter.
-	However, work is in progress for enabling priority boosting of
-	preempted RCU read-side critical sections.  This is needed if you
-	have CPU-bound realtime threads.
+	enabled via the CONFIG_TREE_PREEMPT_RCU kernel configuration
+	parameter.  However, work is in progress for enabling priority
+	boosting of preempted RCU read-side critical sections.	This is
+	needed if you have CPU-bound realtime threads.
 
 o	Where can I find more information on RCU?
 
diff --git a/Documentation/RCU/rcubarrier.txt b/Documentation/RCU/rcubarrier.txt
index 909602d..e439a0e 100644
--- a/Documentation/RCU/rcubarrier.txt
+++ b/Documentation/RCU/rcubarrier.txt
@@ -170,6 +170,13 @@ module invokes call_rcu() from timers, you will need to first cancel all
 the timers, and only then invoke rcu_barrier() to wait for any remaining
 RCU callbacks to complete.
 
+Of course, if you module uses call_rcu_bh(), you will need to invoke
+rcu_barrier_bh() before unloading.  Similarly, if your module uses
+call_rcu_sched(), you will need to invoke rcu_barrier_sched() before
+unloading.  If your module uses call_rcu(), call_rcu_bh(), -and-
+call_rcu_sched(), then you will need to invoke each of rcu_barrier(),
+rcu_barrier_bh(), and rcu_barrier_sched().
+
 
 Implementing rcu_barrier()
 
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index a342b6e..9dba3bb 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -76,8 +76,10 @@ torture_type	The type of RCU to test: "rcu" for the rcu_read_lock() API,
 		"rcu_sync" for rcu_read_lock() with synchronous reclamation,
 		"rcu_bh" for the rcu_read_lock_bh() API, "rcu_bh_sync" for
 		rcu_read_lock_bh() with synchronous reclamation, "srcu" for
-		the "srcu_read_lock()" API, and "sched" for the use of
-		preempt_disable() together with synchronize_sched().
+		the "srcu_read_lock()" API, "sched" for the use of
+		preempt_disable() together with synchronize_sched(),
+		and "sched_expedited" for the use of preempt_disable()
+		with synchronize_sched_expedited().
 
 verbose		Enable debug printk()s.  Default is disabled.
 
@@ -162,6 +164,23 @@ of the "old" and "current" counters for the corresponding CPU.  The
 "idx" value maps the "old" and "current" values to the underlying array,
 and is useful for debugging.
 
+Similarly, sched_expedited RCU provides the following:
+
+	sched_expedited-torture: rtc: d0000000016c1880 ver: 1090796 tfle: 0 rta: 1090796 rtaf: 0 rtf: 1090787 rtmbe: 0 nt: 27713319
+	sched_expedited-torture: Reader Pipe:  12660320201 95875 0 0 0 0 0 0 0 0 0
+	sched_expedited-torture: Reader Batch:  12660424885 0 0 0 0 0 0 0 0 0 0
+	sched_expedited-torture: Free-Block Circulation:  1090795 1090795 1090794 1090793 1090792 1090791 1090790 1090789 1090788 1090787 0
+	state: -1 / 0:0 3:0 4:0
+
+As before, the first four lines are similar to those for RCU.
+The last line shows the task-migration state.  The first number is
+-1 if synchronize_sched_expedited() is idle, -2 if in the process of
+posting wakeups to the migration kthreads, and N when waiting on CPU N.
+Each of the colon-separated fields following the "/" is a CPU:state pair.
+Valid states are "0" for idle, "1" for waiting for quiescent state,
+"2" for passed through quiescent state, and "3" when a race with a
+CPU-hotplug event forces use of the synchronize_sched() primitive.
+
 
 USAGE
 
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
index 02cced1..187bbf1 100644
--- a/Documentation/RCU/trace.txt
+++ b/Documentation/RCU/trace.txt
@@ -191,8 +191,7 @@ rcu/rcuhier (which displays the struct rcu_node hierarchy).
 
 The output of "cat rcu/rcudata" looks as follows:
 
-rcu:
-rcu:
+rcu_sched:
   0 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=10951/1 dn=0 df=1101 of=0 ri=36 ql=0 b=10
   1 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=16117/1 dn=0 df=1015 of=0 ri=0 ql=0 b=10
   2 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1445/1 dn=0 df=1839 of=0 ri=0 ql=0 b=10
@@ -306,7 +305,7 @@ comma-separated-variable spreadsheet format.
 
 The output of "cat rcu/rcugp" looks as follows:
 
-rcu: completed=33062  gpnum=33063
+rcu_sched: completed=33062  gpnum=33063
 rcu_bh: completed=464  gpnum=464
 
 Again, this output is for both "rcu" and "rcu_bh".  The fields are
@@ -413,7 +412,7 @@ o	Each element of the form "1/1 0:127 ^0" represents one struct
 
 The output of "cat rcu/rcu_pending" looks as follows:
 
-rcu:
+rcu_sched:
   0 np=255892 qsp=53936 cbr=0 cng=14417 gpc=10033 gps=24320 nf=6445 nn=146741
   1 np=261224 qsp=54638 cbr=0 cng=25723 gpc=16310 gps=2849 nf=5912 nn=155792
   2 np=237496 qsp=49664 cbr=0 cng=2762 gpc=45478 gps=1762 nf=1201 nn=136629
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index 9617082..e41a7fe 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -136,10 +136,10 @@ rcu_read_lock()
 	Used by a reader to inform the reclaimer that the reader is
 	entering an RCU read-side critical section.  It is illegal
 	to block while in an RCU read-side critical section, though
-	kernels built with CONFIG_PREEMPT_RCU can preempt RCU read-side
-	critical sections.  Any RCU-protected data structure accessed
-	during an RCU read-side critical section is guaranteed to remain
-	unreclaimed for the full duration of that critical section.
+	kernels built with CONFIG_TREE_PREEMPT_RCU can preempt RCU
+	read-side critical sections.  Any RCU-protected data structure
+	accessed during an RCU read-side critical section is guaranteed to
+	remain unreclaimed for the full duration of that critical section.
 	Reference counts may be used in conjunction with RCU to maintain
 	longer-term references to data structures.
 
@@ -785,6 +785,7 @@ RCU pointer/list traversal:
 	rcu_dereference
 	list_for_each_entry_rcu
 	hlist_for_each_entry_rcu
+	hlist_nulls_for_each_entry_rcu
 
 	list_for_each_continue_rcu	(to be deprecated in favor of new
 					 list_for_each_entry_continue_rcu)
@@ -807,19 +808,23 @@ RCU:	Critical sections	Grace period		Barrier
 
 	rcu_read_lock		synchronize_net		rcu_barrier
 	rcu_read_unlock		synchronize_rcu
+				synchronize_rcu_expedited
 				call_rcu
 
 
 bh:	Critical sections	Grace period		Barrier
 
 	rcu_read_lock_bh	call_rcu_bh		rcu_barrier_bh
-	rcu_read_unlock_bh
+	rcu_read_unlock_bh	synchronize_rcu_bh
+				synchronize_rcu_bh_expedited
 
 
 sched:	Critical sections	Grace period		Barrier
 
-	[preempt_disable]	synchronize_sched	rcu_barrier_sched
-	[and friends]		call_rcu_sched
+	rcu_read_lock_sched	synchronize_sched	rcu_barrier_sched
+	rcu_read_unlock_sched	call_rcu_sched
+	[preempt_disable]	synchronize_sched_expedited
+	[and friends]
 
 
 SRCU:	Critical sections	Grace period		Barrier
@@ -827,6 +832,9 @@ SRCU:	Critical sections	Grace period		Barrier
 	srcu_read_lock		synchronize_srcu	N/A
 	srcu_read_unlock
 
+SRCU:	Initialization/cleanup
+	init_srcu_struct
+	cleanup_srcu_struct
 
 See the comment headers in the source code (or the docbook generated
 from them) for more information.
diff --git a/arch/ia64/xen/time.c b/arch/ia64/xen/time.c
index fb83326..dbeadb9 100644
--- a/arch/ia64/xen/time.c
+++ b/arch/ia64/xen/time.c
@@ -133,8 +133,7 @@ consider_steal_time(unsigned long new_itm)
 		account_idle_ticks(blocked);
 		run_local_timers();
 
-		if (rcu_pending(cpu))
-			rcu_check_callbacks(cpu, user_mode(get_irq_regs()));
+		rcu_check_callbacks(cpu, user_mode(get_irq_regs()));
 
 		scheduler_tick();
 		run_posix_cpu_timers(p);
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index 4d668e0..4753619 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -48,6 +48,15 @@ struct notifier_block;
 
 #ifdef CONFIG_SMP
 /* Need to know about CPUs going up/down? */
+#if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE)
+#define cpu_notifier(fn, pri) {					\
+	static struct notifier_block fn##_nb __cpuinitdata =	\
+		{ .notifier_call = fn, .priority = pri };	\
+	register_cpu_notifier(&fn##_nb);			\
+}
+#else /* #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
+#define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+#endif /* #else #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
 #ifdef CONFIG_HOTPLUG_CPU
 extern int register_cpu_notifier(struct notifier_block *nb);
 extern void unregister_cpu_notifier(struct notifier_block *nb);
@@ -74,6 +83,8 @@ extern void cpu_maps_update_done(void);
 
 #else	/* CONFIG_SMP */
 
+#define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
+
 static inline int register_cpu_notifier(struct notifier_block *nb)
 {
 	return 0;
@@ -99,11 +110,7 @@ extern struct sysdev_class cpu_sysdev_class;
 
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
-#define hotcpu_notifier(fn, pri) {				\
-	static struct notifier_block fn##_nb __cpuinitdata =	\
-		{ .notifier_call = fn, .priority = pri };	\
-	register_cpu_notifier(&fn##_nb);			\
-}
+#define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
 #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
 #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
 int cpu_down(unsigned int cpu);
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 8246c69..330cb31 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -132,7 +132,7 @@ static inline void account_system_vtime(struct task_struct *tsk)
 }
 #endif
 
-#if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU)
+#if defined(CONFIG_NO_HZ)
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
 extern void rcu_nmi_enter(void);
@@ -142,7 +142,7 @@ extern void rcu_nmi_exit(void);
 # define rcu_irq_exit() do { } while (0)
 # define rcu_nmi_enter() do { } while (0)
 # define rcu_nmi_exit() do { } while (0)
-#endif /* #if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU) */
+#endif /* #if defined(CONFIG_NO_HZ) */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
diff --git a/include/linux/init_task.h b/include/linux/init_task.h
index 7fc01b1..9e7f2e8 100644
--- a/include/linux/init_task.h
+++ b/include/linux/init_task.h
@@ -94,6 +94,16 @@ extern struct group_info init_groups;
 # define CAP_INIT_BSET  CAP_INIT_EFF_SET
 #endif
 
+#ifdef CONFIG_TREE_PREEMPT_RCU
+#define INIT_TASK_RCU_PREEMPT(tsk)					\
+	.rcu_read_lock_nesting = 0,					\
+	.rcu_read_unlock_special = 0,					\
+	.rcu_blocked_node = NULL,					\
+	.rcu_node_entry = LIST_HEAD_INIT(tsk.rcu_node_entry),
+#else
+#define INIT_TASK_RCU_PREEMPT(tsk)
+#endif
+
 extern struct cred init_cred;
 
 #ifdef CONFIG_PERF_COUNTERS
@@ -173,6 +183,7 @@ extern struct cred init_cred;
 	INIT_LOCKDEP							\
 	INIT_FTRACE_GRAPH						\
 	INIT_TRACE_RECURSION						\
+	INIT_TASK_RCU_PREEMPT(tsk)					\
 }
 
 
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index aec3252..ed5d750 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -132,7 +132,7 @@ static inline int page_cache_get_speculative(struct page *page)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
 # ifdef CONFIG_PREEMPT
 	VM_BUG_ON(!in_atomic());
 # endif
@@ -170,7 +170,7 @@ static inline int page_cache_add_speculative(struct page *page, int count)
 {
 	VM_BUG_ON(in_interrupt());
 
-#if !defined(CONFIG_SMP) && defined(CONFIG_CLASSIC_RCU)
+#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
 # ifdef CONFIG_PREEMPT
 	VM_BUG_ON(!in_atomic());
 # endif
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
deleted file mode 100644
index bfd92e1..0000000
--- a/include/linux/rcuclassic.h
+++ /dev/null
@@ -1,178 +0,0 @@
-/*
- * Read-Copy Update mechanism for mutual exclusion (classic version)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright IBM Corporation, 2001
- *
- * Author: Dipankar Sarma <dipankar@in.ibm.com>
- *
- * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
- * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
- * Papers:
- * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
- * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
- *
- * For detailed explanation of Read-Copy Update mechanism see -
- * 		Documentation/RCU
- *
- */
-
-#ifndef __LINUX_RCUCLASSIC_H
-#define __LINUX_RCUCLASSIC_H
-
-#include <linux/cache.h>
-#include <linux/spinlock.h>
-#include <linux/threads.h>
-#include <linux/cpumask.h>
-#include <linux/seqlock.h>
-
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-#define RCU_SECONDS_TILL_STALL_CHECK	(10 * HZ) /* for rcp->jiffies_stall */
-#define RCU_SECONDS_TILL_STALL_RECHECK	(30 * HZ) /* for rcp->jiffies_stall */
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-/* Global control variables for rcupdate callback mechanism. */
-struct rcu_ctrlblk {
-	long	cur;		/* Current batch number.                      */
-	long	completed;	/* Number of the last completed batch         */
-	long	pending;	/* Number of the last pending batch           */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-	unsigned long gp_start;	/* Time at which GP started in jiffies. */
-	unsigned long jiffies_stall;
-				/* Time at which to check for CPU stalls. */
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-	int	signaled;
-
-	spinlock_t	lock	____cacheline_internodealigned_in_smp;
-	DECLARE_BITMAP(cpumask, NR_CPUS); /* CPUs that need to switch for */
-					  /* current batch to proceed.     */
-} ____cacheline_internodealigned_in_smp;
-
-/* Is batch a before batch b ? */
-static inline int rcu_batch_before(long a, long b)
-{
-	return (a - b) < 0;
-}
-
-/* Is batch a after batch b ? */
-static inline int rcu_batch_after(long a, long b)
-{
-	return (a - b) > 0;
-}
-
-/* Per-CPU data for Read-Copy UPdate. */
-struct rcu_data {
-	/* 1) quiescent state handling : */
-	long		quiescbatch;     /* Batch # for grace period */
-	int		passed_quiesc;	 /* User-mode/idle loop etc. */
-	int		qs_pending;	 /* core waits for quiesc state */
-
-	/* 2) batch handling */
-	/*
-	 * if nxtlist is not NULL, then:
-	 * batch:
-	 *	The batch # for the last entry of nxtlist
-	 * [*nxttail[1], NULL = *nxttail[2]):
-	 *	Entries that batch # <= batch
-	 * [*nxttail[0], *nxttail[1]):
-	 *	Entries that batch # <= batch - 1
-	 * [nxtlist, *nxttail[0]):
-	 *	Entries that batch # <= batch - 2
-	 *	The grace period for these entries has completed, and
-	 *	the other grace-period-completed entries may be moved
-	 *	here temporarily in rcu_process_callbacks().
-	 */
-	long  	       	batch;
-	struct rcu_head *nxtlist;
-	struct rcu_head **nxttail[3];
-	long            qlen; 	 	 /* # of queued callbacks */
-	struct rcu_head *donelist;
-	struct rcu_head **donetail;
-	long		blimit;		 /* Upper limit on a processed batch */
-	int cpu;
-	struct rcu_head barrier;
-};
-
-/*
- * Increment the quiescent state counter.
- * The counter is a bit degenerated: We do not need to know
- * how many quiescent states passed, just if there was at least
- * one since the start of the grace period. Thus just a flag.
- */
-extern void rcu_qsctr_inc(int cpu);
-extern void rcu_bh_qsctr_inc(int cpu);
-
-extern int rcu_pending(int cpu);
-extern int rcu_needs_cpu(int cpu);
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern struct lockdep_map rcu_lock_map;
-# define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
-#else
-# define rcu_read_acquire()	do { } while (0)
-# define rcu_read_release()	do { } while (0)
-#endif
-
-#define __rcu_read_lock() \
-	do { \
-		preempt_disable(); \
-		__acquire(RCU); \
-		rcu_read_acquire(); \
-	} while (0)
-#define __rcu_read_unlock() \
-	do { \
-		rcu_read_release(); \
-		__release(RCU); \
-		preempt_enable(); \
-	} while (0)
-#define __rcu_read_lock_bh() \
-	do { \
-		local_bh_disable(); \
-		__acquire(RCU_BH); \
-		rcu_read_acquire(); \
-	} while (0)
-#define __rcu_read_unlock_bh() \
-	do { \
-		rcu_read_release(); \
-		__release(RCU_BH); \
-		local_bh_enable(); \
-	} while (0)
-
-#define __synchronize_sched() synchronize_rcu()
-
-#define call_rcu_sched(head, func) call_rcu(head, func)
-
-extern void __rcu_init(void);
-#define rcu_init_sched()	do { } while (0)
-extern void rcu_check_callbacks(int cpu, int user);
-extern void rcu_restart_cpu(int cpu);
-
-extern long rcu_batches_completed(void);
-extern long rcu_batches_completed_bh(void);
-
-#define rcu_enter_nohz()	do { } while (0)
-#define rcu_exit_nohz()		do { } while (0)
-
-/* A context switch is a grace period for rcuclassic. */
-static inline int rcu_blocking_is_gp(void)
-{
-	return num_online_cpus() == 1;
-}
-
-#endif /* __LINUX_RCUCLASSIC_H */
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 15fbb3c..95e0615 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -51,18 +51,26 @@ struct rcu_head {
 	void (*func)(struct rcu_head *head);
 };
 
-/* Internal to kernel, but needed by rcupreempt.h. */
+/* Exported common interfaces */
+extern void synchronize_rcu(void);
+extern void synchronize_rcu_bh(void);
+extern void rcu_barrier(void);
+extern void rcu_barrier_bh(void);
+extern void rcu_barrier_sched(void);
+extern void synchronize_sched_expedited(void);
+extern int sched_expedited_torture_stats(char *page);
+
+/* Internal to kernel */
+extern void rcu_init(void);
+extern void rcu_scheduler_starting(void);
+extern int rcu_needs_cpu(int cpu);
 extern int rcu_scheduler_active;
 
-#if defined(CONFIG_CLASSIC_RCU)
-#include <linux/rcuclassic.h>
-#elif defined(CONFIG_TREE_RCU)
+#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
-#elif defined(CONFIG_PREEMPT_RCU)
-#include <linux/rcupreempt.h>
 #else
 #error "Unknown RCU implementation specified to kernel configuration"
-#endif /* #else #if defined(CONFIG_CLASSIC_RCU) */
+#endif
 
 #define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
 #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
@@ -70,6 +78,16 @@ extern int rcu_scheduler_active;
        (ptr)->next = NULL; (ptr)->func = NULL; \
 } while (0)
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+extern struct lockdep_map rcu_lock_map;
+# define rcu_read_acquire()	\
+			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
+#else
+# define rcu_read_acquire()	do { } while (0)
+# define rcu_read_release()	do { } while (0)
+#endif
+
 /**
  * rcu_read_lock - mark the beginning of an RCU read-side critical section.
  *
@@ -99,7 +117,12 @@ extern int rcu_scheduler_active;
  *
  * It is illegal to block while in an RCU read-side critical section.
  */
-#define rcu_read_lock() __rcu_read_lock()
+static inline void rcu_read_lock(void)
+{
+	__rcu_read_lock();
+	__acquire(RCU);
+	rcu_read_acquire();
+}
 
 /**
  * rcu_read_unlock - marks the end of an RCU read-side critical section.
@@ -116,7 +139,12 @@ extern int rcu_scheduler_active;
  * used as well.  RCU does not care how the writers keep out of each
  * others' way, as long as they do so.
  */
-#define rcu_read_unlock() __rcu_read_unlock()
+static inline void rcu_read_unlock(void)
+{
+	rcu_read_release();
+	__release(RCU);
+	__rcu_read_unlock();
+}
 
 /**
  * rcu_read_lock_bh - mark the beginning of a softirq-only RCU critical section
@@ -129,14 +157,24 @@ extern int rcu_scheduler_active;
  * can use just rcu_read_lock().
  *
  */
-#define rcu_read_lock_bh() __rcu_read_lock_bh()
+static inline void rcu_read_lock_bh(void)
+{
+	__rcu_read_lock_bh();
+	__acquire(RCU_BH);
+	rcu_read_acquire();
+}
 
 /*
  * rcu_read_unlock_bh - marks the end of a softirq-only RCU critical section
  *
  * See rcu_read_lock_bh() for more information.
  */
-#define rcu_read_unlock_bh() __rcu_read_unlock_bh()
+static inline void rcu_read_unlock_bh(void)
+{
+	rcu_read_release();
+	__release(RCU_BH);
+	__rcu_read_unlock_bh();
+}
 
 /**
  * rcu_read_lock_sched - mark the beginning of a RCU-classic critical section
@@ -147,17 +185,34 @@ extern int rcu_scheduler_active;
  * - call_rcu_sched() and rcu_barrier_sched()
  * on the write-side to insure proper synchronization.
  */
-#define rcu_read_lock_sched() preempt_disable()
-#define rcu_read_lock_sched_notrace() preempt_disable_notrace()
+static inline void rcu_read_lock_sched(void)
+{
+	preempt_disable();
+	__acquire(RCU_SCHED);
+	rcu_read_acquire();
+}
+static inline notrace void rcu_read_lock_sched_notrace(void)
+{
+	preempt_disable_notrace();
+	__acquire(RCU_SCHED);
+}
 
 /*
  * rcu_read_unlock_sched - marks the end of a RCU-classic critical section
  *
  * See rcu_read_lock_sched for more information.
  */
-#define rcu_read_unlock_sched() preempt_enable()
-#define rcu_read_unlock_sched_notrace() preempt_enable_notrace()
-
+static inline void rcu_read_unlock_sched(void)
+{
+	rcu_read_release();
+	__release(RCU_SCHED);
+	preempt_enable();
+}
+static inline notrace void rcu_read_unlock_sched_notrace(void)
+{
+	__release(RCU_SCHED);
+	preempt_enable_notrace();
+}
 
 
 /**
@@ -259,15 +314,4 @@ extern void call_rcu(struct rcu_head *head,
 extern void call_rcu_bh(struct rcu_head *head,
 			void (*func)(struct rcu_head *head));
 
-/* Exported common interfaces */
-extern void synchronize_rcu(void);
-extern void rcu_barrier(void);
-extern void rcu_barrier_bh(void);
-extern void rcu_barrier_sched(void);
-
-/* Internal to kernel */
-extern void rcu_init(void);
-extern void rcu_scheduler_starting(void);
-extern int rcu_needs_cpu(int cpu);
-
 #endif /* __LINUX_RCUPDATE_H */
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
deleted file mode 100644
index fce5227..0000000
--- a/include/linux/rcupreempt.h
+++ /dev/null
@@ -1,127 +0,0 @@
-/*
- * Read-Copy Update mechanism for mutual exclusion (RT implementation)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright (C) IBM Corporation, 2006
- *
- * Author:  Paul McKenney <paulmck@us.ibm.com>
- *
- * Based on the original work by Paul McKenney <paul.mckenney@us.ibm.com>
- * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
- * Papers:
- * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
- * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
- *
- * For detailed explanation of Read-Copy Update mechanism see -
- * 		Documentation/RCU
- *
- */
-
-#ifndef __LINUX_RCUPREEMPT_H
-#define __LINUX_RCUPREEMPT_H
-
-#include <linux/cache.h>
-#include <linux/spinlock.h>
-#include <linux/threads.h>
-#include <linux/smp.h>
-#include <linux/cpumask.h>
-#include <linux/seqlock.h>
-
-extern void rcu_qsctr_inc(int cpu);
-static inline void rcu_bh_qsctr_inc(int cpu) { }
-
-/*
- * Someone might want to pass call_rcu_bh as a function pointer.
- * So this needs to just be a rename and not a macro function.
- *  (no parentheses)
- */
-#define call_rcu_bh		call_rcu
-
-/**
- * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
- * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
- *
- * The update function will be invoked some time after a full
- * synchronize_sched()-style grace period elapses, in other words after
- * all currently executing preempt-disabled sections of code (including
- * hardirq handlers, NMI handlers, and local_irq_save() blocks) have
- * completed.
- */
-extern void call_rcu_sched(struct rcu_head *head,
-			   void (*func)(struct rcu_head *head));
-
-extern void __rcu_read_lock(void)	__acquires(RCU);
-extern void __rcu_read_unlock(void)	__releases(RCU);
-extern int rcu_pending(int cpu);
-extern int rcu_needs_cpu(int cpu);
-
-#define __rcu_read_lock_bh()	{ rcu_read_lock(); local_bh_disable(); }
-#define __rcu_read_unlock_bh()	{ local_bh_enable(); rcu_read_unlock(); }
-
-extern void __synchronize_sched(void);
-
-extern void __rcu_init(void);
-extern void rcu_init_sched(void);
-extern void rcu_check_callbacks(int cpu, int user);
-extern void rcu_restart_cpu(int cpu);
-extern long rcu_batches_completed(void);
-
-/*
- * Return the number of RCU batches processed thus far. Useful for debug
- * and statistic. The _bh variant is identifcal to straight RCU
- */
-static inline long rcu_batches_completed_bh(void)
-{
-	return rcu_batches_completed();
-}
-
-#ifdef CONFIG_RCU_TRACE
-struct rcupreempt_trace;
-extern long *rcupreempt_flipctr(int cpu);
-extern long rcupreempt_data_completed(void);
-extern int rcupreempt_flip_flag(int cpu);
-extern int rcupreempt_mb_flag(int cpu);
-extern char *rcupreempt_try_flip_state_name(void);
-extern struct rcupreempt_trace *rcupreempt_trace_cpu(int cpu);
-#endif
-
-struct softirq_action;
-
-#ifdef CONFIG_NO_HZ
-extern void rcu_enter_nohz(void);
-extern void rcu_exit_nohz(void);
-#else
-# define rcu_enter_nohz()	do { } while (0)
-# define rcu_exit_nohz()	do { } while (0)
-#endif
-
-/*
- * A context switch is a grace period for rcupreempt synchronize_rcu()
- * only during early boot, before the scheduler has been initialized.
- * So, how the heck do we get a context switch?  Well, if the caller
- * invokes synchronize_rcu(), they are willing to accept a context
- * switch, so we simply pretend that one happened.
- *
- * After boot, there might be a blocked or preempted task in an RCU
- * read-side critical section, so we cannot then take the fastpath.
- */
-static inline int rcu_blocking_is_gp(void)
-{
-	return num_online_cpus() == 1 && !rcu_scheduler_active;
-}
-
-#endif /* __LINUX_RCUPREEMPT_H */
diff --git a/include/linux/rcupreempt_trace.h b/include/linux/rcupreempt_trace.h
deleted file mode 100644
index b99ae07..0000000
--- a/include/linux/rcupreempt_trace.h
+++ /dev/null
@@ -1,97 +0,0 @@
-/*
- * Read-Copy Update mechanism for mutual exclusion (RT implementation)
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright (C) IBM Corporation, 2006
- *
- * Author:  Paul McKenney <paulmck@us.ibm.com>
- *
- * Based on the original work by Paul McKenney <paul.mckenney@us.ibm.com>
- * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
- * Papers:
- * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
- * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
- *
- * For detailed explanation of the Preemptible Read-Copy Update mechanism see -
- * 		 http://lwn.net/Articles/253651/
- */
-
-#ifndef __LINUX_RCUPREEMPT_TRACE_H
-#define __LINUX_RCUPREEMPT_TRACE_H
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-
-#include <asm/atomic.h>
-
-/*
- * PREEMPT_RCU data structures.
- */
-
-struct rcupreempt_trace {
-	long		next_length;
-	long		next_add;
-	long		wait_length;
-	long		wait_add;
-	long		done_length;
-	long		done_add;
-	long		done_remove;
-	atomic_t	done_invoked;
-	long		rcu_check_callbacks;
-	atomic_t	rcu_try_flip_1;
-	atomic_t	rcu_try_flip_e1;
-	long		rcu_try_flip_i1;
-	long		rcu_try_flip_ie1;
-	long		rcu_try_flip_g1;
-	long		rcu_try_flip_a1;
-	long		rcu_try_flip_ae1;
-	long		rcu_try_flip_a2;
-	long		rcu_try_flip_z1;
-	long		rcu_try_flip_ze1;
-	long		rcu_try_flip_z2;
-	long		rcu_try_flip_m1;
-	long		rcu_try_flip_me1;
-	long		rcu_try_flip_m2;
-};
-
-#ifdef CONFIG_RCU_TRACE
-#define RCU_TRACE(fn, arg) 	fn(arg);
-#else
-#define RCU_TRACE(fn, arg)
-#endif
-
-extern void rcupreempt_trace_move2done(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_move2wait(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_e1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_i1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_ie1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_g1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_a1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_ae1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_a2(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_z1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_ze1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_z2(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_m1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_me1(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_try_flip_m2(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_check_callbacks(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_done_remove(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_invoke(struct rcupreempt_trace *trace);
-extern void rcupreempt_trace_next_add(struct rcupreempt_trace *trace);
-
-#endif /* __LINUX_RCUPREEMPT_TRACE_H */
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 5a51538..a893077 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -30,264 +30,57 @@
 #ifndef __LINUX_RCUTREE_H
 #define __LINUX_RCUTREE_H
 
-#include <linux/cache.h>
-#include <linux/spinlock.h>
-#include <linux/threads.h>
-#include <linux/cpumask.h>
-#include <linux/seqlock.h>
+extern void rcu_sched_qs(int cpu);
+extern void rcu_bh_qs(int cpu);
 
-/*
- * Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT.
- * In theory, it should be possible to add more levels straightforwardly.
- * In practice, this has not been tested, so there is probably some
- * bug somewhere.
- */
-#define MAX_RCU_LVLS 3
-#define RCU_FANOUT	      (CONFIG_RCU_FANOUT)
-#define RCU_FANOUT_SQ	      (RCU_FANOUT * RCU_FANOUT)
-#define RCU_FANOUT_CUBE	      (RCU_FANOUT_SQ * RCU_FANOUT)
-
-#if NR_CPUS <= RCU_FANOUT
-#  define NUM_RCU_LVLS	      1
-#  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      (NR_CPUS)
-#  define NUM_RCU_LVL_2	      0
-#  define NUM_RCU_LVL_3	      0
-#elif NR_CPUS <= RCU_FANOUT_SQ
-#  define NUM_RCU_LVLS	      2
-#  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
-#  define NUM_RCU_LVL_2	      (NR_CPUS)
-#  define NUM_RCU_LVL_3	      0
-#elif NR_CPUS <= RCU_FANOUT_CUBE
-#  define NUM_RCU_LVLS	      3
-#  define NUM_RCU_LVL_0	      1
-#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
-#  define NUM_RCU_LVL_2	      (((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
-#  define NUM_RCU_LVL_3	      NR_CPUS
-#else
-# error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
-#endif /* #if (NR_CPUS) <= RCU_FANOUT */
-
-#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
-#define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
-
-/*
- * Dynticks per-CPU state.
- */
-struct rcu_dynticks {
-	int dynticks_nesting;	/* Track nesting level, sort of. */
-	int dynticks;		/* Even value for dynticks-idle, else odd. */
-	int dynticks_nmi;	/* Even value for either dynticks-idle or */
-				/*  not in nmi handler, else odd.  So this */
-				/*  remains even for nmi from irq handler. */
-};
-
-/*
- * Definition for node within the RCU grace-period-detection hierarchy.
- */
-struct rcu_node {
-	spinlock_t lock;
-	unsigned long qsmask;	/* CPUs or groups that need to switch in */
-				/*  order for current grace period to proceed.*/
-	unsigned long qsmaskinit;
-				/* Per-GP initialization for qsmask. */
-	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
-	int	grplo;		/* lowest-numbered CPU or group here. */
-	int	grphi;		/* highest-numbered CPU or group here. */
-	u8	grpnum;		/* CPU/group number for next level up. */
-	u8	level;		/* root is at level 0. */
-	struct rcu_node *parent;
-} ____cacheline_internodealigned_in_smp;
-
-/* Index values for nxttail array in struct rcu_data. */
-#define RCU_DONE_TAIL		0	/* Also RCU_WAIT head. */
-#define RCU_WAIT_TAIL		1	/* Also RCU_NEXT_READY head. */
-#define RCU_NEXT_READY_TAIL	2	/* Also RCU_NEXT head. */
-#define RCU_NEXT_TAIL		3
-#define RCU_NEXT_SIZE		4
-
-/* Per-CPU data for read-copy update. */
-struct rcu_data {
-	/* 1) quiescent-state and grace-period handling : */
-	long		completed;	/* Track rsp->completed gp number */
-					/*  in order to detect GP end. */
-	long		gpnum;		/* Highest gp number that this CPU */
-					/*  is aware of having started. */
-	long		passed_quiesc_completed;
-					/* Value of completed at time of qs. */
-	bool		passed_quiesc;	/* User-mode/idle loop etc. */
-	bool		qs_pending;	/* Core waits for quiesc state. */
-	bool		beenonline;	/* CPU online at least once. */
-	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
-	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
-
-	/* 2) batch handling */
-	/*
-	 * If nxtlist is not NULL, it is partitioned as follows.
-	 * Any of the partitions might be empty, in which case the
-	 * pointer to that partition will be equal to the pointer for
-	 * the following partition.  When the list is empty, all of
-	 * the nxttail elements point to nxtlist, which is NULL.
-	 *
-	 * [*nxttail[RCU_NEXT_READY_TAIL], NULL = *nxttail[RCU_NEXT_TAIL]):
-	 *	Entries that might have arrived after current GP ended
-	 * [*nxttail[RCU_WAIT_TAIL], *nxttail[RCU_NEXT_READY_TAIL]):
-	 *	Entries known to have arrived before current GP ended
-	 * [*nxttail[RCU_DONE_TAIL], *nxttail[RCU_WAIT_TAIL]):
-	 *	Entries that batch # <= ->completed - 1: waiting for current GP
-	 * [nxtlist, *nxttail[RCU_DONE_TAIL]):
-	 *	Entries that batch # <= ->completed
-	 *	The grace period for these entries has completed, and
-	 *	the other grace-period-completed entries may be moved
-	 *	here temporarily in rcu_process_callbacks().
-	 */
-	struct rcu_head *nxtlist;
-	struct rcu_head **nxttail[RCU_NEXT_SIZE];
-	long		qlen; 	 	/* # of queued callbacks */
-	long		blimit;		/* Upper limit on a processed batch */
-
-#ifdef CONFIG_NO_HZ
-	/* 3) dynticks interface. */
-	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
-	int dynticks_snap;		/* Per-GP tracking for dynticks. */
-	int dynticks_nmi_snap;		/* Per-GP tracking for dynticks_nmi. */
-#endif /* #ifdef CONFIG_NO_HZ */
-
-	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
-#ifdef CONFIG_NO_HZ
-	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
-#endif /* #ifdef CONFIG_NO_HZ */
-	unsigned long offline_fqs;	/* Kicked due to being offline. */
-	unsigned long resched_ipi;	/* Sent a resched IPI. */
-
-	/* 5) __rcu_pending() statistics. */
-	long n_rcu_pending;		/* rcu_pending() calls since boot. */
-	long n_rp_qs_pending;
-	long n_rp_cb_ready;
-	long n_rp_cpu_needs_gp;
-	long n_rp_gp_completed;
-	long n_rp_gp_started;
-	long n_rp_need_fqs;
-	long n_rp_need_nothing;
-
-	int cpu;
-};
-
-/* Values for signaled field in struct rcu_state. */
-#define RCU_GP_INIT		0	/* Grace period being initialized. */
-#define RCU_SAVE_DYNTICK	1	/* Need to scan dyntick state. */
-#define RCU_FORCE_QS		2	/* Need to force quiescent state. */
-#ifdef CONFIG_NO_HZ
-#define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
-#else /* #ifdef CONFIG_NO_HZ */
-#define RCU_SIGNAL_INIT		RCU_FORCE_QS
-#endif /* #else #ifdef CONFIG_NO_HZ */
-
-#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-#define RCU_SECONDS_TILL_STALL_CHECK   (10 * HZ)  /* for rsp->jiffies_stall */
-#define RCU_SECONDS_TILL_STALL_RECHECK (30 * HZ)  /* for rsp->jiffies_stall */
-#define RCU_STALL_RAT_DELAY		2	  /* Allow other CPUs time */
-						  /*  to take at least one */
-						  /*  scheduling clock irq */
-						  /*  before ratting on them. */
-
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-/*
- * RCU global state, including node hierarchy.  This hierarchy is
- * represented in "heap" form in a dense array.  The root (first level)
- * of the hierarchy is in ->node[0] (referenced by ->level[0]), the second
- * level in ->node[1] through ->node[m] (->node[1] referenced by ->level[1]),
- * and the third level in ->node[m+1] and following (->node[m+1] referenced
- * by ->level[2]).  The number of levels is determined by the number of
- * CPUs and by CONFIG_RCU_FANOUT.  Small systems will have a "hierarchy"
- * consisting of a single rcu_node.
- */
-struct rcu_state {
-	struct rcu_node node[NUM_RCU_NODES];	/* Hierarchy. */
-	struct rcu_node *level[NUM_RCU_LVLS];	/* Hierarchy levels. */
-	u32 levelcnt[MAX_RCU_LVLS + 1];		/* # nodes in each level. */
-	u8 levelspread[NUM_RCU_LVLS];		/* kids/node in each level. */
-	struct rcu_data *rda[NR_CPUS];		/* array of rdp pointers. */
-
-	/* The following fields are guarded by the root rcu_node's lock. */
-
-	u8	signaled ____cacheline_internodealigned_in_smp;
-						/* Force QS state. */
-	long	gpnum;				/* Current gp number. */
-	long	completed;			/* # of last completed gp. */
-	spinlock_t onofflock;			/* exclude on/offline and */
-						/*  starting new GP. */
-	spinlock_t fqslock;			/* Only one task forcing */
-						/*  quiescent states. */
-	unsigned long jiffies_force_qs;		/* Time at which to invoke */
-						/*  force_quiescent_state(). */
-	unsigned long n_force_qs;		/* Number of calls to */
-						/*  force_quiescent_state(). */
-	unsigned long n_force_qs_lh;		/* ~Number of calls leaving */
-						/*  due to lock unavailable. */
-	unsigned long n_force_qs_ngp;		/* Number of calls leaving */
-						/*  due to no GP active. */
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-	unsigned long gp_start;			/* Time at which GP started, */
-						/*  but in jiffies. */
-	unsigned long jiffies_stall;		/* Time at which to check */
-						/*  for CPU stalls. */
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-#ifdef CONFIG_NO_HZ
-	long dynticks_completed;		/* Value of completed @ snap. */
-#endif /* #ifdef CONFIG_NO_HZ */
-};
+extern int rcu_needs_cpu(int cpu);
 
-extern void rcu_qsctr_inc(int cpu);
-extern void rcu_bh_qsctr_inc(int cpu);
+#ifdef CONFIG_TREE_PREEMPT_RCU
 
-extern int rcu_pending(int cpu);
-extern int rcu_needs_cpu(int cpu);
+extern void __rcu_read_lock(void);
+extern void __rcu_read_unlock(void);
+extern void exit_rcu(void);
 
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-extern struct lockdep_map rcu_lock_map;
-# define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
-# define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
-#else
-# define rcu_read_acquire()	do { } while (0)
-# define rcu_read_release()	do { } while (0)
-#endif
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 static inline void __rcu_read_lock(void)
 {
 	preempt_disable();
-	__acquire(RCU);
-	rcu_read_acquire();
 }
+
 static inline void __rcu_read_unlock(void)
 {
-	rcu_read_release();
-	__release(RCU);
 	preempt_enable();
 }
+
+static inline void exit_rcu(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
+
 static inline void __rcu_read_lock_bh(void)
 {
 	local_bh_disable();
-	__acquire(RCU_BH);
-	rcu_read_acquire();
 }
 static inline void __rcu_read_unlock_bh(void)
 {
-	rcu_read_release();
-	__release(RCU_BH);
 	local_bh_enable();
 }
 
 #define __synchronize_sched() synchronize_rcu()
 
-#define call_rcu_sched(head, func) call_rcu(head, func)
+extern void call_rcu_sched(struct rcu_head *head,
+			   void (*func)(struct rcu_head *rcu));
 
-static inline void rcu_init_sched(void)
+static inline void synchronize_rcu_expedited(void)
 {
+	synchronize_sched_expedited();
+}
+
+static inline void synchronize_rcu_bh_expedited(void)
+{
+	synchronize_sched_expedited();
 }
 
 extern void __rcu_init(void);
@@ -296,6 +89,11 @@ extern void rcu_restart_cpu(int cpu);
 
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
+extern long rcu_batches_completed_sched(void);
+
+static inline void rcu_init_sched(void)
+{
+}
 
 #ifdef CONFIG_NO_HZ
 void rcu_enter_nohz(void);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0f1ea4a..bd2675e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1163,6 +1163,8 @@ struct sched_rt_entity {
 #endif
 };
 
+struct rcu_node;
+
 struct task_struct {
 	volatile long state;	/* -1 unrunnable, 0 runnable, >0 stopped */
 	void *stack;
@@ -1206,10 +1208,12 @@ struct task_struct {
 	unsigned int policy;
 	cpumask_t cpus_allowed;
 
-#ifdef CONFIG_PREEMPT_RCU
+#ifdef CONFIG_TREE_PREEMPT_RCU
 	int rcu_read_lock_nesting;
-	int rcu_flipctr_idx;
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
+	char rcu_read_unlock_special;
+	struct rcu_node *rcu_blocked_node;
+	struct list_head rcu_node_entry;
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 #if defined(CONFIG_SCHEDSTATS) || defined(CONFIG_TASK_DELAY_ACCT)
 	struct sched_info sched_info;
@@ -1724,6 +1728,28 @@ extern cputime_t task_gtime(struct task_struct *p);
 #define tsk_used_math(p) ((p)->flags & PF_USED_MATH)
 #define used_math() tsk_used_math(current)
 
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
+#define RCU_READ_UNLOCK_BLOCKED (1 << 0) /* blocked while in RCU read-side. */
+#define RCU_READ_UNLOCK_NEED_QS (1 << 1) /* RCU core needs CPU response. */
+#define RCU_READ_UNLOCK_GOT_QS  (1 << 2) /* CPU has responded to RCU core. */
+
+static inline void rcu_copy_process(struct task_struct *p)
+{
+	p->rcu_read_lock_nesting = 0;
+	p->rcu_read_unlock_special = 0;
+	p->rcu_blocked_node = NULL;
+	INIT_LIST_HEAD(&p->rcu_node_entry);
+}
+
+#else
+
+static inline void rcu_copy_process(struct task_struct *p)
+{
+}
+
+#endif
+
 #ifdef CONFIG_SMP
 extern int set_cpus_allowed_ptr(struct task_struct *p,
 				const struct cpumask *new_mask);
diff --git a/init/Kconfig b/init/Kconfig
index 3f7e609..8e8b76d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -316,38 +316,28 @@ choice
 	prompt "RCU Implementation"
 	default TREE_RCU
 
-config CLASSIC_RCU
-	bool "Classic RCU"
-	help
-	  This option selects the classic RCU implementation that is
-	  designed for best read-side performance on non-realtime
-	  systems.
-
-	  Select this option if you are unsure.
-
 config TREE_RCU
 	bool "Tree-based hierarchical RCU"
 	help
 	  This option selects the RCU implementation that is
 	  designed for very large SMP system with hundreds or
-	  thousands of CPUs.
+	  thousands of CPUs.  It also scales down nicely to
+	  smaller systems.
 
-config PREEMPT_RCU
-	bool "Preemptible RCU"
+config TREE_PREEMPT_RCU
+	bool "Preemptable tree-based hierarchical RCU"
 	depends on PREEMPT
 	help
-	  This option reduces the latency of the kernel by making certain
-	  RCU sections preemptible. Normally RCU code is non-preemptible, if
-	  this option is selected then read-only RCU sections become
-	  preemptible. This helps latency, but may expose bugs due to
-	  now-naive assumptions about each RCU read-side critical section
-	  remaining on a given CPU through its execution.
+	  This option selects the RCU implementation that is
+	  designed for very large SMP systems with hundreds or
+	  thousands of CPUs, but for which real-time response
+	  is also required.
 
 endchoice
 
 config RCU_TRACE
 	bool "Enable tracing for RCU"
-	depends on TREE_RCU || PREEMPT_RCU
+	depends on TREE_RCU || TREE_PREEMPT_RCU
 	help
 	  This option provides tracing in RCU which presents stats
 	  in debugfs for debugging RCU implementation.
@@ -359,7 +349,7 @@ config RCU_FANOUT
 	int "Tree-based hierarchical RCU fanout value"
 	range 2 64 if 64BIT
 	range 2 32 if !64BIT
-	depends on TREE_RCU
+	depends on TREE_RCU || TREE_PREEMPT_RCU
 	default 64 if 64BIT
 	default 32 if !64BIT
 	help
@@ -374,7 +364,7 @@ config RCU_FANOUT
 
 config RCU_FANOUT_EXACT
 	bool "Disable tree-based hierarchical RCU auto-balancing"
-	depends on TREE_RCU
+	depends on TREE_RCU || TREE_PREEMPT_RCU
 	default n
 	help
 	  This option forces use of the exact RCU_FANOUT value specified,
@@ -387,18 +377,12 @@ config RCU_FANOUT_EXACT
 	  Say N if unsure.
 
 config TREE_RCU_TRACE
-	def_bool RCU_TRACE && TREE_RCU
-	select DEBUG_FS
-	help
-	  This option provides tracing for the TREE_RCU implementation,
-	  permitting Makefile to trivially select kernel/rcutree_trace.c.
-
-config PREEMPT_RCU_TRACE
-	def_bool RCU_TRACE && PREEMPT_RCU
+	def_bool RCU_TRACE && ( TREE_RCU || TREE_PREEMPT_RCU )
 	select DEBUG_FS
 	help
-	  This option provides tracing for the PREEMPT_RCU implementation,
-	  permitting Makefile to trivially select kernel/rcupreempt_trace.c.
+	  This option provides tracing for the TREE_RCU and
+	  TREE_PREEMPT_RCU implementations, permitting Makefile to
+	  trivially select kernel/rcutree_trace.c.
 
 endmenu # "RCU Subsystem"
 
diff --git a/init/main.c b/init/main.c
index 11f4f14..525f6fb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -451,6 +451,7 @@ static noinline void __init_refok rest_init(void)
 {
 	int pid;
 
+	rcu_scheduler_starting();
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
@@ -462,7 +463,6 @@ static noinline void __init_refok rest_init(void)
 	 * at least once to get things moving:
 	 */
 	init_idle_bootup_task(current);
-	rcu_scheduler_starting();
 	preempt_enable_no_resched();
 	schedule();
 	preempt_disable();
diff --git a/kernel/Makefile b/kernel/Makefile
index 2093a69..b833bd5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -80,11 +80,9 @@ obj-$(CONFIG_DETECT_HUNG_TASK) += hung_task.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
-obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
 obj-$(CONFIG_TREE_RCU) += rcutree.o
-obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
+obj-$(CONFIG_TREE_PREEMPT_RCU) += rcutree.o
 obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
-obj-$(CONFIG_PREEMPT_RCU_TRACE) += rcupreempt_trace.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
diff --git a/kernel/exit.c b/kernel/exit.c
index 869dc22..263f95e 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1010,6 +1010,7 @@ NORET_TYPE void do_exit(long code)
 		__free_pipe_info(tsk->splice_pipe);
 
 	preempt_disable();
+	exit_rcu();
 	/* causes final put_task_struct in finish_task_switch(). */
 	tsk->state = TASK_DEAD;
 	schedule();
diff --git a/kernel/fork.c b/kernel/fork.c
index e6c04d4..637520c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1008,10 +1008,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	copy_flags(clone_flags, p);
 	INIT_LIST_HEAD(&p->children);
 	INIT_LIST_HEAD(&p->sibling);
-#ifdef CONFIG_PREEMPT_RCU
-	p->rcu_read_lock_nesting = 0;
-	p->rcu_flipctr_idx = 0;
-#endif /* #ifdef CONFIG_PREEMPT_RCU */
+	rcu_copy_process(p);
 	p->vfork_done = NULL;
 	spin_lock_init(&p->alloc_lock);
 
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
deleted file mode 100644
index 0f2b0b3..0000000
--- a/kernel/rcuclassic.c
+++ /dev/null
@@ -1,807 +0,0 @@
-/*
- * Read-Copy Update mechanism for mutual exclusion
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright IBM Corporation, 2001
- *
- * Authors: Dipankar Sarma <dipankar@in.ibm.com>
- *	    Manfred Spraul <manfred@colorfullife.com>
- *
- * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
- * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
- * Papers:
- * http://www.rdrop.com/users/paulmck/paper/rclockpdcsproof.pdf
- * http://lse.sourceforge.net/locking/rclock_OLS.2001.05.01c.sc.pdf (OLS2001)
- *
- * For detailed explanation of Read-Copy Update mechanism see -
- * 		Documentation/RCU
- *
- */
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-#include <linux/smp.h>
-#include <linux/rcupdate.h>
-#include <linux/interrupt.h>
-#include <linux/sched.h>
-#include <asm/atomic.h>
-#include <linux/bitops.h>
-#include <linux/module.h>
-#include <linux/completion.h>
-#include <linux/moduleparam.h>
-#include <linux/percpu.h>
-#include <linux/notifier.h>
-#include <linux/cpu.h>
-#include <linux/mutex.h>
-#include <linux/time.h>
-
-#ifdef CONFIG_DEBUG_LOCK_ALLOC
-static struct lock_class_key rcu_lock_key;
-struct lockdep_map rcu_lock_map =
-	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
-EXPORT_SYMBOL_GPL(rcu_lock_map);
-#endif
-
-
-/* Definition for rcupdate control block. */
-static struct rcu_ctrlblk rcu_ctrlblk = {
-	.cur = -300,
-	.completed = -300,
-	.pending = -300,
-	.lock = __SPIN_LOCK_UNLOCKED(&rcu_ctrlblk.lock),
-	.cpumask = CPU_BITS_NONE,
-};
-
-static struct rcu_ctrlblk rcu_bh_ctrlblk = {
-	.cur = -300,
-	.completed = -300,
-	.pending = -300,
-	.lock = __SPIN_LOCK_UNLOCKED(&rcu_bh_ctrlblk.lock),
-	.cpumask = CPU_BITS_NONE,
-};
-
-static DEFINE_PER_CPU(struct rcu_data, rcu_data);
-static DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
-
-/*
- * Increment the quiescent state counter.
- * The counter is a bit degenerated: We do not need to know
- * how many quiescent states passed, just if there was at least
- * one since the start of the grace period. Thus just a flag.
- */
-void rcu_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	rdp->passed_quiesc = 1;
-}
-
-void rcu_bh_qsctr_inc(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
-	rdp->passed_quiesc = 1;
-}
-
-static int blimit = 10;
-static int qhimark = 10000;
-static int qlowmark = 100;
-
-#ifdef CONFIG_SMP
-static void force_quiescent_state(struct rcu_data *rdp,
-			struct rcu_ctrlblk *rcp)
-{
-	int cpu;
-	unsigned long flags;
-
-	set_need_resched();
-	spin_lock_irqsave(&rcp->lock, flags);
-	if (unlikely(!rcp->signaled)) {
-		rcp->signaled = 1;
-		/*
-		 * Don't send IPI to itself. With irqs disabled,
-		 * rdp->cpu is the current cpu.
-		 *
-		 * cpu_online_mask is updated by the _cpu_down()
-		 * using __stop_machine(). Since we're in irqs disabled
-		 * section, __stop_machine() is not exectuting, hence
-		 * the cpu_online_mask is stable.
-		 *
-		 * However,  a cpu might have been offlined _just_ before
-		 * we disabled irqs while entering here.
-		 * And rcu subsystem might not yet have handled the CPU_DEAD
-		 * notification, leading to the offlined cpu's bit
-		 * being set in the rcp->cpumask.
-		 *
-		 * Hence cpumask = (rcp->cpumask & cpu_online_mask) to prevent
-		 * sending smp_reschedule() to an offlined CPU.
-		 */
-		for_each_cpu_and(cpu,
-				  to_cpumask(rcp->cpumask), cpu_online_mask) {
-			if (cpu != rdp->cpu)
-				smp_send_reschedule(cpu);
-		}
-	}
-	spin_unlock_irqrestore(&rcp->lock, flags);
-}
-#else
-static inline void force_quiescent_state(struct rcu_data *rdp,
-			struct rcu_ctrlblk *rcp)
-{
-	set_need_resched();
-}
-#endif
-
-static void __call_rcu(struct rcu_head *head, struct rcu_ctrlblk *rcp,
-		struct rcu_data *rdp)
-{
-	long batch;
-
-	head->next = NULL;
-	smp_mb(); /* Read of rcu->cur must happen after any change by caller. */
-
-	/*
-	 * Determine the batch number of this callback.
-	 *
-	 * Using ACCESS_ONCE to avoid the following error when gcc eliminates
-	 * local variable "batch" and emits codes like this:
-	 *	1) rdp->batch = rcp->cur + 1 # gets old value
-	 *	......
-	 *	2)rcu_batch_after(rcp->cur + 1, rdp->batch) # gets new value
-	 * then [*nxttail[0], *nxttail[1]) may contain callbacks
-	 * that batch# = rdp->batch, see the comment of struct rcu_data.
-	 */
-	batch = ACCESS_ONCE(rcp->cur) + 1;
-
-	if (rdp->nxtlist && rcu_batch_after(batch, rdp->batch)) {
-		/* process callbacks */
-		rdp->nxttail[0] = rdp->nxttail[1];
-		rdp->nxttail[1] = rdp->nxttail[2];
-		if (rcu_batch_after(batch - 1, rdp->batch))
-			rdp->nxttail[0] = rdp->nxttail[2];
-	}
-
-	rdp->batch = batch;
-	*rdp->nxttail[2] = head;
-	rdp->nxttail[2] = &head->next;
-
-	if (unlikely(++rdp->qlen > qhimark)) {
-		rdp->blimit = INT_MAX;
-		force_quiescent_state(rdp, &rcu_ctrlblk);
-	}
-}
-
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-
-static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
-{
-	rcp->gp_start = jiffies;
-	rcp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_CHECK;
-}
-
-static void print_other_cpu_stall(struct rcu_ctrlblk *rcp)
-{
-	int cpu;
-	long delta;
-	unsigned long flags;
-
-	/* Only let one CPU complain about others per time interval. */
-
-	spin_lock_irqsave(&rcp->lock, flags);
-	delta = jiffies - rcp->jiffies_stall;
-	if (delta < 2 || rcp->cur != rcp->completed) {
-		spin_unlock_irqrestore(&rcp->lock, flags);
-		return;
-	}
-	rcp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
-	spin_unlock_irqrestore(&rcp->lock, flags);
-
-	/* OK, time to rat on our buddy... */
-
-	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
-	for_each_possible_cpu(cpu) {
-		if (cpumask_test_cpu(cpu, to_cpumask(rcp->cpumask)))
-			printk(" %d", cpu);
-	}
-	printk(" (detected by %d, t=%ld jiffies)\n",
-	       smp_processor_id(), (long)(jiffies - rcp->gp_start));
-}
-
-static void print_cpu_stall(struct rcu_ctrlblk *rcp)
-{
-	unsigned long flags;
-
-	printk(KERN_ERR "INFO: RCU detected CPU %d stall (t=%lu/%lu jiffies)\n",
-			smp_processor_id(), jiffies,
-			jiffies - rcp->gp_start);
-	dump_stack();
-	spin_lock_irqsave(&rcp->lock, flags);
-	if ((long)(jiffies - rcp->jiffies_stall) >= 0)
-		rcp->jiffies_stall =
-			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
-	spin_unlock_irqrestore(&rcp->lock, flags);
-	set_need_resched();  /* kick ourselves to get things going. */
-}
-
-static void check_cpu_stall(struct rcu_ctrlblk *rcp)
-{
-	long delta;
-
-	delta = jiffies - rcp->jiffies_stall;
-	if (cpumask_test_cpu(smp_processor_id(), to_cpumask(rcp->cpumask)) &&
-		delta >= 0) {
-
-		/* We haven't checked in, so go dump stack. */
-		print_cpu_stall(rcp);
-
-	} else if (rcp->cur != rcp->completed && delta >= 2) {
-
-		/* They had two seconds to dump stack, so complain. */
-		print_other_cpu_stall(rcp);
-	}
-}
-
-#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-static void record_gp_stall_check_time(struct rcu_ctrlblk *rcp)
-{
-}
-
-static inline void check_cpu_stall(struct rcu_ctrlblk *rcp)
-{
-}
-
-#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-
-/**
- * call_rcu - Queue an RCU callback for invocation after a grace period.
- * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
- *
- * The update function will be invoked some time after a full grace
- * period elapses, in other words after all currently executing RCU
- * read-side critical sections have completed.  RCU read-side critical
- * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
- * and may be nested.
- */
-void call_rcu(struct rcu_head *head,
-				void (*func)(struct rcu_head *rcu))
-{
-	unsigned long flags;
-
-	head->func = func;
-	local_irq_save(flags);
-	__call_rcu(head, &rcu_ctrlblk, &__get_cpu_var(rcu_data));
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(call_rcu);
-
-/**
- * call_rcu_bh - Queue an RCU for invocation after a quicker grace period.
- * @head: structure to be used for queueing the RCU updates.
- * @func: actual update function to be invoked after the grace period
- *
- * The update function will be invoked some time after a full grace
- * period elapses, in other words after all currently executing RCU
- * read-side critical sections have completed. call_rcu_bh() assumes
- * that the read-side critical sections end on completion of a softirq
- * handler. This means that read-side critical sections in process
- * context must not be interrupted by softirqs. This interface is to be
- * used when most of the read-side critical sections are in softirq context.
- * RCU read-side critical sections are delimited by rcu_read_lock() and
- * rcu_read_unlock(), * if in interrupt context or rcu_read_lock_bh()
- * and rcu_read_unlock_bh(), if in process context. These may be nested.
- */
-void call_rcu_bh(struct rcu_head *head,
-				void (*func)(struct rcu_head *rcu))
-{
-	unsigned long flags;
-
-	head->func = func;
-	local_irq_save(flags);
-	__call_rcu(head, &rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
-	local_irq_restore(flags);
-}
-EXPORT_SYMBOL_GPL(call_rcu_bh);
-
-/*
- * Return the number of RCU batches processed thus far.  Useful
- * for debug and statistics.
- */
-long rcu_batches_completed(void)
-{
-	return rcu_ctrlblk.completed;
-}
-EXPORT_SYMBOL_GPL(rcu_batches_completed);
-
-/*
- * Return the number of RCU batches processed thus far.  Useful
- * for debug and statistics.
- */
-long rcu_batches_completed_bh(void)
-{
-	return rcu_bh_ctrlblk.completed;
-}
-EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
-
-/* Raises the softirq for processing rcu_callbacks. */
-static inline void raise_rcu_softirq(void)
-{
-	raise_softirq(RCU_SOFTIRQ);
-}
-
-/*
- * Invoke the completed RCU callbacks. They are expected to be in
- * a per-cpu list.
- */
-static void rcu_do_batch(struct rcu_data *rdp)
-{
-	unsigned long flags;
-	struct rcu_head *next, *list;
-	int count = 0;
-
-	list = rdp->donelist;
-	while (list) {
-		next = list->next;
-		prefetch(next);
-		list->func(list);
-		list = next;
-		if (++count >= rdp->blimit)
-			break;
-	}
-	rdp->donelist = list;
-
-	local_irq_save(flags);
-	rdp->qlen -= count;
-	local_irq_restore(flags);
-	if (rdp->blimit == INT_MAX && rdp->qlen <= qlowmark)
-		rdp->blimit = blimit;
-
-	if (!rdp->donelist)
-		rdp->donetail = &rdp->donelist;
-	else
-		raise_rcu_softirq();
-}
-
-/*
- * Grace period handling:
- * The grace period handling consists out of two steps:
- * - A new grace period is started.
- *   This is done by rcu_start_batch. The start is not broadcasted to
- *   all cpus, they must pick this up by comparing rcp->cur with
- *   rdp->quiescbatch. All cpus are recorded  in the
- *   rcu_ctrlblk.cpumask bitmap.
- * - All cpus must go through a quiescent state.
- *   Since the start of the grace period is not broadcasted, at least two
- *   calls to rcu_check_quiescent_state are required:
- *   The first call just notices that a new grace period is running. The
- *   following calls check if there was a quiescent state since the beginning
- *   of the grace period. If so, it updates rcu_ctrlblk.cpumask. If
- *   the bitmap is empty, then the grace period is completed.
- *   rcu_check_quiescent_state calls rcu_start_batch(0) to start the next grace
- *   period (if necessary).
- */
-
-/*
- * Register a new batch of callbacks, and start it up if there is currently no
- * active batch and the batch to be registered has not already occurred.
- * Caller must hold rcu_ctrlblk.lock.
- */
-static void rcu_start_batch(struct rcu_ctrlblk *rcp)
-{
-	if (rcp->cur != rcp->pending &&
-			rcp->completed == rcp->cur) {
-		rcp->cur++;
-		record_gp_stall_check_time(rcp);
-
-		/*
-		 * Accessing nohz_cpu_mask before incrementing rcp->cur needs a
-		 * Barrier  Otherwise it can cause tickless idle CPUs to be
-		 * included in rcp->cpumask, which will extend graceperiods
-		 * unnecessarily.
-		 */
-		smp_mb();
-		cpumask_andnot(to_cpumask(rcp->cpumask),
-			       cpu_online_mask, nohz_cpu_mask);
-
-		rcp->signaled = 0;
-	}
-}
-
-/*
- * cpu went through a quiescent state since the beginning of the grace period.
- * Clear it from the cpu mask and complete the grace period if it was the last
- * cpu. Start another grace period if someone has further entries pending
- */
-static void cpu_quiet(int cpu, struct rcu_ctrlblk *rcp)
-{
-	cpumask_clear_cpu(cpu, to_cpumask(rcp->cpumask));
-	if (cpumask_empty(to_cpumask(rcp->cpumask))) {
-		/* batch completed ! */
-		rcp->completed = rcp->cur;
-		rcu_start_batch(rcp);
-	}
-}
-
-/*
- * Check if the cpu has gone through a quiescent state (say context
- * switch). If so and if it already hasn't done so in this RCU
- * quiescent cycle, then indicate that it has done so.
- */
-static void rcu_check_quiescent_state(struct rcu_ctrlblk *rcp,
-					struct rcu_data *rdp)
-{
-	unsigned long flags;
-
-	if (rdp->quiescbatch != rcp->cur) {
-		/* start new grace period: */
-		rdp->qs_pending = 1;
-		rdp->passed_quiesc = 0;
-		rdp->quiescbatch = rcp->cur;
-		return;
-	}
-
-	/* Grace period already completed for this cpu?
-	 * qs_pending is checked instead of the actual bitmap to avoid
-	 * cacheline trashing.
-	 */
-	if (!rdp->qs_pending)
-		return;
-
-	/*
-	 * Was there a quiescent state since the beginning of the grace
-	 * period? If no, then exit and wait for the next call.
-	 */
-	if (!rdp->passed_quiesc)
-		return;
-	rdp->qs_pending = 0;
-
-	spin_lock_irqsave(&rcp->lock, flags);
-	/*
-	 * rdp->quiescbatch/rcp->cur and the cpu bitmap can come out of sync
-	 * during cpu startup. Ignore the quiescent state.
-	 */
-	if (likely(rdp->quiescbatch == rcp->cur))
-		cpu_quiet(rdp->cpu, rcp);
-
-	spin_unlock_irqrestore(&rcp->lock, flags);
-}
-
-
-#ifdef CONFIG_HOTPLUG_CPU
-
-/* warning! helper for rcu_offline_cpu. do not use elsewhere without reviewing
- * locking requirements, the list it's pulling from has to belong to a cpu
- * which is dead and hence not processing interrupts.
- */
-static void rcu_move_batch(struct rcu_data *this_rdp, struct rcu_head *list,
-				struct rcu_head **tail, long batch)
-{
-	unsigned long flags;
-
-	if (list) {
-		local_irq_save(flags);
-		this_rdp->batch = batch;
-		*this_rdp->nxttail[2] = list;
-		this_rdp->nxttail[2] = tail;
-		local_irq_restore(flags);
-	}
-}
-
-static void __rcu_offline_cpu(struct rcu_data *this_rdp,
-				struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
-{
-	unsigned long flags;
-
-	/*
-	 * if the cpu going offline owns the grace period
-	 * we can block indefinitely waiting for it, so flush
-	 * it here
-	 */
-	spin_lock_irqsave(&rcp->lock, flags);
-	if (rcp->cur != rcp->completed)
-		cpu_quiet(rdp->cpu, rcp);
-	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail, rcp->cur + 1);
-	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail[2], rcp->cur + 1);
-	spin_unlock(&rcp->lock);
-
-	this_rdp->qlen += rdp->qlen;
-	local_irq_restore(flags);
-}
-
-static void rcu_offline_cpu(int cpu)
-{
-	struct rcu_data *this_rdp = &get_cpu_var(rcu_data);
-	struct rcu_data *this_bh_rdp = &get_cpu_var(rcu_bh_data);
-
-	__rcu_offline_cpu(this_rdp, &rcu_ctrlblk,
-					&per_cpu(rcu_data, cpu));
-	__rcu_offline_cpu(this_bh_rdp, &rcu_bh_ctrlblk,
-					&per_cpu(rcu_bh_data, cpu));
-	put_cpu_var(rcu_data);
-	put_cpu_var(rcu_bh_data);
-}
-
-#else
-
-static void rcu_offline_cpu(int cpu)
-{
-}
-
-#endif
-
-/*
- * This does the RCU processing work from softirq context.
- */
-static void __rcu_process_callbacks(struct rcu_ctrlblk *rcp,
-					struct rcu_data *rdp)
-{
-	unsigned long flags;
-	long completed_snap;
-
-	if (rdp->nxtlist) {
-		local_irq_save(flags);
-		completed_snap = ACCESS_ONCE(rcp->completed);
-
-		/*
-		 * move the other grace-period-completed entries to
-		 * [rdp->nxtlist, *rdp->nxttail[0]) temporarily
-		 */
-		if (!rcu_batch_before(completed_snap, rdp->batch))
-			rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2];
-		else if (!rcu_batch_before(completed_snap, rdp->batch - 1))
-			rdp->nxttail[0] = rdp->nxttail[1];
-
-		/*
-		 * the grace period for entries in
-		 * [rdp->nxtlist, *rdp->nxttail[0]) has completed and
-		 * move these entries to donelist
-		 */
-		if (rdp->nxttail[0] != &rdp->nxtlist) {
-			*rdp->donetail = rdp->nxtlist;
-			rdp->donetail = rdp->nxttail[0];
-			rdp->nxtlist = *rdp->nxttail[0];
-			*rdp->donetail = NULL;
-
-			if (rdp->nxttail[1] == rdp->nxttail[0])
-				rdp->nxttail[1] = &rdp->nxtlist;
-			if (rdp->nxttail[2] == rdp->nxttail[0])
-				rdp->nxttail[2] = &rdp->nxtlist;
-			rdp->nxttail[0] = &rdp->nxtlist;
-		}
-
-		local_irq_restore(flags);
-
-		if (rcu_batch_after(rdp->batch, rcp->pending)) {
-			unsigned long flags2;
-
-			/* and start it/schedule start if it's a new batch */
-			spin_lock_irqsave(&rcp->lock, flags2);
-			if (rcu_batch_after(rdp->batch, rcp->pending)) {
-				rcp->pending = rdp->batch;
-				rcu_start_batch(rcp);
-			}
-			spin_unlock_irqrestore(&rcp->lock, flags2);
-		}
-	}
-
-	rcu_check_quiescent_state(rcp, rdp);
-	if (rdp->donelist)
-		rcu_do_batch(rdp);
-}
-
-static void rcu_process_callbacks(struct softirq_action *unused)
-{
-	/*
-	 * Memory references from any prior RCU read-side critical sections
-	 * executed by the interrupted code must be see before any RCU
-	 * grace-period manupulations below.
-	 */
-
-	smp_mb(); /* See above block comment. */
-
-	__rcu_process_callbacks(&rcu_ctrlblk, &__get_cpu_var(rcu_data));
-	__rcu_process_callbacks(&rcu_bh_ctrlblk, &__get_cpu_var(rcu_bh_data));
-
-	/*
-	 * Memory references from any later RCU read-side critical sections
-	 * executed by the interrupted code must be see after any RCU
-	 * grace-period manupulations above.
-	 */
-
-	smp_mb(); /* See above block comment. */
-}
-
-static int __rcu_pending(struct rcu_ctrlblk *rcp, struct rcu_data *rdp)
-{
-	/* Check for CPU stalls, if enabled. */
-	check_cpu_stall(rcp);
-
-	if (rdp->nxtlist) {
-		long completed_snap = ACCESS_ONCE(rcp->completed);
-
-		/*
-		 * This cpu has pending rcu entries and the grace period
-		 * for them has completed.
-		 */
-		if (!rcu_batch_before(completed_snap, rdp->batch))
-			return 1;
-		if (!rcu_batch_before(completed_snap, rdp->batch - 1) &&
-				rdp->nxttail[0] != rdp->nxttail[1])
-			return 1;
-		if (rdp->nxttail[0] != &rdp->nxtlist)
-			return 1;
-
-		/*
-		 * This cpu has pending rcu entries and the new batch
-		 * for then hasn't been started nor scheduled start
-		 */
-		if (rcu_batch_after(rdp->batch, rcp->pending))
-			return 1;
-	}
-
-	/* This cpu has finished callbacks to invoke */
-	if (rdp->donelist)
-		return 1;
-
-	/* The rcu core waits for a quiescent state from the cpu */
-	if (rdp->quiescbatch != rcp->cur || rdp->qs_pending)
-		return 1;
-
-	/* nothing to do */
-	return 0;
-}
-
-/*
- * Check to see if there is any immediate RCU-related work to be done
- * by the current CPU, returning 1 if so.  This function is part of the
- * RCU implementation; it is -not- an exported member of the RCU API.
- */
-int rcu_pending(int cpu)
-{
-	return __rcu_pending(&rcu_ctrlblk, &per_cpu(rcu_data, cpu)) ||
-		__rcu_pending(&rcu_bh_ctrlblk, &per_cpu(rcu_bh_data, cpu));
-}
-
-/*
- * Check to see if any future RCU-related work will need to be done
- * by the current CPU, even if none need be done immediately, returning
- * 1 if so.  This function is part of the RCU implementation; it is -not-
- * an exported member of the RCU API.
- */
-int rcu_needs_cpu(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	struct rcu_data *rdp_bh = &per_cpu(rcu_bh_data, cpu);
-
-	return !!rdp->nxtlist || !!rdp_bh->nxtlist || rcu_pending(cpu);
-}
-
-/*
- * Top-level function driving RCU grace-period detection, normally
- * invoked from the scheduler-clock interrupt.  This function simply
- * increments counters that are read only from softirq by this same
- * CPU, so there are no memory barriers required.
- */
-void rcu_check_callbacks(int cpu, int user)
-{
-	if (user ||
-	    (idle_cpu(cpu) && rcu_scheduler_active &&
-	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
-
-		/*
-		 * Get here if this CPU took its interrupt from user
-		 * mode or from the idle loop, and if this is not a
-		 * nested interrupt.  In this case, the CPU is in
-		 * a quiescent state, so count it.
-		 *
-		 * Also do a memory barrier.  This is needed to handle
-		 * the case where writes from a preempt-disable section
-		 * of code get reordered into schedule() by this CPU's
-		 * write buffer.  The memory barrier makes sure that
-		 * the rcu_qsctr_inc() and rcu_bh_qsctr_inc() are see
-		 * by other CPUs to happen after any such write.
-		 */
-
-		smp_mb();  /* See above block comment. */
-		rcu_qsctr_inc(cpu);
-		rcu_bh_qsctr_inc(cpu);
-
-	} else if (!in_softirq()) {
-
-		/*
-		 * Get here if this CPU did not take its interrupt from
-		 * softirq, in other words, if it is not interrupting
-		 * a rcu_bh read-side critical section.  This is an _bh
-		 * critical section, so count it.  The memory barrier
-		 * is needed for the same reason as is the above one.
-		 */
-
-		smp_mb();  /* See above block comment. */
-		rcu_bh_qsctr_inc(cpu);
-	}
-	raise_rcu_softirq();
-}
-
-static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_ctrlblk *rcp,
-						struct rcu_data *rdp)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&rcp->lock, flags);
-	memset(rdp, 0, sizeof(*rdp));
-	rdp->nxttail[0] = rdp->nxttail[1] = rdp->nxttail[2] = &rdp->nxtlist;
-	rdp->donetail = &rdp->donelist;
-	rdp->quiescbatch = rcp->completed;
-	rdp->qs_pending = 0;
-	rdp->cpu = cpu;
-	rdp->blimit = blimit;
-	spin_unlock_irqrestore(&rcp->lock, flags);
-}
-
-static void __cpuinit rcu_online_cpu(int cpu)
-{
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
-	struct rcu_data *bh_rdp = &per_cpu(rcu_bh_data, cpu);
-
-	rcu_init_percpu_data(cpu, &rcu_ctrlblk, rdp);
-	rcu_init_percpu_data(cpu, &rcu_bh_ctrlblk, bh_rdp);
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
-}
-
-static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
-				unsigned long action, void *hcpu)
-{
-	long cpu = (long)hcpu;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		rcu_online_cpu(cpu);
-		break;
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		rcu_offline_cpu(cpu);
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata rcu_nb = {
-	.notifier_call	= rcu_cpu_notify,
-};
-
-/*
- * Initializes rcu mechanism.  Assumed to be called early.
- * That is before local timer(SMP) or jiffie timer (uniproc) is setup.
- * Note that rcu_qsctr and friends are implicitly
- * initialized due to the choice of ``0'' for RCU_CTR_INVALID.
- */
-void __init __rcu_init(void)
-{
-#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
-#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-	rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,
-			(void *)(long)smp_processor_id());
-	/* Register notifier for non-boot CPUs */
-	register_cpu_notifier(&rcu_nb);
-}
-
-module_param(blimit, int, 0);
-module_param(qhimark, int, 0);
-module_param(qlowmark, int, 0);
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index a967c9f..bd5d5c8 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -98,6 +98,30 @@ void synchronize_rcu(void)
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
+/**
+ * synchronize_rcu_bh - wait until an rcu_bh grace period has elapsed.
+ *
+ * Control will return to the caller some time after a full rcu_bh grace
+ * period has elapsed, in other words after all currently executing rcu_bh
+ * read-side critical sections have completed.  RCU read-side critical
+ * sections are delimited by rcu_read_lock_bh() and rcu_read_unlock_bh(),
+ * and may be nested.
+ */
+void synchronize_rcu_bh(void)
+{
+	struct rcu_synchronize rcu;
+
+	if (rcu_blocking_is_gp())
+		return;
+
+	init_completion(&rcu.completion);
+	/* Will wake me after RCU finished. */
+	call_rcu_bh(&rcu.head, wakeme_after_rcu);
+	/* Wait for it. */
+	wait_for_completion(&rcu.completion);
+}
+EXPORT_SYMBOL_GPL(synchronize_rcu_bh);
+
 static void rcu_barrier_callback(struct rcu_head *notused)
 {
 	if (atomic_dec_and_test(&rcu_barrier_cpu_count))
@@ -129,6 +153,7 @@ static void rcu_barrier_func(void *type)
 static inline void wait_migrated_callbacks(void)
 {
 	wait_event(rcu_migrate_wq, !atomic_read(&rcu_migrate_type_count));
+	smp_mb(); /* In case we didn't sleep. */
 }
 
 /*
@@ -192,9 +217,13 @@ static void rcu_migrate_callback(struct rcu_head *notused)
 		wake_up(&rcu_migrate_wq);
 }
 
+extern int rcu_cpu_notify(struct notifier_block *self,
+			  unsigned long action, void *hcpu);
+
 static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 		unsigned long action, void *hcpu)
 {
+	rcu_cpu_notify(self, action, hcpu);
 	if (action == CPU_DYING) {
 		/*
 		 * preempt_disable() in on_each_cpu() prevents stop_machine(),
@@ -209,7 +238,8 @@ static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 		call_rcu_bh(rcu_migrate_head, rcu_migrate_callback);
 		call_rcu_sched(rcu_migrate_head + 1, rcu_migrate_callback);
 		call_rcu(rcu_migrate_head + 2, rcu_migrate_callback);
-	} else if (action == CPU_POST_DEAD) {
+	} else if (action == CPU_DOWN_PREPARE) {
+		/* Don't need to wait until next removal operation. */
 		/* rcu_migrate_head is protected by cpu_add_remove_lock */
 		wait_migrated_callbacks();
 	}
@@ -219,8 +249,18 @@ static int __cpuinit rcu_barrier_cpu_hotplug(struct notifier_block *self,
 
 void __init rcu_init(void)
 {
+	int i;
+
 	__rcu_init();
-	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
+	cpu_notifier(rcu_barrier_cpu_hotplug, 0);
+
+	/*
+	 * We don't need protection against CPU-hotplug here because
+	 * this is called early in boot, before either interrupts
+	 * or the scheduler are operational.
+	 */
+	for_each_online_cpu(i)
+		rcu_barrier_cpu_hotplug(NULL, CPU_UP_PREPARE, (void *)(long)i);
 }
 
 void rcu_scheduler_starting(void)
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
deleted file mode 100644
index beb0e65..0000000
--- a/kernel/rcupreempt.c
+++ /dev/null
@@ -1,1539 +0,0 @@
-/*
- * Read-Copy Update mechanism for mutual exclusion, realtime implementation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright IBM Corporation, 2006
- *
- * Authors: Paul E. McKenney <paulmck@us.ibm.com>
- *		With thanks to Esben Nielsen, Bill Huey, and Ingo Molnar
- *		for pushing me away from locks and towards counters, and
- *		to Suparna Bhattacharya for pushing me completely away
- *		from atomic instructions on the read side.
- *
- *  - Added handling of Dynamic Ticks
- *      Copyright 2007 - Paul E. Mckenney <paulmck@us.ibm.com>
- *                     - Steven Rostedt <srostedt@redhat.com>
- *
- * Papers:  http://www.rdrop.com/users/paulmck/RCU
- *
- * Design Document: http://lwn.net/Articles/253651/
- *
- * For detailed explanation of Read-Copy Update mechanism see -
- * 		Documentation/RCU/ *.txt
- *
- */
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-#include <linux/smp.h>
-#include <linux/rcupdate.h>
-#include <linux/interrupt.h>
-#include <linux/sched.h>
-#include <asm/atomic.h>
-#include <linux/bitops.h>
-#include <linux/module.h>
-#include <linux/kthread.h>
-#include <linux/completion.h>
-#include <linux/moduleparam.h>
-#include <linux/percpu.h>
-#include <linux/notifier.h>
-#include <linux/cpu.h>
-#include <linux/random.h>
-#include <linux/delay.h>
-#include <linux/cpumask.h>
-#include <linux/rcupreempt_trace.h>
-#include <asm/byteorder.h>
-
-/*
- * PREEMPT_RCU data structures.
- */
-
-/*
- * GP_STAGES specifies the number of times the state machine has
- * to go through the all the rcu_try_flip_states (see below)
- * in a single Grace Period.
- *
- * GP in GP_STAGES stands for Grace Period ;)
- */
-#define GP_STAGES    2
-struct rcu_data {
-	spinlock_t	lock;		/* Protect rcu_data fields. */
-	long		completed;	/* Number of last completed batch. */
-	int		waitlistcount;
-	struct rcu_head *nextlist;
-	struct rcu_head **nexttail;
-	struct rcu_head *waitlist[GP_STAGES];
-	struct rcu_head **waittail[GP_STAGES];
-	struct rcu_head *donelist;	/* from waitlist & waitschedlist */
-	struct rcu_head **donetail;
-	long rcu_flipctr[2];
-	struct rcu_head *nextschedlist;
-	struct rcu_head **nextschedtail;
-	struct rcu_head *waitschedlist;
-	struct rcu_head **waitschedtail;
-	int rcu_sched_sleeping;
-#ifdef CONFIG_RCU_TRACE
-	struct rcupreempt_trace trace;
-#endif /* #ifdef CONFIG_RCU_TRACE */
-};
-
-/*
- * States for rcu_try_flip() and friends.
- */
-
-enum rcu_try_flip_states {
-
-	/*
-	 * Stay here if nothing is happening. Flip the counter if somthing
-	 * starts happening. Denoted by "I"
-	 */
-	rcu_try_flip_idle_state,
-
-	/*
-	 * Wait here for all CPUs to notice that the counter has flipped. This
-	 * prevents the old set of counters from ever being incremented once
-	 * we leave this state, which in turn is necessary because we cannot
-	 * test any individual counter for zero -- we can only check the sum.
-	 * Denoted by "A".
-	 */
-	rcu_try_flip_waitack_state,
-
-	/*
-	 * Wait here for the sum of the old per-CPU counters to reach zero.
-	 * Denoted by "Z".
-	 */
-	rcu_try_flip_waitzero_state,
-
-	/*
-	 * Wait here for each of the other CPUs to execute a memory barrier.
-	 * This is necessary to ensure that these other CPUs really have
-	 * completed executing their RCU read-side critical sections, despite
-	 * their CPUs wildly reordering memory. Denoted by "M".
-	 */
-	rcu_try_flip_waitmb_state,
-};
-
-/*
- * States for rcu_ctrlblk.rcu_sched_sleep.
- */
-
-enum rcu_sched_sleep_states {
-	rcu_sched_not_sleeping,	/* Not sleeping, callbacks need GP.  */
-	rcu_sched_sleep_prep,	/* Thinking of sleeping, rechecking. */
-	rcu_sched_sleeping,	/* Sleeping, awaken if GP needed. */
-};
-
-struct rcu_ctrlblk {
-	spinlock_t	fliplock;	/* Protect state-machine transitions. */
-	long		completed;	/* Number of last completed batch. */
-	enum rcu_try_flip_states rcu_try_flip_state; /* The current state of
-							the rcu state machine */
-	spinlock_t	schedlock;	/* Protect rcu_sched sleep state. */
-	enum rcu_sched_sleep_states sched_sleep; /* rcu_sched state. */
-	wait_queue_head_t sched_wq;	/* Place for rcu_sched to sleep. */
-};
-
-struct rcu_dyntick_sched {
-	int dynticks;
-	int dynticks_snap;
-	int sched_qs;
-	int sched_qs_snap;
-	int sched_dynticks_snap;
-};
-
-static DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
-	.dynticks = 1,
-};
-
-void rcu_qsctr_inc(int cpu)
-{
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	rdssp->sched_qs++;
-}
-
-#ifdef CONFIG_NO_HZ
-
-void rcu_enter_nohz(void)
-{
-	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
-
-	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
-	__get_cpu_var(rcu_dyntick_sched).dynticks++;
-	WARN_ON_RATELIMIT(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1, &rs);
-}
-
-void rcu_exit_nohz(void)
-{
-	static DEFINE_RATELIMIT_STATE(rs, 10 * HZ, 1);
-
-	__get_cpu_var(rcu_dyntick_sched).dynticks++;
-	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
-	WARN_ON_RATELIMIT(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1),
-				&rs);
-}
-
-#endif /* CONFIG_NO_HZ */
-
-
-static DEFINE_PER_CPU(struct rcu_data, rcu_data);
-
-static struct rcu_ctrlblk rcu_ctrlblk = {
-	.fliplock = __SPIN_LOCK_UNLOCKED(rcu_ctrlblk.fliplock),
-	.completed = 0,
-	.rcu_try_flip_state = rcu_try_flip_idle_state,
-	.schedlock = __SPIN_LOCK_UNLOCKED(rcu_ctrlblk.schedlock),
-	.sched_sleep = rcu_sched_not_sleeping,
-	.sched_wq = __WAIT_QUEUE_HEAD_INITIALIZER(rcu_ctrlblk.sched_wq),
-};
-
-static struct task_struct *rcu_sched_grace_period_task;
-
-#ifdef CONFIG_RCU_TRACE
-static char *rcu_try_flip_state_names[] =
-	{ "idle", "waitack", "waitzero", "waitmb" };
-#endif /* #ifdef CONFIG_RCU_TRACE */
-
-static DECLARE_BITMAP(rcu_cpu_online_map, NR_CPUS) __read_mostly
-	= CPU_BITS_NONE;
-
-/*
- * Enum and per-CPU flag to determine when each CPU has seen
- * the most recent counter flip.
- */
-
-enum rcu_flip_flag_values {
-	rcu_flip_seen,		/* Steady/initial state, last flip seen. */
-				/* Only GP detector can update. */
-	rcu_flipped		/* Flip just completed, need confirmation. */
-				/* Only corresponding CPU can update. */
-};
-static DEFINE_PER_CPU_SHARED_ALIGNED(enum rcu_flip_flag_values, rcu_flip_flag)
-								= rcu_flip_seen;
-
-/*
- * Enum and per-CPU flag to determine when each CPU has executed the
- * needed memory barrier to fence in memory references from its last RCU
- * read-side critical section in the just-completed grace period.
- */
-
-enum rcu_mb_flag_values {
-	rcu_mb_done,		/* Steady/initial state, no mb()s required. */
-				/* Only GP detector can update. */
-	rcu_mb_needed		/* Flip just completed, need an mb(). */
-				/* Only corresponding CPU can update. */
-};
-static DEFINE_PER_CPU_SHARED_ALIGNED(enum rcu_mb_flag_values, rcu_mb_flag)
-								= rcu_mb_done;
-
-/*
- * RCU_DATA_ME: find the current CPU's rcu_data structure.
- * RCU_DATA_CPU: find the specified CPU's rcu_data structure.
- */
-#define RCU_DATA_ME()		(&__get_cpu_var(rcu_data))
-#define RCU_DATA_CPU(cpu)	(&per_cpu(rcu_data, cpu))
-
-/*
- * Helper macro for tracing when the appropriate rcu_data is not
- * cached in a local variable, but where the CPU number is so cached.
- */
-#define RCU_TRACE_CPU(f, cpu) RCU_TRACE(f, &(RCU_DATA_CPU(cpu)->trace));
-
-/*
- * Helper macro for tracing when the appropriate rcu_data is not
- * cached in a local variable.
- */
-#define RCU_TRACE_ME(f) RCU_TRACE(f, &(RCU_DATA_ME()->trace));
-
-/*
- * Helper macro for tracing when the appropriate rcu_data is pointed
- * to by a local variable.
- */
-#define RCU_TRACE_RDP(f, rdp) RCU_TRACE(f, &((rdp)->trace));
-
-#define RCU_SCHED_BATCH_TIME (HZ / 50)
-
-/*
- * Return the number of RCU batches processed thus far.  Useful
- * for debug and statistics.
- */
-long rcu_batches_completed(void)
-{
-	return rcu_ctrlblk.completed;
-}
-EXPORT_SYMBOL_GPL(rcu_batches_completed);
-
-void __rcu_read_lock(void)
-{
-	int idx;
-	struct task_struct *t = current;
-	int nesting;
-
-	nesting = ACCESS_ONCE(t->rcu_read_lock_nesting);
-	if (nesting != 0) {
-
-		/* An earlier rcu_read_lock() covers us, just count it. */
-
-		t->rcu_read_lock_nesting = nesting + 1;
-
-	} else {
-		unsigned long flags;
-
-		/*
-		 * We disable interrupts for the following reasons:
-		 * - If we get scheduling clock interrupt here, and we
-		 *   end up acking the counter flip, it's like a promise
-		 *   that we will never increment the old counter again.
-		 *   Thus we will break that promise if that
-		 *   scheduling clock interrupt happens between the time
-		 *   we pick the .completed field and the time that we
-		 *   increment our counter.
-		 *
-		 * - We don't want to be preempted out here.
-		 *
-		 * NMIs can still occur, of course, and might themselves
-		 * contain rcu_read_lock().
-		 */
-
-		local_irq_save(flags);
-
-		/*
-		 * Outermost nesting of rcu_read_lock(), so increment
-		 * the current counter for the current CPU.  Use volatile
-		 * casts to prevent the compiler from reordering.
-		 */
-
-		idx = ACCESS_ONCE(rcu_ctrlblk.completed) & 0x1;
-		ACCESS_ONCE(RCU_DATA_ME()->rcu_flipctr[idx])++;
-
-		/*
-		 * Now that the per-CPU counter has been incremented, we
-		 * are protected from races with rcu_read_lock() invoked
-		 * from NMI handlers on this CPU.  We can therefore safely
-		 * increment the nesting counter, relieving further NMIs
-		 * of the need to increment the per-CPU counter.
-		 */
-
-		ACCESS_ONCE(t->rcu_read_lock_nesting) = nesting + 1;
-
-		/*
-		 * Now that we have preventing any NMIs from storing
-		 * to the ->rcu_flipctr_idx, we can safely use it to
-		 * remember which counter to decrement in the matching
-		 * rcu_read_unlock().
-		 */
-
-		ACCESS_ONCE(t->rcu_flipctr_idx) = idx;
-		local_irq_restore(flags);
-	}
-}
-EXPORT_SYMBOL_GPL(__rcu_read_lock);
-
-void __rcu_read_unlock(void)
-{
-	int idx;
-	struct task_struct *t = current;
-	int nesting;
-
-	nesting = ACCESS_ONCE(t->rcu_read_lock_nesting);
-	if (nesting > 1) {
-
-		/*
-		 * We are still protected by the enclosing rcu_read_lock(),
-		 * so simply decrement the counter.
-		 */
-
-		t->rcu_read_lock_nesting = nesting - 1;
-
-	} else {
-		unsigned long flags;
-
-		/*
-		 * Disable local interrupts to prevent the grace-period
-		 * detection state machine from seeing us half-done.
-		 * NMIs can still occur, of course, and might themselves
-		 * contain rcu_read_lock() and rcu_read_unlock().
-		 */
-
-		local_irq_save(flags);
-
-		/*
-		 * Outermost nesting of rcu_read_unlock(), so we must
-		 * decrement the current counter for the current CPU.
-		 * This must be done carefully, because NMIs can
-		 * occur at any point in this code, and any rcu_read_lock()
-		 * and rcu_read_unlock() pairs in the NMI handlers
-		 * must interact non-destructively with this code.
-		 * Lots of volatile casts, and -very- careful ordering.
-		 *
-		 * Changes to this code, including this one, must be
-		 * inspected, validated, and tested extremely carefully!!!
-		 */
-
-		/*
-		 * First, pick up the index.
-		 */
-
-		idx = ACCESS_ONCE(t->rcu_flipctr_idx);
-
-		/*
-		 * Now that we have fetched the counter index, it is
-		 * safe to decrement the per-task RCU nesting counter.
-		 * After this, any interrupts or NMIs will increment and
-		 * decrement the per-CPU counters.
-		 */
-		ACCESS_ONCE(t->rcu_read_lock_nesting) = nesting - 1;
-
-		/*
-		 * It is now safe to decrement this task's nesting count.
-		 * NMIs that occur after this statement will route their
-		 * rcu_read_lock() calls through this "else" clause, and
-		 * will thus start incrementing the per-CPU counter on
-		 * their own.  They will also clobber ->rcu_flipctr_idx,
-		 * but that is OK, since we have already fetched it.
-		 */
-
-		ACCESS_ONCE(RCU_DATA_ME()->rcu_flipctr[idx])--;
-		local_irq_restore(flags);
-	}
-}
-EXPORT_SYMBOL_GPL(__rcu_read_unlock);
-
-/*
- * If a global counter flip has occurred since the last time that we
- * advanced callbacks, advance them.  Hardware interrupts must be
- * disabled when calling this function.
- */
-static void __rcu_advance_callbacks(struct rcu_data *rdp)
-{
-	int cpu;
-	int i;
-	int wlc = 0;
-
-	if (rdp->completed != rcu_ctrlblk.completed) {
-		if (rdp->waitlist[GP_STAGES - 1] != NULL) {
-			*rdp->donetail = rdp->waitlist[GP_STAGES - 1];
-			rdp->donetail = rdp->waittail[GP_STAGES - 1];
-			RCU_TRACE_RDP(rcupreempt_trace_move2done, rdp);
-		}
-		for (i = GP_STAGES - 2; i >= 0; i--) {
-			if (rdp->waitlist[i] != NULL) {
-				rdp->waitlist[i + 1] = rdp->waitlist[i];
-				rdp->waittail[i + 1] = rdp->waittail[i];
-				wlc++;
-			} else {
-				rdp->waitlist[i + 1] = NULL;
-				rdp->waittail[i + 1] =
-					&rdp->waitlist[i + 1];
-			}
-		}
-		if (rdp->nextlist != NULL) {
-			rdp->waitlist[0] = rdp->nextlist;
-			rdp->waittail[0] = rdp->nexttail;
-			wlc++;
-			rdp->nextlist = NULL;
-			rdp->nexttail = &rdp->nextlist;
-			RCU_TRACE_RDP(rcupreempt_trace_move2wait, rdp);
-		} else {
-			rdp->waitlist[0] = NULL;
-			rdp->waittail[0] = &rdp->waitlist[0];
-		}
-		rdp->waitlistcount = wlc;
-		rdp->completed = rcu_ctrlblk.completed;
-	}
-
-	/*
-	 * Check to see if this CPU needs to report that it has seen
-	 * the most recent counter flip, thereby declaring that all
-	 * subsequent rcu_read_lock() invocations will respect this flip.
-	 */
-
-	cpu = raw_smp_processor_id();
-	if (per_cpu(rcu_flip_flag, cpu) == rcu_flipped) {
-		smp_mb();  /* Subsequent counter accesses must see new value */
-		per_cpu(rcu_flip_flag, cpu) = rcu_flip_seen;
-		smp_mb();  /* Subsequent RCU read-side critical sections */
-			   /*  seen -after- acknowledgement. */
-	}
-}
-
-#ifdef CONFIG_NO_HZ
-static DEFINE_PER_CPU(int, rcu_update_flag);
-
-/**
- * rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
- *
- * If the CPU was idle with dynamic ticks active, this updates the
- * rcu_dyntick_sched.dynticks to let the RCU handling know that the
- * CPU is active.
- */
-void rcu_irq_enter(void)
-{
-	int cpu = smp_processor_id();
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	if (per_cpu(rcu_update_flag, cpu))
-		per_cpu(rcu_update_flag, cpu)++;
-
-	/*
-	 * Only update if we are coming from a stopped ticks mode
-	 * (rcu_dyntick_sched.dynticks is even).
-	 */
-	if (!in_interrupt() &&
-	    (rdssp->dynticks & 0x1) == 0) {
-		/*
-		 * The following might seem like we could have a race
-		 * with NMI/SMIs. But this really isn't a problem.
-		 * Here we do a read/modify/write, and the race happens
-		 * when an NMI/SMI comes in after the read and before
-		 * the write. But NMI/SMIs will increment this counter
-		 * twice before returning, so the zero bit will not
-		 * be corrupted by the NMI/SMI which is the most important
-		 * part.
-		 *
-		 * The only thing is that we would bring back the counter
-		 * to a postion that it was in during the NMI/SMI.
-		 * But the zero bit would be set, so the rest of the
-		 * counter would again be ignored.
-		 *
-		 * On return from the IRQ, the counter may have the zero
-		 * bit be 0 and the counter the same as the return from
-		 * the NMI/SMI. If the state machine was so unlucky to
-		 * see that, it still doesn't matter, since all
-		 * RCU read-side critical sections on this CPU would
-		 * have already completed.
-		 */
-		rdssp->dynticks++;
-		/*
-		 * The following memory barrier ensures that any
-		 * rcu_read_lock() primitives in the irq handler
-		 * are seen by other CPUs to follow the above
-		 * increment to rcu_dyntick_sched.dynticks. This is
-		 * required in order for other CPUs to correctly
-		 * determine when it is safe to advance the RCU
-		 * grace-period state machine.
-		 */
-		smp_mb(); /* see above block comment. */
-		/*
-		 * Since we can't determine the dynamic tick mode from
-		 * the rcu_dyntick_sched.dynticks after this routine,
-		 * we use a second flag to acknowledge that we came
-		 * from an idle state with ticks stopped.
-		 */
-		per_cpu(rcu_update_flag, cpu)++;
-		/*
-		 * If we take an NMI/SMI now, they will also increment
-		 * the rcu_update_flag, and will not update the
-		 * rcu_dyntick_sched.dynticks on exit. That is for
-		 * this IRQ to do.
-		 */
-	}
-}
-
-/**
- * rcu_irq_exit - Called from exiting Hard irq context.
- *
- * If the CPU was idle with dynamic ticks active, update the
- * rcu_dyntick_sched.dynticks to put let the RCU handling be
- * aware that the CPU is going back to idle with no ticks.
- */
-void rcu_irq_exit(void)
-{
-	int cpu = smp_processor_id();
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	/*
-	 * rcu_update_flag is set if we interrupted the CPU
-	 * when it was idle with ticks stopped.
-	 * Once this occurs, we keep track of interrupt nesting
-	 * because a NMI/SMI could also come in, and we still
-	 * only want the IRQ that started the increment of the
-	 * rcu_dyntick_sched.dynticks to be the one that modifies
-	 * it on exit.
-	 */
-	if (per_cpu(rcu_update_flag, cpu)) {
-		if (--per_cpu(rcu_update_flag, cpu))
-			return;
-
-		/* This must match the interrupt nesting */
-		WARN_ON(in_interrupt());
-
-		/*
-		 * If an NMI/SMI happens now we are still
-		 * protected by the rcu_dyntick_sched.dynticks being odd.
-		 */
-
-		/*
-		 * The following memory barrier ensures that any
-		 * rcu_read_unlock() primitives in the irq handler
-		 * are seen by other CPUs to preceed the following
-		 * increment to rcu_dyntick_sched.dynticks. This
-		 * is required in order for other CPUs to determine
-		 * when it is safe to advance the RCU grace-period
-		 * state machine.
-		 */
-		smp_mb(); /* see above block comment. */
-		rdssp->dynticks++;
-		WARN_ON(rdssp->dynticks & 0x1);
-	}
-}
-
-void rcu_nmi_enter(void)
-{
-	rcu_irq_enter();
-}
-
-void rcu_nmi_exit(void)
-{
-	rcu_irq_exit();
-}
-
-static void dyntick_save_progress_counter(int cpu)
-{
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	rdssp->dynticks_snap = rdssp->dynticks;
-}
-
-static inline int
-rcu_try_flip_waitack_needed(int cpu)
-{
-	long curr;
-	long snap;
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	curr = rdssp->dynticks;
-	snap = rdssp->dynticks_snap;
-	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
-
-	/*
-	 * If the CPU remained in dynticks mode for the entire time
-	 * and didn't take any interrupts, NMIs, SMIs, or whatever,
-	 * then it cannot be in the middle of an rcu_read_lock(), so
-	 * the next rcu_read_lock() it executes must use the new value
-	 * of the counter.  So we can safely pretend that this CPU
-	 * already acknowledged the counter.
-	 */
-
-	if ((curr == snap) && ((curr & 0x1) == 0))
-		return 0;
-
-	/*
-	 * If the CPU passed through or entered a dynticks idle phase with
-	 * no active irq handlers, then, as above, we can safely pretend
-	 * that this CPU already acknowledged the counter.
-	 */
-
-	if ((curr - snap) > 2 || (curr & 0x1) == 0)
-		return 0;
-
-	/* We need this CPU to explicitly acknowledge the counter flip. */
-
-	return 1;
-}
-
-static inline int
-rcu_try_flip_waitmb_needed(int cpu)
-{
-	long curr;
-	long snap;
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	curr = rdssp->dynticks;
-	snap = rdssp->dynticks_snap;
-	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
-
-	/*
-	 * If the CPU remained in dynticks mode for the entire time
-	 * and didn't take any interrupts, NMIs, SMIs, or whatever,
-	 * then it cannot have executed an RCU read-side critical section
-	 * during that time, so there is no need for it to execute a
-	 * memory barrier.
-	 */
-
-	if ((curr == snap) && ((curr & 0x1) == 0))
-		return 0;
-
-	/*
-	 * If the CPU either entered or exited an outermost interrupt,
-	 * SMI, NMI, or whatever handler, then we know that it executed
-	 * a memory barrier when doing so.  So we don't need another one.
-	 */
-	if (curr != snap)
-		return 0;
-
-	/* We need the CPU to execute a memory barrier. */
-
-	return 1;
-}
-
-static void dyntick_save_progress_counter_sched(int cpu)
-{
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	rdssp->sched_dynticks_snap = rdssp->dynticks;
-}
-
-static int rcu_qsctr_inc_needed_dyntick(int cpu)
-{
-	long curr;
-	long snap;
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	curr = rdssp->dynticks;
-	snap = rdssp->sched_dynticks_snap;
-	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
-
-	/*
-	 * If the CPU remained in dynticks mode for the entire time
-	 * and didn't take any interrupts, NMIs, SMIs, or whatever,
-	 * then it cannot be in the middle of an rcu_read_lock(), so
-	 * the next rcu_read_lock() it executes must use the new value
-	 * of the counter.  Therefore, this CPU has been in a quiescent
-	 * state the entire time, and we don't need to wait for it.
-	 */
-
-	if ((curr == snap) && ((curr & 0x1) == 0))
-		return 0;
-
-	/*
-	 * If the CPU passed through or entered a dynticks idle phase with
-	 * no active irq handlers, then, as above, this CPU has already
-	 * passed through a quiescent state.
-	 */
-
-	if ((curr - snap) > 2 || (snap & 0x1) == 0)
-		return 0;
-
-	/* We need this CPU to go through a quiescent state. */
-
-	return 1;
-}
-
-#else /* !CONFIG_NO_HZ */
-
-# define dyntick_save_progress_counter(cpu)		do { } while (0)
-# define rcu_try_flip_waitack_needed(cpu)		(1)
-# define rcu_try_flip_waitmb_needed(cpu)		(1)
-
-# define dyntick_save_progress_counter_sched(cpu)	do { } while (0)
-# define rcu_qsctr_inc_needed_dyntick(cpu)		(1)
-
-#endif /* CONFIG_NO_HZ */
-
-static void save_qsctr_sched(int cpu)
-{
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	rdssp->sched_qs_snap = rdssp->sched_qs;
-}
-
-static inline int rcu_qsctr_inc_needed(int cpu)
-{
-	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
-
-	/*
-	 * If there has been a quiescent state, no more need to wait
-	 * on this CPU.
-	 */
-
-	if (rdssp->sched_qs != rdssp->sched_qs_snap) {
-		smp_mb(); /* force ordering with cpu entering schedule(). */
-		return 0;
-	}
-
-	/* We need this CPU to go through a quiescent state. */
-
-	return 1;
-}
-
-/*
- * Get here when RCU is idle.  Decide whether we need to
- * move out of idle state, and return non-zero if so.
- * "Straightforward" approach for the moment, might later
- * use callback-list lengths, grace-period duration, or
- * some such to determine when to exit idle state.
- * Might also need a pre-idle test that does not acquire
- * the lock, but let's get the simple case working first...
- */
-
-static int
-rcu_try_flip_idle(void)
-{
-	int cpu;
-
-	RCU_TRACE_ME(rcupreempt_trace_try_flip_i1);
-	if (!rcu_pending(smp_processor_id())) {
-		RCU_TRACE_ME(rcupreempt_trace_try_flip_ie1);
-		return 0;
-	}
-
-	/*
-	 * Do the flip.
-	 */
-
-	RCU_TRACE_ME(rcupreempt_trace_try_flip_g1);
-	rcu_ctrlblk.completed++;  /* stands in for rcu_try_flip_g2 */
-
-	/*
-	 * Need a memory barrier so that other CPUs see the new
-	 * counter value before they see the subsequent change of all
-	 * the rcu_flip_flag instances to rcu_flipped.
-	 */
-
-	smp_mb();	/* see above block comment. */
-
-	/* Now ask each CPU for acknowledgement of the flip. */
-
-	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map)) {
-		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
-		dyntick_save_progress_counter(cpu);
-	}
-
-	return 1;
-}
-
-/*
- * Wait for CPUs to acknowledge the flip.
- */
-
-static int
-rcu_try_flip_waitack(void)
-{
-	int cpu;
-
-	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
-	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map))
-		if (rcu_try_flip_waitack_needed(cpu) &&
-		    per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
-			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
-			return 0;
-		}
-
-	/*
-	 * Make sure our checks above don't bleed into subsequent
-	 * waiting for the sum of the counters to reach zero.
-	 */
-
-	smp_mb();	/* see above block comment. */
-	RCU_TRACE_ME(rcupreempt_trace_try_flip_a2);
-	return 1;
-}
-
-/*
- * Wait for collective ``last'' counter to reach zero,
- * then tell all CPUs to do an end-of-grace-period memory barrier.
- */
-
-static int
-rcu_try_flip_waitzero(void)
-{
-	int cpu;
-	int lastidx = !(rcu_ctrlblk.completed & 0x1);
-	int sum = 0;
-
-	/* Check to see if the sum of the "last" counters is zero. */
-
-	RCU_TRACE_ME(rcupreempt_trace_try_flip_z1);
-	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map))
-		sum += RCU_DATA_CPU(cpu)->rcu_flipctr[lastidx];
-	if (sum != 0) {
-		RCU_TRACE_ME(rcupreempt_trace_try_flip_ze1);
-		return 0;
-	}
-
-	/*
-	 * This ensures that the other CPUs see the call for
-	 * memory barriers -after- the sum to zero has been
-	 * detected here
-	 */
-	smp_mb();  /*  ^^^^^^^^^^^^ */
-
-	/* Call for a memory barrier from each CPU. */
-	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map)) {
-		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
-		dyntick_save_progress_counter(cpu);
-	}
-
-	RCU_TRACE_ME(rcupreempt_trace_try_flip_z2);
-	return 1;
-}
-
-/*
- * Wait for all CPUs to do their end-of-grace-period memory barrier.
- * Return 0 once all CPUs have done so.
- */
-
-static int
-rcu_try_flip_waitmb(void)
-{
-	int cpu;
-
-	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
-	for_each_cpu(cpu, to_cpumask(rcu_cpu_online_map))
-		if (rcu_try_flip_waitmb_needed(cpu) &&
-		    per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
-			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
-			return 0;
-		}
-
-	smp_mb(); /* Ensure that the above checks precede any following flip. */
-	RCU_TRACE_ME(rcupreempt_trace_try_flip_m2);
-	return 1;
-}
-
-/*
- * Attempt a single flip of the counters.  Remember, a single flip does
- * -not- constitute a grace period.  Instead, the interval between
- * at least GP_STAGES consecutive flips is a grace period.
- *
- * If anyone is nuts enough to run this CONFIG_PREEMPT_RCU implementation
- * on a large SMP, they might want to use a hierarchical organization of
- * the per-CPU-counter pairs.
- */
-static void rcu_try_flip(void)
-{
-	unsigned long flags;
-
-	RCU_TRACE_ME(rcupreempt_trace_try_flip_1);
-	if (unlikely(!spin_trylock_irqsave(&rcu_ctrlblk.fliplock, flags))) {
-		RCU_TRACE_ME(rcupreempt_trace_try_flip_e1);
-		return;
-	}
-
-	/*
-	 * Take the next transition(s) through the RCU grace-period
-	 * flip-counter state machine.
-	 */
-
-	switch (rcu_ctrlblk.rcu_try_flip_state) {
-	case rcu_try_flip_idle_state:
-		if (rcu_try_flip_idle())
-			rcu_ctrlblk.rcu_try_flip_state =
-				rcu_try_flip_waitack_state;
-		break;
-	case rcu_try_flip_waitack_state:
-		if (rcu_try_flip_waitack())
-			rcu_ctrlblk.rcu_try_flip_state =
-				rcu_try_flip_waitzero_state;
-		break;
-	case rcu_try_flip_waitzero_state:
-		if (rcu_try_flip_waitzero())
-			rcu_ctrlblk.rcu_try_flip_state =
-				rcu_try_flip_waitmb_state;
-		break;
-	case rcu_try_flip_waitmb_state:
-		if (rcu_try_flip_waitmb())
-			rcu_ctrlblk.rcu_try_flip_state =
-				rcu_try_flip_idle_state;
-	}
-	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
-}
-
-/*
- * Check to see if this CPU needs to do a memory barrier in order to
- * ensure that any prior RCU read-side critical sections have committed
- * their counter manipulations and critical-section memory references
- * before declaring the grace period to be completed.
- */
-static void rcu_check_mb(int cpu)
-{
-	if (per_cpu(rcu_mb_flag, cpu) == rcu_mb_needed) {
-		smp_mb();  /* Ensure RCU read-side accesses are visible. */
-		per_cpu(rcu_mb_flag, cpu) = rcu_mb_done;
-	}
-}
-
-void rcu_check_callbacks(int cpu, int user)
-{
-	unsigned long flags;
-	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
-
-	/*
-	 * If this CPU took its interrupt from user mode or from the
-	 * idle loop, and this is not a nested interrupt, then
-	 * this CPU has to have exited all prior preept-disable
-	 * sections of code.  So increment the counter to note this.
-	 *
-	 * The memory barrier is needed to handle the case where
-	 * writes from a preempt-disable section of code get reordered
-	 * into schedule() by this CPU's write buffer.  So the memory
-	 * barrier makes sure that the rcu_qsctr_inc() is seen by other
-	 * CPUs to happen after any such write.
-	 */
-
-	if (user ||
-	    (idle_cpu(cpu) && !in_softirq() &&
-	     hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
-		smp_mb();	/* Guard against aggressive schedule(). */
-	     	rcu_qsctr_inc(cpu);
-	}
-
-	rcu_check_mb(cpu);
-	if (rcu_ctrlblk.completed == rdp->completed)
-		rcu_try_flip();
-	spin_lock_irqsave(&rdp->lock, flags);
-	RCU_TRACE_RDP(rcupreempt_trace_check_callbacks, rdp);
-	__rcu_advance_callbacks(rdp);
-	if (rdp->donelist == NULL) {
-		spin_unlock_irqrestore(&rdp->lock, flags);
-	} else {
-		spin_unlock_irqrestore(&rdp->lock, flags);
-		raise_softirq(RCU_SOFTIRQ);
-	}
-}
-
-/*
- * Needed by dynticks, to make sure all RCU processing has finished
- * when we go idle:
- */
-void rcu_advance_callbacks(int cpu, int user)
-{
-	unsigned long flags;
-	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
-
-	if (rcu_ctrlblk.completed == rdp->completed) {
-		rcu_try_flip();
-		if (rcu_ctrlblk.completed == rdp->completed)
-			return;
-	}
-	spin_lock_irqsave(&rdp->lock, flags);
-	RCU_TRACE_RDP(rcupreempt_trace_check_callbacks, rdp);
-	__rcu_advance_callbacks(rdp);
-	spin_unlock_irqrestore(&rdp->lock, flags);
-}
-
-#ifdef CONFIG_HOTPLUG_CPU
-#define rcu_offline_cpu_enqueue(srclist, srctail, dstlist, dsttail) do { \
-		*dsttail = srclist; \
-		if (srclist != NULL) { \
-			dsttail = srctail; \
-			srclist = NULL; \
-			srctail = &srclist;\
-		} \
-	} while (0)
-
-void rcu_offline_cpu(int cpu)
-{
-	int i;
-	struct rcu_head *list = NULL;
-	unsigned long flags;
-	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
-	struct rcu_head *schedlist = NULL;
-	struct rcu_head **schedtail = &schedlist;
-	struct rcu_head **tail = &list;
-
-	/*
-	 * Remove all callbacks from the newly dead CPU, retaining order.
-	 * Otherwise rcu_barrier() will fail
-	 */
-
-	spin_lock_irqsave(&rdp->lock, flags);
-	rcu_offline_cpu_enqueue(rdp->donelist, rdp->donetail, list, tail);
-	for (i = GP_STAGES - 1; i >= 0; i--)
-		rcu_offline_cpu_enqueue(rdp->waitlist[i], rdp->waittail[i],
-						list, tail);
-	rcu_offline_cpu_enqueue(rdp->nextlist, rdp->nexttail, list, tail);
-	rcu_offline_cpu_enqueue(rdp->waitschedlist, rdp->waitschedtail,
-				schedlist, schedtail);
-	rcu_offline_cpu_enqueue(rdp->nextschedlist, rdp->nextschedtail,
-				schedlist, schedtail);
-	rdp->rcu_sched_sleeping = 0;
-	spin_unlock_irqrestore(&rdp->lock, flags);
-	rdp->waitlistcount = 0;
-
-	/* Disengage the newly dead CPU from the grace-period computation. */
-
-	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
-	rcu_check_mb(cpu);
-	if (per_cpu(rcu_flip_flag, cpu) == rcu_flipped) {
-		smp_mb();  /* Subsequent counter accesses must see new value */
-		per_cpu(rcu_flip_flag, cpu) = rcu_flip_seen;
-		smp_mb();  /* Subsequent RCU read-side critical sections */
-			   /*  seen -after- acknowledgement. */
-	}
-
-	RCU_DATA_ME()->rcu_flipctr[0] += RCU_DATA_CPU(cpu)->rcu_flipctr[0];
-	RCU_DATA_ME()->rcu_flipctr[1] += RCU_DATA_CPU(cpu)->rcu_flipctr[1];
-
-	RCU_DATA_CPU(cpu)->rcu_flipctr[0] = 0;
-	RCU_DATA_CPU(cpu)->rcu_flipctr[1] = 0;
-
-	cpumask_clear_cpu(cpu, to_cpumask(rcu_cpu_online_map));
-
-	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
-
-	/*
-	 * Place the removed callbacks on the current CPU's queue.
-	 * Make them all start a new grace period: simple approach,
-	 * in theory could starve a given set of callbacks, but
-	 * you would need to be doing some serious CPU hotplugging
-	 * to make this happen.  If this becomes a problem, adding
-	 * a synchronize_rcu() to the hotplug path would be a simple
-	 * fix.
-	 */
-
-	local_irq_save(flags);  /* disable preempt till we know what lock. */
-	rdp = RCU_DATA_ME();
-	spin_lock(&rdp->lock);
-	*rdp->nexttail = list;
-	if (list)
-		rdp->nexttail = tail;
-	*rdp->nextschedtail = schedlist;
-	if (schedlist)
-		rdp->nextschedtail = schedtail;
-	spin_unlock_irqrestore(&rdp->lock, flags);
-}
-
-#else /* #ifdef CONFIG_HOTPLUG_CPU */
-
-void rcu_offline_cpu(int cpu)
-{
-}
-
-#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
-
-void __cpuinit rcu_online_cpu(int cpu)
-{
-	unsigned long flags;
-	struct rcu_data *rdp;
-
-	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
-	cpumask_set_cpu(cpu, to_cpumask(rcu_cpu_online_map));
-	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
-
-	/*
-	 * The rcu_sched grace-period processing might have bypassed
-	 * this CPU, given that it was not in the rcu_cpu_online_map
-	 * when the grace-period scan started.  This means that the
-	 * grace-period task might sleep.  So make sure that if this
-	 * should happen, the first callback posted to this CPU will
-	 * wake up the grace-period task if need be.
-	 */
-
-	rdp = RCU_DATA_CPU(cpu);
-	spin_lock_irqsave(&rdp->lock, flags);
-	rdp->rcu_sched_sleeping = 1;
-	spin_unlock_irqrestore(&rdp->lock, flags);
-}
-
-static void rcu_process_callbacks(struct softirq_action *unused)
-{
-	unsigned long flags;
-	struct rcu_head *next, *list;
-	struct rcu_data *rdp;
-
-	local_irq_save(flags);
-	rdp = RCU_DATA_ME();
-	spin_lock(&rdp->lock);
-	list = rdp->donelist;
-	if (list == NULL) {
-		spin_unlock_irqrestore(&rdp->lock, flags);
-		return;
-	}
-	rdp->donelist = NULL;
-	rdp->donetail = &rdp->donelist;
-	RCU_TRACE_RDP(rcupreempt_trace_done_remove, rdp);
-	spin_unlock_irqrestore(&rdp->lock, flags);
-	while (list) {
-		next = list->next;
-		list->func(list);
-		list = next;
-		RCU_TRACE_ME(rcupreempt_trace_invoke);
-	}
-}
-
-void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
-{
-	unsigned long flags;
-	struct rcu_data *rdp;
-
-	head->func = func;
-	head->next = NULL;
-	local_irq_save(flags);
-	rdp = RCU_DATA_ME();
-	spin_lock(&rdp->lock);
-	__rcu_advance_callbacks(rdp);
-	*rdp->nexttail = head;
-	rdp->nexttail = &head->next;
-	RCU_TRACE_RDP(rcupreempt_trace_next_add, rdp);
-	spin_unlock_irqrestore(&rdp->lock, flags);
-}
-EXPORT_SYMBOL_GPL(call_rcu);
-
-void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
-{
-	unsigned long flags;
-	struct rcu_data *rdp;
-	int wake_gp = 0;
-
-	head->func = func;
-	head->next = NULL;
-	local_irq_save(flags);
-	rdp = RCU_DATA_ME();
-	spin_lock(&rdp->lock);
-	*rdp->nextschedtail = head;
-	rdp->nextschedtail = &head->next;
-	if (rdp->rcu_sched_sleeping) {
-
-		/* Grace-period processing might be sleeping... */
-
-		rdp->rcu_sched_sleeping = 0;
-		wake_gp = 1;
-	}
-	spin_unlock_irqrestore(&rdp->lock, flags);
-	if (wake_gp) {
-
-		/* Wake up grace-period processing, unless someone beat us. */
-
-		spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
-		if (rcu_ctrlblk.sched_sleep != rcu_sched_sleeping)
-			wake_gp = 0;
-		rcu_ctrlblk.sched_sleep = rcu_sched_not_sleeping;
-		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
-		if (wake_gp)
-			wake_up_interruptible(&rcu_ctrlblk.sched_wq);
-	}
-}
-EXPORT_SYMBOL_GPL(call_rcu_sched);
-
-/*
- * Wait until all currently running preempt_disable() code segments
- * (including hardware-irq-disable segments) complete.  Note that
- * in -rt this does -not- necessarily result in all currently executing
- * interrupt -handlers- having completed.
- */
-void __synchronize_sched(void)
-{
-	struct rcu_synchronize rcu;
-
-	if (num_online_cpus() == 1)
-		return;  /* blocking is gp if only one CPU! */
-
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished. */
-	call_rcu_sched(&rcu.head, wakeme_after_rcu);
-	/* Wait for it. */
-	wait_for_completion(&rcu.completion);
-}
-EXPORT_SYMBOL_GPL(__synchronize_sched);
-
-/*
- * kthread function that manages call_rcu_sched grace periods.
- */
-static int rcu_sched_grace_period(void *arg)
-{
-	int couldsleep;		/* might sleep after current pass. */
-	int couldsleepnext = 0; /* might sleep after next pass. */
-	int cpu;
-	unsigned long flags;
-	struct rcu_data *rdp;
-	int ret;
-
-	/*
-	 * Each pass through the following loop handles one
-	 * rcu_sched grace period cycle.
-	 */
-	do {
-		/* Save each CPU's current state. */
-
-		for_each_online_cpu(cpu) {
-			dyntick_save_progress_counter_sched(cpu);
-			save_qsctr_sched(cpu);
-		}
-
-		/*
-		 * Sleep for about an RCU grace-period's worth to
-		 * allow better batching and to consume less CPU.
-		 */
-		schedule_timeout_interruptible(RCU_SCHED_BATCH_TIME);
-
-		/*
-		 * If there was nothing to do last time, prepare to
-		 * sleep at the end of the current grace period cycle.
-		 */
-		couldsleep = couldsleepnext;
-		couldsleepnext = 1;
-		if (couldsleep) {
-			spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
-			rcu_ctrlblk.sched_sleep = rcu_sched_sleep_prep;
-			spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
-		}
-
-		/*
-		 * Wait on each CPU in turn to have either visited
-		 * a quiescent state or been in dynticks-idle mode.
-		 */
-		for_each_online_cpu(cpu) {
-			while (rcu_qsctr_inc_needed(cpu) &&
-			       rcu_qsctr_inc_needed_dyntick(cpu)) {
-				/* resched_cpu(cpu); @@@ */
-				schedule_timeout_interruptible(1);
-			}
-		}
-
-		/* Advance callbacks for each CPU.  */
-
-		for_each_online_cpu(cpu) {
-
-			rdp = RCU_DATA_CPU(cpu);
-			spin_lock_irqsave(&rdp->lock, flags);
-
-			/*
-			 * We are running on this CPU irq-disabled, so no
-			 * CPU can go offline until we re-enable irqs.
-			 * The current CPU might have already gone
-			 * offline (between the for_each_offline_cpu and
-			 * the spin_lock_irqsave), but in that case all its
-			 * callback lists will be empty, so no harm done.
-			 *
-			 * Advance the callbacks!  We share normal RCU's
-			 * donelist, since callbacks are invoked the
-			 * same way in either case.
-			 */
-			if (rdp->waitschedlist != NULL) {
-				*rdp->donetail = rdp->waitschedlist;
-				rdp->donetail = rdp->waitschedtail;
-
-				/*
-				 * Next rcu_check_callbacks() will
-				 * do the required raise_softirq().
-				 */
-			}
-			if (rdp->nextschedlist != NULL) {
-				rdp->waitschedlist = rdp->nextschedlist;
-				rdp->waitschedtail = rdp->nextschedtail;
-				couldsleep = 0;
-				couldsleepnext = 0;
-			} else {
-				rdp->waitschedlist = NULL;
-				rdp->waitschedtail = &rdp->waitschedlist;
-			}
-			rdp->nextschedlist = NULL;
-			rdp->nextschedtail = &rdp->nextschedlist;
-
-			/* Mark sleep intention. */
-
-			rdp->rcu_sched_sleeping = couldsleep;
-
-			spin_unlock_irqrestore(&rdp->lock, flags);
-		}
-
-		/* If we saw callbacks on the last scan, go deal with them. */
-
-		if (!couldsleep)
-			continue;
-
-		/* Attempt to block... */
-
-		spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
-		if (rcu_ctrlblk.sched_sleep != rcu_sched_sleep_prep) {
-
-			/*
-			 * Someone posted a callback after we scanned.
-			 * Go take care of it.
-			 */
-			spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
-			couldsleepnext = 0;
-			continue;
-		}
-
-		/* Block until the next person posts a callback. */
-
-		rcu_ctrlblk.sched_sleep = rcu_sched_sleeping;
-		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
-		ret = 0; /* unused */
-		__wait_event_interruptible(rcu_ctrlblk.sched_wq,
-			rcu_ctrlblk.sched_sleep != rcu_sched_sleeping,
-			ret);
-
-		couldsleepnext = 0;
-
-	} while (!kthread_should_stop());
-
-	return (0);
-}
-
-/*
- * Check to see if any future RCU-related work will need to be done
- * by the current CPU, even if none need be done immediately, returning
- * 1 if so.  Assumes that notifiers would take care of handling any
- * outstanding requests from the RCU core.
- *
- * This function is part of the RCU implementation; it is -not-
- * an exported member of the RCU API.
- */
-int rcu_needs_cpu(int cpu)
-{
-	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
-
-	return (rdp->donelist != NULL ||
-		!!rdp->waitlistcount ||
-		rdp->nextlist != NULL ||
-		rdp->nextschedlist != NULL ||
-		rdp->waitschedlist != NULL);
-}
-
-int rcu_pending(int cpu)
-{
-	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
-
-	/* The CPU has at least one callback queued somewhere. */
-
-	if (rdp->donelist != NULL ||
-	    !!rdp->waitlistcount ||
-	    rdp->nextlist != NULL ||
-	    rdp->nextschedlist != NULL ||
-	    rdp->waitschedlist != NULL)
-		return 1;
-
-	/* The RCU core needs an acknowledgement from this CPU. */
-
-	if ((per_cpu(rcu_flip_flag, cpu) == rcu_flipped) ||
-	    (per_cpu(rcu_mb_flag, cpu) == rcu_mb_needed))
-		return 1;
-
-	/* This CPU has fallen behind the global grace-period number. */
-
-	if (rdp->completed != rcu_ctrlblk.completed)
-		return 1;
-
-	/* Nothing needed from this CPU. */
-
-	return 0;
-}
-
-static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
-				unsigned long action, void *hcpu)
-{
-	long cpu = (long)hcpu;
-
-	switch (action) {
-	case CPU_UP_PREPARE:
-	case CPU_UP_PREPARE_FROZEN:
-		rcu_online_cpu(cpu);
-		break;
-	case CPU_UP_CANCELED:
-	case CPU_UP_CANCELED_FROZEN:
-	case CPU_DEAD:
-	case CPU_DEAD_FROZEN:
-		rcu_offline_cpu(cpu);
-		break;
-	default:
-		break;
-	}
-	return NOTIFY_OK;
-}
-
-static struct notifier_block __cpuinitdata rcu_nb = {
-	.notifier_call = rcu_cpu_notify,
-};
-
-void __init __rcu_init(void)
-{
-	int cpu;
-	int i;
-	struct rcu_data *rdp;
-
-	printk(KERN_NOTICE "Preemptible RCU implementation.\n");
-	for_each_possible_cpu(cpu) {
-		rdp = RCU_DATA_CPU(cpu);
-		spin_lock_init(&rdp->lock);
-		rdp->completed = 0;
-		rdp->waitlistcount = 0;
-		rdp->nextlist = NULL;
-		rdp->nexttail = &rdp->nextlist;
-		for (i = 0; i < GP_STAGES; i++) {
-			rdp->waitlist[i] = NULL;
-			rdp->waittail[i] = &rdp->waitlist[i];
-		}
-		rdp->donelist = NULL;
-		rdp->donetail = &rdp->donelist;
-		rdp->rcu_flipctr[0] = 0;
-		rdp->rcu_flipctr[1] = 0;
-		rdp->nextschedlist = NULL;
-		rdp->nextschedtail = &rdp->nextschedlist;
-		rdp->waitschedlist = NULL;
-		rdp->waitschedtail = &rdp->waitschedlist;
-		rdp->rcu_sched_sleeping = 0;
-	}
-	register_cpu_notifier(&rcu_nb);
-
-	/*
-	 * We don't need protection against CPU-Hotplug here
-	 * since
-	 * a) If a CPU comes online while we are iterating over the
-	 *    cpu_online_mask below, we would only end up making a
-	 *    duplicate call to rcu_online_cpu() which sets the corresponding
-	 *    CPU's mask in the rcu_cpu_online_map.
-	 *
-	 * b) A CPU cannot go offline at this point in time since the user
-	 *    does not have access to the sysfs interface, nor do we
-	 *    suspend the system.
-	 */
-	for_each_online_cpu(cpu)
-		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE,	(void *)(long) cpu);
-
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
-}
-
-/*
- * Late-boot-time RCU initialization that must wait until after scheduler
- * has been initialized.
- */
-void __init rcu_init_sched(void)
-{
-	rcu_sched_grace_period_task = kthread_run(rcu_sched_grace_period,
-						  NULL,
-						  "rcu_sched_grace_period");
-	WARN_ON(IS_ERR(rcu_sched_grace_period_task));
-}
-
-#ifdef CONFIG_RCU_TRACE
-long *rcupreempt_flipctr(int cpu)
-{
-	return &RCU_DATA_CPU(cpu)->rcu_flipctr[0];
-}
-EXPORT_SYMBOL_GPL(rcupreempt_flipctr);
-
-int rcupreempt_flip_flag(int cpu)
-{
-	return per_cpu(rcu_flip_flag, cpu);
-}
-EXPORT_SYMBOL_GPL(rcupreempt_flip_flag);
-
-int rcupreempt_mb_flag(int cpu)
-{
-	return per_cpu(rcu_mb_flag, cpu);
-}
-EXPORT_SYMBOL_GPL(rcupreempt_mb_flag);
-
-char *rcupreempt_try_flip_state_name(void)
-{
-	return rcu_try_flip_state_names[rcu_ctrlblk.rcu_try_flip_state];
-}
-EXPORT_SYMBOL_GPL(rcupreempt_try_flip_state_name);
-
-struct rcupreempt_trace *rcupreempt_trace_cpu(int cpu)
-{
-	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
-
-	return &rdp->trace;
-}
-EXPORT_SYMBOL_GPL(rcupreempt_trace_cpu);
-
-#endif /* #ifdef RCU_TRACE */
diff --git a/kernel/rcupreempt_trace.c b/kernel/rcupreempt_trace.c
deleted file mode 100644
index 7c2665c..0000000
--- a/kernel/rcupreempt_trace.c
+++ /dev/null
@@ -1,334 +0,0 @@
-/*
- * Read-Copy Update tracing for realtime implementation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
- *
- * Copyright IBM Corporation, 2006
- *
- * Papers:  http://www.rdrop.com/users/paulmck/RCU
- *
- * For detailed explanation of Read-Copy Update mechanism see -
- * 		Documentation/RCU/ *.txt
- *
- */
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/spinlock.h>
-#include <linux/smp.h>
-#include <linux/rcupdate.h>
-#include <linux/interrupt.h>
-#include <linux/sched.h>
-#include <asm/atomic.h>
-#include <linux/bitops.h>
-#include <linux/module.h>
-#include <linux/completion.h>
-#include <linux/moduleparam.h>
-#include <linux/percpu.h>
-#include <linux/notifier.h>
-#include <linux/cpu.h>
-#include <linux/mutex.h>
-#include <linux/rcupreempt_trace.h>
-#include <linux/debugfs.h>
-
-static struct mutex rcupreempt_trace_mutex;
-static char *rcupreempt_trace_buf;
-#define RCUPREEMPT_TRACE_BUF_SIZE 4096
-
-void rcupreempt_trace_move2done(struct rcupreempt_trace *trace)
-{
-	trace->done_length += trace->wait_length;
-	trace->done_add += trace->wait_length;
-	trace->wait_length = 0;
-}
-void rcupreempt_trace_move2wait(struct rcupreempt_trace *trace)
-{
-	trace->wait_length += trace->next_length;
-	trace->wait_add += trace->next_length;
-	trace->next_length = 0;
-}
-void rcupreempt_trace_try_flip_1(struct rcupreempt_trace *trace)
-{
-	atomic_inc(&trace->rcu_try_flip_1);
-}
-void rcupreempt_trace_try_flip_e1(struct rcupreempt_trace *trace)
-{
-	atomic_inc(&trace->rcu_try_flip_e1);
-}
-void rcupreempt_trace_try_flip_i1(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_i1++;
-}
-void rcupreempt_trace_try_flip_ie1(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_ie1++;
-}
-void rcupreempt_trace_try_flip_g1(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_g1++;
-}
-void rcupreempt_trace_try_flip_a1(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_a1++;
-}
-void rcupreempt_trace_try_flip_ae1(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_ae1++;
-}
-void rcupreempt_trace_try_flip_a2(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_a2++;
-}
-void rcupreempt_trace_try_flip_z1(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_z1++;
-}
-void rcupreempt_trace_try_flip_ze1(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_ze1++;
-}
-void rcupreempt_trace_try_flip_z2(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_z2++;
-}
-void rcupreempt_trace_try_flip_m1(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_m1++;
-}
-void rcupreempt_trace_try_flip_me1(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_me1++;
-}
-void rcupreempt_trace_try_flip_m2(struct rcupreempt_trace *trace)
-{
-	trace->rcu_try_flip_m2++;
-}
-void rcupreempt_trace_check_callbacks(struct rcupreempt_trace *trace)
-{
-	trace->rcu_check_callbacks++;
-}
-void rcupreempt_trace_done_remove(struct rcupreempt_trace *trace)
-{
-	trace->done_remove += trace->done_length;
-	trace->done_length = 0;
-}
-void rcupreempt_trace_invoke(struct rcupreempt_trace *trace)
-{
-	atomic_inc(&trace->done_invoked);
-}
-void rcupreempt_trace_next_add(struct rcupreempt_trace *trace)
-{
-	trace->next_add++;
-	trace->next_length++;
-}
-
-static void rcupreempt_trace_sum(struct rcupreempt_trace *sp)
-{
-	struct rcupreempt_trace *cp;
-	int cpu;
-
-	memset(sp, 0, sizeof(*sp));
-	for_each_possible_cpu(cpu) {
-		cp = rcupreempt_trace_cpu(cpu);
-		sp->next_length += cp->next_length;
-		sp->next_add += cp->next_add;
-		sp->wait_length += cp->wait_length;
-		sp->wait_add += cp->wait_add;
-		sp->done_length += cp->done_length;
-		sp->done_add += cp->done_add;
-		sp->done_remove += cp->done_remove;
-		atomic_add(atomic_read(&cp->done_invoked), &sp->done_invoked);
-		sp->rcu_check_callbacks += cp->rcu_check_callbacks;
-		atomic_add(atomic_read(&cp->rcu_try_flip_1),
-			   &sp->rcu_try_flip_1);
-		atomic_add(atomic_read(&cp->rcu_try_flip_e1),
-			   &sp->rcu_try_flip_e1);
-		sp->rcu_try_flip_i1 += cp->rcu_try_flip_i1;
-		sp->rcu_try_flip_ie1 += cp->rcu_try_flip_ie1;
-		sp->rcu_try_flip_g1 += cp->rcu_try_flip_g1;
-		sp->rcu_try_flip_a1 += cp->rcu_try_flip_a1;
-		sp->rcu_try_flip_ae1 += cp->rcu_try_flip_ae1;
-		sp->rcu_try_flip_a2 += cp->rcu_try_flip_a2;
-		sp->rcu_try_flip_z1 += cp->rcu_try_flip_z1;
-		sp->rcu_try_flip_ze1 += cp->rcu_try_flip_ze1;
-		sp->rcu_try_flip_z2 += cp->rcu_try_flip_z2;
-		sp->rcu_try_flip_m1 += cp->rcu_try_flip_m1;
-		sp->rcu_try_flip_me1 += cp->rcu_try_flip_me1;
-		sp->rcu_try_flip_m2 += cp->rcu_try_flip_m2;
-	}
-}
-
-static ssize_t rcustats_read(struct file *filp, char __user *buffer,
-				size_t count, loff_t *ppos)
-{
-	struct rcupreempt_trace trace;
-	ssize_t bcount;
-	int cnt = 0;
-
-	rcupreempt_trace_sum(&trace);
-	mutex_lock(&rcupreempt_trace_mutex);
-	snprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE - cnt,
-		 "ggp=%ld rcc=%ld\n",
-		 rcu_batches_completed(),
-		 trace.rcu_check_callbacks);
-	snprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE - cnt,
-		 "na=%ld nl=%ld wa=%ld wl=%ld da=%ld dl=%ld dr=%ld di=%d\n"
-		 "1=%d e1=%d i1=%ld ie1=%ld g1=%ld a1=%ld ae1=%ld a2=%ld\n"
-		 "z1=%ld ze1=%ld z2=%ld m1=%ld me1=%ld m2=%ld\n",
-
-		 trace.next_add, trace.next_length,
-		 trace.wait_add, trace.wait_length,
-		 trace.done_add, trace.done_length,
-		 trace.done_remove, atomic_read(&trace.done_invoked),
-		 atomic_read(&trace.rcu_try_flip_1),
-		 atomic_read(&trace.rcu_try_flip_e1),
-		 trace.rcu_try_flip_i1, trace.rcu_try_flip_ie1,
-		 trace.rcu_try_flip_g1,
-		 trace.rcu_try_flip_a1, trace.rcu_try_flip_ae1,
-			 trace.rcu_try_flip_a2,
-		 trace.rcu_try_flip_z1, trace.rcu_try_flip_ze1,
-			 trace.rcu_try_flip_z2,
-		 trace.rcu_try_flip_m1, trace.rcu_try_flip_me1,
-			trace.rcu_try_flip_m2);
-	bcount = simple_read_from_buffer(buffer, count, ppos,
-			rcupreempt_trace_buf, strlen(rcupreempt_trace_buf));
-	mutex_unlock(&rcupreempt_trace_mutex);
-	return bcount;
-}
-
-static ssize_t rcugp_read(struct file *filp, char __user *buffer,
-				size_t count, loff_t *ppos)
-{
-	long oldgp = rcu_batches_completed();
-	ssize_t bcount;
-
-	mutex_lock(&rcupreempt_trace_mutex);
-	synchronize_rcu();
-	snprintf(rcupreempt_trace_buf, RCUPREEMPT_TRACE_BUF_SIZE,
-		"oldggp=%ld  newggp=%ld\n", oldgp, rcu_batches_completed());
-	bcount = simple_read_from_buffer(buffer, count, ppos,
-			rcupreempt_trace_buf, strlen(rcupreempt_trace_buf));
-	mutex_unlock(&rcupreempt_trace_mutex);
-	return bcount;
-}
-
-static ssize_t rcuctrs_read(struct file *filp, char __user *buffer,
-				size_t count, loff_t *ppos)
-{
-	int cnt = 0;
-	int cpu;
-	int f = rcu_batches_completed() & 0x1;
-	ssize_t bcount;
-
-	mutex_lock(&rcupreempt_trace_mutex);
-
-	cnt += snprintf(&rcupreempt_trace_buf[cnt], RCUPREEMPT_TRACE_BUF_SIZE,
-				"CPU last cur F M\n");
-	for_each_online_cpu(cpu) {
-		long *flipctr = rcupreempt_flipctr(cpu);
-		cnt += snprintf(&rcupreempt_trace_buf[cnt],
-				RCUPREEMPT_TRACE_BUF_SIZE - cnt,
-					"%3d %4ld %3ld %d %d\n",
-			       cpu,
-			       flipctr[!f],
-			       flipctr[f],
-			       rcupreempt_flip_flag(cpu),
-			       rcupreempt_mb_flag(cpu));
-	}
-	cnt += snprintf(&rcupreempt_trace_buf[cnt],
-			RCUPREEMPT_TRACE_BUF_SIZE - cnt,
-			"ggp = %ld, state = %s\n",
-			rcu_batches_completed(),
-			rcupreempt_try_flip_state_name());
-	cnt += snprintf(&rcupreempt_trace_buf[cnt],
-			RCUPREEMPT_TRACE_BUF_SIZE - cnt,
-			"\n");
-	bcount = simple_read_from_buffer(buffer, count, ppos,
-			rcupreempt_trace_buf, strlen(rcupreempt_trace_buf));
-	mutex_unlock(&rcupreempt_trace_mutex);
-	return bcount;
-}
-
-static struct file_operations rcustats_fops = {
-	.owner = THIS_MODULE,
-	.read = rcustats_read,
-};
-
-static struct file_operations rcugp_fops = {
-	.owner = THIS_MODULE,
-	.read = rcugp_read,
-};
-
-static struct file_operations rcuctrs_fops = {
-	.owner = THIS_MODULE,
-	.read = rcuctrs_read,
-};
-
-static struct dentry *rcudir, *statdir, *ctrsdir, *gpdir;
-static int rcupreempt_debugfs_init(void)
-{
-	rcudir = debugfs_create_dir("rcu", NULL);
-	if (!rcudir)
-		goto out;
-	statdir = debugfs_create_file("rcustats", 0444, rcudir,
-						NULL, &rcustats_fops);
-	if (!statdir)
-		goto free_out;
-
-	gpdir = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
-	if (!gpdir)
-		goto free_out;
-
-	ctrsdir = debugfs_create_file("rcuctrs", 0444, rcudir,
-						NULL, &rcuctrs_fops);
-	if (!ctrsdir)
-		goto free_out;
-	return 0;
-free_out:
-	if (statdir)
-		debugfs_remove(statdir);
-	if (gpdir)
-		debugfs_remove(gpdir);
-	debugfs_remove(rcudir);
-out:
-	return 1;
-}
-
-static int __init rcupreempt_trace_init(void)
-{
-	int ret;
-
-	mutex_init(&rcupreempt_trace_mutex);
-	rcupreempt_trace_buf = kmalloc(RCUPREEMPT_TRACE_BUF_SIZE, GFP_KERNEL);
-	if (!rcupreempt_trace_buf)
-		return 1;
-	ret = rcupreempt_debugfs_init();
-	if (ret)
-		kfree(rcupreempt_trace_buf);
-	return ret;
-}
-
-static void __exit rcupreempt_trace_cleanup(void)
-{
-	debugfs_remove(statdir);
-	debugfs_remove(gpdir);
-	debugfs_remove(ctrsdir);
-	debugfs_remove(rcudir);
-	kfree(rcupreempt_trace_buf);
-}
-
-
-module_init(rcupreempt_trace_init);
-module_exit(rcupreempt_trace_cleanup);
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 9b4a975..b33db53 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -257,14 +257,14 @@ struct rcu_torture_ops {
 	void (*init)(void);
 	void (*cleanup)(void);
 	int (*readlock)(void);
-	void (*readdelay)(struct rcu_random_state *rrsp);
+	void (*read_delay)(struct rcu_random_state *rrsp);
 	void (*readunlock)(int idx);
 	int (*completed)(void);
-	void (*deferredfree)(struct rcu_torture *p);
+	void (*deferred_free)(struct rcu_torture *p);
 	void (*sync)(void);
 	void (*cb_barrier)(void);
 	int (*stats)(char *page);
-	int irqcapable;
+	int irq_capable;
 	char *name;
 };
 static struct rcu_torture_ops *cur_ops = NULL;
@@ -320,7 +320,7 @@ rcu_torture_cb(struct rcu_head *p)
 		rp->rtort_mbtest = 0;
 		rcu_torture_free(rp);
 	} else
-		cur_ops->deferredfree(rp);
+		cur_ops->deferred_free(rp);
 }
 
 static void rcu_torture_deferred_free(struct rcu_torture *p)
@@ -329,18 +329,18 @@ static void rcu_torture_deferred_free(struct rcu_torture *p)
 }
 
 static struct rcu_torture_ops rcu_ops = {
-	.init = NULL,
-	.cleanup = NULL,
-	.readlock = rcu_torture_read_lock,
-	.readdelay = rcu_read_delay,
-	.readunlock = rcu_torture_read_unlock,
-	.completed = rcu_torture_completed,
-	.deferredfree = rcu_torture_deferred_free,
-	.sync = synchronize_rcu,
-	.cb_barrier = rcu_barrier,
-	.stats = NULL,
-	.irqcapable = 1,
-	.name = "rcu"
+	.init		= NULL,
+	.cleanup	= NULL,
+	.readlock	= rcu_torture_read_lock,
+	.read_delay	= rcu_read_delay,
+	.readunlock	= rcu_torture_read_unlock,
+	.completed	= rcu_torture_completed,
+	.deferred_free	= rcu_torture_deferred_free,
+	.sync		= synchronize_rcu,
+	.cb_barrier	= rcu_barrier,
+	.stats		= NULL,
+	.irq_capable 	= 1,
+	.name 		= "rcu"
 };
 
 static void rcu_sync_torture_deferred_free(struct rcu_torture *p)
@@ -370,18 +370,18 @@ static void rcu_sync_torture_init(void)
 }
 
 static struct rcu_torture_ops rcu_sync_ops = {
-	.init = rcu_sync_torture_init,
-	.cleanup = NULL,
-	.readlock = rcu_torture_read_lock,
-	.readdelay = rcu_read_delay,
-	.readunlock = rcu_torture_read_unlock,
-	.completed = rcu_torture_completed,
-	.deferredfree = rcu_sync_torture_deferred_free,
-	.sync = synchronize_rcu,
-	.cb_barrier = NULL,
-	.stats = NULL,
-	.irqcapable = 1,
-	.name = "rcu_sync"
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= rcu_torture_read_lock,
+	.read_delay	= rcu_read_delay,
+	.readunlock	= rcu_torture_read_unlock,
+	.completed	= rcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= synchronize_rcu,
+	.cb_barrier	= NULL,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_sync"
 };
 
 /*
@@ -432,33 +432,33 @@ static void rcu_bh_torture_synchronize(void)
 }
 
 static struct rcu_torture_ops rcu_bh_ops = {
-	.init = NULL,
-	.cleanup = NULL,
-	.readlock = rcu_bh_torture_read_lock,
-	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock = rcu_bh_torture_read_unlock,
-	.completed = rcu_bh_torture_completed,
-	.deferredfree = rcu_bh_torture_deferred_free,
-	.sync = rcu_bh_torture_synchronize,
-	.cb_barrier = rcu_barrier_bh,
-	.stats = NULL,
-	.irqcapable = 1,
-	.name = "rcu_bh"
+	.init		= NULL,
+	.cleanup	= NULL,
+	.readlock	= rcu_bh_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= rcu_bh_torture_read_unlock,
+	.completed	= rcu_bh_torture_completed,
+	.deferred_free	= rcu_bh_torture_deferred_free,
+	.sync		= rcu_bh_torture_synchronize,
+	.cb_barrier	= rcu_barrier_bh,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_bh"
 };
 
 static struct rcu_torture_ops rcu_bh_sync_ops = {
-	.init = rcu_sync_torture_init,
-	.cleanup = NULL,
-	.readlock = rcu_bh_torture_read_lock,
-	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock = rcu_bh_torture_read_unlock,
-	.completed = rcu_bh_torture_completed,
-	.deferredfree = rcu_sync_torture_deferred_free,
-	.sync = rcu_bh_torture_synchronize,
-	.cb_barrier = NULL,
-	.stats = NULL,
-	.irqcapable = 1,
-	.name = "rcu_bh_sync"
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= rcu_bh_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= rcu_bh_torture_read_unlock,
+	.completed	= rcu_bh_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= rcu_bh_torture_synchronize,
+	.cb_barrier	= NULL,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "rcu_bh_sync"
 };
 
 /*
@@ -530,17 +530,17 @@ static int srcu_torture_stats(char *page)
 }
 
 static struct rcu_torture_ops srcu_ops = {
-	.init = srcu_torture_init,
-	.cleanup = srcu_torture_cleanup,
-	.readlock = srcu_torture_read_lock,
-	.readdelay = srcu_read_delay,
-	.readunlock = srcu_torture_read_unlock,
-	.completed = srcu_torture_completed,
-	.deferredfree = rcu_sync_torture_deferred_free,
-	.sync = srcu_torture_synchronize,
-	.cb_barrier = NULL,
-	.stats = srcu_torture_stats,
-	.name = "srcu"
+	.init		= srcu_torture_init,
+	.cleanup	= srcu_torture_cleanup,
+	.readlock	= srcu_torture_read_lock,
+	.read_delay	= srcu_read_delay,
+	.readunlock	= srcu_torture_read_unlock,
+	.completed	= srcu_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= srcu_torture_synchronize,
+	.cb_barrier	= NULL,
+	.stats		= srcu_torture_stats,
+	.name		= "srcu"
 };
 
 /*
@@ -574,32 +574,49 @@ static void sched_torture_synchronize(void)
 }
 
 static struct rcu_torture_ops sched_ops = {
-	.init = rcu_sync_torture_init,
-	.cleanup = NULL,
-	.readlock = sched_torture_read_lock,
-	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock = sched_torture_read_unlock,
-	.completed = sched_torture_completed,
-	.deferredfree = rcu_sched_torture_deferred_free,
-	.sync = sched_torture_synchronize,
-	.cb_barrier = rcu_barrier_sched,
-	.stats = NULL,
-	.irqcapable = 1,
-	.name = "sched"
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= sched_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= sched_torture_read_unlock,
+	.completed	= sched_torture_completed,
+	.deferred_free	= rcu_sched_torture_deferred_free,
+	.sync		= sched_torture_synchronize,
+	.cb_barrier	= rcu_barrier_sched,
+	.stats		= NULL,
+	.irq_capable	= 1,
+	.name		= "sched"
 };
 
 static struct rcu_torture_ops sched_ops_sync = {
-	.init = rcu_sync_torture_init,
-	.cleanup = NULL,
-	.readlock = sched_torture_read_lock,
-	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
-	.readunlock = sched_torture_read_unlock,
-	.completed = sched_torture_completed,
-	.deferredfree = rcu_sync_torture_deferred_free,
-	.sync = sched_torture_synchronize,
-	.cb_barrier = NULL,
-	.stats = NULL,
-	.name = "sched_sync"
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= sched_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= sched_torture_read_unlock,
+	.completed	= sched_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= sched_torture_synchronize,
+	.cb_barrier	= NULL,
+	.stats		= NULL,
+	.name		= "sched_sync"
+};
+
+extern int rcu_expedited_torture_stats(char *page);
+
+static struct rcu_torture_ops sched_expedited_ops = {
+	.init		= rcu_sync_torture_init,
+	.cleanup	= NULL,
+	.readlock	= sched_torture_read_lock,
+	.read_delay	= rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock	= sched_torture_read_unlock,
+	.completed	= sched_torture_completed,
+	.deferred_free	= rcu_sync_torture_deferred_free,
+	.sync		= synchronize_sched_expedited,
+	.cb_barrier	= NULL,
+	.stats		= rcu_expedited_torture_stats,
+	.irq_capable	= 1,
+	.name		= "sched_expedited"
 };
 
 /*
@@ -635,7 +652,7 @@ rcu_torture_writer(void *arg)
 				i = RCU_TORTURE_PIPE_LEN;
 			atomic_inc(&rcu_torture_wcount[i]);
 			old_rp->rtort_pipe_count++;
-			cur_ops->deferredfree(old_rp);
+			cur_ops->deferred_free(old_rp);
 		}
 		rcu_torture_current_version++;
 		oldbatch = cur_ops->completed();
@@ -700,7 +717,7 @@ static void rcu_torture_timer(unsigned long unused)
 	if (p->rtort_mbtest == 0)
 		atomic_inc(&n_rcu_torture_mberror);
 	spin_lock(&rand_lock);
-	cur_ops->readdelay(&rand);
+	cur_ops->read_delay(&rand);
 	n_rcu_torture_timers++;
 	spin_unlock(&rand_lock);
 	preempt_disable();
@@ -738,11 +755,11 @@ rcu_torture_reader(void *arg)
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
-	if (irqreader && cur_ops->irqcapable)
+	if (irqreader && cur_ops->irq_capable)
 		setup_timer_on_stack(&t, rcu_torture_timer, 0);
 
 	do {
-		if (irqreader && cur_ops->irqcapable) {
+		if (irqreader && cur_ops->irq_capable) {
 			if (!timer_pending(&t))
 				mod_timer(&t, 1);
 		}
@@ -757,7 +774,7 @@ rcu_torture_reader(void *arg)
 		}
 		if (p->rtort_mbtest == 0)
 			atomic_inc(&n_rcu_torture_mberror);
-		cur_ops->readdelay(&rand);
+		cur_ops->read_delay(&rand);
 		preempt_disable();
 		pipe_count = p->rtort_pipe_count;
 		if (pipe_count > RCU_TORTURE_PIPE_LEN) {
@@ -778,7 +795,7 @@ rcu_torture_reader(void *arg)
 	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
 	rcutorture_shutdown_absorb("rcu_torture_reader");
-	if (irqreader && cur_ops->irqcapable)
+	if (irqreader && cur_ops->irq_capable)
 		del_timer_sync(&t);
 	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
@@ -1078,6 +1095,7 @@ rcu_torture_init(void)
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
+		  &sched_expedited_ops,
 		  &srcu_ops, &sched_ops, &sched_ops_sync, };
 
 	mutex_lock(&fullstop_mutex);
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 7717b95..71bc797 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -46,6 +46,8 @@
 #include <linux/mutex.h>
 #include <linux/time.h>
 
+#include "rcutree.h"
+
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
@@ -72,30 +74,59 @@ EXPORT_SYMBOL_GPL(rcu_lock_map);
 	.n_force_qs_ngp = 0, \
 }
 
-struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
-DEFINE_PER_CPU(struct rcu_data, rcu_data);
+struct rcu_state rcu_sched_state = RCU_STATE_INITIALIZER(rcu_sched_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+extern long rcu_batches_completed_sched(void);
+static struct rcu_node *rcu_get_root(struct rcu_state *rsp);
+static void cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp,
+			  struct rcu_node *rnp, unsigned long flags);
+static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags);
+#ifdef CONFIG_HOTPLUG_CPU
+static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp);
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+static void __rcu_process_callbacks(struct rcu_state *rsp,
+				    struct rcu_data *rdp);
+static void __call_rcu(struct rcu_head *head,
+		       void (*func)(struct rcu_head *rcu),
+		       struct rcu_state *rsp);
+static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp);
+static void __cpuinit rcu_init_percpu_data(int cpu, struct rcu_state *rsp,
+					   int preemptable);
+
+#include "rcutree_plugin.h"
+
 /*
- * Increment the quiescent state counter.
- * The counter is a bit degenerated: We do not need to know
+ * Note a quiescent state.  Because we do not need to know
  * how many quiescent states passed, just if there was at least
- * one since the start of the grace period. Thus just a flag.
+ * one since the start of the grace period, this just sets a flag.
  */
-void rcu_qsctr_inc(int cpu)
+void rcu_sched_qs(int cpu)
 {
-	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
+	unsigned long flags;
+	struct rcu_data *rdp;
+
+	local_irq_save(flags);
+	rdp = &per_cpu(rcu_sched_data, cpu);
 	rdp->passed_quiesc = 1;
 	rdp->passed_quiesc_completed = rdp->completed;
+	rcu_preempt_qs(cpu);
+	local_irq_restore(flags);
 }
 
-void rcu_bh_qsctr_inc(int cpu)
+void rcu_bh_qs(int cpu)
 {
-	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
+	unsigned long flags;
+	struct rcu_data *rdp;
+
+	local_irq_save(flags);
+	rdp = &per_cpu(rcu_bh_data, cpu);
 	rdp->passed_quiesc = 1;
 	rdp->passed_quiesc_completed = rdp->completed;
+	local_irq_restore(flags);
 }
 
 #ifdef CONFIG_NO_HZ
@@ -110,15 +141,16 @@ static int qhimark = 10000;	/* If this many pending, ignore blimit. */
 static int qlowmark = 100;	/* Once only this many pending, use blimit. */
 
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
+static int rcu_pending(int cpu);
 
 /*
- * Return the number of RCU batches processed thus far for debug & stats.
+ * Return the number of RCU-sched batches processed thus far for debug & stats.
  */
-long rcu_batches_completed(void)
+long rcu_batches_completed_sched(void)
 {
-	return rcu_state.completed;
+	return rcu_sched_state.completed;
 }
-EXPORT_SYMBOL_GPL(rcu_batches_completed);
+EXPORT_SYMBOL_GPL(rcu_batches_completed_sched);
 
 /*
  * Return the number of RCU BH batches processed thus far for debug & stats.
@@ -181,6 +213,10 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 		return 1;
 	}
 
+	/* If preemptable RCU, no point in sending reschedule IPI. */
+	if (rdp->preemptable)
+		return 0;
+
 	/* The CPU is online, so send it a reschedule IPI. */
 	if (rdp->cpu != smp_processor_id())
 		smp_send_reschedule(rdp->cpu);
@@ -193,7 +229,6 @@ static int rcu_implicit_offline_qs(struct rcu_data *rdp)
 #endif /* #ifdef CONFIG_SMP */
 
 #ifdef CONFIG_NO_HZ
-static DEFINE_RATELIMIT_STATE(rcu_rs, 10 * HZ, 5);
 
 /**
  * rcu_enter_nohz - inform RCU that current CPU is entering nohz
@@ -213,7 +248,7 @@ void rcu_enter_nohz(void)
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	rdtp->dynticks++;
 	rdtp->dynticks_nesting--;
-	WARN_ON_RATELIMIT(rdtp->dynticks & 0x1, &rcu_rs);
+	WARN_ON_ONCE(rdtp->dynticks & 0x1);
 	local_irq_restore(flags);
 }
 
@@ -232,7 +267,7 @@ void rcu_exit_nohz(void)
 	rdtp = &__get_cpu_var(rcu_dynticks);
 	rdtp->dynticks++;
 	rdtp->dynticks_nesting++;
-	WARN_ON_RATELIMIT(!(rdtp->dynticks & 0x1), &rcu_rs);
+	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
 	local_irq_restore(flags);
 	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 }
@@ -251,7 +286,7 @@ void rcu_nmi_enter(void)
 	if (rdtp->dynticks & 0x1)
 		return;
 	rdtp->dynticks_nmi++;
-	WARN_ON_RATELIMIT(!(rdtp->dynticks_nmi & 0x1), &rcu_rs);
+	WARN_ON_ONCE(!(rdtp->dynticks_nmi & 0x1));
 	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 }
 
@@ -270,7 +305,7 @@ void rcu_nmi_exit(void)
 		return;
 	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
 	rdtp->dynticks_nmi++;
-	WARN_ON_RATELIMIT(rdtp->dynticks_nmi & 0x1, &rcu_rs);
+	WARN_ON_ONCE(rdtp->dynticks_nmi & 0x1);
 }
 
 /**
@@ -286,7 +321,7 @@ void rcu_irq_enter(void)
 	if (rdtp->dynticks_nesting++)
 		return;
 	rdtp->dynticks++;
-	WARN_ON_RATELIMIT(!(rdtp->dynticks & 0x1), &rcu_rs);
+	WARN_ON_ONCE(!(rdtp->dynticks & 0x1));
 	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
 }
 
@@ -305,10 +340,10 @@ void rcu_irq_exit(void)
 		return;
 	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
 	rdtp->dynticks++;
-	WARN_ON_RATELIMIT(rdtp->dynticks & 0x1, &rcu_rs);
+	WARN_ON_ONCE(rdtp->dynticks & 0x1);
 
 	/* If the interrupt queued a callback, get out of dyntick mode. */
-	if (__get_cpu_var(rcu_data).nxtlist ||
+	if (__get_cpu_var(rcu_sched_data).nxtlist ||
 	    __get_cpu_var(rcu_bh_data).nxtlist)
 		set_need_resched();
 }
@@ -461,6 +496,7 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
 	for (; rnp_cur < rnp_end; rnp_cur++) {
+		rcu_print_task_stall(rnp);
 		if (rnp_cur->qsmask == 0)
 			continue;
 		for (cpu = 0; cpu <= rnp_cur->grphi - rnp_cur->grplo; cpu++)
@@ -674,6 +710,19 @@ rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
 }
 
 /*
+ * Clean up after the prior grace period and let rcu_start_gp() start up
+ * the next grace period if one is needed.  Note that the caller must
+ * hold rnp->lock, as required by rcu_start_gp(), which will release it.
+ */
+static void cpu_quiet_msk_finish(struct rcu_state *rsp, unsigned long flags)
+	__releases(rnp->lock)
+{
+	rsp->completed = rsp->gpnum;
+	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
+	rcu_start_gp(rsp, flags);  /* releases root node's rnp->lock. */
+}
+
+/*
  * Similar to cpu_quiet(), for which it is a helper function.  Allows
  * a group of CPUs to be quieted at one go, though all the CPUs in the
  * group must be represented by the same leaf rcu_node structure.
@@ -694,7 +743,7 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 			return;
 		}
 		rnp->qsmask &= ~mask;
-		if (rnp->qsmask != 0) {
+		if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
 
 			/* Other bits still set at this level, so done. */
 			spin_unlock_irqrestore(&rnp->lock, flags);
@@ -714,14 +763,10 @@ cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
 
 	/*
 	 * Get here if we are the last CPU to pass through a quiescent
-	 * state for this grace period.  Clean up and let rcu_start_gp()
-	 * start up the next grace period if one is needed.  Note that
-	 * we still hold rnp->lock, as required by rcu_start_gp(), which
-	 * will release it.
+	 * state for this grace period.  Invoke cpu_quiet_msk_finish()
+	 * to clean up and start the next grace period if one is needed.
 	 */
-	rsp->completed = rsp->gpnum;
-	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
-	rcu_start_gp(rsp, flags);  /* releases rnp->lock. */
+	cpu_quiet_msk_finish(rsp, flags); /* releases rnp->lock. */
 }
 
 /*
@@ -828,11 +873,12 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 		spin_lock(&rnp->lock);		/* irqs already disabled. */
 		rnp->qsmaskinit &= ~mask;
 		if (rnp->qsmaskinit != 0) {
-			spin_unlock(&rnp->lock); /* irqs already disabled. */
+			spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
+		rcu_preempt_offline_tasks(rsp, rnp);
 		mask = rnp->grpmask;
-		spin_unlock(&rnp->lock);	/* irqs already disabled. */
+		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 		rnp = rnp->parent;
 	} while (rnp != NULL);
 	lastcomp = rsp->completed;
@@ -845,7 +891,7 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	/*
 	 * Move callbacks from the outgoing CPU to the running CPU.
 	 * Note that the outgoing CPU is now quiscent, so it is now
-	 * (uncharacteristically) safe to access it rcu_data structure.
+	 * (uncharacteristically) safe to access its rcu_data structure.
 	 * Note also that we must carefully retain the order of the
 	 * outgoing CPU's callbacks in order for rcu_barrier() to work
 	 * correctly.  Finally, note that we start all the callbacks
@@ -876,8 +922,9 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
  */
 static void rcu_offline_cpu(int cpu)
 {
-	__rcu_offline_cpu(cpu, &rcu_state);
+	__rcu_offline_cpu(cpu, &rcu_sched_state);
 	__rcu_offline_cpu(cpu, &rcu_bh_state);
+	rcu_preempt_offline_cpu(cpu);
 }
 
 #else /* #ifdef CONFIG_HOTPLUG_CPU */
@@ -963,6 +1010,8 @@ static void rcu_do_batch(struct rcu_data *rdp)
  */
 void rcu_check_callbacks(int cpu, int user)
 {
+	if (!rcu_pending(cpu))
+		return; /* if nothing for RCU to do. */
 	if (user ||
 	    (idle_cpu(cpu) && rcu_scheduler_active &&
 	     !in_softirq() && hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
@@ -971,17 +1020,16 @@ void rcu_check_callbacks(int cpu, int user)
 		 * Get here if this CPU took its interrupt from user
 		 * mode or from the idle loop, and if this is not a
 		 * nested interrupt.  In this case, the CPU is in
-		 * a quiescent state, so count it.
+		 * a quiescent state, so note it.
 		 *
 		 * No memory barrier is required here because both
-		 * rcu_qsctr_inc() and rcu_bh_qsctr_inc() reference
-		 * only CPU-local variables that other CPUs neither
-		 * access nor modify, at least not while the corresponding
-		 * CPU is online.
+		 * rcu_sched_qs() and rcu_bh_qs() reference only CPU-local
+		 * variables that other CPUs neither access nor modify,
+		 * at least not while the corresponding CPU is online.
 		 */
 
-		rcu_qsctr_inc(cpu);
-		rcu_bh_qsctr_inc(cpu);
+		rcu_sched_qs(cpu);
+		rcu_bh_qs(cpu);
 
 	} else if (!in_softirq()) {
 
@@ -989,11 +1037,12 @@ void rcu_check_callbacks(int cpu, int user)
 		 * Get here if this CPU did not take its interrupt from
 		 * softirq, in other words, if it is not interrupting
 		 * a rcu_bh read-side critical section.  This is an _bh
-		 * critical section, so count it.
+		 * critical section, so note it.
 		 */
 
-		rcu_bh_qsctr_inc(cpu);
+		rcu_bh_qs(cpu);
 	}
+	rcu_preempt_check_callbacks(cpu);
 	raise_softirq(RCU_SOFTIRQ);
 }
 
@@ -1132,6 +1181,8 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long flags;
 
+	WARN_ON_ONCE(rdp->beenonline == 0);
+
 	/*
 	 * If an RCU GP has gone long enough, go check for dyntick
 	 * idle CPUs and, if needed, send resched IPIs.
@@ -1170,8 +1221,10 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 	 */
 	smp_mb(); /* See above block comment. */
 
-	__rcu_process_callbacks(&rcu_state, &__get_cpu_var(rcu_data));
+	__rcu_process_callbacks(&rcu_sched_state,
+				&__get_cpu_var(rcu_sched_data));
 	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+	rcu_preempt_process_callbacks();
 
 	/*
 	 * Memory references from any later RCU read-side critical sections
@@ -1227,13 +1280,13 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 }
 
 /*
- * Queue an RCU callback for invocation after a grace period.
+ * Queue an RCU-sched callback for invocation after a grace period.
  */
-void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 {
-	__call_rcu(head, func, &rcu_state);
+	__call_rcu(head, func, &rcu_sched_state);
 }
-EXPORT_SYMBOL_GPL(call_rcu);
+EXPORT_SYMBOL_GPL(call_rcu_sched);
 
 /*
  * Queue an RCU for invocation after a quicker grace period.
@@ -1305,10 +1358,11 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
  * by the current CPU, returning 1 if so.  This function is part of the
  * RCU implementation; it is -not- an exported member of the RCU API.
  */
-int rcu_pending(int cpu)
+static int rcu_pending(int cpu)
 {
-	return __rcu_pending(&rcu_state, &per_cpu(rcu_data, cpu)) ||
-	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu));
+	return __rcu_pending(&rcu_sched_state, &per_cpu(rcu_sched_data, cpu)) ||
+	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu)) ||
+	       rcu_preempt_pending(cpu);
 }
 
 /*
@@ -1320,27 +1374,46 @@ int rcu_pending(int cpu)
 int rcu_needs_cpu(int cpu)
 {
 	/* RCU callbacks either ready or pending? */
-	return per_cpu(rcu_data, cpu).nxtlist ||
-	       per_cpu(rcu_bh_data, cpu).nxtlist;
+	return per_cpu(rcu_sched_data, cpu).nxtlist ||
+	       per_cpu(rcu_bh_data, cpu).nxtlist ||
+	       rcu_preempt_needs_cpu(cpu);
 }
 
 /*
- * Initialize a CPU's per-CPU RCU data.  We take this "scorched earth"
- * approach so that we don't have to worry about how long the CPU has
- * been gone, or whether it ever was online previously.  We do trust the
- * ->mynode field, as it is constant for a given struct rcu_data and
- * initialized during early boot.
- *
- * Note that only one online or offline event can be happening at a given
- * time.  Note also that we can accept some slop in the rsp->completed
- * access due to the fact that this CPU cannot possibly have any RCU
- * callbacks in flight yet.
+ * Do boot-time initialization of a CPU's per-CPU RCU data.
  */
-static void __cpuinit
-rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
+static void __init
+rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 {
 	unsigned long flags;
 	int i;
+	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	/* Set up local state, ensuring consistent view of global state. */
+	spin_lock_irqsave(&rnp->lock, flags);
+	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
+	rdp->nxtlist = NULL;
+	for (i = 0; i < RCU_NEXT_SIZE; i++)
+		rdp->nxttail[i] = &rdp->nxtlist;
+	rdp->qlen = 0;
+#ifdef CONFIG_NO_HZ
+	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
+#endif /* #ifdef CONFIG_NO_HZ */
+	rdp->cpu = cpu;
+	spin_unlock_irqrestore(&rnp->lock, flags);
+}
+
+/*
+ * Initialize a CPU's per-CPU RCU data.  Note that only one online or
+ * offline event can be happening at a given time.  Note also that we
+ * can accept some slop in the rsp->completed access due to the fact
+ * that this CPU cannot possibly have any RCU callbacks in flight yet.
+ */
+static void __cpuinit
+rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
+{
+	unsigned long flags;
 	long lastcomp;
 	unsigned long mask;
 	struct rcu_data *rdp = rsp->rda[cpu];
@@ -1354,17 +1427,9 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
 	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
+	rdp->preemptable = preemptable;
 	rdp->passed_quiesc_completed = lastcomp - 1;
-	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
-	rdp->nxtlist = NULL;
-	for (i = 0; i < RCU_NEXT_SIZE; i++)
-		rdp->nxttail[i] = &rdp->nxtlist;
-	rdp->qlen = 0;
 	rdp->blimit = blimit;
-#ifdef CONFIG_NO_HZ
-	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
-#endif /* #ifdef CONFIG_NO_HZ */
-	rdp->cpu = cpu;
 	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/*
@@ -1405,16 +1470,16 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 
 static void __cpuinit rcu_online_cpu(int cpu)
 {
-	rcu_init_percpu_data(cpu, &rcu_state);
-	rcu_init_percpu_data(cpu, &rcu_bh_state);
-	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+	rcu_init_percpu_data(cpu, &rcu_sched_state, 0);
+	rcu_init_percpu_data(cpu, &rcu_bh_state, 0);
+	rcu_preempt_init_percpu_data(cpu);
 }
 
 /*
- * Handle CPU online/offline notifcation events.
+ * Handle CPU online/offline notification events.
  */
-static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
-				unsigned long action, void *hcpu)
+int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+			     unsigned long action, void *hcpu)
 {
 	long cpu = (long)hcpu;
 
@@ -1486,6 +1551,7 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
 			spin_lock_init(&rnp->lock);
+			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
 			rnp->grplo = j * cpustride;
@@ -1503,16 +1569,20 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 					      j / rsp->levelspread[i - 1];
 			}
 			rnp->level = i;
+			INIT_LIST_HEAD(&rnp->blocked_tasks[0]);
+			INIT_LIST_HEAD(&rnp->blocked_tasks[1]);
 		}
 	}
 }
 
 /*
- * Helper macro for __rcu_init().  To be used nowhere else!
- * Assigns leaf node pointers into each CPU's rcu_data structure.
+ * Helper macro for __rcu_init() and __rcu_init_preempt().  To be used
+ * nowhere else!  Assigns leaf node pointers into each CPU's rcu_data
+ * structure.
  */
-#define RCU_DATA_PTR_INIT(rsp, rcu_data) \
+#define RCU_INIT_FLAVOR(rsp, rcu_data) \
 do { \
+	rcu_init_one(rsp); \
 	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
 	j = 0; \
 	for_each_possible_cpu(i) { \
@@ -1520,32 +1590,43 @@ do { \
 			j++; \
 		per_cpu(rcu_data, i).mynode = &rnp[j]; \
 		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
+		rcu_boot_init_percpu_data(i, rsp); \
 	} \
 } while (0)
 
-static struct notifier_block __cpuinitdata rcu_nb = {
-	.notifier_call	= rcu_cpu_notify,
-};
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
+void __init __rcu_init_preempt(void)
+{
+	int i;			/* All used by RCU_INIT_FLAVOR(). */
+	int j;
+	struct rcu_node *rnp;
+
+	RCU_INIT_FLAVOR(&rcu_preempt_state, rcu_preempt_data);
+}
+
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+void __init __rcu_init_preempt(void)
+{
+}
+
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
 
 void __init __rcu_init(void)
 {
-	int i;			/* All used by RCU_DATA_PTR_INIT(). */
+	int i;			/* All used by RCU_INIT_FLAVOR(). */
 	int j;
 	struct rcu_node *rnp;
 
-	printk(KERN_INFO "Hierarchical RCU implementation.\n");
+	rcu_bootup_announce();
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
-	rcu_init_one(&rcu_state);
-	RCU_DATA_PTR_INIT(&rcu_state, rcu_data);
-	rcu_init_one(&rcu_bh_state);
-	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);
-
-	for_each_online_cpu(i)
-		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE, (void *)(long)i);
-	/* Register notifier for non-boot CPUs */
-	register_cpu_notifier(&rcu_nb);
+	RCU_INIT_FLAVOR(&rcu_sched_state, rcu_sched_data);
+	RCU_INIT_FLAVOR(&rcu_bh_state, rcu_bh_data);
+	__rcu_init_preempt();
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
 }
 
 module_param(blimit, int, 0);
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index 5e872bb..bf8a6f9 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -1,10 +1,259 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion (tree-based version)
+ * Internal non-public definitions.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright IBM Corporation, 2008
+ *
+ * Author: Ingo Molnar <mingo@elte.hu>
+ *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ */
+
+#include <linux/cache.h>
+#include <linux/spinlock.h>
+#include <linux/threads.h>
+#include <linux/cpumask.h>
+#include <linux/seqlock.h>
+
+/*
+ * Define shape of hierarchy based on NR_CPUS and CONFIG_RCU_FANOUT.
+ * In theory, it should be possible to add more levels straightforwardly.
+ * In practice, this has not been tested, so there is probably some
+ * bug somewhere.
+ */
+#define MAX_RCU_LVLS 3
+#define RCU_FANOUT	      (CONFIG_RCU_FANOUT)
+#define RCU_FANOUT_SQ	      (RCU_FANOUT * RCU_FANOUT)
+#define RCU_FANOUT_CUBE	      (RCU_FANOUT_SQ * RCU_FANOUT)
+
+#if NR_CPUS <= RCU_FANOUT
+#  define NUM_RCU_LVLS	      1
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      (NR_CPUS)
+#  define NUM_RCU_LVL_2	      0
+#  define NUM_RCU_LVL_3	      0
+#elif NR_CPUS <= RCU_FANOUT_SQ
+#  define NUM_RCU_LVLS	      2
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT - 1) / RCU_FANOUT)
+#  define NUM_RCU_LVL_2	      (NR_CPUS)
+#  define NUM_RCU_LVL_3	      0
+#elif NR_CPUS <= RCU_FANOUT_CUBE
+#  define NUM_RCU_LVLS	      3
+#  define NUM_RCU_LVL_0	      1
+#  define NUM_RCU_LVL_1	      (((NR_CPUS) + RCU_FANOUT_SQ - 1) / RCU_FANOUT_SQ)
+#  define NUM_RCU_LVL_2	      (((NR_CPUS) + (RCU_FANOUT) - 1) / (RCU_FANOUT))
+#  define NUM_RCU_LVL_3	      NR_CPUS
+#else
+# error "CONFIG_RCU_FANOUT insufficient for NR_CPUS"
+#endif /* #if (NR_CPUS) <= RCU_FANOUT */
+
+#define RCU_SUM (NUM_RCU_LVL_0 + NUM_RCU_LVL_1 + NUM_RCU_LVL_2 + NUM_RCU_LVL_3)
+#define NUM_RCU_NODES (RCU_SUM - NR_CPUS)
+
+/*
+ * Dynticks per-CPU state.
+ */
+struct rcu_dynticks {
+	int dynticks_nesting;	/* Track nesting level, sort of. */
+	int dynticks;		/* Even value for dynticks-idle, else odd. */
+	int dynticks_nmi;	/* Even value for either dynticks-idle or */
+				/*  not in nmi handler, else odd.  So this */
+				/*  remains even for nmi from irq handler. */
+};
+
+/*
+ * Definition for node within the RCU grace-period-detection hierarchy.
+ */
+struct rcu_node {
+	spinlock_t lock;
+	long	gpnum;		/* Current grace period for this node. */
+				/*  This will either be equal to or one */
+				/*  behind the root rcu_node's gpnum. */
+	unsigned long qsmask;	/* CPUs or groups that need to switch in */
+				/*  order for current grace period to proceed.*/
+	unsigned long qsmaskinit;
+				/* Per-GP initialization for qsmask. */
+	unsigned long grpmask;	/* Mask to apply to parent qsmask. */
+	int	grplo;		/* lowest-numbered CPU or group here. */
+	int	grphi;		/* highest-numbered CPU or group here. */
+	u8	grpnum;		/* CPU/group number for next level up. */
+	u8	level;		/* root is at level 0. */
+	struct rcu_node *parent;
+	struct list_head blocked_tasks[2];
+				/* Tasks blocked in RCU read-side critsect. */
+} ____cacheline_internodealigned_in_smp;
+
+/* Index values for nxttail array in struct rcu_data. */
+#define RCU_DONE_TAIL		0	/* Also RCU_WAIT head. */
+#define RCU_WAIT_TAIL		1	/* Also RCU_NEXT_READY head. */
+#define RCU_NEXT_READY_TAIL	2	/* Also RCU_NEXT head. */
+#define RCU_NEXT_TAIL		3
+#define RCU_NEXT_SIZE		4
+
+/* Per-CPU data for read-copy update. */
+struct rcu_data {
+	/* 1) quiescent-state and grace-period handling : */
+	long		completed;	/* Track rsp->completed gp number */
+					/*  in order to detect GP end. */
+	long		gpnum;		/* Highest gp number that this CPU */
+					/*  is aware of having started. */
+	long		passed_quiesc_completed;
+					/* Value of completed at time of qs. */
+	bool		passed_quiesc;	/* User-mode/idle loop etc. */
+	bool		qs_pending;	/* Core waits for quiesc state. */
+	bool		beenonline;	/* CPU online at least once. */
+	bool		preemptable;	/* Preemptable RCU? */
+	struct rcu_node *mynode;	/* This CPU's leaf of hierarchy */
+	unsigned long grpmask;		/* Mask to apply to leaf qsmask. */
+
+	/* 2) batch handling */
+	/*
+	 * If nxtlist is not NULL, it is partitioned as follows.
+	 * Any of the partitions might be empty, in which case the
+	 * pointer to that partition will be equal to the pointer for
+	 * the following partition.  When the list is empty, all of
+	 * the nxttail elements point to nxtlist, which is NULL.
+	 *
+	 * [*nxttail[RCU_NEXT_READY_TAIL], NULL = *nxttail[RCU_NEXT_TAIL]):
+	 *	Entries that might have arrived after current GP ended
+	 * [*nxttail[RCU_WAIT_TAIL], *nxttail[RCU_NEXT_READY_TAIL]):
+	 *	Entries known to have arrived before current GP ended
+	 * [*nxttail[RCU_DONE_TAIL], *nxttail[RCU_WAIT_TAIL]):
+	 *	Entries that batch # <= ->completed - 1: waiting for current GP
+	 * [nxtlist, *nxttail[RCU_DONE_TAIL]):
+	 *	Entries that batch # <= ->completed
+	 *	The grace period for these entries has completed, and
+	 *	the other grace-period-completed entries may be moved
+	 *	here temporarily in rcu_process_callbacks().
+	 */
+	struct rcu_head *nxtlist;
+	struct rcu_head **nxttail[RCU_NEXT_SIZE];
+	long		qlen; 	 	/* # of queued callbacks */
+	long		blimit;		/* Upper limit on a processed batch */
+
+#ifdef CONFIG_NO_HZ
+	/* 3) dynticks interface. */
+	struct rcu_dynticks *dynticks;	/* Shared per-CPU dynticks state. */
+	int dynticks_snap;		/* Per-GP tracking for dynticks. */
+	int dynticks_nmi_snap;		/* Per-GP tracking for dynticks_nmi. */
+#endif /* #ifdef CONFIG_NO_HZ */
+
+	/* 4) reasons this CPU needed to be kicked by force_quiescent_state */
+#ifdef CONFIG_NO_HZ
+	unsigned long dynticks_fqs;	/* Kicked due to dynticks idle. */
+#endif /* #ifdef CONFIG_NO_HZ */
+	unsigned long offline_fqs;	/* Kicked due to being offline. */
+	unsigned long resched_ipi;	/* Sent a resched IPI. */
+
+	/* 5) __rcu_pending() statistics. */
+	long n_rcu_pending;		/* rcu_pending() calls since boot. */
+	long n_rp_qs_pending;
+	long n_rp_cb_ready;
+	long n_rp_cpu_needs_gp;
+	long n_rp_gp_completed;
+	long n_rp_gp_started;
+	long n_rp_need_fqs;
+	long n_rp_need_nothing;
+
+	int cpu;
+};
+
+/* Values for signaled field in struct rcu_state. */
+#define RCU_GP_INIT		0	/* Grace period being initialized. */
+#define RCU_SAVE_DYNTICK	1	/* Need to scan dyntick state. */
+#define RCU_FORCE_QS		2	/* Need to force quiescent state. */
+#ifdef CONFIG_NO_HZ
+#define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
+#else /* #ifdef CONFIG_NO_HZ */
+#define RCU_SIGNAL_INIT		RCU_FORCE_QS
+#endif /* #else #ifdef CONFIG_NO_HZ */
+
+#define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+#define RCU_SECONDS_TILL_STALL_CHECK   (10 * HZ)  /* for rsp->jiffies_stall */
+#define RCU_SECONDS_TILL_STALL_RECHECK (30 * HZ)  /* for rsp->jiffies_stall */
+#define RCU_STALL_RAT_DELAY		2	  /* Allow other CPUs time */
+						  /*  to take at least one */
+						  /*  scheduling clock irq */
+						  /*  before ratting on them. */
+
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+/*
+ * RCU global state, including node hierarchy.  This hierarchy is
+ * represented in "heap" form in a dense array.  The root (first level)
+ * of the hierarchy is in ->node[0] (referenced by ->level[0]), the second
+ * level in ->node[1] through ->node[m] (->node[1] referenced by ->level[1]),
+ * and the third level in ->node[m+1] and following (->node[m+1] referenced
+ * by ->level[2]).  The number of levels is determined by the number of
+ * CPUs and by CONFIG_RCU_FANOUT.  Small systems will have a "hierarchy"
+ * consisting of a single rcu_node.
+ */
+struct rcu_state {
+	struct rcu_node node[NUM_RCU_NODES];	/* Hierarchy. */
+	struct rcu_node *level[NUM_RCU_LVLS];	/* Hierarchy levels. */
+	u32 levelcnt[MAX_RCU_LVLS + 1];		/* # nodes in each level. */
+	u8 levelspread[NUM_RCU_LVLS];		/* kids/node in each level. */
+	struct rcu_data *rda[NR_CPUS];		/* array of rdp pointers. */
+
+	/* The following fields are guarded by the root rcu_node's lock. */
+
+	u8	signaled ____cacheline_internodealigned_in_smp;
+						/* Force QS state. */
+	long	gpnum;				/* Current gp number. */
+	long	completed;			/* # of last completed gp. */
+	spinlock_t onofflock;			/* exclude on/offline and */
+						/*  starting new GP. */
+	spinlock_t fqslock;			/* Only one task forcing */
+						/*  quiescent states. */
+	unsigned long jiffies_force_qs;		/* Time at which to invoke */
+						/*  force_quiescent_state(). */
+	unsigned long n_force_qs;		/* Number of calls to */
+						/*  force_quiescent_state(). */
+	unsigned long n_force_qs_lh;		/* ~Number of calls leaving */
+						/*  due to lock unavailable. */
+	unsigned long n_force_qs_ngp;		/* Number of calls leaving */
+						/*  due to no GP active. */
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+	unsigned long gp_start;			/* Time at which GP started, */
+						/*  but in jiffies. */
+	unsigned long jiffies_stall;		/* Time at which to check */
+						/*  for CPU stalls. */
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+#ifdef CONFIG_NO_HZ
+	long dynticks_completed;		/* Value of completed @ snap. */
+#endif /* #ifdef CONFIG_NO_HZ */
+};
+
+#ifdef RCU_TREE_NONCORE
 
 /*
  * RCU implementation internal declarations:
  */
-extern struct rcu_state rcu_state;
-DECLARE_PER_CPU(struct rcu_data, rcu_data);
+extern struct rcu_state rcu_sched_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_sched_data);
 
 extern struct rcu_state rcu_bh_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
 
+#ifdef CONFIG_TREE_PREEMPT_RCU
+extern struct rcu_state rcu_preempt_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+#endif /* #ifdef RCU_TREE_NONCORE */
+
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
new file mode 100644
index 0000000..4778936
--- /dev/null
+++ b/kernel/rcutree_plugin.h
@@ -0,0 +1,532 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion (tree-based version)
+ * Internal non-public definitions that provide either classic
+ * or preemptable semantics.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright Red Hat, 2009
+ * Copyright IBM Corporation, 2009
+ *
+ * Author: Ingo Molnar <mingo@elte.hu>
+ *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com>
+ */
+
+
+#ifdef CONFIG_TREE_PREEMPT_RCU
+
+struct rcu_state rcu_preempt_state = RCU_STATE_INITIALIZER(rcu_preempt_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_preempt_data);
+
+/*
+ * Tell them what RCU they are running.
+ */
+static inline void rcu_bootup_announce(void)
+{
+	printk(KERN_INFO
+	       "Experimental preemptable hierarchical RCU implementation.\n");
+}
+
+/*
+ * Return the number of RCU-preempt batches processed thus far
+ * for debug and statistics.
+ */
+long rcu_batches_completed_preempt(void)
+{
+	return rcu_preempt_state.completed;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed_preempt);
+
+/*
+ * Return the number of RCU batches processed thus far for debug & stats.
+ */
+long rcu_batches_completed(void)
+{
+	return rcu_batches_completed_preempt();
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed);
+
+/*
+ * Record a preemptable-RCU quiescent state for the specified CPU.  Note
+ * that this just means that the task currently running on the CPU is
+ * not in a quiescent state.  There might be any number of tasks blocked
+ * while in an RCU read-side critical section.
+ */
+static void rcu_preempt_qs_record(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_preempt_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
+
+/*
+ * We have entered the scheduler or are between softirqs in ksoftirqd.
+ * If we are in an RCU read-side critical section, we need to reflect
+ * that in the state of the rcu_node structure corresponding to this CPU.
+ * Caller must disable hardirqs.
+ */
+static void rcu_preempt_qs(int cpu)
+{
+	struct task_struct *t = current;
+	int phase;
+	struct rcu_data *rdp;
+	struct rcu_node *rnp;
+
+	if (t->rcu_read_lock_nesting &&
+	    (t->rcu_read_unlock_special & RCU_READ_UNLOCK_BLOCKED) == 0) {
+
+		/* Possibly blocking in an RCU read-side critical section. */
+		rdp = rcu_preempt_state.rda[cpu];
+		rnp = rdp->mynode;
+		spin_lock(&rnp->lock);
+		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
+		t->rcu_blocked_node = rnp;
+
+		/*
+		 * If this CPU has already checked in, then this task
+		 * will hold up the next grace period rather than the
+		 * current grace period.  Queue the task accordingly.
+		 * If the task is queued for the current grace period
+		 * (i.e., this CPU has not yet passed through a quiescent
+		 * state for the current grace period), then as long
+		 * as that task remains queued, the current grace period
+		 * cannot end.
+		 */
+		phase = !(rnp->qsmask & rdp->grpmask) ^ (rnp->gpnum & 0x1);
+		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
+		smp_mb();  /* Ensure later ctxt swtch seen after above. */
+		spin_unlock(&rnp->lock);
+	}
+
+	/*
+	 * Either we were not in an RCU read-side critical section to
+	 * begin with, or we have now recorded that critical section
+	 * globally.  Either way, we can now note a quiescent state
+	 * for this CPU.  Again, if we were in an RCU read-side critical
+	 * section, and if that critical section was blocking the current
+	 * grace period, then the fact that the task has been enqueued
+	 * means that we continue to block the current grace period.
+	 */
+	rcu_preempt_qs_record(cpu);
+	t->rcu_read_unlock_special &= ~(RCU_READ_UNLOCK_NEED_QS |
+					RCU_READ_UNLOCK_GOT_QS);
+}
+
+/*
+ * Tree-preemptable RCU implementation for rcu_read_lock().
+ * Just increment ->rcu_read_lock_nesting, shared state will be updated
+ * if we block.
+ */
+void __rcu_read_lock(void)
+{
+	ACCESS_ONCE(current->rcu_read_lock_nesting)++;
+	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
+}
+EXPORT_SYMBOL_GPL(__rcu_read_lock);
+
+static void rcu_read_unlock_special(struct task_struct *t)
+{
+	int empty;
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_node *rnp;
+	int special;
+
+	/* NMI handlers cannot block and cannot safely manipulate state. */
+	if (in_nmi())
+		return;
+
+	local_irq_save(flags);
+
+	/*
+	 * If RCU core is waiting for this CPU to exit critical section,
+	 * let it know that we have done so.
+	 */
+	special = t->rcu_read_unlock_special;
+	if (special & RCU_READ_UNLOCK_NEED_QS) {
+		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_NEED_QS;
+		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_GOT_QS;
+	}
+
+	/* Hardware IRQ handlers cannot block. */
+	if (in_irq()) {
+		local_irq_restore(flags);
+		return;
+	}
+
+	/* Clean up if blocked during RCU read-side critical section. */
+	if (special & RCU_READ_UNLOCK_BLOCKED) {
+		t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_BLOCKED;
+
+		/*
+		 * Remove this task from the list it blocked on.  The
+		 * task can migrate while we acquire the lock, but at
+		 * most one time.  So at most two passes through loop.
+		 */
+		for (;;) {
+			rnp = t->rcu_blocked_node;
+			spin_lock(&rnp->lock);
+			if (rnp == t->rcu_blocked_node)
+				break;
+			spin_unlock(&rnp->lock);
+		}
+		empty = list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
+		list_del_init(&t->rcu_node_entry);
+		t->rcu_blocked_node = NULL;
+
+		/*
+		 * If this was the last task on the current list, and if
+		 * we aren't waiting on any CPUs, report the quiescent state.
+		 * Note that both cpu_quiet_msk_finish() and cpu_quiet_msk()
+		 * drop rnp->lock and restore irq.
+		 */
+		if (!empty && rnp->qsmask == 0 &&
+		    list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1])) {
+			t->rcu_read_unlock_special &=
+				~(RCU_READ_UNLOCK_NEED_QS |
+				  RCU_READ_UNLOCK_GOT_QS);
+			if (rnp->parent == NULL) {
+				/* Only one rcu_node in the tree. */
+				cpu_quiet_msk_finish(&rcu_preempt_state, flags);
+				return;
+			}
+			/* Report up the rest of the hierarchy. */
+			mask = rnp->grpmask;
+			spin_unlock_irqrestore(&rnp->lock, flags);
+			rnp = rnp->parent;
+			spin_lock_irqsave(&rnp->lock, flags);
+			cpu_quiet_msk(mask, &rcu_preempt_state, rnp, flags);
+			return;
+		}
+		spin_unlock(&rnp->lock);
+	}
+	local_irq_restore(flags);
+}
+
+/*
+ * Tree-preemptable RCU implementation for rcu_read_unlock().
+ * Decrement ->rcu_read_lock_nesting.  If the result is zero (outermost
+ * rcu_read_unlock()) and ->rcu_read_unlock_special is non-zero, then
+ * invoke rcu_read_unlock_special() to clean up after a context switch
+ * in an RCU read-side critical section and other special cases.
+ */
+void __rcu_read_unlock(void)
+{
+	struct task_struct *t = current;
+
+	barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
+	if (--ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
+	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
+		rcu_read_unlock_special(t);
+}
+EXPORT_SYMBOL_GPL(__rcu_read_unlock);
+
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
+/*
+ * Scan the current list of tasks blocked within RCU read-side critical
+ * sections, printing out the tid of each.
+ */
+static void rcu_print_task_stall(struct rcu_node *rnp)
+{
+	unsigned long flags;
+	struct list_head *lp;
+	int phase = rnp->gpnum & 0x1;
+	struct task_struct *t;
+
+	if (!list_empty(&rnp->blocked_tasks[phase])) {
+		spin_lock_irqsave(&rnp->lock, flags);
+		phase = rnp->gpnum & 0x1; /* re-read under lock. */
+		lp = &rnp->blocked_tasks[phase];
+		list_for_each_entry(t, lp, rcu_node_entry)
+			printk(" P%d", t->pid);
+		spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+}
+
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+/*
+ * Check for preempted RCU readers for the specified rcu_node structure.
+ * If the caller needs a reliable answer, it must hold the rcu_node's
+ * >lock.
+ */
+static int rcu_preempted_readers(struct rcu_node *rnp)
+{
+	return !list_empty(&rnp->blocked_tasks[rnp->gpnum & 0x1]);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Handle tasklist migration for case in which all CPUs covered by the
+ * specified rcu_node have gone offline.  Move them up to the root
+ * rcu_node.  The reason for not just moving them to the immediate
+ * parent is to remove the need for rcu_read_unlock_special() to
+ * make more than two attempts to acquire the target rcu_node's lock.
+ *
+ * The caller must hold rnp->lock with irqs disabled.
+ */
+static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				      struct rcu_node *rnp)
+{
+	int i;
+	struct list_head *lp;
+	struct list_head *lp_root;
+	struct rcu_node *rnp_root = rcu_get_root(rsp);
+	struct task_struct *tp;
+
+	if (rnp == rnp_root) {
+		WARN_ONCE(1, "Last CPU thought to be offlined?");
+		return;  /* Shouldn't happen: at least one CPU online. */
+	}
+
+	/*
+	 * Move tasks up to root rcu_node.  Rely on the fact that the
+	 * root rcu_node can be at most one ahead of the rest of the
+	 * rcu_nodes in terms of gp_num value.  This fact allows us to
+	 * move the blocked_tasks[] array directly, element by element.
+	 */
+	for (i = 0; i < 2; i++) {
+		lp = &rnp->blocked_tasks[i];
+		lp_root = &rnp_root->blocked_tasks[i];
+		while (!list_empty(lp)) {
+			tp = list_entry(lp->next, typeof(*tp), rcu_node_entry);
+			spin_lock(&rnp_root->lock); /* irqs already disabled */
+			list_del(&tp->rcu_node_entry);
+			tp->rcu_blocked_node = rnp_root;
+			list_add(&tp->rcu_node_entry, lp_root);
+			spin_unlock(&rnp_root->lock); /* irqs remain disabled */
+		}
+	}
+}
+
+/*
+ * Do CPU-offline processing for preemptable RCU.
+ */
+static void rcu_preempt_offline_cpu(int cpu)
+{
+	__rcu_offline_cpu(cpu, &rcu_preempt_state);
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
+/*
+ * Check for a quiescent state from the current CPU.  When a task blocks,
+ * the task is recorded in the corresponding CPU's rcu_node structure,
+ * which is checked elsewhere.
+ *
+ * Caller must disable hard irqs.
+ */
+static void rcu_preempt_check_callbacks(int cpu)
+{
+	struct task_struct *t = current;
+
+	if (t->rcu_read_lock_nesting == 0) {
+		t->rcu_read_unlock_special &=
+			~(RCU_READ_UNLOCK_NEED_QS | RCU_READ_UNLOCK_GOT_QS);
+		rcu_preempt_qs_record(cpu);
+		return;
+	}
+	if (per_cpu(rcu_preempt_data, cpu).qs_pending) {
+		if (t->rcu_read_unlock_special & RCU_READ_UNLOCK_GOT_QS) {
+			rcu_preempt_qs_record(cpu);
+			t->rcu_read_unlock_special &= ~RCU_READ_UNLOCK_GOT_QS;
+		} else if (!(t->rcu_read_unlock_special &
+			     RCU_READ_UNLOCK_NEED_QS)) {
+			t->rcu_read_unlock_special |= RCU_READ_UNLOCK_NEED_QS;
+		}
+	}
+}
+
+/*
+ * Process callbacks for preemptable RCU.
+ */
+static void rcu_preempt_process_callbacks(void)
+{
+	__rcu_process_callbacks(&rcu_preempt_state,
+				&__get_cpu_var(rcu_preempt_data));
+}
+
+/*
+ * Queue a preemptable-RCU callback for invocation after a grace period.
+ */
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_preempt_state);
+}
+EXPORT_SYMBOL_GPL(call_rcu);
+
+/*
+ * Check to see if there is any immediate preemptable-RCU-related work
+ * to be done.
+ */
+static int rcu_preempt_pending(int cpu)
+{
+	return __rcu_pending(&rcu_preempt_state,
+			     &per_cpu(rcu_preempt_data, cpu));
+}
+
+/*
+ * Does preemptable RCU need the CPU to stay out of dynticks mode?
+ */
+static int rcu_preempt_needs_cpu(int cpu)
+{
+	return !!per_cpu(rcu_preempt_data, cpu).nxtlist;
+}
+
+/*
+ * Initialize preemptable RCU's per-CPU data.
+ */
+static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
+{
+	rcu_init_percpu_data(cpu, &rcu_preempt_state, 1);
+}
+
+/*
+ * Check for a task exiting while in a preemptable-RCU read-side
+ * critical section, clean up if so.  No need to issue warnings,
+ * as debug_check_no_locks_held() already does this if lockdep
+ * is enabled.
+ */
+void exit_rcu(void)
+{
+	struct task_struct *t = current;
+
+	if (t->rcu_read_lock_nesting == 0)
+		return;
+	t->rcu_read_lock_nesting = 1;
+	rcu_read_unlock();
+}
+
+#else /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+/*
+ * Tell them what RCU they are running.
+ */
+static inline void rcu_bootup_announce(void)
+{
+	printk(KERN_INFO "Hierarchical RCU implementation.\n");
+}
+
+/*
+ * Return the number of RCU batches processed thus far for debug & stats.
+ */
+long rcu_batches_completed(void)
+{
+	return rcu_batches_completed_sched();
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed);
+
+/*
+ * Because preemptable RCU does not exist, we never have to check for
+ * CPUs being in quiescent states.
+ */
+static void rcu_preempt_qs(int cpu)
+{
+}
+
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
+/*
+ * Because preemptable RCU does not exist, we never have to check for
+ * tasks blocked within RCU read-side critical sections.
+ */
+static void rcu_print_task_stall(struct rcu_node *rnp)
+{
+}
+
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+/*
+ * Because preemptable RCU does not exist, there are never any preempted
+ * RCU readers.
+ */
+static int rcu_preempted_readers(struct rcu_node *rnp)
+{
+	return 0;
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Because preemptable RCU does not exist, it never needs to migrate
+ * tasks that were blocked within RCU read-side critical sections.
+ */
+static void rcu_preempt_offline_tasks(struct rcu_state *rsp,
+				      struct rcu_node *rnp)
+{
+}
+
+/*
+ * Because preemptable RCU does not exist, it never needs CPU-offline
+ * processing.
+ */
+static void rcu_preempt_offline_cpu(int cpu)
+{
+}
+
+#endif /* #ifdef CONFIG_HOTPLUG_CPU */
+
+/*
+ * Because preemptable RCU does not exist, it never has any callbacks
+ * to check.
+ */
+void rcu_preempt_check_callbacks(int cpu)
+{
+}
+
+/*
+ * Because preemptable RCU does not exist, it never has any callbacks
+ * to process.
+ */
+void rcu_preempt_process_callbacks(void)
+{
+}
+
+/*
+ * In classic RCU, call_rcu() is just call_rcu_sched().
+ */
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	call_rcu_sched(head, func);
+}
+EXPORT_SYMBOL_GPL(call_rcu);
+
+/*
+ * Because preemptable RCU does not exist, it never has any work to do.
+ */
+static int rcu_preempt_pending(int cpu)
+{
+	return 0;
+}
+
+/*
+ * Because preemptable RCU does not exist, it never needs any CPU.
+ */
+static int rcu_preempt_needs_cpu(int cpu)
+{
+	return 0;
+}
+
+/*
+ * Because preemptable RCU does not exist, there is no per-CPU
+ * data to initialize.
+ */
+static void __cpuinit rcu_preempt_init_percpu_data(int cpu)
+{
+}
+
+#endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index fe1dcdb..0ea1bff 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -43,6 +43,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 
+#define RCU_TREE_NONCORE
 #include "rcutree.h"
 
 static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
@@ -76,8 +77,12 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 
 static int show_rcudata(struct seq_file *m, void *unused)
 {
-	seq_puts(m, "rcu:\n");
-	PRINT_RCU_DATA(rcu_data, print_one_rcu_data, m);
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	seq_puts(m, "rcu_preempt:\n");
+	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data, m);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+	seq_puts(m, "rcu_sched:\n");
+	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data, m);
 	seq_puts(m, "rcu_bh:\n");
 	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data, m);
 	return 0;
@@ -102,7 +107,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 		return;
 	seq_printf(m, "%d,%s,%ld,%ld,%d,%ld,%d",
 		   rdp->cpu,
-		   cpu_is_offline(rdp->cpu) ? "\"Y\"" : "\"N\"",
+		   cpu_is_offline(rdp->cpu) ? "\"N\"" : "\"Y\"",
 		   rdp->completed, rdp->gpnum,
 		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
 		   rdp->qs_pending);
@@ -124,8 +129,12 @@ static int show_rcudata_csv(struct seq_file *m, void *unused)
 	seq_puts(m, "\"dt\",\"dt nesting\",\"dn\",\"df\",");
 #endif /* #ifdef CONFIG_NO_HZ */
 	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\"\n");
-	seq_puts(m, "\"rcu:\"\n");
-	PRINT_RCU_DATA(rcu_data, print_one_rcu_data_csv, m);
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	seq_puts(m, "\"rcu_preempt:\"\n");
+	PRINT_RCU_DATA(rcu_preempt_data, print_one_rcu_data_csv, m);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+	seq_puts(m, "\"rcu_sched:\"\n");
+	PRINT_RCU_DATA(rcu_sched_data, print_one_rcu_data_csv, m);
 	seq_puts(m, "\"rcu_bh:\"\n");
 	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data_csv, m);
 	return 0;
@@ -171,8 +180,12 @@ static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 
 static int show_rcuhier(struct seq_file *m, void *unused)
 {
-	seq_puts(m, "rcu:\n");
-	print_one_rcu_state(m, &rcu_state);
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	seq_puts(m, "rcu_preempt:\n");
+	print_one_rcu_state(m, &rcu_preempt_state);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+	seq_puts(m, "rcu_sched:\n");
+	print_one_rcu_state(m, &rcu_sched_state);
 	seq_puts(m, "rcu_bh:\n");
 	print_one_rcu_state(m, &rcu_bh_state);
 	return 0;
@@ -193,8 +206,12 @@ static struct file_operations rcuhier_fops = {
 
 static int show_rcugp(struct seq_file *m, void *unused)
 {
-	seq_printf(m, "rcu: completed=%ld  gpnum=%ld\n",
-		   rcu_state.completed, rcu_state.gpnum);
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	seq_printf(m, "rcu_preempt: completed=%ld  gpnum=%ld\n",
+		   rcu_preempt_state.completed, rcu_preempt_state.gpnum);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+	seq_printf(m, "rcu_sched: completed=%ld  gpnum=%ld\n",
+		   rcu_sched_state.completed, rcu_sched_state.gpnum);
 	seq_printf(m, "rcu_bh: completed=%ld  gpnum=%ld\n",
 		   rcu_bh_state.completed, rcu_bh_state.gpnum);
 	return 0;
@@ -243,8 +260,12 @@ static void print_rcu_pendings(struct seq_file *m, struct rcu_state *rsp)
 
 static int show_rcu_pending(struct seq_file *m, void *unused)
 {
-	seq_puts(m, "rcu:\n");
-	print_rcu_pendings(m, &rcu_state);
+#ifdef CONFIG_TREE_PREEMPT_RCU
+	seq_puts(m, "rcu_preempt:\n");
+	print_rcu_pendings(m, &rcu_preempt_state);
+#endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
+	seq_puts(m, "rcu_sched:\n");
+	print_rcu_pendings(m, &rcu_sched_state);
 	seq_puts(m, "rcu_bh:\n");
 	print_rcu_pendings(m, &rcu_bh_state);
 	return 0;
@@ -264,62 +285,47 @@ static struct file_operations rcu_pending_fops = {
 };
 
 static struct dentry *rcudir;
-static struct dentry *datadir;
-static struct dentry *datadir_csv;
-static struct dentry *gpdir;
-static struct dentry *hierdir;
-static struct dentry *rcu_pendingdir;
 
 static int __init rcuclassic_trace_init(void)
 {
+	struct dentry *retval;
+
 	rcudir = debugfs_create_dir("rcu", NULL);
 	if (!rcudir)
-		goto out;
+		goto free_out;
 
-	datadir = debugfs_create_file("rcudata", 0444, rcudir,
+	retval = debugfs_create_file("rcudata", 0444, rcudir,
 						NULL, &rcudata_fops);
-	if (!datadir)
+	if (!retval)
 		goto free_out;
 
-	datadir_csv = debugfs_create_file("rcudata.csv", 0444, rcudir,
+	retval = debugfs_create_file("rcudata.csv", 0444, rcudir,
 						NULL, &rcudata_csv_fops);
-	if (!datadir_csv)
+	if (!retval)
 		goto free_out;
 
-	gpdir = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
-	if (!gpdir)
+	retval = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
+	if (!retval)
 		goto free_out;
 
-	hierdir = debugfs_create_file("rcuhier", 0444, rcudir,
+	retval = debugfs_create_file("rcuhier", 0444, rcudir,
 						NULL, &rcuhier_fops);
-	if (!hierdir)
+	if (!retval)
 		goto free_out;
 
-	rcu_pendingdir = debugfs_create_file("rcu_pending", 0444, rcudir,
+	retval = debugfs_create_file("rcu_pending", 0444, rcudir,
 						NULL, &rcu_pending_fops);
-	if (!rcu_pendingdir)
+	if (!retval)
 		goto free_out;
 	return 0;
 free_out:
-	if (datadir)
-		debugfs_remove(datadir);
-	if (datadir_csv)
-		debugfs_remove(datadir_csv);
-	if (gpdir)
-		debugfs_remove(gpdir);
-	debugfs_remove(rcudir);
-out:
+	debugfs_remove_recursive(rcudir);
 	return 1;
 }
 
 static void __exit rcuclassic_trace_cleanup(void)
 {
-	debugfs_remove(datadir);
-	debugfs_remove(datadir_csv);
-	debugfs_remove(gpdir);
-	debugfs_remove(hierdir);
-	debugfs_remove(rcu_pendingdir);
-	debugfs_remove(rcudir);
+	debugfs_remove_recursive(rcudir);
 }
 
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 1b59e26..c9beca6 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5325,7 +5325,7 @@ need_resched:
 	preempt_disable();
 	cpu = smp_processor_id();
 	rq = cpu_rq(cpu);
-	rcu_qsctr_inc(cpu);
+	rcu_sched_qs(cpu);
 	prev = rq->curr;
 	switch_count = &prev->nivcsw;
 
@@ -7051,6 +7051,11 @@ fail:
 	return ret;
 }
 
+#define RCU_MIGRATION_IDLE	0
+#define RCU_MIGRATION_NEED_QS	1
+#define RCU_MIGRATION_GOT_QS	2
+#define RCU_MIGRATION_MUST_SYNC	3
+
 /*
  * migration_thread - this is a highprio system thread that performs
  * thread migration by bumping thread off CPU then 'pushing' onto
@@ -7058,6 +7063,7 @@ fail:
  */
 static int migration_thread(void *data)
 {
+	int badcpu;
 	int cpu = (long)data;
 	struct rq *rq;
 
@@ -7092,8 +7098,17 @@ static int migration_thread(void *data)
 		req = list_entry(head->next, struct migration_req, list);
 		list_del_init(head->next);
 
-		spin_unlock(&rq->lock);
-		__migrate_task(req->task, cpu, req->dest_cpu);
+		if (req->task != NULL) {
+			spin_unlock(&rq->lock);
+			__migrate_task(req->task, cpu, req->dest_cpu);
+		} else if (likely(cpu == (badcpu = smp_processor_id()))) {
+			req->dest_cpu = RCU_MIGRATION_GOT_QS;
+			spin_unlock(&rq->lock);
+		} else {
+			req->dest_cpu = RCU_MIGRATION_MUST_SYNC;
+			spin_unlock(&rq->lock);
+			WARN_ONCE(1, "migration_thread() on CPU %d, expected %d\n", badcpu, cpu);
+		}
 		local_irq_enable();
 
 		complete(&req->done);
@@ -10581,3 +10596,113 @@ struct cgroup_subsys cpuacct_subsys = {
 	.subsys_id = cpuacct_subsys_id,
 };
 #endif	/* CONFIG_CGROUP_CPUACCT */
+
+#ifndef CONFIG_SMP
+
+int rcu_expedited_torture_stats(char *page)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rcu_expedited_torture_stats);
+
+void synchronize_sched_expedited(void)
+{
+}
+EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
+
+#else /* #ifndef CONFIG_SMP */
+
+static DEFINE_PER_CPU(struct migration_req, rcu_migration_req);
+static DEFINE_MUTEX(rcu_sched_expedited_mutex);
+
+#define RCU_EXPEDITED_STATE_POST -2
+#define RCU_EXPEDITED_STATE_IDLE -1
+
+static int rcu_expedited_state = RCU_EXPEDITED_STATE_IDLE;
+
+int rcu_expedited_torture_stats(char *page)
+{
+	int cnt = 0;
+	int cpu;
+
+	cnt += sprintf(&page[cnt], "state: %d /", rcu_expedited_state);
+	for_each_online_cpu(cpu) {
+		 cnt += sprintf(&page[cnt], " %d:%d",
+				cpu, per_cpu(rcu_migration_req, cpu).dest_cpu);
+	}
+	cnt += sprintf(&page[cnt], "\n");
+	return cnt;
+}
+EXPORT_SYMBOL_GPL(rcu_expedited_torture_stats);
+
+static long synchronize_sched_expedited_count;
+
+/*
+ * Wait for an rcu-sched grace period to elapse, but use "big hammer"
+ * approach to force grace period to end quickly.  This consumes
+ * significant time on all CPUs, and is thus not recommended for
+ * any sort of common-case code.
+ *
+ * Note that it is illegal to call this function while holding any
+ * lock that is acquired by a CPU-hotplug notifier.  Failing to
+ * observe this restriction will result in deadlock.
+ */
+void synchronize_sched_expedited(void)
+{
+	int cpu;
+	unsigned long flags;
+	bool need_full_sync = 0;
+	struct rq *rq;
+	struct migration_req *req;
+	long snap;
+	int trycount = 0;
+
+	smp_mb();  /* ensure prior mod happens before capturing snap. */
+	snap = ACCESS_ONCE(synchronize_sched_expedited_count) + 1;
+	get_online_cpus();
+	while (!mutex_trylock(&rcu_sched_expedited_mutex)) {
+		put_online_cpus();
+		if (trycount++ < 10)
+			udelay(trycount * num_online_cpus());
+		else {
+			synchronize_sched();
+			return;
+		}
+		if (ACCESS_ONCE(synchronize_sched_expedited_count) - snap > 0) {
+			smp_mb(); /* ensure test happens before caller kfree */
+			return;
+		}
+		get_online_cpus();
+	}
+	rcu_expedited_state = RCU_EXPEDITED_STATE_POST;
+	for_each_online_cpu(cpu) {
+		rq = cpu_rq(cpu);
+		req = &per_cpu(rcu_migration_req, cpu);
+		init_completion(&req->done);
+		req->task = NULL;
+		req->dest_cpu = RCU_MIGRATION_NEED_QS;
+		spin_lock_irqsave(&rq->lock, flags);
+		list_add(&req->list, &rq->migration_queue);
+		spin_unlock_irqrestore(&rq->lock, flags);
+		wake_up_process(rq->migration_thread);
+	}
+	for_each_online_cpu(cpu) {
+		rcu_expedited_state = cpu;
+		req = &per_cpu(rcu_migration_req, cpu);
+		rq = cpu_rq(cpu);
+		wait_for_completion(&req->done);
+		spin_lock_irqsave(&rq->lock, flags);
+		if (unlikely(req->dest_cpu == RCU_MIGRATION_MUST_SYNC))
+			need_full_sync = 1;
+		req->dest_cpu = RCU_MIGRATION_IDLE;
+		spin_unlock_irqrestore(&rq->lock, flags);
+	}
+	rcu_expedited_state = RCU_EXPEDITED_STATE_IDLE;
+	mutex_unlock(&rcu_sched_expedited_mutex);
+	put_online_cpus();
+	if (need_full_sync)
+		synchronize_sched();
+}
+EXPORT_SYMBOL_GPL(synchronize_sched_expedited);
+
+#endif /* #else #ifndef CONFIG_SMP */
diff --git a/kernel/softirq.c b/kernel/softirq.c
index eb5e131..7db2506 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -227,7 +227,7 @@ restart:
 				preempt_count() = prev_count;
 			}
 
-			rcu_bh_qsctr_inc(cpu);
+			rcu_bh_qs(cpu);
 		}
 		h++;
 		pending >>= 1;
@@ -721,7 +721,7 @@ static int ksoftirqd(void * __bind_cpu)
 			preempt_enable_no_resched();
 			cond_resched();
 			preempt_disable();
-			rcu_qsctr_inc((long)__bind_cpu);
+			rcu_sched_qs((long)__bind_cpu);
 		}
 		preempt_enable();
 		set_current_state(TASK_INTERRUPTIBLE);
diff --git a/kernel/timer.c b/kernel/timer.c
index a7f07d5..a3d25f4 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -1156,8 +1156,7 @@ void update_process_times(int user_tick)
 	/* Note: this timer irq context must be accounted for as well. */
 	account_process_tick(p, user_tick);
 	run_local_timers();
-	if (rcu_pending(cpu))
-		rcu_check_callbacks(cpu, user_tick);
+	rcu_check_callbacks(cpu, user_tick);
 	printk_tick();
 	scheduler_tick();
 	run_posix_cpu_timers(p);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 12327b2..82fbc49 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -725,7 +725,7 @@ config RCU_TORTURE_TEST_RUNNABLE
 
 config RCU_CPU_STALL_DETECTOR
 	bool "Check for stalled CPUs delaying RCU grace periods"
-	depends on CLASSIC_RCU || TREE_RCU
+	depends on TREE_RCU || TREE_PREEMPT_RCU
 	default n
 	help
 	  This option causes RCU to printk information on which
