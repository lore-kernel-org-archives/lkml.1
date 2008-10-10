Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbYJJAYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbYJJAYu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 20:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753352AbYJJAYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 20:24:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37083 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbYJJAYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 20:24:39 -0400
Date: Fri, 10 Oct 2008 02:24:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [git pull] scheduler updates for v2.6.28
Message-ID: <20081010002422.GA21150@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest sched-v28-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git sched-v28-for-linus

 Thanks,

	Ingo

------------------>
Amit K. Arora (1):
      sched: minor optimizations in wake_affine and select_task_rq_fair

Andrew Morton (1):
      sched: clarify ifdef tangle

Bharata B Rao (2):
      sched: call resched_task() conditionally from new task wake up path
      sched: maintain only task entities in cfs_rq->tasks list

Chris Friesen (1):
      sched: fix list traversal to use _rcu variant

Claudio Scordino (1):
      sched: new documentation about CFS

Dario Faggioli (1):
      sched_rt.c: resch needed in rt_rq_enqueue() for the root rt_rq

Frederic Weisbecker (1):
      cpusets: scan_for_empty_cpusets(), cpuset doesn't seem to be so const

Gautham R Shenoy (1):
      sched: fix __load_balance_iterator() for cfq with only one task

Ingo Molnar (4):
      sched: clean up __might_sleep()
      sched: extract walk_tg_tree(), fix
      sched: turn off WAKEUP_OVERLAP
      sched debug: add name to sched_domain sysctl entries

Joe Korty (1):
      make might_sleep() display the oopsing process

Kevin Diggs (1):
      sched: add kernel doc for the completion, fix kernel-doc-nano-HOWTO.txt

Krzysztof Helt (1):
      sched: compilation fix with gcc 3.4.6

Li Zefan (1):
      sched: remove redundant code in cpu_cgroup_create()

Manfred Spraul (2):
      kernel/cpu.c: Move the CPU_DYING notifiers
      kernel/cpu.c: create a CPU_STARTING cpu_chain notifier

Martin Steigerwald (1):
      CFS scheduler: documentation about scheduling policies

Oleg Nesterov (3):
      sched: do_wait_for_common: use signal_pending_state()
      wait_task_inactive(): don't consider task->nivcsw
      wait_task_inactive: "improve" the returned value for ->nvcsw == 0

Peter Zijlstra (12):
      sched: rt-bandwidth for user grouping interface
      sched: rt-bandwidth accounting fix
      sched: rt-bandwidth group disable fixes
      sched: extract walk_tg_tree()
      sched: rt-bandwidth fixes
      sched: wakeup preempt when small overlap
      sched: rework wakeup preemption
      sched: fixlet for group load balance
      sched: add some comments to the bandwidth code
      sched: more sanity checks on the bandwidth settings
      sched: fixup buddy selection
      sched: sync wakeups vs avg_overlap

Richard Kennedy (3):
      sched: reorder signal_struct to remove 8 bytes on 64 bit builds
      sched: reorder struct sched_rt_entity to remove padding on 64 bit builds
      reorder struct prop_local_single to remove padding on 64 bit builds


 Documentation/kernel-doc-nano-HOWTO.txt      |    4 +-
 Documentation/scheduler/sched-design-CFS.txt |  395 ++++++++++++++++----------
 arch/alpha/kernel/smp.c                      |    3 +
 arch/arm/kernel/smp.c                        |    1 +
 arch/cris/arch-v32/kernel/smp.c              |    1 +
 arch/ia64/kernel/smpboot.c                   |    1 +
 arch/m32r/kernel/smpboot.c                   |    2 +
 arch/mips/kernel/smp.c                       |    2 +
 arch/powerpc/kernel/smp.c                    |    1 +
 arch/s390/kernel/smp.c                       |    2 +
 arch/sh/kernel/smp.c                         |    2 +
 arch/sparc/kernel/sun4d_smp.c                |    1 +
 arch/sparc/kernel/sun4m_smp.c                |    2 +
 arch/um/kernel/smp.c                         |    1 +
 arch/x86/kernel/smpboot.c                    |    1 +
 arch/x86/mach-voyager/voyager_smp.c          |    2 +
 include/linux/completion.h                   |   41 +++
 include/linux/cpu.h                          |    1 +
 include/linux/notifier.h                     |   10 +-
 include/linux/proportions.h                  |    2 +-
 include/linux/sched.h                        |    9 +-
 kernel/cpu.c                                 |   24 ++-
 kernel/cpuset.c                              |    2 +-
 kernel/sched.c                               |  377 ++++++++++++++++---------
 kernel/sched_fair.c                          |  234 ++++------------
 kernel/sched_features.h                      |    1 +
 kernel/sched_idletask.c                      |    6 +-
 kernel/sched_rt.c                            |   57 ++++-
 kernel/user.c                                |    4 +-
 29 files changed, 702 insertions(+), 487 deletions(-)

