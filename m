Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbYGNPVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbYGNPVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbYGNPVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:21:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33685 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbYGNPVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:21:13 -0400
Date: Mon, 14 Jul 2008 17:20:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] RCU updates for v2.6.27
Message-ID: <20080714152045.GA29159@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
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

Linus,

Please pull the latest RCU git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core/rcu-for-linus

[ NOTE: due to merge interaction please pull this after 
  kmemcheck-for-linus. The shortlog is relative to kmemcheck-for-linus. ]

Thanks,

	Ingo

------------------>
Franck Bui-Huu (2):
      rcu: split list.h and move rcu-protected lists into rculist.h
      rculist.h: use the rcu API

Huang Weiyi (2):
      rcu: remove duplicated include in kernel/rcupreempt_trace.c
      rcu: remove duplicated include in kernel/rcupreempt.c

Ingo Molnar (4):
      rculist.h: fix include in net/netfilter/nf_conntrack_netlink.c
      rcu: fix nf_conntrack_helper.c build bug
      Revert "prohibit rcutorture from being compiled into the kernel"
      rcutorture: WARN_ON_ONCE(1) when detecting an error

Lai Jiangshan (2):
      rcu: remove unused field struct rcu_data::rcu_tasklet
      rcu classic: update qlen when cpu offline

Paul E. McKenney (12):
      rcu: add call_rcu_sched()
      rcu: add memory barriers and comments to rcu_check_callbacks()
      rcu: add rcu_barrier_sched() and rcu_barrier_bh()
      rcu: add call_rcu_sched() and friends to rcutorture
      sched: 1Q08 RCU doc update, add call_rcu_sched()
      rcu: fix rcu_try_flip_waitack_needed() to prevent grace-period stall
      RCU, rculist.h: fix list iterators
      rcu: make rcutorture more vicious: add stutter feature
      rcu: make rcutorture more vicious: reinstate boot-time testing
      rcu, rcutorture: make quiescent rcutorture less power-hungry
      rcu: make quiescent rcutorture less power-hungry
      rcu: make rcutorture even more vicious: invoke RCU readers from irq handlers (timers)

Steven Rostedt (1):
      rcupreempt: remove duplicate prototypes


 Documentation/RCU/NMI-RCU.txt                   |    3 +
 Documentation/RCU/RTFP.txt                      |  108 ++++++
 Documentation/RCU/checklist.txt                 |   89 ++++--
 Documentation/RCU/torture.txt                   |   48 ++-
 Documentation/RCU/whatisRCU.txt                 |   58 +++-
 arch/ia64/sn/kernel/irq.c                       |    1 +
 crypto/async_tx/async_tx.c                      |    1 +
 drivers/infiniband/hw/ipath/ipath_verbs.c       |    1 +
 drivers/infiniband/hw/ipath/ipath_verbs_mcast.c |    3 +-
 drivers/net/macvlan.c                           |    2 +-
 include/linux/dcache.h                          |    1 +
 include/linux/list.h                            |  367 --------------------
 include/linux/rcuclassic.h                      |    3 +
 include/linux/rculist.h                         |  369 ++++++++++++++++++++-
 include/linux/rcupdate.h                        |   26 ++-
 include/linux/rcupreempt.h                      |   42 ++-
 init/main.c                                     |    1 +
 kernel/pid.c                                    |    1 +
 kernel/rcuclassic.c                             |   34 ++-
 kernel/rcupdate.c                               |   71 +++--
 kernel/rcupreempt.c                             |  418 ++++++++++++++++++++---
 kernel/rcupreempt_trace.c                       |    1 -
 kernel/rcutorture.c                             |  174 +++++++++-
 kernel/sysctl.c                                 |   13 +
 lib/Kconfig.debug                               |   20 +-
 lib/textsearch.c                                |    1 +
 net/802/psnap.c                                 |    1 +
 net/8021q/vlan.c                                |    1 +
 net/bridge/br_fdb.c                             |    1 +
 net/bridge/br_stp.c                             |    1 +
 net/netfilter/nf_conntrack_helper.c             |    1 +
 net/netfilter/nf_conntrack_netlink.c            |    1 +
 net/netlabel/netlabel_domainhash.c              |    3 +-
 33 files changed, 1341 insertions(+), 524 deletions(-)

diff --git a/Documentation/RCU/NMI-RCU.txt b/Documentation/RCU/NMI-RCU.txt
index c64158e..a6d32e6 100644
--- a/Documentation/RCU/NMI-RCU.txt
+++ b/Documentation/RCU/NMI-RCU.txt
@@ -93,6 +93,9 @@ Since NMI handlers disable preemption, synchronize_sched() is guaranteed
 not to return until all ongoing NMI handlers exit.  It is therefore safe
 to free up the handler's data as soon as synchronize_sched() returns.
 
+Important note: for this to work, the architecture in question must
+invoke irq_enter() and irq_exit() on NMI entry and exit, respectively.
+
 
 Answer to Quick Quiz
 
diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index 39ad8f5..9f711d2 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -52,6 +52,10 @@ of each iteration.  Unfortunately, chaotic relaxation requires highly
 structured data, such as the matrices used in scientific programs, and
 is thus inapplicable to most data structures in operating-system kernels.
 
+In 1992, Henry (now Alexia) Massalin completed a dissertation advising
+parallel programmers to defer processing when feasible to simplify
+synchronization.  RCU makes extremely heavy use of this advice.
+
 In 1993, Jacobson [Jacobson93] verbally described what is perhaps the
 simplest deferred-free technique: simply waiting a fixed amount of time
 before freeing blocks awaiting deferred free.  Jacobson did not describe
@@ -138,6 +142,13 @@ blocking in read-side critical sections appeared [PaulEMcKenney2006c],
 Robert Olsson described an RCU-protected trie-hash combination
 [RobertOlsson2006a].
 
+2007 saw the journal version of the award-winning RCU paper from 2006
+[ThomasEHart2007a], as well as a paper demonstrating use of Promela
+and Spin to mechanically verify an optimization to Oleg Nesterov's
+QRCU [PaulEMcKenney2007QRCUspin], a design document describing
+preemptible RCU [PaulEMcKenney2007PreemptibleRCU], and the three-part
+LWN "What is RCU?" series [PaulEMcKenney2007WhatIsRCUFundamentally,
+PaulEMcKenney2008WhatIsRCUUsage, and PaulEMcKenney2008WhatIsRCUAPI].
 
 Bibtex Entries
 
@@ -202,6 +213,20 @@ Bibtex Entries
 ,Year="1991"
 }
 
+@phdthesis{HMassalinPhD
+,author="H. Massalin"
+,title="Synthesis: An Efficient Implementation of Fundamental Operating
+System Services"
+,school="Columbia University"
+,address="New York, NY"
+,year="1992"
+,annotation="
+	Mondo optimizing compiler.
+	Wait-free stuff.
+	Good advice: defer work to avoid synchronization.
+"
+}
+
 @unpublished{Jacobson93
 ,author="Van Jacobson"
 ,title="Avoid Read-Side Locking Via Delayed Free"
@@ -635,3 +660,86 @@ Revised:
 "
 }
 
