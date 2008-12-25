Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbYLYNV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbYLYNV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 08:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYLYNVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 08:21:49 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41894 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbYLYNVm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 08:21:42 -0500
Date: Thu, 25 Dec 2008 14:21:15 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: [git pull] core kernel updates for v2.6.29
Message-ID: <20081225132115.GA27170@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

Please pull the latest core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git core-for-linus

12 topics were active in this cycle:

   core/debug               core/debugobjects        core/futexes
   core/iommu               core/locking             core/printk
   core/rcu                 core/resources           core/signal
   core/softirq             core/stacktrace          core/xen                 

Notable changes are the RCU-Tree implementation from Paul (which was long 
in the making, and which is to replace RCU-classic in the next cycle if 
all goes well), 'speculative' lockdep rules added by Nick to catch 
might_sleep() bugs, swiotlb extensions to make it available to 32-bit 
platforms - and more.

[ Note, this tree will generate conflicts if pulled after the x86,
  tracing and scheduler trees - i'll follow up with this mail with
  a conflict resolution commit. ]

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      lock debug: sit tight when we are already in a panic

Arjan van de Ven (6):
      debug: add notifier chain debugging
      debug: add notifier chain debugging, v2
      mutex: improve header comment to be actually informative about the API
      debug warnings: consolidate warn_slowpath and warn_on_slowpath
      debug warnings: print the DMI board info name in a WARN/WARN_ON
      resources: skip sanity check of busy resources

Darren Hart (2):
      futex: rename field in futex_q to clarify single waiter semantics
      futex: clean up futex_(un)lock_pi fault handling

David Brownell (1):
      genirq: warn when IRQF_DISABLED may be ignored

Hiroshi Shimamoto (2):
      uaccess: fix parameters inversion for __copy_from_user_inatomic()
      printk: fix discarding message when recursion_bug

Ian Campbell (7):
      swiotlb: move some definitions to header
      swiotlb: add comment where we handle the overflow of a dma mask on 32 bit
      swiotlb: allow architectures to override phys<->bus<->phys conversions
      swiotlb: add arch hook to force mapping
      swiotlb: consolidate swiotlb info message printing
      x86/swiotlb: add default phys<->bus conversion
      x86/swiotlb: add default swiotlb_arch_range_needs_mapping

Ingo Molnar (10):
      softlockup: increase hung tasks check from 2 minutes to 8 minutes
      x86: some lock annotations for user copy paths, v3
      Revert "lockdep: fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is not set"
      rcu: make rcu-stall debug printout more standard
      lockdep: include/linux/lockdep.h - fix warning in net/bluetooth/af_bluetooth.c
      lockdep: fix unused function warning in kernel/lockdep.c
      debugobjects: add boot parameter default value
      debug warnings: eliminate warn_on_slowpath()
      rcu: provide RCU options on non-preempt architectures too
      stacktrace: provide save_stack_trace_tsk() weak alias

Isaku Yamahata (3):
      xen: portability clean up and some minor clean up for xencomm.c
      xen: compilation fix fo xen CPU hotplugging
      xen: compilation fix of drivers/xen/events.c on IA64

Jeremy Fitzhardinge (7):
      xen: don't reload cr3 on suspend
      x86: remove unused iommu_nr_pages
      swiotlb: allow architectures to override swiotlb pool allocation
      swiotlb: factor out copy to/from device
      swiotlb: support bouncing of HighMem pages
      x86: add swiotlb allocation functions
      x86: unify pci iommu setup and allow swiotlb to compile for 32 bit

Liming Wang (1):
      softirq: remove useless function __local_bh_enable

Nick Piggin (3):
      x86: some lock annotations for user copy paths
      x86: some lock annotations for user copy paths, v2
      sched: improve preempt debugging

Oleg Nesterov (3):
      account_steal_time: kill the unneeded account_group_system_time()
      thread_group_cputime: kill the bogus ->signal != NULL check
      thread_group_cputime: move a couple of callsites outside of ->siglock

Paul E. McKenney (3):
      rcu: increase RCU stall-check timeouts
      rcu: fix rcutorture behavior during reboot
      "Tree RCU": scalable classic RCU implementation

Peter Zijlstra (10):
      lockstat: documentation update
      lockdep: add might_lock() / might_lock_read()
      lockstat: fixup signed division
      futex: rely on get_user_pages() for shared futexes
      futex: reduce mmap_sem usage
      futex: use fast_gup()
      futex: cleanup fshared
      futex: fixup get_futex_key() for private futexes
      lockstat: contend with points
      lockdep: change a held lock's class

Rui Sousa (2):
      lockdep: fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is not set
      lockdep, UML: fix compilation when CONFIG_TRACE_IRQFLAGS_SUPPORT is not set

Thomas Gleixner (1):
      futex: make clock selectable for FUTEX_WAIT_BITSET

Török Edwin (1):
      mutex: __used is needed for function referenced only from inline asm


 Documentation/RCU/00-INDEX             |    2 +
 Documentation/RCU/trace.txt            |  413 +++++++++
 Documentation/lockstat.txt             |   51 +-
 arch/powerpc/platforms/pseries/rtasd.c |    4 +
 arch/um/include/asm/system.h           |   14 +-
 arch/x86/include/asm/dma-mapping.h     |    2 +-
 arch/x86/include/asm/iommu.h           |    2 -
 arch/x86/include/asm/pci.h             |    2 +
 arch/x86/include/asm/pci_64.h          |    1 -
 arch/x86/include/asm/uaccess.h         |    2 +
 arch/x86/include/asm/uaccess_32.h      |    8 +-
 arch/x86/include/asm/uaccess_64.h      |    6 +
 arch/x86/kernel/Makefile               |    3 +-
 arch/x86/kernel/pci-dma.c              |   13 +-
 arch/x86/kernel/pci-swiotlb_64.c       |   29 +
 arch/x86/lib/usercopy_32.c             |    8 +-
 arch/x86/lib/usercopy_64.c             |    4 +-
 arch/x86/mm/init_32.c                  |    3 +
 include/asm-generic/bug.h              |    7 +-
 include/linux/bottom_half.h            |    1 -
 include/linux/debug_locks.h            |    2 +-
 include/linux/futex.h                  |    5 +-
 include/linux/hardirq.h                |   14 +-
 include/linux/kernel.h                 |   11 +
 include/linux/lockdep.h                |   43 +-
 include/linux/mutex.h                  |    2 +
 include/linux/rcuclassic.h             |    2 +-
 include/linux/rcupdate.h               |   10 +-
 include/linux/rcutree.h                |  329 +++++++
 include/linux/swiotlb.h                |   22 +
 include/linux/uaccess.h                |    2 +-
 init/Kconfig                           |   86 ++-
 kernel/Kconfig.preempt                 |   25 -
 kernel/Makefile                        |    6 +-
 kernel/exit.c                          |    2 +-
 kernel/extable.c                       |   16 +
 kernel/futex.c                         |  351 +++-----
 kernel/irq/manage.c                    |   12 +
 kernel/lockdep.c                       |   60 +-
 kernel/lockdep_proc.c                  |   28 +-
 kernel/mutex.c                         |   10 +-
 kernel/notifier.c                      |    8 +
 kernel/panic.c                         |   32 +-
 kernel/posix-cpu-timers.c              |   10 +-
 kernel/printk.c                        |    2 +-
 kernel/rcuclassic.c                    |    4 +-
 kernel/rcupreempt.c                    |   10 +
 kernel/rcupreempt_trace.c              |   10 +-
 kernel/rcutorture.c                    |   66 ++-
 kernel/rcutree.c                       | 1535 ++++++++++++++++++++++++++++++++
 kernel/rcutree_trace.c                 |  271 ++++++
 kernel/resource.c                      |    9 +
 kernel/sched.c                         |    3 +-
 kernel/softirq.c                       |   19 +-
 kernel/softlockup.c                    |    2 +-
 kernel/stacktrace.c                    |   11 +
 kernel/sys.c                           |    2 +-
 lib/Kconfig.debug                      |   31 +
 lib/debugobjects.c                     |    4 +-
 lib/swiotlb.c                          |  255 ++++--
 mm/memory.c                            |   15 +
 61 files changed, 3423 insertions(+), 489 deletions(-)
 create mode 100644 Documentation/RCU/trace.txt
 create mode 100644 include/linux/rcutree.h
 create mode 100644 kernel/rcutree.c
 create mode 100644 kernel/rcutree_trace.c

diff --git a/Documentation/RCU/00-INDEX b/Documentation/RCU/00-INDEX
index 461481d..7dc0695 100644
--- a/Documentation/RCU/00-INDEX
+++ b/Documentation/RCU/00-INDEX
@@ -16,6 +16,8 @@ RTFP.txt
 	- List of RCU papers (bibliography) going back to 1980.
 torture.txt
 	- RCU Torture Test Operation (CONFIG_RCU_TORTURE_TEST)
+trace.txt
+	- CONFIG_RCU_TRACE debugfs files and formats
 UP.txt
 	- RCU on Uniprocessor Systems
 whatisRCU.txt
diff --git a/Documentation/RCU/trace.txt b/Documentation/RCU/trace.txt
new file mode 100644
index 0000000..0688482
--- /dev/null
+++ b/Documentation/RCU/trace.txt
@@ -0,0 +1,413 @@
+CONFIG_RCU_TRACE debugfs Files and Formats
+
+
+The rcupreempt and rcutree implementations of RCU provide debugfs trace
+output that summarizes counters and state.  This information is useful for
+debugging RCU itself, and can sometimes also help to debug abuses of RCU.
+Note that the rcuclassic implementation of RCU does not provide debugfs
+trace output.
+
+The following sections describe the debugfs files and formats for
+preemptable RCU (rcupreempt) and hierarchical RCU (rcutree).
+
+
+Preemptable RCU debugfs Files and Formats
+
+This implementation of RCU provides three debugfs files under the
+top-level directory RCU: rcu/rcuctrs (which displays the per-CPU
+counters used by preemptable RCU) rcu/rcugp (which displays grace-period
+counters), and rcu/rcustats (which internal counters for debugging RCU).
+
+The output of "cat rcu/rcuctrs" looks as follows:
+
+CPU last cur F M
+  0    5  -5 0 0
+  1   -1   0 0 0
+  2    0   1 0 0
+  3    0   1 0 0
+  4    0   1 0 0
+  5    0   1 0 0
+  6    0   2 0 0
+  7    0  -1 0 0
+  8    0   1 0 0
+ggp = 26226, state = waitzero
+
+The per-CPU fields are as follows:
+
+o	"CPU" gives the CPU number.  Offline CPUs are not displayed.
+
+o	"last" gives the value of the counter that is being decremented
+	for the current grace period phase.  In the example above,
+	the counters sum to 4, indicating that there are still four
+	RCU read-side critical sections still running that started
+	before the last counter flip.
+
+o	"cur" gives the value of the counter that is currently being
+	both incremented (by rcu_read_lock()) and decremented (by
+	rcu_read_unlock()).  In the example above, the counters sum to
+	1, indicating that there is only one RCU read-side critical section
+	still running that started after the last counter flip.
+
+o	"F" indicates whether RCU is waiting for this CPU to acknowledge
+	a counter flip.  In the above example, RCU is not waiting on any,
+	which is consistent with the state being "waitzero" rather than
+	"waitack".
+
+o	"M" indicates whether RCU is waiting for this CPU to execute a
+	memory barrier.  In the above example, RCU is not waiting on any,
+	which is consistent with the state being "waitzero" rather than
+	"waitmb".
+
+o	"ggp" is the global grace-period counter.
+
+o	"state" is the RCU state, which can be one of the following:
+
+	o	"idle": there is no grace period in progress.
+
+	o	"waitack": RCU just incremented the global grace-period
+		counter, which has the effect of reversing the roles of
+		the "last" and "cur" counters above, and is waiting for
+		all the CPUs to acknowledge the flip.  Once the flip has
+		been acknowledged, CPUs will no longer be incrementing
+		what are now the "last" counters, so that their sum will
+		decrease monotonically down to zero.
+
+	o	"waitzero": RCU is waiting for the sum of the "last" counters
+		to decrease to zero.
+
+	o	"waitmb": RCU is waiting for each CPU to execute a memory
+		barrier, which ensures that instructions from a given CPU's
+		last RCU read-side critical section cannot be reordered
+		with instructions following the memory-barrier instruction.
+
+The output of "cat rcu/rcugp" looks as follows:
+
+oldggp=48870  newggp=48873
+
+Note that reading from this file provokes a synchronize_rcu().  The
+"oldggp" value is that of "ggp" from rcu/rcuctrs above, taken before
+executing the synchronize_rcu(), and the "newggp" value is also the
+"ggp" value, but taken after the synchronize_rcu() command returns.
+
+
+The output of "cat rcu/rcugp" looks as follows:
+
+na=1337955 nl=40 wa=1337915 wl=44 da=1337871 dl=0 dr=1337871 di=1337871
+1=50989 e1=6138 i1=49722 ie1=82 g1=49640 a1=315203 ae1=265563 a2=49640
+z1=1401244 ze1=1351605 z2=49639 m1=5661253 me1=5611614 m2=49639
+
+These are counters tracking internal preemptable-RCU events, however,
+some of them may be useful for debugging algorithms using RCU.  In
+particular, the "nl", "wl", and "dl" values track the number of RCU
+callbacks in various states.  The fields are as follows:
+
+o	"na" is the total number of RCU callbacks that have been enqueued
+	since boot.
+
+o	"nl" is the number of RCU callbacks waiting for the previous
+	grace period to end so that they can start waiting on the next
+	grace period.
+
+o	"wa" is the total number of RCU callbacks that have started waiting
+	for a grace period since boot.  "na" should be roughly equal to
+	"nl" plus "wa".
+
+o	"wl" is the number of RCU callbacks currently waiting for their
+	grace period to end.
+
+o	"da" is the total number of RCU callbacks whose grace periods
+	have completed since boot.  "wa" should be roughly equal to
+	"wl" plus "da".
+
+o	"dr" is the total number of RCU callbacks that have been removed
+	from the list of callbacks ready to invoke.  "dr" should be roughly
+	equal to "da".
+
+o	"di" is the total number of RCU callbacks that have been invoked
+	since boot.  "di" should be roughly equal to "da", though some
+	early versions of preemptable RCU had a bug so that only the
+	last CPU's count of invocations was displayed, rather than the
+	sum of all CPU's counts.
+
+o	"1" is the number of calls to rcu_try_flip().  This should be
+	roughly equal to the sum of "e1", "i1", "a1", "z1", and "m1"
+	described below.  In other words, the number of times that
+	the state machine is visited should be equal to the sum of the
+	number of times that each state is visited plus the number of
+	times that the state-machine lock acquisition failed.
+
+o	"e1" is the number of times that rcu_try_flip() was unable to
+	acquire the fliplock.
+
+o	"i1" is the number of calls to rcu_try_flip_idle().
+
+o	"ie1" is the number of times rcu_try_flip_idle() exited early
+	due to the calling CPU having no work for RCU.
+
+o	"g1" is the number of times that rcu_try_flip_idle() decided
+	to start a new grace period.  "i1" should be roughly equal to
+	"ie1" plus "g1".
+
+o	"a1" is the number of calls to rcu_try_flip_waitack().
+
+o	"ae1" is the number of times that rcu_try_flip_waitack() found
+	that at least one CPU had not yet acknowledge the new grace period
+	(AKA "counter flip").
+
+o	"a2" is the number of time rcu_try_flip_waitack() found that
+	all CPUs had acknowledged.  "a1" should be roughly equal to
+	"ae1" plus "a2".  (This particular output was collected on
+	a 128-CPU machine, hence the smaller-than-usual fraction of
+	calls to rcu_try_flip_waitack() finding all CPUs having already
+	acknowledged.)
+
+o	"z1" is the number of calls to rcu_try_flip_waitzero().
+
+o	"ze1" is the number of times that rcu_try_flip_waitzero() found
+	that not all of the old RCU read-side critical sections had
+	completed.
+
+o	"z2" is the number of times that rcu_try_flip_waitzero() finds
+	the sum of the counters equal to zero, in other words, that
+	all of the old RCU read-side critical sections had completed.
+	The value of "z1" should be roughly equal to "ze1" plus
+	"z2".
+
+o	"m1" is the number of calls to rcu_try_flip_waitmb().
+
+o	"me1" is the number of times that rcu_try_flip_waitmb() finds
+	that at least one CPU has not yet executed a memory barrier.
+
+o	"m2" is the number of times that rcu_try_flip_waitmb() finds that
+	all CPUs have executed a memory barrier.
+
+
+Hierarchical RCU debugfs Files and Formats
+
+This implementation of RCU provides three debugfs files under the
+top-level directory RCU: rcu/rcudata (which displays fields in struct
+rcu_data), rcu/rcugp (which displays grace-period counters), and
+rcu/rcuhier (which displays the struct rcu_node hierarchy).
+
+The output of "cat rcu/rcudata" looks as follows:
+
+rcu:
+  0 c=4011 g=4012 pq=1 pqc=4011 qp=0 rpfq=1 rp=3c2a dt=23301/73 dn=2 df=1882 of=0 ri=2126 ql=2 b=10
+  1 c=4011 g=4012 pq=1 pqc=4011 qp=0 rpfq=3 rp=39a6 dt=78073/1 dn=2 df=1402 of=0 ri=1875 ql=46 b=10
+  2 c=4010 g=4010 pq=1 pqc=4010 qp=0 rpfq=-5 rp=1d12 dt=16646/0 dn=2 df=3140 of=0 ri=2080 ql=0 b=10
+  3 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=2b50 dt=21159/1 dn=2 df=2230 of=0 ri=1923 ql=72 b=10
+  4 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=1644 dt=5783/1 dn=2 df=3348 of=0 ri=2805 ql=7 b=10
+  5 c=4012 g=4013 pq=0 pqc=4011 qp=1 rpfq=3 rp=1aac dt=5879/1 dn=2 df=3140 of=0 ri=2066 ql=10 b=10
+  6 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=ed8 dt=5847/1 dn=2 df=3797 of=0 ri=1266 ql=10 b=10
+  7 c=4012 g=4013 pq=1 pqc=4012 qp=1 rpfq=3 rp=1fa2 dt=6199/1 dn=2 df=2795 of=0 ri=2162 ql=28 b=10
+rcu_bh:
+  0 c=-268 g=-268 pq=1 pqc=-268 qp=0 rpfq=-145 rp=21d6 dt=23301/73 dn=2 df=0 of=0 ri=0 ql=0 b=10
+  1 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-170 rp=20ce dt=78073/1 dn=2 df=26 of=0 ri=5 ql=0 b=10
+  2 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-83 rp=fbd dt=16646/0 dn=2 df=28 of=0 ri=4 ql=0 b=10
+  3 c=-268 g=-268 pq=1 pqc=-268 qp=0 rpfq=-105 rp=178c dt=21159/1 dn=2 df=28 of=0 ri=2 ql=0 b=10
+  4 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-30 rp=b54 dt=5783/1 dn=2 df=32 of=0 ri=0 ql=0 b=10
+  5 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-29 rp=df5 dt=5879/1 dn=2 df=30 of=0 ri=3 ql=0 b=10
+  6 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-28 rp=788 dt=5847/1 dn=2 df=32 of=0 ri=0 ql=0 b=10
+  7 c=-268 g=-268 pq=1 pqc=-268 qp=1 rpfq=-53 rp=1098 dt=6199/1 dn=2 df=30 of=0 ri=3 ql=0 b=10
+
+The first section lists the rcu_data structures for rcu, the second for
+rcu_bh.  Each section has one line per CPU, or eight for this 8-CPU system.
+The fields are as follows:
+
+o	The number at the beginning of each line is the CPU number.
+	CPUs numbers followed by an exclamation mark are offline,
+	but have been online at least once since boot.	There will be
+	no output for CPUs that have never been online, which can be
+	a good thing in the surprisingly common case where NR_CPUS is
+	substantially larger than the number of actual CPUs.
+
+o	"c" is the count of grace periods that this CPU believes have
+	completed.  CPUs in dynticks idle mode may lag quite a ways
+	behind, for example, CPU 4 under "rcu" above, which has slept
+	through the past 25 RCU grace periods.	It is not unusual to
+	see CPUs lagging by thousands of grace periods.
+
+o	"g" is the count of grace periods that this CPU believes have
+	started.  Again, CPUs in dynticks idle mode may lag behind.
+	If the "c" and "g" values are equal, this CPU has already
+	reported a quiescent state for the last RCU grace period that
+	it is aware of, otherwise, the CPU believes that it owes RCU a
+	quiescent state.
+
+o	"pq" indicates that this CPU has passed through a quiescent state
+	for the current grace period.  It is possible for "pq" to be
+	"1" and "c" different than "g", which indicates that although
+	the CPU has passed through a quiescent state, either (1) this
+	CPU has not yet reported that fact, (2) some other CPU has not
+	yet reported for this grace period, or (3) both.
+
+o	"pqc" indicates which grace period the last-observed quiescent
+	state for this CPU corresponds to.  This is important for handling
+	the race between CPU 0 reporting an extended dynticks-idle
+	quiescent state for CPU 1 and CPU 1 suddenly waking up and
+	reporting its own quiescent state.  If CPU 1 was the last CPU
+	for the current grace period, then the CPU that loses this race
+	will attempt to incorrectly mark CPU 1 as having checked in for
+	the next grace period!
+
+o	"qp" indicates that RCU still expects a quiescent state from
+	this CPU.
+
+o	"rpfq" is the number of rcu_pending() calls on this CPU required
+	to induce this CPU to invoke force_quiescent_state().
+
+o	"rp" is low-order four hex digits of the count of how many times
+	rcu_pending() has been invoked on this CPU.
+
+o	"dt" is the current value of the dyntick counter that is incremented
+	when entering or leaving dynticks idle state, either by the
+	scheduler or by irq.  The number after the "/" is the interrupt
+	nesting depth when in dyntick-idle state, or one greater than
+	the interrupt-nesting depth otherwise.
+
+	This field is displayed only for CONFIG_NO_HZ kernels.
+
+o	"dn" is the current value of the dyntick counter that is incremented
+	when entering or leaving dynticks idle state via NMI.  If both
+	the "dt" and "dn" values are even, then this CPU is in dynticks
+	idle mode and may be ignored by RCU.  If either of these two
+	counters is odd, then RCU must be alert to the possibility of
+	an RCU read-side critical section running on this CPU.
+
+	This field is displayed only for CONFIG_NO_HZ kernels.
+
+o	"df" is the number of times that some other CPU has forced a
+	quiescent state on behalf of this CPU due to this CPU being in
+	dynticks-idle state.
+
+	This field is displayed only for CONFIG_NO_HZ kernels.
+
+o	"of" is the number of times that some other CPU has forced a
+	quiescent state on behalf of this CPU due to this CPU being
+	offline.  In a perfect world, this might neve happen, but it
+	turns out that offlining and onlining a CPU can take several grace
+	periods, and so there is likely to be an extended period of time
+	when RCU believes that the CPU is online when it really is not.
+	Please note that erring in the other direction (RCU believing a
+	CPU is offline when it is really alive and kicking) is a fatal
+	error, so it makes sense to err conservatively.
+
+o	"ri" is the number of times that RCU has seen fit to send a
+	reschedule IPI to this CPU in order to get it to report a
+	quiescent state.
+
+o	"ql" is the number of RCU callbacks currently residing on
+	this CPU.  This is the total number of callbacks, regardless
+	of what state they are in (new, waiting for grace period to
+	start, waiting for grace period to end, ready to invoke).
+
+o	"b" is the batch limit for this CPU.  If more than this number
+	of RCU callbacks is ready to invoke, then the remainder will
+	be deferred.
+
+
+The output of "cat rcu/rcugp" looks as follows:
+
+rcu: completed=33062  gpnum=33063
+rcu_bh: completed=464  gpnum=464
+
+Again, this output is for both "rcu" and "rcu_bh".  The fields are
+taken from the rcu_state structure, and are as follows:
+
+o	"completed" is the number of grace periods that have completed.
+	It is comparable to the "c" field from rcu/rcudata in that a
+	CPU whose "c" field matches the value of "completed" is aware
+	that the corresponding RCU grace period has completed.
+
+o	"gpnum" is the number of grace periods that have started.  It is
+	comparable to the "g" field from rcu/rcudata in that a CPU
+	whose "g" field matches the value of "gpnum" is aware that the
+	corresponding RCU grace period has started.
+
+	If these two fields are equal (as they are for "rcu_bh" above),
+	then there is no grace period in progress, in other words, RCU
+	is idle.  On the other hand, if the two fields differ (as they
+	do for "rcu" above), then an RCU grace period is in progress.
+
+
+The output of "cat rcu/rcuhier" looks as follows, with very long lines:
+
+c=6902 g=6903 s=2 jfq=3 j=72c7 nfqs=13142/nfqsng=0(13142) fqlh=6
+1/1 0:127 ^0    
+3/3 0:35 ^0    0/0 36:71 ^1    0/0 72:107 ^2    0/0 108:127 ^3    
+3/3f 0:5 ^0    2/3 6:11 ^1    0/0 12:17 ^2    0/0 18:23 ^3    0/0 24:29 ^4    0/0 30:35 ^5    0/0 36:41 ^0    0/0 42:47 ^1    0/0 48:53 ^2    0/0 54:59 ^3    0/0 60:65 ^4    0/0 66:71 ^5    0/0 72:77 ^0    0/0 78:83 ^1    0/0 84:89 ^2    0/0 90:95 ^3    0/0 96:101 ^4    0/0 102:107 ^5    0/0 108:113 ^0    0/0 114:119 ^1    0/0 120:125 ^2    0/0 126:127 ^3    
+rcu_bh:
+c=-226 g=-226 s=1 jfq=-5701 j=72c7 nfqs=88/nfqsng=0(88) fqlh=0
+0/1 0:127 ^0    
+0/3 0:35 ^0    0/0 36:71 ^1    0/0 72:107 ^2    0/0 108:127 ^3    
+0/3f 0:5 ^0    0/3 6:11 ^1    0/0 12:17 ^2    0/0 18:23 ^3    0/0 24:29 ^4    0/0 30:35 ^5    0/0 36:41 ^0    0/0 42:47 ^1    0/0 48:53 ^2    0/0 54:59 ^3    0/0 60:65 ^4    0/0 66:71 ^5    0/0 72:77 ^0    0/0 78:83 ^1    0/0 84:89 ^2    0/0 90:95 ^3    0/0 96:101 ^4    0/0 102:107 ^5    0/0 108:113 ^0    0/0 114:119 ^1    0/0 120:125 ^2    0/0 126:127 ^3
+
+This is once again split into "rcu" and "rcu_bh" portions.  The fields are
+as follows:
+
+o	"c" is exactly the same as "completed" under rcu/rcugp.
+
+o	"g" is exactly the same as "gpnum" under rcu/rcugp.
+
+o	"s" is the "signaled" state that drives force_quiescent_state()'s
+	state machine.
+
+o	"jfq" is the number of jiffies remaining for this grace period
+	before force_quiescent_state() is invoked to help push things
+	along.  Note that CPUs in dyntick-idle mode thoughout the grace
+	period will not report on their own, but rather must be check by
+	some other CPU via force_quiescent_state().
+
+o	"j" is the low-order four hex digits of the jiffies counter.
+	Yes, Paul did run into a number of problems that turned out to
+	be due to the jiffies counter no longer counting.  Why do you ask?
+
+o	"nfqs" is the number of calls to force_quiescent_state() since
+	boot.
+
+o	"nfqsng" is the number of useless calls to force_quiescent_state(),
+	where there wasn't actually a grace period active.  This can
+	happen due to races.  The number in parentheses is the difference
+	between "nfqs" and "nfqsng", or the number of times that
+	force_quiescent_state() actually did some real work.
+
+o	"fqlh" is the number of calls to force_quiescent_state() that
+	exited immediately (without even being counted in nfqs above)
+	due to contention on ->fqslock.
+
+o	Each element of the form "1/1 0:127 ^0" represents one struct
+	rcu_node.  Each line represents one level of the hierarchy, from
+	root to leaves.  It is best to think of the rcu_data structures
+	as forming yet another level after the leaves.  Note that there
+	might be either one, two, or three levels of rcu_node structures,
+	depending on the relationship between CONFIG_RCU_FANOUT and
+	CONFIG_NR_CPUS.
+	
+	o	The numbers separated by the "/" are the qsmask followed
+		by the qsmaskinit.  The qsmask will have one bit
+		set for each entity in the next lower level that
+		has not yet checked in for the current grace period.
+		The qsmaskinit will have one bit for each entity that is
+		currently expected to check in during each grace period.
+		The value of qsmaskinit is assigned to that of qsmask
+		at the beginning of each grace period.
+
+		For example, for "rcu", the qsmask of the first entry
+		of the lowest level is 0x14, meaning that we are still
+		waiting for CPUs 2 and 4 to check in for the current
+		grace period.
+
+	o	The numbers separated by the ":" are the range of CPUs
+		served by this struct rcu_node.  This can be helpful
+		in working out how the hierarchy is wired together.
+
+		For example, the first entry at the lowest level shows
+		"0:5", indicating that it covers CPUs 0 through 5.
+
+	o	The number after the "^" indicates the bit in the
+		next higher level rcu_node structure that this
+		rcu_node structure corresponds to.
+
+		For example, the first entry at the lowest level shows
+		"^0", indicating that it corresponds to bit zero in
+		the first entry at the middle level.
diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
index 4ba4664..9cb9138 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -71,35 +71,50 @@ Look at the current lock statistics:
 
 # less /proc/lock_stat
 
