Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968354Ab0B0NsM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 08:48:12 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:51849 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968320Ab0B0NsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:48:03 -0500
Date: Sat, 27 Feb 2010 14:47:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] RCU changes for v2.6.34
Message-ID: <20100227134725.GA4355@elte.hu>
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

Please pull the latest core-rcu-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-rcu-for-linus

Lots of nice changes in this cycle, with two areas standing out:

  - expedited grace periods for energy efficiency (off by default)

  - CONFIG_PROVE_RCU, lockdep based correctness checking (off by default)

We expect CONFIG_PROVE_RCU to trigger and we expect the usual 
new-lockdep-feature curve here too: many initial reports all at once, then 
almost overnight it will go down to zero. So the debug feature is off by 
default and we are on alert to handle any reports quickly ...

The warnings are always one-shot and all previous ones were non-fatal.

 Thanks,

	Ingo

------------------>
Ingo Molnar (1):
      sched, cgroups: Fix module export

Paul E. McKenney (43):
      rcu: Adjust force_quiescent_state() locking, step 1
      rcu: Adjust force_quiescent_state() locking, step 2
      rcu: Prohibit starting new grace periods while forcing quiescent states
      rcu: Eliminate local variable signaled from force_quiescent_state()
      rcu: Eliminate local variable lastcomp from force_quiescent_state()
      rcu: Eliminate second argument of rcu_process_dyntick()
      rcu: Eliminate rcu_process_dyntick() return value
      rcu: Remove leg of force_quiescent_state() switch statement
      rcu: Remove redundant grace-period check
      rcu: Make force_quiescent_state() start grace period if needed
      rcu: Add force_quiescent_state() testing to rcutorture
      rcu: Make MAINTAINERS file match new RCU reality
      rcu: Add debug check for too many rcu_read_unlock()
      rcu: Give different levels of the rcu_node hierarchy distinct lockdep names
      rcu: 1Q2010 update for RCU documentation
      rcu: Fix sparse warnings
      rcu: Introduce lockdep-based checking to RCU read-side primitives
      rcu: Add lockdep-enabled variants of rcu_dereference()
      rcu: Integrate rcu_dereference_check() message into lockdep
      rcu: Disable lockdep checking in RCU list-traversal primitives
      net: Add checking to rcu_dereference() primitives
      sched: Use lockdep-based checking on rcu_dereference()
      sched: Better name for for_each_domain_rd
      vfs: Apply lockdep-based checking to rcu_dereference() uses
      vfs: Abstract rcu_dereference_check for files-fdtable use
      radix-tree: Disable RCU lockdep checking in radix tree
      idr: Apply lockdep-based diagnostics to rcu_dereference() uses
      security: Apply lockdep-based checking to rcu_dereference() uses
      rcu: Documentation update for CONFIG_PROVE_RCU
      rcu: Fix citation of Mathieu's dissertation
      rcu: Accelerate grace period if last non-dynticked CPU
      rcu: Use canonical URL for Mathieu's dissertation
      rcu: Stop overflowing signed integers
      rcu: Convert to raw_spinlocks
      rcu: Fix deadlock in TREE_PREEMPT_RCU CPU stall detection
      rcu: Fix rcutorture mod_timer argument to delay one jiffy
      rcu: Add RCU_CPU_STALL_VERBOSE to dump detailed per-task information
      rcu: Make lockdep_rcu_dereference() message less alarmist
      rcu: Make rcu_read_lock_sched_held() take boot time into account
      rcu: Export rcu_scheduler_active
      rcu: Fix accelerated grace periods for last non-dynticked CPU
      rcu: Make non-RCU_PROVE_LOCKING rcu_read_lock_sched_held() understand boot
      rcu: Fix accelerated GPs for last non-dynticked CPU


 Documentation/RCU/00-INDEX                   |   10 +-
 Documentation/RCU/RTFP.txt                   |   61 ++++++-
 Documentation/RCU/checklist.txt              |  208 ++++++++++++--------
 Documentation/RCU/lockdep.txt                |   67 +++++++
 Documentation/RCU/rcu.txt                    |   48 +-----
 Documentation/RCU/stallwarn.txt              |   58 ++++++
 Documentation/RCU/torture.txt                |   12 ++
 Documentation/RCU/whatisRCU.txt              |   16 +-
 Documentation/filesystems/dentry-locking.txt |    3 +-
 MAINTAINERS                                  |   13 +-
 fs/file.c                                    |    2 +-
 fs/proc/array.c                              |    2 +
 fs/proc/base.c                               |    6 +-
 include/linux/cgroup.h                       |    5 +-
 include/linux/cpumask.h                      |   14 ++
 include/linux/cred.h                         |    2 +-
 include/linux/fdtable.h                      |   11 +-
 include/linux/lockdep.h                      |    4 +
 include/linux/rculist.h                      |   14 +-
 include/linux/rculist_nulls.h                |    4 +-
 include/linux/rcupdate.h                     |  165 ++++++++++++++--
 include/linux/rcutiny.h                      |   16 ++-
 include/linux/rcutree.h                      |    4 +-
 include/linux/rtnetlink.h                    |    3 +
 include/linux/srcu.h                         |   95 +++++++++-
 include/net/addrconf.h                       |    4 +-
 init/Kconfig                                 |   16 ++
 init/main.c                                  |    2 +
 kernel/cgroup.c                              |   15 ++
 kernel/exit.c                                |   14 +-
 kernel/fork.c                                |    1 +
 kernel/lockdep.c                             |   18 ++
 kernel/notifier.c                            |    6 +-
 kernel/pid.c                                 |    2 +-
 kernel/rcupdate.c                            |   29 +++
 kernel/rcutorture.c                          |   94 +++++++++-
 kernel/rcutree.c                             |  268 +++++++++++++-------------
 kernel/rcutree.h                             |   61 ++++---
 kernel/rcutree_plugin.h                      |  229 ++++++++++++++++++++---
 kernel/rcutree_trace.c                       |   14 +-
 kernel/sched.c                               |   11 +-
 kernel/srcu.c                                |   52 ++++--
 lib/Kconfig.debug                            |   26 +++-
 lib/debug_locks.c                            |    1 +
 lib/idr.c                                    |    8 +-
 lib/radix-tree.c                             |   24 ++--
 net/core/dev.c                               |    2 +-
 net/core/filter.c                            |    6 +-
 net/core/rtnetlink.c                         |    8 +
 net/core/sock.c                              |    3 +-
 net/decnet/dn_route.c                        |   14 +-
 net/ipv4/route.c                             |   14 +-
 net/packet/af_packet.c                       |    2 +-
 security/keys/gc.c                           |    3 +-
 security/keys/keyring.c                      |    4 +-
 55 files changed, 1346 insertions(+), 448 deletions(-)
 create mode 100644 Documentation/RCU/lockdep.txt
 create mode 100644 Documentation/RCU/stallwarn.txt

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index 9bb62f7..71b6f50 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -6,16 +6,22 @@ checklist.txt
 	- Review Checklist for RCU Patches
 listRCU.txt
 	- Using RCU to Protect Read-Mostly Linked Lists
+lockdep.txt
+	- RCU and lockdep checking
 NMI-RCU.txt
 	- Using RCU to Protect Dynamic NMI Handlers
+rcubarrier.txt
+	- RCU and Unloadable Modules
+rculist_nulls.txt
+	- RCU list primitives for use with SLAB_DESTROY_BY_RCU
 rcuref.txt
 	- Reference-count design for elements of lists/arrays protected by RCU
 rcu.txt
 	- RCU Concepts
-rcubarrier.txt
-	- Unloading modules that use RCU callbacks
 RTFP.txt
 	- List of RCU papers (bibliography) going back to 1980.
+stallwarn.txt
+	- RCU CPU stall warnings (CONFIG_RCU_CPU_STALL_DETECTOR)
 torture.txt
 	- RCU Torture Test Operation (CONFIG_RCU_TORTURE_TEST)
 trace.txt
diff --git a/Documentation/RCU/RTFP.txt b/Documentation/RCU/RTFP.txt
index d2b8523..5aea459 100644
--- a/Documentation/RCU/RTFP.txt
+++ b/Documentation/RCU/RTFP.txt
@@ -25,10 +25,10 @@ to be referencing the data structure.  However, this mechanism was not
 optimized for modern computer systems, which is not surprising given
 that these overheads were not so expensive in the mid-80s.  Nonetheless,
 passive serialization appears to be the first deferred-destruction
-mechanism to be used in production.  Furthermore, the relevant patent has
-lapsed, so this approach may be used in non-GPL software, if desired.
-(In contrast, use of RCU is permitted only in software licensed under
-GPL.  Sorry!!!)
+mechanism to be used in production.  Furthermore, the relevant patent
+has lapsed, so this approach may be used in non-GPL software, if desired.
+(In contrast, implementation of RCU is permitted only in software licensed
+under either GPL or LGPL.  Sorry!!!)
 
 In 1990, Pugh [Pugh90] noted that explicitly tracking which threads
 were reading a given data structure permitted deferred free to operate
@@ -150,6 +150,18 @@ preemptible RCU [PaulEMcKenney2007PreemptibleRCU], and the three-part
 LWN "What is RCU?" series [PaulEMcKenney2007WhatIsRCUFundamentally,
 PaulEMcKenney2008WhatIsRCUUsage, and PaulEMcKenney2008WhatIsRCUAPI].
 
+2008 saw a journal paper on real-time RCU [DinakarGuniguntala2008IBMSysJ],
+a history of how Linux changed RCU more than RCU changed Linux
+[PaulEMcKenney2008RCUOSR], and a design overview of hierarchical RCU
+[PaulEMcKenney2008HierarchicalRCU].
+
+2009 introduced user-level RCU algorithms [PaulEMcKenney2009MaliciousURCU],
+which Mathieu Desnoyers is now maintaining [MathieuDesnoyers2009URCU]
+[MathieuDesnoyersPhD].  TINY_RCU [PaulEMcKenney2009BloatWatchRCU] made
+its appearance, as did expedited RCU [PaulEMcKenney2009expeditedRCU].
+The problem of resizeable RCU-protected hash tables may now be on a path
+to a solution [JoshTriplett2009RPHash].
+
 Bibtex Entries
 
 @article{Kung80
@@ -730,6 +742,11 @@ Revised:
 "
 }
 
+#
+#	"What is RCU?" LWN series.
+#
+########################################################################
+
 @article{DinakarGuniguntala2008IBMSysJ
 ,author="D. Guniguntala and P. E. McKenney and J. Triplett and J. Walpole"
 ,title="The read-copy-update mechanism for supporting real-time applications on shared-memory multiprocessor systems with {Linux}"
@@ -820,3 +837,39 @@ Revised:
 	Uniprocessor assumptions allow simplified RCU implementation.
 "
 }
+
+@unpublished{PaulEMcKenney2009expeditedRCU
+,Author="Paul E. McKenney"
+,Title="[{PATCH} -tip 0/3] expedited 'big hammer' {RCU} grace periods"
+,month="June"
+,day="25"
+,year="2009"
+,note="Available:
+\url{http://lkml.org/lkml/2009/6/25/306}
+[Viewed August 16, 2009]"
+,annotation="
+	First posting of expedited RCU to be accepted into -tip.
+"
+}
+
+@unpublished{JoshTriplett2009RPHash
+,Author="Josh Triplett"
+,Title="Scalable concurrent hash tables via relativistic programming"
+,month="September"
+,year="2009"
+,note="Linux Plumbers Conference presentation"
+,annotation="
+	RP fun with hash tables.
+"
+}
+
+@phdthesis{MathieuDesnoyersPhD
+, title  = "Low-Impact Operating System Tracing"
+, author = "Mathieu Desnoyers"
+, school = "Ecole Polytechnique de Montr\'{e}al"
+, month  = "December"
+, year   = 2009
+,note="Available:
+\url{http://www.lttng.org/pub/thesis/desnoyers-dissertation-2009-12.pdf}
+[Viewed December 9, 2009]"
+}
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 51525a3..cbc180f 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -8,13 +8,12 @@ would cause.  This list is based on experiences reviewing such patches
 over a rather long period of time, but improvements are always welcome!
 
 0.	Is RCU being applied to a read-mostly situation?  If the data
-	structure is updated more than about 10% of the time, then
-	you should strongly consider some other approach, unless
-	detailed performance measurements show that RCU is nonetheless
-	the right tool for the job.  Yes, you might think of RCU
-	as simply cutting overhead off of the readers and imposing it
-	on the writers.  That is exactly why normal uses of RCU will
-	do much more reading than updating.
+	structure is updated more than about 10% of the time, then you
+	should strongly consider some other approach, unless detailed
+	performance measurements show that RCU is nonetheless the right
+	tool for the job.  Yes, RCU does reduce read-side overhead by
+	increasing write-side overhead, which is exactly why normal uses
+	of RCU will do much more reading than updating.
 
 	Another exception is where performance is not an issue, and RCU
 	provides a simpler implementation.  An example of this situation
@@ -35,13 +34,13 @@ over a rather long period of time, but improvements are always welcome!
 
 	If you choose #b, be prepared to describe how you have handled
 	memory barriers on weakly ordered machines (pretty much all of
-	them -- even x86 allows reads to be reordered), and be prepared
-	to explain why this added complexity is worthwhile.  If you
-	choose #c, be prepared to explain how this single task does not
-	become a major bottleneck on big multiprocessor machines (for
-	example, if the task is updating information relating to itself
-	that other tasks can read, there by definition can be no
-	bottleneck).
+	them -- even x86 allows later loads to be reordered to precede
+	earlier stores), and be prepared to explain why this added
+	complexity is worthwhile.  If you choose #c, be prepared to
+	explain how this single task does not become a major bottleneck on
+	big multiprocessor machines (for example, if the task is updating
+	information relating to itself that other tasks can read, there
+	by definition can be no bottleneck).
 
 2.	Do the RCU read-side critical sections make proper use of
 	rcu_read_lock() and friends?  These primitives are needed
@@ -51,8 +50,10 @@ over a rather long period of time, but improvements are always welcome!
 	actuarial risk of your kernel.
 
 	As a rough rule of thumb, any dereference of an RCU-protected
-	pointer must be covered by rcu_read_lock() or rcu_read_lock_bh()
-	or by the appropriate update-side lock.
+	pointer must be covered by rcu_read_lock(), rcu_read_lock_bh(),
+	rcu_read_lock_sched(), or by the appropriate update-side lock.
+	Disabling of preemption can serve as rcu_read_lock_sched(), but
+	is less readable.
 
 3.	Does the update code tolerate concurrent accesses?
 
@@ -62,25 +63,27 @@ over a rather long period of time, but improvements are always welcome!
 	of ways to handle this concurrency, depending on the situation:
 
 	a.	Use the RCU variants of the list and hlist update
-		primitives to add, remove, and replace elements on an
-		RCU-protected list.  Alternatively, use the RCU-protected
-		trees that have been added to the Linux kernel.
+		primitives to add, remove, and replace elements on
+		an RCU-protected list.	Alternatively, use the other
+		RCU-protected data structures that have been added to
+		the Linux kernel.
 
 		This is almost always the best approach.
 
 	b.	Proceed as in (a) above, but also maintain per-element
 		locks (that are acquired by both readers and writers)
 		that guard per-element state.  Of course, fields that
-		the readers refrain from accessing can be guarded by the
-		update-side lock.
+		the readers refrain from accessing can be guarded by
+		some other lock acquired only by updaters, if desired.
 
 		This works quite well, also.
 
 	c.	Make updates appear atomic to readers.  For example,
-		pointer updates to properly aligned fields will appear
-		atomic, as will individual atomic primitives.  Operations
-		performed under a lock and sequences of multiple atomic
-		primitives will -not- appear to be atomic.
+		pointer updates to properly aligned fields will
+		appear atomic, as will individual atomic primitives.
+		Sequences of perations performed under a lock will -not-
+		appear to be atomic to RCU readers, nor will sequences
+		of multiple atomic primitives.
 
 		This can work, but is starting to get a bit tricky.
 
@@ -98,9 +101,9 @@ over a rather long period of time, but improvements are always welcome!
 		a new structure containing updated values.
 
 4.	Weakly ordered CPUs pose special challenges.  Almost all CPUs
-	are weakly ordered -- even i386 CPUs allow reads to be reordered.
-	RCU code must take all of the following measures to prevent
-	memory-corruption problems:
+	are weakly ordered -- even x86 CPUs allow later loads to be
+	reordered to precede earlier stores.  RCU code must take all of
+	the following measures to prevent memory-corruption problems:
 
 	a.	Readers must maintain proper ordering of their memory
 		accesses.  The rcu_dereference() primitive ensures that
@@ -113,14 +116,25 @@ over a rather long period of time, but improvements are always welcome!
 		The rcu_dereference() primitive is also an excellent
 		documentation aid, letting the person reading the code
 		know exactly which pointers are protected by RCU.
-
-		The rcu_dereference() primitive is used by the various
-		"_rcu()" list-traversal primitives, such as the
-		list_for_each_entry_rcu().  Note that it is perfectly
-		legal (if redundant) for update-side code to use
-		rcu_dereference() and the "_rcu()" list-traversal
-		primitives.  This is particularly useful in code
-		that is common to readers and updaters.
+		Please note that compilers can also reorder code, and
+		they are becoming increasingly aggressive about doing
+		just that.  The rcu_dereference() primitive therefore
+		also prevents destructive compiler optimizations.
+
+		The rcu_dereference() primitive is used by the
+		various "_rcu()" list-traversal primitives, such
+		as the list_for_each_entry_rcu().  Note that it is
+		perfectly legal (if redundant) for update-side code to
+		use rcu_dereference() and the "_rcu()" list-traversal
+		primitives.  This is particularly useful in code that
+		is common to readers and updaters.  However, lockdep
+		will complain if you access rcu_dereference() outside
+		of an RCU read-side critical section.  See lockdep.txt
+		to learn what to do about this.
+
+		Of course, neither rcu_dereference() nor the "_rcu()"
+		list-traversal primitives can substitute for a good
+		concurrency design coordinating among multiple updaters.
 
 	b.	If the list macros are being used, the list_add_tail_rcu()
 		and list_add_rcu() primitives must be used in order
@@ -135,11 +149,14 @@ over a rather long period of time, but improvements are always welcome!
 		readers.  Similarly, if the hlist macros are being used,
 		the hlist_del_rcu() primitive is required.
 
-		The list_replace_rcu() primitive may be used to
-		replace an old structure with a new one in an
-		RCU-protected list.
+		The list_replace_rcu() and hlist_replace_rcu() primitives
+		may be used to replace an old structure with a new one
+		in their respective types of RCU-protected lists.
+
+	d.	Rules similar to (4b) and (4c) apply to the "hlist_nulls"
+		type of RCU-protected linked lists.
 
-	d.	Updates must ensure that initialization of a given
+	e.	Updates must ensure that initialization of a given
 		structure happens before pointers to that structure are
 		publicized.  Use the rcu_assign_pointer() primitive
 		when publicizing a pointer to a structure that can
@@ -151,16 +168,31 @@ over a rather long period of time, but improvements are always welcome!
 	it cannot block.
 
 6.	Since synchronize_rcu() can block, it cannot be called from
-	any sort of irq context.  Ditto for synchronize_sched() and
-	synchronize_srcu().
-
-7.	If the updater uses call_rcu(), then the corresponding readers
-	must use rcu_read_lock() and rcu_read_unlock().  If the updater
-	uses call_rcu_bh(), then the corresponding readers must use
-	rcu_read_lock_bh() and rcu_read_unlock_bh().  If the updater
-	uses call_rcu_sched(), then the corresponding readers must
-	disable preemption.  Mixing things up will result in confusion
-	and broken kernels.
+	any sort of irq context.  The same rule applies for
+	synchronize_rcu_bh(), synchronize_sched(), synchronize_srcu(),
+	synchronize_rcu_expedited(), synchronize_rcu_bh_expedited(),
+	synchronize_sched_expedite(), and synchronize_srcu_expedited().
+
+	The expedited forms of these primitives have the same semantics
+	as the non-expedited forms, but expediting is both expensive
+	and unfriendly to real-time workloads.	Use of the expedited
+	primitives should be restricted to rare configuration-change
+	operations that would not normally be undertaken while a real-time
+	workload is running.
+
+7.	If the updater uses call_rcu() or synchronize_rcu(), then the
+	corresponding readers must use rcu_read_lock() and
+	rcu_read_unlock().  If the updater uses call_rcu_bh() or
+	synchronize_rcu_bh(), then the corresponding readers must
+	use rcu_read_lock_bh() and rcu_read_unlock_bh().  If the
+	updater uses call_rcu_sched() or synchronize_sched(), then
+	the corresponding readers must disable preemption, possibly
+	by calling rcu_read_lock_sched() and rcu_read_unlock_sched().
+	If the updater uses synchronize_srcu(), the the corresponding
+	readers must use srcu_read_lock() and srcu_read_unlock(),
+	and with the same srcu_struct.	The rules for the expedited
+	primitives are the same as for their non-expedited counterparts.
+	Mixing things up will result in confusion and broken kernels.
 
 	One exception to this rule: rcu_read_lock() and rcu_read_unlock()
 	may be substituted for rcu_read_lock_bh() and rcu_read_unlock_bh()
@@ -212,6 +244,8 @@ over a rather long period of time, but improvements are always welcome!
 	e.	Periodically invoke synchronize_rcu(), permitting a limited
 		number of updates per grace period.
 
+	The same cautions apply to call_rcu_bh() and call_rcu_sched().
+
 9.	All RCU list-traversal primitives, which include
 	rcu_dereference(), list_for_each_entry_rcu(),
 	list_for_each_continue_rcu(), and list_for_each_safe_rcu(),
@@ -219,7 +253,9 @@ over a rather long period of time, but improvements are always welcome!
 	must be protected by appropriate update-side locks.  RCU
 	read-side critical sections are delimited by rcu_read_lock()
 	and rcu_read_unlock(), or by similar primitives such as
-	rcu_read_lock_bh() and rcu_read_unlock_bh().
+	rcu_read_lock_bh() and rcu_read_unlock_bh(), in which case
+	the matching rcu_dereference() primitive must be used in order
+	to keep lockdep happy, in this case, rcu_dereference_bh().
 
 	The reason that it is permissible to use RCU list-traversal
 	primitives when the update-side lock is held is that doing so
@@ -229,7 +265,8 @@ over a rather long period of time, but improvements are always welcome!
 10.	Conversely, if you are in an RCU read-side critical section,
 	and you don't hold the appropriate update-side lock, you -must-
 	use the "_rcu()" variants of the list macros.  Failing to do so
-	will break Alpha and confuse people reading your code.
+	will break Alpha, cause aggressive compilers to generate bad code,
+	and confuse people trying to read your code.
 
 11.	Note that synchronize_rcu() -only- guarantees to wait until
 	all currently executing rcu_read_lock()-protected RCU read-side
@@ -239,15 +276,21 @@ over a rather long period of time, but improvements are always welcome!
 	rcu_read_lock()-protected read-side critical sections, do -not-
 	use synchronize_rcu().
 
-	If you want to wait for some of these other things, you might
-	instead need to use synchronize_irq() or synchronize_sched().
+	Similarly, disabling preemption is not an acceptable substitute
+	for rcu_read_lock().  Code that attempts to use preemption
+	disabling where it should be using rcu_read_lock() will break
+	in real-time kernel builds.
+
+	If you want to wait for interrupt handlers, NMI handlers, and
+	code under the influence of preempt_disable(), you instead
+	need to use synchronize_irq() or synchronize_sched().
 
 12.	Any lock acquired by an RCU callback must be acquired elsewhere
 	with softirq disabled, e.g., via spin_lock_irqsave(),
 	spin_lock_bh(), etc.  Failing to disable irq on a given
-	acquisition of that lock will result in deadlock as soon as the
-	RCU callback happens to interrupt that acquisition's critical
-	section.
+	acquisition of that lock will result in deadlock as soon as
+	the RCU softirq handler happens to run your RCU callback while
+	interrupting that acquisition's critical section.
 
 13.	RCU callbacks can be and are executed in parallel.  In many cases,
 	the callback code simply wrappers around kfree(), so that this
@@ -265,29 +308,30 @@ over a rather long period of time, but improvements are always welcome!
 	not the case, a self-spawning RCU callback would prevent the
 	victim CPU from ever going offline.)
 