+@unpublished{PaulEMcKenney2007PreemptibleRCU
+,Author="Paul E. McKenney"
+,Title="The design of preemptible read-copy-update"
+,month="October"
+,day="8"
+,year="2007"
+,note="Available:
+\url{http://lwn.net/Articles/253651/}
+[Viewed October 25, 2007]"
+,annotation="
+	LWN article describing the design of preemptible RCU.
+"
+}
+
+########################################################################
+#
+#	"What is RCU?" LWN series.
+#
+
+@unpublished{PaulEMcKenney2007WhatIsRCUFundamentally
+,Author="Paul E. McKenney and Jonathan Walpole"
+,Title="What is {RCU}, Fundamentally?"
+,month="December"
+,day="17"
+,year="2007"
+,note="Available:
+\url{http://lwn.net/Articles/262464/}
+[Viewed December 27, 2007]"
+,annotation="
+	Lays out the three basic components of RCU: (1) publish-subscribe,
+	(2) wait for pre-existing readers to complete, and (2) maintain
+	multiple versions.
+"
+}
+
+@unpublished{PaulEMcKenney2008WhatIsRCUUsage
+,Author="Paul E. McKenney"
+,Title="What is {RCU}? Part 2: Usage"
+,month="January"
+,day="4"
+,year="2008"
+,note="Available:
+\url{http://lwn.net/Articles/263130/}
+[Viewed January 4, 2008]"
+,annotation="
+	Lays out six uses of RCU:
+	1. RCU is a Reader-Writer Lock Replacement
+	2. RCU is a Restricted Reference-Counting Mechanism
+	3. RCU is a Bulk Reference-Counting Mechanism
+	4. RCU is a Poor Man's Garbage Collector
+	5. RCU is a Way of Providing Existence Guarantees
+	6. RCU is a Way of Waiting for Things to Finish 
+"
+}
+
+@unpublished{PaulEMcKenney2008WhatIsRCUAPI
+,Author="Paul E. McKenney"
+,Title="{RCU} part 3: the {RCU} {API}"
+,month="January"
+,day="17"
+,year="2008"
+,note="Available:
+\url{http://lwn.net/Articles/264090/}
+[Viewed January 10, 2008]"
+,annotation="
+	Gives an overview of the Linux-kernel RCU API and a brief annotated RCU
+	bibliography.
+"
+}
+
+@article{DinakarGuniguntala2008IBMSysJ
+,author="D. Guniguntala and P. E. McKenney and J. Triplett and J. Walpole"
+,title="The read-copy-update mechanism for supporting real-time applications on shared-memory multiprocessor systems with {Linux}"
+,Year="2008"
+,Month="April"
+,journal="IBM Systems Journal"
+,volume="47"
+,number="2"
+,pages="@@-@@"
+,annotation="
+	RCU, realtime RCU, sleepable RCU, performance.
+"
+}
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 42b01bc..cf5562c 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -13,10 +13,13 @@ over a rather long period of time, but improvements are always welcome!
 	detailed performance measurements show that RCU is nonetheless
 	the right tool for the job.
 
-	The other exception would be where performance is not an issue,
-	and RCU provides a simpler implementation.  An example of this
-	situation is the dynamic NMI code in the Linux 2.6 kernel,
-	at least on architectures where NMIs are rare.
+	Another exception is where performance is not an issue, and RCU
+	provides a simpler implementation.  An example of this situation
+	is the dynamic NMI code in the Linux 2.6 kernel, at least on
+	architectures where NMIs are rare.
+
+	Yet another exception is where the low real-time latency of RCU's
+	read-side primitives is critically important.
 
 1.	Does the update code have proper mutual exclusion?
 
@@ -39,9 +42,10 @@ over a rather long period of time, but improvements are always welcome!
 
 2.	Do the RCU read-side critical sections make proper use of
 	rcu_read_lock() and friends?  These primitives are needed
-	to suppress preemption (or bottom halves, in the case of
-	rcu_read_lock_bh()) in the read-side critical sections,
-	and are also an excellent aid to readability.
+	to prevent grace periods from ending prematurely, which
+	could result in data being unceremoniously freed out from
+	under your read-side code, which can greatly increase the
+	actuarial risk of your kernel.
 
 	As a rough rule of thumb, any dereference of an RCU-protected
 	pointer must be covered by rcu_read_lock() or rcu_read_lock_bh()
@@ -54,15 +58,30 @@ over a rather long period of time, but improvements are always welcome!
 	be running while updates are in progress.  There are a number
 	of ways to handle this concurrency, depending on the situation:
 
-	a.	Make updates appear atomic to readers.  For example,
+	a.	Use the RCU variants of the list and hlist update
+		primitives to add, remove, and replace elements on an
+		RCU-protected list.  Alternatively, use the RCU-protected
+		trees that have been added to the Linux kernel.
+
+		This is almost always the best approach.
+
+	b.	Proceed as in (a) above, but also maintain per-element
+		locks (that are acquired by both readers and writers)
+		that guard per-element state.  Of course, fields that
+		the readers refrain from accessing can be guarded by the
+		update-side lock.
+
+		This works quite well, also.
+
+	c.	Make updates appear atomic to readers.  For example,
 		pointer updates to properly aligned fields will appear
 		atomic, as will individual atomic primitives.  Operations
 		performed under a lock and sequences of multiple atomic
 		primitives will -not- appear to be atomic.
 
-		This is almost always the best approach.
+		This can work, but is starting to get a bit tricky.
 
-	b.	Carefully order the updates and the reads so that
+	d.	Carefully order the updates and the reads so that
 		readers see valid data at all phases of the update.
 		This is often more difficult than it sounds, especially
 		given modern CPUs' tendency to reorder memory references.
@@ -123,18 +142,22 @@ over a rather long period of time, but improvements are always welcome!
 		when publicizing a pointer to a structure that can
 		be traversed by an RCU read-side critical section.
 
-5.	If call_rcu(), or a related primitive such as call_rcu_bh(),
-	is used, the callback function must be written to be called
-	from softirq context.  In particular, it cannot block.
+5.	If call_rcu(), or a related primitive such as call_rcu_bh() or
+	call_rcu_sched(), is used, the callback function must be
+	written to be called from softirq context.  In particular,
+	it cannot block.
 
 6.	Since synchronize_rcu() can block, it cannot be called from
-	any sort of irq context.
+	any sort of irq context.  Ditto for synchronize_sched() and
+	synchronize_srcu().
 
 7.	If the updater uses call_rcu(), then the corresponding readers
 	must use rcu_read_lock() and rcu_read_unlock().  If the updater
 	uses call_rcu_bh(), then the corresponding readers must use
-	rcu_read_lock_bh() and rcu_read_unlock_bh().  Mixing things up
-	will result in confusion and broken kernels.
+	rcu_read_lock_bh() and rcu_read_unlock_bh().  If the updater
+	uses call_rcu_sched(), then the corresponding readers must
+	disable preemption.  Mixing things up will result in confusion
+	and broken kernels.
 
 	One exception to this rule: rcu_read_lock() and rcu_read_unlock()
 	may be substituted for rcu_read_lock_bh() and rcu_read_unlock_bh()
@@ -143,9 +166,9 @@ over a rather long period of time, but improvements are always welcome!
 	such cases is a must, of course!  And the jury is still out on
 	whether the increased speed is worth it.
 
-8.	Although synchronize_rcu() is a bit slower than is call_rcu(),
-	it usually results in simpler code.  So, unless update
-	performance is critically important or the updaters cannot block,
+8.	Although synchronize_rcu() is slower than is call_rcu(), it
+	usually results in simpler code.  So, unless update performance
+	is critically important or the updaters cannot block,
 	synchronize_rcu() should be used in preference to call_rcu().
 
 	An especially important property of the synchronize_rcu()
@@ -187,23 +210,23 @@ over a rather long period of time, but improvements are always welcome!
 		number of updates per grace period.
 
 9.	All RCU list-traversal primitives, which include
-	list_for_each_rcu(), list_for_each_entry_rcu(),
+	rcu_dereference(), list_for_each_rcu(), list_for_each_entry_rcu(),
 	list_for_each_continue_rcu(), and list_for_each_safe_rcu(),
-	must be within an RCU read-side critical section.  RCU
+	must be either within an RCU read-side critical section or
+	must be protected by appropriate update-side locks.  RCU
 	read-side critical sections are delimited by rcu_read_lock()
 	and rcu_read_unlock(), or by similar primitives such as
 	rcu_read_lock_bh() and rcu_read_unlock_bh().
 
-	Use of the _rcu() list-traversal primitives outside of an
-	RCU read-side critical section causes no harm other than
-	a slight performance degradation on Alpha CPUs.  It can
-	also be quite helpful in reducing code bloat when common
-	code is shared between readers and updaters.
+	The reason that it is permissible to use RCU list-traversal
+	primitives when the update-side lock is held is that doing so
+	can be quite helpful in reducing code bloat when common code is
+	shared between readers and updaters.
 
 10.	Conversely, if you are in an RCU read-side critical section,
-	you -must- use the "_rcu()" variants of the list macros.
-	Failing to do so will break Alpha and confuse people reading
-	your code.
+	and you don't hold the appropriate update-side lock, you -must-
+	use the "_rcu()" variants of the list macros.  Failing to do so
+	will break Alpha and confuse people reading your code.
 
 11.	Note that synchronize_rcu() -only- guarantees to wait until
 	all currently executing rcu_read_lock()-protected RCU read-side
@@ -230,6 +253,14 @@ over a rather long period of time, but improvements are always welcome!
 	must use whatever locking or other synchronization is required
 	to safely access and/or modify that data structure.
 
+	RCU callbacks are -usually- executed on the same CPU that executed
+	the corresponding call_rcu(), call_rcu_bh(), or call_rcu_sched(),
+	but are by -no- means guaranteed to be.  For example, if a given
+	CPU goes offline while having an RCU callback pending, then that
+	RCU callback will execute on some surviving CPU.  (If this was
+	not the case, a self-spawning RCU callback would prevent the
+	victim CPU from ever going offline.)
+
 14.	SRCU (srcu_read_lock(), srcu_read_unlock(), and synchronize_srcu())
 	may only be invoked from process context.  Unlike other forms of
 	RCU, it -is- permissible to block in an SRCU read-side critical
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 2967a65..a342b6e 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -10,23 +10,30 @@ status messages via printk(), which can be examined via the dmesg
 command (perhaps grepping for "torture").  The test is started
 when the module is loaded, and stops when the module is unloaded.
 
-However, actually setting this config option to "y" results in the system
-running the test immediately upon boot, and ending only when the system
-is taken down.  Normally, one will instead want to build the system
-with CONFIG_RCU_TORTURE_TEST=m and to use modprobe and rmmod to control
-the test, perhaps using a script similar to the one shown at the end of
-this document.  Note that you will need CONFIG_MODULE_UNLOAD in order
-to be able to end the test.
+CONFIG_RCU_TORTURE_TEST_RUNNABLE
+
+It is also possible to specify CONFIG_RCU_TORTURE_TEST=y, which will
+result in the tests being loaded into the base kernel.  In this case,
+the CONFIG_RCU_TORTURE_TEST_RUNNABLE config option is used to specify
+whether the RCU torture tests are to be started immediately during
+boot or whether the /proc/sys/kernel/rcutorture_runnable file is used
+to enable them.  This /proc file can be used to repeatedly pause and
+restart the tests, regardless of the initial state specified by the
+CONFIG_RCU_TORTURE_TEST_RUNNABLE config option.
+
+You will normally -not- want to start the RCU torture tests during boot
+(and thus the default is CONFIG_RCU_TORTURE_TEST_RUNNABLE=n), but doing
+this can sometimes be useful in finding boot-time bugs.
 
 
 MODULE PARAMETERS
 
 This module has the following parameters:
 
-nreaders	This is the number of RCU reading threads supported.
-		The default is twice the number of CPUs.  Why twice?
-		To properly exercise RCU implementations with preemptible
-		read-side critical sections.
+irqreaders	Says to invoke RCU readers from irq level.  This is currently
+		done via timers.  Defaults to "1" for variants of RCU that
+		permit this.  (Or, more accurately, variants of RCU that do
+		-not- permit this know to ignore this variable.)
 
 nfakewriters	This is the number of RCU fake writer threads to run.  Fake
 		writer threads repeatedly use the synchronous "wait for
@@ -37,6 +44,16 @@ nfakewriters	This is the number of RCU fake writer threads to run.  Fake
 		to trigger special cases caused by multiple writers, such as
 		the synchronize_srcu() early return optimization.
 
+nreaders	This is the number of RCU reading threads supported.
+		The default is twice the number of CPUs.  Why twice?
+		To properly exercise RCU implementations with preemptible
+		read-side critical sections.
+
+shuffle_interval
+		The number of seconds to keep the test threads affinitied
+		to a particular subset of the CPUs, defaults to 3 seconds.
+		Used in conjunction with test_no_idle_hz.
+
 stat_interval	The number of seconds between output of torture
 		statistics (via printk()).  Regardless of the interval,
 		statistics are printed when the module is unloaded.
@@ -44,10 +61,11 @@ stat_interval	The number of seconds between output of torture
 		be printed -only- when the module is unloaded, and this
 		is the default.
 
-shuffle_interval
-		The number of seconds to keep the test threads affinitied
-		to a particular subset of the CPUs, defaults to 5 seconds.
-		Used in conjunction with test_no_idle_hz.
+stutter		The length of time to run the test before pausing for this
+		same period of time.  Defaults to "stutter=5", so as
+		to run and pause for (roughly) five-second intervals.
+		Specifying "stutter=0" causes the test to run continuously
+		without pausing, which is the old default behavior.
 
 test_no_idle_hz	Whether or not to test the ability of RCU to operate in
 		a kernel that disables the scheduling-clock interrupt to
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index e0d6d99..e04d643 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -1,3 +1,11 @@
+Please note that the "What is RCU?" LWN series is an excellent place
+to start learning about RCU:
+
+1.	What is RCU, Fundamentally?  http://lwn.net/Articles/262464/
+2.	What is RCU? Part 2: Usage   http://lwn.net/Articles/263130/
+3.	RCU part 3: the RCU API      http://lwn.net/Articles/264090/
+
+
 What is RCU?
 
 RCU is a synchronization mechanism that was added to the Linux kernel
@@ -772,26 +780,18 @@ Linux-kernel source code, but it helps to have a full list of the
 APIs, since there does not appear to be a way to categorize them
 in docbook.  Here is the list, by category.
 
-Markers for RCU read-side critical sections:
-
-	rcu_read_lock
-	rcu_read_unlock
-	rcu_read_lock_bh
-	rcu_read_unlock_bh
-	srcu_read_lock
-	srcu_read_unlock
-
 RCU pointer/list traversal:
 
 	rcu_dereference
+	list_for_each_entry_rcu
+	hlist_for_each_entry_rcu
+
 	list_for_each_rcu		(to be deprecated in favor of
 					 list_for_each_entry_rcu)
-	list_for_each_entry_rcu
 	list_for_each_continue_rcu	(to be deprecated in favor of new
 					 list_for_each_entry_continue_rcu)
-	hlist_for_each_entry_rcu
 
-RCU pointer update:
+RCU pointer/list update:
 
 	rcu_assign_pointer
 	list_add_rcu
@@ -799,16 +799,36 @@ RCU pointer update:
 	list_del_rcu
 	list_replace_rcu
 	hlist_del_rcu
+	hlist_add_after_rcu
+	hlist_add_before_rcu
 	hlist_add_head_rcu
+	hlist_replace_rcu
+	list_splice_init_rcu()
 
-RCU grace period:
+RCU:	Critical sections	Grace period		Barrier
+
+	rcu_read_lock		synchronize_net		rcu_barrier
+	rcu_read_unlock		synchronize_rcu
+				call_rcu
+
+
+bh:	Critical sections	Grace period		Barrier
+
+	rcu_read_lock_bh	call_rcu_bh		rcu_barrier_bh
+	rcu_read_unlock_bh
+
+
+sched:	Critical sections	Grace period		Barrier
+
+	[preempt_disable]	synchronize_sched	rcu_barrier_sched
+	[and friends]		call_rcu_sched
+
+
+SRCU:	Critical sections	Grace period		Barrier
+
+	srcu_read_lock		synchronize_srcu	N/A
+	srcu_read_unlock
 
-	synchronize_net
-	synchronize_sched
-	synchronize_rcu
-	synchronize_srcu
-	call_rcu
-	call_rcu_bh
 
 See the comment headers in the source code (or the docbook generated
 from them) for more information.
diff --git a/arch/ia64/sn/kernel/irq.c b/arch/ia64/sn/kernel/irq.c
index 53351c3..96c31b4 100644
--- a/arch/ia64/sn/kernel/irq.c
+++ b/arch/ia64/sn/kernel/irq.c
@@ -11,6 +11,7 @@
 #include <linux/irq.h>
 #include <linux/spinlock.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <asm/sn/addrs.h>
 #include <asm/sn/arch.h>
 #include <asm/sn/intr.h>
diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index c6e772f..095c798 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -23,6 +23,7 @@
  * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
+#include <linux/rculist.h>
 #include <linux/kernel.h>
 #include <linux/async_tx.h>
 
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 7779165..38c44de 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -35,6 +35,7 @@
 #include <rdma/ib_user_verbs.h>
 #include <linux/io.h>
 #include <linux/utsname.h>
+#include <linux/rculist.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c b/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
index 9e5abf9..d73e322 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs_mcast.c
@@ -31,8 +31,7 @@
  * SOFTWARE.
  */
 
-#include <linux/list.h>
-#include <linux/rcupdate.h>
+#include <linux/rculist.h>
 
 #include "ipath_verbs.h"
 
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index c36a03a..860d75d 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -20,7 +20,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/notifier.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index d982eb8..98202c6 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -3,6 +3,7 @@
 
 #include <asm/atomic.h>
 #include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/spinlock.h>
 #include <linux/cache.h>
 #include <linux/rcupdate.h>
diff --git a/include/linux/list.h b/include/linux/list.h
index 08cf4f6..139ec41 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -85,65 +85,6 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
 }
 
 /*
- * Insert a new entry between two known consecutive entries.
- *
- * This is only for internal list manipulation where we know
- * the prev/next entries already!
- */
-static inline void __list_add_rcu(struct list_head * new,
-		struct list_head * prev, struct list_head * next)
-{
-	new->next = next;
-	new->prev = prev;
-	smp_wmb();
-	next->prev = new;
-	prev->next = new;
-}
-
-/**
- * list_add_rcu - add a new entry to rcu-protected list
- * @new: new entry to be added
- * @head: list head to add it after
- *
- * Insert a new entry after the specified head.
- * This is good for implementing stacks.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_add_rcu()
- * or list_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- */
-static inline void list_add_rcu(struct list_head *new, struct list_head *head)
-{
-	__list_add_rcu(new, head, head->next);
-}
-
-/**
- * list_add_tail_rcu - add a new entry to rcu-protected list
- * @new: new entry to be added
- * @head: list head to add it before
- *
- * Insert a new entry before the specified head.
- * This is useful for implementing queues.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_add_tail_rcu()
- * or list_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- */
-static inline void list_add_tail_rcu(struct list_head *new,
-					struct list_head *head)
-{
-	__list_add_rcu(new, head->prev, head);
-}
-
-/*
  * Delete a list entry by making the prev/next entries
  * point to each other.
  *
@@ -174,36 +115,6 @@ extern void list_del(struct list_head *entry);
 #endif
 
 /**
- * list_del_rcu - deletes entry from list without re-initialization
- * @entry: the element to delete from the list.
- *
- * Note: list_empty() on entry does not return true after this,
- * the entry is in an undefined state. It is useful for RCU based
- * lockfree traversal.
- *
- * In particular, it means that we can not poison the forward
- * pointers that may still be used for walking the list.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as list_del_rcu()
- * or list_add_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * list_for_each_entry_rcu().
- *
- * Note that the caller is not permitted to immediately free
- * the newly deleted entry.  Instead, either synchronize_rcu()
- * or call_rcu() must be used to defer freeing until an RCU
- * grace period has elapsed.
- */
-static inline void list_del_rcu(struct list_head *entry)
-{
-	__list_del(entry->prev, entry->next);
-	entry->prev = LIST_POISON2;
-}
-
-/**
  * list_replace - replace old entry by new one
  * @old : the element to be replaced
  * @new : the new element to insert
@@ -227,25 +138,6 @@ static inline void list_replace_init(struct list_head *old,
 }
 
 /**
- * list_replace_rcu - replace old entry by new one
- * @old : the element to be replaced
- * @new : the new element to insert
- *
- * The @old entry will be replaced with the @new entry atomically.
- * Note: @old should not be empty.
- */
-static inline void list_replace_rcu(struct list_head *old,
-				struct list_head *new)
-{
-	new->next = old->next;
-	new->prev = old->prev;
-	smp_wmb();
-	new->next->prev = new;
-	new->prev->next = new;
-	old->prev = LIST_POISON2;
-}
-
-/**
  * list_del_init - deletes entry from list and reinitialize it.
  * @entry: the element to delete from the list.
  */
@@ -369,62 +261,6 @@ static inline void list_splice_init(struct list_head *list,
 }
 
 /**
- * list_splice_init_rcu - splice an RCU-protected list into an existing list.
- * @list:	the RCU-protected list to splice
- * @head:	the place in the list to splice the first list into
- * @sync:	function to sync: synchronize_rcu(), synchronize_sched(), ...
- *
- * @head can be RCU-read traversed concurrently with this function.
- *
- * Note that this function blocks.
- *
- * Important note: the caller must take whatever action is necessary to
- *	prevent any other updates to @head.  In principle, it is possible
- *	to modify the list as soon as sync() begins execution.
- *	If this sort of thing becomes necessary, an alternative version
- *	based on call_rcu() could be created.  But only if -really-
- *	needed -- there is no shortage of RCU API members.
- */
-static inline void list_splice_init_rcu(struct list_head *list,
-					struct list_head *head,
-					void (*sync)(void))
-{
-	struct list_head *first = list->next;
-	struct list_head *last = list->prev;
-	struct list_head *at = head->next;
-
-	if (list_empty(head))
-		return;
-
-	/* "first" and "last" tracking list, so initialize it. */
-
-	INIT_LIST_HEAD(list);
-
-	/*
-	 * At this point, the list body still points to the source list.
-	 * Wait for any readers to finish using the list before splicing
-	 * the list body into the new list.  Any new readers will see
-	 * an empty list.
-	 */
-
-	sync();
-
-	/*
-	 * Readers are finished with the source list, so perform splice.
-	 * The order is important if the new list is global and accessible
-	 * to concurrent RCU readers.  Note that RCU readers are not
-	 * permitted to traverse the prev pointers without excluding
-	 * this function.
-	 */
-
-	last->next = at;
-	smp_wmb();
-	head->next = first;
-	first->prev = head;
-	at->prev = last;
-}
-
-/**
  * list_entry - get the struct for this entry
  * @ptr:	the &struct list_head pointer.
  * @type:	the type of the struct this is embedded in.
@@ -629,57 +465,6 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	     &pos->member != (head); 					\
 	     pos = n, n = list_entry(n->member.prev, typeof(*n), member))
 
-/**
- * list_for_each_rcu	-	iterate over an rcu-protected list
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_rcu(pos, head) \
-	for (pos = rcu_dereference((head)->next); \
-		prefetch(pos->next), pos != (head); \
-		pos = rcu_dereference(pos->next))
-
-#define __list_for_each_rcu(pos, head) \
-	for (pos = rcu_dereference((head)->next); \
-		pos != (head); \
-		pos = rcu_dereference(pos->next))
-
-/**
- * list_for_each_entry_rcu	-	iterate over rcu list of given type
- * @pos:	the type * to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the list_struct within the struct.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_entry_rcu(pos, head, member) \
-	for (pos = list_entry(rcu_dereference((head)->next), typeof(*pos), member); \
-		prefetch(pos->member.next), &pos->member != (head); \
-		pos = list_entry(rcu_dereference(pos->member.next), typeof(*pos), member))
-
-
-/**
- * list_for_each_continue_rcu
- * @pos:	the &struct list_head to use as a loop cursor.
- * @head:	the head for your list.
- *
- * Iterate over an rcu-protected list, continuing after current point.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as list_add_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define list_for_each_continue_rcu(pos, head) \
-	for ((pos) = rcu_dereference((pos)->next); \
-		prefetch((pos)->next), (pos) != (head); \
-		(pos) = rcu_dereference((pos)->next))
-
 /*
  * Double linked lists with a single pointer list head.
  * Mostly useful for hash tables where the two pointer list head is
@@ -730,31 +515,6 @@ static inline void hlist_del(struct hlist_node *n)
 	n->pprev = LIST_POISON2;
 }
 
-/**
- * hlist_del_rcu - deletes entry from hash list without re-initialization
- * @n: the element to delete from the hash list.
- *
- * Note: list_unhashed() on entry does not return true after this,
- * the entry is in an undefined state. It is useful for RCU based
- * lockfree traversal.
- *
- * In particular, it means that we can not poison the forward
- * pointers that may still be used for walking the hash list.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry().
- */
-static inline void hlist_del_rcu(struct hlist_node *n)
-{
-	__hlist_del(n);
-	n->pprev = LIST_POISON2;
-}
-
 static inline void hlist_del_init(struct hlist_node *n)
 {
 	if (!hlist_unhashed(n)) {
@@ -763,27 +523,6 @@ static inline void hlist_del_init(struct hlist_node *n)
 	}
 }
 
-/**
- * hlist_replace_rcu - replace old entry by new one
- * @old : the element to be replaced
- * @new : the new element to insert
- *
- * The @old entry will be replaced with the @new entry atomically.
- */
-static inline void hlist_replace_rcu(struct hlist_node *old,
-					struct hlist_node *new)
-{
-	struct hlist_node *next = old->next;
-
-	new->next = next;
-	new->pprev = old->pprev;
-	smp_wmb();
-	if (next)
-		new->next->pprev = &new->next;
-	*new->pprev = new;
-	old->pprev = LIST_POISON2;
-}
-
 static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 {
 	struct hlist_node *first = h->first;
@@ -794,38 +533,6 @@ static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
 	n->pprev = &h->first;
 }
 
-
-/**
- * hlist_add_head_rcu
- * @n: the element to add to the hash list.
- * @h: the list to add to.
- *
- * Description:
- * Adds the specified element to the specified hlist,
- * while permitting racing traversals.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry_rcu(), used to prevent memory-consistency
- * problems on Alpha CPUs.  Regardless of the type of CPU, the
- * list-traversal primitive must be guarded by rcu_read_lock().
- */
-static inline void hlist_add_head_rcu(struct hlist_node *n,
-					struct hlist_head *h)
-{
-	struct hlist_node *first = h->first;
-	n->next = first;
-	n->pprev = &h->first;
-	smp_wmb();
-	if (first)
-		first->pprev = &n->next;
-	h->first = n;
-}
-
 /* next must be != NULL */
 static inline void hlist_add_before(struct hlist_node *n,
 					struct hlist_node *next)
@@ -847,63 +554,6 @@ static inline void hlist_add_after(struct hlist_node *n,
 		next->next->pprev  = &next->next;
 }
 
-/**
- * hlist_add_before_rcu
- * @n: the new element to add to the hash list.
- * @next: the existing element to add the new element before.
- *
- * Description:
- * Adds the specified element to the specified hlist
- * before the specified node while permitting racing traversals.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry_rcu(), used to prevent memory-consistency
- * problems on Alpha CPUs.
- */
-static inline void hlist_add_before_rcu(struct hlist_node *n,
-					struct hlist_node *next)
-{
-	n->pprev = next->pprev;
-	n->next = next;
-	smp_wmb();
-	next->pprev = &n->next;
-	*(n->pprev) = n;
-}
-
-/**
- * hlist_add_after_rcu
- * @prev: the existing element to add the new element after.
- * @n: the new element to add to the hash list.
- *
- * Description:
- * Adds the specified element to the specified hlist
- * after the specified node while permitting racing traversals.
- *
- * The caller must take whatever precautions are necessary
- * (such as holding appropriate locks) to avoid racing
- * with another list-mutation primitive, such as hlist_add_head_rcu()
- * or hlist_del_rcu(), running on this same list.
- * However, it is perfectly legal to run concurrently with
- * the _rcu list-traversal primitives, such as
- * hlist_for_each_entry_rcu(), used to prevent memory-consistency
- * problems on Alpha CPUs.
- */
-static inline void hlist_add_after_rcu(struct hlist_node *prev,
-				       struct hlist_node *n)
-{
-	n->next = prev->next;
-	n->pprev = &prev->next;
-	smp_wmb();
-	prev->next = n;
-	if (n->next)
-		n->next->pprev = &n->next;
-}
-
 #define hlist_entry(ptr, type, member) container_of(ptr,type,member)
 
 #define hlist_for_each(pos, head) \
@@ -964,21 +614,4 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
 	     pos = n)
 
-/**
- * hlist_for_each_entry_rcu - iterate over rcu list of given type
- * @tpos:	the type * to use as a loop cursor.
- * @pos:	the &struct hlist_node to use as a loop cursor.
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
- *
- * This list-traversal primitive may safely run concurrently with
- * the _rcu list-mutation primitives such as hlist_add_head_rcu()
- * as long as the traversal is guarded by rcu_read_lock().
- */
-#define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
-	for (pos = rcu_dereference((head)->first);			 \
-	        pos && ({ prefetch(pos->next); 1;}) &&			 \
-		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1;}); \
-	     pos = rcu_dereference(pos->next))
-
 #endif
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index b3aa05b..8c77490 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -151,7 +151,10 @@ extern struct lockdep_map rcu_lock_map;
 
 #define __synchronize_sched() synchronize_rcu()
 