-01 lock_stat version 0.2
+01 lock_stat version 0.3
 02 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 03                               class name    con-bounces    contentions   waittime-min   waittime-max waittime-total    acq-bounces   acquisitions   holdtime-min   holdtime-max holdtime-total
 04 -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 05
-06               &inode->i_data.tree_lock-W:            15          21657           0.18     1093295.30 11547131054.85             58          10415           0.16          87.51        6387.60
-07               &inode->i_data.tree_lock-R:             0              0           0.00           0.00           0.00          23302         231198           0.25           8.45       98023.38
-08               --------------------------
-09                 &inode->i_data.tree_lock              0          [<ffffffff8027c08f>] add_to_page_cache+0x5f/0x190
-10
-11 ...............................................................................................................................................................................................
-12
-13                              dcache_lock:          1037           1161           0.38          45.32         774.51           6611         243371           0.15         306.48       77387.24
-14                              -----------
-15                              dcache_lock            180          [<ffffffff802c0d7e>] sys_getcwd+0x11e/0x230
-16                              dcache_lock            165          [<ffffffff802c002a>] d_alloc+0x15a/0x210
-17                              dcache_lock             33          [<ffffffff8035818d>] _atomic_dec_and_lock+0x4d/0x70
-18                              dcache_lock              1          [<ffffffff802beef8>] shrink_dcache_parent+0x18/0x130
+06                          &mm->mmap_sem-W:           233            538 18446744073708       22924.27      607243.51           1342          45806           1.71        8595.89     1180582.34
+07                          &mm->mmap_sem-R:           205            587 18446744073708       28403.36      731975.00           1940         412426           0.58      187825.45     6307502.88
+08                          ---------------
+09                            &mm->mmap_sem            487          [<ffffffff8053491f>] do_page_fault+0x466/0x928
+10                            &mm->mmap_sem            179          [<ffffffff802a6200>] sys_mprotect+0xcd/0x21d
+11                            &mm->mmap_sem            279          [<ffffffff80210a57>] sys_mmap+0x75/0xce
+12                            &mm->mmap_sem             76          [<ffffffff802a490b>] sys_munmap+0x32/0x59
+13                          ---------------
+14                            &mm->mmap_sem            270          [<ffffffff80210a57>] sys_mmap+0x75/0xce
+15                            &mm->mmap_sem            431          [<ffffffff8053491f>] do_page_fault+0x466/0x928
+16                            &mm->mmap_sem            138          [<ffffffff802a490b>] sys_munmap+0x32/0x59
+17                            &mm->mmap_sem            145          [<ffffffff802a6200>] sys_mprotect+0xcd/0x21d
+18
+19 ...............................................................................................................................................................................................
+20
+21                              dcache_lock:           621            623           0.52         118.26        1053.02           6745          91930           0.29         316.29      118423.41
+22                              -----------
+23                              dcache_lock            179          [<ffffffff80378274>] _atomic_dec_and_lock+0x34/0x54
+24                              dcache_lock            113          [<ffffffff802cc17b>] d_alloc+0x19a/0x1eb
+25                              dcache_lock             99          [<ffffffff802ca0dc>] d_rehash+0x1b/0x44
+26                              dcache_lock            104          [<ffffffff802cbca0>] d_instantiate+0x36/0x8a
+27                              -----------
+28                              dcache_lock            192          [<ffffffff80378274>] _atomic_dec_and_lock+0x34/0x54
+29                              dcache_lock             98          [<ffffffff802ca0dc>] d_rehash+0x1b/0x44
+30                              dcache_lock             72          [<ffffffff802cc17b>] d_alloc+0x19a/0x1eb
+31                              dcache_lock            112          [<ffffffff802cbca0>] d_instantiate+0x36/0x8a
 
 This excerpt shows the first two lock class statistics. Line 01 shows the
 output version - each time the format changes this will be updated. Line 02-04
-show the header with column descriptions. Lines 05-10 and 13-18 show the actual
+show the header with column descriptions. Lines 05-18 and 20-31 show the actual
 statistics. These statistics come in two parts; the actual stats separated by a
-short separator (line 08, 14) from the contention points.
+short separator (line 08, 13) from the contention points.
 
-The first lock (05-10) is a read/write lock, and shows two lines above the
+The first lock (05-18) is a read/write lock, and shows two lines above the
 short separator. The contention points don't match the column descriptors,
-they have two: contentions and [<IP>] symbol.
+they have two: contentions and [<IP>] symbol. The second set of contention
+points are the points we're contending with.
 
+The integer part of the time values is in us.
 
 View the top contending locks:
 
diff --git a/arch/powerpc/platforms/pseries/rtasd.c b/arch/powerpc/platforms/pseries/rtasd.c
index f4e55be..afad9f5 100644
--- a/arch/powerpc/platforms/pseries/rtasd.c
+++ b/arch/powerpc/platforms/pseries/rtasd.c
@@ -208,6 +208,7 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 		break;
 	case ERR_TYPE_KERNEL_PANIC:
 	default:
+		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		return;
 	}
@@ -227,6 +228,7 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 	/* Check to see if we need to or have stopped logging */
 	if (fatal || !logging_enabled) {
 		logging_enabled = 0;
+		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		return;
 	}
@@ -249,11 +251,13 @@ void pSeries_log_error(char *buf, unsigned int err_type, int fatal)
 		else
 			rtas_log_start += 1;
 
+		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		wake_up_interruptible(&rtas_log_wait);
 		break;
 	case ERR_TYPE_KERNEL_PANIC:
 	default:
+		WARN_ON_ONCE(!irqs_disabled()); /* @@@ DEBUG @@@ */
 		spin_unlock_irqrestore(&rtasd_log_lock, s);
 		return;
 	}
diff --git a/arch/um/include/asm/system.h b/arch/um/include/asm/system.h
index 753346e..ae5f94d 100644
--- a/arch/um/include/asm/system.h
+++ b/arch/um/include/asm/system.h
@@ -11,21 +11,21 @@ extern int get_signals(void);
 extern void block_signals(void);
 extern void unblock_signals(void);
 
-#define local_save_flags(flags) do { typecheck(unsigned long, flags); \
+#define raw_local_save_flags(flags) do { typecheck(unsigned long, flags); \
 				     (flags) = get_signals(); } while(0)
-#define local_irq_restore(flags) do { typecheck(unsigned long, flags); \
+#define raw_local_irq_restore(flags) do { typecheck(unsigned long, flags); \
 				      set_signals(flags); } while(0)
 
-#define local_irq_save(flags) do { local_save_flags(flags); \
-                                   local_irq_disable(); } while(0)
+#define raw_local_irq_save(flags) do { raw_local_save_flags(flags); \
+                                   raw_local_irq_disable(); } while(0)
 
-#define local_irq_enable() unblock_signals()
-#define local_irq_disable() block_signals()
+#define raw_local_irq_enable() unblock_signals()
+#define raw_local_irq_disable() block_signals()
 
 #define irqs_disabled()                 \
 ({                                      \
         unsigned long flags;            \
-        local_save_flags(flags);        \
+        raw_local_save_flags(flags);        \
         (flags == 0);                   \
 })
 
diff --git a/arch/x86/include/asm/dma-mapping.h b/arch/x86/include/asm/dma-mapping.h
index 097794f..3b43a65 100644
--- a/arch/x86/include/asm/dma-mapping.h
+++ b/arch/x86/include/asm/dma-mapping.h
@@ -65,7 +65,7 @@ static inline struct dma_mapping_ops *get_dma_ops(struct device *dev)
 		return dma_ops;
 	else
 		return dev->archdata.dma_ops;
-#endif /* _ASM_X86_DMA_MAPPING_H */
+#endif
 }
 
 /* Make sure we keep the same behaviour */
diff --git a/arch/x86/include/asm/iommu.h b/arch/x86/include/asm/iommu.h
index 0b500c5..35276ec 100644
--- a/arch/x86/include/asm/iommu.h
+++ b/arch/x86/include/asm/iommu.h
@@ -7,8 +7,6 @@ extern struct dma_mapping_ops nommu_dma_ops;
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
 
-extern unsigned long iommu_nr_pages(unsigned long addr, unsigned long len);
-
 /* 10 seconds */
 #define DMAR_OPERATION_TIMEOUT ((cycles_t) tsc_khz*10*1000)
 
diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 875b38e..50ac542 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -82,6 +82,8 @@ static inline void pci_dma_burst_advice(struct pci_dev *pdev,
 static inline void early_quirks(void) { }
 #endif
 
+extern void pci_iommu_alloc(void);
+
 #endif  /* __KERNEL__ */
 
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/include/asm/pci_64.h b/arch/x86/include/asm/pci_64.h
index d02d936..4da2079 100644
--- a/arch/x86/include/asm/pci_64.h
+++ b/arch/x86/include/asm/pci_64.h
@@ -23,7 +23,6 @@ extern int (*pci_config_write)(int seg, int bus, int dev, int fn,
 			       int reg, int len, u32 value);
 
 extern void dma32_reserve_bootmem(void);
-extern void pci_iommu_alloc(void);
 
 /* The PCI address space does equal the physical memory
  * address space.  The networking and block device layers use
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 35c5492..99192bb 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -157,6 +157,7 @@ extern int __get_user_bad(void);
 	int __ret_gu;							\
 	unsigned long __val_gu;						\
 	__chk_user_ptr(ptr);						\
+	might_fault();							\
 	switch (sizeof(*(ptr))) {					\
 	case 1:								\
 		__get_user_x(1, __ret_gu, __val_gu, ptr);		\
@@ -241,6 +242,7 @@ extern void __put_user_8(void);
 	int __ret_pu;						\
 	__typeof__(*(ptr)) __pu_val;				\
 	__chk_user_ptr(ptr);					\
+	might_fault();						\
 	__pu_val = x;						\
 	switch (sizeof(*(ptr))) {				\
 	case 1:							\
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index d095a3a..5e06259 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -82,8 +82,8 @@ __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
 static __always_inline unsigned long __must_check
 __copy_to_user(void __user *to, const void *from, unsigned long n)
 {
-       might_sleep();
-       return __copy_to_user_inatomic(to, from, n);
+	might_fault();
+	return __copy_to_user_inatomic(to, from, n);
 }
 
 static __always_inline unsigned long
@@ -137,7 +137,7 @@ __copy_from_user_inatomic(void *to, const void __user *from, unsigned long n)
 static __always_inline unsigned long
 __copy_from_user(void *to, const void __user *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
@@ -159,7 +159,7 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
 static __always_inline unsigned long __copy_from_user_nocache(void *to,
 				const void __user *from, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (__builtin_constant_p(n)) {
 		unsigned long ret;
 
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index f8cfd00..84210c4 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -29,6 +29,8 @@ static __always_inline __must_check
 int __copy_from_user(void *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
+
+	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic(dst, (__force void *)src, size);
 	switch (size) {
@@ -71,6 +73,8 @@ static __always_inline __must_check
 int __copy_to_user(void __user *dst, const void *src, unsigned size)
 {
 	int ret = 0;
+
+	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst, src, size);
 	switch (size) {
@@ -113,6 +117,8 @@ static __always_inline __must_check
 int __copy_in_user(void __user *dst, const void __user *src, unsigned size)
 {
 	int ret = 0;
+
+	might_fault();
 	if (!__builtin_constant_p(size))
 		return copy_user_generic((__force void *)dst,
 					 (__force void *)src, size);
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index b62a766..a9c656f 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -105,6 +105,8 @@ microcode-$(CONFIG_MICROCODE_INTEL)	+= microcode_intel.o
 microcode-$(CONFIG_MICROCODE_AMD)	+= microcode_amd.o
 obj-$(CONFIG_MICROCODE)			+= microcode.o
 
+obj-$(CONFIG_SWIOTLB)			+= pci-swiotlb_64.o # NB rename without _64
+
 ###
 # 64 bit specific files
 ifeq ($(CONFIG_X86_64),y)
@@ -118,7 +120,6 @@ ifeq ($(CONFIG_X86_64),y)
         obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
         obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
         obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
-        obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb_64.o
 
         obj-$(CONFIG_PCI_MMCONFIG)	+= mmconf-fam10h_64.o
 endif
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 1926248..00e0744 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -105,11 +105,15 @@ static void __init dma32_free_bootmem(void)
 	dma32_bootmem_ptr = NULL;
 	dma32_bootmem_size = 0;
 }
+#endif
 
 void __init pci_iommu_alloc(void)
 {
+#ifdef CONFIG_X86_64
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
+#endif
+
 	/*
 	 * The order of these functions is important for
 	 * fall-back/fail-over reasons
@@ -125,15 +129,6 @@ void __init pci_iommu_alloc(void)
 	pci_swiotlb_init();
 }
 
-unsigned long iommu_nr_pages(unsigned long addr, unsigned long len)
-{
-	unsigned long size = roundup((addr & ~PAGE_MASK) + len, PAGE_SIZE);
-
-	return size >> PAGE_SHIFT;
-}
-EXPORT_SYMBOL(iommu_nr_pages);
-#endif
-
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,
 				 dma_addr_t *dma_addr, gfp_t flag)
 {
diff --git a/arch/x86/kernel/pci-swiotlb_64.c b/arch/x86/kernel/pci-swiotlb_64.c
index 3c539d1..242c344 100644
--- a/arch/x86/kernel/pci-swiotlb_64.c
+++ b/arch/x86/kernel/pci-swiotlb_64.c
@@ -3,6 +3,8 @@
 #include <linux/pci.h>
 #include <linux/cache.h>
 #include <linux/module.h>
+#include <linux/swiotlb.h>
+#include <linux/bootmem.h>
 #include <linux/dma-mapping.h>
 
 #include <asm/iommu.h>
@@ -11,6 +13,31 @@
 
 int swiotlb __read_mostly;
 
+void *swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+{
+	return alloc_bootmem_low_pages(size);
+}
+
+void *swiotlb_alloc(unsigned order, unsigned long nslabs)
+{
+	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
+}
+
+dma_addr_t swiotlb_phys_to_bus(phys_addr_t paddr)
+{
+	return paddr;
+}
+
+phys_addr_t swiotlb_bus_to_phys(dma_addr_t baddr)
+{
+	return baddr;
+}
+
+int __weak swiotlb_arch_range_needs_mapping(void *ptr, size_t size)
+{
+	return 0;
+}
+
 static dma_addr_t
 swiotlb_map_single_phys(struct device *hwdev, phys_addr_t paddr, size_t size,
 			int direction)
@@ -50,8 +77,10 @@ struct dma_mapping_ops swiotlb_dma_ops = {
 void __init pci_swiotlb_init(void)
 {
 	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
+#ifdef CONFIG_X86_64
 	if (!iommu_detected && !no_iommu && max_pfn > MAX_DMA32_PFN)
 	       swiotlb = 1;
+#endif
 	if (swiotlb_force)
 		swiotlb = 1;
 	if (swiotlb) {
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 9e68075..4a20b2f 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -39,7 +39,7 @@ static inline int __movsl_is_ok(unsigned long a1, unsigned long a2, unsigned lon
 #define __do_strncpy_from_user(dst, src, count, res)			   \
 do {									   \
 	int __d0, __d1, __d2;						   \
-	might_sleep();							   \
+	might_fault();							   \
 	__asm__ __volatile__(						   \
 		"	testl %1,%1\n"					   \
 		"	jz 2f\n"					   \
@@ -126,7 +126,7 @@ EXPORT_SYMBOL(strncpy_from_user);
 #define __do_clear_user(addr,size)					\
 do {									\
 	int __d0;							\
-	might_sleep();							\
+	might_fault();							\
 	__asm__ __volatile__(						\
 		"0:	rep; stosl\n"					\
 		"	movl %2,%0\n"					\
@@ -155,7 +155,7 @@ do {									\
 unsigned long
 clear_user(void __user *to, unsigned long n)
 {
-	might_sleep();
+	might_fault();
 	if (access_ok(VERIFY_WRITE, to, n))
 		__do_clear_user(to, n);
 	return n;
@@ -197,7 +197,7 @@ long strnlen_user(const char __user *s, long n)
 	unsigned long mask = -__addr_ok(s);
 	unsigned long res, tmp;
 
-	might_sleep();
+	might_fault();
 
 	__asm__ __volatile__(
 		"	testl %0, %0\n"
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index f4df6e7..64d6c84 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -15,7 +15,7 @@
 #define __do_strncpy_from_user(dst,src,count,res)			   \
 do {									   \
 	long __d0, __d1, __d2;						   \
-	might_sleep();							   \
+	might_fault();							   \
 	__asm__ __volatile__(						   \
 		"	testq %1,%1\n"					   \
 		"	jz 2f\n"					   \
@@ -64,7 +64,7 @@ EXPORT_SYMBOL(strncpy_from_user);
 unsigned long __clear_user(void __user *addr, unsigned long size)
 {
 	long __d0;
-	might_sleep();
+	might_fault();
 	/* no memory constraint because it doesn't change any memory gcc knows
 	   about */
 	asm volatile(
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index c483f42..2b4b14f 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -21,6 +21,7 @@
 #include <linux/init.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/pci.h>
 #include <linux/pfn.h>
 #include <linux/poison.h>
 #include <linux/bootmem.h>
@@ -971,6 +972,8 @@ void __init mem_init(void)
 
 	start_periodic_check_for_corruption();
 
+	pci_iommu_alloc();
+
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 12c07c1..b8ba694 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -33,15 +33,14 @@ struct bug_entry {
 
 #ifndef __WARN
 #ifndef __ASSEMBLY__
-extern void warn_on_slowpath(const char *file, const int line);
 extern void warn_slowpath(const char *file, const int line,
 		const char *fmt, ...) __attribute__((format(printf, 3, 4)));
 #define WANT_WARN_ON_SLOWPATH
 #endif
-#define __WARN() warn_on_slowpath(__FILE__, __LINE__)
-#define __WARN_printf(arg...) warn_slowpath(__FILE__, __LINE__, arg)
+#define __WARN()		warn_slowpath(__FILE__, __LINE__, NULL)
+#define __WARN_printf(arg...)	warn_slowpath(__FILE__, __LINE__, arg)
 #else
-#define __WARN_printf(arg...) do { printk(arg); __WARN(); } while (0)
+#define __WARN_printf(arg...)	do { printk(arg); __WARN(); } while (0)
 #endif
 
 #ifndef WARN_ON
diff --git a/include/linux/bottom_half.h b/include/linux/bottom_half.h
index 777dbf6..27b1bcf 100644
--- a/include/linux/bottom_half.h
+++ b/include/linux/bottom_half.h
@@ -2,7 +2,6 @@
 #define _LINUX_BH_H
 
 extern void local_bh_disable(void);
-extern void __local_bh_enable(void);
 extern void _local_bh_enable(void);
 extern void local_bh_enable(void);
 extern void local_bh_enable_ip(unsigned long ip);
diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
index 4aaa4af..096476f 100644
--- a/include/linux/debug_locks.h
+++ b/include/linux/debug_locks.h
@@ -17,7 +17,7 @@ extern int debug_locks_off(void);
 ({									\
 	int __ret = 0;							\
 									\
-	if (unlikely(c)) {						\
+	if (!oops_in_progress && unlikely(c)) {				\
 		if (debug_locks_off() && !debug_locks_silent)		\
 			WARN_ON(1);					\
 		__ret = 1;						\
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 586ab56..3bf5bb5 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -25,7 +25,8 @@ union ktime;
 #define FUTEX_WAKE_BITSET	10
 
 #define FUTEX_PRIVATE_FLAG	128
-#define FUTEX_CMD_MASK		~FUTEX_PRIVATE_FLAG
+#define FUTEX_CLOCK_REALTIME	256
+#define FUTEX_CMD_MASK		~(FUTEX_PRIVATE_FLAG | FUTEX_CLOCK_REALTIME)
 
 #define FUTEX_WAIT_PRIVATE	(FUTEX_WAIT | FUTEX_PRIVATE_FLAG)
 #define FUTEX_WAKE_PRIVATE	(FUTEX_WAKE | FUTEX_PRIVATE_FLAG)
@@ -164,6 +165,8 @@ union futex_key {
 	} both;
 };
 
+#define FUTEX_KEY_INIT (union futex_key) { .both = { .ptr = NULL } }
+
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
 extern void exit_pi_state_list(struct task_struct *curr);
diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 181006c..9b70b92 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -118,13 +118,17 @@ static inline void account_system_vtime(struct task_struct *tsk)
 }
 #endif
 
-#if defined(CONFIG_PREEMPT_RCU) && defined(CONFIG_NO_HZ)
+#if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU)
 extern void rcu_irq_enter(void);
 extern void rcu_irq_exit(void);
+extern void rcu_nmi_enter(void);
+extern void rcu_nmi_exit(void);
 #else
 # define rcu_irq_enter() do { } while (0)
 # define rcu_irq_exit() do { } while (0)
-#endif /* CONFIG_PREEMPT_RCU */
+# define rcu_nmi_enter() do { } while (0)
+# define rcu_nmi_exit() do { } while (0)
+#endif /* #if defined(CONFIG_NO_HZ) && !defined(CONFIG_CLASSIC_RCU) */
 
 /*
  * It is safe to do non-atomic ops on ->hardirq_context,
@@ -134,7 +138,6 @@ extern void rcu_irq_exit(void);
  */
 #define __irq_enter()					\
 	do {						\
-		rcu_irq_enter();			\
 		account_system_vtime(current);		\
 		add_preempt_count(HARDIRQ_OFFSET);	\
 		trace_hardirq_enter();			\
@@ -153,7 +156,6 @@ extern void irq_enter(void);
 		trace_hardirq_exit();			\
 		account_system_vtime(current);		\
 		sub_preempt_count(HARDIRQ_OFFSET);	\
-		rcu_irq_exit();				\
 	} while (0)
 
 /*
@@ -161,7 +163,7 @@ extern void irq_enter(void);
  */
 extern void irq_exit(void);
 
-#define nmi_enter()		do { lockdep_off(); __irq_enter(); } while (0)
-#define nmi_exit()		do { __irq_exit(); lockdep_on(); } while (0)
+#define nmi_enter()		do { lockdep_off(); rcu_nmi_enter(); __irq_enter(); } while (0)
+#define nmi_exit()		do { __irq_exit(); rcu_nmi_exit(); lockdep_on(); } while (0)
 
 #endif /* LINUX_HARDIRQ_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index dc7e0d0..269df5a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -141,6 +141,15 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
+#ifdef CONFIG_PROVE_LOCKING
+void might_fault(void);
+#else
+static inline void might_fault(void)
+{
+	might_sleep();
+}
+#endif
+
 extern struct atomic_notifier_head panic_notifier_list;
 extern long (*panic_blink)(long time);
 NORET_TYPE void panic(const char * fmt, ...)
@@ -188,6 +197,8 @@ extern unsigned long long memparse(const char *ptr, char **retptr);
 extern int core_kernel_text(unsigned long addr);
 extern int __kernel_text_address(unsigned long addr);
 extern int kernel_text_address(unsigned long addr);
+extern int func_ptr_is_kernel_text(void *ptr);
+
 struct pid;
 extern struct pid *session_of_pgrp(struct pid *pgrp);
 
diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index 29aec6e..37a0361 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -73,6 +73,8 @@ struct lock_class_key {
 	struct lockdep_subclass_key	subkeys[MAX_LOCKDEP_SUBCLASSES];
 };
 
+#define LOCKSTAT_POINTS		4
+
 /*
  * The lock-class itself:
  */
@@ -119,7 +121,8 @@ struct lock_class {
 	int				name_version;
 
 #ifdef CONFIG_LOCK_STAT
-	unsigned long			contention_point[4];
+	unsigned long			contention_point[LOCKSTAT_POINTS];
+	unsigned long			contending_point[LOCKSTAT_POINTS];
 #endif
 };
 
@@ -144,6 +147,7 @@ enum bounce_type {
 
 struct lock_class_stats {
 	unsigned long			contention_point[4];
+	unsigned long			contending_point[4];
 	struct lock_time		read_waittime;
 	struct lock_time		write_waittime;
 	struct lock_time		read_holdtime;
@@ -165,6 +169,7 @@ struct lockdep_map {
 	const char			*name;
 #ifdef CONFIG_LOCK_STAT
 	int				cpu;
+	unsigned long			ip;
 #endif
 };
 
@@ -309,8 +314,15 @@ extern void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 extern void lock_release(struct lockdep_map *lock, int nested,
 			 unsigned long ip);
 
-extern void lock_set_subclass(struct lockdep_map *lock, unsigned int subclass,
-			      unsigned long ip);
+extern void lock_set_class(struct lockdep_map *lock, const char *name,
+			   struct lock_class_key *key, unsigned int subclass,
+			   unsigned long ip);
+
+static inline void lock_set_subclass(struct lockdep_map *lock,
+		unsigned int subclass, unsigned long ip)
+{
+	lock_set_class(lock, lock->name, lock->key, subclass, ip);
+}
 
 # define INIT_LOCKDEP				.lockdep_recursion = 0,
 
@@ -328,6 +340,7 @@ static inline void lockdep_on(void)
 
 # define lock_acquire(l, s, t, r, c, n, i)	do { } while (0)
 # define lock_release(l, n, i)			do { } while (0)
+# define lock_set_class(l, n, k, s, i)		do { } while (0)
 # define lock_set_subclass(l, s, i)		do { } while (0)
 # define lockdep_init()				do { } while (0)
 # define lockdep_info()				do { } while (0)
@@ -356,7 +369,7 @@ struct lock_class_key { };
 #ifdef CONFIG_LOCK_STAT
 
 extern void lock_contended(struct lockdep_map *lock, unsigned long ip);
-extern void lock_acquired(struct lockdep_map *lock);
+extern void lock_acquired(struct lockdep_map *lock, unsigned long ip);
 
 #define LOCK_CONTENDED(_lock, try, lock)			\
 do {								\
@@ -364,13 +377,13 @@ do {								\
 		lock_contended(&(_lock)->dep_map, _RET_IP_);	\
 		lock(_lock);					\
 	}							\
-	lock_acquired(&(_lock)->dep_map);			\
+	lock_acquired(&(_lock)->dep_map, _RET_IP_);			\
 } while (0)
 
 #else /* CONFIG_LOCK_STAT */
 
 #define lock_contended(lockdep_map, ip) do {} while (0)
-#define lock_acquired(lockdep_map) do {} while (0)
+#define lock_acquired(lockdep_map, ip) do {} while (0)
 
 #define LOCK_CONTENDED(_lock, try, lock) \
 	lock(_lock)
@@ -481,4 +494,22 @@ static inline void print_irqtrace_events(struct task_struct *curr)
 # define lock_map_release(l)			do { } while (0)
 #endif
 
+#ifdef CONFIG_PROVE_LOCKING
+# define might_lock(lock) 						\
+do {									\
+	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
+	lock_acquire(&(lock)->dep_map, 0, 0, 0, 2, NULL, _THIS_IP_);	\
+	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
+} while (0)
+# define might_lock_read(lock) 						\
+do {									\
+	typecheck(struct lockdep_map *, &(lock)->dep_map);		\
+	lock_acquire(&(lock)->dep_map, 0, 0, 1, 2, NULL, _THIS_IP_);	\
+	lock_release(&(lock)->dep_map, 0, _THIS_IP_);			\
+} while (0)
+#else
+# define might_lock(lock) do { } while (0)
+# define might_lock_read(lock) do { } while (0)
+#endif
+
 #endif /* __LINUX_LOCKDEP_H */
diff --git a/include/linux/mutex.h b/include/linux/mutex.h
index bc6da10..7a0e5c4 100644
--- a/include/linux/mutex.h
+++ b/include/linux/mutex.h
@@ -144,6 +144,8 @@ extern int __must_check mutex_lock_killable(struct mutex *lock);
 /*
  * NOTE: mutex_trylock() follows the spin_trylock() convention,
  *       not the down_trylock() convention!
+ *
+ * Returns 1 if the mutex has been acquired successfully, and 0 on contention.
  */
 extern int mutex_trylock(struct mutex *lock);
 extern void mutex_unlock(struct mutex *lock);
diff --git a/include/linux/rcuclassic.h b/include/linux/rcuclassic.h
index 5f89b62..301dda8 100644
--- a/include/linux/rcuclassic.h
+++ b/include/linux/rcuclassic.h
@@ -41,7 +41,7 @@
 #include <linux/seqlock.h>
 
 #ifdef CONFIG_RCU_CPU_STALL_DETECTOR
-#define RCU_SECONDS_TILL_STALL_CHECK	( 3 * HZ) /* for rcp->jiffies_stall */
+#define RCU_SECONDS_TILL_STALL_CHECK	(10 * HZ) /* for rcp->jiffies_stall */
 #define RCU_SECONDS_TILL_STALL_RECHECK	(30 * HZ) /* for rcp->jiffies_stall */
 #endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 86f1f5e..bfd289a 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -52,11 +52,15 @@ struct rcu_head {
 	void (*func)(struct rcu_head *head);
 };
 
-#ifdef CONFIG_CLASSIC_RCU
+#if defined(CONFIG_CLASSIC_RCU)
 #include <linux/rcuclassic.h>
-#else /* #ifdef CONFIG_CLASSIC_RCU */
+#elif defined(CONFIG_TREE_RCU)
+#include <linux/rcutree.h>
+#elif defined(CONFIG_PREEMPT_RCU)
 #include <linux/rcupreempt.h>
-#endif /* #else #ifdef CONFIG_CLASSIC_RCU */
+#else
+#error "Unknown RCU implementation specified to kernel configuration"
+#endif /* #else #if defined(CONFIG_CLASSIC_RCU) */
 
 #define RCU_HEAD_INIT 	{ .next = NULL, .func = NULL }
 #define RCU_HEAD(head) struct rcu_head head = RCU_HEAD_INIT
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
new file mode 100644
index 0000000..d4368b7
--- /dev/null
+++ b/include/linux/rcutree.h
@@ -0,0 +1,329 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion (tree-based version)
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
+ * Author: Dipankar Sarma <dipankar@in.ibm.com>
+ *	   Paul E. McKenney <paulmck@linux.vnet.ibm.com> Hierarchical algorithm
+ *
+ * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
+ * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 	Documentation/RCU
+ */
+
+#ifndef __LINUX_RCUTREE_H
+#define __LINUX_RCUTREE_H
+
+#include <linux/cache.h>
+#include <linux/spinlock.h>
+#include <linux/threads.h>
+#include <linux/percpu.h>
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
+	/* 5) state to allow this CPU to force_quiescent_state on others */
+	long n_rcu_pending;		/* rcu_pending() calls since boot. */
+	long n_rcu_pending_force_qs;	/* when to force quiescent states. */
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
+extern struct rcu_state rcu_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_data);
+
+extern struct rcu_state rcu_bh_state;
+DECLARE_PER_CPU(struct rcu_data, rcu_bh_data);
+
+/*
+ * Increment the quiescent state counter.
+ * The counter is a bit degenerated: We do not need to know
+ * how many quiescent states passed, just if there was at least
+ * one since the start of the grace period. Thus just a flag.
+ */
+static inline void rcu_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
+static inline void rcu_bh_qsctr_inc(int cpu)
+{
+	struct rcu_data *rdp = &per_cpu(rcu_bh_data, cpu);
+	rdp->passed_quiesc = 1;
+	rdp->passed_quiesc_completed = rdp->completed;
+}
+
+extern int rcu_pending(int cpu);
+extern int rcu_needs_cpu(int cpu);
+
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
+static inline void __rcu_read_lock(void)
+{
+	preempt_disable();
+	__acquire(RCU);
+	rcu_read_acquire();
+}
+static inline void __rcu_read_unlock(void)
+{
+	rcu_read_release();
+	__release(RCU);
+	preempt_enable();
+}
+static inline void __rcu_read_lock_bh(void)
+{
+	local_bh_disable();
+	__acquire(RCU_BH);
+	rcu_read_acquire();
+}
+static inline void __rcu_read_unlock_bh(void)
+{
+	rcu_read_release();
+	__release(RCU_BH);
+	local_bh_enable();
+}
+
+#define __synchronize_sched() synchronize_rcu()
+
+#define call_rcu_sched(head, func) call_rcu(head, func)
+
+static inline void rcu_init_sched(void)
+{
+}
+
+extern void __rcu_init(void);
+extern void rcu_check_callbacks(int cpu, int user);
+extern void rcu_restart_cpu(int cpu);
+
+extern long rcu_batches_completed(void);
+extern long rcu_batches_completed_bh(void);
+
+#ifdef CONFIG_NO_HZ
+void rcu_enter_nohz(void);
+void rcu_exit_nohz(void);
+#else /* CONFIG_NO_HZ */
+static inline void rcu_enter_nohz(void)
+{
+}
+static inline void rcu_exit_nohz(void)
+{
+}
+#endif /* CONFIG_NO_HZ */
+
+#endif /* __LINUX_RCUTREE_H */
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index b18ec55..325af1d 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -7,9 +7,31 @@ struct device;
 struct dma_attrs;
 struct scatterlist;
 
+/*
+ * Maximum allowable number of contiguous slabs to map,
+ * must be a power of 2.  What is the appropriate value ?
+ * The complexity of {map,unmap}_single is linearly dependent on this value.
+ */
+#define IO_TLB_SEGSIZE	128
+
+
+/*
+ * log of the size of each IO TLB slab.  The number of slabs is command line
+ * controllable.
+ */
+#define IO_TLB_SHIFT 11
+
 extern void
 swiotlb_init(void);
 
+extern void *swiotlb_alloc_boot(size_t bytes, unsigned long nslabs);
+extern void *swiotlb_alloc(unsigned order, unsigned long nslabs);
+
+extern dma_addr_t swiotlb_phys_to_bus(phys_addr_t address);
+extern phys_addr_t swiotlb_bus_to_phys(dma_addr_t address);
+
+extern int swiotlb_arch_range_needs_mapping(void *ptr, size_t size);
+
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 			dma_addr_t *dma_handle, gfp_t flags);
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index fec6dec..6b58367 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -78,7 +78,7 @@ static inline unsigned long __copy_from_user_nocache(void *to,
 							\
 		set_fs(KERNEL_DS);			\
 		pagefault_disable();			\
-		ret = __get_user(retval, (__force typeof(retval) __user *)(addr));		\
+		ret = __copy_from_user_inatomic(&(retval), (__force typeof(retval) __user *)(addr), sizeof(retval));		\
 		pagefault_enable();			\
 		set_fs(old_fs);				\
 		ret;					\
diff --git a/init/Kconfig b/init/Kconfig
index f763762..6b0fded 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -928,10 +928,90 @@ source "block/Kconfig"
 config PREEMPT_NOTIFIERS
 	bool
 
+choice
+	prompt "RCU Implementation"
+	default CLASSIC_RCU
+
 config CLASSIC_RCU
-	def_bool !PREEMPT_RCU
+	bool "Classic RCU"
 	help
 	  This option selects the classic RCU implementation that is
 	  designed for best read-side performance on non-realtime
-	  systems.  Classic RCU is the default.  Note that the
-	  PREEMPT_RCU symbol is used to select/deselect this option.
+	  systems.
+
+	  Select this option if you are unsure.
+
+config TREE_RCU
+	bool "Tree-based hierarchical RCU"
+	help
+	  This option selects the RCU implementation that is
+	  designed for very large SMP system with hundreds or
+	  thousands of CPUs.
+
+config PREEMPT_RCU
+	bool "Preemptible RCU"
+	depends on PREEMPT
+	help
+	  This option reduces the latency of the kernel by making certain
+	  RCU sections preemptible. Normally RCU code is non-preemptible, if
+	  this option is selected then read-only RCU sections become
+	  preemptible. This helps latency, but may expose bugs due to
+	  now-naive assumptions about each RCU read-side critical section
+	  remaining on a given CPU through its execution.
+
+endchoice
+
+config RCU_TRACE
+	bool "Enable tracing for RCU"
+	depends on TREE_RCU || PREEMPT_RCU
+	help
+	  This option provides tracing in RCU which presents stats
+	  in debugfs for debugging RCU implementation.
+
+	  Say Y here if you want to enable RCU tracing
+	  Say N if you are unsure.
+
+config RCU_FANOUT
+	int "Tree-based hierarchical RCU fanout value"
+	range 2 64 if 64BIT
+	range 2 32 if !64BIT
+	depends on TREE_RCU
+	default 64 if 64BIT
+	default 32 if !64BIT
+	help
+	  This option controls the fanout of hierarchical implementations
+	  of RCU, allowing RCU to work efficiently on machines with
+	  large numbers of CPUs.  This value must be at least the cube
+	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
+	  systems and up to 262,144 for 64-bit systems.
+
+	  Select a specific number if testing RCU itself.
+	  Take the default if unsure.
+
+config RCU_FANOUT_EXACT
+	bool "Disable tree-based hierarchical RCU auto-balancing"
+	depends on TREE_RCU
+	default n
+	help
+	  This option forces use of the exact RCU_FANOUT value specified,
+	  regardless of imbalances in the hierarchy.  This is useful for
+	  testing RCU itself, and might one day be useful on systems with
+	  strong NUMA behavior.
+
+	  Without RCU_FANOUT_EXACT, the code will balance the hierarchy.
+
+	  Say N if unsure.
+
+config TREE_RCU_TRACE
+	def_bool RCU_TRACE && TREE_RCU
+	select DEBUG_FS
+	help
+	  This option provides tracing for the TREE_RCU implementation,
+	  permitting Makefile to trivially select kernel/rcutree_trace.c.
+
+config PREEMPT_RCU_TRACE
+	def_bool RCU_TRACE && PREEMPT_RCU
+	select DEBUG_FS
+	help
+	  This option provides tracing for the PREEMPT_RCU implementation,
+	  permitting Makefile to trivially select kernel/rcupreempt_trace.c.
diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
index 9fdba03..bf987b9 100644
--- a/kernel/Kconfig.preempt
+++ b/kernel/Kconfig.preempt
@@ -52,28 +52,3 @@ config PREEMPT
 
 endchoice
 
-config PREEMPT_RCU
-	bool "Preemptible RCU"
-	depends on PREEMPT
-	default n
-	help
-	  This option reduces the latency of the kernel by making certain
-	  RCU sections preemptible. Normally RCU code is non-preemptible, if
-	  this option is selected then read-only RCU sections become
-	  preemptible. This helps latency, but may expose bugs due to
-	  now-naive assumptions about each RCU read-side critical section
-	  remaining on a given CPU through its execution.
-
-	  Say N if you are unsure.
-
-config RCU_TRACE
-	bool "Enable tracing for RCU - currently stats in debugfs"
-	depends on PREEMPT_RCU
-	select DEBUG_FS
-	default y
-	help
-	  This option provides tracing in RCU which presents stats
-	  in debugfs for debugging RCU implementation.
-
-	  Say Y here if you want to enable RCU tracing
-	  Say N if you are unsure.
diff --git a/kernel/Makefile b/kernel/Makefile
index 19fad00..b4fdbbf 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -74,10 +74,10 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_CLASSIC_RCU) += rcuclassic.o
+obj-$(CONFIG_TREE_RCU) += rcutree.o
 obj-$(CONFIG_PREEMPT_RCU) += rcupreempt.o
-ifeq ($(CONFIG_PREEMPT_RCU),y)
-obj-$(CONFIG_RCU_TRACE) += rcupreempt_trace.o
-endif
+obj-$(CONFIG_TREE_RCU_TRACE) += rcutree_trace.o
+obj-$(CONFIG_PREEMPT_RCU_TRACE) += rcupreempt_trace.o
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
diff --git a/kernel/exit.c b/kernel/exit.c
index 2d8be7e..30fcdf1 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1321,10 +1321,10 @@ static int wait_task_zombie(struct task_struct *p, int options,
 		 * group, which consolidates times for all threads in the
 		 * group including the group leader.
 		 */
+		thread_group_cputime(p, &cputime);
 		spin_lock_irq(&p->parent->sighand->siglock);
 		psig = p->parent->signal;
 		sig = p->signal;
-		thread_group_cputime(p, &cputime);
 		psig->cutime =
 			cputime_add(psig->cutime,
 			cputime_add(cputime.utime,
diff --git a/kernel/extable.c b/kernel/extable.c
index a26cb2e..adf0cc9 100644
--- a/kernel/extable.c
+++ b/kernel/extable.c
@@ -66,3 +66,19 @@ int kernel_text_address(unsigned long addr)
 		return 1;
 	return module_text_address(addr) != NULL;
 }
+
+/*
+ * On some architectures (PPC64, IA64) function pointers
+ * are actually only tokens to some data that then holds the
+ * real function address. As a result, to find if a function
+ * pointer is part of the kernel text, we need to do some
+ * special dereferencing first.
+ */
+int func_ptr_is_kernel_text(void *ptr)
+{
+	unsigned long addr;
+	addr = (unsigned long) dereference_function_descriptor(ptr);
+	if (core_kernel_text(addr))
+		return 1;
+	return module_text_address(addr) != NULL;
+}
diff --git a/kernel/futex.c b/kernel/futex.c
index 8af1002..b4f87ba 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -92,11 +92,12 @@ struct futex_pi_state {
  * A futex_q has a woken state, just like tasks have TASK_RUNNING.
  * It is considered woken when plist_node_empty(&q->list) || q->lock_ptr == 0.
  * The order of wakup is always to make the first condition true, then
- * wake up q->waiters, then make the second condition true.
+ * wake up q->waiter, then make the second condition true.
  */
 struct futex_q {
 	struct plist_node list;
-	wait_queue_head_t waiters;
+	/* There can only be a single waiter */
+	wait_queue_head_t waiter;
 
 	/* Which hash list lock to use: */
 	spinlock_t *lock_ptr;
@@ -123,24 +124,6 @@ struct futex_hash_bucket {
 static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];
 
 /*
- * Take mm->mmap_sem, when futex is shared
- */
-static inline void futex_lock_mm(struct rw_semaphore *fshared)
-{
-	if (fshared)
-		down_read(fshared);
-}
-
-/*
- * Release mm->mmap_sem, when the futex is shared
- */
-static inline void futex_unlock_mm(struct rw_semaphore *fshared)
-{
-	if (fshared)
-		up_read(fshared);
-}
-
-/*
  * We hash on the keys returned from get_futex_key (see below).
  */
 static struct futex_hash_bucket *hash_futex(union futex_key *key)
@@ -161,6 +144,45 @@ static inline int match_futex(union futex_key *key1, union futex_key *key2)
 		&& key1->both.offset == key2->both.offset);
 }
 
+/*
+ * Take a reference to the resource addressed by a key.
+ * Can be called while holding spinlocks.
+ *
+ */
+static void get_futex_key_refs(union futex_key *key)
+{
+	if (!key->both.ptr)
+		return;
+
+	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
+	case FUT_OFF_INODE:
+		atomic_inc(&key->shared.inode->i_count);
+		break;
+	case FUT_OFF_MMSHARED:
+		atomic_inc(&key->private.mm->mm_count);
+		break;
+	}
+}
+
+/*
+ * Drop a reference to the resource addressed by a key.
+ * The hash bucket spinlock must not be held.
+ */
+static void drop_futex_key_refs(union futex_key *key)
+{
+	if (!key->both.ptr)
+		return;
+
+	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
+	case FUT_OFF_INODE:
+		iput(key->shared.inode);
+		break;
+	case FUT_OFF_MMSHARED:
+		mmdrop(key->private.mm);
+		break;
+	}
+}
+
 /**
  * get_futex_key - Get parameters which are the keys for a futex.
  * @uaddr: virtual address of the futex
@@ -179,12 +201,10 @@ static inline int match_futex(union futex_key *key1, union futex_key *key2)
  * For other futexes, it points to &current->mm->mmap_sem and
  * caller must have taken the reader lock. but NOT any spinlocks.
  */
-static int get_futex_key(u32 __user *uaddr, struct rw_semaphore *fshared,
-			 union futex_key *key)
+static int get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
 	struct page *page;
 	int err;
 
@@ -208,100 +228,50 @@ static int get_futex_key(u32 __user *uaddr, struct rw_semaphore *fshared,
 			return -EFAULT;
 		key->private.mm = mm;
 		key->private.address = address;
+		get_futex_key_refs(key);
 		return 0;
 	}
-	/*
-	 * The futex is hashed differently depending on whether
-	 * it's in a shared or private mapping.  So check vma first.
-	 */
-	vma = find_extend_vma(mm, address);
-	if (unlikely(!vma))
-		return -EFAULT;
 
-	/*
-	 * Permissions.
-	 */
-	if (unlikely((vma->vm_flags & (VM_IO|VM_READ)) != VM_READ))
-		return (vma->vm_flags & VM_IO) ? -EPERM : -EACCES;
+again:
+	err = get_user_pages_fast(address, 1, 0, &page);
+	if (err < 0)
+		return err;
+
+	lock_page(page);
+	if (!page->mapping) {
+		unlock_page(page);
+		put_page(page);
+		goto again;
+	}
 
 	/*
 	 * Private mappings are handled in a simple way.
 	 *
 	 * NOTE: When userspace waits on a MAP_SHARED mapping, even if
 	 * it's a read-only handle, it's expected that futexes attach to
-	 * the object not the particular process.  Therefore we use
-	 * VM_MAYSHARE here, not VM_SHARED which is restricted to shared
-	 * mappings of _writable_ handles.
+	 * the object not the particular process.
 	 */
-	if (likely(!(vma->vm_flags & VM_MAYSHARE))) {
-		key->both.offset |= FUT_OFF_MMSHARED; /* reference taken on mm */
+	if (PageAnon(page)) {
+		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
 		key->private.mm = mm;
 		key->private.address = address;
-		return 0;
+	} else {
+		key->both.offset |= FUT_OFF_INODE; /* inode-based key */
+		key->shared.inode = page->mapping->host;
+		key->shared.pgoff = page->index;
 	}
 
-	/*
-	 * Linear file mappings are also simple.
-	 */
-	key->shared.inode = vma->vm_file->f_path.dentry->d_inode;
-	key->both.offset |= FUT_OFF_INODE; /* inode-based key. */
-	if (likely(!(vma->vm_flags & VM_NONLINEAR))) {
-		key->shared.pgoff = (((address - vma->vm_start) >> PAGE_SHIFT)
-				     + vma->vm_pgoff);
-		return 0;
-	}
+	get_futex_key_refs(key);
 
-	/*
-	 * We could walk the page table to read the non-linear
-	 * pte, and get the page index without fetching the page
-	 * from swap.  But that's a lot of code to duplicate here
-	 * for a rare case, so we simply fetch the page.
-	 */
-	err = get_user_pages(current, mm, address, 1, 0, 0, &page, NULL);
-	if (err >= 0) {
-		key->shared.pgoff =
-			page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
-		put_page(page);
-		return 0;
-	}
-	return err;
-}
-
-/*
- * Take a reference to the resource addressed by a key.
- * Can be called while holding spinlocks.
- *
- */
-static void get_futex_key_refs(union futex_key *key)
-{
-	if (key->both.ptr == NULL)
-		return;
-	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
-		case FUT_OFF_INODE:
-			atomic_inc(&key->shared.inode->i_count);
-			break;
-		case FUT_OFF_MMSHARED:
-			atomic_inc(&key->private.mm->mm_count);
-			break;
-	}
+	unlock_page(page);
+	put_page(page);
+	return 0;
 }
 
-/*
- * Drop a reference to the resource addressed by a key.
- * The hash bucket spinlock must not be held.
- */
-static void drop_futex_key_refs(union futex_key *key)
+static inline
+void put_futex_key(int fshared, union futex_key *key)
 {
-	if (!key->both.ptr)
-		return;
-	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
-		case FUT_OFF_INODE:
-			iput(key->shared.inode);
-			break;
-		case FUT_OFF_MMSHARED:
-			mmdrop(key->private.mm);
-			break;
-	}
+	drop_futex_key_refs(key);
 }
 
 static u32 cmpxchg_futex_value_locked(u32 __user *uaddr, u32 uval, u32 newval)
@@ -328,10 +298,8 @@ static int get_futex_value_locked(u32 *dest, u32 __user *from)
 
 /*
  * Fault handling.
- * if fshared is non NULL, current->mm->mmap_sem is already held
  */
-static int futex_handle_fault(unsigned long address,
-			      struct rw_semaphore *fshared, int attempt)
+static int futex_handle_fault(unsigned long address, int attempt)
 {
 	struct vm_area_struct * vma;
 	struct mm_struct *mm = current->mm;
@@ -340,8 +308,7 @@ static int futex_handle_fault(unsigned long address,
 	if (attempt > 2)
 		return ret;
 
-	if (!fshared)
-		down_read(&mm->mmap_sem);
+	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, address);
 	if (vma && address >= vma->vm_start &&
 	    (vma->vm_flags & VM_WRITE)) {
@@ -361,8 +328,7 @@ static int futex_handle_fault(unsigned long address,
 				current->min_flt++;
 		}
 	}
-	if (!fshared)
-		up_read(&mm->mmap_sem);
+	up_read(&mm->mmap_sem);
 	return ret;
 }
 
@@ -385,6 +351,7 @@ static int refill_pi_state_cache(void)
 	/* pi_mutex gets initialized later */
 	pi_state->owner = NULL;
 	atomic_set(&pi_state->refcount, 1);
+	pi_state->key = FUTEX_KEY_INIT;
 
 	current->pi_state_cache = pi_state;
 
@@ -462,7 +429,7 @@ void exit_pi_state_list(struct task_struct *curr)
 	struct list_head *next, *head = &curr->pi_state_list;
 	struct futex_pi_state *pi_state;
 	struct futex_hash_bucket *hb;
-	union futex_key key;
+	union futex_key key = FUTEX_KEY_INIT;
 
 	if (!futex_cmpxchg_enabled)
 		return;
@@ -607,7 +574,7 @@ static void wake_futex(struct futex_q *q)
 	 * The lock in wake_up_all() is a crucial memory barrier after the
 	 * plist_del() and also before assigning to q->lock_ptr.
 	 */
-	wake_up_all(&q->waiters);
+	wake_up(&q->waiter);
 	/*
 	 * The waiting task can free the futex_q as soon as this is written,
 	 * without taking any locks.  This must come last.
@@ -719,20 +686,17 @@ double_lock_hb(struct futex_hash_bucket *hb1, struct futex_hash_bucket *hb2)
  * Wake up all waiters hashed on the physical page that is mapped
  * to this virtual address:
  */
-static int futex_wake(u32 __user *uaddr, struct rw_semaphore *fshared,
-		      int nr_wake, u32 bitset)
+static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
 	struct plist_head *head;
-	union futex_key key;
+	union futex_key key = FUTEX_KEY_INIT;
 	int ret;
 
 	if (!bitset)
 		return -EINVAL;
 
-	futex_lock_mm(fshared);
-
 	ret = get_futex_key(uaddr, fshared, &key);
 	if (unlikely(ret != 0))
 		goto out;
@@ -760,7 +724,7 @@ static int futex_wake(u32 __user *uaddr, struct rw_semaphore *fshared,
 
 	spin_unlock(&hb->lock);
 out:
-	futex_unlock_mm(fshared);
+	put_futex_key(fshared, &key);
 	return ret;
 }
 
@@ -769,19 +733,16 @@ out:
  * to this virtual address:
  */
 static int
-futex_wake_op(u32 __user *uaddr1, struct rw_semaphore *fshared,
-	      u32 __user *uaddr2,
+futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
 	      int nr_wake, int nr_wake2, int op)
 {
-	union futex_key key1, key2;
+	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head;
 	struct futex_q *this, *next;
 	int ret, op_ret, attempt = 0;
 
 retryfull:
-	futex_lock_mm(fshared);
-
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
@@ -826,18 +787,12 @@ retry:
 		 */
 		if (attempt++) {
 			ret = futex_handle_fault((unsigned long)uaddr2,
-						 fshared, attempt);
+						 attempt);
 			if (ret)
 				goto out;
 			goto retry;
 		}
 
-		/*
-		 * If we would have faulted, release mmap_sem,
-		 * fault it in and start all over again.
-		 */
-		futex_unlock_mm(fshared);
-
 		ret = get_user(dummy, uaddr2);
 		if (ret)
 			return ret;
@@ -873,7 +828,8 @@ retry:
 	if (hb1 != hb2)
 		spin_unlock(&hb2->lock);
 out:
-	futex_unlock_mm(fshared);
+	put_futex_key(fshared, &key2);
+	put_futex_key(fshared, &key1);
 
 	return ret;
 }
@@ -882,19 +838,16 @@ out:
  * Requeue all waiters hashed on one physical page to another
  * physical page.
  */
-static int futex_requeue(u32 __user *uaddr1, struct rw_semaphore *fshared,
-			 u32 __user *uaddr2,
+static int futex_requeue(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
 			 int nr_wake, int nr_requeue, u32 *cmpval)
 {
-	union futex_key key1, key2;
+	union futex_key key1 = FUTEX_KEY_INIT, key2 = FUTEX_KEY_INIT;
 	struct futex_hash_bucket *hb1, *hb2;
 	struct plist_head *head1;
 	struct futex_q *this, *next;
 	int ret, drop_count = 0;
 
  retry:
-	futex_lock_mm(fshared);
-
 	ret = get_futex_key(uaddr1, fshared, &key1);
 	if (unlikely(ret != 0))
 		goto out;
@@ -917,12 +870,6 @@ static int futex_requeue(u32 __user *uaddr1, struct rw_semaphore *fshared,
 			if (hb1 != hb2)
 				spin_unlock(&hb2->lock);
 
-			/*
-			 * If we would have faulted, release mmap_sem, fault
-			 * it in and start all over again.
-			 */
-			futex_unlock_mm(fshared);
-
 			ret = get_user(curval, uaddr1);
 
 			if (!ret)
@@ -974,7 +921,8 @@ out_unlock:
 		drop_futex_key_refs(&key1);
 
 out:
-	futex_unlock_mm(fshared);
+	put_futex_key(fshared, &key2);
+	put_futex_key(fshared, &key1);
 	return ret;
 }
 
@@ -983,7 +931,7 @@ static inline struct futex_hash_bucket *queue_lock(struct futex_q *q)
 {
 	struct futex_hash_bucket *hb;
 
-	init_waitqueue_head(&q->waiters);
+	init_waitqueue_head(&q->waiter);
 
 	get_futex_key_refs(&q->key);
 	hb = hash_futex(&q->key);
@@ -1096,8 +1044,7 @@ static void unqueue_me_pi(struct futex_q *q)
  * private futexes.
  */
 static int fixup_pi_state_owner(u32 __user *uaddr, struct futex_q *q,
-				struct task_struct *newowner,
-				struct rw_semaphore *fshared)
+				struct task_struct *newowner, int fshared)
 {
 	u32 newtid = task_pid_vnr(newowner) | FUTEX_WAITERS;
 	struct futex_pi_state *pi_state = q->pi_state;
@@ -1176,7 +1123,7 @@ retry:
 handle_fault:
 	spin_unlock(q->lock_ptr);
 
-	ret = futex_handle_fault((unsigned long)uaddr, fshared, attempt++);
+	ret = futex_handle_fault((unsigned long)uaddr, attempt++);
 
 	spin_lock(q->lock_ptr);
 
@@ -1196,12 +1143,13 @@ handle_fault:
  * In case we must use restart_block to restart a futex_wait,
  * we encode in the 'flags' shared capability
  */
-#define FLAGS_SHARED  1
+#define FLAGS_SHARED		0x01
+#define FLAGS_CLOCKRT		0x02
 
 static long futex_wait_restart(struct restart_block *restart);
 
-static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
-		      u32 val, ktime_t *abs_time, u32 bitset)
+static int futex_wait(u32 __user *uaddr, int fshared,
+		      u32 val, ktime_t *abs_time, u32 bitset, int clockrt)
 {
 	struct task_struct *curr = current;
 	DECLARE_WAITQUEUE(wait, curr);
@@ -1218,8 +1166,7 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 	q.pi_state = NULL;
 	q.bitset = bitset;
  retry:
-	futex_lock_mm(fshared);
-
+	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
@@ -1251,12 +1198,6 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 	if (unlikely(ret)) {
 		queue_unlock(&q, hb);
 
-		/*
-		 * If we would have faulted, release mmap_sem, fault it in and
-		 * start all over again.
-		 */
-		futex_unlock_mm(fshared);
-
 		ret = get_user(uval, uaddr);
 
 		if (!ret)
@@ -1271,12 +1212,6 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 	queue_me(&q, hb);
 
 	/*
-	 * Now the futex is queued and we have checked the data, we
-	 * don't want to hold mmap_sem while we sleep.
-	 */
-	futex_unlock_mm(fshared);
-
-	/*
 	 * There might have been scheduling since the queue_me(), as we
 	 * cannot hold a spinlock across the get_user() in case it
 	 * faults, and we cannot just set TASK_INTERRUPTIBLE state when
@@ -1287,7 +1222,7 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 
 	/* add_wait_queue is the barrier after __set_current_state. */
 	__set_current_state(TASK_INTERRUPTIBLE);
-	add_wait_queue(&q.waiters, &wait);
+	add_wait_queue(&q.waiter, &wait);
 	/*
 	 * !plist_node_empty() is safe here without any lock.
 	 * q.lock_ptr != 0 is not safe, because of ordering against wakeup.
@@ -1300,8 +1235,10 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 			slack = current->timer_slack_ns;
 			if (rt_task(current))
 				slack = 0;
-			hrtimer_init_on_stack(&t.timer, CLOCK_MONOTONIC,
-						HRTIMER_MODE_ABS);
+			hrtimer_init_on_stack(&t.timer,
+					      clockrt ? CLOCK_REALTIME :
+					      CLOCK_MONOTONIC,
+					      HRTIMER_MODE_ABS);
 			hrtimer_init_sleeper(&t, current);
 			hrtimer_set_expires_range_ns(&t.timer, *abs_time, slack);
 
@@ -1356,6 +1293,8 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 
 		if (fshared)
 			restart->futex.flags |= FLAGS_SHARED;
+		if (clockrt)
+			restart->futex.flags |= FLAGS_CLOCKRT;
 		return -ERESTART_RESTARTBLOCK;
 	}
 
@@ -1363,7 +1302,7 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	futex_unlock_mm(fshared);
+	put_futex_key(fshared, &q.key);
 	return ret;
 }
 
@@ -1371,15 +1310,16 @@ static int futex_wait(u32 __user *uaddr, struct rw_semaphore *fshared,
 static long futex_wait_restart(struct restart_block *restart)
 {
 	u32 __user *uaddr = (u32 __user *)restart->futex.uaddr;
-	struct rw_semaphore *fshared = NULL;
+	int fshared = 0;
 	ktime_t t;
 
 	t.tv64 = restart->futex.time;
 	restart->fn = do_no_restart_syscall;
 	if (restart->futex.flags & FLAGS_SHARED)
-		fshared = &current->mm->mmap_sem;
+		fshared = 1;
 	return (long)futex_wait(uaddr, fshared, restart->futex.val, &t,
-				restart->futex.bitset);
+				restart->futex.bitset,
+				restart->futex.flags & FLAGS_CLOCKRT);
 }
 
 
@@ -1389,7 +1329,7 @@ static long futex_wait_restart(struct restart_block *restart)
  * if there are waiters then it will block, it does PI, etc. (Due to
  * races the kernel might see a 0 value of the futex too.)
  */
-static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
+static int futex_lock_pi(u32 __user *uaddr, int fshared,
 			 int detect, ktime_t *time, int trylock)
 {
 	struct hrtimer_sleeper timeout, *to = NULL;
@@ -1412,8 +1352,7 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
 
 	q.pi_state = NULL;
  retry:
-	futex_lock_mm(fshared);
-
+	q.key = FUTEX_KEY_INIT;
 	ret = get_futex_key(uaddr, fshared, &q.key);
 	if (unlikely(ret != 0))
 		goto out_release_sem;
@@ -1502,7 +1441,6 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
 			 * exit to complete.
 			 */
 			queue_unlock(&q, hb);
-			futex_unlock_mm(fshared);
 			cond_resched();
 			goto retry;
 
@@ -1534,12 +1472,6 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
 	 */
 	queue_me(&q, hb);
 
-	/*
-	 * Now the futex is queued and we have checked the data, we
-	 * don't want to hold mmap_sem while we sleep.
-	 */
-	futex_unlock_mm(fshared);
-
 	WARN_ON(!q.pi_state);
 	/*
 	 * Block on the PI mutex:
@@ -1552,7 +1484,6 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
 		ret = ret ? 0 : -EWOULDBLOCK;
 	}
 
-	futex_lock_mm(fshared);
 	spin_lock(q.lock_ptr);
 
 	if (!ret) {
@@ -1618,7 +1549,6 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
 
 	/* Unqueue and drop the lock */
 	unqueue_me_pi(&q);
-	futex_unlock_mm(fshared);
 
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
@@ -1628,34 +1558,30 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
 	queue_unlock(&q, hb);
 
  out_release_sem:
-	futex_unlock_mm(fshared);
+	put_futex_key(fshared, &q.key);
 	if (to)
 		destroy_hrtimer_on_stack(&to->timer);
 	return ret;
 
  uaddr_faulted:
 	/*
-	 * We have to r/w  *(int __user *)uaddr, but we can't modify it
-	 * non-atomically.  Therefore, if get_user below is not
-	 * enough, we need to handle the fault ourselves, while
-	 * still holding the mmap_sem.
-	 *
-	 * ... and hb->lock. :-) --ANK
+	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
+	 * atomically.  Therefore, if we continue to fault after get_user()
+	 * below, we need to handle the fault ourselves, while still holding
+	 * the mmap_sem.  This can occur if the uaddr is under contention as
+	 * we have to drop the mmap_sem in order to call get_user().
 	 */
 	queue_unlock(&q, hb);
 
 	if (attempt++) {
-		ret = futex_handle_fault((unsigned long)uaddr, fshared,
-					 attempt);
+		ret = futex_handle_fault((unsigned long)uaddr, attempt);
 		if (ret)
 			goto out_release_sem;
 		goto retry_unlocked;
 	}
 
-	futex_unlock_mm(fshared);
-
 	ret = get_user(uval, uaddr);
-	if (!ret && (uval != -EFAULT))
+	if (!ret)
 		goto retry;
 
 	if (to)
@@ -1668,13 +1594,13 @@ static int futex_lock_pi(u32 __user *uaddr, struct rw_semaphore *fshared,
  * This is the in-kernel slowpath: we look up the PI state (if any),
  * and do the rt-mutex unlock.
  */
-static int futex_unlock_pi(u32 __user *uaddr, struct rw_semaphore *fshared)
+static int futex_unlock_pi(u32 __user *uaddr, int fshared)
 {
 	struct futex_hash_bucket *hb;
 	struct futex_q *this, *next;
 	u32 uval;
 	struct plist_head *head;
-	union futex_key key;
+	union futex_key key = FUTEX_KEY_INIT;
 	int ret, attempt = 0;
 
 retry:
@@ -1685,10 +1611,6 @@ retry:
 	 */
 	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(current))
 		return -EPERM;
-	/*
-	 * First take all the futex related locks:
-	 */
-	futex_lock_mm(fshared);
 
 	ret = get_futex_key(uaddr, fshared, &key);
 	if (unlikely(ret != 0))
@@ -1747,34 +1669,30 @@ retry_unlocked:
 out_unlock:
 	spin_unlock(&hb->lock);
 out:
-	futex_unlock_mm(fshared);
+	put_futex_key(fshared, &key);
 
 	return ret;
 
 pi_faulted:
 	/*
-	 * We have to r/w  *(int __user *)uaddr, but we can't modify it
-	 * non-atomically.  Therefore, if get_user below is not
-	 * enough, we need to handle the fault ourselves, while
-	 * still holding the mmap_sem.
-	 *
-	 * ... and hb->lock. --ANK
+	 * We have to r/w  *(int __user *)uaddr, and we have to modify it
+	 * atomically.  Therefore, if we continue to fault after get_user()
+	 * below, we need to handle the fault ourselves, while still holding
+	 * the mmap_sem.  This can occur if the uaddr is under contention as
+	 * we have to drop the mmap_sem in order to call get_user().
 	 */
 	spin_unlock(&hb->lock);
 
 	if (attempt++) {
-		ret = futex_handle_fault((unsigned long)uaddr, fshared,
-					 attempt);
+		ret = futex_handle_fault((unsigned long)uaddr, attempt);
 		if (ret)
 			goto out;
 		uval = 0;
 		goto retry_unlocked;
 	}
 
-	futex_unlock_mm(fshared);
-
 	ret = get_user(uval, uaddr);
-	if (!ret && (uval != -EFAULT))
+	if (!ret)
 		goto retry;
 
 	return ret;
@@ -1898,8 +1816,7 @@ retry:
 		 * PI futexes happens in exit_pi_state():
 		 */
 		if (!pi && (uval & FUTEX_WAITERS))
-			futex_wake(uaddr, &curr->mm->mmap_sem, 1,
-				   FUTEX_BITSET_MATCH_ANY);
+			futex_wake(uaddr, 1, 1, FUTEX_BITSET_MATCH_ANY);
 	}
 	return 0;
 }
@@ -1993,18 +1910,22 @@ void exit_robust_list(struct task_struct *curr)
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 		u32 __user *uaddr2, u32 val2, u32 val3)
 {
-	int ret = -ENOSYS;
+	int clockrt, ret = -ENOSYS;
 	int cmd = op & FUTEX_CMD_MASK;
-	struct rw_semaphore *fshared = NULL;
+	int fshared = 0;
 
 	if (!(op & FUTEX_PRIVATE_FLAG))
-		fshared = &current->mm->mmap_sem;
+		fshared = 1;
+
+	clockrt = op & FUTEX_CLOCK_REALTIME;
+	if (clockrt && cmd != FUTEX_WAIT_BITSET)
+		return -ENOSYS;
 
 	switch (cmd) {
 	case FUTEX_WAIT:
 		val3 = FUTEX_BITSET_MATCH_ANY;
 	case FUTEX_WAIT_BITSET:
-		ret = futex_wait(uaddr, fshared, val, timeout, val3);
+		ret = futex_wait(uaddr, fshared, val, timeout, val3, clockrt);
 		break;
 	case FUTEX_WAKE:
 		val3 = FUTEX_BITSET_MATCH_ANY;
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 801addd..e9d1c82 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -673,6 +673,18 @@ int request_irq(unsigned int irq, irq_handler_t handler,
 	struct irq_desc *desc;
 	int retval;
 
+	/*
+	 * handle_IRQ_event() always ignores IRQF_DISABLED except for
+	 * the _first_ irqaction (sigh).  That can cause oopsing, but
+	 * the behavior is classified as "will not fix" so we need to
+	 * start nudging drivers away from using that idiom.
+	 */
+	if ((irqflags & (IRQF_SHARED|IRQF_DISABLED))
+			== (IRQF_SHARED|IRQF_DISABLED))
+		pr_warning("IRQ %d/%s: IRQF_DISABLED is not "
+				"guaranteed on shared IRQs\n",
+				irq, devname);
+
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * Lockdep wants atomic interrupt handlers:
diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 46a4041..4fa6eeb 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -136,16 +136,16 @@ static inline struct lock_class *hlock_class(struct held_lock *hlock)
 #ifdef CONFIG_LOCK_STAT
 static DEFINE_PER_CPU(struct lock_class_stats[MAX_LOCKDEP_KEYS], lock_stats);
 
-static int lock_contention_point(struct lock_class *class, unsigned long ip)
+static int lock_point(unsigned long points[], unsigned long ip)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(class->contention_point); i++) {
-		if (class->contention_point[i] == 0) {
-			class->contention_point[i] = ip;
+	for (i = 0; i < LOCKSTAT_POINTS; i++) {
+		if (points[i] == 0) {
+			points[i] = ip;
 			break;
 		}
-		if (class->contention_point[i] == ip)
+		if (points[i] == ip)
 			break;
 	}
 
@@ -185,6 +185,9 @@ struct lock_class_stats lock_stats(struct lock_class *class)
 		for (i = 0; i < ARRAY_SIZE(stats.contention_point); i++)
 			stats.contention_point[i] += pcs->contention_point[i];
 
+		for (i = 0; i < ARRAY_SIZE(stats.contending_point); i++)
+			stats.contending_point[i] += pcs->contending_point[i];
+
 		lock_time_add(&pcs->read_waittime, &stats.read_waittime);
 		lock_time_add(&pcs->write_waittime, &stats.write_waittime);
 
@@ -209,6 +212,7 @@ void clear_lock_stats(struct lock_class *class)
 		memset(cpu_stats, 0, sizeof(struct lock_class_stats));
 	}
 	memset(class->contention_point, 0, sizeof(class->contention_point));
+	memset(class->contending_point, 0, sizeof(class->contending_point));
 }
 
 static struct lock_class_stats *get_lock_stats(struct lock_class *class)
@@ -287,14 +291,12 @@ void lockdep_off(void)
 {
 	current->lockdep_recursion++;
 }
-
 EXPORT_SYMBOL(lockdep_off);
 
 void lockdep_on(void)
 {
 	current->lockdep_recursion--;
 }
-
 EXPORT_SYMBOL(lockdep_on);
 
 /*
@@ -576,7 +578,8 @@ static void print_lock_class_header(struct lock_class *class, int depth)
 /*
  * printk all lock dependencies starting at <entry>:
  */
-static void print_lock_dependencies(struct lock_class *class, int depth)
+static void __used
+print_lock_dependencies(struct lock_class *class, int depth)
 {
 	struct lock_list *entry;
 
@@ -2508,7 +2511,6 @@ void lockdep_init_map(struct lockdep_map *lock, const char *name,
 	if (subclass)
 		register_lock_class(lock, subclass, 1);
 }
-
 EXPORT_SYMBOL_GPL(lockdep_init_map);
 
 /*
@@ -2689,8 +2691,9 @@ static int check_unlock(struct task_struct *curr, struct lockdep_map *lock,
 }
 
 static int
-__lock_set_subclass(struct lockdep_map *lock,
-		    unsigned int subclass, unsigned long ip)
+__lock_set_class(struct lockdep_map *lock, const char *name,
+		 struct lock_class_key *key, unsigned int subclass,
+		 unsigned long ip)
 {
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
@@ -2717,6 +2720,7 @@ __lock_set_subclass(struct lockdep_map *lock,
 	return print_unlock_inbalance_bug(curr, lock, ip);
 
 found_it:
+	lockdep_init_map(lock, name, key, 0);
 	class = register_lock_class(lock, subclass, 0);
 	hlock->class_idx = class - lock_classes + 1;
 
@@ -2901,9 +2905,9 @@ static void check_flags(unsigned long flags)
 #endif
 }
 
-void
-lock_set_subclass(struct lockdep_map *lock,
-		  unsigned int subclass, unsigned long ip)
+void lock_set_class(struct lockdep_map *lock, const char *name,
+		    struct lock_class_key *key, unsigned int subclass,
+		    unsigned long ip)
 {
 	unsigned long flags;
 
@@ -2913,13 +2917,12 @@ lock_set_subclass(struct lockdep_map *lock,
 	raw_local_irq_save(flags);
 	current->lockdep_recursion = 1;
 	check_flags(flags);
-	if (__lock_set_subclass(lock, subclass, ip))
+	if (__lock_set_class(lock, name, key, subclass, ip))
 		check_chain_key(current);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-
-EXPORT_SYMBOL_GPL(lock_set_subclass);
+EXPORT_SYMBOL_GPL(lock_set_class);
 
 /*
  * We are not always called with irqs disabled - do that here,
@@ -2943,7 +2946,6 @@ void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL_GPL(lock_acquire);
 
 void lock_release(struct lockdep_map *lock, int nested,
@@ -2961,7 +2963,6 @@ void lock_release(struct lockdep_map *lock, int nested,
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
-
 EXPORT_SYMBOL_GPL(lock_release);
 
 #ifdef CONFIG_LOCK_STAT
@@ -2999,7 +3000,7 @@ __lock_contended(struct lockdep_map *lock, unsigned long ip)
 	struct held_lock *hlock, *prev_hlock;
 	struct lock_class_stats *stats;
 	unsigned int depth;
-	int i, point;
+	int i, contention_point, contending_point;
 
 	depth = curr->lockdep_depth;
 	if (DEBUG_LOCKS_WARN_ON(!depth))
@@ -3023,18 +3024,22 @@ __lock_contended(struct lockdep_map *lock, unsigned long ip)
 found_it:
 	hlock->waittime_stamp = sched_clock();
 
-	point = lock_contention_point(hlock_class(hlock), ip);
+	contention_point = lock_point(hlock_class(hlock)->contention_point, ip);
+	contending_point = lock_point(hlock_class(hlock)->contending_point,
+				      lock->ip);
 
 	stats = get_lock_stats(hlock_class(hlock));
-	if (point < ARRAY_SIZE(stats->contention_point))
-		stats->contention_point[point]++;
+	if (contention_point < LOCKSTAT_POINTS)
+		stats->contention_point[contention_point]++;
+	if (contending_point < LOCKSTAT_POINTS)
+		stats->contending_point[contending_point]++;
 	if (lock->cpu != smp_processor_id())
 		stats->bounces[bounce_contended + !!hlock->read]++;
 	put_lock_stats(stats);
 }
 
 static void
-__lock_acquired(struct lockdep_map *lock)
+__lock_acquired(struct lockdep_map *lock, unsigned long ip)
 {
 	struct task_struct *curr = current;
 	struct held_lock *hlock, *prev_hlock;
@@ -3083,6 +3088,7 @@ found_it:
 	put_lock_stats(stats);
 
 	lock->cpu = cpu;
+	lock->ip = ip;
 }
 
 void lock_contended(struct lockdep_map *lock, unsigned long ip)
@@ -3104,7 +3110,7 @@ void lock_contended(struct lockdep_map *lock, unsigned long ip)
 }
 EXPORT_SYMBOL_GPL(lock_contended);
 
-void lock_acquired(struct lockdep_map *lock)
+void lock_acquired(struct lockdep_map *lock, unsigned long ip)
 {
 	unsigned long flags;
 
@@ -3117,7 +3123,7 @@ void lock_acquired(struct lockdep_map *lock)
 	raw_local_irq_save(flags);
 	check_flags(flags);
 	current->lockdep_recursion = 1;
-	__lock_acquired(lock);
+	__lock_acquired(lock, ip);
 	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 }
@@ -3441,7 +3447,6 @@ retry:
 	if (unlock)
 		read_unlock(&tasklist_lock);
 }
-
 EXPORT_SYMBOL_GPL(debug_show_all_locks);
 
 /*
@@ -3462,7 +3467,6 @@ void debug_show_held_locks(struct task_struct *task)
 {
 		__debug_show_held_locks(task);
 }
-
 EXPORT_SYMBOL_GPL(debug_show_held_locks);
 
 void lockdep_sys_exit(void)
diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
index 20dbcbf..13716b8 100644
--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -470,11 +470,12 @@ static void seq_line(struct seq_file *m, char c, int offset, int length)
 
 static void snprint_time(char *buf, size_t bufsiz, s64 nr)
 {
-	unsigned long rem;
+	s64 div;
+	s32 rem;
 
 	nr += 5; /* for display rounding */
-	rem = do_div(nr, 1000); /* XXX: do_div_signed */
-	snprintf(buf, bufsiz, "%lld.%02d", (long long)nr, (int)rem/10);
+	div = div_s64_rem(nr, 1000, &rem);
+	snprintf(buf, bufsiz, "%lld.%02d", (long long)div, (int)rem/10);
 }
 
 static void seq_time(struct seq_file *m, s64 time)
@@ -556,7 +557,7 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 	if (stats->read_holdtime.nr)
 		namelen += 2;
 
-	for (i = 0; i < ARRAY_SIZE(class->contention_point); i++) {
+	for (i = 0; i < LOCKSTAT_POINTS; i++) {
 		char sym[KSYM_SYMBOL_LEN];
 		char ip[32];
 
@@ -573,6 +574,23 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 				stats->contention_point[i],
 				ip, sym);
 	}
+	for (i = 0; i < LOCKSTAT_POINTS; i++) {
+		char sym[KSYM_SYMBOL_LEN];
+		char ip[32];
+
+		if (class->contending_point[i] == 0)
+			break;
+
+		if (!i)
+			seq_line(m, '-', 40-namelen, namelen);
+
+		sprint_symbol(sym, class->contending_point[i]);
+		snprintf(ip, sizeof(ip), "[<%p>]",
+				(void *)class->contending_point[i]);
+		seq_printf(m, "%40s %14lu %29s %s\n", name,
+				stats->contending_point[i],
+				ip, sym);
+	}
 	if (i) {
 		seq_puts(m, "\n");
 		seq_line(m, '.', 0, 40 + 1 + 10 * (14 + 1));
@@ -582,7 +600,7 @@ static void seq_stats(struct seq_file *m, struct lock_stat_data *data)
 
 static void seq_header(struct seq_file *m)
 {
-	seq_printf(m, "lock_stat version 0.2\n");
+	seq_printf(m, "lock_stat version 0.3\n");
 	seq_line(m, '-', 0, 40 + 1 + 10 * (14 + 1));
 	seq_printf(m, "%40s %14s %14s %14s %14s %14s %14s %14s %14s "
 			"%14s %14s\n",
diff --git a/kernel/mutex.c b/kernel/mutex.c
index 12c779d..4f45d4b 100644
--- a/kernel/mutex.c
+++ b/kernel/mutex.c
@@ -59,7 +59,7 @@ EXPORT_SYMBOL(__mutex_init);
  * We also put the fastpath first in the kernel image, to make sure the
  * branch is predicted by the CPU as default-untaken.
  */
-static void noinline __sched
+static __used noinline void __sched
 __mutex_lock_slowpath(atomic_t *lock_count);
 
 /***
@@ -96,7 +96,7 @@ void inline __sched mutex_lock(struct mutex *lock)
 EXPORT_SYMBOL(mutex_lock);
 #endif
 
-static noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
+static __used noinline void __sched __mutex_unlock_slowpath(atomic_t *lock_count);
 
 /***
  * mutex_unlock - release the mutex
@@ -184,7 +184,7 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
 	}
 
 done:
-	lock_acquired(&lock->dep_map);
+	lock_acquired(&lock->dep_map, ip);
 	/* got the lock - rejoice! */
 	mutex_remove_waiter(lock, &waiter, task_thread_info(task));
 	debug_mutex_set_owner(lock, task_thread_info(task));
@@ -268,7 +268,7 @@ __mutex_unlock_common_slowpath(atomic_t *lock_count, int nested)
 /*
  * Release the lock, slowpath:
  */
-static noinline void
+static __used noinline void
 __mutex_unlock_slowpath(atomic_t *lock_count)
 {
 	__mutex_unlock_common_slowpath(lock_count, 1);
@@ -313,7 +313,7 @@ int __sched mutex_lock_killable(struct mutex *lock)
 }
 EXPORT_SYMBOL(mutex_lock_killable);
 
-static noinline void __sched
+static __used noinline void __sched
 __mutex_lock_slowpath(atomic_t *lock_count)
 {
 	struct mutex *lock = container_of(lock_count, struct mutex, count);
diff --git a/kernel/notifier.c b/kernel/notifier.c
index 4282c0a..61d5aa5 100644
--- a/kernel/notifier.c
+++ b/kernel/notifier.c
@@ -82,6 +82,14 @@ static int __kprobes notifier_call_chain(struct notifier_block **nl,
 
 	while (nb && nr_to_call) {
 		next_nb = rcu_dereference(nb->next);
+
+#ifdef CONFIG_DEBUG_NOTIFIERS
+		if (unlikely(!func_ptr_is_kernel_text(nb->notifier_call))) {
+			WARN(1, "Invalid notifier called!");
+			nb = next_nb;
+			continue;
+		}
+#endif
 		ret = nb->notifier_call(nb, val, v);
 
 		if (nr_calls)
diff --git a/kernel/panic.c b/kernel/panic.c
index 4d50883..13f0634 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -21,6 +21,7 @@
 #include <linux/debug_locks.h>
 #include <linux/random.h>
 #include <linux/kallsyms.h>
+#include <linux/dmi.h>
 
 int panic_on_oops;
 static unsigned long tainted_mask;
@@ -321,36 +322,27 @@ void oops_exit(void)
 }
 
 #ifdef WANT_WARN_ON_SLOWPATH
-void warn_on_slowpath(const char *file, int line)
-{
-	char function[KSYM_SYMBOL_LEN];
-	unsigned long caller = (unsigned long) __builtin_return_address(0);
-	sprint_symbol(function, caller);
-
-	printk(KERN_WARNING "------------[ cut here ]------------\n");
-	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
-		line, function);
-	print_modules();
-	dump_stack();
-	print_oops_end_marker();
-	add_taint(TAINT_WARN);
-}
-EXPORT_SYMBOL(warn_on_slowpath);
-
-
 void warn_slowpath(const char *file, int line, const char *fmt, ...)
 {
 	va_list args;
 	char function[KSYM_SYMBOL_LEN];
 	unsigned long caller = (unsigned long)__builtin_return_address(0);
+	const char *board;
+
 	sprint_symbol(function, caller);
 
 	printk(KERN_WARNING "------------[ cut here ]------------\n");
 	printk(KERN_WARNING "WARNING: at %s:%d %s()\n", file,
 		line, function);
-	va_start(args, fmt);
-	vprintk(fmt, args);
-	va_end(args);
+	board = dmi_get_system_info(DMI_PRODUCT_NAME);
+	if (board)
+		printk(KERN_WARNING "Hardware name: %s\n", board);
+
+	if (fmt) {
+		va_start(args, fmt);
+		vprintk(fmt, args);
+		va_end(args);
+	}
 
 	print_modules();
 	dump_stack();
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index 4e5288a..157de3a 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -58,21 +58,21 @@ void thread_group_cputime(
 	struct task_struct *tsk,
 	struct task_cputime *times)
 {
-	struct signal_struct *sig;
+	struct task_cputime *totals, *tot;
 	int i;
-	struct task_cputime *tot;
 
-	sig = tsk->signal;
-	if (unlikely(!sig) || !sig->cputime.totals) {
+	totals = tsk->signal->cputime.totals;
+	if (!totals) {
 		times->utime = tsk->utime;
 		times->stime = tsk->stime;
 		times->sum_exec_runtime = tsk->se.sum_exec_runtime;
 		return;
 	}
+
 	times->stime = times->utime = cputime_zero;
 	times->sum_exec_runtime = 0;
 	for_each_possible_cpu(i) {
-		tot = per_cpu_ptr(tsk->signal->cputime.totals, i);
+		tot = per_cpu_ptr(totals, i);
 		times->utime = cputime_add(times->utime, tot->utime);
 		times->stime = cputime_add(times->stime, tot->stime);
 		times->sum_exec_runtime += tot->sum_exec_runtime;
diff --git a/kernel/printk.c b/kernel/printk.c
index f492f15..e651ab0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -662,7 +662,7 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 	if (recursion_bug) {
 		recursion_bug = 0;
 		strcpy(printk_buf, recursion_bug_msg);
-		printed_len = sizeof(recursion_bug_msg);
+		printed_len = strlen(recursion_bug_msg);
 	}
 	/* Emit the output into the temporary buffer */
 	printed_len += vscnprintf(printk_buf + printed_len,
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 37f72e5..e503a00 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -191,7 +191,7 @@ static void print_other_cpu_stall(struct rcu_ctrlblk *rcp)
 
 	/* OK, time to rat on our buddy... */
 
-	printk(KERN_ERR "RCU detected CPU stalls:");
+	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
 	for_each_possible_cpu(cpu) {
 		if (cpu_isset(cpu, rcp->cpumask))
 			printk(" %d", cpu);
@@ -204,7 +204,7 @@ static void print_cpu_stall(struct rcu_ctrlblk *rcp)
 {
 	unsigned long flags;
 
-	printk(KERN_ERR "RCU detected CPU %d stall (t=%lu/%lu jiffies)\n",
+	printk(KERN_ERR "INFO: RCU detected CPU %d stall (t=%lu/%lu jiffies)\n",
 			smp_processor_id(), jiffies,
 			jiffies - rcp->gp_start);
 	dump_stack();
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 59236e8..0498265 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -551,6 +551,16 @@ void rcu_irq_exit(void)
 	}
 }
 
+void rcu_nmi_enter(void)
+{
+	rcu_irq_enter();
+}
+
+void rcu_nmi_exit(void)
+{
+	rcu_irq_exit();
+}
+
 static void dyntick_save_progress_counter(int cpu)
 {
 	struct rcu_dyntick_sched *rdssp = &per_cpu(rcu_dyntick_sched, cpu);
diff --git a/kernel/rcupreempt_trace.c b/kernel/rcupreempt_trace.c
index 35c2d33..7c2665c 100644
--- a/kernel/rcupreempt_trace.c
+++ b/kernel/rcupreempt_trace.c
@@ -149,12 +149,12 @@ static void rcupreempt_trace_sum(struct rcupreempt_trace *sp)
 		sp->done_length += cp->done_length;
 		sp->done_add += cp->done_add;
 		sp->done_remove += cp->done_remove;
-		atomic_set(&sp->done_invoked, atomic_read(&cp->done_invoked));
+		atomic_add(atomic_read(&cp->done_invoked), &sp->done_invoked);
 		sp->rcu_check_callbacks += cp->rcu_check_callbacks;
-		atomic_set(&sp->rcu_try_flip_1,
-			   atomic_read(&cp->rcu_try_flip_1));
-		atomic_set(&sp->rcu_try_flip_e1,
-			   atomic_read(&cp->rcu_try_flip_e1));
+		atomic_add(atomic_read(&cp->rcu_try_flip_1),
+			   &sp->rcu_try_flip_1);
+		atomic_add(atomic_read(&cp->rcu_try_flip_e1),
+			   &sp->rcu_try_flip_e1);
 		sp->rcu_try_flip_i1 += cp->rcu_try_flip_i1;
 		sp->rcu_try_flip_ie1 += cp->rcu_try_flip_ie1;
 		sp->rcu_try_flip_g1 += cp->rcu_try_flip_g1;
diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
index 85cb905..b310655 100644
--- a/kernel/rcutorture.c
+++ b/kernel/rcutorture.c
@@ -39,6 +39,7 @@
 #include <linux/moduleparam.h>
 #include <linux/percpu.h>
 #include <linux/notifier.h>
+#include <linux/reboot.h>
 #include <linux/freezer.h>
 #include <linux/cpu.h>
 #include <linux/delay.h>
@@ -108,7 +109,6 @@ struct rcu_torture {
 	int rtort_mbtest;
 };
 
-static int fullstop = 0;	/* stop generating callbacks at test end. */
 static LIST_HEAD(rcu_torture_freelist);
 static struct rcu_torture *rcu_torture_current = NULL;
 static long rcu_torture_current_version = 0;
@@ -136,6 +136,30 @@ static int stutter_pause_test = 0;
 #endif
 int rcutorture_runnable = RCUTORTURE_RUNNABLE_INIT;
 
+#define FULLSTOP_SIGNALED 1	/* Bail due to signal. */
+#define FULLSTOP_CLEANUP  2	/* Orderly shutdown. */
+static int fullstop;		/* stop generating callbacks at test end. */
+DEFINE_MUTEX(fullstop_mutex);	/* protect fullstop transitions and */
+				/*  spawning of kthreads. */
+
+/*
+ * Detect and respond to a signal-based shutdown.
+ */
+static int
+rcutorture_shutdown_notify(struct notifier_block *unused1,
+			   unsigned long unused2, void *unused3)
+{
+	if (fullstop)
+		return NOTIFY_DONE;
+	if (signal_pending(current)) {
+		mutex_lock(&fullstop_mutex);
+		if (!ACCESS_ONCE(fullstop))
+			fullstop = FULLSTOP_SIGNALED;
+		mutex_unlock(&fullstop_mutex);
+	}
+	return NOTIFY_DONE;
+}
+
 /*
  * Allocate an element from the rcu_tortures pool.
  */
@@ -199,11 +223,12 @@ rcu_random(struct rcu_random_state *rrsp)
 static void
 rcu_stutter_wait(void)
 {
-	while (stutter_pause_test || !rcutorture_runnable)
+	while ((stutter_pause_test || !rcutorture_runnable) && !fullstop) {
 		if (rcutorture_runnable)
 			schedule_timeout_interruptible(1);
 		else
 			schedule_timeout_interruptible(round_jiffies_relative(HZ));
+	}
 }
 
 /*
@@ -599,7 +624,7 @@ rcu_torture_writer(void *arg)
 		rcu_stutter_wait();
 	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_writer task stopping");
-	while (!kthread_should_stop())
+	while (!kthread_should_stop() && fullstop != FULLSTOP_SIGNALED)
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -624,7 +649,7 @@ rcu_torture_fakewriter(void *arg)
 	} while (!kthread_should_stop() && !fullstop);
 
 	VERBOSE_PRINTK_STRING("rcu_torture_fakewriter task stopping");
-	while (!kthread_should_stop())
+	while (!kthread_should_stop() && fullstop != FULLSTOP_SIGNALED)
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -734,7 +759,7 @@ rcu_torture_reader(void *arg)
 	VERBOSE_PRINTK_STRING("rcu_torture_reader task stopping");
 	if (irqreader && cur_ops->irqcapable)
 		del_timer_sync(&t);
-	while (!kthread_should_stop())
+	while (!kthread_should_stop() && fullstop != FULLSTOP_SIGNALED)
 		schedule_timeout_uninterruptible(1);
 	return 0;
 }
@@ -831,7 +856,7 @@ rcu_torture_stats(void *arg)
 	do {
 		schedule_timeout_interruptible(stat_interval * HZ);
 		rcu_torture_stats_print();
-	} while (!kthread_should_stop());
+	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_stats task stopping");
 	return 0;
 }
@@ -899,7 +924,7 @@ rcu_torture_shuffle(void *arg)
 	do {
 		schedule_timeout_interruptible(shuffle_interval * HZ);
 		rcu_torture_shuffle_tasks();
-	} while (!kthread_should_stop());
+	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_shuffle task stopping");
 	return 0;
 }
@@ -914,10 +939,10 @@ rcu_torture_stutter(void *arg)
 	do {
 		schedule_timeout_interruptible(stutter * HZ);
 		stutter_pause_test = 1;
-		if (!kthread_should_stop())
+		if (!kthread_should_stop() && !fullstop)
 			schedule_timeout_interruptible(stutter * HZ);
 		stutter_pause_test = 0;
-	} while (!kthread_should_stop());
+	} while (!kthread_should_stop() && !fullstop);
 	VERBOSE_PRINTK_STRING("rcu_torture_stutter task stopping");
 	return 0;
 }
@@ -934,12 +959,27 @@ rcu_torture_print_module_parms(char *tag)
 		stutter, irqreader);
 }
 
+static struct notifier_block rcutorture_nb = {
+	.notifier_call = rcutorture_shutdown_notify,
+};
+
 static void
 rcu_torture_cleanup(void)
 {
 	int i;
 
-	fullstop = 1;
+	mutex_lock(&fullstop_mutex);
+	if (!fullstop) {
+		/* If being signaled, let it happen, then exit. */
+		mutex_unlock(&fullstop_mutex);
+		schedule_timeout_interruptible(10 * HZ);
+		if (cur_ops->cb_barrier != NULL)
+			cur_ops->cb_barrier();
+		return;
+	}
+	fullstop = FULLSTOP_CLEANUP;
+	mutex_unlock(&fullstop_mutex);
+	unregister_reboot_notifier(&rcutorture_nb);
 	if (stutter_task) {
 		VERBOSE_PRINTK_STRING("Stopping rcu_torture_stutter task");
 		kthread_stop(stutter_task);
@@ -1015,6 +1055,8 @@ rcu_torture_init(void)
 		{ &rcu_ops, &rcu_sync_ops, &rcu_bh_ops, &rcu_bh_sync_ops,
 		  &srcu_ops, &sched_ops, &sched_ops_sync, };
 
+	mutex_lock(&fullstop_mutex);
+
 	/* Process args and tell the world that the torturer is on the job. */
 	for (i = 0; i < ARRAY_SIZE(torture_ops); i++) {
 		cur_ops = torture_ops[i];
@@ -1024,6 +1066,7 @@ rcu_torture_init(void)
 	if (i == ARRAY_SIZE(torture_ops)) {
 		printk(KERN_ALERT "rcutorture: invalid torture type: \"%s\"\n",
 		       torture_type);
+		mutex_unlock(&fullstop_mutex);
 		return (-EINVAL);
 	}
 	if (cur_ops->init)
@@ -1146,9 +1189,12 @@ rcu_torture_init(void)
 			goto unwind;
 		}
 	}
+	register_reboot_notifier(&rcutorture_nb);
+	mutex_unlock(&fullstop_mutex);
 	return 0;
 
 unwind:
+	mutex_unlock(&fullstop_mutex);
 	rcu_torture_cleanup();
 	return firsterr;
 }
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
new file mode 100644
index 0000000..a342b03
--- /dev/null
+++ b/kernel/rcutree.c
@@ -0,0 +1,1535 @@
+/*
+ * Read-Copy Update mechanism for mutual exclusion
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
+ * Authors: Dipankar Sarma <dipankar@in.ibm.com>
+ *	    Manfred Spraul <manfred@colorfullife.com>
+ *	    Paul E. McKenney <paulmck@linux.vnet.ibm.com> Hierarchical version
+ *
+ * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
+ * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 	Documentation/RCU
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/rcupdate.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <asm/atomic.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <linux/percpu.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/mutex.h>
+#include <linux/time.h>
+
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+static struct lock_class_key rcu_lock_key;
+struct lockdep_map rcu_lock_map =
+	STATIC_LOCKDEP_MAP_INIT("rcu_read_lock", &rcu_lock_key);
+EXPORT_SYMBOL_GPL(rcu_lock_map);
+#endif
+
+/* Data structures. */
+
+#define RCU_STATE_INITIALIZER(name) { \
+	.level = { &name.node[0] }, \
+	.levelcnt = { \
+		NUM_RCU_LVL_0,  /* root of hierarchy. */ \
+		NUM_RCU_LVL_1, \
+		NUM_RCU_LVL_2, \
+		NUM_RCU_LVL_3, /* == MAX_RCU_LVLS */ \
+	}, \
+	.signaled = RCU_SIGNAL_INIT, \
+	.gpnum = -300, \
+	.completed = -300, \
+	.onofflock = __SPIN_LOCK_UNLOCKED(&name.onofflock), \
+	.fqslock = __SPIN_LOCK_UNLOCKED(&name.fqslock), \
+	.n_force_qs = 0, \
+	.n_force_qs_ngp = 0, \
+}
+
+struct rcu_state rcu_state = RCU_STATE_INITIALIZER(rcu_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_data);
+
+struct rcu_state rcu_bh_state = RCU_STATE_INITIALIZER(rcu_bh_state);
+DEFINE_PER_CPU(struct rcu_data, rcu_bh_data);
+
+#ifdef CONFIG_NO_HZ
+DEFINE_PER_CPU(struct rcu_dynticks, rcu_dynticks);
+#endif /* #ifdef CONFIG_NO_HZ */
+
+static int blimit = 10;		/* Maximum callbacks per softirq. */
+static int qhimark = 10000;	/* If this many pending, ignore blimit. */
+static int qlowmark = 100;	/* Once only this many pending, use blimit. */
+
+static void force_quiescent_state(struct rcu_state *rsp, int relaxed);
+
+/*
+ * Return the number of RCU batches processed thus far for debug & stats.
+ */
+long rcu_batches_completed(void)
+{
+	return rcu_state.completed;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed);
+
+/*
+ * Return the number of RCU BH batches processed thus far for debug & stats.
+ */
+long rcu_batches_completed_bh(void)
+{
+	return rcu_bh_state.completed;
+}
+EXPORT_SYMBOL_GPL(rcu_batches_completed_bh);
+
+/*
+ * Does the CPU have callbacks ready to be invoked?
+ */
+static int
+cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
+{
+	return &rdp->nxtlist != rdp->nxttail[RCU_DONE_TAIL];
+}
+
+/*
+ * Does the current CPU require a yet-as-unscheduled grace period?
+ */
+static int
+cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	/* ACCESS_ONCE() because we are accessing outside of lock. */
+	return *rdp->nxttail[RCU_DONE_TAIL] &&
+	       ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum);
+}
+
+/*
+ * Return the root node of the specified rcu_state structure.
+ */
+static struct rcu_node *rcu_get_root(struct rcu_state *rsp)
+{
+	return &rsp->node[0];
+}
+
+#ifdef CONFIG_SMP
+
+/*
+ * If the specified CPU is offline, tell the caller that it is in
+ * a quiescent state.  Otherwise, whack it with a reschedule IPI.
+ * Grace periods can end up waiting on an offline CPU when that
+ * CPU is in the process of coming online -- it will be added to the
+ * rcu_node bitmasks before it actually makes it online.  The same thing
+ * can happen while a CPU is in the process of coming online.  Because this
+ * race is quite rare, we check for it after detecting that the grace
+ * period has been delayed rather than checking each and every CPU
+ * each and every time we start a new grace period.
+ */
+static int rcu_implicit_offline_qs(struct rcu_data *rdp)
+{
+	/*
+	 * If the CPU is offline, it is in a quiescent state.  We can
+	 * trust its state not to change because interrupts are disabled.
+	 */
+	if (cpu_is_offline(rdp->cpu)) {
+		rdp->offline_fqs++;
+		return 1;
+	}
+
+	/* The CPU is online, so send it a reschedule IPI. */
+	if (rdp->cpu != smp_processor_id())
+		smp_send_reschedule(rdp->cpu);
+	else
+		set_need_resched();
+	rdp->resched_ipi++;
+	return 0;
+}
+
+#endif /* #ifdef CONFIG_SMP */
+
+#ifdef CONFIG_NO_HZ
+static DEFINE_RATELIMIT_STATE(rcu_rs, 10 * HZ, 5);
+
+/**
+ * rcu_enter_nohz - inform RCU that current CPU is entering nohz
+ *
+ * Enter nohz mode, in other words, -leave- the mode in which RCU
+ * read-side critical sections can occur.  (Though RCU read-side
+ * critical sections can occur in irq handlers in nohz mode, a possibility
+ * handled by rcu_irq_enter() and rcu_irq_exit()).
+ */
+void rcu_enter_nohz(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp->dynticks++;
+	rdtp->dynticks_nesting--;
+	WARN_ON_RATELIMIT(rdtp->dynticks & 0x1, &rcu_rs);
+	local_irq_restore(flags);
+}
+
+/*
+ * rcu_exit_nohz - inform RCU that current CPU is leaving nohz
+ *
+ * Exit nohz mode, in other words, -enter- the mode in which RCU
+ * read-side critical sections normally occur.
+ */
+void rcu_exit_nohz(void)
+{
+	unsigned long flags;
+	struct rcu_dynticks *rdtp;
+
+	local_irq_save(flags);
+	rdtp = &__get_cpu_var(rcu_dynticks);
+	rdtp->dynticks++;
+	rdtp->dynticks_nesting++;
+	WARN_ON_RATELIMIT(!(rdtp->dynticks & 0x1), &rcu_rs);
+	local_irq_restore(flags);
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+}
+
+/**
+ * rcu_nmi_enter - inform RCU of entry to NMI context
+ *
+ * If the CPU was idle with dynamic ticks active, and there is no
+ * irq handler running, this updates rdtp->dynticks_nmi to let the
+ * RCU grace-period handling know that the CPU is active.
+ */
+void rcu_nmi_enter(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (rdtp->dynticks & 0x1)
+		return;
+	rdtp->dynticks_nmi++;
+	WARN_ON_RATELIMIT(!(rdtp->dynticks_nmi & 0x1), &rcu_rs);
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+}
+
+/**
+ * rcu_nmi_exit - inform RCU of exit from NMI context
+ *
+ * If the CPU was idle with dynamic ticks active, and there is no
+ * irq handler running, this updates rdtp->dynticks_nmi to let the
+ * RCU grace-period handling know that the CPU is no longer active.
+ */
+void rcu_nmi_exit(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (rdtp->dynticks & 0x1)
+		return;
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
+	rdtp->dynticks_nmi++;
+	WARN_ON_RATELIMIT(rdtp->dynticks_nmi & 0x1, &rcu_rs);
+}
+
+/**
+ * rcu_irq_enter - inform RCU of entry to hard irq context
+ *
+ * If the CPU was idle with dynamic ticks active, this updates the
+ * rdtp->dynticks to let the RCU handling know that the CPU is active.
+ */
+void rcu_irq_enter(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (rdtp->dynticks_nesting++)
+		return;
+	rdtp->dynticks++;
+	WARN_ON_RATELIMIT(!(rdtp->dynticks & 0x1), &rcu_rs);
+	smp_mb(); /* CPUs seeing ++ must see later RCU read-side crit sects */
+}
+
+/**
+ * rcu_irq_exit - inform RCU of exit from hard irq context
+ *
+ * If the CPU was idle with dynamic ticks active, update the rdp->dynticks
+ * to put let the RCU handling be aware that the CPU is going back to idle
+ * with no ticks.
+ */
+void rcu_irq_exit(void)
+{
+	struct rcu_dynticks *rdtp = &__get_cpu_var(rcu_dynticks);
+
+	if (--rdtp->dynticks_nesting)
+		return;
+	smp_mb(); /* CPUs seeing ++ must see prior RCU read-side crit sects */
+	rdtp->dynticks++;
+	WARN_ON_RATELIMIT(rdtp->dynticks & 0x1, &rcu_rs);
+
+	/* If the interrupt queued a callback, get out of dyntick mode. */
+	if (__get_cpu_var(rcu_data).nxtlist ||
+	    __get_cpu_var(rcu_bh_data).nxtlist)
+		set_need_resched();
+}
+
+/*
+ * Record the specified "completed" value, which is later used to validate
+ * dynticks counter manipulations.  Specify "rsp->completed - 1" to
+ * unconditionally invalidate any future dynticks manipulations (which is
+ * useful at the beginning of a grace period).
+ */
+static void dyntick_record_completed(struct rcu_state *rsp, long comp)
+{
+	rsp->dynticks_completed = comp;
+}
+
+#ifdef CONFIG_SMP
+
+/*
+ * Recall the previously recorded value of the completion for dynticks.
+ */
+static long dyntick_recall_completed(struct rcu_state *rsp)
+{
+	return rsp->dynticks_completed;
+}
+
+/*
+ * Snapshot the specified CPU's dynticks counter so that we can later
+ * credit them with an implicit quiescent state.  Return 1 if this CPU
+ * is already in a quiescent state courtesy of dynticks idle mode.
+ */
+static int dyntick_save_progress_counter(struct rcu_data *rdp)
+{
+	int ret;
+	int snap;
+	int snap_nmi;
+
+	snap = rdp->dynticks->dynticks;
+	snap_nmi = rdp->dynticks->dynticks_nmi;
+	smp_mb();	/* Order sampling of snap with end of grace period. */
+	rdp->dynticks_snap = snap;
+	rdp->dynticks_nmi_snap = snap_nmi;
+	ret = ((snap & 0x1) == 0) && ((snap_nmi & 0x1) == 0);
+	if (ret)
+		rdp->dynticks_fqs++;
+	return ret;
+}
+
+/*
+ * Return true if the specified CPU has passed through a quiescent
+ * state by virtue of being in or having passed through an dynticks
+ * idle state since the last call to dyntick_save_progress_counter()
+ * for this same CPU.
+ */
+static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
+{
+	long curr;
+	long curr_nmi;
+	long snap;
+	long snap_nmi;
+
+	curr = rdp->dynticks->dynticks;
+	snap = rdp->dynticks_snap;
+	curr_nmi = rdp->dynticks->dynticks_nmi;
+	snap_nmi = rdp->dynticks_nmi_snap;
+	smp_mb(); /* force ordering with cpu entering/leaving dynticks. */
+
+	/*
+	 * If the CPU passed through or entered a dynticks idle phase with
+	 * no active irq/NMI handlers, then we can safely pretend that the CPU
+	 * already acknowledged the request to pass through a quiescent
+	 * state.  Either way, that CPU cannot possibly be in an RCU
+	 * read-side critical section that started before the beginning
+	 * of the current RCU grace period.
+	 */
+	if ((curr != snap || (curr & 0x1) == 0) &&
+	    (curr_nmi != snap_nmi || (curr_nmi & 0x1) == 0)) {
+		rdp->dynticks_fqs++;
+		return 1;
+	}
+
+	/* Go check for the CPU being offline. */
+	return rcu_implicit_offline_qs(rdp);
+}
+
+#endif /* #ifdef CONFIG_SMP */
+
+#else /* #ifdef CONFIG_NO_HZ */
+
+static void dyntick_record_completed(struct rcu_state *rsp, long comp)
+{
+}
+
+#ifdef CONFIG_SMP
+
+/*
+ * If there are no dynticks, then the only way that a CPU can passively
+ * be in a quiescent state is to be offline.  Unlike dynticks idle, which
+ * is a point in time during the prior (already finished) grace period,
+ * an offline CPU is always in a quiescent state, and thus can be
+ * unconditionally applied.  So just return the current value of completed.
+ */
+static long dyntick_recall_completed(struct rcu_state *rsp)
+{
+	return rsp->completed;
+}
+
+static int dyntick_save_progress_counter(struct rcu_data *rdp)
+{
+	return 0;
+}
+
+static int rcu_implicit_dynticks_qs(struct rcu_data *rdp)
+{
+	return rcu_implicit_offline_qs(rdp);
+}
+
+#endif /* #ifdef CONFIG_SMP */
+
+#endif /* #else #ifdef CONFIG_NO_HZ */
+
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+
+static void record_gp_stall_check_time(struct rcu_state *rsp)
+{
+	rsp->gp_start = jiffies;
+	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_CHECK;
+}
+
+static void print_other_cpu_stall(struct rcu_state *rsp)
+{
+	int cpu;
+	long delta;
+	unsigned long flags;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
+	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
+
+	/* Only let one CPU complain about others per time interval. */
+
+	spin_lock_irqsave(&rnp->lock, flags);
+	delta = jiffies - rsp->jiffies_stall;
+	if (delta < RCU_STALL_RAT_DELAY || rsp->gpnum == rsp->completed) {
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+	rsp->jiffies_stall = jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rnp->lock, flags);
+
+	/* OK, time to rat on our buddy... */
+
+	printk(KERN_ERR "INFO: RCU detected CPU stalls:");
+	for (; rnp_cur < rnp_end; rnp_cur++) {
+		if (rnp_cur->qsmask == 0)
+			continue;
+		for (cpu = 0; cpu <= rnp_cur->grphi - rnp_cur->grplo; cpu++)
+			if (rnp_cur->qsmask & (1UL << cpu))
+				printk(" %d", rnp_cur->grplo + cpu);
+	}
+	printk(" (detected by %d, t=%ld jiffies)\n",
+	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
+	force_quiescent_state(rsp, 0);  /* Kick them all. */
+}
+
+static void print_cpu_stall(struct rcu_state *rsp)
+{
+	unsigned long flags;
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	printk(KERN_ERR "INFO: RCU detected CPU %d stall (t=%lu jiffies)\n",
+			smp_processor_id(), jiffies - rsp->gp_start);
+	dump_stack();
+	spin_lock_irqsave(&rnp->lock, flags);
+	if ((long)(jiffies - rsp->jiffies_stall) >= 0)
+		rsp->jiffies_stall =
+			jiffies + RCU_SECONDS_TILL_STALL_RECHECK;
+	spin_unlock_irqrestore(&rnp->lock, flags);
+	set_need_resched();  /* kick ourselves to get things going. */
+}
+
+static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	long delta;
+	struct rcu_node *rnp;
+
+	delta = jiffies - rsp->jiffies_stall;
+	rnp = rdp->mynode;
+	if ((rnp->qsmask & rdp->grpmask) && delta >= 0) {
+
+		/* We haven't checked in, so go dump stack. */
+		print_cpu_stall(rsp);
+
+	} else if (rsp->gpnum != rsp->completed &&
+		   delta >= RCU_STALL_RAT_DELAY) {
+
+		/* They had two time units to dump stack, so complain. */
+		print_other_cpu_stall(rsp);
+	}
+}
+
+#else /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+static void record_gp_stall_check_time(struct rcu_state *rsp)
+{
+}
+
+static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+}
+
+#endif /* #else #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+
+/*
+ * Update CPU-local rcu_data state to record the newly noticed grace period.
+ * This is used both when we started the grace period and when we notice
+ * that someone else started the grace period.
+ */
+static void note_new_gpnum(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	rdp->qs_pending = 1;
+	rdp->passed_quiesc = 0;
+	rdp->gpnum = rsp->gpnum;
+	rdp->n_rcu_pending_force_qs = rdp->n_rcu_pending +
+				      RCU_JIFFIES_TILL_FORCE_QS;
+}
+
+/*
+ * Did someone else start a new RCU grace period start since we last
+ * checked?  Update local state appropriately if so.  Must be called
+ * on the CPU corresponding to rdp.
+ */
+static int
+check_for_new_grace_period(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	unsigned long flags;
+	int ret = 0;
+
+	local_irq_save(flags);
+	if (rdp->gpnum != rsp->gpnum) {
+		note_new_gpnum(rsp, rdp);
+		ret = 1;
+	}
+	local_irq_restore(flags);
+	return ret;
+}
+
+/*
+ * Start a new RCU grace period if warranted, re-initializing the hierarchy
+ * in preparation for detecting the next grace period.  The caller must hold
+ * the root node's ->lock, which is released before return.  Hard irqs must
+ * be disabled.
+ */
+static void
+rcu_start_gp(struct rcu_state *rsp, unsigned long flags)
+	__releases(rcu_get_root(rsp)->lock)
+{
+	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	struct rcu_node *rnp_cur;
+	struct rcu_node *rnp_end;
+
+	if (!cpu_needs_another_gp(rsp, rdp)) {
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+
+	/* Advance to a new grace period and initialize state. */
+	rsp->gpnum++;
+	rsp->signaled = RCU_GP_INIT; /* Hold off force_quiescent_state. */
+	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
+	rdp->n_rcu_pending_force_qs = rdp->n_rcu_pending +
+				      RCU_JIFFIES_TILL_FORCE_QS;
+	record_gp_stall_check_time(rsp);
+	dyntick_record_completed(rsp, rsp->completed - 1);
+	note_new_gpnum(rsp, rdp);
+
+	/*
+	 * Because we are first, we know that all our callbacks will
+	 * be covered by this upcoming grace period, even the ones
+	 * that were registered arbitrarily recently.
+	 */
+	rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+	rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+	/* Special-case the common single-level case. */
+	if (NUM_RCU_NODES == 1) {
+		rnp->qsmask = rnp->qsmaskinit;
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+
+	spin_unlock(&rnp->lock);  /* leave irqs disabled. */
+
+
+	/* Exclude any concurrent CPU-hotplug operations. */
+	spin_lock(&rsp->onofflock);  /* irqs already disabled. */
+
+	/*
+	 * Set the quiescent-state-needed bits in all the non-leaf RCU
+	 * nodes for all currently online CPUs.  This operation relies
+	 * on the layout of the hierarchy within the rsp->node[] array.
+	 * Note that other CPUs will access only the leaves of the
+	 * hierarchy, which still indicate that no grace period is in
+	 * progress.  In addition, we have excluded CPU-hotplug operations.
+	 *
+	 * We therefore do not need to hold any locks.  Any required
+	 * memory barriers will be supplied by the locks guarding the
+	 * leaf rcu_nodes in the hierarchy.
+	 */
+
+	rnp_end = rsp->level[NUM_RCU_LVLS - 1];
+	for (rnp_cur = &rsp->node[0]; rnp_cur < rnp_end; rnp_cur++)
+		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+
+	/*
+	 * Now set up the leaf nodes.  Here we must be careful.  First,
+	 * we need to hold the lock in order to exclude other CPUs, which
+	 * might be contending for the leaf nodes' locks.  Second, as
+	 * soon as we initialize a given leaf node, its CPUs might run
+	 * up the rest of the hierarchy.  We must therefore acquire locks
+	 * for each node that we touch during this stage.  (But we still
+	 * are excluding CPU-hotplug operations.)
+	 *
+	 * Note that the grace period cannot complete until we finish
+	 * the initialization process, as there will be at least one
+	 * qsmask bit set in the root node until that time, namely the
+	 * one corresponding to this CPU.
+	 */
+	rnp_end = &rsp->node[NUM_RCU_NODES];
+	rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
+	for (; rnp_cur < rnp_end; rnp_cur++) {
+		spin_lock(&rnp_cur->lock);	/* irqs already disabled. */
+		rnp_cur->qsmask = rnp_cur->qsmaskinit;
+		spin_unlock(&rnp_cur->lock);	/* irqs already disabled. */
+	}
+
+	rsp->signaled = RCU_SIGNAL_INIT; /* force_quiescent_state now OK. */
+	spin_unlock_irqrestore(&rsp->onofflock, flags);
+}
+
+/*
+ * Advance this CPU's callbacks, but only if the current grace period
+ * has ended.  This may be called only from the CPU to whom the rdp
+ * belongs.
+ */
+static void
+rcu_process_gp_end(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	long completed_snap;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	completed_snap = ACCESS_ONCE(rsp->completed);  /* outside of lock. */
+
+	/* Did another grace period end? */
+	if (rdp->completed != completed_snap) {
+
+		/* Advance callbacks.  No harm if list empty. */
+		rdp->nxttail[RCU_DONE_TAIL] = rdp->nxttail[RCU_WAIT_TAIL];
+		rdp->nxttail[RCU_WAIT_TAIL] = rdp->nxttail[RCU_NEXT_READY_TAIL];
+		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+		/* Remember that we saw this grace-period completion. */
+		rdp->completed = completed_snap;
+	}
+	local_irq_restore(flags);
+}
+
+/*
+ * Similar to cpu_quiet(), for which it is a helper function.  Allows
+ * a group of CPUs to be quieted at one go, though all the CPUs in the
+ * group must be represented by the same leaf rcu_node structure.
+ * That structure's lock must be held upon entry, and it is released
+ * before return.
+ */
+static void
+cpu_quiet_msk(unsigned long mask, struct rcu_state *rsp, struct rcu_node *rnp,
+	      unsigned long flags)
+	__releases(rnp->lock)
+{
+	/* Walk up the rcu_node hierarchy. */
+	for (;;) {
+		if (!(rnp->qsmask & mask)) {
+
+			/* Our bit has already been cleared, so done. */
+			spin_unlock_irqrestore(&rnp->lock, flags);
+			return;
+		}
+		rnp->qsmask &= ~mask;
+		if (rnp->qsmask != 0) {
+
+			/* Other bits still set at this level, so done. */
+			spin_unlock_irqrestore(&rnp->lock, flags);
+			return;
+		}
+		mask = rnp->grpmask;
+		if (rnp->parent == NULL) {
+
+			/* No more levels.  Exit loop holding root lock. */
+
+			break;
+		}
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		rnp = rnp->parent;
+		spin_lock_irqsave(&rnp->lock, flags);
+	}
+
+	/*
+	 * Get here if we are the last CPU to pass through a quiescent
+	 * state for this grace period.  Clean up and let rcu_start_gp()
+	 * start up the next grace period if one is needed.  Note that
+	 * we still hold rnp->lock, as required by rcu_start_gp(), which
+	 * will release it.
+	 */
+	rsp->completed = rsp->gpnum;
+	rcu_process_gp_end(rsp, rsp->rda[smp_processor_id()]);
+	rcu_start_gp(rsp, flags);  /* releases rnp->lock. */
+}
+
+/*
+ * Record a quiescent state for the specified CPU, which must either be
+ * the current CPU or an offline CPU.  The lastcomp argument is used to
+ * make sure we are still in the grace period of interest.  We don't want
+ * to end the current grace period based on quiescent states detected in
+ * an earlier grace period!
+ */
+static void
+cpu_quiet(int cpu, struct rcu_state *rsp, struct rcu_data *rdp, long lastcomp)
+{
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_node *rnp;
+
+	rnp = rdp->mynode;
+	spin_lock_irqsave(&rnp->lock, flags);
+	if (lastcomp != ACCESS_ONCE(rsp->completed)) {
+
+		/*
+		 * Someone beat us to it for this grace period, so leave.
+		 * The race with GP start is resolved by the fact that we
+		 * hold the leaf rcu_node lock, so that the per-CPU bits
+		 * cannot yet be initialized -- so we would simply find our
+		 * CPU's bit already cleared in cpu_quiet_msk() if this race
+		 * occurred.
+		 */
+		rdp->passed_quiesc = 0;	/* try again later! */
+		spin_unlock_irqrestore(&rnp->lock, flags);
+		return;
+	}
+	mask = rdp->grpmask;
+	if ((rnp->qsmask & mask) == 0) {
+		spin_unlock_irqrestore(&rnp->lock, flags);
+	} else {
+		rdp->qs_pending = 0;
+
+		/*
+		 * This GP can't end until cpu checks in, so all of our
+		 * callbacks can be processed during the next GP.
+		 */
+		rdp = rsp->rda[smp_processor_id()];
+		rdp->nxttail[RCU_NEXT_READY_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+
+		cpu_quiet_msk(mask, rsp, rnp, flags); /* releases rnp->lock */
+	}
+}
+
+/*
+ * Check to see if there is a new grace period of which this CPU
+ * is not yet aware, and if so, set up local rcu_data state for it.
+ * Otherwise, see if this CPU has just passed through its first
+ * quiescent state for this grace period, and record that fact if so.
+ */
+static void
+rcu_check_quiescent_state(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	/* If there is now a new grace period, record and return. */
+	if (check_for_new_grace_period(rsp, rdp))
+		return;
+
+	/*
+	 * Does this CPU still need to do its part for current grace period?
+	 * If no, return and let the other CPUs do their part as well.
+	 */
+	if (!rdp->qs_pending)
+		return;
+
+	/*
+	 * Was there a quiescent state since the beginning of the grace
+	 * period? If no, then exit and wait for the next call.
+	 */
+	if (!rdp->passed_quiesc)
+		return;
+
+	/* Tell RCU we are done (but cpu_quiet() will be the judge of that). */
+	cpu_quiet(rdp->cpu, rsp, rdp, rdp->passed_quiesc_completed);
+}
+
+#ifdef CONFIG_HOTPLUG_CPU
+
+/*
+ * Remove the outgoing CPU from the bitmasks in the rcu_node hierarchy
+ * and move all callbacks from the outgoing CPU to the current one.
+ */
+static void __rcu_offline_cpu(int cpu, struct rcu_state *rsp)
+{
+	int i;
+	unsigned long flags;
+	long lastcomp;
+	unsigned long mask;
+	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_data *rdp_me;
+	struct rcu_node *rnp;
+
+	/* Exclude any attempts to start a new grace period. */
+	spin_lock_irqsave(&rsp->onofflock, flags);
+
+	/* Remove the outgoing CPU from the masks in the rcu_node hierarchy. */
+	rnp = rdp->mynode;
+	mask = rdp->grpmask;	/* rnp->grplo is constant. */
+	do {
+		spin_lock(&rnp->lock);		/* irqs already disabled. */
+		rnp->qsmaskinit &= ~mask;
+		if (rnp->qsmaskinit != 0) {
+			spin_unlock(&rnp->lock); /* irqs already disabled. */
+			break;
+		}
+		mask = rnp->grpmask;
+		spin_unlock(&rnp->lock);	/* irqs already disabled. */
+		rnp = rnp->parent;
+	} while (rnp != NULL);
+	lastcomp = rsp->completed;
+
+	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
+
+	/* Being offline is a quiescent state, so go record it. */
+	cpu_quiet(cpu, rsp, rdp, lastcomp);
+
+	/*
+	 * Move callbacks from the outgoing CPU to the running CPU.
+	 * Note that the outgoing CPU is now quiscent, so it is now
+	 * (uncharacteristically) safe to access it rcu_data structure.
+	 * Note also that we must carefully retain the order of the
+	 * outgoing CPU's callbacks in order for rcu_barrier() to work
+	 * correctly.  Finally, note that we start all the callbacks
+	 * afresh, even those that have passed through a grace period
+	 * and are therefore ready to invoke.  The theory is that hotplug
+	 * events are rare, and that if they are frequent enough to
+	 * indefinitely delay callbacks, you have far worse things to
+	 * be worrying about.
+	 */
+	rdp_me = rsp->rda[smp_processor_id()];
+	if (rdp->nxtlist != NULL) {
+		*rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxtlist;
+		rdp_me->nxttail[RCU_NEXT_TAIL] = rdp->nxttail[RCU_NEXT_TAIL];
+		rdp->nxtlist = NULL;
+		for (i = 0; i < RCU_NEXT_SIZE; i++)
+			rdp->nxttail[i] = &rdp->nxtlist;
+		rdp_me->qlen += rdp->qlen;
+		rdp->qlen = 0;
+	}
+	local_irq_restore(flags);
+}
+
+/*
+ * Remove the specified CPU from the RCU hierarchy and move any pending
+ * callbacks that it might have to the current CPU.  This code assumes
+ * that at least one CPU in the system will remain running at all times.
+ * Any attempt to offline -all- CPUs is likely to strand RCU callbacks.
+ */
+static void rcu_offline_cpu(int cpu)
+{
+	__rcu_offline_cpu(cpu, &rcu_state);
+	__rcu_offline_cpu(cpu, &rcu_bh_state);
+}
+
+#else /* #ifdef CONFIG_HOTPLUG_CPU */
+
+static void rcu_offline_cpu(int cpu)
+{
+}
+
+#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
+
+/*
+ * Invoke any RCU callbacks that have made it to the end of their grace
+ * period.  Thottle as specified by rdp->blimit.
+ */
+static void rcu_do_batch(struct rcu_data *rdp)
+{
+	unsigned long flags;
+	struct rcu_head *next, *list, **tail;
+	int count;
+
+	/* If no callbacks are ready, just return.*/
+	if (!cpu_has_callbacks_ready_to_invoke(rdp))
+		return;
+
+	/*
+	 * Extract the list of ready callbacks, disabling to prevent
+	 * races with call_rcu() from interrupt handlers.
+	 */
+	local_irq_save(flags);
+	list = rdp->nxtlist;
+	rdp->nxtlist = *rdp->nxttail[RCU_DONE_TAIL];
+	*rdp->nxttail[RCU_DONE_TAIL] = NULL;
+	tail = rdp->nxttail[RCU_DONE_TAIL];
+	for (count = RCU_NEXT_SIZE - 1; count >= 0; count--)
+		if (rdp->nxttail[count] == rdp->nxttail[RCU_DONE_TAIL])
+			rdp->nxttail[count] = &rdp->nxtlist;
+	local_irq_restore(flags);
+
+	/* Invoke callbacks. */
+	count = 0;
+	while (list) {
+		next = list->next;
+		prefetch(next);
+		list->func(list);
+		list = next;
+		if (++count >= rdp->blimit)
+			break;
+	}
+
+	local_irq_save(flags);
+
+	/* Update count, and requeue any remaining callbacks. */
+	rdp->qlen -= count;
+	if (list != NULL) {
+		*tail = rdp->nxtlist;
+		rdp->nxtlist = list;
+		for (count = 0; count < RCU_NEXT_SIZE; count++)
+			if (&rdp->nxtlist == rdp->nxttail[count])
+				rdp->nxttail[count] = tail;
+			else
+				break;
+	}
+
+	/* Reinstate batch limit if we have worked down the excess. */
+	if (rdp->blimit == LONG_MAX && rdp->qlen <= qlowmark)
+		rdp->blimit = blimit;
+
+	local_irq_restore(flags);
+
+	/* Re-raise the RCU softirq if there are callbacks remaining. */
+	if (cpu_has_callbacks_ready_to_invoke(rdp))
+		raise_softirq(RCU_SOFTIRQ);
+}
+
+/*
+ * Check to see if this CPU is in a non-context-switch quiescent state
+ * (user mode or idle loop for rcu, non-softirq execution for rcu_bh).
+ * Also schedule the RCU softirq handler.
+ *
+ * This function must be called with hardirqs disabled.  It is normally
+ * invoked from the scheduling-clock interrupt.  If rcu_pending returns
+ * false, there is no point in invoking rcu_check_callbacks().
+ */
+void rcu_check_callbacks(int cpu, int user)
+{
+	if (user ||
+	    (idle_cpu(cpu) && !in_softirq() &&
+				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
+
+		/*
+		 * Get here if this CPU took its interrupt from user
+		 * mode or from the idle loop, and if this is not a
+		 * nested interrupt.  In this case, the CPU is in
+		 * a quiescent state, so count it.
+		 *
+		 * No memory barrier is required here because both
+		 * rcu_qsctr_inc() and rcu_bh_qsctr_inc() reference
+		 * only CPU-local variables that other CPUs neither
+		 * access nor modify, at least not while the corresponding
+		 * CPU is online.
+		 */
+
+		rcu_qsctr_inc(cpu);
+		rcu_bh_qsctr_inc(cpu);
+
+	} else if (!in_softirq()) {
+
+		/*
+		 * Get here if this CPU did not take its interrupt from
+		 * softirq, in other words, if it is not interrupting
+		 * a rcu_bh read-side critical section.  This is an _bh
+		 * critical section, so count it.
+		 */
+
+		rcu_bh_qsctr_inc(cpu);
+	}
+	raise_softirq(RCU_SOFTIRQ);
+}
+
+#ifdef CONFIG_SMP
+
+/*
+ * Scan the leaf rcu_node structures, processing dyntick state for any that
+ * have not yet encountered a quiescent state, using the function specified.
+ * Returns 1 if the current grace period ends while scanning (possibly
+ * because we made it end).
+ */
+static int rcu_process_dyntick(struct rcu_state *rsp, long lastcomp,
+			       int (*f)(struct rcu_data *))
+{
+	unsigned long bit;
+	int cpu;
+	unsigned long flags;
+	unsigned long mask;
+	struct rcu_node *rnp_cur = rsp->level[NUM_RCU_LVLS - 1];
+	struct rcu_node *rnp_end = &rsp->node[NUM_RCU_NODES];
+
+	for (; rnp_cur < rnp_end; rnp_cur++) {
+		mask = 0;
+		spin_lock_irqsave(&rnp_cur->lock, flags);
+		if (rsp->completed != lastcomp) {
+			spin_unlock_irqrestore(&rnp_cur->lock, flags);
+			return 1;
+		}
+		if (rnp_cur->qsmask == 0) {
+			spin_unlock_irqrestore(&rnp_cur->lock, flags);
+			continue;
+		}
+		cpu = rnp_cur->grplo;
+		bit = 1;
+		for (; cpu <= rnp_cur->grphi; cpu++, bit <<= 1) {
+			if ((rnp_cur->qsmask & bit) != 0 && f(rsp->rda[cpu]))
+				mask |= bit;
+		}
+		if (mask != 0 && rsp->completed == lastcomp) {
+
+			/* cpu_quiet_msk() releases rnp_cur->lock. */
+			cpu_quiet_msk(mask, rsp, rnp_cur, flags);
+			continue;
+		}
+		spin_unlock_irqrestore(&rnp_cur->lock, flags);
+	}
+	return 0;
+}
+
+/*
+ * Force quiescent states on reluctant CPUs, and also detect which
+ * CPUs are in dyntick-idle mode.
+ */
+static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
+{
+	unsigned long flags;
+	long lastcomp;
+	struct rcu_data *rdp = rsp->rda[smp_processor_id()];
+	struct rcu_node *rnp = rcu_get_root(rsp);
+	u8 signaled;
+
+	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum))
+		return;  /* No grace period in progress, nothing to force. */
+	if (!spin_trylock_irqsave(&rsp->fqslock, flags)) {
+		rsp->n_force_qs_lh++; /* Inexact, can lose counts.  Tough! */
+		return;	/* Someone else is already on the job. */
+	}
+	if (relaxed &&
+	    (long)(rsp->jiffies_force_qs - jiffies) >= 0 &&
+	    (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) >= 0)
+		goto unlock_ret; /* no emergency and done recently. */
+	rsp->n_force_qs++;
+	spin_lock(&rnp->lock);
+	lastcomp = rsp->completed;
+	signaled = rsp->signaled;
+	rsp->jiffies_force_qs = jiffies + RCU_JIFFIES_TILL_FORCE_QS;
+	rdp->n_rcu_pending_force_qs = rdp->n_rcu_pending +
+				      RCU_JIFFIES_TILL_FORCE_QS;
+	if (lastcomp == rsp->gpnum) {
+		rsp->n_force_qs_ngp++;
+		spin_unlock(&rnp->lock);
+		goto unlock_ret;  /* no GP in progress, time updated. */
+	}
+	spin_unlock(&rnp->lock);
+	switch (signaled) {
+	case RCU_GP_INIT:
+
+		break; /* grace period still initializing, ignore. */
+
+	case RCU_SAVE_DYNTICK:
+
+		if (RCU_SIGNAL_INIT != RCU_SAVE_DYNTICK)
+			break; /* So gcc recognizes the dead code. */
+
+		/* Record dyntick-idle state. */
+		if (rcu_process_dyntick(rsp, lastcomp,
+					dyntick_save_progress_counter))
+			goto unlock_ret;
+
+		/* Update state, record completion counter. */
+		spin_lock(&rnp->lock);
+		if (lastcomp == rsp->completed) {
+			rsp->signaled = RCU_FORCE_QS;
+			dyntick_record_completed(rsp, lastcomp);
+		}
+		spin_unlock(&rnp->lock);
+		break;
+
+	case RCU_FORCE_QS:
+
+		/* Check dyntick-idle state, send IPI to laggarts. */
+		if (rcu_process_dyntick(rsp, dyntick_recall_completed(rsp),
+					rcu_implicit_dynticks_qs))
+			goto unlock_ret;
+
+		/* Leave state in case more forcing is required. */
+
+		break;
+	}
+unlock_ret:
+	spin_unlock_irqrestore(&rsp->fqslock, flags);
+}
+
+#else /* #ifdef CONFIG_SMP */
+
+static void force_quiescent_state(struct rcu_state *rsp, int relaxed)
+{
+	set_need_resched();
+}
+
+#endif /* #else #ifdef CONFIG_SMP */
+
+/*
+ * This does the RCU processing work from softirq context for the
+ * specified rcu_state and rcu_data structures.  This may be called
+ * only from the CPU to whom the rdp belongs.
+ */
+static void
+__rcu_process_callbacks(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	unsigned long flags;
+
+	/*
+	 * If an RCU GP has gone long enough, go check for dyntick
+	 * idle CPUs and, if needed, send resched IPIs.
+	 */
+	if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0 ||
+	    (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) < 0)
+		force_quiescent_state(rsp, 1);
+
+	/*
+	 * Advance callbacks in response to end of earlier grace
+	 * period that some other CPU ended.
+	 */
+	rcu_process_gp_end(rsp, rdp);
+
+	/* Update RCU state based on any recent quiescent states. */
+	rcu_check_quiescent_state(rsp, rdp);
+
+	/* Does this CPU require a not-yet-started grace period? */
+	if (cpu_needs_another_gp(rsp, rdp)) {
+		spin_lock_irqsave(&rcu_get_root(rsp)->lock, flags);
+		rcu_start_gp(rsp, flags);  /* releases above lock */
+	}
+
+	/* If there are callbacks ready, invoke them. */
+	rcu_do_batch(rdp);
+}
+
+/*
+ * Do softirq processing for the current CPU.
+ */
+static void rcu_process_callbacks(struct softirq_action *unused)
+{
+	/*
+	 * Memory references from any prior RCU read-side critical sections
+	 * executed by the interrupted code must be seen before any RCU
+	 * grace-period manipulations below.
+	 */
+	smp_mb(); /* See above block comment. */
+
+	__rcu_process_callbacks(&rcu_state, &__get_cpu_var(rcu_data));
+	__rcu_process_callbacks(&rcu_bh_state, &__get_cpu_var(rcu_bh_data));
+
+	/*
+	 * Memory references from any later RCU read-side critical sections
+	 * executed by the interrupted code must be seen after any RCU
+	 * grace-period manipulations above.
+	 */
+	smp_mb(); /* See above block comment. */
+}
+
+static void
+__call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
+	   struct rcu_state *rsp)
+{
+	unsigned long flags;
+	struct rcu_data *rdp;
+
+	head->func = func;
+	head->next = NULL;
+
+	smp_mb(); /* Ensure RCU update seen before callback registry. */
+
+	/*
+	 * Opportunistically note grace-period endings and beginnings.
+	 * Note that we might see a beginning right after we see an
+	 * end, but never vice versa, since this CPU has to pass through
+	 * a quiescent state betweentimes.
+	 */
+	local_irq_save(flags);
+	rdp = rsp->rda[smp_processor_id()];
+	rcu_process_gp_end(rsp, rdp);
+	check_for_new_grace_period(rsp, rdp);
+
+	/* Add the callback to our list. */
+	*rdp->nxttail[RCU_NEXT_TAIL] = head;
+	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
+
+	/* Start a new grace period if one not already started. */
+	if (ACCESS_ONCE(rsp->completed) == ACCESS_ONCE(rsp->gpnum)) {
+		unsigned long nestflag;
+		struct rcu_node *rnp_root = rcu_get_root(rsp);
+
+		spin_lock_irqsave(&rnp_root->lock, nestflag);
+		rcu_start_gp(rsp, nestflag);  /* releases rnp_root->lock. */
+	}
+
+	/* Force the grace period if too many callbacks or too long waiting. */
+	if (unlikely(++rdp->qlen > qhimark)) {
+		rdp->blimit = LONG_MAX;
+		force_quiescent_state(rsp, 0);
+	} else if ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0 ||
+		   (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) < 0)
+		force_quiescent_state(rsp, 1);
+	local_irq_restore(flags);
+}
+
+/*
+ * Queue an RCU callback for invocation after a grace period.
+ */
+void call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_state);
+}
+EXPORT_SYMBOL_GPL(call_rcu);
+
+/*
+ * Queue an RCU for invocation after a quicker grace period.
+ */
+void call_rcu_bh(struct rcu_head *head, void (*func)(struct rcu_head *rcu))
+{
+	__call_rcu(head, func, &rcu_bh_state);
+}
+EXPORT_SYMBOL_GPL(call_rcu_bh);
+
+/*
+ * Check to see if there is any immediate RCU-related work to be done
+ * by the current CPU, for the specified type of RCU, returning 1 if so.
+ * The checks are in order of increasing expense: checks that can be
+ * carried out against CPU-local state are performed first.  However,
+ * we must check for CPU stalls first, else we might not get a chance.
+ */
+static int __rcu_pending(struct rcu_state *rsp, struct rcu_data *rdp)
+{
+	rdp->n_rcu_pending++;
+
+	/* Check for CPU stalls, if enabled. */
+	check_cpu_stall(rsp, rdp);
+
+	/* Is the RCU core waiting for a quiescent state from this CPU? */
+	if (rdp->qs_pending)
+		return 1;
+
+	/* Does this CPU have callbacks ready to invoke? */
+	if (cpu_has_callbacks_ready_to_invoke(rdp))
+		return 1;
+
+	/* Has RCU gone idle with this CPU needing another grace period? */
+	if (cpu_needs_another_gp(rsp, rdp))
+		return 1;
+
+	/* Has another RCU grace period completed?  */
+	if (ACCESS_ONCE(rsp->completed) != rdp->completed) /* outside of lock */
+		return 1;
+
+	/* Has a new RCU grace period started? */
+	if (ACCESS_ONCE(rsp->gpnum) != rdp->gpnum) /* outside of lock */
+		return 1;
+
+	/* Has an RCU GP gone long enough to send resched IPIs &c? */
+	if (ACCESS_ONCE(rsp->completed) != ACCESS_ONCE(rsp->gpnum) &&
+	    ((long)(ACCESS_ONCE(rsp->jiffies_force_qs) - jiffies) < 0 ||
+	     (rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending) < 0))
+		return 1;
+
+	/* nothing to do */
+	return 0;
+}
+
+/*
+ * Check to see if there is any immediate RCU-related work to be done
+ * by the current CPU, returning 1 if so.  This function is part of the
+ * RCU implementation; it is -not- an exported member of the RCU API.
+ */
+int rcu_pending(int cpu)
+{
+	return __rcu_pending(&rcu_state, &per_cpu(rcu_data, cpu)) ||
+	       __rcu_pending(&rcu_bh_state, &per_cpu(rcu_bh_data, cpu));
+}
+
+/*
+ * Check to see if any future RCU-related work will need to be done
+ * by the current CPU, even if none need be done immediately, returning
+ * 1 if so.  This function is part of the RCU implementation; it is -not-
+ * an exported member of the RCU API.
+ */
+int rcu_needs_cpu(int cpu)
+{
+	/* RCU callbacks either ready or pending? */
+	return per_cpu(rcu_data, cpu).nxtlist ||
+	       per_cpu(rcu_bh_data, cpu).nxtlist;
+}
+
+/*
+ * Initialize a CPU's per-CPU RCU data.  We take this "scorched earth"
+ * approach so that we don't have to worry about how long the CPU has
+ * been gone, or whether it ever was online previously.  We do trust the
+ * ->mynode field, as it is constant for a given struct rcu_data and
+ * initialized during early boot.
+ *
+ * Note that only one online or offline event can be happening at a given
+ * time.  Note also that we can accept some slop in the rsp->completed
+ * access due to the fact that this CPU cannot possibly have any RCU
+ * callbacks in flight yet.
+ */
+static void
+rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
+{
+	unsigned long flags;
+	int i;
+	long lastcomp;
+	unsigned long mask;
+	struct rcu_data *rdp = rsp->rda[cpu];
+	struct rcu_node *rnp = rcu_get_root(rsp);
+
+	/* Set up local state, ensuring consistent view of global state. */
+	spin_lock_irqsave(&rnp->lock, flags);
+	lastcomp = rsp->completed;
+	rdp->completed = lastcomp;
+	rdp->gpnum = lastcomp;
+	rdp->passed_quiesc = 0;  /* We could be racing with new GP, */
+	rdp->qs_pending = 1;	 /*  so set up to respond to current GP. */
+	rdp->beenonline = 1;	 /* We have now been online. */
+	rdp->passed_quiesc_completed = lastcomp - 1;
+	rdp->grpmask = 1UL << (cpu - rdp->mynode->grplo);
+	rdp->nxtlist = NULL;
+	for (i = 0; i < RCU_NEXT_SIZE; i++)
+		rdp->nxttail[i] = &rdp->nxtlist;
+	rdp->qlen = 0;
+	rdp->blimit = blimit;
+#ifdef CONFIG_NO_HZ
+	rdp->dynticks = &per_cpu(rcu_dynticks, cpu);
+#endif /* #ifdef CONFIG_NO_HZ */
+	rdp->cpu = cpu;
+	spin_unlock(&rnp->lock);		/* irqs remain disabled. */
+
+	/*
+	 * A new grace period might start here.  If so, we won't be part
+	 * of it, but that is OK, as we are currently in a quiescent state.
+	 */
+
+	/* Exclude any attempts to start a new GP on large systems. */
+	spin_lock(&rsp->onofflock);		/* irqs already disabled. */
+
+	/* Add CPU to rcu_node bitmasks. */
+	rnp = rdp->mynode;
+	mask = rdp->grpmask;
+	do {
+		/* Exclude any attempts to start a new GP on small systems. */
+		spin_lock(&rnp->lock);	/* irqs already disabled. */
+		rnp->qsmaskinit |= mask;
+		mask = rnp->grpmask;
+		spin_unlock(&rnp->lock); /* irqs already disabled. */
+		rnp = rnp->parent;
+	} while (rnp != NULL && !(rnp->qsmaskinit & mask));
+
+	spin_unlock(&rsp->onofflock);		/* irqs remain disabled. */
+
+	/*
+	 * A new grace period might start here.  If so, we will be part of
+	 * it, and its gpnum will be greater than ours, so we will
+	 * participate.  It is also possible for the gpnum to have been
+	 * incremented before this function was called, and the bitmasks
+	 * to not be filled out until now, in which case we will also
+	 * participate due to our gpnum being behind.
+	 */
+
+	/* Since it is coming online, the CPU is in a quiescent state. */
+	cpu_quiet(cpu, rsp, rdp, lastcomp);
+	local_irq_restore(flags);
+}
+
+static void __cpuinit rcu_online_cpu(int cpu)
+{
+#ifdef CONFIG_NO_HZ
+	struct rcu_dynticks *rdtp = &per_cpu(rcu_dynticks, cpu);
+
+	rdtp->dynticks_nesting = 1;
+	rdtp->dynticks |= 1; 	/* need consecutive #s even for hotplug. */
+	rdtp->dynticks_nmi = (rdtp->dynticks_nmi + 1) & ~0x1;
+#endif /* #ifdef CONFIG_NO_HZ */
+	rcu_init_percpu_data(cpu, &rcu_state);
+	rcu_init_percpu_data(cpu, &rcu_bh_state);
+	open_softirq(RCU_SOFTIRQ, rcu_process_callbacks);
+}
+
+/*
+ * Handle CPU online/offline notifcation events.
+ */
+static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
+				unsigned long action, void *hcpu)
+{
+	long cpu = (long)hcpu;
+
+	switch (action) {
+	case CPU_UP_PREPARE:
+	case CPU_UP_PREPARE_FROZEN:
+		rcu_online_cpu(cpu);
+		break;
+	case CPU_DEAD:
+	case CPU_DEAD_FROZEN:
+	case CPU_UP_CANCELED:
+	case CPU_UP_CANCELED_FROZEN:
+		rcu_offline_cpu(cpu);
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
+/*
+ * Compute the per-level fanout, either using the exact fanout specified
+ * or balancing the tree, depending on CONFIG_RCU_FANOUT_EXACT.
+ */
+#ifdef CONFIG_RCU_FANOUT_EXACT
+static void __init rcu_init_levelspread(struct rcu_state *rsp)
+{
+	int i;
+
+	for (i = NUM_RCU_LVLS - 1; i >= 0; i--)
+		rsp->levelspread[i] = CONFIG_RCU_FANOUT;
+}
+#else /* #ifdef CONFIG_RCU_FANOUT_EXACT */
+static void __init rcu_init_levelspread(struct rcu_state *rsp)
+{
+	int ccur;
+	int cprv;
+	int i;
+
+	cprv = NR_CPUS;
+	for (i = NUM_RCU_LVLS - 1; i >= 0; i--) {
+		ccur = rsp->levelcnt[i];
+		rsp->levelspread[i] = (cprv + ccur - 1) / ccur;
+		cprv = ccur;
+	}
+}
+#endif /* #else #ifdef CONFIG_RCU_FANOUT_EXACT */
+
+/*
+ * Helper function for rcu_init() that initializes one rcu_state structure.
+ */
+static void __init rcu_init_one(struct rcu_state *rsp)
+{
+	int cpustride = 1;
+	int i;
+	int j;
+	struct rcu_node *rnp;
+
+	/* Initialize the level-tracking arrays. */
+
+	for (i = 1; i < NUM_RCU_LVLS; i++)
+		rsp->level[i] = rsp->level[i - 1] + rsp->levelcnt[i - 1];
+	rcu_init_levelspread(rsp);
+
+	/* Initialize the elements themselves, starting from the leaves. */
+
+	for (i = NUM_RCU_LVLS - 1; i >= 0; i--) {
+		cpustride *= rsp->levelspread[i];
+		rnp = rsp->level[i];
+		for (j = 0; j < rsp->levelcnt[i]; j++, rnp++) {
+			spin_lock_init(&rnp->lock);
+			rnp->qsmask = 0;
+			rnp->qsmaskinit = 0;
+			rnp->grplo = j * cpustride;
+			rnp->grphi = (j + 1) * cpustride - 1;
+			if (rnp->grphi >= NR_CPUS)
+				rnp->grphi = NR_CPUS - 1;
+			if (i == 0) {
+				rnp->grpnum = 0;
+				rnp->grpmask = 0;
+				rnp->parent = NULL;
+			} else {
+				rnp->grpnum = j % rsp->levelspread[i - 1];
+				rnp->grpmask = 1UL << rnp->grpnum;
+				rnp->parent = rsp->level[i - 1] +
+					      j / rsp->levelspread[i - 1];
+			}
+			rnp->level = i;
+		}
+	}
+}
+
+/*
+ * Helper macro for __rcu_init().  To be used nowhere else!
+ * Assigns leaf node pointers into each CPU's rcu_data structure.
+ */
+#define RCU_DATA_PTR_INIT(rsp, rcu_data) \
+do { \
+	rnp = (rsp)->level[NUM_RCU_LVLS - 1]; \
+	j = 0; \
+	for_each_possible_cpu(i) { \
+		if (i > rnp[j].grphi) \
+			j++; \
+		per_cpu(rcu_data, i).mynode = &rnp[j]; \
+		(rsp)->rda[i] = &per_cpu(rcu_data, i); \
+	} \
+} while (0)
+
+static struct notifier_block __cpuinitdata rcu_nb = {
+	.notifier_call	= rcu_cpu_notify,
+};
+
+void __init __rcu_init(void)
+{
+	int i;			/* All used by RCU_DATA_PTR_INIT(). */
+	int j;
+	struct rcu_node *rnp;
+
+	printk(KERN_WARNING "Experimental hierarchical RCU implementation.\n");
+#ifdef CONFIG_RCU_CPU_STALL_DETECTOR
+	printk(KERN_INFO "RCU-based detection of stalled CPUs is enabled.\n");
+#endif /* #ifdef CONFIG_RCU_CPU_STALL_DETECTOR */
+	rcu_init_one(&rcu_state);
+	RCU_DATA_PTR_INIT(&rcu_state, rcu_data);
+	rcu_init_one(&rcu_bh_state);
+	RCU_DATA_PTR_INIT(&rcu_bh_state, rcu_bh_data);
+
+	for_each_online_cpu(i)
+		rcu_cpu_notify(&rcu_nb, CPU_UP_PREPARE, (void *)(long)i);
+	/* Register notifier for non-boot CPUs */
+	register_cpu_notifier(&rcu_nb);
+	printk(KERN_WARNING "Experimental hierarchical RCU init done.\n");
+}
+
+module_param(blimit, int, 0);
+module_param(qhimark, int, 0);
+module_param(qlowmark, int, 0);
diff --git a/kernel/rcutree_trace.c b/kernel/rcutree_trace.c
new file mode 100644
index 0000000..d6db3e8
--- /dev/null
+++ b/kernel/rcutree_trace.c
@@ -0,0 +1,271 @@
+/*
+ * Read-Copy Update tracing for classic implementation
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
+ * Papers:  http://www.rdrop.com/users/paulmck/RCU
+ *
+ * For detailed explanation of Read-Copy Update mechanism see -
+ * 		Documentation/RCU
+ *
+ */
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/spinlock.h>
+#include <linux/smp.h>
+#include <linux/rcupdate.h>
+#include <linux/interrupt.h>
+#include <linux/sched.h>
+#include <asm/atomic.h>
+#include <linux/bitops.h>
+#include <linux/module.h>
+#include <linux/completion.h>
+#include <linux/moduleparam.h>
+#include <linux/percpu.h>
+#include <linux/notifier.h>
+#include <linux/cpu.h>
+#include <linux/mutex.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
+
+static void print_one_rcu_data(struct seq_file *m, struct rcu_data *rdp)
+{
+	if (!rdp->beenonline)
+		return;
+	seq_printf(m, "%3d%cc=%ld g=%ld pq=%d pqc=%ld qp=%d rpfq=%ld rp=%x",
+		   rdp->cpu,
+		   cpu_is_offline(rdp->cpu) ? '!' : ' ',
+		   rdp->completed, rdp->gpnum,
+		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
+		   rdp->qs_pending,
+		   rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending,
+		   (int)(rdp->n_rcu_pending & 0xffff));
+#ifdef CONFIG_NO_HZ
+	seq_printf(m, " dt=%d/%d dn=%d df=%lu",
+		   rdp->dynticks->dynticks,
+		   rdp->dynticks->dynticks_nesting,
+		   rdp->dynticks->dynticks_nmi,
+		   rdp->dynticks_fqs);
+#endif /* #ifdef CONFIG_NO_HZ */
+	seq_printf(m, " of=%lu ri=%lu", rdp->offline_fqs, rdp->resched_ipi);
+	seq_printf(m, " ql=%ld b=%ld\n", rdp->qlen, rdp->blimit);
+}
+
+#define PRINT_RCU_DATA(name, func, m) \
+	do { \
+		int _p_r_d_i; \
+		\
+		for_each_possible_cpu(_p_r_d_i) \
+			func(m, &per_cpu(name, _p_r_d_i)); \
+	} while (0)
+
+static int show_rcudata(struct seq_file *m, void *unused)
+{
+	seq_puts(m, "rcu:\n");
+	PRINT_RCU_DATA(rcu_data, print_one_rcu_data, m);
+	seq_puts(m, "rcu_bh:\n");
+	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data, m);
+	return 0;
+}
+
+static int rcudata_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcudata, NULL);
+}
+
+static struct file_operations rcudata_fops = {
+	.owner = THIS_MODULE,
+	.open = rcudata_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static void print_one_rcu_data_csv(struct seq_file *m, struct rcu_data *rdp)
+{
+	if (!rdp->beenonline)
+		return;
+	seq_printf(m, "%d,%s,%ld,%ld,%d,%ld,%d,%ld,%ld",
+		   rdp->cpu,
+		   cpu_is_offline(rdp->cpu) ? "\"Y\"" : "\"N\"",
+		   rdp->completed, rdp->gpnum,
+		   rdp->passed_quiesc, rdp->passed_quiesc_completed,
+		   rdp->qs_pending,
+		   rdp->n_rcu_pending_force_qs - rdp->n_rcu_pending,
+		   rdp->n_rcu_pending);
+#ifdef CONFIG_NO_HZ
+	seq_printf(m, ",%d,%d,%d,%lu",
+		   rdp->dynticks->dynticks,
+		   rdp->dynticks->dynticks_nesting,
+		   rdp->dynticks->dynticks_nmi,
+		   rdp->dynticks_fqs);
+#endif /* #ifdef CONFIG_NO_HZ */
+	seq_printf(m, ",%lu,%lu", rdp->offline_fqs, rdp->resched_ipi);
+	seq_printf(m, ",%ld,%ld\n", rdp->qlen, rdp->blimit);
+}
+
+static int show_rcudata_csv(struct seq_file *m, void *unused)
+{
+	seq_puts(m, "\"CPU\",\"Online?\",\"c\",\"g\",\"pq\",\"pqc\",\"pq\",\"rpfq\",\"rp\",");
+#ifdef CONFIG_NO_HZ
+	seq_puts(m, "\"dt\",\"dt nesting\",\"dn\",\"df\",");
+#endif /* #ifdef CONFIG_NO_HZ */
+	seq_puts(m, "\"of\",\"ri\",\"ql\",\"b\"\n");
+	seq_puts(m, "\"rcu:\"\n");
+	PRINT_RCU_DATA(rcu_data, print_one_rcu_data_csv, m);
+	seq_puts(m, "\"rcu_bh:\"\n");
+	PRINT_RCU_DATA(rcu_bh_data, print_one_rcu_data_csv, m);
+	return 0;
+}
+
+static int rcudata_csv_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcudata_csv, NULL);
+}
+
+static struct file_operations rcudata_csv_fops = {
+	.owner = THIS_MODULE,
+	.open = rcudata_csv_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static void print_one_rcu_state(struct seq_file *m, struct rcu_state *rsp)
+{
+	int level = 0;
+	struct rcu_node *rnp;
+
+	seq_printf(m, "c=%ld g=%ld s=%d jfq=%ld j=%x "
+	              "nfqs=%lu/nfqsng=%lu(%lu) fqlh=%lu\n",
+		   rsp->completed, rsp->gpnum, rsp->signaled,
+		   (long)(rsp->jiffies_force_qs - jiffies),
+		   (int)(jiffies & 0xffff),
+		   rsp->n_force_qs, rsp->n_force_qs_ngp,
+		   rsp->n_force_qs - rsp->n_force_qs_ngp,
+		   rsp->n_force_qs_lh);
+	for (rnp = &rsp->node[0]; rnp - &rsp->node[0] < NUM_RCU_NODES; rnp++) {
+		if (rnp->level != level) {
+			seq_puts(m, "\n");
+			level = rnp->level;
+		}
+		seq_printf(m, "%lx/%lx %d:%d ^%d    ",
+			   rnp->qsmask, rnp->qsmaskinit,
+			   rnp->grplo, rnp->grphi, rnp->grpnum);
+	}
+	seq_puts(m, "\n");
+}
+
+static int show_rcuhier(struct seq_file *m, void *unused)
+{
+	seq_puts(m, "rcu:\n");
+	print_one_rcu_state(m, &rcu_state);
+	seq_puts(m, "rcu_bh:\n");
+	print_one_rcu_state(m, &rcu_bh_state);
+	return 0;
+}
+
+static int rcuhier_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcuhier, NULL);
+}
+
+static struct file_operations rcuhier_fops = {
+	.owner = THIS_MODULE,
+	.open = rcuhier_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static int show_rcugp(struct seq_file *m, void *unused)
+{
+	seq_printf(m, "rcu: completed=%ld  gpnum=%ld\n",
+		   rcu_state.completed, rcu_state.gpnum);
+	seq_printf(m, "rcu_bh: completed=%ld  gpnum=%ld\n",
+		   rcu_bh_state.completed, rcu_bh_state.gpnum);
+	return 0;
+}
+
+static int rcugp_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, show_rcugp, NULL);
+}
+
+static struct file_operations rcugp_fops = {
+	.owner = THIS_MODULE,
+	.open = rcugp_open,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+};
+
+static struct dentry *rcudir, *datadir, *datadir_csv, *hierdir, *gpdir;
+static int __init rcuclassic_trace_init(void)
+{
+	rcudir = debugfs_create_dir("rcu", NULL);
+	if (!rcudir)
+		goto out;
+
+	datadir = debugfs_create_file("rcudata", 0444, rcudir,
+						NULL, &rcudata_fops);
+	if (!datadir)
+		goto free_out;
+
+	datadir_csv = debugfs_create_file("rcudata.csv", 0444, rcudir,
+						NULL, &rcudata_csv_fops);
+	if (!datadir_csv)
+		goto free_out;
+
+	gpdir = debugfs_create_file("rcugp", 0444, rcudir, NULL, &rcugp_fops);
+	if (!gpdir)
+		goto free_out;
+
+	hierdir = debugfs_create_file("rcuhier", 0444, rcudir,
+						NULL, &rcuhier_fops);
+	if (!hierdir)
+		goto free_out;
+	return 0;
+free_out:
+	if (datadir)
+		debugfs_remove(datadir);
+	if (datadir_csv)
+		debugfs_remove(datadir_csv);
+	if (gpdir)
+		debugfs_remove(gpdir);
+	debugfs_remove(rcudir);
+out:
+	return 1;
+}
+
+static void __exit rcuclassic_trace_cleanup(void)
+{
+	debugfs_remove(datadir);
+	debugfs_remove(datadir_csv);
+	debugfs_remove(gpdir);
+	debugfs_remove(hierdir);
+	debugfs_remove(rcudir);
+}
+
+
+module_init(rcuclassic_trace_init);
+module_exit(rcuclassic_trace_cleanup);
+
+MODULE_AUTHOR("Paul E. McKenney");
+MODULE_DESCRIPTION("Read-Copy Update tracing for hierarchical implementation");
+MODULE_LICENSE("GPL");
diff --git a/kernel/resource.c b/kernel/resource.c
index 4337063..e633106 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -853,6 +853,15 @@ int iomem_map_sanity_check(resource_size_t addr, unsigned long size)
 		if (PFN_DOWN(p->start) <= PFN_DOWN(addr) &&
 		    PFN_DOWN(p->end) >= PFN_DOWN(addr + size - 1))
 			continue;
+		/*
+		 * if a resource is "BUSY", it's not a hardware resource
+		 * but a driver mapping of such a resource; we don't want
+		 * to warn for those; some drivers legitimately map only
+		 * partial hardware resources. (example: vesafb)
+		 */
+		if (p->flags & IORESOURCE_BUSY)
+			continue;
+
 		printk(KERN_WARNING "resource map sanity check conflict: "
 		       "0x%llx 0x%llx 0x%llx 0x%llx %s\n",
 		       (unsigned long long)addr,
diff --git a/kernel/sched.c b/kernel/sched.c
index e4bb1dd..3e70963 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -4203,7 +4203,6 @@ void account_steal_time(struct task_struct *p, cputime_t steal)
 
 	if (p == rq->idle) {
 		p->stime = cputime_add(p->stime, steal);
-		account_group_system_time(p, steal);
 		if (atomic_read(&rq->nr_iowait) > 0)
 			cpustat->iowait = cputime64_add(cpustat->iowait, tmp);
 		else
@@ -4339,7 +4338,7 @@ void __kprobes sub_preempt_count(int val)
 	/*
 	 * Underflow?
 	 */
-	if (DEBUG_LOCKS_WARN_ON(val > preempt_count()))
+       if (DEBUG_LOCKS_WARN_ON(val > preempt_count() - (!!kernel_locked())))
 		return;
 	/*
 	 * Is the spinlock portion underflowing?
diff --git a/kernel/softirq.c b/kernel/softirq.c
index e7c69a7..466e75c 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -102,20 +102,6 @@ void local_bh_disable(void)
 
 EXPORT_SYMBOL(local_bh_disable);
 
-void __local_bh_enable(void)
-{
-	WARN_ON_ONCE(in_irq());
-
-	/*
-	 * softirqs should never be enabled by __local_bh_enable(),
-	 * it always nests inside local_bh_enable() sections:
-	 */
-	WARN_ON_ONCE(softirq_count() == SOFTIRQ_OFFSET);
-
-	sub_preempt_count(SOFTIRQ_OFFSET);
-}
-EXPORT_SYMBOL_GPL(__local_bh_enable);
-
 /*
  * Special-case - softirqs can safely be enabled in
  * cond_resched_softirq(), or by __do_softirq(),
@@ -269,6 +255,7 @@ void irq_enter(void)
 {
 	int cpu = smp_processor_id();
 
+	rcu_irq_enter();
 	if (idle_cpu(cpu) && !in_interrupt()) {
 		__irq_enter();
 		tick_check_idle(cpu);
@@ -295,9 +282,9 @@ void irq_exit(void)
 
 #ifdef CONFIG_NO_HZ
 	/* Make sure that timer wheel updates are propagated */
-	if (!in_interrupt() && idle_cpu(smp_processor_id()) && !need_resched())
-		tick_nohz_stop_sched_tick(0);
 	rcu_irq_exit();
+	if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
+		tick_nohz_stop_sched_tick(0);
 #endif
 	preempt_enable_no_resched();
 }
diff --git a/kernel/softlockup.c b/kernel/softlockup.c
index dc0b3be..1ab790c 100644
--- a/kernel/softlockup.c
+++ b/kernel/softlockup.c
@@ -164,7 +164,7 @@ unsigned long __read_mostly sysctl_hung_task_check_count = 1024;
 /*
  * Zero means infinite timeout - no checking done:
  */
-unsigned long __read_mostly sysctl_hung_task_timeout_secs = 120;
+unsigned long __read_mostly sysctl_hung_task_timeout_secs = 480;
 
 unsigned long __read_mostly sysctl_hung_task_warnings = 10;
 
diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 94b527e..eb212f8 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -6,6 +6,7 @@
  *  Copyright (C) 2006 Red Hat, Inc., Ingo Molnar <mingo@redhat.com>
  */
 #include <linux/sched.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
@@ -24,3 +25,13 @@ void print_stack_trace(struct stack_trace *trace, int spaces)
 }
 EXPORT_SYMBOL_GPL(print_stack_trace);
 
+/*
+ * Architectures that do not implement save_stack_trace_tsk get this
+ * weak alias and a once-per-bootup warning (whenever this facility
+ * is utilized - for example by procfs):
+ */
+__weak void
+save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
+{
+	WARN_ONCE(1, KERN_INFO "save_stack_trace_tsk() not implemented yet.\n");
+}
diff --git a/kernel/sys.c b/kernel/sys.c
index 31deba8..5fc3a0c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -858,8 +858,8 @@ void do_sys_times(struct tms *tms)
 	struct task_cputime cputime;
 	cputime_t cutime, cstime;
 
-	spin_lock_irq(&current->sighand->siglock);
 	thread_group_cputime(current, &cputime);
+	spin_lock_irq(&current->sighand->siglock);
 	cutime = current->signal->cutime;
 	cstime = current->signal->cstime;
 	spin_unlock_irq(&current->sighand->siglock);
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b0f239e..eae594c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -252,6 +252,14 @@ config DEBUG_OBJECTS_TIMERS
 	  timer routines to track the life time of timer objects and
 	  validate the timer operations.
 
+config DEBUG_OBJECTS_ENABLE_DEFAULT
+	int "debug_objects bootup default value (0-1)"
+        range 0 1
+        default "1"
+        depends on DEBUG_OBJECTS
+        help
+          Debug objects boot parameter default value
+
 config DEBUG_SLAB
 	bool "Debug slab memory allocations"
 	depends on DEBUG_KERNEL && SLAB
@@ -545,6 +553,16 @@ config DEBUG_SG
 
 	  If unsure, say N.
 
+config DEBUG_NOTIFIERS
+	bool "Debug notifier call chains"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on sanity checking for notifier call chains.
+	  This is most useful for kernel developers to make sure that
+	  modules properly unregister themselves from notifier chains.
+	  This is a relatively cheap check but if you care about maximum
+	  performance, say N.
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
@@ -619,6 +637,19 @@ config RCU_CPU_STALL_DETECTOR
 
 	  Say N if you are unsure.
 
+config RCU_CPU_STALL_DETECTOR
+	bool "Check for stalled CPUs delaying RCU grace periods"
+	depends on CLASSIC_RCU || TREE_RCU
+	default n
+	help
+	  This option causes RCU to printk information on which
+	  CPUs are delaying the current grace period, but only when
+	  the grace period extends for excessive time periods.
+
+	  Say Y if you want RCU to perform such checks.
+
+	  Say N if you are unsure.
+
 config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
diff --git a/lib/debugobjects.c b/lib/debugobjects.c
index e3ab374..5d99be1 100644
--- a/lib/debugobjects.c
+++ b/lib/debugobjects.c
@@ -45,7 +45,9 @@ static struct kmem_cache	*obj_cache;
 static int			debug_objects_maxchain __read_mostly;
 static int			debug_objects_fixups __read_mostly;
 static int			debug_objects_warnings __read_mostly;
-static int			debug_objects_enabled __read_mostly;
+static int			debug_objects_enabled __read_mostly
+				= CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT;
+
 static struct debug_obj_descr	*descr_test  __read_mostly;
 
 static int __init enable_object_debug(char *str)
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 5f6c629..fa2dc4e 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -21,9 +21,12 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/swiotlb.h>
 #include <linux/string.h>
+#include <linux/swiotlb.h>
 #include <linux/types.h>
 #include <linux/ctype.h>
+#include <linux/highmem.h>
 
 #include <asm/io.h>
 #include <asm/dma.h>
@@ -36,22 +39,6 @@
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
-#define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(SG_ENT_VIRT_ADDRESS(sg))
-
-/*
- * Maximum allowable number of contiguous slabs to map,
- * must be a power of 2.  What is the appropriate value ?
- * The complexity of {map,unmap}_single is linearly dependent on this value.
- */
-#define IO_TLB_SEGSIZE	128
-
-/*
- * log of the size of each IO TLB slab.  The number of slabs is command line
- * controllable.
- */
-#define IO_TLB_SHIFT 11
-
 #define SLABS_PER_PAGE (1 << (PAGE_SHIFT - IO_TLB_SHIFT))
 
 /*
@@ -102,7 +89,10 @@ static unsigned int io_tlb_index;
  * We need to save away the original address corresponding to a mapped entry
  * for the sync operations.
  */
-static unsigned char **io_tlb_orig_addr;
+static struct swiotlb_phys_addr {
+	struct page *page;
+	unsigned int offset;
+} *io_tlb_orig_addr;
 
 /*
  * Protect the above data structures in the map and unmap calls
@@ -126,6 +116,72 @@ setup_io_tlb_npages(char *str)
 __setup("swiotlb=", setup_io_tlb_npages);
 /* make io_tlb_overflow tunable too? */
 
+void * __weak swiotlb_alloc_boot(size_t size, unsigned long nslabs)
+{
+	return alloc_bootmem_low_pages(size);
+}
+
+void * __weak swiotlb_alloc(unsigned order, unsigned long nslabs)
+{
+	return (void *)__get_free_pages(GFP_DMA | __GFP_NOWARN, order);
+}
+
+dma_addr_t __weak swiotlb_phys_to_bus(phys_addr_t paddr)
+{
+	return paddr;
+}
+
+phys_addr_t __weak swiotlb_bus_to_phys(dma_addr_t baddr)
+{
+	return baddr;
+}
+
+static dma_addr_t swiotlb_virt_to_bus(volatile void *address)
+{
+	return swiotlb_phys_to_bus(virt_to_phys(address));
+}
+
+static void *swiotlb_bus_to_virt(dma_addr_t address)
+{
+	return phys_to_virt(swiotlb_bus_to_phys(address));
+}
+
+int __weak swiotlb_arch_range_needs_mapping(void *ptr, size_t size)
+{
+	return 0;
+}
+
+static dma_addr_t swiotlb_sg_to_bus(struct scatterlist *sg)
+{
+	return swiotlb_phys_to_bus(page_to_phys(sg_page(sg)) + sg->offset);
+}
+
+static void swiotlb_print_info(unsigned long bytes)
+{
+	phys_addr_t pstart, pend;
+	dma_addr_t bstart, bend;
+
+	pstart = virt_to_phys(io_tlb_start);
+	pend = virt_to_phys(io_tlb_end);
+
+	bstart = swiotlb_phys_to_bus(pstart);
+	bend = swiotlb_phys_to_bus(pend);
+
+	printk(KERN_INFO "Placing %luMB software IO TLB between %p - %p\n",
+	       bytes >> 20, io_tlb_start, io_tlb_end);
+	if (pstart != bstart || pend != bend)
+		printk(KERN_INFO "software IO TLB at phys %#llx - %#llx"
+		       " bus %#llx - %#llx\n",
+		       (unsigned long long)pstart,
+		       (unsigned long long)pend,
+		       (unsigned long long)bstart,
+		       (unsigned long long)bend);
+	else
+		printk(KERN_INFO "software IO TLB at phys %#llx - %#llx\n",
+		       (unsigned long long)pstart,
+		       (unsigned long long)pend);
+}
+
 /*
  * Statically reserve bounce buffer space and initialize bounce buffer data
  * structures for the software IO TLB used to implement the DMA API.
@@ -145,7 +201,7 @@ swiotlb_init_with_default_size(size_t default_size)
 	/*
 	 * Get IO TLB memory from the low pages
 	 */
-	io_tlb_start = alloc_bootmem_low_pages(bytes);
+	io_tlb_start = swiotlb_alloc_boot(bytes, io_tlb_nslabs);
 	if (!io_tlb_start)
 		panic("Cannot allocate SWIOTLB buffer");
 	io_tlb_end = io_tlb_start + bytes;
@@ -159,7 +215,7 @@ swiotlb_init_with_default_size(size_t default_size)
 	for (i = 0; i < io_tlb_nslabs; i++)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
-	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(char *));
+	io_tlb_orig_addr = alloc_bootmem(io_tlb_nslabs * sizeof(struct swiotlb_phys_addr));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -168,8 +224,7 @@ swiotlb_init_with_default_size(size_t default_size)
 	if (!io_tlb_overflow_buffer)
 		panic("Cannot allocate SWIOTLB overflow buffer!\n");
 
-	printk(KERN_INFO "Placing software IO TLB between 0x%lx - 0x%lx\n",
-	       virt_to_bus(io_tlb_start), virt_to_bus(io_tlb_end));
+	swiotlb_print_info(bytes);
 }
 
 void __init