diff --git a/Documentation/kernel-doc-nano-HOWTO.txt b/Documentation/kernel-doc-nano-HOWTO.txt
index 0bd3274..c6841ee 100644
--- a/Documentation/kernel-doc-nano-HOWTO.txt
+++ b/Documentation/kernel-doc-nano-HOWTO.txt
@@ -168,10 +168,10 @@ if ($#ARGV < 0) {
 mkdir $ARGV[0],0777;
 $state = 0;
 while (<STDIN>) {
-    if (/^\.TH \"[^\"]*\" 4 \"([^\"]*)\"/) {
+    if (/^\.TH \"[^\"]*\" 9 \"([^\"]*)\"/) {
 	if ($state == 1) { close OUT }
 	$state = 1;
-	$fn = "$ARGV[0]/$1.4";
+	$fn = "$ARGV[0]/$1.9";
 	print STDERR "Creating $fn\n";
 	open OUT, ">$fn" or die "can't open $fn: $!\n";
 	print OUT $_;
diff --git a/Documentation/scheduler/sched-design-CFS.txt b/Documentation/scheduler/sched-design-CFS.txt
index 88bcb87..9d8eb55 100644
--- a/Documentation/scheduler/sched-design-CFS.txt
+++ b/Documentation/scheduler/sched-design-CFS.txt
@@ -1,151 +1,242 @@
+                      =============
+                      CFS Scheduler
+                      =============
 
-This is the CFS scheduler.
-
-80% of CFS's design can be summed up in a single sentence: CFS basically
-models an "ideal, precise multi-tasking CPU" on real hardware.
-
-"Ideal multi-tasking CPU" is a (non-existent  :-))  CPU that has 100%
-physical power and which can run each task at precise equal speed, in
-parallel, each at 1/nr_running speed. For example: if there are 2 tasks
-running then it runs each at 50% physical power - totally in parallel.
-
-On real hardware, we can run only a single task at once, so while that
-one task runs, the other tasks that are waiting for the CPU are at a
-disadvantage - the current task gets an unfair amount of CPU time. In
-CFS this fairness imbalance is expressed and tracked via the per-task
-p->wait_runtime (nanosec-unit) value. "wait_runtime" is the amount of
-time the task should now run on the CPU for it to become completely fair
-and balanced.
-
-( small detail: on 'ideal' hardware, the p->wait_runtime value would
-  always be zero - no task would ever get 'out of balance' from the
-  'ideal' share of CPU time. )
-
-CFS's task picking logic is based on this p->wait_runtime value and it
-is thus very simple: it always tries to run the task with the largest
-p->wait_runtime value. In other words, CFS tries to run the task with
-the 'gravest need' for more CPU time. So CFS always tries to split up
-CPU time between runnable tasks as close to 'ideal multitasking
-hardware' as possible.
-
-Most of the rest of CFS's design just falls out of this really simple
-concept, with a few add-on embellishments like nice levels,
-multiprocessing and various algorithm variants to recognize sleepers.
-
-In practice it works like this: the system runs a task a bit, and when
-the task schedules (or a scheduler tick happens) the task's CPU usage is
-'accounted for': the (small) time it just spent using the physical CPU
-is deducted from p->wait_runtime. [minus the 'fair share' it would have
-gotten anyway]. Once p->wait_runtime gets low enough so that another
-task becomes the 'leftmost task' of the time-ordered rbtree it maintains
-(plus a small amount of 'granularity' distance relative to the leftmost
-task so that we do not over-schedule tasks and trash the cache) then the
-new leftmost task is picked and the current task is preempted.
-
-The rq->fair_clock value tracks the 'CPU time a runnable task would have
-fairly gotten, had it been runnable during that time'. So by using
-rq->fair_clock values we can accurately timestamp and measure the
-'expected CPU time' a task should have gotten. All runnable tasks are
-sorted in the rbtree by the "rq->fair_clock - p->wait_runtime" key, and
-CFS picks the 'leftmost' task and sticks to it. As the system progresses
-forwards, newly woken tasks are put into the tree more and more to the
-right - slowly but surely giving a chance for every task to become the
-'leftmost task' and thus get on the CPU within a deterministic amount of
-time.
-
-Some implementation details:
-
- - the introduction of Scheduling Classes: an extensible hierarchy of
-   scheduler modules. These modules encapsulate scheduling policy
-   details and are handled by the scheduler core without the core
-   code assuming about them too much.
-
- - sched_fair.c implements the 'CFS desktop scheduler': it is a
-   replacement for the vanilla scheduler's SCHED_OTHER interactivity
-   code.
-
-   I'd like to give credit to Con Kolivas for the general approach here:
-   he has proven via RSDL/SD that 'fair scheduling' is possible and that
-   it results in better desktop scheduling. Kudos Con!
-
-   The CFS patch uses a completely different approach and implementation
-   from RSDL/SD. My goal was to make CFS's interactivity quality exceed
-   that of RSDL/SD, which is a high standard to meet :-) Testing
-   feedback is welcome to decide this one way or another. [ and, in any
-   case, all of SD's logic could be added via a kernel/sched_sd.c module
-   as well, if Con is interested in such an approach. ]
-
-   CFS's design is quite radical: it does not use runqueues, it uses a
-   time-ordered rbtree to build a 'timeline' of future task execution,
-   and thus has no 'array switch' artifacts (by which both the vanilla
-   scheduler and RSDL/SD are affected).
-
-   CFS uses nanosecond granularity accounting and does not rely on any
-   jiffies or other HZ detail. Thus the CFS scheduler has no notion of
-   'timeslices' and has no heuristics whatsoever. There is only one
-   central tunable (you have to switch on CONFIG_SCHED_DEBUG):
-
-         /proc/sys/kernel/sched_granularity_ns
-
-   which can be used to tune the scheduler from 'desktop' (low
-   latencies) to 'server' (good batching) workloads. It defaults to a
-   setting suitable for desktop workloads. SCHED_BATCH is handled by the
-   CFS scheduler module too.
-
-   Due to its design, the CFS scheduler is not prone to any of the
-   'attacks' that exist today against the heuristics of the stock
-   scheduler: fiftyp.c, thud.c, chew.c, ring-test.c, massive_intr.c all
-   work fine and do not impact interactivity and produce the expected
-   behavior.
-
-   the CFS scheduler has a much stronger handling of nice levels and
-   SCHED_BATCH: both types of workloads should be isolated much more
-   agressively than under the vanilla scheduler.
-
-   ( another detail: due to nanosec accounting and timeline sorting,
-     sched_yield() support is very simple under CFS, and in fact under
-     CFS sched_yield() behaves much better than under any other
-     scheduler i have tested so far. )
-
- - sched_rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler
-   way than the vanilla scheduler does. It uses 100 runqueues (for all
-   100 RT priority levels, instead of 140 in the vanilla scheduler)
-   and it needs no expired array.
-
- - reworked/sanitized SMP load-balancing: the runqueue-walking
-   assumptions are gone from the load-balancing code now, and
-   iterators of the scheduling modules are used. The balancing code got
-   quite a bit simpler as a result.
-
-
-Group scheduler extension to CFS
-================================
-
-Normally the scheduler operates on individual tasks and strives to provide
-fair CPU time to each task. Sometimes, it may be desirable to group tasks
-and provide fair CPU time to each such task group. For example, it may
-be desirable to first provide fair CPU time to each user on the system
-and then to each task belonging to a user.
-
-CONFIG_FAIR_GROUP_SCHED strives to achieve exactly that. It lets
-SCHED_NORMAL/BATCH tasks be be grouped and divides CPU time fairly among such
-groups. At present, there are two (mutually exclusive) mechanisms to group
-tasks for CPU bandwidth control purpose:
-
-	- Based on user id (CONFIG_FAIR_USER_SCHED)
-		In this option, tasks are grouped according to their user id.
-	- Based on "cgroup" pseudo filesystem (CONFIG_FAIR_CGROUP_SCHED)
-		This options lets the administrator create arbitrary groups
-		of tasks, using the "cgroup" pseudo filesystem. See
-		Documentation/cgroups.txt for more information about this
-		filesystem.
 
-Only one of these options to group tasks can be chosen and not both.
+1.  OVERVIEW
+
+CFS stands for "Completely Fair Scheduler," and is the new "desktop" process
+scheduler implemented by Ingo Molnar and merged in Linux 2.6.23.  It is the
+replacement for the previous vanilla scheduler's SCHED_OTHER interactivity
+code.
+
+80% of CFS's design can be summed up in a single sentence: CFS basically models
+an "ideal, precise multi-tasking CPU" on real hardware.
+
+"Ideal multi-tasking CPU" is a (non-existent  :-)) CPU that has 100% physical
+power and which can run each task at precise equal speed, in parallel, each at
+1/nr_running speed.  For example: if there are 2 tasks running, then it runs
+each at 50% physical power --- i.e., actually in parallel.
+
+On real hardware, we can run only a single task at once, so we have to
+introduce the concept of "virtual runtime."  The virtual runtime of a task
+specifies when its next timeslice would start execution on the ideal
+multi-tasking CPU described above.  In practice, the virtual runtime of a task
+is its actual runtime normalized to the total number of running tasks.
+
+
+
+2.  FEW IMPLEMENTATION DETAILS
+
+In CFS the virtual runtime is expressed and tracked via the per-task
+p->se.vruntime (nanosec-unit) value.  This way, it's possible to accurately
+timestamp and measure the "expected CPU time" a task should have gotten.
+
+[ small detail: on "ideal" hardware, at any time all tasks would have the same
+  p->se.vruntime value --- i.e., tasks would execute simultaneously and no task
+  would ever get "out of balance" from the "ideal" share of CPU time.  ]
+
+CFS's task picking logic is based on this p->se.vruntime value and it is thus
+very simple: it always tries to run the task with the smallest p->se.vruntime
+value (i.e., the task which executed least so far).  CFS always tries to split
+up CPU time between runnable tasks as close to "ideal multitasking hardware" as
+possible.
+
+Most of the rest of CFS's design just falls out of this really simple concept,
+with a few add-on embellishments like nice levels, multiprocessing and various
+algorithm variants to recognize sleepers.
+
+
+
+3.  THE RBTREE
+
+CFS's design is quite radical: it does not use the old data structures for the
+runqueues, but it uses a time-ordered rbtree to build a "timeline" of future
+task execution, and thus has no "array switch" artifacts (by which both the
+previous vanilla scheduler and RSDL/SD are affected).
+
+CFS also maintains the rq->cfs.min_vruntime value, which is a monotonic
+increasing value tracking the smallest vruntime among all tasks in the
+runqueue.  The total amount of work done by the system is tracked using
+min_vruntime; that value is used to place newly activated entities on the left
+side of the tree as much as possible.
+
+The total number of running tasks in the runqueue is accounted through the
+rq->cfs.load value, which is the sum of the weights of the tasks queued on the
+runqueue.
+
+CFS maintains a time-ordered rbtree, where all runnable tasks are sorted by the
+p->se.vruntime key (there is a subtraction using rq->cfs.min_vruntime to
+account for possible wraparounds).  CFS picks the "leftmost" task from this
+tree and sticks to it.
+As the system progresses forwards, the executed tasks are put into the tree
+more and more to the right --- slowly but surely giving a chance for every task
+to become the "leftmost task" and thus get on the CPU within a deterministic
+amount of time.
+
+Summing up, CFS works like this: it runs a task a bit, and when the task
+schedules (or a scheduler tick happens) the task's CPU usage is "accounted
+for": the (small) time it just spent using the physical CPU is added to
+p->se.vruntime.  Once p->se.vruntime gets high enough so that another task
+becomes the "leftmost task" of the time-ordered rbtree it maintains (plus a
+small amount of "granularity" distance relative to the leftmost task so that we
+do not over-schedule tasks and trash the cache), then the new leftmost task is
+picked and the current task is preempted.
+
+
+
+4.  SOME FEATURES OF CFS
+
+CFS uses nanosecond granularity accounting and does not rely on any jiffies or
+other HZ detail.  Thus the CFS scheduler has no notion of "timeslices" in the
+way the previous scheduler had, and has no heuristics whatsoever.  There is
+only one central tunable (you have to switch on CONFIG_SCHED_DEBUG):
+
+   /proc/sys/kernel/sched_granularity_ns
+
+which can be used to tune the scheduler from "desktop" (i.e., low latencies) to
+"server" (i.e., good batching) workloads.  It defaults to a setting suitable
+for desktop workloads.  SCHED_BATCH is handled by the CFS scheduler module too.
+
+Due to its design, the CFS scheduler is not prone to any of the "attacks" that
+exist today against the heuristics of the stock scheduler: fiftyp.c, thud.c,
+chew.c, ring-test.c, massive_intr.c all work fine and do not impact
+interactivity and produce the expected behavior.
+
+The CFS scheduler has a much stronger handling of nice levels and SCHED_BATCH
+than the previous vanilla scheduler: both types of workloads are isolated much
+more aggressively.
+
+SMP load-balancing has been reworked/sanitized: the runqueue-walking
+assumptions are gone from the load-balancing code now, and iterators of the
+scheduling modules are used.  The balancing code got quite a bit simpler as a
+result.
+
+
+
+5. Scheduling policies
+
+CFS implements three scheduling policies:
+
+  - SCHED_NORMAL (traditionally called SCHED_OTHER): The scheduling
+    policy that is used for regular tasks.
+
+  - SCHED_BATCH: Does not preempt nearly as often as regular tasks
+    would, thereby allowing tasks to run longer and make better use of
+    caches but at the cost of interactivity. This is well suited for
+    batch jobs.
+
+  - SCHED_IDLE: This is even weaker than nice 19, but its not a true
+    idle timer scheduler in order to avoid to get into priority
+    inversion problems which would deadlock the machine.
+
+SCHED_FIFO/_RR are implemented in sched_rt.c and are as specified by
+POSIX.
+
+The command chrt from util-linux-ng 2.13.1.1 can set all of these except
+SCHED_IDLE.
 
-Group scheduler tunables:
 
-When CONFIG_FAIR_USER_SCHED is defined, a directory is created in sysfs for
-each new user and a "cpu_share" file is added in that directory.
+
+6.  SCHEDULING CLASSES
+
+The new CFS scheduler has been designed in such a way to introduce "Scheduling
+Classes," an extensible hierarchy of scheduler modules.  These modules
+encapsulate scheduling policy details and are handled by the scheduler core
+without the core code assuming too much about them.
+
+sched_fair.c implements the CFS scheduler described above.
+
+sched_rt.c implements SCHED_FIFO and SCHED_RR semantics, in a simpler way than
+the previous vanilla scheduler did.  It uses 100 runqueues (for all 100 RT
+priority levels, instead of 140 in the previous scheduler) and it needs no
+expired array.
+
+Scheduling classes are implemented through the sched_class structure, which
+contains hooks to functions that must be called whenever an interesting event
+occurs.
+
+This is the (partial) list of the hooks:
+
+ - enqueue_task(...)
+
+   Called when a task enters a runnable state.
+   It puts the scheduling entity (task) into the red-black tree and
+   increments the nr_running variable.
+
+ - dequeue_tree(...)
+
+   When a task is no longer runnable, this function is called to keep the
+   corresponding scheduling entity out of the red-black tree.  It decrements
+   the nr_running variable.
+
+ - yield_task(...)
+
+   This function is basically just a dequeue followed by an enqueue, unless the
+   compat_yield sysctl is turned on; in that case, it places the scheduling
+   entity at the right-most end of the red-black tree.
+
+ - check_preempt_curr(...)
+
+   This function checks if a task that entered the runnable state should
+   preempt the currently running task.
+
+ - pick_next_task(...)
+
+   This function chooses the most appropriate task eligible to run next.
+
+ - set_curr_task(...)
+
+   This function is called when a task changes its scheduling class or changes
+   its task group.
+
+ - task_tick(...)
+
+   This function is mostly called from time tick functions; it might lead to
+   process switch.  This drives the running preemption.
+
+ - task_new(...)
+
+   The core scheduler gives the scheduling module an opportunity to manage new
+   task startup.  The CFS scheduling module uses it for group scheduling, while
+   the scheduling module for a real-time task does not use it.
+
+
+
+7.  GROUP SCHEDULER EXTENSIONS TO CFS
+
+Normally, the scheduler operates on individual tasks and strives to provide
+fair CPU time to each task.  Sometimes, it may be desirable to group tasks and
+provide fair CPU time to each such task group.  For example, it may be
+desirable to first provide fair CPU time to each user on the system and then to
+each task belonging to a user.
+
+CONFIG_GROUP_SCHED strives to achieve exactly that.  It lets tasks to be
+grouped and divides CPU time fairly among such groups.
+
+CONFIG_RT_GROUP_SCHED permits to group real-time (i.e., SCHED_FIFO and
+SCHED_RR) tasks.
+
+CONFIG_FAIR_GROUP_SCHED permits to group CFS (i.e., SCHED_NORMAL and
+SCHED_BATCH) tasks.
+
+At present, there are two (mutually exclusive) mechanisms to group tasks for
+CPU bandwidth control purposes:
+
+ - Based on user id (CONFIG_USER_SCHED)
+
+   With this option, tasks are grouped according to their user id.
+
+ - Based on "cgroup" pseudo filesystem (CONFIG_CGROUP_SCHED)
+
+   This options needs CONFIG_CGROUPS to be defined, and lets the administrator
+   create arbitrary groups of tasks, using the "cgroup" pseudo filesystem.  See
+   Documentation/cgroups.txt for more information about this filesystem.
+
+Only one of these options to group tasks can be chosen and not both.
+
+When CONFIG_USER_SCHED is defined, a directory is created in sysfs for each new
+user and a "cpu_share" file is added in that directory.
 
 	# cd /sys/kernel/uids
 	# cat 512/cpu_share		# Display user 512's CPU share
@@ -155,16 +246,14 @@ each new user and a "cpu_share" file is added in that directory.
 	2048
 	#
 
-CPU bandwidth between two users are divided in the ratio of their CPU shares.
-For ex: if you would like user "root" to get twice the bandwidth of user
-"guest", then set the cpu_share for both the users such that "root"'s
-cpu_share is twice "guest"'s cpu_share
-
+CPU bandwidth between two users is divided in the ratio of their CPU shares.
+For example: if you would like user "root" to get twice the bandwidth of user
+"guest," then set the cpu_share for both the users such that "root"'s cpu_share
+is twice "guest"'s cpu_share.
 
-When CONFIG_FAIR_CGROUP_SCHED is defined, a "cpu.shares" file is created
-for each group created using the pseudo filesystem. See example steps
-below to create task groups and modify their CPU share using the "cgroups"
-pseudo filesystem
+When CONFIG_CGROUP_SCHED is defined, a "cpu.shares" file is created for each
+group created using the pseudo filesystem.  See example steps below to create
+task groups and modify their CPU share using the "cgroups" pseudo filesystem.
 
 	# mkdir /dev/cpuctl
 	# mount -t cgroup -ocpu none /dev/cpuctl
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 83df541..06b6fda 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -149,6 +149,9 @@ smp_callin(void)
 	atomic_inc(&init_mm.mm_count);
 	current->active_mm = &init_mm;
 
+	/* inform the notifiers about the new cpu */
+	notify_cpu_starting(cpuid);
+
 	/* Must have completely accurate bogos.  */
 	local_irq_enable();
 
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index e9842f6..e42a749 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -277,6 +277,7 @@ asmlinkage void __cpuinit secondary_start_kernel(void)
 	/*
 	 * Enable local interrupts.
 	 */
+	notify_cpu_starting(cpu);
 	local_irq_enable();
 	local_fiq_enable();
 
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 952a24b..52e16c6 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -178,6 +178,7 @@ void __init smp_callin(void)
 	unmask_irq(IPI_INTR_VECT);
 	unmask_irq(TIMER0_INTR_VECT);
 	preempt_disable();
+	notify_cpu_starting(cpu);
 	local_irq_enable();
 
 	cpu_set(cpu, cpu_online_map);
diff --git a/arch/ia64/kernel/smpboot.c b/arch/ia64/kernel/smpboot.c
index d8f05e5..1dcbb85 100644
--- a/arch/ia64/kernel/smpboot.c
+++ b/arch/ia64/kernel/smpboot.c
@@ -401,6 +401,7 @@ smp_callin (void)
 	spin_lock(&vector_lock);
 	/* Setup the per cpu irq handling data structures */
 	__setup_vector_irq(cpuid);
+	notify_cpu_starting(cpuid);
 	cpu_set(cpuid, cpu_online_map);
 	per_cpu(cpu_state, cpuid) = CPU_ONLINE;
 	spin_unlock(&vector_lock);
diff --git a/arch/m32r/kernel/smpboot.c b/arch/m32r/kernel/smpboot.c
index 2c03ac1..fc29948 100644
--- a/arch/m32r/kernel/smpboot.c
+++ b/arch/m32r/kernel/smpboot.c
@@ -498,6 +498,8 @@ static void __init smp_online(void)
 {
 	int cpu_id = smp_processor_id();
 
+	notify_cpu_starting(cpu_id);
+
 	local_irq_enable();
 
 	/* Get our bogomips. */
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 4410f17..7b59cfb 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -121,6 +121,8 @@ asmlinkage __cpuinit void start_secondary(void)
 	cpu = smp_processor_id();
 	cpu_data[cpu].udelay_val = loops_per_jiffy;
 
+	notify_cpu_starting(cpu);
+
 	mp_ops->smp_finish();
 	set_cpu_sibling_map(cpu);
 
diff --git a/arch/powerpc/kernel/smp.c b/arch/powerpc/kernel/smp.c
index 5337ca7..c27b10a 100644
--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -453,6 +453,7 @@ int __devinit start_secondary(void *unused)
 	secondary_cpu_time_init();
 
 	ipi_call_lock();
+	notify_cpu_starting(cpu);
 	cpu_set(cpu, cpu_online_map);
 	/* Update sibling maps */
 	base = cpu_first_thread_in_core(cpu);
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 00b9b4d..9e8b1f9 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -585,6 +585,8 @@ int __cpuinit start_secondary(void *cpuvoid)
 	/* Enable pfault pseudo page faults on this cpu. */
 	pfault_init();
 
+	/* call cpu notifiers */
+	notify_cpu_starting(smp_processor_id());
 	/* Mark this cpu as online */
 	spin_lock(&call_lock);
 	cpu_set(smp_processor_id(), cpu_online_map);
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index 60c5084..001778f 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -82,6 +82,8 @@ asmlinkage void __cpuinit start_secondary(void)
 
 	preempt_disable();
 
+	notify_cpu_starting(smp_processor_id());
+
 	local_irq_enable();
 
 	calibrate_delay();
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index 6959640..446767e 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -88,6 +88,7 @@ void __init smp4d_callin(void)
 	local_flush_cache_all();
 	local_flush_tlb_all();
 
+	notify_cpu_starting(cpuid);
 	/*
 	 * Unblock the master CPU _only_ when the scheduler state
 	 * of all secondary CPUs will be up-to-date, so after
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index a14a76a..9964890 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -71,6 +71,8 @@ void __cpuinit smp4m_callin(void)
 	local_flush_cache_all();
 	local_flush_tlb_all();
 
+	notify_cpu_starting(cpuid);
+
 	/* Get our local ticker going. */
 	smp_setup_percpu_timer();
 
diff --git a/arch/um/kernel/smp.c b/arch/um/kernel/smp.c
index be2d50c..0457721 100644
--- a/arch/um/kernel/smp.c
+++ b/arch/um/kernel/smp.c
@@ -85,6 +85,7 @@ static int idle_proc(void *cpup)
 	while (!cpu_isset(cpu, smp_commenced_mask))
 		cpu_relax();
 
+	notify_cpu_starting(cpu);
 	cpu_set(cpu, cpu_online_map);
 	default_idle();
 	return 0;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 7985c5b..0b8261c 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -257,6 +257,7 @@ static void __cpuinit smp_callin(void)
 	end_local_APIC_setup();
 	map_cpu_to_logical_apicid();
 
+	notify_cpu_starting(cpuid);
 	/*
 	 * Get our bogomips.
 	 *
diff --git a/arch/x86/mach-voyager/voyager_smp.c b/arch/x86/mach-voyager/voyager_smp.c
index ee0fba0..199a5f4 100644
--- a/arch/x86/mach-voyager/voyager_smp.c
+++ b/arch/x86/mach-voyager/voyager_smp.c
@@ -448,6 +448,8 @@ static void __init start_secondary(void *unused)
 
 	VDEBUG(("VOYAGER SMP: CPU%d, stack at about %p\n", cpuid, &cpuid));
 
+	notify_cpu_starting(cpuid);
+
 	/* enable interrupts */
 	local_irq_enable();
 
diff --git a/include/linux/completion.h b/include/linux/completion.h
index 02ef883..4a6b604 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -10,6 +10,18 @@
 
 #include <linux/wait.h>
 
+/**
+ * struct completion - structure used to maintain state for a "completion"
+ *
+ * This is the opaque structure used to maintain the state for a "completion".
+ * Completions currently use a FIFO to queue threads that have to wait for
+ * the "completion" event.
+ *
+ * See also:  complete(), wait_for_completion() (and friends _timeout,
+ * _interruptible, _interruptible_timeout, and _killable), init_completion(),
+ * and macros DECLARE_COMPLETION(), DECLARE_COMPLETION_ONSTACK(), and
+ * INIT_COMPLETION().
+ */
 struct completion {
 	unsigned int done;
 	wait_queue_head_t wait;
@@ -21,6 +33,14 @@ struct completion {
 #define COMPLETION_INITIALIZER_ONSTACK(work) \
 	({ init_completion(&work); work; })
 
+/**
+ * DECLARE_COMPLETION: - declare and initialize a completion structure
+ * @work:  identifier for the completion structure
+ *
+ * This macro declares and initializes a completion structure. Generally used
+ * for static declarations. You should use the _ONSTACK variant for automatic
+ * variables.
+ */
 #define DECLARE_COMPLETION(work) \
 	struct completion work = COMPLETION_INITIALIZER(work)
 
@@ -29,6 +49,13 @@ struct completion {
  * completions - so we use the _ONSTACK() variant for those that
  * are on the kernel stack:
  */
+/**
+ * DECLARE_COMPLETION_ONSTACK: - declare and initialize a completion structure
+ * @work:  identifier for the completion structure
+ *
+ * This macro declares and initializes a completion structure on the kernel
+ * stack.
+ */
 #ifdef CONFIG_LOCKDEP
 # define DECLARE_COMPLETION_ONSTACK(work) \
 	struct completion work = COMPLETION_INITIALIZER_ONSTACK(work)
@@ -36,6 +63,13 @@ struct completion {
 # define DECLARE_COMPLETION_ONSTACK(work) DECLARE_COMPLETION(work)
 #endif
 
+/**
+ * init_completion: - Initialize a dynamically allocated completion
+ * @x:  completion structure that is to be initialized
+ *
+ * This inline function will initialize a dynamically created completion
+ * structure.
+ */
 static inline void init_completion(struct completion *x)
 {
 	x->done = 0;
@@ -55,6 +89,13 @@ extern bool completion_done(struct completion *x);
 extern void complete(struct completion *);
 extern void complete_all(struct completion *);
 
+/**
+ * INIT_COMPLETION: - reinitialize a completion structure
+ * @x:  completion structure to be reinitialized
+ *
+ * This macro should be used to reinitialize a completion structure so it can
+ * be reused. This is especially important after complete_all() is used.
+ */
 #define INIT_COMPLETION(x)	((x).done = 0)
 
 
diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index d7faf88..c2747ac 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -69,6 +69,7 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
 #endif
 
 int cpu_up(unsigned int cpu);
+void notify_cpu_starting(unsigned int cpu);
 extern void cpu_hotplug_init(void);
 extern void cpu_maps_update_begin(void);
 extern void cpu_maps_update_done(void);
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index da2698b..b86fa2f 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -213,9 +213,16 @@ static inline int notifier_to_errno(int ret)
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 #define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
-				        * not handling interrupts, soon dead */
+					* not handling interrupts, soon dead.
+					* Called on the dying cpu, interrupts
+					* are already disabled. Must not
+					* sleep, must not fail */
 #define CPU_POST_DEAD		0x0009 /* CPU (unsigned)v dead, cpu_hotplug
 					* lock is dropped */
+#define CPU_STARTING		0x000A /* CPU (unsigned)v soon running.
+					* Called on the new cpu, just before
+					* enabling interrupts. Must not sleep,
+					* must not fail */
 
 /* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
  * operation in progress
@@ -229,6 +236,7 @@ static inline int notifier_to_errno(int ret)
 #define CPU_DOWN_FAILED_FROZEN	(CPU_DOWN_FAILED | CPU_TASKS_FROZEN)
 #define CPU_DEAD_FROZEN		(CPU_DEAD | CPU_TASKS_FROZEN)
 #define CPU_DYING_FROZEN	(CPU_DYING | CPU_TASKS_FROZEN)
+#define CPU_STARTING_FROZEN	(CPU_STARTING | CPU_TASKS_FROZEN)
 
 /* Hibernation and suspend events */
 #define PM_HIBERNATION_PREPARE	0x0001 /* Going to hibernate */
diff --git a/include/linux/proportions.h b/include/linux/proportions.h
index 5afc1b2..cf793bb 100644
--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
@@ -104,8 +104,8 @@ struct prop_local_single {
 	 * snapshot of the last seen global state
 	 * and a lock protecting this state
 	 */
-	int shift;
 	unsigned long period;
+	int shift;
 	spinlock_t lock;		/* protect the snapshot state */
 };
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3d9120c..5d0819e 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -451,8 +451,8 @@ struct signal_struct {
 	 * - everyone except group_exit_task is stopped during signal delivery
 	 *   of fatal signals, group_exit_task processes the signal.
 	 */
-	struct task_struct	*group_exit_task;
 	int			notify_count;
+	struct task_struct	*group_exit_task;
 
 	/* thread group stop support, overloads group_exit_code too */
 	int			group_stop_count;
@@ -824,6 +824,9 @@ struct sched_domain {
 	unsigned int ttwu_move_affine;
 	unsigned int ttwu_move_balance;
 #endif
+#ifdef CONFIG_SCHED_DEBUG
+	char *name;
+#endif
 };
 
 extern void partition_sched_domains(int ndoms_new, cpumask_t *doms_new,
@@ -897,7 +900,7 @@ struct sched_class {
 	void (*yield_task) (struct rq *rq);
 	int  (*select_task_rq)(struct task_struct *p, int sync);
 
-	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p);
+	void (*check_preempt_curr) (struct rq *rq, struct task_struct *p, int sync);
 
 	struct task_struct * (*pick_next_task) (struct rq *rq);
 	void (*put_prev_task) (struct rq *rq, struct task_struct *p);
@@ -1010,8 +1013,8 @@ struct sched_entity {
 
 struct sched_rt_entity {
 	struct list_head run_list;
-	unsigned int time_slice;
 	unsigned long timeout;
+	unsigned int time_slice;
 	int nr_cpus_allowed;
 
 	struct sched_rt_entity *back;
diff --git a/kernel/cpu.c b/kernel/cpu.c
index f17e985..86d4904 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -199,13 +199,14 @@ static int __ref take_cpu_down(void *_param)
 	struct take_cpu_down_param *param = _param;
 	int err;
 
-	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
-				param->hcpu);
 	/* Ensure this CPU doesn't handle any more interrupts. */
 	err = __cpu_disable();
 	if (err < 0)
 		return err;
 
+	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
+				param->hcpu);
+
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
 	sched_idle_next();
@@ -453,6 +454,25 @@ out:
 }
 #endif /* CONFIG_PM_SLEEP_SMP */
 
+/**
+ * notify_cpu_starting(cpu) - call the CPU_STARTING notifiers
+ * @cpu: cpu that just started
+ *
+ * This function calls the cpu_chain notifiers with CPU_STARTING.
+ * It must be called by the arch code on the new cpu, before the new cpu
+ * enables interrupts and before the "boot" cpu returns from __cpu_up().
+ */
+void notify_cpu_starting(unsigned int cpu)
+{
+	unsigned long val = CPU_STARTING;
+
+#ifdef CONFIG_PM_SLEEP_SMP
+	if (cpu_isset(cpu, frozen_cpus))
+		val = CPU_STARTING_FROZEN;
+#endif /* CONFIG_PM_SLEEP_SMP */
+	raw_notifier_call_chain(&cpu_chain, val, (void *)(long)cpu);
+}
+
 #endif /* CONFIG_SMP */
 
 /*
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 827cd9a..eab7bd6 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1921,7 +1921,7 @@ static void remove_tasks_in_empty_cpuset(struct cpuset *cs)
  * that has tasks along with an empty 'mems'.  But if we did see such
  * a cpuset, we'd handle it just like we do if its 'cpus' was empty.
  */
-static void scan_for_empty_cpusets(const struct cpuset *root)
+static void scan_for_empty_cpusets(struct cpuset *root)
 {
 	LIST_HEAD(queue);
 	struct cpuset *cp;	/* scans cpusets being updated */
diff --git a/kernel/sched.c b/kernel/sched.c
index ad1962d..6f23059 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -204,11 +204,16 @@ void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime)
 	rt_b->rt_period_timer.cb_mode = HRTIMER_CB_IRQSAFE_UNLOCKED;
 }
 
+static inline int rt_bandwidth_enabled(void)
+{
+	return sysctl_sched_rt_runtime >= 0;
+}
+
 static void start_rt_bandwidth(struct rt_bandwidth *rt_b)
 {
 	ktime_t now;
 
-	if (rt_b->rt_runtime == RUNTIME_INF)
+	if (rt_bandwidth_enabled() && rt_b->rt_runtime == RUNTIME_INF)
 		return;
 
 	if (hrtimer_active(&rt_b->rt_period_timer))
@@ -298,9 +303,9 @@ static DEFINE_PER_CPU(struct cfs_rq, init_cfs_rq) ____cacheline_aligned_in_smp;
 static DEFINE_PER_CPU(struct sched_rt_entity, init_sched_rt_entity);
 static DEFINE_PER_CPU(struct rt_rq, init_rt_rq) ____cacheline_aligned_in_smp;
 #endif /* CONFIG_RT_GROUP_SCHED */
-#else /* !CONFIG_FAIR_GROUP_SCHED */
+#else /* !CONFIG_USER_SCHED */
 #define root_task_group init_task_group
-#endif /* CONFIG_FAIR_GROUP_SCHED */
+#endif /* CONFIG_USER_SCHED */
 
 /* task_group_lock serializes add/remove of task groups and also changes to
  * a task group's cpu shares.
@@ -604,9 +609,9 @@ struct rq {
 
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
-static inline void check_preempt_curr(struct rq *rq, struct task_struct *p)
+static inline void check_preempt_curr(struct rq *rq, struct task_struct *p, int sync)
 {
-	rq->curr->sched_class->check_preempt_curr(rq, p);
+	rq->curr->sched_class->check_preempt_curr(rq, p, sync);
 }
 
 static inline int cpu_of(struct rq *rq)
@@ -1102,7 +1107,7 @@ static void hrtick_start(struct rq *rq, u64 delay)
 	hrtimer_start(&rq->hrtick_timer, ns_to_ktime(delay), HRTIMER_MODE_REL);
 }
 
-static void init_hrtick(void)
+static inline void init_hrtick(void)
 {
 }
 #endif /* CONFIG_SMP */
@@ -1121,7 +1126,7 @@ static void init_rq_hrtick(struct rq *rq)
 	rq->hrtick_timer.function = hrtick;
 	rq->hrtick_timer.cb_mode = HRTIMER_CB_IRQSAFE_PERCPU;
 }
-#else
+#else	/* CONFIG_SCHED_HRTICK */
 static inline void hrtick_clear(struct rq *rq)
 {
 }
@@ -1133,7 +1138,7 @@ static inline void init_rq_hrtick(struct rq *rq)
 static inline void init_hrtick(void)
 {
 }
-#endif
+#endif	/* CONFIG_SCHED_HRTICK */
 
 /*
  * resched_task - mark a task 'to be rescheduled now'.
@@ -1380,38 +1385,24 @@ static inline void dec_cpu_load(struct rq *rq, unsigned long load)
 	update_load_sub(&rq->load, load);
 }
 
-#ifdef CONFIG_SMP
-static unsigned long source_load(int cpu, int type);
-static unsigned long target_load(int cpu, int type);
-static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
-
-static unsigned long cpu_avg_load_per_task(int cpu)
-{
-	struct rq *rq = cpu_rq(cpu);
-
-	if (rq->nr_running)
-		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
-
-	return rq->avg_load_per_task;
-}
-
-#ifdef CONFIG_FAIR_GROUP_SCHED
-
-typedef void (*tg_visitor)(struct task_group *, int, struct sched_domain *);
+#if (defined(CONFIG_SMP) && defined(CONFIG_FAIR_GROUP_SCHED)) || defined(CONFIG_RT_GROUP_SCHED)
+typedef int (*tg_visitor)(struct task_group *, void *);
 
 /*
  * Iterate the full tree, calling @down when first entering a node and @up when
  * leaving it for the final time.
  */
-static void
-walk_tg_tree(tg_visitor down, tg_visitor up, int cpu, struct sched_domain *sd)
+static int walk_tg_tree(tg_visitor down, tg_visitor up, void *data)
 {
 	struct task_group *parent, *child;
+	int ret;
 
 	rcu_read_lock();
 	parent = &root_task_group;
 down:
-	(*down)(parent, cpu, sd);
+	ret = (*down)(parent, data);
+	if (ret)
+		goto out_unlock;
 	list_for_each_entry_rcu(child, &parent->children, siblings) {
 		parent = child;
 		goto down;
@@ -1419,15 +1410,43 @@ down:
 up:
 		continue;
 	}
-	(*up)(parent, cpu, sd);
+	ret = (*up)(parent, data);
+	if (ret)
+		goto out_unlock;
 
 	child = parent;
 	parent = parent->parent;
 	if (parent)
 		goto up;
+out_unlock:
 	rcu_read_unlock();
+
+	return ret;
 }
 
+static int tg_nop(struct task_group *tg, void *data)
+{
+	return 0;
+}
+#endif
+
+#ifdef CONFIG_SMP
+static unsigned long source_load(int cpu, int type);
+static unsigned long target_load(int cpu, int type);
+static int task_hot(struct task_struct *p, u64 now, struct sched_domain *sd);
+
+static unsigned long cpu_avg_load_per_task(int cpu)
+{
+	struct rq *rq = cpu_rq(cpu);
+
+	if (rq->nr_running)
+		rq->avg_load_per_task = rq->load.weight / rq->nr_running;
+
+	return rq->avg_load_per_task;
+}
+
+#ifdef CONFIG_FAIR_GROUP_SCHED
+
 static void __set_se_shares(struct sched_entity *se, unsigned long shares);
 
 /*
@@ -1486,11 +1505,11 @@ __update_group_shares_cpu(struct task_group *tg, int cpu,
  * This needs to be done in a bottom-up fashion because the rq weight of a
  * parent group depends on the shares of its child groups.
  */
-static void
-tg_shares_up(struct task_group *tg, int cpu, struct sched_domain *sd)
+static int tg_shares_up(struct task_group *tg, void *data)
 {
 	unsigned long rq_weight = 0;
 	unsigned long shares = 0;
+	struct sched_domain *sd = data;
 	int i;
 
 	for_each_cpu_mask(i, sd->span) {
@@ -1515,6 +1534,8 @@ tg_shares_up(struct task_group *tg, int cpu, struct sched_domain *sd)
 		__update_group_shares_cpu(tg, i, shares, rq_weight);
 		spin_unlock_irqrestore(&rq->lock, flags);
 	}
+
+	return 0;
 }
 
 /*
@@ -1522,10 +1543,10 @@ tg_shares_up(struct task_group *tg, int cpu, struct sched_domain *sd)
  * This needs to be done in a top-down fashion because the load of a child
  * group is a fraction of its parents load.
  */
-static void
-tg_load_down(struct task_group *tg, int cpu, struct sched_domain *sd)
+static int tg_load_down(struct task_group *tg, void *data)
 {
 	unsigned long load;
+	long cpu = (long)data;
 
 	if (!tg->parent) {
 		load = cpu_rq(cpu)->load.weight;
@@ -1536,11 +1557,8 @@ tg_load_down(struct task_group *tg, int cpu, struct sched_domain *sd)
 	}
 
 	tg->cfs_rq[cpu]->h_load = load;
-}
 
-static void
-tg_nop(struct task_group *tg, int cpu, struct sched_domain *sd)
-{
+	return 0;
 }
 
 static void update_shares(struct sched_domain *sd)
@@ -1550,7 +1568,7 @@ static void update_shares(struct sched_domain *sd)
 
 	if (elapsed >= (s64)(u64)sysctl_sched_shares_ratelimit) {
 		sd->last_update = now;
-		walk_tg_tree(tg_nop, tg_shares_up, 0, sd);
+		walk_tg_tree(tg_nop, tg_shares_up, sd);
 	}
 }
 
@@ -1561,9 +1579,9 @@ static void update_shares_locked(struct rq *rq, struct sched_domain *sd)
 	spin_lock(&rq->lock);
 }
 
-static void update_h_load(int cpu)
+static void update_h_load(long cpu)
 {
-	walk_tg_tree(tg_load_down, tg_nop, cpu, NULL);
+	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 }
 
 #else
@@ -1921,11 +1939,8 @@ unsigned long wait_task_inactive(struct task_struct *p, long match_state)
 		running = task_running(rq, p);
 		on_rq = p->se.on_rq;
 		ncsw = 0;
-		if (!match_state || p->state == match_state) {
-			ncsw = p->nivcsw + p->nvcsw;
-			if (unlikely(!ncsw))
-				ncsw = 1;
-		}
+		if (!match_state || p->state == match_state)
+			ncsw = p->nvcsw | LONG_MIN; /* sets MSB */
 		task_rq_unlock(rq, &flags);
 
 		/*
@@ -2285,7 +2300,7 @@ out_running:
 	trace_mark(kernel_sched_wakeup,
 		"pid %d state %ld ## rq %p task %p rq->curr %p",
 		p->pid, p->state, rq, p, rq->curr);
-	check_preempt_curr(rq, p);
+	check_preempt_curr(rq, p, sync);
 
 	p->state = TASK_RUNNING;
 #ifdef CONFIG_SMP
@@ -2420,7 +2435,7 @@ void wake_up_new_task(struct task_struct *p, unsigned long clone_flags)
 	trace_mark(kernel_sched_wakeup_new,
 		"pid %d state %ld ## rq %p task %p rq->curr %p",
 		p->pid, p->state, rq, p, rq->curr);
-	check_preempt_curr(rq, p);
+	check_preempt_curr(rq, p, 0);
 #ifdef CONFIG_SMP
 	if (p->sched_class->task_wake_up)
 		p->sched_class->task_wake_up(rq, p);
@@ -2880,7 +2895,7 @@ static void pull_task(struct rq *src_rq, struct task_struct *p,
 	 * Note that idle threads have a prio of MAX_PRIO, for this test
 	 * to be always true for them.
 	 */
-	check_preempt_curr(this_rq, p);
+	check_preempt_curr(this_rq, p, 0);
 }
 
 /*
@@ -4627,6 +4642,15 @@ __wake_up_sync(wait_queue_head_t *q, unsigned int mode, int nr_exclusive)
 }
 EXPORT_SYMBOL_GPL(__wake_up_sync);	/* For internal use only */
 
+/**
+ * complete: - signals a single thread waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up a single thread waiting on this completion. Threads will be
+ * awakened in the same order in which they were queued.
+ *
+ * See also complete_all(), wait_for_completion() and related routines.
+ */
 void complete(struct completion *x)
 {
 	unsigned long flags;
@@ -4638,6 +4662,12 @@ void complete(struct completion *x)
 }
 EXPORT_SYMBOL(complete);
 
+/**
+ * complete_all: - signals all threads waiting on this completion
+ * @x:  holds the state of this particular completion
+ *
+ * This will wake up all threads waiting on this particular completion event.
+ */
 void complete_all(struct completion *x)
 {
 	unsigned long flags;
@@ -4658,10 +4688,7 @@ do_wait_for_common(struct completion *x, long timeout, int state)
 		wait.flags |= WQ_FLAG_EXCLUSIVE;
 		__add_wait_queue_tail(&x->wait, &wait);
 		do {
-			if ((state == TASK_INTERRUPTIBLE &&
-			     signal_pending(current)) ||
-			    (state == TASK_KILLABLE &&
-			     fatal_signal_pending(current))) {
+			if (signal_pending_state(state, current)) {
 				timeout = -ERESTARTSYS;
 				break;
 			}
@@ -4689,12 +4716,31 @@ wait_for_common(struct completion *x, long timeout, int state)
 	return timeout;
 }
 
+/**
+ * wait_for_completion: - waits for completion of a task
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It is NOT
+ * interruptible and there is no timeout.
+ *
+ * See also similar routines (i.e. wait_for_completion_timeout()) with timeout
+ * and interrupt capability. Also see complete().
+ */
 void __sched wait_for_completion(struct completion *x)
 {
 	wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_UNINTERRUPTIBLE);
 }
 EXPORT_SYMBOL(wait_for_completion);
 
+/**
+ * wait_for_completion_timeout: - waits for completion of a task (w/timeout)
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled or for a
+ * specified timeout to expire. The timeout is in jiffies. It is not
+ * interruptible.
+ */
 unsigned long __sched
 wait_for_completion_timeout(struct completion *x, unsigned long timeout)
 {
@@ -4702,6 +4748,13 @@ wait_for_completion_timeout(struct completion *x, unsigned long timeout)
 }
 EXPORT_SYMBOL(wait_for_completion_timeout);
 
+/**
+ * wait_for_completion_interruptible: - waits for completion of a task (w/intr)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits for completion of a specific task to be signaled. It is
+ * interruptible.
+ */
 int __sched wait_for_completion_interruptible(struct completion *x)
 {
 	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_INTERRUPTIBLE);
@@ -4711,6 +4764,14 @@ int __sched wait_for_completion_interruptible(struct completion *x)
 }
 EXPORT_SYMBOL(wait_for_completion_interruptible);
 
+/**
+ * wait_for_completion_interruptible_timeout: - waits for completion (w/(to,intr))
+ * @x:  holds the state of this particular completion
+ * @timeout:  timeout value in jiffies
+ *
+ * This waits for either a completion of a specific task to be signaled or for a
+ * specified timeout to expire. It is interruptible. The timeout is in jiffies.
+ */
 unsigned long __sched
 wait_for_completion_interruptible_timeout(struct completion *x,
 					  unsigned long timeout)
@@ -4719,6 +4780,13 @@ wait_for_completion_interruptible_timeout(struct completion *x,
 }
 EXPORT_SYMBOL(wait_for_completion_interruptible_timeout);
 
+/**
+ * wait_for_completion_killable: - waits for completion of a task (killable)
+ * @x:  holds the state of this particular completion
+ *
+ * This waits to be signaled for completion of a specific task. It can be
+ * interrupted by a kill signal.
+ */
 int __sched wait_for_completion_killable(struct completion *x)
 {
 	long t = wait_for_common(x, MAX_SCHEDULE_TIMEOUT, TASK_KILLABLE);
@@ -5121,7 +5189,8 @@ recheck:
 		 * Do not allow realtime tasks into groups that have no runtime
 		 * assigned.
 		 */
-		if (rt_policy(policy) && task_group(p)->rt_bandwidth.rt_runtime == 0)
+		if (rt_bandwidth_enabled() && rt_policy(policy) &&
+				task_group(p)->rt_bandwidth.rt_runtime == 0)
 			return -EPERM;
 #endif
 
@@ -5957,7 +6026,7 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
 	set_task_cpu(p, dest_cpu);
 	if (on_rq) {
 		activate_task(rq_dest, p, 0);
-		check_preempt_curr(rq_dest, p);
+		check_preempt_curr(rq_dest, p, 0);
 	}
 done:
 	ret = 1;
@@ -6282,7 +6351,7 @@ set_table_entry(struct ctl_table *entry,
 static struct ctl_table *
 sd_alloc_ctl_domain_table(struct sched_domain *sd)
 {
-	struct ctl_table *table = sd_alloc_ctl_entry(12);
+	struct ctl_table *table = sd_alloc_ctl_entry(13);
 
 	if (table == NULL)
 		return NULL;
@@ -6310,7 +6379,9 @@ sd_alloc_ctl_domain_table(struct sched_domain *sd)
 		sizeof(int), 0644, proc_dointvec_minmax);
 	set_table_entry(&table[10], "flags", &sd->flags,
 		sizeof(int), 0644, proc_dointvec_minmax);
-	/* &table[11] is terminator */
+	set_table_entry(&table[11], "name", sd->name,
+		CORENAME_MAX_SIZE, 0444, proc_dostring);
+	/* &table[12] is terminator */
 
 	return table;
 }
@@ -7194,13 +7265,21 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
  * Non-inlined to reduce accumulated stack pressure in build_sched_domains()
  */
 
+#ifdef CONFIG_SCHED_DEBUG
+# define SD_INIT_NAME(sd, type)		sd->name = #type
+#else
+# define SD_INIT_NAME(sd, type)		do { } while (0)
+#endif
+
 #define	SD_INIT(sd, type)	sd_init_##type(sd)
+
 #define SD_INIT_FUNC(type)	\
 static noinline void sd_init_##type(struct sched_domain *sd)	\
 {								\
 	memset(sd, 0, sizeof(*sd));				\
 	*sd = SD_##type##_INIT;					\
 	sd->level = SD_LV_##type;				\
+	SD_INIT_NAME(sd, type);					\
 }
 
 SD_INIT_FUNC(CPU)
@@ -8242,20 +8321,25 @@ void __might_sleep(char *file, int line)
 #ifdef in_atomic
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
-	if ((in_atomic() || irqs_disabled()) &&
-	    system_state == SYSTEM_RUNNING && !oops_in_progress) {
-		if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
-			return;
-		prev_jiffy = jiffies;
-		printk(KERN_ERR "BUG: sleeping function called from invalid"
-				" context at %s:%d\n", file, line);
-		printk("in_atomic():%d, irqs_disabled():%d\n",
-			in_atomic(), irqs_disabled());
-		debug_show_held_locks(current);
-		if (irqs_disabled())
-			print_irqtrace_events(current);
-		dump_stack();
-	}
+	if ((!in_atomic() && !irqs_disabled()) ||
+		    system_state != SYSTEM_RUNNING || oops_in_progress)
+		return;
+	if (time_before(jiffies, prev_jiffy + HZ) && prev_jiffy)
+		return;
+	prev_jiffy = jiffies;
+
+	printk(KERN_ERR
+		"BUG: sleeping function called from invalid context at %s:%d\n",
+			file, line);
+	printk(KERN_ERR
+		"in_atomic(): %d, irqs_disabled(): %d, pid: %d, name: %s\n",
+			in_atomic(), irqs_disabled(),
+			current->pid, current->comm);
+
+	debug_show_held_locks(current);
+	if (irqs_disabled())
+		print_irqtrace_events(current);
+	dump_stack();
 #endif
 }
 EXPORT_SYMBOL(__might_sleep);
@@ -8753,73 +8837,95 @@ static DEFINE_MUTEX(rt_constraints_mutex);
 static unsigned long to_ratio(u64 period, u64 runtime)
 {
 	if (runtime == RUNTIME_INF)
-		return 1ULL << 16;
+		return 1ULL << 20;
 
-	return div64_u64(runtime << 16, period);
+	return div64_u64(runtime << 20, period);
 }
 
-#ifdef CONFIG_CGROUP_SCHED
-static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
+/* Must be called with tasklist_lock held */
+static inline int tg_has_rt_tasks(struct task_group *tg)
 {
-	struct task_group *tgi, *parent = tg->parent;
-	unsigned long total = 0;
+	struct task_struct *g, *p;
 
-	if (!parent) {
-		if (global_rt_period() < period)
-			return 0;
+	do_each_thread(g, p) {
+		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
+			return 1;
+	} while_each_thread(g, p);
 
-		return to_ratio(period, runtime) <
-			to_ratio(global_rt_period(), global_rt_runtime());
-	}
+	return 0;
+}
 
-	if (ktime_to_ns(parent->rt_bandwidth.rt_period) < period)
-		return 0;
+struct rt_schedulable_data {
+	struct task_group *tg;
+	u64 rt_period;
+	u64 rt_runtime;
+};
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(tgi, &parent->children, siblings) {
-		if (tgi == tg)
-			continue;
+static int tg_schedulable(struct task_group *tg, void *data)
+{
+	struct rt_schedulable_data *d = data;
+	struct task_group *child;
+	unsigned long total, sum = 0;
+	u64 period, runtime;
 
-		total += to_ratio(ktime_to_ns(tgi->rt_bandwidth.rt_period),
-				tgi->rt_bandwidth.rt_runtime);
+	period = ktime_to_ns(tg->rt_bandwidth.rt_period);
+	runtime = tg->rt_bandwidth.rt_runtime;
+
+	if (tg == d->tg) {
+		period = d->rt_period;
+		runtime = d->rt_runtime;
 	}
-	rcu_read_unlock();
 
-	return total + to_ratio(period, runtime) <=
-		to_ratio(ktime_to_ns(parent->rt_bandwidth.rt_period),
-				parent->rt_bandwidth.rt_runtime);
-}
-#elif defined CONFIG_USER_SCHED
-static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
-{
-	struct task_group *tgi;
-	unsigned long total = 0;
-	unsigned long global_ratio =
-		to_ratio(global_rt_period(), global_rt_runtime());
+	/*
+	 * Cannot have more runtime than the period.
+	 */
+	if (runtime > period && runtime != RUNTIME_INF)
+		return -EINVAL;
 
-	rcu_read_lock();
-	list_for_each_entry_rcu(tgi, &task_groups, list) {
-		if (tgi == tg)
-			continue;
+	/*
+	 * Ensure we don't starve existing RT tasks.
+	 */
+	if (rt_bandwidth_enabled() && !runtime && tg_has_rt_tasks(tg))
+		return -EBUSY;
+
+	total = to_ratio(period, runtime);
+
+	/*
+	 * Nobody can have more than the global setting allows.
+	 */
+	if (total > to_ratio(global_rt_period(), global_rt_runtime()))
+		return -EINVAL;
+
+	/*
+	 * The sum of our children's runtime should not exceed our own.
+	 */
+	list_for_each_entry_rcu(child, &tg->children, siblings) {
+		period = ktime_to_ns(child->rt_bandwidth.rt_period);
+		runtime = child->rt_bandwidth.rt_runtime;
+
+		if (child == d->tg) {
+			period = d->rt_period;
+			runtime = d->rt_runtime;
+		}
 
-		total += to_ratio(ktime_to_ns(tgi->rt_bandwidth.rt_period),
-				tgi->rt_bandwidth.rt_runtime);
+		sum += to_ratio(period, runtime);
 	}
-	rcu_read_unlock();
 
-	return total + to_ratio(period, runtime) < global_ratio;
+	if (sum > total)
+		return -EINVAL;
+
+	return 0;
 }
-#endif
 
-/* Must be called with tasklist_lock held */
-static inline int tg_has_rt_tasks(struct task_group *tg)
+static int __rt_schedulable(struct task_group *tg, u64 period, u64 runtime)
 {
-	struct task_struct *g, *p;
-	do_each_thread(g, p) {
-		if (rt_task(p) && rt_rq_of_se(&p->rt)->tg == tg)
-			return 1;
-	} while_each_thread(g, p);
-	return 0;
+	struct rt_schedulable_data data = {
+		.tg = tg,
+		.rt_period = period,
+		.rt_runtime = runtime,
+	};
+
+	return walk_tg_tree(tg_schedulable, tg_nop, &data);
 }
 
 static int tg_set_bandwidth(struct task_group *tg,
@@ -8829,14 +8935,9 @@ static int tg_set_bandwidth(struct task_group *tg,
 
 	mutex_lock(&rt_constraints_mutex);
 	read_lock(&tasklist_lock);
-	if (rt_runtime == 0 && tg_has_rt_tasks(tg)) {
-		err = -EBUSY;
+	err = __rt_schedulable(tg, rt_period, rt_runtime);
+	if (err)
 		goto unlock;
-	}
-	if (!__rt_schedulable(tg, rt_period, rt_runtime)) {
-		err = -EINVAL;
-		goto unlock;
-	}
 
 	spin_lock_irq(&tg->rt_bandwidth.rt_runtime_lock);
 	tg->rt_bandwidth.rt_period = ns_to_ktime(rt_period);
@@ -8905,19 +9006,25 @@ long sched_group_rt_period(struct task_group *tg)
 
 static int sched_rt_global_constraints(void)
 {
-	struct task_group *tg = &root_task_group;
-	u64 rt_runtime, rt_period;
+	u64 runtime, period;
 	int ret = 0;
 
 	if (sysctl_sched_rt_period <= 0)
 		return -EINVAL;
 
-	rt_period = ktime_to_ns(tg->rt_bandwidth.rt_period);
-	rt_runtime = tg->rt_bandwidth.rt_runtime;
+	runtime = global_rt_runtime();
+	period = global_rt_period();
+
+	/*
+	 * Sanity check on the sysctl variables.
+	 */
+	if (runtime > period && runtime != RUNTIME_INF)
+		return -EINVAL;
 
 	mutex_lock(&rt_constraints_mutex);
-	if (!__rt_schedulable(tg, rt_period, rt_runtime))
-		ret = -EINVAL;
+	read_lock(&tasklist_lock);
+	ret = __rt_schedulable(NULL, 0, 0);
+	read_unlock(&tasklist_lock);
 	mutex_unlock(&rt_constraints_mutex);
 
 	return ret;
@@ -8991,7 +9098,6 @@ cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 
 	if (!cgrp->parent) {
 		/* This is early initialization for the top cgroup */
-		init_task_group.css.cgroup = cgrp;
 		return &init_task_group.css;
 	}
 
@@ -9000,9 +9106,6 @@ cpu_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	if (IS_ERR(tg))
 		return ERR_PTR(-ENOMEM);
 
-	/* Bind the cgroup to task_group object we just created */
-	tg->css.cgroup = cgrp;
-
 	return &tg->css;
 }
 
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index fb8994c..18fd171 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -409,64 +409,6 @@ static u64 sched_vslice_add(struct cfs_rq *cfs_rq, struct sched_entity *se)
 }
 
 /*
- * The goal of calc_delta_asym() is to be asymmetrically around NICE_0_LOAD, in
- * that it favours >=0 over <0.
- *
- *   -20         |
- *               |
- *     0 --------+-------
- *             .'
- *    19     .'
- *
- */
-static unsigned long
-calc_delta_asym(unsigned long delta, struct sched_entity *se)
-{
-	struct load_weight lw = {
-		.weight = NICE_0_LOAD,
-		.inv_weight = 1UL << (WMULT_SHIFT-NICE_0_SHIFT)
-	};
-
-	for_each_sched_entity(se) {
-		struct load_weight *se_lw = &se->load;
-		unsigned long rw = cfs_rq_of(se)->load.weight;
-
-#ifdef CONFIG_FAIR_SCHED_GROUP
-		struct cfs_rq *cfs_rq = se->my_q;
-		struct task_group *tg = NULL
-
-		if (cfs_rq)
-			tg = cfs_rq->tg;
-
-		if (tg && tg->shares < NICE_0_LOAD) {
-			/*
-			 * scale shares to what it would have been had
-			 * tg->weight been NICE_0_LOAD:
-			 *
-			 *   weight = 1024 * shares / tg->weight
-			 */
-			lw.weight *= se->load.weight;
-			lw.weight /= tg->shares;
-
-			lw.inv_weight = 0;
-
-			se_lw = &lw;
-			rw += lw.weight - se->load.weight;
-		} else
-#endif
-
-		if (se->load.weight < NICE_0_LOAD) {
-			se_lw = &lw;
-			rw += NICE_0_LOAD - se->load.weight;
-		}
-
-		delta = calc_delta_mine(delta, rw, se_lw);
-	}
-
-	return delta;
-}
-
-/*
  * Update the current task's runtime statistics. Skip current tasks that
  * are not in our scheduling class.
  */
@@ -586,11 +528,12 @@ account_entity_enqueue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	update_load_add(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		inc_cpu_load(rq_of(cfs_rq), se->load.weight);
-	if (entity_is_task(se))
+	if (entity_is_task(se)) {
 		add_cfs_task_weight(cfs_rq, se->load.weight);
+		list_add(&se->group_node, &cfs_rq->tasks);
+	}
 	cfs_rq->nr_running++;
 	se->on_rq = 1;
-	list_add(&se->group_node, &cfs_rq->tasks);
 }
 
 static void
@@ -599,11 +542,12 @@ account_entity_dequeue(struct cfs_rq *cfs_rq, struct sched_entity *se)
 	update_load_sub(&cfs_rq->load, se->load.weight);
 	if (!parent_entity(se))
 		dec_cpu_load(rq_of(cfs_rq), se->load.weight);
-	if (entity_is_task(se))
+	if (entity_is_task(se)) {
 		add_cfs_task_weight(cfs_rq, -se->load.weight);
+		list_del_init(&se->group_node);
+	}
 	cfs_rq->nr_running--;
 	se->on_rq = 0;
-	list_del_init(&se->group_node);
 }
 
 static void enqueue_sleeper(struct cfs_rq *cfs_rq, struct sched_entity *se)
@@ -1085,7 +1029,6 @@ static long effective_load(struct task_group *tg, int cpu,
 		long wl, long wg)
 {
 	struct sched_entity *se = tg->se[cpu];
-	long more_w;
 
 	if (!tg->parent)
 		return wl;
@@ -1097,18 +1040,17 @@ static long effective_load(struct task_group *tg, int cpu,
 	if (!wl && sched_feat(ASYM_EFF_LOAD))
 		return wl;
 
-	/*
-	 * Instead of using this increment, also add the difference
-	 * between when the shares were last updated and now.
-	 */
-	more_w = se->my_q->load.weight - se->my_q->rq_weight;
-	wl += more_w;
-	wg += more_w;
-
 	for_each_sched_entity(se) {
-#define D(n) (likely(n) ? (n) : 1)
-
 		long S, rw, s, a, b;
+		long more_w;
+
+		/*
+		 * Instead of using this increment, also add the difference
+		 * between when the shares were last updated and now.
+		 */
+		more_w = se->my_q->load.weight - se->my_q->rq_weight;
+		wl += more_w;
+		wg += more_w;
 
 		S = se->my_q->tg->shares;
 		s = se->my_q->shares;
@@ -1117,7 +1059,11 @@ static long effective_load(struct task_group *tg, int cpu,
 		a = S*(rw + wl);
 		b = S*rw + s*wg;
 
-		wl = s*(a-b)/D(b);
+		wl = s*(a-b);
+
+		if (likely(b))
+			wl /= b;
+
 		/*
 		 * Assume the group is already running and will
 		 * thus already be accounted for in the weight.
@@ -1126,7 +1072,6 @@ static long effective_load(struct task_group *tg, int cpu,
 		 * alter the group weight.
 		 */
 		wg = 0;
-#undef D
 	}
 
 	return wl;
@@ -1143,7 +1088,7 @@ static inline unsigned long effective_load(struct task_group *tg, int cpu,
 #endif
 
 static int
-wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
+wake_affine(struct sched_domain *this_sd, struct rq *this_rq,
 	    struct task_struct *p, int prev_cpu, int this_cpu, int sync,
 	    int idx, unsigned long load, unsigned long this_load,
 	    unsigned int imbalance)
@@ -1158,6 +1103,11 @@ wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	if (!(this_sd->flags & SD_WAKE_AFFINE) || !sched_feat(AFFINE_WAKEUPS))
 		return 0;
 
+	if (!sync && sched_feat(SYNC_WAKEUPS) &&
+	    curr->se.avg_overlap < sysctl_sched_migration_cost &&
+	    p->se.avg_overlap < sysctl_sched_migration_cost)
+		sync = 1;
+
 	/*
 	 * If sync wakeup then subtract the (maximum possible)
 	 * effect of the currently running task from the load
@@ -1182,17 +1132,14 @@ wake_affine(struct rq *rq, struct sched_domain *this_sd, struct rq *this_rq,
 	 * a reasonable amount of time then attract this newly
 	 * woken task:
 	 */
-	if (sync && balanced) {
-		if (curr->se.avg_overlap < sysctl_sched_migration_cost &&
-		    p->se.avg_overlap < sysctl_sched_migration_cost)
-			return 1;
-	}
+	if (sync && balanced)
+		return 1;
 
 	schedstat_inc(p, se.nr_wakeups_affine_attempts);
 	tl_per_task = cpu_avg_load_per_task(this_cpu);
 
-	if ((tl <= load && tl + target_load(prev_cpu, idx) <= tl_per_task) ||
-			balanced) {
+	if (balanced || (tl <= load && tl + target_load(prev_cpu, idx) <=
+			tl_per_task)) {
 		/*
 		 * This domain has SD_WAKE_AFFINE and
 		 * p is cache cold in this domain, and
@@ -1211,16 +1158,17 @@ static int select_task_rq_fair(struct task_struct *p, int sync)
 	struct sched_domain *sd, *this_sd = NULL;
 	int prev_cpu, this_cpu, new_cpu;
 	unsigned long load, this_load;
-	struct rq *rq, *this_rq;
+	struct rq *this_rq;
 	unsigned int imbalance;
 	int idx;
 
 	prev_cpu	= task_cpu(p);
-	rq		= task_rq(p);
 	this_cpu	= smp_processor_id();
 	this_rq		= cpu_rq(this_cpu);
 	new_cpu		= prev_cpu;
 
+	if (prev_cpu == this_cpu)
+		goto out;
 	/*
 	 * 'this_sd' is the first domain that both
 	 * this_cpu and prev_cpu are present in:
@@ -1248,13 +1196,10 @@ static int select_task_rq_fair(struct task_struct *p, int sync)
 	load = source_load(prev_cpu, idx);
 	this_load = target_load(this_cpu, idx);
 
-	if (wake_affine(rq, this_sd, this_rq, p, prev_cpu, this_cpu, sync, idx,
+	if (wake_affine(this_sd, this_rq, p, prev_cpu, this_cpu, sync, idx,
 				     load, this_load, imbalance))
 		return this_cpu;
 
-	if (prev_cpu == this_cpu)
-		goto out;
-
 	/*
 	 * Start passive balancing when half the imbalance_pct
 	 * limit is reached.
@@ -1281,62 +1226,20 @@ static unsigned long wakeup_gran(struct sched_entity *se)
 	 * + nice tasks.
 	 */
 	if (sched_feat(ASYM_GRAN))
-		gran = calc_delta_asym(sysctl_sched_wakeup_granularity, se);
-	else
-		gran = calc_delta_fair(sysctl_sched_wakeup_granularity, se);
+		gran = calc_delta_mine(gran, NICE_0_LOAD, &se->load);
 
 	return gran;
 }
 
 /*
- * Should 'se' preempt 'curr'.
- *
- *             |s1
- *        |s2
- *   |s3
- *         g
- *      |<--->|c
- *
- *  w(c, s1) = -1
- *  w(c, s2) =  0
- *  w(c, s3) =  1
- *
- */
-static int
-wakeup_preempt_entity(struct sched_entity *curr, struct sched_entity *se)
-{
-	s64 gran, vdiff = curr->vruntime - se->vruntime;
-
-	if (vdiff < 0)
-		return -1;
-
-	gran = wakeup_gran(curr);
-	if (vdiff > gran)
-		return 1;
-
-	return 0;
-}
-
-/* return depth at which a sched entity is present in the hierarchy */
-static inline int depth_se(struct sched_entity *se)
-{
-	int depth = 0;
-
-	for_each_sched_entity(se)
-		depth++;
-
-	return depth;
-}
-
-/*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
+static void check_preempt_wakeup(struct rq *rq, struct task_struct *p, int sync)
 {
 	struct task_struct *curr = rq->curr;
 	struct cfs_rq *cfs_rq = task_cfs_rq(curr);
 	struct sched_entity *se = &curr->se, *pse = &p->se;
-	int se_depth, pse_depth;
+	s64 delta_exec;
 
 	if (unlikely(rt_prio(p->prio))) {
 		update_rq_clock(rq);
@@ -1351,6 +1254,13 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 	cfs_rq_of(pse)->next = pse;
 
 	/*
+	 * We can come here with TIF_NEED_RESCHED already set from new task
+	 * wake up path.
+	 */
+	if (test_tsk_need_resched(curr))
+		return;
+
+	/*
 	 * Batch tasks do not preempt (their preemption is driven by
 	 * the tick):
 	 */
@@ -1360,33 +1270,15 @@ static void check_preempt_wakeup(struct rq *rq, struct task_struct *p)
 	if (!sched_feat(WAKEUP_PREEMPT))
 		return;
 
-	/*
-	 * preemption test can be made between sibling entities who are in the
-	 * same cfs_rq i.e who have a common parent. Walk up the hierarchy of
-	 * both tasks until we find their ancestors who are siblings of common
-	 * parent.
-	 */
-
-	/* First walk up until both entities are at same depth */
-	se_depth = depth_se(se);
-	pse_depth = depth_se(pse);
-
-	while (se_depth > pse_depth) {
-		se_depth--;
-		se = parent_entity(se);
-	}
-
-	while (pse_depth > se_depth) {
-		pse_depth--;
-		pse = parent_entity(pse);
-	}
-
-	while (!is_same_group(se, pse)) {
-		se = parent_entity(se);
-		pse = parent_entity(pse);
+	if (sched_feat(WAKEUP_OVERLAP) && (sync ||
+			(se->avg_overlap < sysctl_sched_migration_cost &&
+			 pse->avg_overlap < sysctl_sched_migration_cost))) {
+		resched_task(curr);
+		return;
 	}
 
-	if (wakeup_preempt_entity(se, pse) == 1)
+	delta_exec = se->sum_exec_runtime - se->prev_sum_exec_runtime;
+	if (delta_exec > wakeup_gran(pse))
 		resched_task(curr);
 }
 
@@ -1445,19 +1337,9 @@ __load_balance_iterator(struct cfs_rq *cfs_rq, struct list_head *next)
 	if (next == &cfs_rq->tasks)
 		return NULL;
 
-	/* Skip over entities that are not tasks */
-	do {
-		se = list_entry(next, struct sched_entity, group_node);
-		next = next->next;
-	} while (next != &cfs_rq->tasks && !entity_is_task(se));
-
-	if (next == &cfs_rq->tasks)
-		return NULL;
-
-	cfs_rq->balance_iterator = next;
-
-	if (entity_is_task(se))
-		p = task_of(se);
+	se = list_entry(next, struct sched_entity, group_node);
+	p = task_of(se);
+	cfs_rq->balance_iterator = next->next;
 
 	return p;
 }
@@ -1507,7 +1389,7 @@ load_balance_fair(struct rq *this_rq, int this_cpu, struct rq *busiest,
 	rcu_read_lock();
 	update_h_load(busiest_cpu);
 
-	list_for_each_entry(tg, &task_groups, list) {
+	list_for_each_entry_rcu(tg, &task_groups, list) {
 		struct cfs_rq *busiest_cfs_rq = tg->cfs_rq[busiest_cpu];
 		unsigned long busiest_h_load = busiest_cfs_rq->h_load;
 		unsigned long busiest_weight = busiest_cfs_rq->load.weight;
@@ -1620,10 +1502,10 @@ static void task_new_fair(struct rq *rq, struct task_struct *p)
 		 * 'current' within the tree based on its new key value.
 		 */
 		swap(curr->vruntime, se->vruntime);
+		resched_task(rq->curr);
 	}
 
 	enqueue_task_fair(rq, p, 0);
-	resched_task(rq->curr);
 }
 
 /*
@@ -1642,7 +1524,7 @@ static void prio_changed_fair(struct rq *rq, struct task_struct *p,
 		if (p->prio > oldprio)
 			resched_task(rq->curr);
 	} else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 /*
@@ -1659,7 +1541,7 @@ static void switched_to_fair(struct rq *rq, struct task_struct *p,
 	if (running)
 		resched_task(rq->curr);
 	else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 /* Account for a task changing its policy or group.
diff --git a/kernel/sched_features.h b/kernel/sched_features.h
index 9353ca7..7c9e8f4 100644
--- a/kernel/sched_features.h
+++ b/kernel/sched_features.h
@@ -11,3 +11,4 @@ SCHED_FEAT(ASYM_GRAN, 1)
 SCHED_FEAT(LB_BIAS, 1)
 SCHED_FEAT(LB_WAKEUP_UPDATE, 1)
 SCHED_FEAT(ASYM_EFF_LOAD, 1)
+SCHED_FEAT(WAKEUP_OVERLAP, 0)
diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
index 3a4f92d..dec4cca 100644
--- a/kernel/sched_idletask.c
+++ b/kernel/sched_idletask.c
@@ -14,7 +14,7 @@ static int select_task_rq_idle(struct task_struct *p, int sync)
 /*
  * Idle tasks are unconditionally rescheduled:
  */
-static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p)
+static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p, int sync)
 {
 	resched_task(rq->idle);
 }
@@ -76,7 +76,7 @@ static void switched_to_idle(struct rq *rq, struct task_struct *p,
 	if (running)
 		resched_task(rq->curr);
 	else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 static void prio_changed_idle(struct rq *rq, struct task_struct *p,
@@ -93,7 +93,7 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
 		if (p->prio > oldprio)
 			resched_task(rq->curr);
 	} else
-		check_preempt_curr(rq, p);
+		check_preempt_curr(rq, p, 0);
 }
 
 /*
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 1113157..cdf5740 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -102,12 +102,12 @@ static void dequeue_rt_entity(struct sched_rt_entity *rt_se);
 
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
+	struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
 	struct sched_rt_entity *rt_se = rt_rq->rt_se;
 
-	if (rt_se && !on_rt_rq(rt_se) && rt_rq->rt_nr_running) {
-		struct task_struct *curr = rq_of_rt_rq(rt_rq)->curr;
-
-		enqueue_rt_entity(rt_se);
+	if (rt_rq->rt_nr_running) {
+		if (rt_se && !on_rt_rq(rt_se))
+			enqueue_rt_entity(rt_se);
 		if (rt_rq->highest_prio < curr->prio)
 			resched_task(curr);
 	}
@@ -231,6 +231,9 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 #endif /* CONFIG_RT_GROUP_SCHED */
 
 #ifdef CONFIG_SMP
+/*
+ * We ran out of runtime, see if we can borrow some from our neighbours.
+ */
 static int do_balance_runtime(struct rt_rq *rt_rq)
 {
 	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
@@ -250,9 +253,18 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 			continue;
 
 		spin_lock(&iter->rt_runtime_lock);
+		/*
+		 * Either all rqs have inf runtime and there's nothing to steal
+		 * or __disable_runtime() below sets a specific rq to inf to
+		 * indicate its been disabled and disalow stealing.
+		 */
 		if (iter->rt_runtime == RUNTIME_INF)
 			goto next;
 
+		/*
+		 * From runqueues with spare time, take 1/n part of their
+		 * spare time, but no more than our period.
+		 */
 		diff = iter->rt_runtime - iter->rt_time;
 		if (diff > 0) {
 			diff = div_u64((u64)diff, weight);
@@ -274,6 +286,9 @@ next:
 	return more;
 }
 
+/*
+ * Ensure this RQ takes back all the runtime it lend to its neighbours.
+ */
 static void __disable_runtime(struct rq *rq)
 {
 	struct root_domain *rd = rq->rd;
@@ -289,17 +304,33 @@ static void __disable_runtime(struct rq *rq)
 
 		spin_lock(&rt_b->rt_runtime_lock);
 		spin_lock(&rt_rq->rt_runtime_lock);
+		/*
+		 * Either we're all inf and nobody needs to borrow, or we're
+		 * already disabled and thus have nothing to do, or we have
+		 * exactly the right amount of runtime to take out.
+		 */
 		if (rt_rq->rt_runtime == RUNTIME_INF ||
 				rt_rq->rt_runtime == rt_b->rt_runtime)
 			goto balanced;
 		spin_unlock(&rt_rq->rt_runtime_lock);
 
+		/*
+		 * Calculate the difference between what we started out with
+		 * and what we current have, that's the amount of runtime
+		 * we lend and now have to reclaim.
+		 */
 		want = rt_b->rt_runtime - rt_rq->rt_runtime;
 
+		/*
+		 * Greedy reclaim, take back as much as we can.
+		 */
 		for_each_cpu_mask(i, rd->span) {
 			struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 			s64 diff;
 
+			/*
+			 * Can't reclaim from ourselves or disabled runqueues.
+			 */
 			if (iter == rt_rq || iter->rt_runtime == RUNTIME_INF)
 				continue;
 
@@ -319,8 +350,16 @@ static void __disable_runtime(struct rq *rq)
 		}
 
 		spin_lock(&rt_rq->rt_runtime_lock);
+		/*
+		 * We cannot be left wanting - that would mean some runtime
+		 * leaked out of the system.
+		 */
 		BUG_ON(want);
 balanced:
+		/*
+		 * Disable all the borrow logic by pretending we have inf
+		 * runtime - in which case borrowing doesn't make sense.
+		 */
 		rt_rq->rt_runtime = RUNTIME_INF;
 		spin_unlock(&rt_rq->rt_runtime_lock);
 		spin_unlock(&rt_b->rt_runtime_lock);
@@ -343,6 +382,9 @@ static void __enable_runtime(struct rq *rq)
 	if (unlikely(!scheduler_running))
 		return;
 
+	/*
+	 * Reset each runqueue's bandwidth settings
+	 */
 	for_each_leaf_rt_rq(rt_rq, rq) {
 		struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
 
@@ -389,7 +431,7 @@ static int do_sched_rt_period_timer(struct rt_bandwidth *rt_b, int overrun)
 	int i, idle = 1;
 	cpumask_t span;
 
-	if (rt_b->rt_runtime == RUNTIME_INF)
+	if (!rt_bandwidth_enabled() || rt_b->rt_runtime == RUNTIME_INF)
 		return 1;
 
 	span = sched_rt_period_mask();
@@ -487,6 +529,9 @@ static void update_curr_rt(struct rq *rq)
 	curr->se.exec_start = rq->clock;
 	cpuacct_charge(curr, delta_exec);
 
+	if (!rt_bandwidth_enabled())
+		return;
+
 	for_each_sched_rt_entity(rt_se) {
 		rt_rq = rt_rq_of_se(rt_se);
 
@@ -784,7 +829,7 @@ static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
 /*
  * Preempt the current task with a newly woken task if needed:
  */
-static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p)
+static void check_preempt_curr_rt(struct rq *rq, struct task_struct *p, int sync)
 {
 	if (p->prio < rq->curr->prio) {
 		resched_task(rq->curr);
diff --git a/kernel/user.c b/kernel/user.c
index 865ecf5..39d6159 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -169,7 +169,7 @@ static ssize_t cpu_rt_runtime_show(struct kobject *kobj,
 {
 	struct user_struct *up = container_of(kobj, struct user_struct, kobj);
 
-	return sprintf(buf, "%lu\n", sched_group_rt_runtime(up->tg));
+	return sprintf(buf, "%ld\n", sched_group_rt_runtime(up->tg));
 }
 
 static ssize_t cpu_rt_runtime_store(struct kobject *kobj,
@@ -180,7 +180,7 @@ static ssize_t cpu_rt_runtime_store(struct kobject *kobj,
 	unsigned long rt_runtime;
 	int rc;
 
-	sscanf(buf, "%lu", &rt_runtime);
+	sscanf(buf, "%ld", &rt_runtime);
 
 	rc = sched_group_set_rt_runtime(up->tg, rt_runtime);
 