+#define call_rcu_sched(head, func) call_rcu(head, func)
+
 extern void __rcu_init(void);
+#define rcu_init_sched()	do { } while (0)
 extern void rcu_check_callbacks(int cpu, int user);
 extern void rcu_restart_cpu(int cpu);
 
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index bde4586..b0f39be 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -1,6 +1,373 @@
 #ifndef _LINUX_RCULIST_H
 #define _LINUX_RCULIST_H
 
+#ifdef __KERNEL__
+
+/*
+ * RCU-protected list version
+ */
 #include <linux/list.h>
+#include <linux/rcupdate.h>
+
+/*
+ * Insert a new entry between two known consecutive entries.
+ *
+ * This is only for internal list manipulation where we know
+ * the prev/next entries already!
+ */
+static inline void __list_add_rcu(struct list_head *new,
+		struct list_head *prev, struct list_head *next)
+{
+	new->next = next;
+	new->prev = prev;
+	rcu_assign_pointer(prev->next, new);
+	next->prev = new;
+}
+
+/**
+ * list_add_rcu - add a new entry to rcu-protected list
+ * @new: new entry to be added
+ * @head: list head to add it after
+ *
+ * Insert a new entry after the specified head.
+ * This is good for implementing stacks.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_add_rcu()
+ * or list_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ */
+static inline void list_add_rcu(struct list_head *new, struct list_head *head)
+{
+	__list_add_rcu(new, head, head->next);
+}
+
+/**
+ * list_add_tail_rcu - add a new entry to rcu-protected list
+ * @new: new entry to be added
+ * @head: list head to add it before
+ *
+ * Insert a new entry before the specified head.
+ * This is useful for implementing queues.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_add_tail_rcu()
+ * or list_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ */
+static inline void list_add_tail_rcu(struct list_head *new,
+					struct list_head *head)
+{
+	__list_add_rcu(new, head->prev, head);
+}
+
+/**
+ * list_del_rcu - deletes entry from list without re-initialization
+ * @entry: the element to delete from the list.
+ *
+ * Note: list_empty() on entry does not return true after this,
+ * the entry is in an undefined state. It is useful for RCU based
+ * lockfree traversal.
+ *
+ * In particular, it means that we can not poison the forward
+ * pointers that may still be used for walking the list.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as list_del_rcu()
+ * or list_add_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * list_for_each_entry_rcu().
+ *
+ * Note that the caller is not permitted to immediately free
+ * the newly deleted entry.  Instead, either synchronize_rcu()
+ * or call_rcu() must be used to defer freeing until an RCU
+ * grace period has elapsed.
+ */
+static inline void list_del_rcu(struct list_head *entry)
+{
+	__list_del(entry->prev, entry->next);
+	entry->prev = LIST_POISON2;
+}
+
+/**
+ * list_replace_rcu - replace old entry by new one
+ * @old : the element to be replaced
+ * @new : the new element to insert
+ *
+ * The @old entry will be replaced with the @new entry atomically.
+ * Note: @old should not be empty.
+ */
+static inline void list_replace_rcu(struct list_head *old,
+				struct list_head *new)
+{
+	new->next = old->next;
+	new->prev = old->prev;
+	rcu_assign_pointer(new->prev->next, new);
+	new->next->prev = new;
+	old->prev = LIST_POISON2;
+}
+
+/**
+ * list_splice_init_rcu - splice an RCU-protected list into an existing list.
+ * @list:	the RCU-protected list to splice
+ * @head:	the place in the list to splice the first list into
+ * @sync:	function to sync: synchronize_rcu(), synchronize_sched(), ...
+ *
+ * @head can be RCU-read traversed concurrently with this function.
+ *
+ * Note that this function blocks.
+ *
+ * Important note: the caller must take whatever action is necessary to
+ *	prevent any other updates to @head.  In principle, it is possible
+ *	to modify the list as soon as sync() begins execution.
+ *	If this sort of thing becomes necessary, an alternative version
+ *	based on call_rcu() could be created.  But only if -really-
+ *	needed -- there is no shortage of RCU API members.
+ */
+static inline void list_splice_init_rcu(struct list_head *list,
+					struct list_head *head,
+					void (*sync)(void))
+{
+	struct list_head *first = list->next;
+	struct list_head *last = list->prev;
+	struct list_head *at = head->next;
+
+	if (list_empty(head))
+		return;
+
+	/* "first" and "last" tracking list, so initialize it. */
+
+	INIT_LIST_HEAD(list);
+
+	/*
+	 * At this point, the list body still points to the source list.
+	 * Wait for any readers to finish using the list before splicing
+	 * the list body into the new list.  Any new readers will see
+	 * an empty list.
+	 */
+
+	sync();
+
+	/*
+	 * Readers are finished with the source list, so perform splice.
+	 * The order is important if the new list is global and accessible
+	 * to concurrent RCU readers.  Note that RCU readers are not
+	 * permitted to traverse the prev pointers without excluding
+	 * this function.
+	 */
+
+	last->next = at;
+	rcu_assign_pointer(head->next, first);
+	first->prev = head;
+	at->prev = last;
+}
+
+/**
+ * list_for_each_rcu	-	iterate over an rcu-protected list
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_rcu(pos, head) \
+	for (pos = rcu_dereference((head)->next); \
+		prefetch(pos->next), pos != (head); \
+		pos = rcu_dereference(pos->next))
+
+#define __list_for_each_rcu(pos, head) \
+	for (pos = rcu_dereference((head)->next); \
+		pos != (head); \
+		pos = rcu_dereference(pos->next))
+
+/**
+ * list_for_each_entry_rcu	-	iterate over rcu list of given type
+ * @pos:	the type * to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the list_struct within the struct.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_entry_rcu(pos, head, member) \
+	for (pos = list_entry(rcu_dereference((head)->next), typeof(*pos), member); \
+		prefetch(pos->member.next), &pos->member != (head); \
+		pos = list_entry(rcu_dereference(pos->member.next), typeof(*pos), member))
+
+
+/**
+ * list_for_each_continue_rcu
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @head:	the head for your list.
+ *
+ * Iterate over an rcu-protected list, continuing after current point.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as list_add_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define list_for_each_continue_rcu(pos, head) \
+	for ((pos) = rcu_dereference((pos)->next); \
+		prefetch((pos)->next), (pos) != (head); \
+		(pos) = rcu_dereference((pos)->next))
+
+/**
+ * hlist_del_rcu - deletes entry from hash list without re-initialization
+ * @n: the element to delete from the hash list.
+ *
+ * Note: list_unhashed() on entry does not return true after this,
+ * the entry is in an undefined state. It is useful for RCU based
+ * lockfree traversal.
+ *
+ * In particular, it means that we can not poison the forward
+ * pointers that may still be used for walking the hash list.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry().
+ */
+static inline void hlist_del_rcu(struct hlist_node *n)
+{
+	__hlist_del(n);
+	n->pprev = LIST_POISON2;
+}
+
+/**
+ * hlist_replace_rcu - replace old entry by new one
+ * @old : the element to be replaced
+ * @new : the new element to insert
+ *
+ * The @old entry will be replaced with the @new entry atomically.
+ */
+static inline void hlist_replace_rcu(struct hlist_node *old,
+					struct hlist_node *new)
+{
+	struct hlist_node *next = old->next;
+
+	new->next = next;
+	new->pprev = old->pprev;
+	rcu_assign_pointer(*new->pprev, new);
+	if (next)
+		new->next->pprev = &new->next;
+	old->pprev = LIST_POISON2;
+}
+
+/**
+ * hlist_add_head_rcu
+ * @n: the element to add to the hash list.
+ * @h: the list to add to.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist,
+ * while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.  Regardless of the type of CPU, the
+ * list-traversal primitive must be guarded by rcu_read_lock().
+ */
+static inline void hlist_add_head_rcu(struct hlist_node *n,
+					struct hlist_head *h)
+{
+	struct hlist_node *first = h->first;
+
+	n->next = first;
+	n->pprev = &h->first;
+	rcu_assign_pointer(h->first, n);
+	if (first)
+		first->pprev = &n->next;
+}
+
+/**
+ * hlist_add_before_rcu
+ * @n: the new element to add to the hash list.
+ * @next: the existing element to add the new element before.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist
+ * before the specified node while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.
+ */
+static inline void hlist_add_before_rcu(struct hlist_node *n,
+					struct hlist_node *next)
+{
+	n->pprev = next->pprev;
+	n->next = next;
+	rcu_assign_pointer(*(n->pprev), n);
+	next->pprev = &n->next;
+}
+
+/**
+ * hlist_add_after_rcu
+ * @prev: the existing element to add the new element after.
+ * @n: the new element to add to the hash list.
+ *
+ * Description:
+ * Adds the specified element to the specified hlist
+ * after the specified node while permitting racing traversals.
+ *
+ * The caller must take whatever precautions are necessary
+ * (such as holding appropriate locks) to avoid racing
+ * with another list-mutation primitive, such as hlist_add_head_rcu()
+ * or hlist_del_rcu(), running on this same list.
+ * However, it is perfectly legal to run concurrently with
+ * the _rcu list-traversal primitives, such as
+ * hlist_for_each_entry_rcu(), used to prevent memory-consistency
+ * problems on Alpha CPUs.
+ */
+static inline void hlist_add_after_rcu(struct hlist_node *prev,
+				       struct hlist_node *n)
+{
+	n->next = prev->next;
+	n->pprev = &prev->next;
+	rcu_assign_pointer(prev->next, n);
+	if (n->next)
+		n->next->pprev = &n->next;
+}
+
+/**
+ * hlist_for_each_entry_rcu - iterate over rcu list of given type
+ * @tpos:	the type * to use as a loop cursor.
+ * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @head:	the head for your list.
+ * @member:	the name of the hlist_node within the struct.
+ *
+ * This list-traversal primitive may safely run concurrently with
+ * the _rcu list-mutation primitives such as hlist_add_head_rcu()
+ * as long as the traversal is guarded by rcu_read_lock().
+ */
+#define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
+	for (pos = rcu_dereference((head)->first);			 \
+		pos && ({ prefetch(pos->next); 1; }) &&			 \
+		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
+		pos = rcu_dereference(pos->next))
 