@@ -202,8 +257,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
-		io_tlb_start = (char *)__get_free_pages(GFP_DMA | __GFP_NOWARN,
-		                                        order);
+		io_tlb_start = swiotlb_alloc(order, io_tlb_nslabs);
 		if (io_tlb_start)
 			break;
 		order--;
@@ -235,12 +289,12 @@ swiotlb_late_init_with_default_size(size_t default_size)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
 
-	io_tlb_orig_addr = (unsigned char **)__get_free_pages(GFP_KERNEL,
-	                           get_order(io_tlb_nslabs * sizeof(char *)));
+	io_tlb_orig_addr = (struct swiotlb_phys_addr *)__get_free_pages(GFP_KERNEL,
+	                           get_order(io_tlb_nslabs * sizeof(struct swiotlb_phys_addr)));
 	if (!io_tlb_orig_addr)
 		goto cleanup3;
 
-	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(char *));
+	memset(io_tlb_orig_addr, 0, io_tlb_nslabs * sizeof(struct swiotlb_phys_addr));
 
 	/*
 	 * Get the overflow emergency buffer
@@ -250,9 +304,7 @@ swiotlb_late_init_with_default_size(size_t default_size)
 	if (!io_tlb_overflow_buffer)
 		goto cleanup4;
 
-	printk(KERN_INFO "Placing %luMB software IO TLB between 0x%lx - "
-	       "0x%lx\n", bytes >> 20,
-	       virt_to_bus(io_tlb_start), virt_to_bus(io_tlb_end));
+	swiotlb_print_info(bytes);
 
 	return 0;
 
@@ -279,16 +331,69 @@ address_needs_mapping(struct device *hwdev, dma_addr_t addr, size_t size)
 	return !is_buffer_dma_capable(dma_get_mask(hwdev), addr, size);
 }
 
+static inline int range_needs_mapping(void *ptr, size_t size)
+{
+	return swiotlb_force || swiotlb_arch_range_needs_mapping(ptr, size);
+}
+
 static int is_swiotlb_buffer(char *addr)
 {
 	return addr >= io_tlb_start && addr < io_tlb_end;
 }
 
+static struct swiotlb_phys_addr swiotlb_bus_to_phys_addr(char *dma_addr)
+{
+	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
+	struct swiotlb_phys_addr buffer = io_tlb_orig_addr[index];
+	buffer.offset += (long)dma_addr & ((1 << IO_TLB_SHIFT) - 1);
+	buffer.page += buffer.offset >> PAGE_SHIFT;
+	buffer.offset &= PAGE_SIZE - 1;
+	return buffer;
+}
+
+static void
+__sync_single(struct swiotlb_phys_addr buffer, char *dma_addr, size_t size, int dir)
+{
+	if (PageHighMem(buffer.page)) {
+		size_t len, bytes;
+		char *dev, *host, *kmp;
+
+		len = size;
+		while (len != 0) {
+			unsigned long flags;
+
+			bytes = len;
+			if ((bytes + buffer.offset) > PAGE_SIZE)
+				bytes = PAGE_SIZE - buffer.offset;
+			local_irq_save(flags); /* protects KM_BOUNCE_READ */
+			kmp  = kmap_atomic(buffer.page, KM_BOUNCE_READ);
+			dev  = dma_addr + size - len;
+			host = kmp + buffer.offset;
+			if (dir == DMA_FROM_DEVICE)
+				memcpy(host, dev, bytes);
+			else
+				memcpy(dev, host, bytes);
+			kunmap_atomic(kmp, KM_BOUNCE_READ);
+			local_irq_restore(flags);
+			len -= bytes;
+			buffer.page++;
+			buffer.offset = 0;
+		}
+	} else {
+		void *v = page_address(buffer.page) + buffer.offset;
+
+		if (dir == DMA_TO_DEVICE)
+			memcpy(dma_addr, v, size);
+		else
+			memcpy(v, dma_addr, size);
+	}
+}
+
 /*
  * Allocates bounce buffer and returns its kernel virtual address.
  */
 static void *