-14.	SRCU (srcu_read_lock(), srcu_read_unlock(), and synchronize_srcu())
-	may only be invoked from process context.  Unlike other forms of
-	RCU, it -is- permissible to block in an SRCU read-side critical
-	section (demarked by srcu_read_lock() and srcu_read_unlock()),
-	hence the "SRCU": "sleepable RCU".  Please note that if you
-	don't need to sleep in read-side critical sections, you should
-	be using RCU rather than SRCU, because RCU is almost always
-	faster and easier to use than is SRCU.
+14.	SRCU (srcu_read_lock(), srcu_read_unlock(), srcu_dereference(),
+	synchronize_srcu(), and synchronize_srcu_expedited()) may only
+	be invoked from process context.  Unlike other forms of RCU, it
+	-is- permissible to block in an SRCU read-side critical section
+	(demarked by srcu_read_lock() and srcu_read_unlock()), hence the
+	"SRCU": "sleepable RCU".  Please note that if you don't need
+	to sleep in read-side critical sections, you should be using
+	RCU rather than SRCU, because RCU is almost always faster and
+	easier to use than is SRCU.
 
 	Also unlike other forms of RCU, explicit initialization
 	and cleanup is required via init_srcu_struct() and
 	cleanup_srcu_struct().	These are passed a "struct srcu_struct"
 	that defines the scope of a given SRCU domain.	Once initialized,
 	the srcu_struct is passed to srcu_read_lock(), srcu_read_unlock()
-	and synchronize_srcu().  A given synchronize_srcu() waits only
-	for SRCU read-side critical sections governed by srcu_read_lock()
-	and srcu_read_unlock() calls that have been passd the same
-	srcu_struct.  This property is what makes sleeping read-side
-	critical sections tolerable -- a given subsystem delays only
-	its own updates, not those of other subsystems using SRCU.
-	Therefore, SRCU is less prone to OOM the system than RCU would
-	be if RCU's read-side critical sections were permitted to
-	sleep.
+	synchronize_srcu(), and synchronize_srcu_expedited().  A given
+	synchronize_srcu() waits only for SRCU read-side critical
+	sections governed by srcu_read_lock() and srcu_read_unlock()
+	calls that have been passed the same srcu_struct.  This property
+	is what makes sleeping read-side critical sections tolerable --
+	a given subsystem delays only its own updates, not those of other
+	subsystems using SRCU.	Therefore, SRCU is less prone to OOM the
+	system than RCU would be if RCU's read-side critical sections
+	were permitted to sleep.
 
 	The ability to sleep in read-side critical sections does not
 	come for free.	First, corresponding srcu_read_lock() and
@@ -311,12 +355,12 @@ over a rather long period of time, but improvements are always welcome!
 	destructive operation, and -only- -then- invoke call_rcu(),
 	synchronize_rcu(), or friends.
 
-	Because these primitives only wait for pre-existing readers,
-	it is the caller's responsibility to guarantee safety to
-	any subsequent readers.
+	Because these primitives only wait for pre-existing readers, it
+	is the caller's responsibility to guarantee that any subsequent
+	readers will execute safely.
 
-16.	The various RCU read-side primitives do -not- contain memory
-	barriers.  The CPU (and in some cases, the compiler) is free
-	to reorder code into and out of RCU read-side critical sections.
-	It is the responsibility of the RCU update-side primitives to
-	deal with this.
+16.	The various RCU read-side primitives do -not- necessarily contain
+	memory barriers.  You should therefore plan for the CPU
+	and the compiler to freely reorder code into and out of RCU
+	read-side critical sections.  It is the responsibility of the
+	RCU update-side primitives to deal with this.
diff --git a/Documentation/RCU/lockdep.txt b/Documentation/RCU/lockdep.txt
new file mode 100644
index 0000000..fe24b58
--- /dev/null
+++ b/Documentation/RCU/lockdep.txt
@@ -0,0 +1,67 @@
+RCU and lockdep checking
+
+All flavors of RCU have lockdep checking available, so that lockdep is
+aware of when each task enters and leaves any flavor of RCU read-side
+critical section.  Each flavor of RCU is tracked separately (but note
+that this is not the case in 2.6.32 and earlier).  This allows lockdep's
+tracking to include RCU state, which can sometimes help when debugging
+deadlocks and the like.
+
+In addition, RCU provides the following primitives that check lockdep's
+state:
+
+	rcu_read_lock_held() for normal RCU.
+	rcu_read_lock_bh_held() for RCU-bh.
+	rcu_read_lock_sched_held() for RCU-sched.
+	srcu_read_lock_held() for SRCU.
+
+These functions are conservative, and will therefore return 1 if they
+aren't certain (for example, if CONFIG_DEBUG_LOCK_ALLOC is not set).
+This prevents things like WARN_ON(!rcu_read_lock_held()) from giving false
+positives when lockdep is disabled.
+
+In addition, a separate kernel config parameter CONFIG_PROVE_RCU enables
+checking of rcu_dereference() primitives:
+
+	rcu_dereference(p):
+		Check for RCU read-side critical section.
+	rcu_dereference_bh(p):
+		Check for RCU-bh read-side critical section.
+	rcu_dereference_sched(p):
+		Check for RCU-sched read-side critical section.
+	srcu_dereference(p, sp):
+		Check for SRCU read-side critical section.
+	rcu_dereference_check(p, c):
+		Use explicit check expression "c".
+	rcu_dereference_raw(p)
+		Don't check.  (Use sparingly, if at all.)
+
+The rcu_dereference_check() check expression can be any boolean
+expression, but would normally include one of the rcu_read_lock_held()
+family of functions and a lockdep expression.  However, any boolean
+expression can be used.  For a moderately ornate example, consider
+the following:
+
+	file = rcu_dereference_check(fdt->fd[fd],
+				     rcu_read_lock_held() ||
+				     lockdep_is_held(&files->file_lock) ||
+				     atomic_read(&files->count) == 1);
+
+This expression picks up the pointer "fdt->fd[fd]" in an RCU-safe manner,
+and, if CONFIG_PROVE_RCU is configured, verifies that this expression
+is used in:
+
+1.	An RCU read-side critical section, or
+2.	with files->file_lock held, or
+3.	on an unshared files_struct.
+
+In case (1), the pointer is picked up in an RCU-safe manner for vanilla
+RCU read-side critical sections, in case (2) the ->file_lock prevents
+any change from taking place, and finally, in case (3) the current task
+is the only task accessing the file_struct, again preventing any change
+from taking place.
+
+There are currently only "universal" versions of the rcu_assign_pointer()
+and RCU list-/tree-traversal primitives, which do not (yet) check for
+being in an RCU read-side critical section.  In the future, separate
+versions of these primitives might be created.
diff --git a/Documentation/RCU/rcu.txt b/Documentation/RCU/rcu.txt
index 2a23523..3185270 100644
--- a/Documentation/RCU/rcu.txt
+++ b/Documentation/RCU/rcu.txt
@@ -75,6 +75,8 @@ o	I hear that RCU is patented?  What is with that?
 	search for the string "Patent" in RTFP.txt to find them.
 	Of these, one was allowed to lapse by the assignee, and the
 	others have been contributed to the Linux kernel under GPL.