-#endif	/* _LINUX_RCULIST_H */
+#endif	/* __KERNEL__ */
+#endif
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index d42dbec..e8b4039 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -40,6 +40,7 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 #include <linux/lockdep.h>
+#include <linux/completion.h>
 
 /**
  * struct rcu_head - callback structure for use with RCU
@@ -168,6 +169,27 @@ struct rcu_head {
 		(p) = (v); \
 	})
 
+/* Infrastructure to implement the synchronize_() primitives. */
+
+struct rcu_synchronize {
+	struct rcu_head head;
+	struct completion completion;
+};
+
+extern void wakeme_after_rcu(struct rcu_head  *head);
+
+#define synchronize_rcu_xxx(name, func) \
+void name(void) \
+{ \
+	struct rcu_synchronize rcu; \
+	\
+	init_completion(&rcu.completion); \
+	/* Will wake me after RCU finished. */ \
+	func(&rcu.head, wakeme_after_rcu); \
+	/* Wait for it. */ \
+	wait_for_completion(&rcu.completion); \
+}
+
 /**
  * synchronize_sched - block until all CPUs have exited any non-preemptive
  * kernel code sequences.
@@ -224,8 +246,8 @@ extern void call_rcu_bh(struct rcu_head *head,
 /* Exported common interfaces */
 extern void synchronize_rcu(void);
 extern void rcu_barrier(void);
-extern long rcu_batches_completed(void);
-extern long rcu_batches_completed_bh(void);
+extern void rcu_barrier_bh(void);
+extern void rcu_barrier_sched(void);
 
 /* Internal to kernel */
 extern void rcu_init(void);
diff --git a/include/linux/rcupreempt.h b/include/linux/rcupreempt.h
index 8a05c7e..f04b64e 100644
--- a/include/linux/rcupreempt.h
+++ b/include/linux/rcupreempt.h
@@ -40,10 +40,39 @@
 #include <linux/cpumask.h>
 #include <linux/seqlock.h>
 
-#define rcu_qsctr_inc(cpu)
+struct rcu_dyntick_sched {
+	int dynticks;
+	int dynticks_snap;
+	int sched_qs;
+	int sched_qs_snap;
+	int sched_dynticks_snap;
+};
+
+DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
+
+static inline void rcu_qsctr_inc(int cpu)
+{
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	rdssp->sched_qs++;
+}
 #define rcu_bh_qsctr_inc(cpu)
 #define call_rcu_bh(head, rcu) call_rcu(head, rcu)
 
+/**
+ * call_rcu_sched - Queue RCU callback for invocation after sched grace period.
+ * @head: structure to be used for queueing the RCU updates.
+ * @func: actual update function to be invoked after the grace period
+ *
+ * The update function will be invoked some time after a full
+ * synchronize_sched()-style grace period elapses, in other words after
+ * all currently executing preempt-disabled sections of code (including
+ * hardirq handlers, NMI handlers, and local_irq_save() blocks) have
+ * completed.
+ */
+extern void call_rcu_sched(struct rcu_head *head,
+			   void (*func)(struct rcu_head *head));
+
 extern void __rcu_read_lock(void)	__acquires(RCU);
 extern void __rcu_read_unlock(void)	__releases(RCU);
 extern int rcu_pending(int cpu);
@@ -55,6 +84,7 @@ extern int rcu_needs_cpu(int cpu);
 extern void __synchronize_sched(void);
 
 extern void __rcu_init(void);
+extern void rcu_init_sched(void);
 extern void rcu_check_callbacks(int cpu, int user);
 extern void rcu_restart_cpu(int cpu);
 extern long rcu_batches_completed(void);
@@ -81,20 +111,20 @@ extern struct rcupreempt_trace *rcupreempt_trace_cpu(int cpu);
 struct softirq_action;
 
 #ifdef CONFIG_NO_HZ
-DECLARE_PER_CPU(long, dynticks_progress_counter);
+DECLARE_PER_CPU(struct rcu_dyntick_sched, rcu_dyntick_sched);
 
 static inline void rcu_enter_nohz(void)
 {
 	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
-	__get_cpu_var(dynticks_progress_counter)++;
-	WARN_ON(__get_cpu_var(dynticks_progress_counter) & 0x1);
+	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	WARN_ON(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1);
 }
 
 static inline void rcu_exit_nohz(void)
 {
-	__get_cpu_var(dynticks_progress_counter)++;
 	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
-	WARN_ON(!(__get_cpu_var(dynticks_progress_counter) & 0x1));
+	__get_cpu_var(rcu_dyntick_sched).dynticks++;
+	WARN_ON(!(__get_cpu_var(rcu_dyntick_sched).dynticks & 0x1));
 }
 
 #else /* CONFIG_NO_HZ */