-map_single(struct device *hwdev, char *buffer, size_t size, int dir)
+map_single(struct device *hwdev, struct swiotlb_phys_addr buffer, size_t size, int dir)
 {
 	unsigned long flags;
 	char *dma_addr;
@@ -298,11 +403,16 @@ map_single(struct device *hwdev, char *buffer, size_t size, int dir)
 	unsigned long mask;
 	unsigned long offset_slots;
 	unsigned long max_slots;
+	struct swiotlb_phys_addr slot_buf;
 
 	mask = dma_get_seg_boundary(hwdev);
-	start_dma_addr = virt_to_bus(io_tlb_start) & mask;
+	start_dma_addr = swiotlb_virt_to_bus(io_tlb_start) & mask;
 
 	offset_slots = ALIGN(start_dma_addr, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
+
+	/*
+ 	 * Carefully handle integer overflow which can occur when mask == ~0UL.
+ 	 */
 	max_slots = mask + 1
 		    ? ALIGN(mask + 1, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT
 		    : 1UL << (BITS_PER_LONG - IO_TLB_SHIFT);
@@ -378,10 +488,15 @@ found:
 	 * This is needed when we sync the memory.  Then we sync the buffer if
 	 * needed.
 	 */
-	for (i = 0; i < nslots; i++)
-		io_tlb_orig_addr[index+i] = buffer + (i << IO_TLB_SHIFT);
+	slot_buf = buffer;
+	for (i = 0; i < nslots; i++) {
+		slot_buf.page += slot_buf.offset >> PAGE_SHIFT;
+		slot_buf.offset &= PAGE_SIZE - 1;
+		io_tlb_orig_addr[index+i] = slot_buf;
+		slot_buf.offset += 1 << IO_TLB_SHIFT;
+	}
 	if (dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL)
-		memcpy(dma_addr, buffer, size);
+		__sync_single(buffer, dma_addr, size, DMA_TO_DEVICE);
 
 	return dma_addr;
 }
@@ -395,17 +510,17 @@ unmap_single(struct device *hwdev, char *dma_addr, size_t size, int dir)
 	unsigned long flags;
 	int i, count, nslots = ALIGN(size, 1 << IO_TLB_SHIFT) >> IO_TLB_SHIFT;
 	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	char *buffer = io_tlb_orig_addr[index];
+	struct swiotlb_phys_addr buffer = swiotlb_bus_to_phys_addr(dma_addr);
 
 	/*
 	 * First, sync the memory before unmapping the entry
 	 */
-	if (buffer && ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL)))
+	if ((dir == DMA_FROM_DEVICE) || (dir == DMA_BIDIRECTIONAL))
 		/*
 		 * bounce... copy the data back into the original buffer * and
 		 * delete the bounce buffer.
 		 */