+	There are now also LGPL implementations of user-level RCU
+	available (http://lttng.org/?q=node/18).
 
 o	I hear that RCU needs work in order to support realtime kernels?
 
@@ -91,48 +93,4 @@ o	Where can I find more information on RCU?
 
 o	What are all these files in this directory?
 
-
-	NMI-RCU.txt
-
-		Describes how to use RCU to implement dynamic
-		NMI handlers, which can be revectored on the fly,
-		without rebooting.
-
-	RTFP.txt
-
-		List of RCU-related publications and web sites.
-
-	UP.txt
-
-		Discussion of RCU usage in UP kernels.
-
-	arrayRCU.txt
-
-		Describes how to use RCU to protect arrays, with
-		resizeable arrays whose elements reference other
-		data structures being of the most interest.
-
-	checklist.txt
-
-		Lists things to check for when inspecting code that
-		uses RCU.
-
-	listRCU.txt
-
-		Describes how to use RCU to protect linked lists.
-		This is the simplest and most common use of RCU
-		in the Linux kernel.
-
-	rcu.txt
-
-		You are reading it!
-
-	rcuref.txt
-
-		Describes how to combine use of reference counts
-		with RCU.
-
-	whatisRCU.txt
-
-		Overview of how the RCU implementation works.  Along
-		the way, presents a conceptual view of RCU.
+	See 00-INDEX for the list.
diff --git a/Documentation/RCU/stallwarn.txt b/Documentation/RCU/stallwarn.txt
new file mode 100644
index 0000000..1423d25
--- /dev/null
+++ b/Documentation/RCU/stallwarn.txt
@@ -0,0 +1,58 @@
+Using RCU's CPU Stall Detector
+
+The CONFIG_RCU_CPU_STALL_DETECTOR kernel config parameter enables
+RCU's CPU stall detector, which detects conditions that unduly delay
+RCU grace periods.  The stall detector's idea of what constitutes
+"unduly delayed" is controlled by a pair of C preprocessor macros:
+
+RCU_SECONDS_TILL_STALL_CHECK
+
+	This macro defines the period of time that RCU will wait from
+	the beginning of a grace period until it issues an RCU CPU
+	stall warning.	It is normally ten seconds.
+
+RCU_SECONDS_TILL_STALL_RECHECK
+
+	This macro defines the period of time that RCU will wait after
+	issuing a stall warning until it issues another stall warning.
+	It is normally set to thirty seconds.
+
+RCU_STALL_RAT_DELAY
+
+	The CPU stall detector tries to make the offending CPU rat on itself,
+	as this often gives better-quality stack traces.  However, if
+	the offending CPU does not detect its own stall in the number
+	of jiffies specified by RCU_STALL_RAT_DELAY, then other CPUs will
+	complain.  This is normally set to two jiffies.
+
+The following problems can result in an RCU CPU stall warning:
+
+o	A CPU looping in an RCU read-side critical section.
+	
+o	A CPU looping with interrupts disabled.
+
+o	A CPU looping with preemption disabled.
+
+o	For !CONFIG_PREEMPT kernels, a CPU looping anywhere in the kernel
+	without invoking schedule().
+
+o	A bug in the RCU implementation.
+
+o	A hardware failure.  This is quite unlikely, but has occurred
+	at least once in a former life.  A CPU failed in a running system,
+	becoming unresponsive, but not causing an immediate crash.
+	This resulted in a series of RCU CPU stall warnings, eventually
+	leading the realization that the CPU had failed.
+
+The RCU, RCU-sched, and RCU-bh implementations have CPU stall warning.
+SRCU does not do so directly, but its calls to synchronize_sched() will
+result in RCU-sched detecting any CPU stalls that might be occurring.
+
+To diagnose the cause of the stall, inspect the stack traces.  The offending
+function will usually be near the top of the stack.  If you have a series
+of stall warnings from a single extended stall, comparing the stack traces
+can often help determine where the stall is occurring, which will usually
+be in the function nearest the top of the stack that stays the same from
+trace to trace.
+
+RCU bugs can often be debugged with the help of CONFIG_RCU_TRACE.
diff --git a/Documentation/RCU/torture.txt b/Documentation/RCU/torture.txt
index 9dba3bb..0e50bc2 100644
--- a/Documentation/RCU/torture.txt
+++ b/Documentation/RCU/torture.txt
@@ -30,6 +30,18 @@ MODULE PARAMETERS
 
 This module has the following parameters:
 
+fqs_duration	Duration (in microseconds) of artificially induced bursts
+		of force_quiescent_state() invocations.  In RCU
+		implementations having force_quiescent_state(), these
+		bursts help force races between forcing a given grace
+		period and that grace period ending on its own.
+
+fqs_holdoff	Holdoff time (in microseconds) between consecutive calls
+		to force_quiescent_state() within a burst.
+
+fqs_stutter	Wait time (in seconds) between consecutive bursts
+		of calls to force_quiescent_state().
+
 irqreaders	Says to invoke RCU readers from irq level.  This is currently
 		done via timers.  Defaults to "1" for variants of RCU that
 		permit this.  (Or, more accurately, variants of RCU that do
diff --git a/Documentation/RCU/whatisRCU.txt b/Documentation/RCU/whatisRCU.txt
index d542ca2..1dc00ee 100644
--- a/Documentation/RCU/whatisRCU.txt
+++ b/Documentation/RCU/whatisRCU.txt
@@ -323,14 +323,17 @@ used as follows:
 	Defer			Protect
 
 a.	synchronize_rcu()	rcu_read_lock() / rcu_read_unlock()
-	call_rcu()
+	call_rcu()		rcu_dereference()
 
 b.	call_rcu_bh()		rcu_read_lock_bh() / rcu_read_unlock_bh()
+				rcu_dereference_bh()
 
-c.	synchronize_sched()	preempt_disable() / preempt_enable()
+c.	synchronize_sched()	rcu_read_lock_sched() / rcu_read_unlock_sched()
+				preempt_disable() / preempt_enable()
 				local_irq_save() / local_irq_restore()
 				hardirq enter / hardirq exit
 				NMI enter / NMI exit
+				rcu_dereference_sched()
 
 These three mechanisms are used as follows:
 
@@ -780,9 +783,8 @@ Linux-kernel source code, but it helps to have a full list of the
 APIs, since there does not appear to be a way to categorize them
 in docbook.  Here is the list, by category.
 
-RCU pointer/list traversal:
+RCU list traversal:
 
-	rcu_dereference
 	list_for_each_entry_rcu
 	hlist_for_each_entry_rcu
 	hlist_nulls_for_each_entry_rcu
@@ -808,7 +810,7 @@ RCU:	Critical sections	Grace period		Barrier
 
 	rcu_read_lock		synchronize_net		rcu_barrier
 	rcu_read_unlock		synchronize_rcu
-				synchronize_rcu_expedited
+	rcu_dereference		synchronize_rcu_expedited
 				call_rcu
 
 
@@ -816,7 +818,7 @@ bh:	Critical sections	Grace period		Barrier
 
 	rcu_read_lock_bh	call_rcu_bh		rcu_barrier_bh
 	rcu_read_unlock_bh	synchronize_rcu_bh
-				synchronize_rcu_bh_expedited
+	rcu_dereference_bh	synchronize_rcu_bh_expedited
 
 
 sched:	Critical sections	Grace period		Barrier
@@ -825,12 +827,14 @@ sched:	Critical sections	Grace period		Barrier
 	rcu_read_unlock_sched	call_rcu_sched
 	[preempt_disable]	synchronize_sched_expedited
 	[and friends]
+	rcu_dereference_sched
 
 
 SRCU:	Critical sections	Grace period		Barrier
 
 	srcu_read_lock		synchronize_srcu	N/A
 	srcu_read_unlock	synchronize_srcu_expedited
+	srcu_dereference
 
 SRCU:	Initialization/cleanup
 	init_srcu_struct
diff --git a/Documentation/filesystems/dentry-locking.txt b/Documentation/filesystems/dentry-locking.txt
index 4c0c575..79334ed 100644
--- a/Documentation/filesystems/dentry-locking.txt
+++ b/Documentation/filesystems/dentry-locking.txt
@@ -62,7 +62,8 @@ changes are :
 2. Insertion of a dentry into the hash table is done using
    hlist_add_head_rcu() which take care of ordering the writes - the
    writes to the dentry must be visible before the dentry is
-   inserted. This works in conjunction with hlist_for_each_rcu() while
+   inserted. This works in conjunction with hlist_for_each_rcu(),
+   which has since been replaced by hlist_for_each_entry_rcu(), while
    walking the hash chain. The only requirement is that all
    initialization to the dentry must be done before
    hlist_add_head_rcu() since we don't have dcache_lock protection
diff --git a/MAINTAINERS b/MAINTAINERS
index 2533fc4..2123f6a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4509,7 +4509,7 @@ F:	drivers/net/wireless/ray*
 RCUTORTURE MODULE
 M:	Josh Triplett <josh@freedesktop.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
-S:	Maintained
+S:	Supported
 F:	Documentation/RCU/torture.txt
 F:	kernel/rcutorture.c
 
@@ -4534,11 +4534,12 @@ M:	Dipankar Sarma <dipankar@in.ibm.com>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 W:	http://www.rdrop.com/users/paulmck/rclock/
 S:	Supported
-F:	Documentation/RCU/rcu.txt
-F:	Documentation/RCU/rcuref.txt
-F:	include/linux/rcupdate.h
-F:	include/linux/srcu.h
-F:	kernel/rcupdate.c
+F:	Documentation/RCU/
+F:	include/linux/rcu*
+F:	include/linux/srcu*
+F:	kernel/rcu*
+F:	kernel/srcu*
+X:	kernel/rcutorture.c
 
 REAL TIME CLOCK DRIVER
 M:	Paul Gortmaker <p_gortmaker@yahoo.com>
diff --git a/fs/file.c b/fs/file.c
index 87e1290..38039af 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -478,7 +478,7 @@ repeat:
 	error = fd;
 #if 1
 	/* Sanity check */
-	if (rcu_dereference(fdt->fd[fd]) != NULL) {
+	if (rcu_dereference_raw(fdt->fd[fd]) != NULL) {
 		printk(KERN_WARNING "alloc_fd: slot %d not NULL!\n", fd);
 		rcu_assign_pointer(fdt->fd[fd], NULL);
 	}
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 13b5d07..18e20fe 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -270,7 +270,9 @@ static inline void task_sig(struct seq_file *m, struct task_struct *p)
 		blocked = p->blocked;
 		collect_sigign_sigcatch(p, &ignored, &caught);
 		num_threads = atomic_read(&p->signal->count);
+		rcu_read_lock();  /* FIXME: is this correct? */
 		qsize = atomic_read(&__task_cred(p)->user->sigpending);
+		rcu_read_unlock();
 		qlim = p->signal->rlim[RLIMIT_SIGPENDING].rlim_cur;
 		unlock_task_sighand(p, &flags);
 	}
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 58324c2..623e2ff 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1095,8 +1095,12 @@ static ssize_t proc_loginuid_write(struct file * file, const char __user * buf,
 	if (!capable(CAP_AUDIT_CONTROL))
 		return -EPERM;
 
-	if (current != pid_task(proc_pid(inode), PIDTYPE_PID))
+	rcu_read_lock();
+	if (current != pid_task(proc_pid(inode), PIDTYPE_PID)) {
+		rcu_read_unlock();
 		return -EPERM;
+	}
+	rcu_read_unlock();
 
 	if (count >= PAGE_SIZE)
 		count = PAGE_SIZE - 1;
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0008dee..c9bbcb2 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -28,6 +28,7 @@ struct css_id;
 extern int cgroup_init_early(void);
 extern int cgroup_init(void);
 extern void cgroup_lock(void);
+extern int cgroup_lock_is_held(void);
 extern bool cgroup_lock_live_group(struct cgroup *cgrp);
 extern void cgroup_unlock(void);
 extern void cgroup_fork(struct task_struct *p);
@@ -486,7 +487,9 @@ static inline struct cgroup_subsys_state *cgroup_subsys_state(
 static inline struct cgroup_subsys_state *task_subsys_state(
 	struct task_struct *task, int subsys_id)
 {
-	return rcu_dereference(task->cgroups->subsys[subsys_id]);
+	return rcu_dereference_check(task->cgroups->subsys[subsys_id],
+				     rcu_read_lock_held() ||
+				     cgroup_lock_is_held());
 }
 
 static inline struct cgroup* task_cgroup(struct task_struct *task,
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index d77b547..dbcee76 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -143,6 +143,8 @@ static inline unsigned int cpumask_any_but(const struct cpumask *mask,
 
 #define for_each_cpu(cpu, mask)			\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
+#define for_each_cpu_not(cpu, mask)		\
+	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
 #define for_each_cpu_and(cpu, mask, and)	\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask, (void)and)
 #else
@@ -203,6 +205,18 @@ int cpumask_any_but(const struct cpumask *mask, unsigned int cpu);
 		(cpu) < nr_cpu_ids;)
 
 /**
+ * for_each_cpu_not - iterate over every cpu in a complemented mask
+ * @cpu: the (optionally unsigned) integer iterator
+ * @mask: the cpumask pointer
+ *
+ * After the loop, cpu is >= nr_cpu_ids.
+ */
+#define for_each_cpu_not(cpu, mask)				\
+	for ((cpu) = -1;					\
+		(cpu) = cpumask_next_zero((cpu), (mask)),	\
+		(cpu) < nr_cpu_ids;)
+
+/**
  * for_each_cpu_and - iterate over every cpu in both masks
  * @cpu: the (optionally unsigned) integer iterator
  * @mask: the first cpumask pointer
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 4e3387a..4db09f8 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -280,7 +280,7 @@ static inline void put_cred(const struct cred *_cred)
  * task or by holding tasklist_lock to prevent it from being unlinked.
  */
 #define __task_cred(task) \
-	((const struct cred *)(rcu_dereference((task)->real_cred)))
+	((const struct cred *)(rcu_dereference_check((task)->real_cred, rcu_read_lock_held() || lockdep_is_held(&tasklist_lock))))
 
 /**
  * get_task_cred - Get another task's objective credentials
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index a2ec74b..013dc52 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -57,7 +57,14 @@ struct files_struct {
 	struct file * fd_array[NR_OPEN_DEFAULT];
 };
 
-#define files_fdtable(files) (rcu_dereference((files)->fdt))
+#define rcu_dereference_check_fdtable(files, fdtfd) \
+	(rcu_dereference_check((fdtfd), \
+			       rcu_read_lock_held() || \
+			       lockdep_is_held(&(files)->file_lock) || \
+			       atomic_read(&(files)->count) == 1))
+
+#define files_fdtable(files) \
+		(rcu_dereference_check_fdtable((files), (files)->fdt))
 
 struct file_operations;
 struct vfsmount;
@@ -78,7 +85,7 @@ static inline struct file * fcheck_files(struct files_struct *files, unsigned in
 	struct fdtable *fdt = files_fdtable(files);
 
 	if (fd < fdt->max_fds)
-		file = rcu_dereference(fdt->fd[fd]);
+		file = rcu_dereference_check_fdtable(files, fdt->fd[fd]);
 	return file;
 }
 
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 9ccf0e2..10206a8 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -534,4 +534,8 @@ do {									\
 # define might_lock_read(lock) do { } while (0)
 #endif
 
+#ifdef CONFIG_PROVE_RCU
+extern void lockdep_rcu_dereference(const char *file, const int line);
+#endif
+
 #endif /* __LINUX_LOCKDEP_H */
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 1bf0f70..779d707 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -208,7 +208,7 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * primitives such as list_add_rcu() as long as it's guarded by rcu_read_lock().
  */
 #define list_entry_rcu(ptr, type, member) \
-	container_of(rcu_dereference(ptr), type, member)
+	container_of(rcu_dereference_raw(ptr), type, member)
 
 /**
  * list_first_entry_rcu - get the first element from a list
@@ -225,9 +225,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
 	list_entry_rcu((ptr)->next, type, member)
 
 #define __list_for_each_rcu(pos, head) \
-	for (pos = rcu_dereference((head)->next); \
+	for (pos = rcu_dereference_raw((head)->next); \
 		pos != (head); \
-		pos = rcu_dereference(pos->next))
+		pos = rcu_dereference_raw(pos->next))
 
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
@@ -257,9 +257,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_continue_rcu(pos, head) \
-	for ((pos) = rcu_dereference((pos)->next); \
+	for ((pos) = rcu_dereference_raw((pos)->next); \
 		prefetch((pos)->next), (pos) != (head); \
-		(pos) = rcu_dereference((pos)->next))
+		(pos) = rcu_dereference_raw((pos)->next))
 
 /**
  * list_for_each_entry_continue_rcu - continue iteration over list of given type
@@ -418,10 +418,10 @@ static inline void hlist_add_after_rcu(struct hlist_node *prev,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define hlist_for_each_entry_rcu(tpos, pos, head, member)		 \
-	for (pos = rcu_dereference((head)->first);			 \
+	for (pos = rcu_dereference_raw((head)->first);			 \
 		pos && ({ prefetch(pos->next); 1; }) &&			 \
 		({ tpos = hlist_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference(pos->next))
+		pos = rcu_dereference_raw(pos->next))
 
 #endif	/* __KERNEL__ */
 #endif
diff --git a/include/linux/rculist_nulls.h b/include/linux/rculist_nulls.h
index 589a409..b70ffe5 100644
--- a/include/linux/rculist_nulls.h
+++ b/include/linux/rculist_nulls.h
@@ -101,10 +101,10 @@ static inline void hlist_nulls_add_head_rcu(struct hlist_nulls_node *n,
  *
  */
 #define hlist_nulls_for_each_entry_rcu(tpos, pos, head, member) \
-	for (pos = rcu_dereference((head)->first);			 \
+	for (pos = rcu_dereference_raw((head)->first);			 \
 		(!is_a_nulls(pos)) &&			\
 		({ tpos = hlist_nulls_entry(pos, typeof(*tpos), member); 1; }); \
-		pos = rcu_dereference(pos->next))
+		pos = rcu_dereference_raw(pos->next))
 
 #endif
 #endif
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 24440f4..c843736 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -62,6 +62,8 @@ extern int sched_expedited_torture_stats(char *page);
 
 /* Internal to kernel */
 extern void rcu_init(void);
+extern int rcu_scheduler_active;
+extern void rcu_scheduler_starting(void);
 
 #if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
 #include <linux/rcutree.h>
@@ -78,14 +80,120 @@ extern void rcu_init(void);
 } while (0)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
+
 extern struct lockdep_map rcu_lock_map;
-# define rcu_read_acquire()	\
-			lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_acquire() \
+		lock_acquire(&rcu_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
 # define rcu_read_release()	lock_release(&rcu_lock_map, 1, _THIS_IP_)
-#else
-# define rcu_read_acquire()	do { } while (0)
-# define rcu_read_release()	do { } while (0)
-#endif
+
+extern struct lockdep_map rcu_bh_lock_map;
+# define rcu_read_acquire_bh() \
+		lock_acquire(&rcu_bh_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_release_bh()	lock_release(&rcu_bh_lock_map, 1, _THIS_IP_)
+
+extern struct lockdep_map rcu_sched_lock_map;
+# define rcu_read_acquire_sched() \
+		lock_acquire(&rcu_sched_lock_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define rcu_read_release_sched() \
+		lock_release(&rcu_sched_lock_map, 1, _THIS_IP_)
+
+/**
+ * rcu_read_lock_held - might we be in RCU read-side critical section?
+ *
+ * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
+ * an RCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * this assumes we are in an RCU read-side critical section unless it can
+ * prove otherwise.
+ */
+static inline int rcu_read_lock_held(void)
+{
+	if (debug_locks)
+		return lock_is_held(&rcu_lock_map);
+	return 1;
+}
+
+/**
+ * rcu_read_lock_bh_held - might we be in RCU-bh read-side critical section?
+ *
+ * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
+ * an RCU-bh read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * this assumes we are in an RCU-bh read-side critical section unless it can
+ * prove otherwise.
+ */
+static inline int rcu_read_lock_bh_held(void)
+{
+	if (debug_locks)
+		return lock_is_held(&rcu_bh_lock_map);
+	return 1;
+}
+
+/**
+ * rcu_read_lock_sched_held - might we be in RCU-sched read-side critical section?
+ *
+ * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in an
+ * RCU-sched read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * this assumes we are in an RCU-sched read-side critical section unless it
+ * can prove otherwise.  Note that disabling of preemption (including
+ * disabling irqs) counts as an RCU-sched read-side critical section.
+ */
+static inline int rcu_read_lock_sched_held(void)
+{
+	int lockdep_opinion = 0;
+
+	if (debug_locks)
+		lockdep_opinion = lock_is_held(&rcu_sched_lock_map);
+	return lockdep_opinion || preempt_count() != 0 || !rcu_scheduler_active;
+}
+
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+# define rcu_read_acquire()		do { } while (0)
+# define rcu_read_release()		do { } while (0)
+# define rcu_read_acquire_bh()		do { } while (0)
+# define rcu_read_release_bh()		do { } while (0)
+# define rcu_read_acquire_sched()	do { } while (0)
+# define rcu_read_release_sched()	do { } while (0)
+
+static inline int rcu_read_lock_held(void)
+{
+	return 1;
+}
+
+static inline int rcu_read_lock_bh_held(void)
+{
+	return 1;
+}
+
+static inline int rcu_read_lock_sched_held(void)
+{
+	return preempt_count() != 0 || !rcu_scheduler_active;
+}
+
+#endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+#ifdef CONFIG_PROVE_RCU
+
+/**
+ * rcu_dereference_check - rcu_dereference with debug checking
+ *
+ * Do an rcu_dereference(), but check that the context is correct.
+ * For example, rcu_dereference_check(gp, rcu_read_lock_held()) to
+ * ensure that the rcu_dereference_check() executes within an RCU
+ * read-side critical section.  It is also possible to check for
+ * locks being held, for example, by using lockdep_is_held().
+ */
+#define rcu_dereference_check(p, c) \
+	({ \
+		if (debug_locks && !(c)) \
+			lockdep_rcu_dereference(__FILE__, __LINE__); \
+		rcu_dereference_raw(p); \
+	})
+
+#else /* #ifdef CONFIG_PROVE_RCU */
+
+#define rcu_dereference_check(p, c)	rcu_dereference_raw(p)
+
+#endif /* #else #ifdef CONFIG_PROVE_RCU */
 
 /**
  * rcu_read_lock - mark the beginning of an RCU read-side critical section.
@@ -160,7 +268,7 @@ static inline void rcu_read_lock_bh(void)
 {
 	__rcu_read_lock_bh();
 	__acquire(RCU_BH);
-	rcu_read_acquire();
+	rcu_read_acquire_bh();
 }
 
 /*
@@ -170,7 +278,7 @@ static inline void rcu_read_lock_bh(void)
  */
 static inline void rcu_read_unlock_bh(void)
 {
-	rcu_read_release();
+	rcu_read_release_bh();
 	__release(RCU_BH);
 	__rcu_read_unlock_bh();
 }
@@ -188,7 +296,7 @@ static inline void rcu_read_lock_sched(void)
 {
 	preempt_disable();
 	__acquire(RCU_SCHED);
-	rcu_read_acquire();
+	rcu_read_acquire_sched();
 }
 
 /* Used by lockdep and tracing: cannot be traced, cannot call lockdep. */
@@ -205,7 +313,7 @@ static inline notrace void rcu_read_lock_sched_notrace(void)
  */
 static inline void rcu_read_unlock_sched(void)
 {
-	rcu_read_release();
+	rcu_read_release_sched();
 	__release(RCU_SCHED);
 	preempt_enable();
 }
@@ -219,22 +327,49 @@ static inline notrace void rcu_read_unlock_sched_notrace(void)
 
 
 /**
- * rcu_dereference - fetch an RCU-protected pointer in an
- * RCU read-side critical section.  This pointer may later
- * be safely dereferenced.
+ * rcu_dereference_raw - fetch an RCU-protected pointer
+ *
+ * The caller must be within some flavor of RCU read-side critical
+ * section, or must be otherwise preventing the pointer from changing,
+ * for example, by holding an appropriate lock.  This pointer may later
+ * be safely dereferenced.  It is the caller's responsibility to have
+ * done the right thing, as this primitive does no checking of any kind.
  *
  * Inserts memory barriers on architectures that require them
  * (currently only the Alpha), and, more importantly, documents
  * exactly which pointers are protected by RCU.
  */
-
-#define rcu_dereference(p)     ({ \
+#define rcu_dereference_raw(p)	({ \
 				typeof(p) _________p1 = ACCESS_ONCE(p); \
 				smp_read_barrier_depends(); \
 				(_________p1); \
 				})
 
 /**
+ * rcu_dereference - fetch an RCU-protected pointer, checking for RCU
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define rcu_dereference(p) \
+	rcu_dereference_check(p, rcu_read_lock_held())
+
+/**
+ * rcu_dereference_bh - fetch an RCU-protected pointer, checking for RCU-bh
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define rcu_dereference_bh(p) \
+		rcu_dereference_check(p, rcu_read_lock_bh_held())
+
+/**
+ * rcu_dereference_sched - fetch RCU-protected pointer, checking for RCU-sched
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define rcu_dereference_sched(p) \
+		rcu_dereference_check(p, rcu_read_lock_sched_held())
+
+/**
  * rcu_assign_pointer - assign (publicize) a pointer to a newly
  * initialized structure that will be dereferenced by RCU read-side
  * critical sections.  Returns the value assigned.
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 96cc307..a519587 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -62,6 +62,18 @@ static inline long rcu_batches_completed_bh(void)
 
 extern int rcu_expedited_torture_stats(char *page);
 
+static inline void rcu_force_quiescent_state(void)
+{
+}
+
+static inline void rcu_bh_force_quiescent_state(void)
+{
+}
+
+static inline void rcu_sched_force_quiescent_state(void)
+{
+}
+
 #define synchronize_rcu synchronize_sched
 
 static inline void synchronize_rcu_expedited(void)
@@ -93,10 +105,6 @@ static inline void rcu_exit_nohz(void)
 
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
-static inline void rcu_scheduler_starting(void)
-{
-}
-
 static inline void exit_rcu(void)
 {
 }
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 8044b1b..42cc3a0 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -35,7 +35,6 @@ struct notifier_block;
 extern void rcu_sched_qs(int cpu);
 extern void rcu_bh_qs(int cpu);
 extern int rcu_needs_cpu(int cpu);
-extern void rcu_scheduler_starting(void);
 extern int rcu_expedited_torture_stats(char *page);
 
 #ifdef CONFIG_TREE_PREEMPT_RCU
@@ -99,6 +98,9 @@ extern void rcu_check_callbacks(int cpu, int user);
 extern long rcu_batches_completed(void);
 extern long rcu_batches_completed_bh(void);
 extern long rcu_batches_completed_sched(void);
+extern void rcu_force_quiescent_state(void);
+extern void rcu_bh_force_quiescent_state(void);
+extern void rcu_sched_force_quiescent_state(void);
 
 #ifdef CONFIG_NO_HZ
 void rcu_enter_nohz(void);
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index 05330fc..5c52fa4 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -735,6 +735,9 @@ extern void rtnl_lock(void);
 extern void rtnl_unlock(void);
 extern int rtnl_trylock(void);
 extern int rtnl_is_locked(void);
+#ifdef CONFIG_PROVE_LOCKING
+extern int lockdep_rtnl_is_held(void);
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
 
 extern void rtnetlink_init(void);
 extern void __rtnl_unlock(void);
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 4765d97..3084f80 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -35,6 +35,9 @@ struct srcu_struct {
 	int completed;
 	struct srcu_struct_array *per_cpu_ref;
 	struct mutex mutex;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 };
 
 #ifndef CONFIG_PREEMPT
@@ -43,12 +46,100 @@ struct srcu_struct {
 #define srcu_barrier()
 #endif /* #else #ifndef CONFIG_PREEMPT */
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+int __init_srcu_struct(struct srcu_struct *sp, const char *name,
+		       struct lock_class_key *key);
+
+#define init_srcu_struct(sp) \
+({ \
+	static struct lock_class_key __srcu_key; \
+	\
+	__init_srcu_struct((sp), #sp, &__srcu_key); \
+})
+
+# define srcu_read_acquire(sp) \
+		lock_acquire(&(sp)->dep_map, 0, 0, 2, 1, NULL, _THIS_IP_)
+# define srcu_read_release(sp) \
+		lock_release(&(sp)->dep_map, 1, _THIS_IP_)
+
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 int init_srcu_struct(struct srcu_struct *sp);
+
+# define srcu_read_acquire(sp)  do { } while (0)
+# define srcu_read_release(sp)  do { } while (0)
+
+#endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 void cleanup_srcu_struct(struct srcu_struct *sp);
-int srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
-void srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
+int __srcu_read_lock(struct srcu_struct *sp) __acquires(sp);
+void __srcu_read_unlock(struct srcu_struct *sp, int idx) __releases(sp);
 void synchronize_srcu(struct srcu_struct *sp);
 void synchronize_srcu_expedited(struct srcu_struct *sp);
 long srcu_batches_completed(struct srcu_struct *sp);
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+/**
+ * srcu_read_lock_held - might we be in SRCU read-side critical section?
+ *
+ * If CONFIG_PROVE_LOCKING is selected and enabled, returns nonzero iff in
+ * an SRCU read-side critical section.  In absence of CONFIG_PROVE_LOCKING,
+ * this assumes we are in an SRCU read-side critical section unless it can
+ * prove otherwise.
+ */
+static inline int srcu_read_lock_held(struct srcu_struct *sp)
+{
+	if (debug_locks)
+		return lock_is_held(&sp->dep_map);
+	return 1;
+}
+
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+static inline int srcu_read_lock_held(struct srcu_struct *sp)
+{
+	return 1;
+}
+
+#endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
+/**
+ * srcu_dereference - fetch SRCU-protected pointer with checking
+ *
+ * Makes rcu_dereference_check() do the dirty work.
+ */
+#define srcu_dereference(p, sp) \
+		rcu_dereference_check(p, srcu_read_lock_held(sp))
+
+/**
+ * srcu_read_lock - register a new reader for an SRCU-protected structure.
+ * @sp: srcu_struct in which to register the new reader.
+ *
+ * Enter an SRCU read-side critical section.  Note that SRCU read-side
+ * critical sections may be nested.
+ */
+static inline int srcu_read_lock(struct srcu_struct *sp) __acquires(sp)
+{
+	int retval = __srcu_read_lock(sp);
+
+	srcu_read_acquire(sp);
+	return retval;
+}
+
+/**
+ * srcu_read_unlock - unregister a old reader from an SRCU-protected structure.
+ * @sp: srcu_struct in which to unregister the old reader.
+ * @idx: return value from corresponding srcu_read_lock().
+ *
+ * Exit an SRCU read-side critical section.
+ */
+static inline void srcu_read_unlock(struct srcu_struct *sp, int idx)
+	__releases(sp)
+{
+	srcu_read_release(sp);
+	__srcu_read_unlock(sp, idx);
+}
+
 #endif
diff --git a/include/net/addrconf.h b/include/net/addrconf.h
index 0f7c378..45375b4 100644
--- a/include/net/addrconf.h
+++ b/include/net/addrconf.h
@@ -177,7 +177,9 @@ extern int unregister_inet6addr_notifier(struct notifier_block *nb);
 static inline struct inet6_dev *
 __in6_dev_get(struct net_device *dev)
 {
-	return rcu_dereference(dev->ip6_ptr);
+	return rcu_dereference_check(dev->ip6_ptr,
+				     rcu_read_lock_held() ||
+				     lockdep_rtnl_is_held());
 }
 
 static inline struct inet6_dev *
diff --git a/init/Kconfig b/init/Kconfig
index d95ca7c..42bf914 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -396,6 +396,22 @@ config RCU_FANOUT_EXACT
 
 	  Say N if unsure.
 
+config RCU_FAST_NO_HZ
+	bool "Accelerate last non-dyntick-idle CPU's grace periods"
+	depends on TREE_RCU && NO_HZ && SMP
+	default n
+	help
+	  This option causes RCU to attempt to accelerate grace periods
+	  in order to allow the final CPU to enter dynticks-idle state
+	  more quickly.  On the other hand, this option increases the
+	  overhead of the dynticks-idle checking, particularly on systems
+	  with large numbers of CPUs.
+
+	  Say Y if energy efficiency is critically important, particularly
+	  	if you have relatively few CPUs.
+
+	  Say N if you are unsure.
+
 config TREE_RCU_TRACE
 	def_bool RCU_TRACE && ( TREE_RCU || TREE_PREEMPT_RCU )
 	select DEBUG_FS
diff --git a/init/main.c b/init/main.c
index 4cb47a1..c75dcd6 100644
--- a/init/main.c
+++ b/init/main.c
@@ -416,7 +416,9 @@ static noinline void __init_refok rest_init(void)
 	kernel_thread(kernel_init, NULL, CLONE_FS | CLONE_SIGHAND);
 	numa_default_policy();
 	pid = kernel_thread(kthreadd, NULL, CLONE_FS | CLONE_FILES);
+	rcu_read_lock();
 	kthreadd_task = find_task_by_pid_ns(pid, &init_pid_ns);
+	rcu_read_unlock();
 	unlock_kernel();
 
 	/*
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index aa3bee5..4fd90e1 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -23,6 +23,7 @@
  */
 
 #include <linux/cgroup.h>
+#include <linux/module.h>
 #include <linux/ctype.h>
 #include <linux/errno.h>
 #include <linux/fs.h>
@@ -166,6 +167,20 @@ static DEFINE_SPINLOCK(hierarchy_id_lock);
  */
 static int need_forkexit_callback __read_mostly;
 
+#ifdef CONFIG_PROVE_LOCKING
+int cgroup_lock_is_held(void)
+{
+	return lockdep_is_held(&cgroup_mutex);
+}
+#else /* #ifdef CONFIG_PROVE_LOCKING */
+int cgroup_lock_is_held(void)
+{
+	return mutex_is_locked(&cgroup_mutex);
+}
+#endif /* #else #ifdef CONFIG_PROVE_LOCKING */
+
+EXPORT_SYMBOL_GPL(cgroup_lock_is_held);
+
 /* convenient tests for these bits */
 inline int cgroup_is_removed(const struct cgroup *cgrp)
 {
diff --git a/kernel/exit.c b/kernel/exit.c
index 546774a..45ed043 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -85,7 +85,9 @@ static void __exit_signal(struct task_struct *tsk)
 	BUG_ON(!sig);
 	BUG_ON(!atomic_read(&sig->count));
 
-	sighand = rcu_dereference(tsk->sighand);
+	sighand = rcu_dereference_check(tsk->sighand,
+					rcu_read_lock_held() ||
+					lockdep_is_held(&tasklist_lock));
 	spin_lock(&sighand->siglock);
 
 	posix_cpu_timers_exit(tsk);
@@ -170,8 +172,10 @@ void release_task(struct task_struct * p)
 repeat:
 	tracehook_prepare_release_task(p);
 	/* don't need to get the RCU readlock here - the process is dead and
-	 * can't be modifying its own credentials */
+	 * can't be modifying its own credentials. But shut RCU-lockdep up */
+	rcu_read_lock();
 	atomic_dec(&__task_cred(p)->user->processes);
+	rcu_read_unlock();
 
 	proc_flush_task(p);
 
@@ -473,9 +477,11 @@ static void close_files(struct files_struct * files)
 	/*
 	 * It is safe to dereference the fd table without RCU or
 	 * ->file_lock because this is the last reference to the
-	 * files structure.
+	 * files structure.  But use RCU to shut RCU-lockdep up.
 	 */
+	rcu_read_lock();
 	fdt = files_fdtable(files);
+	rcu_read_unlock();
 	for (;;) {
 		unsigned long set;
 		i = j * __NFDBITS;
@@ -521,10 +527,12 @@ void put_files_struct(struct files_struct *files)
 		 * at the end of the RCU grace period. Otherwise,
 		 * you can free files immediately.
 		 */
+		rcu_read_lock();
 		fdt = files_fdtable(files);
 		if (fdt != &files->fdtab)
 			kmem_cache_free(files_cachep, files);
 		free_fdtable(fdt);
+		rcu_read_unlock();
 	}
 }
 
diff --git a/kernel/fork.c b/kernel/fork.c
index f88bd98..17bbf09 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -86,6 +86,7 @@ int max_threads;		/* tunable limit on nr_threads */
 DEFINE_PER_CPU(unsigned long, process_counts) = 0;
 
 __cacheline_aligned DEFINE_RWLOCK(tasklist_lock);  /* outer */
+EXPORT_SYMBOL_GPL(tasklist_lock);
 
 int nr_processes(void)
 {
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index c62ec14..0c30d04 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -3809,3 +3809,21 @@ void lockdep_sys_exit(void)
 		lockdep_print_held_locks(curr);
 	}
 }
+
+void lockdep_rcu_dereference(const char *file, const int line)
+{
+	struct task_struct *curr = current;
+
+	if (!debug_locks_off())
+		return;
+	printk("\n===================================================\n");
+	printk(  "[ INFO: suspicious rcu_dereference_check() usage. ]\n");
+	printk(  "---------------------------------------------------\n");
+	printk("%s:%d invoked rcu_dereference_check() without protection!\n",
+			file, line);
+	printk("\nother info that might help us debug this:\n\n");
+	lockdep_print_held_locks(curr);
+	printk("\nstack backtrace:\n");
+	dump_stack();
+}
+EXPORT_SYMBOL_GPL(lockdep_rcu_dereference);
diff --git a/kernel/notifier.c b/kernel/notifier.c
index acd24e7..2488ba7 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -78,10 +78,10 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 	int ret = NOTIFY_DONE;
 	struct notifier_block *nb, *next_nb;
 
-	nb = rcu_dereference(*nl);
+	nb = rcu_dereference_raw(*nl);
 
 	while (nb && nr_to_call) {
-		next_nb = rcu_dereference(nb->next);
+		next_nb = rcu_dereference_raw(nb->next);
 
 #ifdef CONFIG_DEBUG_NOTIFIERS
 		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
@@ -309,7 +309,7 @@ int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 	 * racy then it does not matter what the result of the test
 	 * is, we re-check the list after having taken the lock anyway:
 	 */
-	if (rcu_dereference(nh->head)) {
+	if (rcu_dereference_raw(nh->head)) {
 		down_read(&nh->rwsem);
 		ret = notifier_call_chain(&nh->head, val, v, nr_to_call,
 					nr_calls);
diff --git a/kernel/pid.c b/kernel/pid.c
index 2e17c9c..b08e697 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -367,7 +367,7 @@ struct task_struct *pid_task(struct pid *pid, enum pid_type type)
 	struct task_struct *result = NULL;
 	if (pid) {
 		struct hlist_node *first;
-		first = rcu_dereference(pid->tasks[type].first);
+		first = rcu_dereference_check(pid->tasks[type].first, rcu_read_lock_held() || lockdep_is_held(&tasklist_lock));
 		if (first)
 			result = hlist_entry(first, struct task_struct, pids[(type)].node);
 	}
diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
index 9b7fd47..f1125c1 100644
--- a/kernel/rcupdate.c
+++ b/kernel/rcupdate.c
@@ -44,14 +44,43 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/kernel_stat.h>
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 static struct lock_class_key rcu_lock_key;
 struct lockdep_map rcu_lock_map =
 	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
 EXPORT_SYMBOL_GPL(rcu_lock_map);
+
+static struct lock_class_key rcu_bh_lock_key;
+struct lockdep_map rcu_bh_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_bh", &rcu_bh_lock_key);
+EXPORT_SYMBOL_GPL(rcu_bh_lock_map);
+
+static struct lock_class_key rcu_sched_lock_key;
+struct lockdep_map rcu_sched_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock_sched", &rcu_sched_lock_key);
+EXPORT_SYMBOL_GPL(rcu_sched_lock_map);
 #endif
 
+int rcu_scheduler_active __read_mostly;
+EXPORT_SYMBOL_GPL(rcu_scheduler_active);
+
+/*
+ * This function is invoked towards the end of the scheduler's initialization
+ * process.  Before this is called, the idle task might contain
+ * RCU read-side critical sections (during which time, this idle
+ * task is booting the system).  After this function is called, the
+ * idle tasks are prohibited from containing RCU read-side critical
+ * sections.
+ */
+void rcu_scheduler_starting(void)
+{
+	WARN_ON(num_online_cpus() != 1);
+	WARN_ON(nr_context_switches() > 0);
+	rcu_scheduler_active = 1;
+}
+
 /*
  * Awaken the corresponding synchronize_rcu() instance now that a
  * grace period has elapsed.
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 9bb5217..258cdf0 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -61,6 +61,9 @@ static int test_no_idle_hz;	/* Test RCU's support for tickless idle CPUs. */
 static int shuffle_interval = 3; /* Interval between shuffles (in sec)*/
 static int stutter = 5;		/* Start/stop testing interval (in sec) */
 static int irqreader = 1;	/* RCU readers from irq (timers). */
+static int fqs_duration = 0;	/* Duration of bursts (us), 0 to disable. */
+static int fqs_holdoff = 0;	/* Hold time within burst (us). */
+static int fqs_stutter = 3;	/* Wait time between bursts (s). */
 static char *torture_type = "rcu"; /* What RCU implementation to torture. */
 
 module_param(nreaders, int, 0444);
@@ -79,6 +82,12 @@ module_param(stutter, int, 0444);
 MODULE_PARM_DESC(stutter, "Number of seconds to run/halt test");
 module_param(irqreader, int, 0444);
 MODULE_PARM_DESC(irqreader, "Allow RCU readers from irq handlers");
+module_param(fqs_duration, int, 0444);
+MODULE_PARM_DESC(fqs_duration, "Duration of fqs bursts (us)");
+module_param(fqs_holdoff, int, 0444);
+MODULE_PARM_DESC(fqs_holdoff, "Holdoff time within fqs bursts (us)");
+module_param(fqs_stutter, int, 0444);
+MODULE_PARM_DESC(fqs_stutter, "Wait time between fqs bursts (s)");
 module_param(torture_type, charp, 0444);
 MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, srcu)");
 
@@ -99,6 +108,7 @@ static struct task_struct **reader_tasks;
 static struct task_struct *stats_task;
 static struct task_struct *shuffler_task;
 static struct task_struct *stutter_task;
+static struct task_struct *fqs_task;
 
 #define RCU_TORTURE_PIPE_LEN 10
 
@@ -263,6 +273,7 @@ struct rcu_torture_ops {
 	void (*deferred_free)(struct rcu_torture *p);
 	void (*sync)(void);
 	void (*cb_barrier)(void);
+	void (*fqs)(void);
 	int (*stats)(char *page);
 	int irq_capable;
 	char *name;
@@ -347,6 +358,7 @@ static struct rcu_torture_ops rcu_ops = {
 	.deferred_free	= rcu_torture_deferred_free,
 	.sync		= synchronize_rcu,
 	.cb_barrier	= rcu_barrier,
+	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "rcu"
@@ -388,6 +400,7 @@ static struct rcu_torture_ops rcu_sync_ops = {
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_rcu,
 	.cb_barrier	= NULL,
+	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "rcu_sync"
@@ -403,6 +416,7 @@ static struct rcu_torture_ops rcu_expedited_ops = {
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_rcu_expedited,
 	.cb_barrier	= NULL,
+	.fqs		= rcu_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "rcu_expedited"
@@ -465,6 +479,7 @@ static struct rcu_torture_ops rcu_bh_ops = {
 	.deferred_free	= rcu_bh_torture_deferred_free,
 	.sync		= rcu_bh_torture_synchronize,
 	.cb_barrier	= rcu_barrier_bh,
+	.fqs		= rcu_bh_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "rcu_bh"
@@ -480,6 +495,7 @@ static struct rcu_torture_ops rcu_bh_sync_ops = {
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= rcu_bh_torture_synchronize,
 	.cb_barrier	= NULL,
+	.fqs		= rcu_bh_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "rcu_bh_sync"
@@ -621,6 +637,7 @@ static struct rcu_torture_ops sched_ops = {
 	.deferred_free	= rcu_sched_torture_deferred_free,
 	.sync		= sched_torture_synchronize,
 	.cb_barrier	= rcu_barrier_sched,
+	.fqs		= rcu_sched_force_quiescent_state,
 	.stats		= NULL,
 	.irq_capable	= 1,
 	.name		= "sched"
@@ -636,6 +653,7 @@ static struct rcu_torture_ops sched_sync_ops = {
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= sched_torture_synchronize,
 	.cb_barrier	= NULL,
+	.fqs		= rcu_sched_force_quiescent_state,
 	.stats		= NULL,
 	.name		= "sched_sync"
 };
@@ -650,12 +668,45 @@ static struct rcu_torture_ops sched_expedited_ops = {
 	.deferred_free	= rcu_sync_torture_deferred_free,
 	.sync		= synchronize_sched_expedited,
 	.cb_barrier	= NULL,
+	.fqs		= rcu_sched_force_quiescent_state,
 	.stats		= rcu_expedited_torture_stats,
 	.irq_capable	= 1,
 	.name		= "sched_expedited"
 };
 
 /*
+ * RCU torture force-quiescent-state kthread.  Repeatedly induces
+ * bursts of calls to force_quiescent_state(), increasing the probability
+ * of occurrence of some important types of race conditions.
+ */
+static int
+rcu_torture_fqs(void *arg)
+{
+	unsigned long fqs_resume_time;
+	int fqs_burst_remaining;
+
+	VERBOSE_PRINTK_STRING("rcu_torture_fqs task started");
+	do {
+		fqs_resume_time = jiffies + fqs_stutter * HZ;
+		while (jiffies - fqs_resume_time > LONG_MAX) {
+			schedule_timeout_interruptible(1);
+		}
+		fqs_burst_remaining = fqs_duration;
+		while (fqs_burst_remaining > 0) {
+			cur_ops->fqs();
+			udelay(fqs_holdoff);
+			fqs_burst_remaining -= fqs_holdoff;
+		}
+		rcu_stutter_wait("rcu_torture_fqs");
+	} while (!kthread_should_stop() && fullstop == FULLSTOP_DONTSTOP);
+	VERBOSE_PRINTK_STRING("rcu_torture_fqs task stopping");
+	rcutorture_shutdown_absorb("rcu_torture_fqs");
+	while (!kthread_should_stop())
+		schedule_timeout_uninterruptible(1);
+	return 0;
+}
+
+/*
  * RCU torture writer kthread.  Repeatedly substitutes a new structure
  * for that pointed to by rcu_torture_current, freeing the old structure
  * after a series of grace periods (the "pipeline").
@@ -745,7 +796,11 @@ static void rcu_torture_timer(unsigned long unused)
 
 	idx = cur_ops->readlock();
 	completed = cur_ops->completed();
-	p = rcu_dereference(rcu_torture_current);
+	p = rcu_dereference_check(rcu_torture_current,
+				  rcu_read_lock_held() ||
+				  rcu_read_lock_bh_held() ||
+				  rcu_read_lock_sched_held() ||
+				  srcu_read_lock_held(&srcu_ctl));
 	if (p == NULL) {
 		/* Leave because rcu_torture_writer is not yet underway */
 		cur_ops->readunlock(idx);
@@ -798,11 +853,15 @@ rcu_torture_reader(void *arg)
 	do {
 		if (irqreader && cur_ops->irq_capable) {
 			if (!timer_pending(&t))
-				mod_timer(&t, 1);
+				mod_timer(&t, jiffies + 1);
 		}
 		idx = cur_ops->readlock();
 		completed = cur_ops->completed();
-		p = rcu_dereference(rcu_torture_current);
+		p = rcu_dereference_check(rcu_torture_current,
+					  rcu_read_lock_held() ||
+					  rcu_read_lock_bh_held() ||
+					  rcu_read_lock_sched_held() ||
+					  srcu_read_lock_held(&srcu_ctl));
 		if (p == NULL) {
 			/* Wait for rcu_torture_writer to get underway */
 			cur_ops->readunlock(idx);
@@ -1030,10 +1089,11 @@ rcu_torture_print_module_parms(char *tag)
 	printk(KERN_ALERT "%s" TORTURE_FLAG
 		"--- %s: nreaders=%d nfakewriters=%d "
 		"stat_interval=%d verbose=%d test_no_idle_hz=%d "
-		"shuffle_interval=%d stutter=%d irqreader=%d\n",
+		"shuffle_interval=%d stutter=%d irqreader=%d "
+		"fqs_duration=%d fqs_holdoff=%d fqs_stutter=%d\n",
 		torture_type, tag, nrealreaders, nfakewriters,
 		stat_interval, verbose, test_no_idle_hz, shuffle_interval,
-		stutter, irqreader);
+		stutter, irqreader, fqs_duration, fqs_holdoff, fqs_stutter);
 }
 
 static struct notifier_block rcutorture_nb = {
@@ -1109,6 +1169,12 @@ rcu_torture_cleanup(void)
 	}
 	stats_task = NULL;
 
+	if (fqs_task) {
+		VERBOSE_PRINTK_STRING("Stopping rcu_torture_fqs task");
+		kthread_stop(fqs_task);
+	}
+	fqs_task = NULL;
+
 	/* Wait for all RCU callbacks to fire.  */
 
 	if (cur_ops->cb_barrier != NULL)
@@ -1154,6 +1220,11 @@ rcu_torture_init(void)
 		mutex_unlock(&fullstop_mutex);
 		return -EINVAL;
 	}
+	if (cur_ops->fqs == NULL && fqs_duration != 0) {
+		printk(KERN_ALERT "rcu-torture: ->fqs NULL and non-zero "
+				  "fqs_duration, fqs disabled.\n");
+		fqs_duration = 0;
+	}
 	if (cur_ops->init)
 		cur_ops->init(); /* no "goto unwind" prior to this point!!! */
 
@@ -1282,6 +1353,19 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	if (fqs_duration < 0)
+		fqs_duration = 0;
+	if (fqs_duration) {
+		/* Create the stutter thread */
+		fqs_task = kthread_run(rcu_torture_fqs, NULL,
+				       "rcu_torture_fqs");
+		if (IS_ERR(fqs_task)) {
+			firsterr = PTR_ERR(fqs_task);
+			VERBOSE_PRINTK_ERRSTRING("Failed to create fqs");
+			fqs_task = NULL;
+			goto unwind;
+		}
+	}
 	register_reboot_notifier(&rcutorture_nb);
 	mutex_unlock(&fullstop_mutex);
 	return 0;
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 53ae959..3ec8160 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -46,7 +46,6 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/time.h>
-#include <linux/kernel_stat.h>
 
 #include "rcutree.h"
 
@@ -66,11 +65,11 @@ static struct lock_class_key rcu_node_class[NUM_RCU_LVLS];
 	.signaled = RCU_GP_IDLE, \
 	.gpnum = -300, \
 	.completed = -300, \
-	.onofflock = __SPIN_LOCK_UNLOCKED(&name.onofflock), \
+	.onofflock = __RAW_SPIN_LOCK_UNLOCKED(&name.onofflock), \
 	.orphan_cbs_list = NULL, \
 	.orphan_cbs_tail = &name.orphan_cbs_list, \
 	.orphan_qlen = 0, \
-	.fqslock = __SPIN_LOCK_UNLOCKED(&name.fqslock), \
+	.fqslock = __RAW_SPIN_LOCK_UNLOCKED(&name.fqslock), \
 	.n_force_qs = 0, \
 	.n_force_qs_ngp = 0, \
 }
@@ -81,9 +80,6 @@ DEFINE_PER_CPU(struct rcu_data, rcu_sched_data);
 struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
 DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
 
-static int rcu_scheduler_active __read_mostly;
-
-
 /*
  * Return true if an RCU grace period is in progress.  The ACCESS_ONCE()s
  * permit this function to be invoked without holding the root rcu_node
@@ -157,6 +153,24 @@ long rcu_batches_completed_bh(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
 
 /*
+ * Force a quiescent state for RCU BH.
+ */
+void rcu_bh_force_quiescent_state(void)
+{
+	force_quiescent_state(&rcu_bh_state, 0);
+}
+EXPORT_SYMBOL_GPL(rcu_bh_force_quiescent_state);
+
+/*
+ * Force a quiescent state for RCU-sched.
+ */
+void rcu_sched_force_quiescent_state(void)
+{
+	force_quiescent_state(&rcu_sched_state, 0);
+}
+EXPORT_SYMBOL_GPL(rcu_sched_force_quiescent_state);
+
+/*
  * Does the CPU have callbacks ready to be invoked?
  */
 static int
@@ -439,10 +453,10 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 
 	/* Only let one CPU complain about others per time interval. */
 
-	spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	delta = jiffies - rsp->jiffies_stall;
 	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp)) {
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
@@ -452,13 +466,15 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	 * due to CPU offlining.
 	 */
 	rcu_print_task_stall(rnp);
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	/* OK, time to rat on our buddy... */
 
 	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
 	rcu_for_each_leaf_node(rsp, rnp) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		rcu_print_task_stall(rnp);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		if (rnp->qsmask == 0)
 			continue;
 		for (cpu = 0; cpu <= rnp->grphi - rnp->grplo; cpu++)
@@ -469,6 +485,10 @@ static void print_other_cpu_stall(struct rcu_state *rsp)
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
 	trigger_all_cpu_backtrace();
 
+	/* If so configured, complain about tasks blocking the grace period. */
+
+	rcu_print_detail_task_stall(rsp);
+
 	force_quiescent_state(rsp, 0);  /* Kick them all. */
 }
 
@@ -481,11 +501,11 @@ static void print_cpu_stall(struct rcu_state *rsp)
 			smp_processor_id(), jiffies - rsp->gp_start);
 	trigger_all_cpu_backtrace();
 
-	spin_lock_irqsave(&rnp->lock, flags);
-	if ((long)(jiffies - rsp->jiffies_stall) >= 0)
+	raw_spin_lock_irqsave(&rnp->lock, flags);
+	if (ULONG_CMP_GE(jiffies, rsp->jiffies_stall))
 		rsp->jiffies_stall =
 			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
 	set_need_resched();  /* kick ourselves to get things going. */
 }
@@ -545,12 +565,12 @@ static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
 	local_irq_save(flags);
 	rnp = rdp->mynode;
 	if (rdp->gpnum == ACCESS_ONCE(rnp->gpnum) || /* outside lock. */
-	    !spin_trylock(&rnp->lock)) { /* irqs already off, retry later. */
+	    !raw_spin_trylock(&rnp->lock)) { /* irqs already off, so later. */
 		local_irq_restore(flags);
 		return;
 	}
 	__note_new_gpnum(rsp, rnp, rdp);
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -609,12 +629,12 @@ rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
 	local_irq_save(flags);
 	rnp = rdp->mynode;
 	if (rdp->completed == ACCESS_ONCE(rnp->completed) || /* outside lock. */
-	    !spin_trylock(&rnp->lock)) { /* irqs already off, retry later. */
+	    !raw_spin_trylock(&rnp->lock)) { /* irqs already off, so later. */
 		local_irq_restore(flags);
 		return;
 	}
 	__rcu_process_gp_end(rsp, rnp, rdp);
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -659,12 +679,14 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
-	if (!cpu_needs_another_gp(rsp, rdp)) {
+	if (!cpu_needs_another_gp(rsp, rdp) || rsp->fqs_active) {
+		if (cpu_needs_another_gp(rsp, rdp))
+			rsp->fqs_need_gp = 1;
 		if (rnp->completed == rsp->completed) {
-			spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
 		}
-		spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
+		raw_spin_unlock(&rnp->lock);	 /* irqs remain disabled. */
 
 		/*
 		 * Propagate new ->completed value to rcu_node structures
@@ -672,9 +694,9 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		 * of the next grace period to process their callbacks.
 		 */
 		rcu_for_each_node_breadth_first(rsp, rnp) {
-			spin_lock(&rnp->lock);	 /* irqs already disabled. */
+			raw_spin_lock(&rnp->lock); /* irqs already disabled. */
 			rnp->completed = rsp->completed;
-			spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		}
 		local_irq_restore(flags);
 		return;
@@ -695,15 +717,15 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 		rnp->completed = rsp->completed;
 		rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state OK. */
 		rcu_start_gp_per_cpu(rsp, rnp, rdp);
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 
-	spin_unlock(&rnp->lock);  /* leave irqs disabled. */
+	raw_spin_unlock(&rnp->lock);  /* leave irqs disabled. */
 
 
 	/* Exclude any concurrent CPU-hotplug operations. */
-	spin_lock(&rsp->onofflock);  /* irqs already disabled. */
+	raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
 
 	/*
 	 * Set the quiescent-state-needed bits in all the rcu_node
@@ -723,21 +745,21 @@ rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
 	 * irqs disabled.
 	 */
 	rcu_for_each_node_breadth_first(rsp, rnp) {
-		spin_lock(&rnp->lock);		/* irqs already disabled. */
+		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rcu_preempt_check_blocked_tasks(rnp);
 		rnp->qsmask = rnp->qsmaskinit;
 		rnp->gpnum = rsp->gpnum;
 		rnp->completed = rsp->completed;
 		if (rnp == rdp->mynode)
 			rcu_start_gp_per_cpu(rsp, rnp, rdp);
-		spin_unlock(&rnp->lock);	/* irqs remain disabled. */
+		raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
 	}
 
 	rnp = rcu_get_root(rsp);
-	spin_lock(&rnp->lock);			/* irqs already disabled. */
+	raw_spin_lock(&rnp->lock);		/* irqs already disabled. */
 	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
-	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
-	spin_unlock_irqrestore(&rsp->onofflock, flags);
+	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
+	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
 /*
@@ -776,14 +798,14 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
 		if (!(rnp->qsmask & mask)) {
 
 			/* Our bit has already been cleared, so done. */
-			spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
 		}
 		rnp->qsmask &= ~mask;
 		if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
 
 			/* Other bits still set at this level, so done. */
-			spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			return;
 		}
 		mask = rnp->grpmask;
@@ -793,10 +815,10 @@ rcu_report_qs_rnp(unsigned long mask, struct rcu_state *rsp,
 
 			break;
 		}
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		rnp_c = rnp;
 		rnp = rnp->parent;
-		spin_lock_irqsave(&rnp->lock, flags);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		WARN_ON_ONCE(rnp_c->qsmask);
 	}
 
@@ -825,7 +847,7 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long las
 	struct rcu_node *rnp;
 
 	rnp = rdp->mynode;
-	spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	if (lastcomp != rnp->completed) {
 
 		/*
@@ -837,12 +859,12 @@ rcu_report_qs_rdp(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long las
 		 * race occurred.
 		 */
 		rdp->passed_quiesc = 0;	/* try again later! */
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
 	mask = rdp->grpmask;
 	if ((rnp->qsmask & mask) == 0) {
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	} else {
 		rdp->qs_pending = 0;
 
@@ -906,7 +928,7 @@ static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
 
 	if (rdp->nxtlist == NULL)
 		return;  /* irqs disabled, so comparison is stable. */
-	spin_lock(&rsp->onofflock);  /* irqs already disabled. */
+	raw_spin_lock(&rsp->onofflock);  /* irqs already disabled. */
 	*rsp->orphan_cbs_tail = rdp->nxtlist;
 	rsp->orphan_cbs_tail = rdp->nxttail[RCU_NEXT_TAIL];
 	rdp->nxtlist = NULL;
@@ -914,7 +936,7 @@ static void rcu_send_cbs_to_orphanage(struct rcu_state *rsp)
 		rdp->nxttail[i] = &rdp->nxtlist;
 	rsp->orphan_qlen += rdp->qlen;
 	rdp->qlen = 0;
-	spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
+	raw_spin_unlock(&rsp->onofflock);  /* irqs remain disabled. */
 }
 
 /*
@@ -925,10 +947,10 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 	unsigned long flags;
 	struct rcu_data *rdp;
 
-	spin_lock_irqsave(&rsp->onofflock, flags);
+	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 	rdp = rsp->rda[smp_processor_id()];
 	if (rsp->orphan_cbs_list == NULL) {
-		spin_unlock_irqrestore(&rsp->onofflock, flags);
+		raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 		return;
 	}
 	*rdp->nxttail[RCU_NEXT_TAIL] = rsp->orphan_cbs_list;
@@ -937,7 +959,7 @@ static void rcu_adopt_orphan_cbs(struct rcu_state *rsp)
 	rsp->orphan_cbs_list = NULL;
 	rsp->orphan_cbs_tail = &rsp->orphan_cbs_list;
 	rsp->orphan_qlen = 0;
-	spin_unlock_irqrestore(&rsp->onofflock, flags);
+	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
 /*
@@ -953,23 +975,23 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	struct rcu_node *rnp;
 
 	/* Exclude any attempts to start a new grace period. */
-	spin_lock_irqsave(&rsp->onofflock, flags);
+	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 
 	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
 	rnp = rdp->mynode;	/* this is the outgoing CPU's rnp. */
 	mask = rdp->grpmask;	/* rnp->grplo is constant. */
 	do {
-		spin_lock(&rnp->lock);		/* irqs already disabled. */
+		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rnp->qsmaskinit &= ~mask;
 		if (rnp->qsmaskinit != 0) {
 			if (rnp != rdp->mynode)
-				spin_unlock(&rnp->lock); /* irqs remain disabled. */
+				raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 			break;
 		}
 		if (rnp == rdp->mynode)
 			need_report = rcu_preempt_offline_tasks(rsp, rnp, rdp);
 		else
-			spin_unlock(&rnp->lock); /* irqs remain disabled. */
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		mask = rnp->grpmask;
 		rnp = rnp->parent;
 	} while (rnp != NULL);
@@ -980,12 +1002,12 @@ static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
 	 * because invoking rcu_report_unblock_qs_rnp() with ->onofflock
 	 * held leads to deadlock.
 	 */
-	spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
+	raw_spin_unlock(&rsp->onofflock); /* irqs remain disabled. */
 	rnp = rdp->mynode;
 	if (need_report & RCU_OFL_TASKS_NORM_GP)
 		rcu_report_unblock_qs_rnp(rnp, flags);
 	else
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	if (need_report & RCU_OFL_TASKS_EXP_GP)
 		rcu_report_exp_rnp(rsp, rnp);
 
@@ -1144,11 +1166,9 @@ void rcu_check_callbacks(int cpu, int user)
 /*
  * Scan the leaf rcu_node structures, processing dyntick state for any that
  * have not yet encountered a quiescent state, using the function specified.
- * Returns 1 if the current grace period ends while scanning (possibly
- * because we made it end).
+ * The caller must have suppressed start of new grace periods.
  */
-static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
-			       int (*f)(struct rcu_data *))
+static void force_qs_rnp(struct rcu_state *rsp, int (*f)(struct rcu_data *))
 {
 	unsigned long bit;
 	int cpu;
@@ -1158,13 +1178,13 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 
 	rcu_for_each_leaf_node(rsp, rnp) {
 		mask = 0;
-		spin_lock_irqsave(&rnp->lock, flags);
-		if (rnp->completed != lastcomp) {
-			spin_unlock_irqrestore(&rnp->lock, flags);
-			return 1;
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		if (!rcu_gp_in_progress(rsp)) {
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
+			return;
 		}
 		if (rnp->qsmask == 0) {
-			spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 			continue;
 		}
 		cpu = rnp->grplo;
@@ -1173,15 +1193,14 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 			if ((rnp->qsmask & bit) != 0 && f(rsp->rda[cpu]))
 				mask |= bit;
 		}
-		if (mask != 0 && rnp->completed == lastcomp) {
+		if (mask != 0) {
 
 			/* rcu_report_qs_rnp() releases rnp->lock. */
 			rcu_report_qs_rnp(mask, rsp, rnp, flags);
 			continue;
 		}
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
-	return 0;
 }
 
 /*
@@ -1191,32 +1210,26 @@ static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
 static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 {
 	unsigned long flags;
-	long lastcomp;
 	struct rcu_node *rnp = rcu_get_root(rsp);
-	u8 signaled;
-	u8 forcenow;
 
 	if (!rcu_gp_in_progress(rsp))
 		return;  /* No grace period in progress, nothing to force. */
-	if (!spin_trylock_irqsave(&rsp->fqslock, flags)) {
+	if (!raw_spin_trylock_irqsave(&rsp->fqslock, flags)) {
 		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
 		return;	/* Someone else is already on the job. */
 	}
-	if (relaxed &&
-	    (long)(rsp->jiffies_force_qs - jiffies) >= 0)
-		goto unlock_ret; /* no emergency and done recently. */
+	if (relaxed && ULONG_CMP_GE(rsp->jiffies_force_qs, jiffies))
+		goto unlock_fqs_ret; /* no emergency and done recently. */
 	rsp->n_force_qs++;
-	spin_lock(&rnp->lock);
-	lastcomp = rsp->gpnum - 1;
-	signaled = rsp->signaled;
+	raw_spin_lock(&rnp->lock);  /* irqs already disabled */
 	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
 	if(!rcu_gp_in_progress(rsp)) {
 		rsp->n_force_qs_ngp++;
-		spin_unlock(&rnp->lock);
-		goto unlock_ret;  /* no GP in progress, time updated. */
+		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
+		goto unlock_fqs_ret;  /* no GP in progress, time updated. */
 	}
-	spin_unlock(&rnp->lock);
-	switch (signaled) {
+	rsp->fqs_active = 1;
+	switch (rsp->signaled) {
 	case RCU_GP_IDLE:
 	case RCU_GP_INIT:
 
@@ -1224,45 +1237,38 @@ static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
 
 	case RCU_SAVE_DYNTICK:
 
+		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
 		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
 			break; /* So gcc recognizes the dead code. */
 
 		/* Record dyntick-idle state. */
-		if (rcu_process_dyntick(rsp, lastcomp,
-					dyntick_save_progress_counter))
-			goto unlock_ret;
-		/* fall into next case. */
-
-	case RCU_SAVE_COMPLETED:
-
-		/* Update state, record completion counter. */
-		forcenow = 0;
-		spin_lock(&rnp->lock);
-		if (lastcomp + 1 == rsp->gpnum &&
-		    lastcomp == rsp->completed &&
-		    rsp->signaled == signaled) {
+		force_qs_rnp(rsp, dyntick_save_progress_counter);
+		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
+		if (rcu_gp_in_progress(rsp))
 			rsp->signaled = RCU_FORCE_QS;
-			rsp->completed_fqs = lastcomp;
-			forcenow = signaled == RCU_SAVE_COMPLETED;
-		}
-		spin_unlock(&rnp->lock);
-		if (!forcenow)
-			break;
-		/* fall into next case. */
+		break;
 
 	case RCU_FORCE_QS:
 
 		/* Check dyntick-idle state, send IPI to laggarts. */
-		if (rcu_process_dyntick(rsp, rsp->completed_fqs,
-					rcu_implicit_dynticks_qs))
-			goto unlock_ret;
+		raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
+		force_qs_rnp(rsp, rcu_implicit_dynticks_qs);
 
 		/* Leave state in case more forcing is required. */
 
+		raw_spin_lock(&rnp->lock);  /* irqs already disabled */
 		break;
 	}
-unlock_ret:
-	spin_unlock_irqrestore(&rsp->fqslock, flags);
+	rsp->fqs_active = 0;
+	if (rsp->fqs_need_gp) {
+		raw_spin_unlock(&rsp->fqslock); /* irqs remain disabled */
+		rsp->fqs_need_gp = 0;
+		rcu_start_gp(rsp, flags); /* releases rnp->lock */
+		return;
+	}
+	raw_spin_unlock(&rnp->lock);  /* irqs remain disabled */
+unlock_fqs_ret:
+	raw_spin_unlock_irqrestore(&rsp->fqslock, flags);
 }
 
 #else /* #ifdef CONFIG_SMP */
@@ -1290,7 +1296,7 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 	 * If an RCU GP has gone long enough, go check for dyntick
 	 * idle CPUs and, if needed, send resched IPIs.
 	 */
-	if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
+	if (ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies))
 		force_quiescent_state(rsp, 1);
 
 	/*
@@ -1304,7 +1310,7 @@ __rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Does this CPU require a not-yet-started grace period? */
 	if (cpu_needs_another_gp(rsp, rdp)) {
-		spin_lock_irqsave(&rcu_get_root(rsp)->lock, flags);
+		raw_spin_lock_irqsave(&rcu_get_root(rsp)->lock, flags);
 		rcu_start_gp(rsp, flags);  /* releases above lock */
 	}
 
@@ -1335,6 +1341,9 @@ static void rcu_process_callbacks(struct softirq_action *unused)
 	 * grace-period manipulations above.
 	 */
 	smp_mb(); /* See above block comment. */
+
+	/* If we are last CPU on way to dyntick-idle mode, accelerate it. */
+	rcu_needs_cpu_flush();
 }
 
 static void
@@ -1369,7 +1378,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 		unsigned long nestflag;
 		struct rcu_node *rnp_root = rcu_get_root(rsp);
 
-		spin_lock_irqsave(&rnp_root->lock, nestflag);
+		raw_spin_lock_irqsave(&rnp_root->lock, nestflag);
 		rcu_start_gp(rsp, nestflag);  /* releases rnp_root->lock. */
 	}
 
@@ -1387,7 +1396,7 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
 			force_quiescent_state(rsp, 0);
 		rdp->n_force_qs_snap = rsp->n_force_qs;
 		rdp->qlen_last_fqs_check = rdp->qlen;
-	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)
+	} else if (ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies))
 		force_quiescent_state(rsp, 1);
 	local_irq_restore(flags);
 }
@@ -1520,7 +1529,7 @@ static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
 
 	/* Has an RCU GP gone long enough to send resched IPIs &c? */
 	if (rcu_gp_in_progress(rsp) &&
-	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0)) {
+	    ULONG_CMP_LT(ACCESS_ONCE(rsp->jiffies_force_qs), jiffies)) {
 		rdp->n_rp_need_fqs++;
 		return 1;
 	}
@@ -1545,10 +1554,9 @@ static int rcu_pending(int cpu)
 /*
  * Check to see if any future RCU-related work will need to be done
  * by the current CPU, even if none need be done immediately, returning
- * 1 if so.  This function is part of the RCU implementation; it is -not-
- * an exported member of the RCU API.
+ * 1 if so.
  */
-int rcu_needs_cpu(int cpu)
+static int rcu_needs_cpu_quick_check(int cpu)
 {
 	/* RCU callbacks either ready or pending? */
 	return per_cpu(rcu_sched_data, cpu).nxtlist ||
@@ -1556,21 +1564,6 @@ int rcu_needs_cpu(int cpu)
 	       rcu_preempt_needs_cpu(cpu);
 }
 
-/*
- * This function is invoked towards the end of the scheduler's initialization
- * process.  Before this is called, the idle task might contain
- * RCU read-side critical sections (during which time, this idle
- * task is booting the system).  After this function is called, the
- * idle tasks are prohibited from containing RCU read-side critical
- * sections.
- */
-void rcu_scheduler_starting(void)
-{
-	WARN_ON(num_online_cpus() != 1);
-	WARN_ON(nr_context_switches() > 0);
-	rcu_scheduler_active = 1;
-}
-
 static DEFINE_PER_CPU(struct rcu_head, rcu_barrier_head) = {NULL};
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
@@ -1659,7 +1652,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
-	spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
 	rdp->nxtlist = NULL;
 	for (i = 0; i < RCU_NEXT_SIZE; i++)
@@ -1669,7 +1662,7 @@ rcu_boot_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
 #endif /* #ifdef CONFIG_NO_HZ */
 	rdp->cpu = cpu;
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -1687,7 +1680,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 	struct rcu_node *rnp = rcu_get_root(rsp);
 
 	/* Set up local state, ensuring consistent view of global state. */
-	spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
 	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
 	rdp->beenonline = 1;	 /* We have now been online. */
@@ -1695,7 +1688,7 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
-	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
+	raw_spin_unlock(&rnp->lock);		/* irqs remain disabled. */
 
 	/*
 	 * A new grace period might start here.  If so, we won't be part
@@ -1703,14 +1696,14 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 	 */
 
 	/* Exclude any attempts to start a new GP on large systems. */
-	spin_lock(&rsp->onofflock);		/* irqs already disabled. */
+	raw_spin_lock(&rsp->onofflock);		/* irqs already disabled. */
 
 	/* Add CPU to rcu_node bitmasks. */
 	rnp = rdp->mynode;
 	mask = rdp->grpmask;
 	do {
 		/* Exclude any attempts to start a new GP on small systems. */
-		spin_lock(&rnp->lock);	/* irqs already disabled. */
+		raw_spin_lock(&rnp->lock);	/* irqs already disabled. */
 		rnp->qsmaskinit |= mask;
 		mask = rnp->grpmask;
 		if (rnp == rdp->mynode) {
@@ -1718,11 +1711,11 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp, int preemptable)
 			rdp->completed = rnp->completed;
 			rdp->passed_quiesc_completed = rnp->completed - 1;
 		}
-		spin_unlock(&rnp->lock); /* irqs already disabled. */
+		raw_spin_unlock(&rnp->lock); /* irqs already disabled. */
 		rnp = rnp->parent;
 	} while (rnp != NULL && !(rnp->qsmaskinit & mask));
 
-	spin_unlock_irqrestore(&rsp->onofflock, flags);
+	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 }
 
 static void __cpuinit rcu_online_cpu(int cpu)
@@ -1806,11 +1799,17 @@ static void __init rcu_init_levelspread(struct rcu_state *rsp)
  */
 static void __init rcu_init_one(struct rcu_state *rsp)
 {
+	static char *buf[] = { "rcu_node_level_0",
+			       "rcu_node_level_1",
+			       "rcu_node_level_2",
+			       "rcu_node_level_3" };  /* Match MAX_RCU_LVLS */
 	int cpustride = 1;
 	int i;
 	int j;
 	struct rcu_node *rnp;
 
+	BUILD_BUG_ON(MAX_RCU_LVLS > ARRAY_SIZE(buf));  /* Fix buf[] init! */
+
 	/* Initialize the level-tracking arrays. */
 
 	for (i = 1; i < NUM_RCU_LVLS; i++)
@@ -1823,8 +1822,9 @@ static void __init rcu_init_one(struct rcu_state *rsp)
 		cpustride *= rsp->levelspread[i];
 		rnp = rsp->level[i];
 		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
-			spin_lock_init(&rnp->lock);
-			lockdep_set_class(&rnp->lock, &rcu_node_class[i]);
+			raw_spin_lock_init(&rnp->lock);
+			lockdep_set_class_and_name(&rnp->lock,
+						   &rcu_node_class[i], buf[i]);
 			rnp->gpnum = 0;
 			rnp->qsmask = 0;
 			rnp->qsmaskinit = 0;
@@ -1876,7 +1876,7 @@ do { \
 
 void __init rcu_init(void)
 {
-	int i;
+	int cpu;
 
 	rcu_bootup_announce();
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
@@ -1896,8 +1896,8 @@ void __init rcu_init(void)
 	 * or the scheduler are operational.
 	 */
 	cpu_notifier(rcu_cpu_notify, 0);
-	for_each_online_cpu(i)
-		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)i);
+	for_each_online_cpu(cpu)
+		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
 }
 
 #include "rcutree_plugin.h"
diff --git a/kernel/rcutree.h b/kernel/rcutree.h
index d2a0046..1439eb5 100644
--- a/kernel/rcutree.h
+++ b/kernel/rcutree.h
@@ -90,12 +90,12 @@ struct rcu_dynticks {
  * Definition for node within the RCU grace-period-detection hierarchy.
  */
 struct rcu_node {
-	spinlock_t lock;	/* Root rcu_node's lock protects some */
+	raw_spinlock_t lock;	/* Root rcu_node's lock protects some */
 				/*  rcu_state fields as well as following. */
-	long	gpnum;		/* Current grace period for this node. */
+	unsigned long gpnum;	/* Current grace period for this node. */
 				/*  This will either be equal to or one */
 				/*  behind the root rcu_node's gpnum. */
-	long	completed;	/* Last grace period completed for this node. */
+	unsigned long completed; /* Last GP completed for this node. */
 				/*  This will either be equal to or one */
 				/*  behind the root rcu_node's gpnum. */
 	unsigned long qsmask;	/* CPUs or groups that need to switch in */
@@ -161,11 +161,11 @@ struct rcu_node {
 /* Per-CPU data for read-copy update. */
 struct rcu_data {
 	/* 1) quiescent-state and grace-period handling : */
-	long		completed;	/* Track rsp->completed gp number */
+	unsigned long	completed;	/* Track rsp->completed gp number */
 					/*  in order to detect GP end. */
-	long		gpnum;		/* Highest gp number that this CPU */
+	unsigned long	gpnum;		/* Highest gp number that this CPU */
 					/*  is aware of having started. */
-	long		passed_quiesc_completed;
+	unsigned long	passed_quiesc_completed;
 					/* Value of completed at time of qs. */
 	bool		passed_quiesc;	/* User-mode/idle loop etc. */
 	bool		qs_pending;	/* Core waits for quiesc state. */
@@ -221,14 +221,14 @@ struct rcu_data {
 	unsigned long resched_ipi;	/* Sent a resched IPI. */
 
 	/* 5) __rcu_pending() statistics. */
-	long n_rcu_pending;		/* rcu_pending() calls since boot. */
-	long n_rp_qs_pending;
-	long n_rp_cb_ready;
-	long n_rp_cpu_needs_gp;
-	long n_rp_gp_completed;
-	long n_rp_gp_started;
-	long n_rp_need_fqs;
-	long n_rp_need_nothing;
+	unsigned long n_rcu_pending;	/* rcu_pending() calls since boot. */
+	unsigned long n_rp_qs_pending;
+	unsigned long n_rp_cb_ready;
+	unsigned long n_rp_cpu_needs_gp;
+	unsigned long n_rp_gp_completed;
+	unsigned long n_rp_gp_started;
+	unsigned long n_rp_need_fqs;
+	unsigned long n_rp_need_nothing;
 
 	int cpu;
 };
@@ -237,12 +237,11 @@ struct rcu_data {
 #define RCU_GP_IDLE		0	/* No grace period in progress. */
 #define RCU_GP_INIT		1	/* Grace period being initialized. */
 #define RCU_SAVE_DYNTICK	2	/* Need to scan dyntick state. */
-#define RCU_SAVE_COMPLETED	3	/* Need to save rsp->completed. */
-#define RCU_FORCE_QS		4	/* Need to force quiescent state. */
+#define RCU_FORCE_QS		3	/* Need to force quiescent state. */
 #ifdef CONFIG_NO_HZ
 #define RCU_SIGNAL_INIT		RCU_SAVE_DYNTICK
 #else /* #ifdef CONFIG_NO_HZ */
-#define RCU_SIGNAL_INIT		RCU_SAVE_COMPLETED
+#define RCU_SIGNAL_INIT		RCU_FORCE_QS
 #endif /* #else #ifdef CONFIG_NO_HZ */
 
 #define RCU_JIFFIES_TILL_FORCE_QS	 3	/* for rsp->jiffies_force_qs */
@@ -256,6 +255,9 @@ struct rcu_data {
 
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
+#define ULONG_CMP_GE(a, b)	(ULONG_MAX / 2 >= (a) - (b))
+#define ULONG_CMP_LT(a, b)	(ULONG_MAX / 2 < (a) - (b))
+
 /*
  * RCU global state, including node hierarchy.  This hierarchy is
  * represented in "heap" form in a dense array.  The root (first level)
@@ -277,12 +279,19 @@ struct rcu_state {
 
 	u8	signaled ____cacheline_internodealigned_in_smp;
 						/* Force QS state. */
-	long	gpnum;				/* Current gp number. */
-	long	completed;			/* # of last completed gp. */
+	u8	fqs_active;			/* force_quiescent_state() */
+						/*  is running. */
+	u8	fqs_need_gp;			/* A CPU was prevented from */
+						/*  starting a new grace */
+						/*  period because */
+						/*  force_quiescent_state() */
+						/*  was running. */
+	unsigned long gpnum;			/* Current gp number. */
+	unsigned long completed;		/* # of last completed gp. */
 
 	/* End of fields guarded by root rcu_node's lock. */
 
-	spinlock_t onofflock;			/* exclude on/offline and */
+	raw_spinlock_t onofflock;		/* exclude on/offline and */
 						/*  starting new GP.  Also */
 						/*  protects the following */
 						/*  orphan_cbs fields. */
@@ -292,10 +301,8 @@ struct rcu_state {
 						/*  going offline. */
 	struct rcu_head **orphan_cbs_tail;	/* And tail pointer. */
 	long orphan_qlen;			/* Number of orphaned cbs. */
-	spinlock_t fqslock;			/* Only one task forcing */
+	raw_spinlock_t fqslock;			/* Only one task forcing */
 						/*  quiescent states. */
-	long	completed_fqs;			/* Value of completed @ snap. */
-						/*  Protected by fqslock. */
 	unsigned long jiffies_force_qs;		/* Time at which to invoke */
 						/*  force_quiescent_state(). */
 	unsigned long n_force_qs;		/* Number of calls to */
@@ -319,8 +326,6 @@ struct rcu_state {
 #define RCU_OFL_TASKS_EXP_GP	0x2		/* Tasks blocking expedited */
 						/*  GP were moved to root. */
 
-#ifdef RCU_TREE_NONCORE
-
 /*
  * RCU implementation internal declarations:
  */
@@ -335,7 +340,7 @@ extern struct rcu_state rcu_preempt_state;
 DECLARE_PER_CPU(struct rcu_data, rcu_preempt_data);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
 
-#else /* #ifdef RCU_TREE_NONCORE */
+#ifndef RCU_TREE_NONCORE
 
 /* Forward declarations for rcutree_plugin.h */
 static void rcu_bootup_announce(void);
@@ -347,6 +352,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp,
 				      unsigned long flags);
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+static void rcu_print_detail_task_stall(struct rcu_state *rsp);
 static void rcu_print_task_stall(struct rcu_node *rnp);
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 static void rcu_preempt_check_blocked_tasks(struct rcu_node *rnp);
@@ -367,5 +373,6 @@ static int rcu_preempt_needs_cpu(int cpu);
 static void __cpuinit rcu_preempt_init_percpu_data(int cpu);
 static void rcu_preempt_send_cbs_to_orphanage(void);
 static void __init __rcu_init_preempt(void);
+static void rcu_needs_cpu_flush(void);
 
-#endif /* #else #ifdef RCU_TREE_NONCORE */
+#endif /* #ifndef RCU_TREE_NONCORE */
diff --git a/kernel/rcutree_plugin.h b/kernel/rcutree_plugin.h
index 37fbccd..464ad2c 100644
--- a/kernel/rcutree_plugin.h
+++ b/kernel/rcutree_plugin.h
@@ -62,6 +62,15 @@ long rcu_batches_completed(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
 /*
+ * Force a quiescent state for preemptible RCU.
+ */
+void rcu_force_quiescent_state(void)
+{
+	force_quiescent_state(&rcu_preempt_state, 0);
+}
+EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
+
+/*
  * Record a preemptable-RCU quiescent state for the specified CPU.  Note
  * that this just means that the task currently running on the CPU is
  * not in a quiescent state.  There might be any number of tasks blocked
@@ -102,7 +111,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 		/* Possibly blocking in an RCU read-side critical section. */
 		rdp = rcu_preempt_state.rda[cpu];
 		rnp = rdp->mynode;
-		spin_lock_irqsave(&rnp->lock, flags);
+		raw_spin_lock_irqsave(&rnp->lock, flags);
 		t->rcu_read_unlock_special |= RCU_READ_UNLOCK_BLOCKED;
 		t->rcu_blocked_node = rnp;
 
@@ -123,7 +132,7 @@ static void rcu_preempt_note_context_switch(int cpu)
 		WARN_ON_ONCE(!list_empty(&t->rcu_node_entry));
 		phase = (rnp->gpnum + !(rnp->qsmask & rdp->grpmask)) & 0x1;
 		list_add(&t->rcu_node_entry, &rnp->blocked_tasks[phase]);
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 
 	/*
@@ -180,7 +189,7 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 	struct rcu_node *rnp_p;
 
 	if (rnp->qsmask != 0 || rcu_preempted_readers(rnp)) {
-		spin_unlock_irqrestore(&rnp->lock, flags);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;  /* Still need more quiescent states! */
 	}
 
@@ -197,8 +206,8 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 
 	/* Report up the rest of the hierarchy. */
 	mask = rnp->grpmask;
-	spin_unlock(&rnp->lock);	/* irqs remain disabled. */
-	spin_lock(&rnp_p->lock);	/* irqs already disabled. */
+	raw_spin_unlock(&rnp->lock);	/* irqs remain disabled. */
+	raw_spin_lock(&rnp_p->lock);	/* irqs already disabled. */
 	rcu_report_qs_rnp(mask, &rcu_preempt_state, rnp_p, flags);
 }
 
@@ -248,10 +257,10 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 */
 		for (;;) {
 			rnp = t->rcu_blocked_node;
-			spin_lock(&rnp->lock);  /* irqs already disabled. */
+			raw_spin_lock(&rnp->lock);  /* irqs already disabled. */
 			if (rnp == t->rcu_blocked_node)
 				break;
-			spin_unlock(&rnp->lock);  /* irqs remain disabled. */
+			raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 		}
 		empty = !rcu_preempted_readers(rnp);
 		empty_exp = !rcu_preempted_readers_exp(rnp);
@@ -265,7 +274,7 @@ static void rcu_read_unlock_special(struct task_struct *t)
 		 * Note that rcu_report_unblock_qs_rnp() releases rnp->lock.
 		 */
 		if (empty)
-			spin_unlock_irqrestore(&rnp->lock, flags);
+			raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		else
 			rcu_report_unblock_qs_rnp(rnp, flags);
 
@@ -295,29 +304,73 @@ void __rcu_read_unlock(void)
 	if (--ACCESS_ONCE(t->rcu_read_lock_nesting) == 0 &&
 	    unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
 		rcu_read_unlock_special(t);
+#ifdef CONFIG_PROVE_LOCKING
+	WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
 }
 EXPORT_SYMBOL_GPL(__rcu_read_unlock);
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
 
+#ifdef CONFIG_RCU_CPU_STALL_VERBOSE
+
+/*
+ * Dump detailed information for all tasks blocking the current RCU
+ * grace period on the specified rcu_node structure.
+ */
+static void rcu_print_detail_task_stall_rnp(struct rcu_node *rnp)
+{
+	unsigned long flags;
+	struct list_head *lp;
+	int phase;
+	struct task_struct *t;
+
+	if (rcu_preempted_readers(rnp)) {
+		raw_spin_lock_irqsave(&rnp->lock, flags);
+		phase = rnp->gpnum & 0x1;
+		lp = &rnp->blocked_tasks[phase];
+		list_for_each_entry(t, lp, rcu_node_entry)
+			sched_show_task(t);
+		raw_spin_unlock_irqrestore(&rnp->lock, flags);
+	}
+}
+
+/*
+ * Dump detailed information for all tasks blocking the current RCU
+ * grace period.
+ */
+static void rcu_print_detail_task_stall(struct rcu_state *rsp)
+{
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	rcu_print_detail_task_stall_rnp(rnp);
+	rcu_for_each_leaf_node(rsp, rnp)
+		rcu_print_detail_task_stall_rnp(rnp);
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL_VERBOSE */
+
+static void rcu_print_detail_task_stall(struct rcu_state *rsp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_VERBOSE */
+
 /*
  * Scan the current list of tasks blocked within RCU read-side critical
  * sections, printing out the tid of each.
  */
 static void rcu_print_task_stall(struct rcu_node *rnp)
 {
-	unsigned long flags;
 	struct list_head *lp;
 	int phase;
 	struct task_struct *t;
 
 	if (rcu_preempted_readers(rnp)) {
-		spin_lock_irqsave(&rnp->lock, flags);
 		phase = rnp->gpnum & 0x1;
 		lp = &rnp->blocked_tasks[phase];
 		list_for_each_entry(t, lp, rcu_node_entry)
 			printk(" P%d", t->pid);
-		spin_unlock_irqrestore(&rnp->lock, flags);
 	}
 }
 
@@ -388,11 +441,11 @@ static int rcu_preempt_offline_tasks(struct rcu_state *rsp,
 		lp_root = &rnp_root->blocked_tasks[i];
 		while (!list_empty(lp)) {
 			tp = list_entry(lp->next, typeof(*tp), rcu_node_entry);
-			spin_lock(&rnp_root->lock); /* irqs already disabled */
+			raw_spin_lock(&rnp_root->lock); /* irqs already disabled */
 			list_del(&tp->rcu_node_entry);
 			tp->rcu_blocked_node = rnp_root;
 			list_add(&tp->rcu_node_entry, lp_root);
-			spin_unlock(&rnp_root->lock); /* irqs remain disabled */
+			raw_spin_unlock(&rnp_root->lock); /* irqs remain disabled */
 		}
 	}
 	return retval;
@@ -516,7 +569,7 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 	unsigned long flags;
 	unsigned long mask;
 
-	spin_lock_irqsave(&rnp->lock, flags);
+	raw_spin_lock_irqsave(&rnp->lock, flags);
 	for (;;) {
 		if (!sync_rcu_preempt_exp_done(rnp))
 			break;
@@ -525,12 +578,12 @@ static void rcu_report_exp_rnp(struct rcu_state *rsp, struct rcu_node *rnp)
 			break;
 		}
 		mask = rnp->grpmask;
-		spin_unlock(&rnp->lock); /* irqs remain disabled */
+		raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
 		rnp = rnp->parent;
-		spin_lock(&rnp->lock); /* irqs already disabled */
+		raw_spin_lock(&rnp->lock); /* irqs already disabled */
 		rnp->expmask &= ~mask;
 	}
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 /*
@@ -545,11 +598,11 @@ sync_rcu_preempt_exp_init(struct rcu_state *rsp, struct rcu_node *rnp)
 {
 	int must_wait;
 
-	spin_lock(&rnp->lock); /* irqs already disabled */
+	raw_spin_lock(&rnp->lock); /* irqs already disabled */
 	list_splice_init(&rnp->blocked_tasks[0], &rnp->blocked_tasks[2]);
 	list_splice_init(&rnp->blocked_tasks[1], &rnp->blocked_tasks[3]);
 	must_wait = rcu_preempted_readers_exp(rnp);
-	spin_unlock(&rnp->lock); /* irqs remain disabled */
+	raw_spin_unlock(&rnp->lock); /* irqs remain disabled */
 	if (!must_wait)
 		rcu_report_exp_rnp(rsp, rnp);
 }
@@ -594,13 +647,13 @@ void synchronize_rcu_expedited(void)
 	/* force all RCU readers onto blocked_tasks[]. */
 	synchronize_sched_expedited();
 
-	spin_lock_irqsave(&rsp->onofflock, flags);
+	raw_spin_lock_irqsave(&rsp->onofflock, flags);
 
 	/* Initialize ->expmask for all non-leaf rcu_node structures. */
 	rcu_for_each_nonleaf_node_breadth_first(rsp, rnp) {
-		spin_lock(&rnp->lock); /* irqs already disabled. */
+		raw_spin_lock(&rnp->lock); /* irqs already disabled. */
 		rnp->expmask = rnp->qsmaskinit;
-		spin_unlock(&rnp->lock); /* irqs remain disabled. */
+		raw_spin_unlock(&rnp->lock); /* irqs remain disabled. */
 	}
 
 	/* Snapshot current state of ->blocked_tasks[] lists. */
@@ -609,7 +662,7 @@ void synchronize_rcu_expedited(void)
 	if (NUM_RCU_NODES > 1)
 		sync_rcu_preempt_exp_init(rsp, rcu_get_root(rsp));
 
-	spin_unlock_irqrestore(&rsp->onofflock, flags);
+	raw_spin_unlock_irqrestore(&rsp->onofflock, flags);
 
 	/* Wait for snapshotted ->blocked_tasks[] lists to drain. */
 	rnp = rcu_get_root(rsp);
@@ -713,6 +766,16 @@ long rcu_batches_completed(void)
 EXPORT_SYMBOL_GPL(rcu_batches_completed);
 
 /*
+ * Force a quiescent state for RCU, which, because there is no preemptible
+ * RCU, becomes the same as rcu-sched.
+ */
+void rcu_force_quiescent_state(void)
+{
+	rcu_sched_force_quiescent_state();
+}
+EXPORT_SYMBOL_GPL(rcu_force_quiescent_state);
+
+/*
  * Because preemptable RCU does not exist, we never have to check for
  * CPUs being in quiescent states.
  */
@@ -734,7 +797,7 @@ static int rcu_preempted_readers(struct rcu_node *rnp)
 /* Because preemptible RCU does not exist, no quieting of tasks. */
 static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
 {
-	spin_unlock_irqrestore(&rnp->lock, flags);
+	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 }
 
 #endif /* #ifdef CONFIG_HOTPLUG_CPU */
@@ -745,6 +808,14 @@ static void rcu_report_unblock_qs_rnp(struct rcu_node *rnp, unsigned long flags)
  * Because preemptable RCU does not exist, we never have to check for
  * tasks blocked within RCU read-side critical sections.
  */
+static void rcu_print_detail_task_stall(struct rcu_state *rsp)
+{
+}
+
+/*
+ * Because preemptable RCU does not exist, we never have to check for
+ * tasks blocked within RCU read-side critical sections.
+ */
 static void rcu_print_task_stall(struct rcu_node *rnp)
 {
 }
@@ -884,3 +955,113 @@ static void __init __rcu_init_preempt(void)
 }
 
 #endif /* #else #ifdef CONFIG_TREE_PREEMPT_RCU */
+
+#if !defined(CONFIG_RCU_FAST_NO_HZ)
+
+/*
+ * Check to see if any future RCU-related work will need to be done
+ * by the current CPU, even if none need be done immediately, returning
+ * 1 if so.  This function is part of the RCU implementation; it is -not-
+ * an exported member of the RCU API.
+ *
+ * Because we have preemptible RCU, just check whether this CPU needs
+ * any flavor of RCU.  Do not chew up lots of CPU cycles with preemption
+ * disabled in a most-likely vain attempt to cause RCU not to need this CPU.
+ */
+int rcu_needs_cpu(int cpu)
+{
+	return rcu_needs_cpu_quick_check(cpu);
+}
+
+/*
+ * Check to see if we need to continue a callback-flush operations to
+ * allow the last CPU to enter dyntick-idle mode.  But fast dyntick-idle
+ * entry is not configured, so we never do need to.
+ */
+static void rcu_needs_cpu_flush(void)
+{
+}
+
+#else /* #if !defined(CONFIG_RCU_FAST_NO_HZ) */
+
+#define RCU_NEEDS_CPU_FLUSHES 5
+static DEFINE_PER_CPU(int, rcu_dyntick_drain);
+static DEFINE_PER_CPU(unsigned long, rcu_dyntick_holdoff);
+
+/*
+ * Check to see if any future RCU-related work will need to be done
+ * by the current CPU, even if none need be done immediately, returning
+ * 1 if so.  This function is part of the RCU implementation; it is -not-
+ * an exported member of the RCU API.
+ *
+ * Because we are not supporting preemptible RCU, attempt to accelerate
+ * any current grace periods so that RCU no longer needs this CPU, but
+ * only if all other CPUs are already in dynticks-idle mode.  This will
+ * allow the CPU cores to be powered down immediately, as opposed to after
+ * waiting many milliseconds for grace periods to elapse.
+ *
+ * Because it is not legal to invoke rcu_process_callbacks() with irqs
+ * disabled, we do one pass of force_quiescent_state(), then do a
+ * raise_softirq() to cause rcu_process_callbacks() to be invoked later.
+ * The per-cpu rcu_dyntick_drain variable controls the sequencing.
+ */
+int rcu_needs_cpu(int cpu)
+{
+	int c = 0;
+	int thatcpu;
+
+	/* Don't bother unless we are the last non-dyntick-idle CPU. */
+	for_each_cpu_not(thatcpu, nohz_cpu_mask)
+		if (thatcpu != cpu) {
+			per_cpu(rcu_dyntick_drain, cpu) = 0;
+			per_cpu(rcu_dyntick_holdoff, cpu) = jiffies - 1;
+			return rcu_needs_cpu_quick_check(cpu);
+		}
+
+	/* Check and update the rcu_dyntick_drain sequencing. */
+	if (per_cpu(rcu_dyntick_drain, cpu) <= 0) {
+		/* First time through, initialize the counter. */
+		per_cpu(rcu_dyntick_drain, cpu) = RCU_NEEDS_CPU_FLUSHES;
+	} else if (--per_cpu(rcu_dyntick_drain, cpu) <= 0) {
+		/* We have hit the limit, so time to give up. */
+		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
+		return rcu_needs_cpu_quick_check(cpu);
+	}
+
+	/* Do one step pushing remaining RCU callbacks through. */
+	if (per_cpu(rcu_sched_data, cpu).nxtlist) {
+		rcu_sched_qs(cpu);
+		force_quiescent_state(&rcu_sched_state, 0);
+		c = c || per_cpu(rcu_sched_data, cpu).nxtlist;
+	}
+	if (per_cpu(rcu_bh_data, cpu).nxtlist) {
+		rcu_bh_qs(cpu);
+		force_quiescent_state(&rcu_bh_state, 0);
+		c = c || per_cpu(rcu_bh_data, cpu).nxtlist;
+	}
+
+	/* If RCU callbacks are still pending, RCU still needs this CPU. */
+	if (c) {
+		raise_softirq(RCU_SOFTIRQ);
+		per_cpu(rcu_dyntick_holdoff, cpu) = jiffies;
+	}
+	return c;
+}
+
+/*
+ * Check to see if we need to continue a callback-flush operations to
+ * allow the last CPU to enter dyntick-idle mode.
+ */
+static void rcu_needs_cpu_flush(void)
+{
+	int cpu = smp_processor_id();
+	unsigned long flags;
+
+	if (per_cpu(rcu_dyntick_drain, cpu) <= 0)
+		return;
+	local_irq_save(flags);
+	(void)rcu_needs_cpu(cpu);
+	local_irq_restore(flags);
+}
+
+#endif /* #else #if !defined(CONFIG_RCU_FAST_NO_HZ) */
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
index 9d2c884..d45db2e 100644
--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -50,7 +50,7 @@ static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%3d%cc=%ld g=%ld pq=%d pqc=%ld qp=%d",
+	seq_printf(m, "%3d%cc=%lu g=%lu pq=%d pqc=%lu qp=%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
 		   rdp->completed, rdp->gpnum,
@@ -105,7 +105,7 @@ static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
 {
 	if (!rdp->beenonline)
 		return;
-	seq_printf(m, "%d,%s,%ld,%ld,%d,%ld,%d",
+	seq_printf(m, "%d,%s,%lu,%lu,%d,%lu,%d",
 		   rdp->cpu,
 		   cpu_is_offline(rdp->cpu) ? "\"N\"" : "\"Y\"",
 		   rdp->completed, rdp->gpnum,
@@ -155,13 +155,13 @@ static const struct file_operations rcudata_csv_fops = {
 
 static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
 {
-	long gpnum;
+	unsigned long gpnum;
 	int level = 0;
 	int phase;
 	struct rcu_node *rnp;
 
 	gpnum = rsp->gpnum;
-	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
+	seq_printf(m, "c=%lu g=%lu s=%d jfq=%ld j=%x "
 		      "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu oqlen=%ld\n",
 		   rsp->completed, gpnum, rsp->signaled,
 		   (long)(rsp->jiffies_force_qs - jiffies),
@@ -215,12 +215,12 @@ static const struct file_operations rcuhier_fops = {
 static int show_rcugp(struct seq_file *m, void *unused)
 {
 #ifdef CONFIG_TREE_PREEMPT_RCU
-	seq_printf(m, "rcu_preempt: completed=%ld  gpnum=%ld\n",
+	seq_printf(m, "rcu_preempt: completed=%ld  gpnum=%lu\n",
 		   rcu_preempt_state.completed, rcu_preempt_state.gpnum);
 #endif /* #ifdef CONFIG_TREE_PREEMPT_RCU */
-	seq_printf(m, "rcu_sched: completed=%ld  gpnum=%ld\n",
+	seq_printf(m, "rcu_sched: completed=%ld  gpnum=%lu\n",
 		   rcu_sched_state.completed, rcu_sched_state.gpnum);
-	seq_printf(m, "rcu_bh: completed=%ld  gpnum=%ld\n",
+	seq_printf(m, "rcu_bh: completed=%ld  gpnum=%lu\n",
 		   rcu_bh_state.completed, rcu_bh_state.gpnum);
 	return 0;
 }
diff --git a/kernel/sched.c b/kernel/sched.c
index 3a8fb30..3218f52 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -645,6 +645,11 @@ static inline int cpu_of(struct rq *rq)
 #endif
 }
 
+#define rcu_dereference_check_sched_domain(p) \
+	rcu_dereference_check((p), \
+			      rcu_read_lock_sched_held() || \
+			      lockdep_is_held(&sched_domains_mutex))
+
 /*
  * The domain tree (rq->sd) is protected by RCU's quiescent state transition.
  * See detach_destroy_domains: synchronize_sched for details.
@@ -653,7 +658,7 @@ static inline int cpu_of(struct rq *rq)
  * preempt-disabled sections.
  */
 #define for_each_domain(cpu, __sd) \
-	for (__sd = rcu_dereference(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
+	for (__sd = rcu_dereference_check_sched_domain(cpu_rq(cpu)->sd); __sd; __sd = __sd->parent)
 
 #define cpu_rq(cpu)		(&per_cpu(runqueues, (cpu)))
 #define this_rq()		(&__get_cpu_var(runqueues))
@@ -1531,7 +1536,7 @@ static unsigned long target_load(int cpu, int type)
 
 static struct sched_group *group_of(int cpu)
 {
-	struct sched_domain *sd = rcu_dereference(cpu_rq(cpu)->sd);
+	struct sched_domain *sd = rcu_dereference_sched(cpu_rq(cpu)->sd);
 
 	if (!sd)
 		return NULL;
@@ -4888,7 +4893,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 
 static inline int on_null_domain(int cpu)
 {
-	return !rcu_dereference(cpu_rq(cpu)->sd);
+	return !rcu_dereference_sched(cpu_rq(cpu)->sd);
 }
 
 /*
diff --git a/kernel/srcu.c b/kernel/srcu.c
index 818d7d9..bde4295 100644
--- a/kernel/srcu.c
+++ b/kernel/srcu.c
@@ -34,6 +34,30 @@
 #include <linux/smp.h>
 #include <linux/srcu.h>
 
+static int init_srcu_struct_fields(struct srcu_struct *sp)
+{
+	sp->completed = 0;
+	mutex_init(&sp->mutex);
+	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
+	return sp->per_cpu_ref ? 0 : -ENOMEM;
+}
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+
+int __init_srcu_struct(struct srcu_struct *sp, const char *name,
+		       struct lock_class_key *key)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/* Don't re-initialize a lock while it is held. */
+	debug_check_no_locks_freed((void *)sp, sizeof(*sp));
+	lockdep_init_map(&sp->dep_map, name, key, 0);
+#endif /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+	return init_srcu_struct_fields(sp);
+}
+EXPORT_SYMBOL_GPL(__init_srcu_struct);
+
+#else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 /**
  * init_srcu_struct - initialize a sleep-RCU structure
  * @sp: structure to initialize.
@@ -44,13 +68,12 @@
  */
 int init_srcu_struct(struct srcu_struct *sp)
 {
-	sp->completed = 0;
-	mutex_init(&sp->mutex);
-	sp->per_cpu_ref = alloc_percpu(struct srcu_struct_array);
-	return (sp->per_cpu_ref ? 0 : -ENOMEM);
+	return init_srcu_struct_fields(sp);
 }
 EXPORT_SYMBOL_GPL(init_srcu_struct);
 
+#endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
+
 /*
  * srcu_readers_active_idx -- returns approximate number of readers
  *	active on the specified rank of per-CPU counters.
@@ -100,15 +123,12 @@ void cleanup_srcu_struct(struct srcu_struct *sp)
 }
 EXPORT_SYMBOL_GPL(cleanup_srcu_struct);
 
-/**
- * srcu_read_lock - register a new reader for an SRCU-protected structure.
- * @sp: srcu_struct in which to register the new reader.
- *
+/*
  * Counts the new reader in the appropriate per-CPU element of the
  * srcu_struct.  Must be called from process context.
  * Returns an index that must be passed to the matching srcu_read_unlock().
  */
-int srcu_read_lock(struct srcu_struct *sp)
+int __srcu_read_lock(struct srcu_struct *sp)
 {
 	int idx;
 
@@ -120,31 +140,27 @@ int srcu_read_lock(struct srcu_struct *sp)
 	preempt_enable();
 	return idx;
 }
-EXPORT_SYMBOL_GPL(srcu_read_lock);
+EXPORT_SYMBOL_GPL(__srcu_read_lock);
 
-/**
- * srcu_read_unlock - unregister a old reader from an SRCU-protected structure.
- * @sp: srcu_struct in which to unregister the old reader.
- * @idx: return value from corresponding srcu_read_lock().
- *
+/*
  * Removes the count for the old reader from the appropriate per-CPU
  * element of the srcu_struct.  Note that this may well be a different
  * CPU than that which was incremented by the corresponding srcu_read_lock().
  * Must be called from process context.
  */
-void srcu_read_unlock(struct srcu_struct *sp, int idx)
+void __srcu_read_unlock(struct srcu_struct *sp, int idx)
 {
 	preempt_disable();
 	srcu_barrier();  /* ensure compiler won't misorder critical section. */
 	per_cpu_ptr(sp->per_cpu_ref, smp_processor_id())->c[idx]--;
 	preempt_enable();
 }
-EXPORT_SYMBOL_GPL(srcu_read_unlock);
+EXPORT_SYMBOL_GPL(__srcu_read_unlock);
 
 /*
  * Helper function for synchronize_srcu() and synchronize_srcu_expedited().
  */
-void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
+static void __synchronize_srcu(struct srcu_struct *sp, void (*sync_func)(void))
 {
 	int idx;
 
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 25c3ed5..4cdab45 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -499,6 +499,18 @@ config PROVE_LOCKING
 
 	 For more details, see Documentation/lockdep-design.txt.
 
+config PROVE_RCU
+	bool "RCU debugging: prove RCU correctness"
+	depends on PROVE_LOCKING
+	default n
+	help
+	 This feature enables lockdep extensions that check for correct
+	 use of RCU APIs.  This is currently under development.  Say Y
+	 if you want to debug RCU usage or help work on the PROVE_RCU
+	 feature.
+
+	 Say N if you are unsure.
+
 config LOCKDEP
 	bool
 	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
@@ -765,10 +777,22 @@ config RCU_CPU_STALL_DETECTOR
 	  CPUs are delaying the current grace period, but only when
 	  the grace period extends for excessive time periods.
 
-	  Say Y if you want RCU to perform such checks.
+	  Say N if you want to disable such checks.
+
+	  Say Y if you are unsure.
+
+config RCU_CPU_STALL_VERBOSE
+	bool "Print additional per-task information for RCU_CPU_STALL_DETECTOR"
+	depends on RCU_CPU_STALL_DETECTOR && TREE_PREEMPT_RCU
+	default n
+	help
+	  This option causes RCU to printk detailed per-task information
+	  for any tasks that are stalling the current RCU grace period.
 
 	  Say N if you are unsure.
 
+	  Say Y if you want to enable such checks.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
diff --git a/lib/debug_locks.c b/lib/debug_locks.c
index bc3b117..5bf0020 100644
--- a/lib/debug_locks.c
+++ b/lib/debug_locks.c
@@ -23,6 +23,7 @@
  * shut up after that.
  */
 int debug_locks = 1;
+EXPORT_SYMBOL_GPL(debug_locks);
 
 /*
  * The locking-testsuite uses <debug_locks_silent> to get a
diff --git a/lib/idr.c b/lib/idr.c
index 0dc7822..2eb1dca 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -504,7 +504,7 @@ void *idr_find(struct idr *idp, int id)
 	int n;
 	struct idr_layer *p;
 
-	p = rcu_dereference(idp->top);
+	p = rcu_dereference_raw(idp->top);
 	if (!p)
 		return NULL;
 	n = (p->layer+1) * IDR_BITS;
@@ -519,7 +519,7 @@ void *idr_find(struct idr *idp, int id)
 	while (n > 0 && p) {
 		n -= IDR_BITS;
 		BUG_ON(n != p->layer*IDR_BITS);
-		p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
+		p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
 	}
 	return((void *)p);
 }
@@ -552,7 +552,7 @@ int idr_for_each(struct idr *idp,
 	struct idr_layer **paa = &pa[0];
 
 	n = idp->layers * IDR_BITS;
-	p = rcu_dereference(idp->top);
+	p = rcu_dereference_raw(idp->top);
 	max = 1 << n;
 
 	id = 0;
@@ -560,7 +560,7 @@ int idr_for_each(struct idr *idp,
 		while (n > 0 && p) {
 			n -= IDR_BITS;
 			*paa++ = p;
-			p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
+			p = rcu_dereference_raw(p->ary[(id >> n) & IDR_MASK]);
 		}
 
 		if (p) {
diff --git a/lib/radix-tree.c b/lib/radix-tree.c
index 92cdd99..6b9670d 100644
--- a/lib/radix-tree.c
+++ b/lib/radix-tree.c
@@ -364,7 +364,7 @@ static void *radix_tree_lookup_element(struct radix_tree_root *root,
 	unsigned int height, shift;
 	struct radix_tree_node *node, **slot;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (node == NULL)
 		return NULL;
 
@@ -384,7 +384,7 @@ static void *radix_tree_lookup_element(struct radix_tree_root *root,
 	do {
 		slot = (struct radix_tree_node **)
 			(node->slots + ((index>>shift) & RADIX_TREE_MAP_MASK));
-		node = rcu_dereference(*slot);
+		node = rcu_dereference_raw(*slot);
 		if (node == NULL)
 			return NULL;
 
@@ -568,7 +568,7 @@ int radix_tree_tag_get(struct radix_tree_root *root,
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (node == NULL)
 		return 0;
 
@@ -602,7 +602,7 @@ int radix_tree_tag_get(struct radix_tree_root *root,
 			BUG_ON(ret && saw_unset_tag);
 			return !!ret;
 		}
-		node = rcu_dereference(node->slots[offset]);
+		node = rcu_dereference_raw(node->slots[offset]);
 		shift -= RADIX_TREE_MAP_SHIFT;
 		height--;
 	}
@@ -711,7 +711,7 @@ __lookup(struct radix_tree_node *slot, void ***results, unsigned long index,
 		}
 
 		shift -= RADIX_TREE_MAP_SHIFT;
-		slot = rcu_dereference(slot->slots[i]);
+		slot = rcu_dereference_raw(slot->slots[i]);
 		if (slot == NULL)
 			goto out;
 	}
@@ -758,7 +758,7 @@ radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 	unsigned long cur_index = first_index;
 	unsigned int ret;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
@@ -787,7 +787,7 @@ radix_tree_gang_lookup(struct radix_tree_root *root, void **results,
 			slot = *(((void ***)results)[ret + i]);
 			if (!slot)
 				continue;
-			results[ret + nr_found] = rcu_dereference(slot);
+			results[ret + nr_found] = rcu_dereference_raw(slot);
 			nr_found++;
 		}
 		ret += nr_found;
@@ -826,7 +826,7 @@ radix_tree_gang_lookup_slot(struct radix_tree_root *root, void ***results,
 	unsigned long cur_index = first_index;
 	unsigned int ret;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
@@ -915,7 +915,7 @@ __lookup_tag(struct radix_tree_node *slot, void ***results, unsigned long index,
 			}
 		}
 		shift -= RADIX_TREE_MAP_SHIFT;
-		slot = rcu_dereference(slot->slots[i]);
+		slot = rcu_dereference_raw(slot->slots[i]);
 		if (slot == NULL)
 			break;
 	}
@@ -951,7 +951,7 @@ radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
@@ -980,7 +980,7 @@ radix_tree_gang_lookup_tag(struct radix_tree_root *root, void **results,
 			slot = *(((void ***)results)[ret + i]);
 			if (!slot)
 				continue;
-			results[ret + nr_found] = rcu_dereference(slot);
+			results[ret + nr_found] = rcu_dereference_raw(slot);
 			nr_found++;
 		}
 		ret += nr_found;
@@ -1020,7 +1020,7 @@ radix_tree_gang_lookup_tag_slot(struct radix_tree_root *root, void ***results,
 	if (!root_tag_get(root, tag))
 		return 0;
 
-	node = rcu_dereference(root->rnode);
+	node = rcu_dereference_raw(root->rnode);
 	if (!node)
 		return 0;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index ec87421..bb1f1da 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2041,7 +2041,7 @@ gso:
 	rcu_read_lock_bh();
 
 	txq = dev_pick_tx(dev, skb);
-	q = rcu_dereference(txq->qdisc);
+	q = rcu_dereference_bh(txq->qdisc);
 
 #ifdef CONFIG_NET_CLS_ACT
 	skb->tc_verd = SET_TC_AT(skb->tc_verd, AT_EGRESS);
diff --git a/net/core/filter.c b/net/core/filter.c
index 08db7b9..3541aa4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -86,7 +86,7 @@ int sk_filter(struct sock *sk, struct sk_buff *skb)
 		return err;
 
 	rcu_read_lock_bh();
-	filter = rcu_dereference(sk->sk_filter);
+	filter = rcu_dereference_bh(sk->sk_filter);
 	if (filter) {
 		unsigned int pkt_len = sk_run_filter(skb, filter->insns,
 				filter->len);
@@ -521,7 +521,7 @@ int sk_attach_filter(struct sock_fprog *fprog, struct sock *sk)
 	}
 
 	rcu_read_lock_bh();
-	old_fp = rcu_dereference(sk->sk_filter);
+	old_fp = rcu_dereference_bh(sk->sk_filter);
 	rcu_assign_pointer(sk->sk_filter, fp);
 	rcu_read_unlock_bh();
 
@@ -536,7 +536,7 @@ int sk_detach_filter(struct sock *sk)
 	struct sk_filter *filter;
 
 	rcu_read_lock_bh();
-	filter = rcu_dereference(sk->sk_filter);
+	filter = rcu_dereference_bh(sk->sk_filter);
 	if (filter) {
 		rcu_assign_pointer(sk->sk_filter, NULL);
 		sk_filter_delayed_uncharge(sk, filter);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 794bcb8..4c7d3f6 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -89,6 +89,14 @@ int rtnl_is_locked(void)
 }
 EXPORT_SYMBOL(rtnl_is_locked);
 
+#ifdef CONFIG_PROVE_LOCKING
+int lockdep_rtnl_is_held(void)
+{
+	return lockdep_is_held(&rtnl_mutex);
+}
+EXPORT_SYMBOL(lockdep_rtnl_is_held);
+#endif /* #ifdef CONFIG_PROVE_LOCKING */
+
 static struct rtnl_link *rtnl_msg_handlers[NPROTO];
 
 static inline int rtm_msgindex(int msgtype)
diff --git a/net/core/sock.c b/net/core/sock.c
index e1f6f22..305cba4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1073,7 +1073,8 @@ static void __sk_free(struct sock *sk)
 	if (sk->sk_destruct)
 		sk->sk_destruct(sk);
 
-	filter = rcu_dereference(sk->sk_filter);
+	filter = rcu_dereference_check(sk->sk_filter,
+				       atomic_read(&sk->sk_wmem_alloc) == 0);
 	if (filter) {
 		sk_filter_uncharge(sk, filter);
 		rcu_assign_pointer(sk->sk_filter, NULL);
diff --git a/net/decnet/dn_route.c b/net/decnet/dn_route.c
index a032840..a7bf03c 100644
--- a/net/decnet/dn_route.c
+++ b/net/decnet/dn_route.c
@@ -1155,8 +1155,8 @@ static int __dn_route_output_key(struct dst_entry **pprt, const struct flowi *fl
 
 	if (!(flags & MSG_TRYHARD)) {
 		rcu_read_lock_bh();
-		for(rt = rcu_dereference(dn_rt_hash_table[hash].chain); rt;
-			rt = rcu_dereference(rt->u.dst.dn_next)) {
+		for (rt = rcu_dereference_bh(dn_rt_hash_table[hash].chain); rt;
+			rt = rcu_dereference_bh(rt->u.dst.dn_next)) {
 			if ((flp->fld_dst == rt->fl.fld_dst) &&
 			    (flp->fld_src == rt->fl.fld_src) &&
 			    (flp->mark == rt->fl.mark) &&
@@ -1618,9 +1618,9 @@ int dn_cache_dump(struct sk_buff *skb, struct netlink_callback *cb)
 		if (h > s_h)
 			s_idx = 0;
 		rcu_read_lock_bh();
-		for(rt = rcu_dereference(dn_rt_hash_table[h].chain), idx = 0;
+		for(rt = rcu_dereference_bh(dn_rt_hash_table[h].chain), idx = 0;
 			rt;
-			rt = rcu_dereference(rt->u.dst.dn_next), idx++) {
+			rt = rcu_dereference_bh(rt->u.dst.dn_next), idx++) {
 			if (idx < s_idx)
 				continue;
 			skb_dst_set(skb, dst_clone(&rt->u.dst));
@@ -1654,12 +1654,12 @@ static struct dn_route *dn_rt_cache_get_first(struct seq_file *seq)
 
 	for(s->bucket = dn_rt_hash_mask; s->bucket >= 0; --s->bucket) {
 		rcu_read_lock_bh();
-		rt = dn_rt_hash_table[s->bucket].chain;
+		rt = rcu_dereference_bh(dn_rt_hash_table[s->bucket].chain);
 		if (rt)
 			break;
 		rcu_read_unlock_bh();
 	}
-	return rcu_dereference(rt);
+	return rt;
 }
 
 static struct dn_route *dn_rt_cache_get_next(struct seq_file *seq, struct dn_route *rt)
@@ -1674,7 +1674,7 @@ static struct dn_route *dn_rt_cache_get_next(struct seq_file *seq, struct dn_rou
 		rcu_read_lock_bh();
 		rt = dn_rt_hash_table[s->bucket].chain;
 	}
-	return rcu_dereference(rt);
+	return rcu_dereference_bh(rt);
 }
 
 static void *dn_rt_cache_seq_start(struct seq_file *seq, loff_t *pos)
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index d62b05d..4f11faa 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -287,12 +287,12 @@ static struct rtable *rt_cache_get_first(struct seq_file *seq)
 		if (!rt_hash_table[st->bucket].chain)
 			continue;
 		rcu_read_lock_bh();
-		r = rcu_dereference(rt_hash_table[st->bucket].chain);
+		r = rcu_dereference_bh(rt_hash_table[st->bucket].chain);
 		while (r) {
 			if (dev_net(r->u.dst.dev) == seq_file_net(seq) &&
 			    r->rt_genid == st->genid)
 				return r;
-			r = rcu_dereference(r->u.dst.rt_next);
+			r = rcu_dereference_bh(r->u.dst.rt_next);
 		}
 		rcu_read_unlock_bh();
 	}
@@ -314,7 +314,7 @@ static struct rtable *__rt_cache_get_next(struct seq_file *seq,
 		rcu_read_lock_bh();
 		r = rt_hash_table[st->bucket].chain;
 	}
-	return rcu_dereference(r);
+	return rcu_dereference_bh(r);
 }
 
 static struct rtable *rt_cache_get_next(struct seq_file *seq,
@@ -2689,8 +2689,8 @@ int __ip_route_output_key(struct net *net, struct rtable **rp,
 	hash = rt_hash(flp->fl4_dst, flp->fl4_src, flp->oif, rt_genid(net));
 
 	rcu_read_lock_bh();
-	for (rth = rcu_dereference(rt_hash_table[hash].chain); rth;
-		rth = rcu_dereference(rth->u.dst.rt_next)) {
+	for (rth = rcu_dereference_bh(rt_hash_table[hash].chain); rth;
+		rth = rcu_dereference_bh(rth->u.dst.rt_next)) {
 		if (rth->fl.fl4_dst == flp->fl4_dst &&
 		    rth->fl.fl4_src == flp->fl4_src &&
 		    rth->fl.iif == 0 &&
@@ -3008,8 +3008,8 @@ int ip_rt_dump(struct sk_buff *skb,  struct netlink_callback *cb)
 		if (!rt_hash_table[h].chain)
 			continue;
 		rcu_read_lock_bh();
-		for (rt = rcu_dereference(rt_hash_table[h].chain), idx = 0; rt;
-		     rt = rcu_dereference(rt->u.dst.rt_next), idx++) {
+		for (rt = rcu_dereference_bh(rt_hash_table[h].chain), idx = 0; rt;
+		     rt = rcu_dereference_bh(rt->u.dst.rt_next), idx++) {
 			if (!net_eq(dev_net(rt->u.dst.dev), net) || idx < s_idx)
 				continue;
 			if (rt_is_expired(rt))
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index f126d18..939471e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -508,7 +508,7 @@ static inline unsigned int run_filter(struct sk_buff *skb, struct sock *sk,
 	struct sk_filter *filter;
 
 	rcu_read_lock_bh();
-	filter = rcu_dereference(sk->sk_filter);
+	filter = rcu_dereference_bh(sk->sk_filter);
 	if (filter != NULL)
 		res = sk_run_filter(skb, filter->insns, filter->len);
 	rcu_read_unlock_bh();
diff --git a/security/keys/gc.c b/security/keys/gc.c
index 4770be3..1990231 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -77,7 +77,8 @@ static bool key_gc_keyring(struct key *keyring, time_t limit)
 		goto dont_gc;
 
 	/* scan the keyring looking for dead keys */
-	klist = rcu_dereference(keyring->payload.subscriptions);
+	klist = rcu_dereference_check(keyring->payload.subscriptions,
+				      lockdep_is_held(&key_serial_lock));
 	if (!klist)
 		goto dont_gc;
 
diff --git a/security/keys/keyring.c b/security/keys/keyring.c
index 8ec0274..e814d21 100644
--- a/security/keys/keyring.c
+++ b/security/keys/keyring.c
@@ -151,7 +151,9 @@ static void keyring_destroy(struct key *keyring)
 		write_unlock(&keyring_name_lock);
 	}
 
-	klist = rcu_dereference(keyring->payload.subscriptions);
+	klist = rcu_dereference_check(keyring->payload.subscriptions,
+				      rcu_read_lock_held() ||
+				      atomic_read(&keyring->usage) == 0);
 	if (klist) {
 		for (loop = klist->nkeys - 1; loop >= 0; loop--)
 			key_put(klist->keys[loop]);