diff --git a/init/main.c b/init/main.c
index d215b27..a8ff981 100644
--- a/init/main.c
+++ b/init/main.c
@@ -766,6 +766,7 @@ static void __init do_initcalls(void)
  */
 static void __init do_basic_setup(void)
 {
+	rcu_init_sched(); /* needed by module_init stage. */
 	/* drivers will send hotplug events */
 	init_workqueues();
 	usermodehelper_init();
diff --git a/kernel/pid.c b/kernel/pid.c
index 20d59fa..30bd5d4 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -30,6 +30,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <linux/bootmem.h>
 #include <linux/hash.h>
 #include <linux/pid_namespace.h>
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index a38895a..529190c 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -387,6 +387,10 @@ static void __rcu_offline_cpu(struct rcu_data *this_rdp,
 	rcu_move_batch(this_rdp, rdp->donelist, rdp->donetail);
 	rcu_move_batch(this_rdp, rdp->curlist, rdp->curtail);
 	rcu_move_batch(this_rdp, rdp->nxtlist, rdp->nxttail);
+
+	local_irq_disable();
+	this_rdp->qlen += rdp->qlen;
+	local_irq_enable();
 }
 
 static void rcu_offline_cpu(int cpu)
@@ -516,10 +520,38 @@ void rcu_check_callbacks(int cpu, int user)
 	if (user ||
 	    (idle_cpu(cpu) && !in_softirq() &&
 				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+
+		/*
+		 * Get here if this CPU took its interrupt from user
+		 * mode or from the idle loop, and if this is not a
+		 * nested interrupt.  In this case, the CPU is in
+		 * a quiescent state, so count it.
+		 *
+		 * Also do a memory barrier.  This is needed to handle
+		 * the case where writes from a preempt-disable section
+		 * of code get reordered into schedule() by this CPU's
+		 * write buffer.  The memory barrier makes sure that
+		 * the rcu_qsctr_inc() and rcu_bh_qsctr_inc() are see
+		 * by other CPUs to happen after any such write.
+		 */
+
+		smp_mb();  /* See above block comment. */
 		rcu_qsctr_inc(cpu);
 		rcu_bh_qsctr_inc(cpu);
-	} else if (!in_softirq())
+
+	} else if (!in_softirq()) {
+
+		/*
+		 * Get here if this CPU did not take its interrupt from
+		 * softirq, in other words, if it is not interrupting
+		 * a rcu_bh read-side critical section.  This is an _bh
+		 * critical section, so count it.  The memory barrier
+		 * is needed for the same reason as is the above one.
+		 */
+
+		smp_mb();  /* See above block comment. */
 		rcu_bh_qsctr_inc(cpu);
+	}
 	raise_rcu_softirq();
 }
 
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index c09605f..4a74b8d 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -39,16 +39,16 @@
 #include <linux/sched.h>
 #include <asm/atomic.h>
 #include <linux/bitops.h>
-#include <linux/completion.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
 