-		memcpy(buffer, dma_addr, size);
+		__sync_single(buffer, dma_addr, size, DMA_FROM_DEVICE);
 
 	/*
 	 * Return the buffer to the free list by setting the corresponding
@@ -437,21 +552,18 @@ static void
 sync_single(struct device *hwdev, char *dma_addr, size_t size,
 	    int dir, int target)
 {
-	int index = (dma_addr - io_tlb_start) >> IO_TLB_SHIFT;
-	char *buffer = io_tlb_orig_addr[index];
-
-	buffer += ((unsigned long)dma_addr & ((1 << IO_TLB_SHIFT) - 1));
+	struct swiotlb_phys_addr buffer = swiotlb_bus_to_phys_addr(dma_addr);
 
 	switch (target) {
 	case SYNC_FOR_CPU:
 		if (likely(dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL))
-			memcpy(buffer, dma_addr, size);
+			__sync_single(buffer, dma_addr, size, DMA_FROM_DEVICE);
 		else
 			BUG_ON(dir != DMA_TO_DEVICE);
 		break;
 	case SYNC_FOR_DEVICE:
 		if (likely(dir == DMA_TO_DEVICE || dir == DMA_BIDIRECTIONAL))
-			memcpy(dma_addr, buffer, size);
+			__sync_single(buffer, dma_addr, size, DMA_TO_DEVICE);
 		else
 			BUG_ON(dir != DMA_FROM_DEVICE);
 		break;
@@ -473,7 +585,7 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		dma_mask = hwdev->coherent_dma_mask;
 
 	ret = (void *)__get_free_pages(flags, order);
-	if (ret && !is_buffer_dma_capable(dma_mask, virt_to_bus(ret), size)) {
+	if (ret && !is_buffer_dma_capable(dma_mask, swiotlb_virt_to_bus(ret), size)) {
 		/*
 		 * The allocated memory isn't reachable by the device.
 		 * Fall back on swiotlb_map_single().
@@ -488,13 +600,16 @@ swiotlb_alloc_coherent(struct device *hwdev, size_t size,
 		 * swiotlb_map_single(), which will grab memory from
 		 * the lowest available address range.
 		 */