-struct rcu_synchronize {
-	struct rcu_head head;
-	struct completion completion;
+enum rcu_barrier {
+	RCU_BARRIER_STD,
+	RCU_BARRIER_BH,
+	RCU_BARRIER_SCHED,
 };
 
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
@@ -60,7 +60,7 @@ static struct completion rcu_barrier_completion;
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
  */
-static void wakeme_after_rcu(struct rcu_head  *head)
+void wakeme_after_rcu(struct rcu_head  *head)
 {
 	struct rcu_synchronize *rcu;
 
@@ -77,17 +77,7 @@ static void wakeme_after_rcu(struct rcu_head  *head)
  * sections are delimited by rcu_read_lock() and rcu_read_unlock(),
  * and may be nested.
  */
-void synchronize_rcu(void)
-{
-	struct rcu_synchronize rcu;
-
-	init_completion(&rcu.completion);
-	/* Will wake me after RCU finished */
-	call_rcu(&rcu.head, wakeme_after_rcu);
-
-	/* Wait for it */
-	wait_for_completion(&rcu.completion);
-}
+synchronize_rcu_xxx(synchronize_rcu, call_rcu)
 EXPORT_SYMBOL_GPL(synchronize_rcu);
 
 static void rcu_barrier_callback(struct rcu_head *notused)
@@ -99,19 +89,30 @@ static void rcu_barrier_callback(struct rcu_head *notused)
 /*
  * Called with preemption disabled, and from cross-cpu IRQ context.
  */
-static void rcu_barrier_func(void *notused)
+static void rcu_barrier_func(void *type)
 {
 	int cpu = smp_processor_id();
 	struct rcu_head *head = &per_cpu(rcu_barrier_head, cpu);
 
 	atomic_inc(&rcu_barrier_cpu_count);
-	call_rcu(head, rcu_barrier_callback);
+	switch ((enum rcu_barrier)type) {
+	case RCU_BARRIER_STD:
+		call_rcu(head, rcu_barrier_callback);
+		break;
+	case RCU_BARRIER_BH:
+		call_rcu_bh(head, rcu_barrier_callback);
+		break;
+	case RCU_BARRIER_SCHED:
+		call_rcu_sched(head, rcu_barrier_callback);
+		break;
+	}
 }
 
-/**
- * rcu_barrier - Wait until all the in-flight RCUs are complete.
+/*
+ * Orchestrate the specified type of RCU barrier, waiting for all
+ * RCU callbacks of the specified type to complete.
  */
-void rcu_barrier(void)
+static void _rcu_barrier(enum rcu_barrier type)
 {
 	BUG_ON(in_interrupt());
 	/* Take cpucontrol mutex to protect against CPU hotplug */
@@ -127,13 +128,39 @@ void rcu_barrier(void)
 	 * until all the callbacks are queued.
 	 */
 	rcu_read_lock();
-	on_each_cpu(rcu_barrier_func, NULL, 0, 1);
+	on_each_cpu(rcu_barrier_func, (void *)type, 0, 1);
 	rcu_read_unlock();
 	wait_for_completion(&rcu_barrier_completion);
 	mutex_unlock(&rcu_barrier_mutex);
 }
+
+/**
+ * rcu_barrier - Wait until all in-flight call_rcu() callbacks complete.
+ */
+void rcu_barrier(void)
+{
+	_rcu_barrier(RCU_BARRIER_STD);
+}
 EXPORT_SYMBOL_GPL(rcu_barrier);
 
+/**
+ * rcu_barrier_bh - Wait until all in-flight call_rcu_bh() callbacks complete.
+ */
+void rcu_barrier_bh(void)
+{
+	_rcu_barrier(RCU_BARRIER_BH);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_bh);
+
+/**
+ * rcu_barrier_sched - Wait for in-flight call_rcu_sched() callbacks.
+ */
+void rcu_barrier_sched(void)
+{
+	_rcu_barrier(RCU_BARRIER_SCHED);
+}
+EXPORT_SYMBOL_GPL(rcu_barrier_sched);
+
 void __init rcu_init(void)
 {
 	__rcu_init();
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 41d275a..536ce83 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -46,11 +46,11 @@
 #include <asm/atomic.h>
 #include <linux/bitops.h>
 #include <linux/module.h>
+#include <linux/kthread.h>
 #include <linux/completion.h>
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
-#include <linux/rcupdate.h>
 #include <linux/cpu.h>
 #include <linux/random.h>
 #include <linux/delay.h>
@@ -82,14 +82,18 @@ struct rcu_data {
 	spinlock_t	lock;		/* Protect rcu_data fields. */
 	long		completed;	/* Number of last completed batch. */
 	int		waitlistcount;
-	struct tasklet_struct rcu_tasklet;
 	struct rcu_head *nextlist;
 	struct rcu_head **nexttail;
 	struct rcu_head *waitlist[GP_STAGES];
 	struct rcu_head **waittail[GP_STAGES];
-	struct rcu_head *donelist;
+	struct rcu_head *donelist;	/* from waitlist & waitschedlist */
 	struct rcu_head **donetail;
 	long rcu_flipctr[2];
+	struct rcu_head *nextschedlist;
+	struct rcu_head **nextschedtail;
+	struct rcu_head *waitschedlist;
+	struct rcu_head **waitschedtail;
+	int rcu_sched_sleeping;
 #ifdef CONFIG_RCU_TRACE
 	struct rcupreempt_trace trace;
 #endif /* #ifdef CONFIG_RCU_TRACE */
@@ -131,11 +135,24 @@ enum rcu_try_flip_states {
 	rcu_try_flip_waitmb_state,
 };
 
+/*
+ * States for rcu_ctrlblk.rcu_sched_sleep.
+ */
+
+enum rcu_sched_sleep_states {
+	rcu_sched_not_sleeping,	/* Not sleeping, callbacks need GP.  */
+	rcu_sched_sleep_prep,	/* Thinking of sleeping, rechecking. */
+	rcu_sched_sleeping,	/* Sleeping, awaken if GP needed. */
+};
+
 struct rcu_ctrlblk {
 	spinlock_t	fliplock;	/* Protect state-machine transitions. */
 	long		completed;	/* Number of last completed batch. */
 	enum rcu_try_flip_states rcu_try_flip_state; /* The current state of
 							the rcu state machine */
+	spinlock_t	schedlock;	/* Protect rcu_sched sleep state. */
+	enum rcu_sched_sleep_states sched_sleep; /* rcu_sched state. */
+	wait_queue_head_t sched_wq;	/* Place for rcu_sched to sleep. */
 };
 
 static DEFINE_PER_CPU(struct rcu_data, rcu_data);
@@ -143,8 +160,12 @@ static struct rcu_ctrlblk rcu_ctrlblk = {
 	.fliplock = __SPIN_LOCK_UNLOCKED(rcu_ctrlblk.fliplock),
 	.completed = 0,
 	.rcu_try_flip_state = rcu_try_flip_idle_state,
+	.schedlock = __SPIN_LOCK_UNLOCKED(rcu_ctrlblk.schedlock),
+	.sched_sleep = rcu_sched_not_sleeping,
+	.sched_wq = __WAIT_QUEUE_HEAD_INITIALIZER(rcu_ctrlblk.sched_wq),
 };
 
+static struct task_struct *rcu_sched_grace_period_task;
 
 #ifdef CONFIG_RCU_TRACE
 static char *rcu_try_flip_state_names[] =
@@ -207,6 +228,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(enum rcu_mb_flag_values, rcu_mb_flag)
  */
 #define RCU_TRACE_RDP(f, rdp) RCU_TRACE(f, &((rdp)->trace));
 
+#define RCU_SCHED_BATCH_TIME (HZ / 50)
+
 /*
  * Return the number of RCU batches processed thus far.  Useful
  * for debug and statistics.
@@ -411,32 +434,34 @@ static void __rcu_advance_callbacks(struct rcu_data *rdp)
 	}
 }
 
-#ifdef CONFIG_NO_HZ
+DEFINE_PER_CPU_SHARED_ALIGNED(struct rcu_dyntick_sched, rcu_dyntick_sched) = {
+	.dynticks = 1,
+};
 
-DEFINE_PER_CPU(long, dynticks_progress_counter) = 1;
-static DEFINE_PER_CPU(long, rcu_dyntick_snapshot);
+#ifdef CONFIG_NO_HZ
 static DEFINE_PER_CPU(int, rcu_update_flag);
 
 /**
  * rcu_irq_enter - Called from Hard irq handlers and NMI/SMI.
  *
  * If the CPU was idle with dynamic ticks active, this updates the
- * dynticks_progress_counter to let the RCU handling know that the
+ * rcu_dyntick_sched.dynticks to let the RCU handling know that the
  * CPU is active.
  */
 void rcu_irq_enter(void)
 {
 	int cpu = smp_processor_id();
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
 
 	if (per_cpu(rcu_update_flag, cpu))
 		per_cpu(rcu_update_flag, cpu)++;
 
 	/*
 	 * Only update if we are coming from a stopped ticks mode
-	 * (dynticks_progress_counter is even).
+	 * (rcu_dyntick_sched.dynticks is even).
 	 */
 	if (!in_interrupt() &&
-	    (per_cpu(dynticks_progress_counter, cpu) & 0x1) == 0) {
+	    (rdssp->dynticks & 0x1) == 0) {
 		/*
 		 * The following might seem like we could have a race
 		 * with NMI/SMIs. But this really isn't a problem.
@@ -459,12 +484,12 @@ void rcu_irq_enter(void)
 		 * RCU read-side critical sections on this CPU would
 		 * have already completed.
 		 */
-		per_cpu(dynticks_progress_counter, cpu)++;
+		rdssp->dynticks++;
 		/*
 		 * The following memory barrier ensures that any
 		 * rcu_read_lock() primitives in the irq handler
 		 * are seen by other CPUs to follow the above
-		 * increment to dynticks_progress_counter. This is
+		 * increment to rcu_dyntick_sched.dynticks. This is
 		 * required in order for other CPUs to correctly
 		 * determine when it is safe to advance the RCU
 		 * grace-period state machine.
@@ -472,7 +497,7 @@ void rcu_irq_enter(void)
 		smp_mb(); /* see above block comment. */
 		/*
 		 * Since we can't determine the dynamic tick mode from
-		 * the dynticks_progress_counter after this routine,
+		 * the rcu_dyntick_sched.dynticks after this routine,
 		 * we use a second flag to acknowledge that we came
 		 * from an idle state with ticks stopped.
 		 */
@@ -480,7 +505,7 @@ void rcu_irq_enter(void)
 		/*
 		 * If we take an NMI/SMI now, they will also increment
 		 * the rcu_update_flag, and will not update the
-		 * dynticks_progress_counter on exit. That is for
+		 * rcu_dyntick_sched.dynticks on exit. That is for
 		 * this IRQ to do.
 		 */
 	}
@@ -490,12 +515,13 @@ void rcu_irq_enter(void)
  * rcu_irq_exit - Called from exiting Hard irq context.
  *
  * If the CPU was idle with dynamic ticks active, update the
- * dynticks_progress_counter to put let the RCU handling be
+ * rcu_dyntick_sched.dynticks to put let the RCU handling be
  * aware that the CPU is going back to idle with no ticks.
  */
 void rcu_irq_exit(void)
 {
 	int cpu = smp_processor_id();
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
 
 	/*
 	 * rcu_update_flag is set if we interrupted the CPU
@@ -503,7 +529,7 @@ void rcu_irq_exit(void)
 	 * Once this occurs, we keep track of interrupt nesting
 	 * because a NMI/SMI could also come in, and we still
 	 * only want the IRQ that started the increment of the
-	 * dynticks_progress_counter to be the one that modifies
+	 * rcu_dyntick_sched.dynticks to be the one that modifies
 	 * it on exit.
 	 */
 	if (per_cpu(rcu_update_flag, cpu)) {
@@ -515,28 +541,29 @@ void rcu_irq_exit(void)
 
 		/*
 		 * If an NMI/SMI happens now we are still
-		 * protected by the dynticks_progress_counter being odd.
+		 * protected by the rcu_dyntick_sched.dynticks being odd.
 		 */
 
 		/*
 		 * The following memory barrier ensures that any
 		 * rcu_read_unlock() primitives in the irq handler
 		 * are seen by other CPUs to preceed the following
-		 * increment to dynticks_progress_counter. This
+		 * increment to rcu_dyntick_sched.dynticks. This
 		 * is required in order for other CPUs to determine
 		 * when it is safe to advance the RCU grace-period
 		 * state machine.
 		 */
 		smp_mb(); /* see above block comment. */
-		per_cpu(dynticks_progress_counter, cpu)++;
-		WARN_ON(per_cpu(dynticks_progress_counter, cpu) & 0x1);
+		rdssp->dynticks++;
+		WARN_ON(rdssp->dynticks & 0x1);
 	}
 }
 
 static void dyntick_save_progress_counter(int cpu)
 {
-	per_cpu(rcu_dyntick_snapshot, cpu) =
-		per_cpu(dynticks_progress_counter, cpu);
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	rdssp->dynticks_snap = rdssp->dynticks;
 }
 
 static inline int
@@ -544,9 +571,10 @@ rcu_try_flip_waitack_needed(int cpu)
 {
 	long curr;
 	long snap;
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
 
-	curr = per_cpu(dynticks_progress_counter, cpu);
-	snap = per_cpu(rcu_dyntick_snapshot, cpu);
+	curr = rdssp->dynticks;
+	snap = rdssp->dynticks_snap;
 	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
 
 	/*
@@ -567,7 +595,7 @@ rcu_try_flip_waitack_needed(int cpu)
 	 * that this CPU already acknowledged the counter.
 	 */
 
-	if ((curr - snap) > 2 || (snap & 0x1) == 0)
+	if ((curr - snap) > 2 || (curr & 0x1) == 0)
 		return 0;
 
 	/* We need this CPU to explicitly acknowledge the counter flip. */
@@ -580,9 +608,10 @@ rcu_try_flip_waitmb_needed(int cpu)
 {
 	long curr;
 	long snap;
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
 
-	curr = per_cpu(dynticks_progress_counter, cpu);
-	snap = per_cpu(rcu_dyntick_snapshot, cpu);
+	curr = rdssp->dynticks;
+	snap = rdssp->dynticks_snap;
 	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
 
 	/*
@@ -609,14 +638,86 @@ rcu_try_flip_waitmb_needed(int cpu)
 	return 1;
 }
 
+static void dyntick_save_progress_counter_sched(int cpu)
+{
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	rdssp->sched_dynticks_snap = rdssp->dynticks;
+}
+
+static int rcu_qsctr_inc_needed_dyntick(int cpu)
+{
+	long curr;
+	long snap;
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	curr = rdssp->dynticks;
+	snap = rdssp->sched_dynticks_snap;
+	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
+
+	/*
+	 * If the CPU remained in dynticks mode for the entire time
+	 * and didn't take any interrupts, NMIs, SMIs, or whatever,
+	 * then it cannot be in the middle of an rcu_read_lock(), so
+	 * the next rcu_read_lock() it executes must use the new value
+	 * of the counter.  Therefore, this CPU has been in a quiescent
+	 * state the entire time, and we don't need to wait for it.
+	 */
+
+	if ((curr == snap) && ((curr & 0x1) == 0))
+		return 0;
+
+	/*
+	 * If the CPU passed through or entered a dynticks idle phase with
+	 * no active irq handlers, then, as above, this CPU has already
+	 * passed through a quiescent state.
+	 */
+
+	if ((curr - snap) > 2 || (snap & 0x1) == 0)
+		return 0;
+
+	/* We need this CPU to go through a quiescent state. */
+
+	return 1;
+}
+
 #else /* !CONFIG_NO_HZ */
 
-# define dyntick_save_progress_counter(cpu)	do { } while (0)
-# define rcu_try_flip_waitack_needed(cpu)	(1)
-# define rcu_try_flip_waitmb_needed(cpu)	(1)
+# define dyntick_save_progress_counter(cpu)		do { } while (0)
+# define rcu_try_flip_waitack_needed(cpu)		(1)
+# define rcu_try_flip_waitmb_needed(cpu)		(1)
+
+# define dyntick_save_progress_counter_sched(cpu)	do { } while (0)
+# define rcu_qsctr_inc_needed_dyntick(cpu)		(1)
 
 #endif /* CONFIG_NO_HZ */
 
+static void save_qsctr_sched(int cpu)
+{
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	rdssp->sched_qs_snap = rdssp->sched_qs;
+}
+
+static inline int rcu_qsctr_inc_needed(int cpu)
+{
+	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
+
+	/*
+	 * If there has been a quiescent state, no more need to wait
+	 * on this CPU.
+	 */
+
+	if (rdssp->sched_qs != rdssp->sched_qs_snap) {
+		smp_mb(); /* force ordering with cpu entering schedule(). */
+		return 0;
+	}
+
+	/* We need this CPU to go through a quiescent state. */
+
+	return 1;
+}
+
 /*
  * Get here when RCU is idle.  Decide whether we need to
  * move out of idle state, and return non-zero if so.
@@ -819,6 +920,26 @@ void rcu_check_callbacks(int cpu, int user)
 	unsigned long flags;
 	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
 
+	/*
+	 * If this CPU took its interrupt from user mode or from the
+	 * idle loop, and this is not a nested interrupt, then
+	 * this CPU has to have exited all prior preept-disable
+	 * sections of code.  So increment the counter to note this.
+	 *
+	 * The memory barrier is needed to handle the case where
+	 * writes from a preempt-disable section of code get reordered
+	 * into schedule() by this CPU's write buffer.  So the memory
+	 * barrier makes sure that the rcu_qsctr_inc() is seen by other
+	 * CPUs to happen after any such write.
+	 */
+
+	if (user ||
+	    (idle_cpu(cpu) && !in_softirq() &&
+	     hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+		smp_mb();	/* Guard against aggressive schedule(). */
+	     	rcu_qsctr_inc(cpu);
+	}
+
 	rcu_check_mb(cpu);
 	if (rcu_ctrlblk.completed == rdp->completed)
 		rcu_try_flip();
@@ -869,6 +990,8 @@ void rcu_offline_cpu(int cpu)
 	struct rcu_head *list = NULL;
 	unsigned long flags;
 	struct rcu_data *rdp = RCU_DATA_CPU(cpu);
+	struct rcu_head *schedlist = NULL;
+	struct rcu_head **schedtail = &schedlist;
 	struct rcu_head **tail = &list;
 
 	/*
@@ -882,6 +1005,11 @@ void rcu_offline_cpu(int cpu)
 		rcu_offline_cpu_enqueue(rdp->waitlist[i], rdp->waittail[i],
 						list, tail);
 	rcu_offline_cpu_enqueue(rdp->nextlist, rdp->nexttail, list, tail);
+	rcu_offline_cpu_enqueue(rdp->waitschedlist, rdp->waitschedtail,
+				schedlist, schedtail);
+	rcu_offline_cpu_enqueue(rdp->nextschedlist, rdp->nextschedtail,
+				schedlist, schedtail);
+	rdp->rcu_sched_sleeping = 0;
 	spin_unlock_irqrestore(&rdp->lock, flags);
 	rdp->waitlistcount = 0;
 
@@ -916,12 +1044,15 @@ void rcu_offline_cpu(int cpu)
 	 * fix.
 	 */
 
-	local_irq_save(flags);
+	local_irq_save(flags);  /* disable preempt till we know what lock. */
 	rdp = RCU_DATA_ME();
 	spin_lock(&rdp->lock);
 	*rdp->nexttail = list;
 	if (list)
 		rdp->nexttail = tail;
+	*rdp->nextschedtail = schedlist;
+	if (schedlist)
+		rdp->nextschedtail = schedtail;
 	spin_unlock_irqrestore(&rdp->lock, flags);
 }
 
@@ -936,10 +1067,25 @@ void rcu_offline_cpu(int cpu)
 void __cpuinit rcu_online_cpu(int cpu)
 {
 	unsigned long flags;
+	struct rcu_data *rdp;
 
 	spin_lock_irqsave(&rcu_ctrlblk.fliplock, flags);
 	cpu_set(cpu, rcu_cpu_online_map);
 	spin_unlock_irqrestore(&rcu_ctrlblk.fliplock, flags);
+
+	/*
+	 * The rcu_sched grace-period processing might have bypassed
+	 * this CPU, given that it was not in the rcu_cpu_online_map
+	 * when the grace-period scan started.  This means that the
+	 * grace-period task might sleep.  So make sure that if this
+	 * should happen, the first callback posted to this CPU will
+	 * wake up the grace-period task if need be.
+	 */
+
+	rdp = RCU_DATA_CPU(cpu);
+	spin_lock_irqsave(&rdp->lock, flags);
+	rdp->rcu_sched_sleeping = 1;
+	spin_unlock_irqrestore(&rdp->lock, flags);
 }
 
 static void rcu_process_callbacks(struct softirq_action *unused)
@@ -982,31 +1128,196 @@ void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
 	*rdp->nexttail = head;
 	rdp->nexttail = &head->next;
 	RCU_TRACE_RDP(rcupreempt_trace_next_add, rdp);
-	spin_unlock(&rdp->lock);
-	local_irq_restore(flags);
+	spin_unlock_irqrestore(&rdp->lock, flags);
 }
 EXPORT_SYMBOL_GPL(call_rcu);
 
+void call_rcu_sched(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	unsigned long flags;
+	struct rcu_data *rdp;
+	int wake_gp = 0;
+
+	head->func = func;
+	head->next = NULL;
+	local_irq_save(flags);
+	rdp = RCU_DATA_ME();
+	spin_lock(&rdp->lock);
+	*rdp->nextschedtail = head;
+	rdp->nextschedtail = &head->next;
+	if (rdp->rcu_sched_sleeping) {
+
+		/* Grace-period processing might be sleeping... */
+
+		rdp->rcu_sched_sleeping = 0;
+		wake_gp = 1;
+	}
+	spin_unlock_irqrestore(&rdp->lock, flags);
+	if (wake_gp) {
+
+		/* Wake up grace-period processing, unless someone beat us. */
+
+		spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
+		if (rcu_ctrlblk.sched_sleep != rcu_sched_sleeping)
+			wake_gp = 0;
+		rcu_ctrlblk.sched_sleep = rcu_sched_not_sleeping;
+		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
+		if (wake_gp)
+			wake_up_interruptible(&rcu_ctrlblk.sched_wq);
+	}
+}
+EXPORT_SYMBOL_GPL(call_rcu_sched);
+
 /*
  * Wait until all currently running preempt_disable() code segments
  * (including hardware-irq-disable segments) complete.  Note that
  * in -rt this does -not- necessarily result in all currently executing
  * interrupt -handlers- having completed.
  */
-void __synchronize_sched(void)
+synchronize_rcu_xxx(__synchronize_sched, call_rcu_sched)
+EXPORT_SYMBOL_GPL(__synchronize_sched);
+
+/*
+ * kthread function that manages call_rcu_sched grace periods.
+ */
+static int rcu_sched_grace_period(void *arg)
 {
-	cpumask_t oldmask;
+	int couldsleep;		/* might sleep after current pass. */
+	int couldsleepnext = 0; /* might sleep after next pass. */
 	int cpu;
+	unsigned long flags;
+	struct rcu_data *rdp;
+	int ret;
 
-	if (sched_getaffinity(0, &oldmask) < 0)
-		oldmask = cpu_possible_map;
-	for_each_online_cpu(cpu) {
-		sched_setaffinity(0, &cpumask_of_cpu(cpu));
-		schedule();
-	}
-	sched_setaffinity(0, &oldmask);
+	/*
+	 * Each pass through the following loop handles one
+	 * rcu_sched grace period cycle.
+	 */
+	do {
+		/* Save each CPU's current state. */
+
+		for_each_online_cpu(cpu) {
+			dyntick_save_progress_counter_sched(cpu);
+			save_qsctr_sched(cpu);
+		}
+
+		/*
+		 * Sleep for about an RCU grace-period's worth to
+		 * allow better batching and to consume less CPU.
+		 */
+		schedule_timeout_interruptible(RCU_SCHED_BATCH_TIME);
+
+		/*
+		 * If there was nothing to do last time, prepare to
+		 * sleep at the end of the current grace period cycle.
+		 */
+		couldsleep = couldsleepnext;
+		couldsleepnext = 1;
+		if (couldsleep) {
+			spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
+			rcu_ctrlblk.sched_sleep = rcu_sched_sleep_prep;
+			spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
+		}
+
+		/*
+		 * Wait on each CPU in turn to have either visited
+		 * a quiescent state or been in dynticks-idle mode.
+		 */
+		for_each_online_cpu(cpu) {
+			while (rcu_qsctr_inc_needed(cpu) &&
+			       rcu_qsctr_inc_needed_dyntick(cpu)) {
+				/* resched_cpu(cpu); @@@ */
+				schedule_timeout_interruptible(1);
+			}
+		}
+
+		/* Advance callbacks for each CPU.  */
+
+		for_each_online_cpu(cpu) {
+
+			rdp = RCU_DATA_CPU(cpu);
+			spin_lock_irqsave(&rdp->lock, flags);
+
+			/*
+			 * We are running on this CPU irq-disabled, so no
+			 * CPU can go offline until we re-enable irqs.
+			 * The current CPU might have already gone
+			 * offline (between the for_each_offline_cpu and
+			 * the spin_lock_irqsave), but in that case all its
+			 * callback lists will be empty, so no harm done.
+			 *
+			 * Advance the callbacks!  We share normal RCU's
+			 * donelist, since callbacks are invoked the
+			 * same way in either case.
+			 */
+			if (rdp->waitschedlist != NULL) {
+				*rdp->donetail = rdp->waitschedlist;
+				rdp->donetail = rdp->waitschedtail;
+
+				/*
+				 * Next rcu_check_callbacks() will
+				 * do the required raise_softirq().
+				 */
+			}
+			if (rdp->nextschedlist != NULL) {
+				rdp->waitschedlist = rdp->nextschedlist;
+				rdp->waitschedtail = rdp->nextschedtail;
+				couldsleep = 0;
+				couldsleepnext = 0;
+			} else {
+				rdp->waitschedlist = NULL;
+				rdp->waitschedtail = &rdp->waitschedlist;
+			}
+			rdp->nextschedlist = NULL;
+			rdp->nextschedtail = &rdp->nextschedlist;
+
+			/* Mark sleep intention. */
+
+			rdp->rcu_sched_sleeping = couldsleep;
+
+			spin_unlock_irqrestore(&rdp->lock, flags);
+		}
+
+		/* If we saw callbacks on the last scan, go deal with them. */
+
+		if (!couldsleep)
+			continue;
+
+		/* Attempt to block... */
+
+		spin_lock_irqsave(&rcu_ctrlblk.schedlock, flags);
+		if (rcu_ctrlblk.sched_sleep != rcu_sched_sleep_prep) {
+
+			/*
+			 * Someone posted a callback after we scanned.
+			 * Go take care of it.
+			 */
+			spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
+			couldsleepnext = 0;
+			continue;
+		}
+
+		/* Block until the next person posts a callback. */
+
+		rcu_ctrlblk.sched_sleep = rcu_sched_sleeping;
+		spin_unlock_irqrestore(&rcu_ctrlblk.schedlock, flags);
+		ret = 0;
+		__wait_event_interruptible(rcu_ctrlblk.sched_wq,
+			rcu_ctrlblk.sched_sleep != rcu_sched_sleeping,
+			ret);
+
+		/*
+		 * Signals would prevent us from sleeping, and we cannot
+		 * do much with them in any case.  So flush them.
+		 */
+		if (ret)
+			flush_signals(current);
+		couldsleepnext = 0;
+
+	} while (!kthread_should_stop());
+
+	return (0);
 }
-EXPORT_SYMBOL_GPL(__synchronize_sched);
 
 /*
  * Check to see if any future RCU-related work will need to be done
@@ -1023,7 +1334,9 @@ int rcu_needs_cpu(int cpu)
 
 	return (rdp->donelist != NULL ||
 		!!rdp->waitlistcount ||
-		rdp->nextlist != NULL);
+		rdp->nextlist != NULL ||
+		rdp->nextschedlist != NULL ||
+		rdp->waitschedlist != NULL);
 }
 
 int rcu_pending(int cpu)
@@ -1034,7 +1347,9 @@ int rcu_pending(int cpu)
 
 	if (rdp->donelist != NULL ||
 	    !!rdp->waitlistcount ||
-	    rdp->nextlist != NULL)
+	    rdp->nextlist != NULL ||
+	    rdp->nextschedlist != NULL ||
+	    rdp->waitschedlist != NULL)
 		return 1;
 
 	/* The RCU core needs an acknowledgement from this CPU. */
@@ -1101,6 +1416,11 @@ void __init __rcu_init(void)
 		rdp->donetail = &rdp->donelist;
 		rdp->rcu_flipctr[0] = 0;
 		rdp->rcu_flipctr[1] = 0;
+		rdp->nextschedlist = NULL;
+		rdp->nextschedtail = &rdp->nextschedlist;
+		rdp->waitschedlist = NULL;
+		rdp->waitschedtail = &rdp->waitschedlist;
+		rdp->rcu_sched_sleeping = 0;
 	}
 	register_cpu_notifier(&rcu_nb);
 
@@ -1123,11 +1443,15 @@ void __init __rcu_init(void)
 }
 
 /*
- * Deprecated, use synchronize_rcu() or synchronize_sched() instead.
+ * Late-boot-time RCU initialization that must wait until after scheduler
+ * has been initialized.
  */
-void synchronize_kernel(void)
+void __init rcu_init_sched(void)
 {
-	synchronize_rcu();
+	rcu_sched_grace_period_task = kthread_run(rcu_sched_grace_period,
+						  NULL,
+						  "rcu_sched_grace_period");
+	WARN_ON(IS_ERR(rcu_sched_grace_period_task));
 }
 
 #ifdef CONFIG_RCU_TRACE
diff --git a/kernel/rcupreempt_trace.c b/kernel/rcupreempt_trace.c
index 49ac494..5edf82c 100644
--- a/kernel/rcupreempt_trace.c
+++ b/kernel/rcupreempt_trace.c
@@ -38,7 +38,6 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
-#include <linux/rcupdate.h>
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/rcupreempt_trace.h>
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 33acc42..90b5b12 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -57,7 +57,9 @@ static int stat_interval;	/* Interval between stats, in seconds. */
 				/*  Defaults to "only at end of test". */
 static int verbose;		/* Print more debug info. */
 static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
-static int shuffle_interval = 5; /* Interval between shuffles (in sec)*/
+static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
+static int stutter = 5;		/* Start/stop testing interval (in sec) */
+static int irqreader = 1;	/* RCU readers from irq (timers). */
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
 
 module_param(nreaders, int, 0444);
@@ -72,6 +74,10 @@ module_param(test_no_idle_hz, bool, 0444);
 MODULE_PARM_DESC(test_no_idle_hz, "Test support for tickless idle CPUs");
 module_param(shuffle_interval, int, 0444);
 MODULE_PARM_DESC(shuffle_interval, "Number of seconds between shuffles");
+module_param(stutter, int, 0444);
+MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
+module_param(irqreader, int, 0444);
+MODULE_PARM_DESC(irqreader, "Allow RCU readers from irq handlers");
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
@@ -91,6 +97,7 @@ static struct task_struct **fakewriter_tasks;
 static struct task_struct **reader_tasks;
 static struct task_struct *stats_task;
 static struct task_struct *shuffler_task;
+static struct task_struct *stutter_task;
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -117,8 +124,18 @@ static atomic_t n_rcu_torture_alloc_fail;
 static atomic_t n_rcu_torture_free;
 static atomic_t n_rcu_torture_mberror;
 static atomic_t n_rcu_torture_error;
+static long n_rcu_torture_timers = 0;
 static struct list_head rcu_torture_removed;
 
+static int stutter_pause_test = 0;
+
+#if defined(MODULE) || defined(CONFIG_RCU_TORTURE_TEST_RUNNABLE)
+#define RCUTORTURE_RUNNABLE_INIT 1
+#else
+#define RCUTORTURE_RUNNABLE_INIT 0
+#endif
+int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
+
 /*
  * Allocate an element from the rcu_tortures pool.
  */
@@ -179,6 +196,16 @@ rcu_random(struct rcu_random_state *rrsp)
 	return swahw32(rrsp->rrs_state);
 }
 
+static void
+rcu_stutter_wait(void)
+{
+	while (stutter_pause_test || !rcutorture_runnable)
+		if (rcutorture_runnable)
+			schedule_timeout_interruptible(1);
+		else
+			schedule_timeout_interruptible(round_jiffies_relative(HZ));
+}
+
 /*
  * Operations vector for selecting different types of tests.
  */
@@ -192,7 +219,9 @@ struct rcu_torture_ops {
 	int (*completed)(void);
 	void (*deferredfree)(struct rcu_torture *p);
 	void (*sync)(void);
+	void (*cb_barrier)(void);
 	int (*stats)(char *page);
+	int irqcapable;
 	char *name;
 };
 static struct rcu_torture_ops *cur_ops = NULL;
@@ -265,7 +294,9 @@ static struct rcu_torture_ops rcu_ops = {
 	.completed = rcu_torture_completed,
 	.deferredfree = rcu_torture_deferred_free,
 	.sync = synchronize_rcu,
+	.cb_barrier = rcu_barrier,
 	.stats = NULL,
+	.irqcapable = 1,
 	.name = "rcu"
 };
 
@@ -304,7 +335,9 @@ static struct rcu_torture_ops rcu_sync_ops = {
 	.completed = rcu_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = synchronize_rcu,
+	.cb_barrier = NULL,
 	.stats = NULL,
+	.irqcapable = 1,
 	.name = "rcu_sync"
 };
 
@@ -364,7 +397,9 @@ static struct rcu_torture_ops rcu_bh_ops = {
 	.completed = rcu_bh_torture_completed,
 	.deferredfree = rcu_bh_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
+	.cb_barrier = rcu_barrier_bh,
 	.stats = NULL,
+	.irqcapable = 1,
 	.name = "rcu_bh"
 };
 
@@ -377,7 +412,9 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.completed = rcu_bh_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = rcu_bh_torture_synchronize,
+	.cb_barrier = NULL,
 	.stats = NULL,
+	.irqcapable = 1,
 	.name = "rcu_bh_sync"
 };
 
@@ -458,6 +495,7 @@ static struct rcu_torture_ops srcu_ops = {
 	.completed = srcu_torture_completed,
 	.deferredfree = rcu_sync_torture_deferred_free,
 	.sync = srcu_torture_synchronize,
+	.cb_barrier = NULL,
 	.stats = srcu_torture_stats,
 	.name = "srcu"
 };
@@ -482,6 +520,11 @@ static int sched_torture_completed(void)
 	return 0;
 }
 
+static void rcu_sched_torture_deferred_free(struct rcu_torture *p)
+{
+	call_rcu_sched(&p->rtort_rcu, rcu_torture_cb);
+}
+
 static void sched_torture_synchronize(void)
 {
 	synchronize_sched();
@@ -494,12 +537,28 @@ static struct rcu_torture_ops sched_ops = {
 	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
 	.readunlock = sched_torture_read_unlock,
 	.completed = sched_torture_completed,
-	.deferredfree = rcu_sync_torture_deferred_free,
+	.deferredfree = rcu_sched_torture_deferred_free,
 	.sync = sched_torture_synchronize,
+	.cb_barrier = rcu_barrier_sched,
 	.stats = NULL,
+	.irqcapable = 1,
 	.name = "sched"
 };
 
+static struct rcu_torture_ops sched_ops_sync = {
+	.init = rcu_sync_torture_init,
+	.cleanup = NULL,
+	.readlock = sched_torture_read_lock,
+	.readdelay = rcu_read_delay,  /* just reuse rcu's version. */
+	.readunlock = sched_torture_read_unlock,
+	.completed = sched_torture_completed,
+	.deferredfree = rcu_sync_torture_deferred_free,
+	.sync = sched_torture_synchronize,
+	.cb_barrier = NULL,
+	.stats = NULL,
+	.name = "sched_sync"
+};
+
 /*
  * RCU torture writer kthread.  Repeatedly substitutes a new structure
  * for that pointed to by rcu_torture_current, freeing the old structure
@@ -537,6 +596,7 @@ rcu_torture_writer(void *arg)
 		}
 		rcu_torture_current_version++;
 		oldbatch = cur_ops->completed();
+		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
 	while (!kthread_should_stop())
@@ -560,6 +620,7 @@ rcu_torture_fakewriter(void *arg)
 		schedule_timeout_uninterruptible(1 + rcu_random(&rand)%10);
 		udelay(rcu_random(&rand) & 0x3ff);
 		cur_ops->sync();
+		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
@@ -569,6 +630,52 @@ rcu_torture_fakewriter(void *arg)
 }
 
 /*
+ * RCU torture reader from timer handler.  Dereferences rcu_torture_current,
+ * incrementing the corresponding element of the pipeline array.  The
+ * counter in the element should never be greater than 1, otherwise, the
+ * RCU implementation is broken.
+ */
+static void rcu_torture_timer(unsigned long unused)
+{
+	int idx;
+	int completed;
+	static DEFINE_RCU_RANDOM(rand);
+	static DEFINE_SPINLOCK(rand_lock);
+	struct rcu_torture *p;
+	int pipe_count;
+
+	idx = cur_ops->readlock();
+	completed = cur_ops->completed();
+	p = rcu_dereference(rcu_torture_current);
+	if (p == NULL) {
+		/* Leave because rcu_torture_writer is not yet underway */
+		cur_ops->readunlock(idx);
+		return;
+	}
+	if (p->rtort_mbtest == 0)
+		atomic_inc(&n_rcu_torture_mberror);
+	spin_lock(&rand_lock);
+	cur_ops->readdelay(&rand);
+	n_rcu_torture_timers++;
+	spin_unlock(&rand_lock);
+	preempt_disable();
+	pipe_count = p->rtort_pipe_count;
+	if (pipe_count > RCU_TORTURE_PIPE_LEN) {
+		/* Should not happen, but... */
+		pipe_count = RCU_TORTURE_PIPE_LEN;
+	}
+	++__get_cpu_var(rcu_torture_count)[pipe_count];
+	completed = cur_ops->completed() - completed;
+	if (completed > RCU_TORTURE_PIPE_LEN) {
+		/* Should not happen, but... */
+		completed = RCU_TORTURE_PIPE_LEN;
+	}
+	++__get_cpu_var(rcu_torture_batch)[completed];
+	preempt_enable();
+	cur_ops->readunlock(idx);
+}
+
+/*
  * RCU torture reader kthread.  Repeatedly dereferences rcu_torture_current,
  * incrementing the corresponding element of the pipeline array.  The
  * counter in the element should never be greater than 1, otherwise, the
@@ -582,11 +689,18 @@ rcu_torture_reader(void *arg)
 	DEFINE_RCU_RANDOM(rand);
 	struct rcu_torture *p;
 	int pipe_count;
+	struct timer_list t;
 
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task started");
 	set_user_nice(current, 19);
+	if (irqreader && cur_ops->irqcapable)
+		setup_timer_on_stack(&t, rcu_torture_timer, 0);
 
 	do {
+		if (irqreader && cur_ops->irqcapable) {
+			if (!timer_pending(&t))
+				mod_timer(&t, 1);
+		}
 		idx = cur_ops->readlock();
 		completed = cur_ops->completed();
 		p = rcu_dereference(rcu_torture_current);
@@ -615,8 +729,11 @@ rcu_torture_reader(void *arg)
 		preempt_enable();
 		cur_ops->readunlock(idx);
 		schedule();
+		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
+	if (irqreader && cur_ops->irqcapable)
+		del_timer_sync(&t);
 	while (!kthread_should_stop())
 		schedule_timeout_uninterruptible(1);
 	return 0;
@@ -647,20 +764,22 @@ rcu_torture_printk(char *page)
 	cnt += sprintf(&page[cnt], "%s%s ", torture_type, TORTURE_FLAG);
 	cnt += sprintf(&page[cnt],
 		       "rtc: %p ver: %ld tfle: %d rta: %d rtaf: %d rtf: %d "
-		       "rtmbe: %d",
+		       "rtmbe: %d nt: %ld",
 		       rcu_torture_current,
 		       rcu_torture_current_version,
 		       list_empty(&rcu_torture_freelist),
 		       atomic_read(&n_rcu_torture_alloc),
 		       atomic_read(&n_rcu_torture_alloc_fail),
 		       atomic_read(&n_rcu_torture_free),
-		       atomic_read(&n_rcu_torture_mberror));
+		       atomic_read(&n_rcu_torture_mberror),
+		       n_rcu_torture_timers);
 	if (atomic_read(&n_rcu_torture_mberror) != 0)
 		cnt += sprintf(&page[cnt], " !!!");
 	cnt += sprintf(&page[cnt], "\n%s%s ", torture_type, TORTURE_FLAG);
 	if (i > 1) {
 		cnt += sprintf(&page[cnt], "!!! ");
 		atomic_inc(&n_rcu_torture_error);
+		WARN_ON_ONCE(1);
 	}
 	cnt += sprintf(&page[cnt], "Reader Pipe: ");
 	for (i = 0; i < RCU_TORTURE_PIPE_LEN + 1; i++)
@@ -785,15 +904,34 @@ rcu_torture_shuffle(void *arg)
 	return 0;
 }
 
+/* Cause the rcutorture test to "stutter", starting and stopping all
+ * threads periodically.
+ */
+static int
+rcu_torture_stutter(void *arg)
+{
+	VERBOSE_PRINTK_STRING("rcu_torture_stutter task started");
+	do {
+		schedule_timeout_interruptible(stutter * HZ);
+		stutter_pause_test = 1;
+		if (!kthread_should_stop())
+			schedule_timeout_interruptible(stutter * HZ);
+		stutter_pause_test = 0;
+	} while (!kthread_should_stop());
+	VERBOSE_PRINTK_STRING("rcu_torture_stutter task stopping");
+	return 0;
+}
+
 static inline void
 rcu_torture_print_module_parms(char *tag)
 {
 	printk(KERN_ALERT "%s" TORTURE_FLAG
 		"--- %s: nreaders=%d nfakewriters=%d "
 		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
-		"shuffle_interval = %d\n",
+		"shuffle_interval=%d stutter=%d irqreader=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
-		stat_interval, verbose, test_no_idle_hz, shuffle_interval);
+		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
+		stutter, irqreader);
 }
 
 static void