-		ret = map_single(hwdev, NULL, size, DMA_FROM_DEVICE);
+		struct swiotlb_phys_addr buffer;
+		buffer.page = virt_to_page(NULL);
+		buffer.offset = 0;
+		ret = map_single(hwdev, buffer, size, DMA_FROM_DEVICE);
 		if (!ret)
 			return NULL;
 	}
 
 	memset(ret, 0, size);
-	dev_addr = virt_to_bus(ret);
+	dev_addr = swiotlb_virt_to_bus(ret);
 
 	/* Confirm address can be DMA'd by device */
 	if (!is_buffer_dma_capable(dma_mask, dev_addr, size)) {
@@ -554,8 +669,9 @@ dma_addr_t
 swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 			 int dir, struct dma_attrs *attrs)
 {
-	dma_addr_t dev_addr = virt_to_bus(ptr);
+	dma_addr_t dev_addr = swiotlb_virt_to_bus(ptr);
 	void *map;
+	struct swiotlb_phys_addr buffer;
 
 	BUG_ON(dir == DMA_NONE);
 	/*
@@ -563,19 +679,22 @@ swiotlb_map_single_attrs(struct device *hwdev, void *ptr, size_t size,
 	 * we can safely return the device addr and not worry about bounce
 	 * buffering it.
 	 */
-	if (!address_needs_mapping(hwdev, dev_addr, size) && !swiotlb_force)
+	if (!address_needs_mapping(hwdev, dev_addr, size) &&
+	    !range_needs_mapping(ptr, size))
 		return dev_addr;
 
 	/*
 	 * Oh well, have to allocate and map a bounce buffer.
 	 */
-	map = map_single(hwdev, ptr, size, dir);
+	buffer.page   = virt_to_page(ptr);
+	buffer.offset = (unsigned long)ptr & ~PAGE_MASK;
+	map = map_single(hwdev, buffer, size, dir);
 	if (!map) {
 		swiotlb_full(hwdev, size, dir, 1);
 		map = io_tlb_overflow_buffer;
 	}
 
-	dev_addr = virt_to_bus(map);
+	dev_addr = swiotlb_virt_to_bus(map);
 
 	/*
 	 * Ensure that the address returned is DMA'ble
@@ -605,7 +724,7 @@ void
 swiotlb_unmap_single_attrs(struct device *hwdev, dma_addr_t dev_addr,
 			   size_t size, int dir, struct dma_attrs *attrs)
 {
-	char *dma_addr = bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -635,7 +754,7 @@ static void
 swiotlb_sync_single(struct device *hwdev, dma_addr_t dev_addr,
 		    size_t size, int dir, int target)
 {
-	char *dma_addr = bus_to_virt(dev_addr);
+	char *dma_addr = swiotlb_bus_to_virt(dev_addr);
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -666,7 +785,7 @@ swiotlb_sync_single_range(struct device *hwdev, dma_addr_t dev_addr,
 			  unsigned long offset, size_t size,
 			  int dir, int target)
 {
-	char *dma_addr = bus_to_virt(dev_addr) + offset;
+	char *dma_addr = swiotlb_bus_to_virt(dev_addr) + offset;
 
 	BUG_ON(dir == DMA_NONE);
 	if (is_swiotlb_buffer(dma_addr))
@@ -714,18 +833,20 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 		     int dir, struct dma_attrs *attrs)
 {
 	struct scatterlist *sg;
-	void *addr;
+	struct swiotlb_phys_addr buffer;
 	dma_addr_t dev_addr;
 	int i;
 
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		addr = SG_ENT_VIRT_ADDRESS(sg);
-		dev_addr = virt_to_bus(addr);
-		if (swiotlb_force ||
+		dev_addr = swiotlb_sg_to_bus(sg);
+		if (range_needs_mapping(sg_virt(sg), sg->length) ||
 		    address_needs_mapping(hwdev, dev_addr, sg->length)) {
-			void *map = map_single(hwdev, addr, sg->length, dir);
+			void *map;
+			buffer.page   = sg_page(sg);
+			buffer.offset = sg->offset;
+			map = map_single(hwdev, buffer, sg->length, dir);
 			if (!map) {
 				/* Don't panic here, we expect map_sg users
 				   to do proper error handling. */
@@ -735,7 +856,7 @@ swiotlb_map_sg_attrs(struct device *hwdev, struct scatterlist *sgl, int nelems,
 				sgl[0].dma_length = 0;
 				return 0;
 			}
-			sg->dma_address = virt_to_bus(map);
+			sg->dma_address = swiotlb_virt_to_bus(map);
 		} else
 			sg->dma_address = dev_addr;
 		sg->dma_length = sg->length;