@@ -802,6 +940,11 @@ rcu_torture_cleanup(void)
 	int i;
 
 	fullstop = 1;
+	if (stutter_task) {
+		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
+		kthread_stop(stutter_task);
+	}
+	stutter_task = NULL;
 	if (shuffler_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_shuffle task");
 		kthread_stop(shuffler_task);
@@ -848,7 +991,9 @@ rcu_torture_cleanup(void)
 	stats_task = NULL;
 
 	/* Wait for all RCU callbacks to fire.  */
-	rcu_barrier();
+
+	if (cur_ops->cb_barrier != NULL)
+		cur_ops->cb_barrier();
 
 	rcu_torture_stats_print();  /* -After- the stats thread is stopped! */
 
@@ -868,7 +1013,7 @@ rcu_torture_init(void)
 	int firsterr = 0;
 	static struct rcu_torture_ops *torture_ops[] =
 		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
-		  &srcu_ops, &sched_ops, };
+		  &srcu_ops, &sched_ops, &sched_ops_sync, };
 
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
@@ -988,6 +1133,19 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	if (stutter < 0)
+		stutter = 0;
+	if (stutter) {
+		/* Create the stutter thread */
+		stutter_task = kthread_run(rcu_torture_stutter, NULL,
+					  "rcu_torture_stutter");
+		if (IS_ERR(stutter_task)) {
+			firsterr = PTR_ERR(stutter_task);
+			VERBOSE_PRINTK_ERRSTRING("Failed to create stutter");
+			stutter_task = NULL;
+			goto unwind;
+		}
+	}
 	return 0;
 
 unwind:
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index dfb6822..ea9c3f7 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -84,6 +84,9 @@ extern int maps_protect;
 extern int sysctl_stat_interval;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
+#ifdef CONFIG_RCU_TORTURE_TEST
+extern int rcutorture_runnable;
+#endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
 
 /* Constants used for minimum and  maximum */
 #if defined(CONFIG_DETECT_SOFTLOCKUP) || defined(CONFIG_HIGHMEM)
@@ -1171,6 +1174,16 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one,
 	},
 #endif
+#ifdef CONFIG_RCU_TORTURE_TEST
+	{
+		.ctl_name       = CTL_UNNUMBERED,
+		.procname       = "rcutorture_runnable",
+		.data           = &rcutorture_runnable,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+#endif
 /*
  * NOTE: do not add new entries to this table unless you have read
  * Documentation/sysctl/ctl_unnumbered.txt
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index d8b6279..d2f6e3f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -531,16 +531,34 @@ config BOOT_PRINTK_DELAY
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
-	depends on m
 	default n
 	help
 	  This option provides a kernel module that runs torture tests
 	  on the RCU infrastructure.  The kernel module may be built
 	  after the fact on the running kernel to be tested, if desired.
 
+	  Say Y here if you want RCU torture tests to be built into
+	  the kernel.
 	  Say M if you want the RCU torture tests to build as a module.
 	  Say N if you are unsure.
 
+config RCU_TORTURE_TEST_RUNNABLE
+	bool "torture tests for RCU runnable by default"
+	depends on RCU_TORTURE_TEST = y
+	default n
+	help
+	  This option provides a way to build the RCU torture tests
+	  directly into the kernel without them starting up at boot
+	  time.  You can use /proc/sys/kernel/rcutorture_runnable
+	  to manually override this setting.  This /proc file is
+	  available only when the RCU torture tests have been built
+	  into the kernel.
+
+	  Say Y here if you want the RCU torture tests to start during
+	  boot (you probably don't).
+	  Say N here if you want the RCU torture tests to start only
+	  after being manually enabled via /proc.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
diff --git a/lib/textsearch.c b/lib/textsearch.c
index be8bda3..a3e500a 100644
--- a/lib/textsearch.c
+++ b/lib/textsearch.c
@@ -97,6 +97,7 @@
 #include <linux/types.h>
 #include <linux/string.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <linux/rcupdate.h>
 #include <linux/err.h>
 #include <linux/textsearch.h>
diff --git a/net/802/psnap.c b/net/802/psnap.c
index 31128cb..ea46439 100644
--- a/net/802/psnap.c
+++ b/net/802/psnap.c
@@ -20,6 +20,7 @@
 #include <linux/mm.h>
 #include <linux/in.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 
 static LIST_HEAD(snap_list);
 static DEFINE_SPINLOCK(snap_lock);
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index ab2225d..08f14f6 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -27,6 +27,7 @@
 #include <linux/mm.h>
 #include <linux/in.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <net/p8022.h>
 #include <net/arp.h>
 #include <linux/rtnetlink.h>
diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index 72c5976..142060f 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -15,6 +15,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/rculist.h>
 #include <linux/spinlock.h>
 #include <linux/times.h>
 #include <linux/netdevice.h>
diff --git a/net/bridge/br_stp.c b/net/bridge/br_stp.c
index e38034a..9e96ffc 100644
--- a/net/bridge/br_stp.c
+++ b/net/bridge/br_stp.c
@@ -13,6 +13,7 @@
  *	2 of the License, or (at your option) any later version.
  */
 #include <linux/kernel.h>
+#include <linux/rculist.h>
 
 #include "br_private.h"
 #include "br_private_stp.h"
diff --git a/net/netfilter/nf_conntrack_helper.c b/net/netfilter/nf_conntrack_helper.c
index 7d1b117..8e0b4c8 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -20,6 +20,7 @@
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/rculist.h>
 
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 0edefcf..077bcd2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
+#include <linux/rculist.h>
 #include <linux/types.h>
 #include <linux/timer.h>
 #include <linux/skbuff.h>
diff --git a/net/netlabel/netlabel_domainhash.c b/net/netlabel/netlabel_domainhash.c
index 02c2f7c..643c032 100644
--- a/net/netlabel/netlabel_domainhash.c
+++ b/net/netlabel/netlabel_domainhash.c
@@ -30,8 +30,7 @@
  */
 
 #include <linux/types.h>
-#include <linux/rcupdate.h>
-#include <linux/list.h>
+#include <linux/rculist.h>
 #include <linux/skbuff.h>
 #include <linux/spinlock.h>
 #include <linux/string.h>