@@ -765,11 +886,11 @@ swiotlb_unmap_sg_attrs(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			unmap_single(hwdev, bus_to_virt(sg->dma_address),
+		if (sg->dma_address != swiotlb_sg_to_bus(sg))
+			unmap_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				     sg->dma_length, dir);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
+			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
 	}
 }
 EXPORT_SYMBOL(swiotlb_unmap_sg_attrs);
@@ -798,11 +919,11 @@ swiotlb_sync_sg(struct device *hwdev, struct scatterlist *sgl,
 	BUG_ON(dir == DMA_NONE);
 
 	for_each_sg(sgl, sg, nelems, i) {
-		if (sg->dma_address != SG_ENT_PHYS_ADDRESS(sg))
-			sync_single(hwdev, bus_to_virt(sg->dma_address),
+		if (sg->dma_address != swiotlb_sg_to_bus(sg))
+			sync_single(hwdev, swiotlb_bus_to_virt(sg->dma_address),
 				    sg->dma_length, dir, target);
 		else if (dir == DMA_FROM_DEVICE)
-			dma_mark_clean(SG_ENT_VIRT_ADDRESS(sg), sg->dma_length);
+			dma_mark_clean(swiotlb_bus_to_virt(sg->dma_address), sg->dma_length);
 	}
 }
 
@@ -823,7 +944,7 @@ swiotlb_sync_sg_for_device(struct device *hwdev, struct scatterlist *sg,
 int
 swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 {
-	return (dma_addr == virt_to_bus(io_tlb_overflow_buffer));
+	return (dma_addr == swiotlb_virt_to_bus(io_tlb_overflow_buffer));
 }
 
 /*
@@ -835,7 +956,7 @@ swiotlb_dma_mapping_error(struct device *hwdev, dma_addr_t dma_addr)
 int
 swiotlb_dma_supported(struct device *hwdev, u64 mask)
 {
-	return virt_to_bus(io_tlb_end - 1) <= mask;
+	return swiotlb_virt_to_bus(io_tlb_end - 1) <= mask;
 }
 
 EXPORT_SYMBOL(swiotlb_map_single);
diff --git a/mm/memory.c b/mm/memory.c
index 164951c..fc031d6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3049,3 +3049,18 @@ void print_vma_addr(char *prefix, unsigned long ip)
 	}
 	up_read(&current->mm->mmap_sem);
 }
+
+#ifdef CONFIG_PROVE_LOCKING
+void might_fault(void)
+{
+	might_sleep();
+	/*
+	 * it would be nicer only to annotate paths which are not under
+	 * pagefault_disable, however that requires a larger audit and
+	 * providing helpers like get_user_atomic.
+	 */
+	if (!in_atomic() && current->mm)
+		might_lock_read(&current->mm->mmap_sem);
+}
+EXPORT_SYMBOL(might_fault);
+#endif
