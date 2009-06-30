Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbZF3XCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbZF3XCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759924AbZF3XCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:02:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36132 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759942AbZF3XC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:02:28 -0400
Date: Wed, 1 Jul 2009 01:02:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [RFC GIT PULL] perfcounters updates
Message-ID: <20090630230213.GA8018@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

Would you still be willing to pull the latest perfcounters git tree? 
It is at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

I kept the tree strictly within perfcounter file boundaries, so it 
shouldnt affect anything else - and perfcounters is a new subsystem 
so this shouldnt cause regressions.

The scope and size of the changes is beyond what we'd allow for a 
pre-existing subsystem, hence the RFC. There's a lot of interest, 
feedback, fixes and activities so it would be nice to have this 
upstream. All additions to the syscall are ABI compatible, as usual.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (4):
      perf_counter tools: Adjust only prelinked symbol's addresses
      perf report: Add --dsos parameter
      perf report: Add --comms parameter
      perf report: Add --symbols parameter

Frederic Weisbecker (3):
      perf record: Fix unhandled io return value
      perf_counter tools: Prepare a small callchain framework
      perf report: Print sorted callchains per histogram entries

Ingo Molnar (7):
      perf_counter tools: Fix vmlinux fallback when running on a different kernel
      perf report: Fix help text typo
      perf_counter tools: Add CREDITS file for Git contributors
      perf_counter tools: Remove dead code
      perf stat: Add -n/--null option to run without counters
      perf stat: Fix multi-run stats
      perf stat: Use percentages for scaling output

Jaswinder Singh Rajput (12):
      perf_counter, x8: Fix L1-data-Cache-Store-Referencees for AMD
      perf_counter tools: Define separate declarations for H/W and S/W events
      perf_counter tools: Introduce alias member in event_symbol
      perf_counter tools: Set alias for page-faults
      perf stat: Fix command option / manpage
      perf stat: Fix verbose for perf stat
      perf stat: Remove dead code
      perf_counter tools: Check for valid cache operations
      perf_counter tools: Shorten names for events
      perf_counter tools: Add alias for 'l1d' and 'l1i'
      perf stat: Improve output
      perf stat: Micro-optimize the code: memcpy is only required if no event is selected and !null_run

Johannes Weiner (1):
      perf record: Fix filemap pathname parsing in /proc/pid/maps

Paul Mackerras (2):
      perf_counter tools: Reduce perf stat measurement overhead/skew
      perf_counter: Provide a way to enable counters on exec

Peter Zijlstra (15):
      perf report: Output more symbol related debug data
      perf_counter tools: Handle overlapping MMAP events
      perf_counter: Optimize perf_swcounter_event()
      perf_counter: Push inherit into perf_counter_alloc()
      perf_counter: Optimize perf_counter_alloc()'s inherit case
      perf_counter tools: Rework the file format
      perf_counter: Split the mmap control page in two parts
      perf_counter: Add scale information to the mmap control page
      perf_counter, x86: Add mmap counter read support
      perf_counter: Add PERF_EVENT_READ
      perf_counter: Implement more accurate per task statistics
      perf_counter: Rework the sample ABI
      perf-report: Add modes for inherited stats and no-samples
      perf-report: Add bare minimum PERF_EVENT_READ parsing
      perf_counter: Complete counter swap

Roel Kluin (1):
      perf_counter tools: Fix strbuf_fread() error path handling

Yinghai Lu (1):
      perf_counter, x86: Update x86_pmu after WARN()

Yong Wang (1):
      perf_counter, x86: Set global control MSR correctly


 arch/powerpc/include/asm/perf_counter.h  |    2 +
 arch/x86/include/asm/perf_counter.h      |    3 +
 arch/x86/kernel/cpu/perf_counter.c       |   22 +--
 include/linux/perf_counter.h             |   46 ++++-
 kernel/perf_counter.c                    |  320 +++++++++++++++++++++++++-----
 tools/perf/CREDITS                       |   30 +++
 tools/perf/Documentation/perf-report.txt |   14 ++-
 tools/perf/Documentation/perf-stat.txt   |    6 +-
 tools/perf/Makefile                      |    6 +-
 tools/perf/builtin-annotate.c            |    8 +-
 tools/perf/builtin-record.c              |  127 ++++++++----
 tools/perf/builtin-report.c              |  236 ++++++++++++++++++----
 tools/perf/builtin-stat.c                |  171 ++++++++++-------
 tools/perf/builtin-top.c                 |   11 +-
 tools/perf/perf.h                        |    9 +-
 tools/perf/util/callchain.c              |  174 ++++++++++++++++
 tools/perf/util/callchain.h              |   33 +++
 tools/perf/util/header.c                 |  242 ++++++++++++++++++++++
 tools/perf/util/header.h                 |   37 ++++
 tools/perf/util/help.c                   |   15 --
 tools/perf/util/pager.c                  |    5 +-
 tools/perf/util/parse-events.c           |  153 ++++++++++-----
 tools/perf/util/run-command.c            |   95 +---------
 tools/perf/util/run-command.h            |    5 -
 tools/perf/util/strbuf.c                 |    2 +-
 tools/perf/util/string.h                 |    2 +-
 tools/perf/util/strlist.c                |  184 +++++++++++++++++
 tools/perf/util/strlist.h                |   32 +++
 tools/perf/util/symbol.c                 |   16 ++-
 tools/perf/util/symbol.h                 |    5 +-
 tools/perf/{ => util}/types.h            |    0
 tools/perf/util/util.h                   |   15 --
 32 files changed, 1604 insertions(+), 422 deletions(-)
 create mode 100644 tools/perf/CREDITS
 create mode 100644 tools/perf/util/callchain.c
 create mode 100644 tools/perf/util/callchain.h
 create mode 100644 tools/perf/util/header.c
 create mode 100644 tools/perf/util/header.h
 create mode 100644 tools/perf/util/strlist.c
 create mode 100644 tools/perf/util/strlist.h
 rename tools/perf/{ => util}/types.h (100%)

diff --git a/arch/powerpc/include/asm/perf_counter.h b/arch/powerpc/include/asm/perf_counter.h
index 8ccd4e1..0ea0639 100644
--- a/arch/powerpc/include/asm/perf_counter.h
+++ b/arch/powerpc/include/asm/perf_counter.h
@@ -61,6 +61,8 @@ struct pt_regs;
 extern unsigned long perf_misc_flags(struct pt_regs *regs);
 extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
 
+#define PERF_COUNTER_INDEX_OFFSET	1
+
 /*
  * Only override the default definitions in include/linux/perf_counter.h
  * if we have hardware PMU support.
diff --git a/arch/x86/include/asm/perf_counter.h b/arch/x86/include/asm/perf_counter.h
index 5fb33e1..fa64e40 100644
--- a/arch/x86/include/asm/perf_counter.h
+++ b/arch/x86/include/asm/perf_counter.h
@@ -87,6 +87,9 @@ union cpuid10_edx {
 #ifdef CONFIG_PERF_COUNTERS
 extern void init_hw_perf_counters(void);
 extern void perf_counters_lapic_init(void);
+
+#define PERF_COUNTER_INDEX_OFFSET			0
+
 #else
 static inline void init_hw_perf_counters(void)		{ }
 static inline void perf_counters_lapic_init(void)	{ }
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 76dfef2..d4cf4ce 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -401,7 +401,7 @@ static const u64 amd_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = 0x0041, /* Data Cache Misses          */
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = 0x0042, /* Data Cache Refills from L2 */
+		[ C(RESULT_ACCESS) ] = 0x0142, /* Data Cache Refills :system */
 		[ C(RESULT_MISS)   ] = 0,
 	},
 	[ C(OP_PREFETCH) ] = {
@@ -912,6 +912,8 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 	err = checking_wrmsrl(hwc->counter_base + idx,
 			     (u64)(-left) & x86_pmu.counter_mask);
 
+	perf_counter_update_userpage(counter);
+
 	return ret;
 }
 
@@ -969,13 +971,6 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 	if (!x86_pmu.num_counters_fixed)
 		return -1;
 
-	/*
-	 * Quirk, IA32_FIXED_CTRs do not work on current Atom processors:
-	 */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL &&
-					boot_cpu_data.x86_model == 28)
-		return -1;
-
 	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
 
 	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_INSTRUCTIONS)))
@@ -1041,6 +1036,8 @@ try_generic:
 	x86_perf_counter_set_period(counter, hwc, idx);
 	x86_pmu.enable(hwc, idx);
 
+	perf_counter_update_userpage(counter);
+
 	return 0;
 }
 
@@ -1133,6 +1130,8 @@ static void x86_pmu_disable(struct perf_counter *counter)
 	x86_perf_counter_update(counter, hwc, idx);
 	cpuc->counters[idx] = NULL;
 	clear_bit(idx, cpuc->used_mask);
+
+	perf_counter_update_userpage(counter);
 }
 
 /*
@@ -1428,8 +1427,6 @@ static int intel_pmu_init(void)
 	 */
 	x86_pmu.num_counters_fixed	= max((int)edx.split.num_counters_fixed, 3);
 
-	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, x86_pmu.intel_ctrl);
-
 	/*
 	 * Install the hw-cache-events table:
 	 */
@@ -1499,21 +1496,22 @@ void __init init_hw_perf_counters(void)
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
 	if (x86_pmu.num_counters > X86_PMC_MAX_GENERIC) {
-		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
 		WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
 		     x86_pmu.num_counters, X86_PMC_MAX_GENERIC);
+		x86_pmu.num_counters = X86_PMC_MAX_GENERIC;
 	}
 	perf_counter_mask = (1 << x86_pmu.num_counters) - 1;
 	perf_max_counters = x86_pmu.num_counters;
 
 	if (x86_pmu.num_counters_fixed > X86_PMC_MAX_FIXED) {
-		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
 		WARN(1, KERN_ERR "hw perf counters fixed %d > max(%d), clipping!",
 		     x86_pmu.num_counters_fixed, X86_PMC_MAX_FIXED);
+		x86_pmu.num_counters_fixed = X86_PMC_MAX_FIXED;
 	}
 
 	perf_counter_mask |=
 		((1LL << x86_pmu.num_counters_fixed)-1) << X86_PMC_IDX_FIXED;
+	x86_pmu.intel_ctrl = perf_counter_mask;
 
 	perf_counters_lapic_init();
 	register_die_notifier(&perf_counter_nmi_notifier);
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 89698d8..5e970c7 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -178,8 +178,10 @@ struct perf_counter_attr {
 				mmap           :  1, /* include mmap data     */
 				comm	       :  1, /* include comm data     */
 				freq           :  1, /* use freq, not period  */
+				inherit_stat   :  1, /* per task counts       */
+				enable_on_exec :  1, /* next exec enables     */
 
-				__reserved_1   : 53;
+				__reserved_1   : 51;
 
 	__u32			wakeup_events;	/* wakeup every n events */
 	__u32			__reserved_2;
@@ -232,6 +234,14 @@ struct perf_counter_mmap_page {
 	__u32	lock;			/* seqlock for synchronization */
 	__u32	index;			/* hardware counter identifier */
 	__s64	offset;			/* add to hardware counter value */
+	__u64	time_enabled;		/* time counter active */
+	__u64	time_running;		/* time counter on cpu */
+
+		/*
+		 * Hole for extension of the self monitor capabilities
+		 */
+
+	__u64	__reserved[123];	/* align to 1k */
 
 	/*
 	 * Control data for the mmap() data buffer.
@@ -253,7 +263,6 @@ struct perf_counter_mmap_page {
 #define PERF_EVENT_MISC_KERNEL			(1 << 0)
 #define PERF_EVENT_MISC_USER			(2 << 0)
 #define PERF_EVENT_MISC_HYPERVISOR		(3 << 0)
-#define PERF_EVENT_MISC_OVERFLOW		(1 << 2)
 
 struct perf_event_header {
 	__u32	type;
@@ -327,9 +336,18 @@ enum perf_event_type {
 	PERF_EVENT_FORK			= 7,
 
 	/*
-	 * When header.misc & PERF_EVENT_MISC_OVERFLOW the event_type field
-	 * will be PERF_SAMPLE_*
-	 *
+	 * struct {
+	 * 	struct perf_event_header	header;
+	 * 	u32				pid, tid;
+	 * 	u64				value;
+	 * 	{ u64		time_enabled; 	} && PERF_FORMAT_ENABLED
+	 * 	{ u64		time_running; 	} && PERF_FORMAT_RUNNING
+	 * 	{ u64		parent_id;	} && PERF_FORMAT_ID
+	 * };
+	 */
+	PERF_EVENT_READ			= 8,
+
+	/*
 	 * struct {
 	 *	struct perf_event_header	header;
 	 *
@@ -337,8 +355,9 @@ enum perf_event_type {
 	 *	{ u32			pid, tid; } && PERF_SAMPLE_TID
 	 *	{ u64			time;     } && PERF_SAMPLE_TIME
 	 *	{ u64			addr;     } && PERF_SAMPLE_ADDR
-	 *	{ u64			config;   } && PERF_SAMPLE_CONFIG
+	 *	{ u64			id;	  } && PERF_SAMPLE_ID
 	 *	{ u32			cpu, res; } && PERF_SAMPLE_CPU
+	 * 	{ u64			period;   } && PERF_SAMPLE_PERIOD
 	 *
 	 *	{ u64			nr;
 	 *	  { u64 id, val; }	cnt[nr];  } && PERF_SAMPLE_GROUP
@@ -347,6 +366,9 @@ enum perf_event_type {
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
 	 * };
 	 */
+	PERF_EVENT_SAMPLE		= 9,
+
+	PERF_EVENT_MAX,			/* non-ABI */
 };
 
 enum perf_callchain_context {
@@ -582,6 +604,7 @@ struct perf_counter_context {
 	int				nr_counters;
 	int				nr_active;
 	int				is_active;
+	int				nr_stat;
 	atomic_t			refcount;
 	struct task_struct		*task;
 
@@ -669,7 +692,16 @@ static inline int is_software_counter(struct perf_counter *counter)
 		(counter->attr.type != PERF_TYPE_HW_CACHE);
 }
 
-extern void perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
+extern atomic_t perf_swcounter_enabled[PERF_COUNT_SW_MAX];
+
+extern void __perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
+
+static inline void
+perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
+{
+	if (atomic_read(&perf_swcounter_enabled[event]))
+		__perf_swcounter_event(event, nr, nmi, regs, addr);
+}
 
 extern void __perf_counter_mmap(struct vm_area_struct *vma);
 
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 1a933a2..d55a50d 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -236,6 +236,8 @@ list_add_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 
 	list_add_rcu(&counter->event_entry, &ctx->event_list);
 	ctx->nr_counters++;
+	if (counter->attr.inherit_stat)
+		ctx->nr_stat++;
 }
 
 /*
@@ -250,6 +252,8 @@ list_del_counter(struct perf_counter *counter, struct perf_counter_context *ctx)
 	if (list_empty(&counter->list_entry))
 		return;
 	ctx->nr_counters--;
+	if (counter->attr.inherit_stat)
+		ctx->nr_stat--;
 
 	list_del_init(&counter->list_entry);
 	list_del_rcu(&counter->event_entry);
@@ -1006,6 +1010,81 @@ static int context_equiv(struct perf_counter_context *ctx1,
 		&& !ctx1->pin_count && !ctx2->pin_count;
 }
 
+static void __perf_counter_read(void *counter);
+
+static void __perf_counter_sync_stat(struct perf_counter *counter,
+				     struct perf_counter *next_counter)
+{
+	u64 value;
+
+	if (!counter->attr.inherit_stat)
+		return;
+
+	/*
+	 * Update the counter value, we cannot use perf_counter_read()
+	 * because we're in the middle of a context switch and have IRQs
+	 * disabled, which upsets smp_call_function_single(), however
+	 * we know the counter must be on the current CPU, therefore we
+	 * don't need to use it.
+	 */
+	switch (counter->state) {
+	case PERF_COUNTER_STATE_ACTIVE:
+		__perf_counter_read(counter);
+		break;
+
+	case PERF_COUNTER_STATE_INACTIVE:
+		update_counter_times(counter);
+		break;
+
+	default:
+		break;
+	}
+
+	/*
+	 * In order to keep per-task stats reliable we need to flip the counter
+	 * values when we flip the contexts.
+	 */
+	value = atomic64_read(&next_counter->count);
+	value = atomic64_xchg(&counter->count, value);
+	atomic64_set(&next_counter->count, value);
+
+	swap(counter->total_time_enabled, next_counter->total_time_enabled);
+	swap(counter->total_time_running, next_counter->total_time_running);
+
+	/*
+	 * Since we swizzled the values, update the user visible data too.
+	 */
+	perf_counter_update_userpage(counter);
+	perf_counter_update_userpage(next_counter);
+}
+
+#define list_next_entry(pos, member) \
+	list_entry(pos->member.next, typeof(*pos), member)
+
+static void perf_counter_sync_stat(struct perf_counter_context *ctx,
+				   struct perf_counter_context *next_ctx)
+{
+	struct perf_counter *counter, *next_counter;
+
+	if (!ctx->nr_stat)
+		return;
+
+	counter = list_first_entry(&ctx->event_list,
+				   struct perf_counter, event_entry);
+
+	next_counter = list_first_entry(&next_ctx->event_list,
+					struct perf_counter, event_entry);
+
+	while (&counter->event_entry != &ctx->event_list &&
+	       &next_counter->event_entry != &next_ctx->event_list) {
+
+		__perf_counter_sync_stat(counter, next_counter);
+
+		counter = list_next_entry(counter, event_entry);
+		next_counter = list_next_entry(counter, event_entry);
+	}
+}
+
 /*
  * Called from scheduler to remove the counters of the current task,
  * with interrupts disabled.
@@ -1061,6 +1140,8 @@ void perf_counter_task_sched_out(struct task_struct *task,
 			ctx->task = next;
 			next_ctx->task = task;
 			do_switch = 0;
+
+			perf_counter_sync_stat(ctx, next_ctx);
 		}
 		spin_unlock(&next_ctx->lock);
 		spin_unlock(&ctx->lock);
@@ -1348,9 +1429,56 @@ void perf_counter_task_tick(struct task_struct *curr, int cpu)
 }
 
 /*
+ * Enable all of a task's counters that have been marked enable-on-exec.
+ * This expects task == current.
+ */
+static void perf_counter_enable_on_exec(struct task_struct *task)
+{
+	struct perf_counter_context *ctx;
+	struct perf_counter *counter;
+	unsigned long flags;
+	int enabled = 0;
+
+	local_irq_save(flags);
+	ctx = task->perf_counter_ctxp;
+	if (!ctx || !ctx->nr_counters)
+		goto out;
+
+	__perf_counter_task_sched_out(ctx);
+
+	spin_lock(&ctx->lock);
+
+	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
+		if (!counter->attr.enable_on_exec)
+			continue;
+		counter->attr.enable_on_exec = 0;
+		if (counter->state >= PERF_COUNTER_STATE_INACTIVE)
+			continue;
+		counter->state = PERF_COUNTER_STATE_INACTIVE;
+		counter->tstamp_enabled =
+			ctx->time - counter->total_time_enabled;
+		enabled = 1;
+	}
+
+	/*
+	 * Unclone this context if we enabled any counter.
+	 */
+	if (enabled && ctx->parent_ctx) {
+		put_ctx(ctx->parent_ctx);
+		ctx->parent_ctx = NULL;
+	}
+
+	spin_unlock(&ctx->lock);
+
+	perf_counter_task_sched_in(task, smp_processor_id());
+ out:
+	local_irq_restore(flags);
+}
+
+/*
  * Cross CPU call to read the hardware counter
  */
-static void __read(void *info)
+static void __perf_counter_read(void *info)
 {
 	struct perf_counter *counter = info;
 	struct perf_counter_context *ctx = counter->ctx;
@@ -1372,7 +1500,7 @@ static u64 perf_counter_read(struct perf_counter *counter)
 	 */
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE) {
 		smp_call_function_single(counter->oncpu,
-					 __read, counter, 1);
+					 __perf_counter_read, counter, 1);
 	} else if (counter->state == PERF_COUNTER_STATE_INACTIVE) {
 		update_counter_times(counter);
 	}
@@ -1508,11 +1636,13 @@ static void free_counter(struct perf_counter *counter)
 {
 	perf_pending_sync(counter);
 
-	atomic_dec(&nr_counters);
-	if (counter->attr.mmap)
-		atomic_dec(&nr_mmap_counters);
-	if (counter->attr.comm)
-		atomic_dec(&nr_comm_counters);
+	if (!counter->parent) {
+		atomic_dec(&nr_counters);
+		if (counter->attr.mmap)
+			atomic_dec(&nr_mmap_counters);
+		if (counter->attr.comm)
+			atomic_dec(&nr_comm_counters);
+	}
 
 	if (counter->destroy)
 		counter->destroy(counter);
@@ -1751,6 +1881,14 @@ int perf_counter_task_disable(void)
 	return 0;
 }
 
+static int perf_counter_index(struct perf_counter *counter)
+{
+	if (counter->state != PERF_COUNTER_STATE_ACTIVE)
+		return 0;
+
+	return counter->hw.idx + 1 - PERF_COUNTER_INDEX_OFFSET;
+}
+
 /*
  * Callers need to ensure there can be no nesting of this function, otherwise
  * the seqlock logic goes bad. We can not serialize this because the arch
@@ -1775,11 +1913,17 @@ void perf_counter_update_userpage(struct perf_counter *counter)
 	preempt_disable();
 	++userpg->lock;
 	barrier();
-	userpg->index = counter->hw.idx;
+	userpg->index = perf_counter_index(counter);
 	userpg->offset = atomic64_read(&counter->count);
 	if (counter->state == PERF_COUNTER_STATE_ACTIVE)
 		userpg->offset -= atomic64_read(&counter->hw.prev_count);
 
+	userpg->time_enabled = counter->total_time_enabled +
+			atomic64_read(&counter->child_total_time_enabled);
+
+	userpg->time_running = counter->total_time_running +
+			atomic64_read(&counter->child_total_time_running);
+
 	barrier();
 	++userpg->lock;
 	preempt_enable();
@@ -2483,15 +2627,14 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		u32 cpu, reserved;
 	} cpu_entry;
 
-	header.type = 0;
+	header.type = PERF_EVENT_SAMPLE;
 	header.size = sizeof(header);
 
-	header.misc = PERF_EVENT_MISC_OVERFLOW;
+	header.misc = 0;
 	header.misc |= perf_misc_flags(data->regs);
 
 	if (sample_type & PERF_SAMPLE_IP) {
 		ip = perf_instruction_pointer(data->regs);
-		header.type |= PERF_SAMPLE_IP;
 		header.size += sizeof(ip);
 	}
 
@@ -2500,7 +2643,6 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		tid_entry.pid = perf_counter_pid(counter, current);
 		tid_entry.tid = perf_counter_tid(counter, current);
 
-		header.type |= PERF_SAMPLE_TID;
 		header.size += sizeof(tid_entry);
 	}
 
@@ -2510,34 +2652,25 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		 */
 		time = sched_clock();
 
-		header.type |= PERF_SAMPLE_TIME;
 		header.size += sizeof(u64);
 	}
 
-	if (sample_type & PERF_SAMPLE_ADDR) {
-		header.type |= PERF_SAMPLE_ADDR;
+	if (sample_type & PERF_SAMPLE_ADDR)
 		header.size += sizeof(u64);
-	}
 
-	if (sample_type & PERF_SAMPLE_ID) {
-		header.type |= PERF_SAMPLE_ID;
+	if (sample_type & PERF_SAMPLE_ID)
 		header.size += sizeof(u64);
-	}
 
 	if (sample_type & PERF_SAMPLE_CPU) {
-		header.type |= PERF_SAMPLE_CPU;
 		header.size += sizeof(cpu_entry);
 
 		cpu_entry.cpu = raw_smp_processor_id();
 	}
 
-	if (sample_type & PERF_SAMPLE_PERIOD) {
-		header.type |= PERF_SAMPLE_PERIOD;
+	if (sample_type & PERF_SAMPLE_PERIOD)
 		header.size += sizeof(u64);
-	}
 
 	if (sample_type & PERF_SAMPLE_GROUP) {
-		header.type |= PERF_SAMPLE_GROUP;
 		header.size += sizeof(u64) +
 			counter->nr_siblings * sizeof(group_entry);
 	}
@@ -2547,10 +2680,9 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 
 		if (callchain) {
 			callchain_size = (1 + callchain->nr) * sizeof(u64);
-
-			header.type |= PERF_SAMPLE_CALLCHAIN;
 			header.size += callchain_size;
-		}
+		} else
+			header.size += sizeof(u64);
 	}
 
 	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
@@ -2601,13 +2733,79 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		}
 	}
 
-	if (callchain)
-		perf_output_copy(&handle, callchain, callchain_size);
+	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
+		if (callchain)
+			perf_output_copy(&handle, callchain, callchain_size);
+		else {
+			u64 nr = 0;
+			perf_output_put(&handle, nr);
+		}
+	}
 
 	perf_output_end(&handle);
 }
 
 /*
+ * read event
+ */
+
+struct perf_read_event {
+	struct perf_event_header	header;
+
+	u32				pid;
+	u32				tid;
+	u64				value;
+	u64				format[3];
+};
+
+static void
+perf_counter_read_event(struct perf_counter *counter,
+			struct task_struct *task)
+{
+	struct perf_output_handle handle;
+	struct perf_read_event event = {
+		.header = {
+			.type = PERF_EVENT_READ,
+			.misc = 0,
+			.size = sizeof(event) - sizeof(event.format),
+		},
+		.pid = perf_counter_pid(counter, task),
+		.tid = perf_counter_tid(counter, task),
+		.value = atomic64_read(&counter->count),
+	};
+	int ret, i = 0;
+
+	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
+		event.header.size += sizeof(u64);
+		event.format[i++] = counter->total_time_enabled;
+	}
+
+	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING) {
+		event.header.size += sizeof(u64);
+		event.format[i++] = counter->total_time_running;
+	}
+
+	if (counter->attr.read_format & PERF_FORMAT_ID) {
+		u64 id;
+
+		event.header.size += sizeof(u64);
+		if (counter->parent)
+			id = counter->parent->id;
+		else
+			id = counter->id;
+
+		event.format[i++] = id;
+	}
+
+	ret = perf_output_begin(&handle, counter, event.header.size, 0, 0);
+	if (ret)
+		return;
+
+	perf_output_copy(&handle, &event, event.header.size);
+	perf_output_end(&handle);
+}
+
+/*
  * fork tracking
  */
 
@@ -2798,6 +2996,9 @@ void perf_counter_comm(struct task_struct *task)
 {
 	struct perf_comm_event comm_event;
 
+	if (task->perf_counter_ctxp)
+		perf_counter_enable_on_exec(task);
+
 	if (!atomic_read(&nr_comm_counters))
 		return;
 
@@ -3317,8 +3518,8 @@ out:
 	put_cpu_var(perf_cpu_context);
 }
 
-void
-perf_swcounter_event(u32 event, u64 nr, int nmi, struct pt_regs *regs, u64 addr)
+void __perf_swcounter_event(u32 event, u64 nr, int nmi,
+			    struct pt_regs *regs, u64 addr)
 {
 	struct perf_sample_data data = {
 		.regs = regs,
@@ -3509,9 +3710,21 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 }
 #endif
 
+atomic_t perf_swcounter_enabled[PERF_COUNT_SW_MAX];
+
+static void sw_perf_counter_destroy(struct perf_counter *counter)
+{
+	u64 event = counter->attr.config;
+
+	WARN_ON(counter->parent);
+
+	atomic_dec(&perf_swcounter_enabled[event]);
+}
+
 static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 {
 	const struct pmu *pmu = NULL;
+	u64 event = counter->attr.config;
 
 	/*
 	 * Software counters (currently) can't in general distinguish
@@ -3520,7 +3733,7 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	 * to be kernel events, and page faults are never hypervisor
 	 * events.
 	 */
-	switch (counter->attr.config) {
+	switch (event) {
 	case PERF_COUNT_SW_CPU_CLOCK:
 		pmu = &perf_ops_cpu_clock;
 
@@ -3541,6 +3754,10 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	case PERF_COUNT_SW_PAGE_FAULTS_MAJ:
 	case PERF_COUNT_SW_CONTEXT_SWITCHES:
 	case PERF_COUNT_SW_CPU_MIGRATIONS:
+		if (!counter->parent) {
+			atomic_inc(&perf_swcounter_enabled[event]);
+			counter->destroy = sw_perf_counter_destroy;
+		}
 		pmu = &perf_ops_generic;
 		break;
 	}
@@ -3556,6 +3773,7 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 		   int cpu,
 		   struct perf_counter_context *ctx,
 		   struct perf_counter *group_leader,
+		   struct perf_counter *parent_counter,
 		   gfp_t gfpflags)
 {
 	const struct pmu *pmu;
@@ -3591,6 +3809,8 @@ perf_counter_alloc(struct perf_counter_attr *attr,
 	counter->ctx		= ctx;
 	counter->oncpu		= -1;
 
+	counter->parent		= parent_counter;
+
 	counter->ns		= get_pid_ns(current->nsproxy->pid_ns);
 	counter->id		= atomic64_inc_return(&perf_counter_id);
 
@@ -3648,11 +3868,13 @@ done:
 
 	counter->pmu = pmu;
 
-	atomic_inc(&nr_counters);
-	if (counter->attr.mmap)
-		atomic_inc(&nr_mmap_counters);
-	if (counter->attr.comm)
-		atomic_inc(&nr_comm_counters);
+	if (!counter->parent) {
+		atomic_inc(&nr_counters);
+		if (counter->attr.mmap)
+			atomic_inc(&nr_mmap_counters);
+		if (counter->attr.comm)
+			atomic_inc(&nr_comm_counters);
+	}
 
 	return counter;
 }
@@ -3815,7 +4037,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 	}
 
 	counter = perf_counter_alloc(&attr, cpu, ctx, group_leader,
-				     GFP_KERNEL);
+				     NULL, GFP_KERNEL);
 	ret = PTR_ERR(counter);
 	if (IS_ERR(counter))
 		goto err_put_context;
@@ -3881,7 +4103,8 @@ inherit_counter(struct perf_counter *parent_counter,
 
 	child_counter = perf_counter_alloc(&parent_counter->attr,
 					   parent_counter->cpu, child_ctx,
-					   group_leader, GFP_KERNEL);
+					   group_leader, parent_counter,
+					   GFP_KERNEL);
 	if (IS_ERR(child_counter))
 		return child_counter;
 	get_ctx(child_ctx);
@@ -3904,12 +4127,6 @@ inherit_counter(struct perf_counter *parent_counter,
 	 */
 	add_counter_to_ctx(child_counter, child_ctx);
 
-	child_counter->parent = parent_counter;
-	/*
-	 * inherit into child's child as well:
-	 */
-	child_counter->attr.inherit = 1;
-
 	/*
 	 * Get a reference to the parent filp - we will fput it
 	 * when the child counter exits. This is safe to do because
@@ -3953,10 +4170,14 @@ static int inherit_group(struct perf_counter *parent_counter,
 }
 
 static void sync_child_counter(struct perf_counter *child_counter,
-			       struct perf_counter *parent_counter)
+			       struct task_struct *child)
 {
+	struct perf_counter *parent_counter = child_counter->parent;
 	u64 child_val;
 
+	if (child_counter->attr.inherit_stat)
+		perf_counter_read_event(child_counter, child);
+
 	child_val = atomic64_read(&child_counter->count);
 
 	/*
@@ -3985,7 +4206,8 @@ static void sync_child_counter(struct perf_counter *child_counter,
 
 static void
 __perf_counter_exit_task(struct perf_counter *child_counter,
-			 struct perf_counter_context *child_ctx)
+			 struct perf_counter_context *child_ctx,
+			 struct task_struct *child)
 {
 	struct perf_counter *parent_counter;
 
@@ -3999,7 +4221,7 @@ __perf_counter_exit_task(struct perf_counter *child_counter,
 	 * counters need to be zapped - but otherwise linger.
 	 */
 	if (parent_counter) {
-		sync_child_counter(child_counter, parent_counter);
+		sync_child_counter(child_counter, child);
 		free_counter(child_counter);
 	}
 }
@@ -4061,7 +4283,7 @@ void perf_counter_exit_task(struct task_struct *child)
 again:
 	list_for_each_entry_safe(child_counter, tmp, &child_ctx->counter_list,
 				 list_entry)
-		__perf_counter_exit_task(child_counter, child_ctx);
+		__perf_counter_exit_task(child_counter, child_ctx, child);
 
 	/*
 	 * If the last counter was a group counter, it will have appended all
diff --git a/tools/perf/CREDITS b/tools/perf/CREDITS
new file mode 100644
index 0000000..c2ddcb3
--- /dev/null
+++ b/tools/perf/CREDITS
@@ -0,0 +1,30 @@
+Most of the infrastructure that 'perf' uses here has been reused
+from the Git project, as of version:
+
+    66996ec: Sync with 1.6.2.4
+
+Here is an (incomplete!) list of main contributors to those files
+in util/* and elsewhere:
+
+ Alex Riesen
+ Christian Couder
+ Dmitry Potapov
+ Jeff King
+ Johannes Schindelin
+ Johannes Sixt
+ Junio C Hamano
+ Linus Torvalds
+ Matthias Kestenholz
+ Michal Ostrowski
+ Miklos Vajna
+ Petr Baudis
+ Pierre Habouzit
+ René Scharfe
+ Samuel Tardieu
+ Shawn O. Pearce
+ Steffen Prohaska
+ Steve Haslam
+
+Thanks guys!
+
+The full history of the files can be found in the upstream Git commits.
diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 52d3fc6..8aa3f8c 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -13,13 +13,25 @@ SYNOPSIS
 DESCRIPTION
 -----------
 This command displays the performance counter profile information recorded
-via perf report.
+via perf record.
 
 OPTIONS
 -------
 -i::
 --input=::
         Input file name. (default: perf.data)
+-d::
+--dsos=::
+	Only consider symbols in these dsos. CSV that understands
+	file://filename entries.
+-C::
+--comms=::
+	Only consider symbols in these comms. CSV that understands
+	file://filename entries.
+-S::
+--symbols=::
+	Only consider these symbols. CSV that understands
+	file://filename entries.
 
 SEE ALSO
 --------
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index c368a72..0d74346 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -8,8 +8,8 @@ perf-stat - Run a command and gather performance counter statistics
 SYNOPSIS
 --------
 [verse]
-'perf stat' [-e <EVENT> | --event=EVENT] [-l] [-a] <command>
-'perf stat' [-e <EVENT> | --event=EVENT] [-l] [-a] -- <command> [<options>]
+'perf stat' [-e <EVENT> | --event=EVENT] [-S] [-a] <command>
+'perf stat' [-e <EVENT> | --event=EVENT] [-S] [-a] -- <command> [<options>]
 
 DESCRIPTION
 -----------
@@ -40,7 +40,7 @@ OPTIONS
 -a::
         system-wide collection
 
--l::
+-S::
         scale counter values
 
 EXAMPLES
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 36d7eef..9c6d0ae 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -290,7 +290,7 @@ LIB_FILE=libperf.a
 
 LIB_H += ../../include/linux/perf_counter.h
 LIB_H += perf.h
-LIB_H += types.h
+LIB_H += util/types.h
 LIB_H += util/list.h
 LIB_H += util/rbtree.h
 LIB_H += util/levenshtein.h
@@ -301,6 +301,7 @@ LIB_H += util/util.h
 LIB_H += util/help.h
 LIB_H += util/strbuf.h
 LIB_H += util/string.h
+LIB_H += util/strlist.h
 LIB_H += util/run-command.h
 LIB_H += util/sigchain.h
 LIB_H += util/symbol.h
@@ -322,12 +323,15 @@ LIB_OBJS += util/run-command.o
 LIB_OBJS += util/quote.o
 LIB_OBJS += util/strbuf.o
 LIB_OBJS += util/string.o
+LIB_OBJS += util/strlist.o
 LIB_OBJS += util/usage.o
 LIB_OBJS += util/wrapper.o
 LIB_OBJS += util/sigchain.o
 LIB_OBJS += util/symbol.o
 LIB_OBJS += util/color.o
 LIB_OBJS += util/pager.o
+LIB_OBJS += util/header.o
+LIB_OBJS += util/callchain.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 7e58e3a..722c0f5 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -855,7 +855,7 @@ static unsigned long total = 0,
 		     total_unknown = 0;
 
 static int
-process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
+process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	char level;
 	int show = 0;
@@ -1013,10 +1013,10 @@ process_period_event(event_t *event, unsigned long offset, unsigned long head)
 static int
 process_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW)
-		return process_overflow_event(event, offset, head);
-
 	switch (event->header.type) {
+	case PERF_EVENT_SAMPLE:
+		return process_sample_event(event, offset, head);
+
 	case PERF_EVENT_MMAP:
 		return process_mmap_event(event, offset, head);
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d7ebbd7..d18546f 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -14,6 +14,8 @@
 #include "util/parse-events.h"
 #include "util/string.h"
 
+#include "util/header.h"
+
 #include <unistd.h>
 #include <sched.h>
 
@@ -39,6 +41,8 @@ static int			force				= 0;
 static int			append_file			= 0;
 static int			call_graph			= 0;
 static int			verbose				= 0;
+static int			inherit_stat			= 0;
+static int			no_samples			= 0;
 
 static long			samples;
 static struct timeval		last_read;
@@ -52,7 +56,8 @@ static int			nr_poll;
 static int			nr_cpu;
 
 static int			file_new = 1;
-static struct perf_file_header	file_header;
+
+struct perf_header		*header;
 
 struct mmap_event {
 	struct perf_event_header	header;
@@ -306,12 +311,11 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 			continue;
 		pbf += n + 3;
 		if (*pbf == 'x') { /* vm_exec */
-			char *execname = strrchr(bf, ' ');
+			char *execname = strchr(bf, '/');
 
-			if (execname == NULL || execname[1] != '/')
+			if (execname == NULL)
 				continue;
 
-			execname += 1;
 			size = strlen(execname);
 			execname[size - 1] = '\0'; /* Remove \n */
 			memcpy(mmap_ev.filename, execname, size);
@@ -329,7 +333,7 @@ static void pid_synthesize_mmap_samples(pid_t pid)
 	fclose(fp);
 }
 
-static void synthesize_samples(void)
+static void synthesize_all(void)
 {
 	DIR *proc;
 	struct dirent dirent, *next;
@@ -353,10 +357,35 @@ static void synthesize_samples(void)
 
 static int group_fd;
 
+static struct perf_header_attr *get_header_attr(struct perf_counter_attr *a, int nr)
+{
+	struct perf_header_attr *h_attr;
+
+	if (nr < header->attrs) {
+		h_attr = header->attr[nr];
+	} else {
+		h_attr = perf_header_attr__new(a);
+		perf_header__add_attr(header, h_attr);
+	}
+
+	return h_attr;
+}
+
 static void create_counter(int counter, int cpu, pid_t pid)
 {
 	struct perf_counter_attr *attr = attrs + counter;
-	int track = 1;
+	struct perf_header_attr *h_attr;
+	int track = !counter; /* only the first counter needs these */
+	struct {
+		u64 count;
+		u64 time_enabled;
+		u64 time_running;
+		u64 id;
+	} read_data;
+
+	attr->read_format	= PERF_FORMAT_TOTAL_TIME_ENABLED |
+				  PERF_FORMAT_TOTAL_TIME_RUNNING |
+				  PERF_FORMAT_ID;
 
 	attr->sample_type	= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
@@ -366,25 +395,20 @@ static void create_counter(int counter, int cpu, pid_t pid)
 		attr->sample_freq	= freq;
 	}
 
+	if (no_samples)
+		attr->sample_freq = 0;
+
+	if (inherit_stat)
+		attr->inherit_stat = 1;
+
 	if (call_graph)
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
-	if (file_new) {
-		file_header.sample_type = attr->sample_type;
-	} else {
-		if (file_header.sample_type != attr->sample_type) {
-			fprintf(stderr, "incompatible append\n");
-			exit(-1);
-		}
-	}
-
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= (cpu < 0) && inherit;
 	attr->disabled		= 1;
 
-	track = 0; /* only the first counter needs these */
-
 try_again:
 	fd[nr_cpu][counter] = sys_perf_counter_open(attr, pid, cpu, group_fd, 0);
 
@@ -415,6 +439,22 @@ try_again:
 		exit(-1);
 	}
 
+	h_attr = get_header_attr(attr, counter);
+
+	if (!file_new) {
+		if (memcmp(&h_attr->attr, attr, sizeof(*attr))) {
+			fprintf(stderr, "incompatible append\n");
+			exit(-1);
+		}
+	}
+
+	if (read(fd[nr_cpu][counter], &read_data, sizeof(read_data)) == -1) {
+		perror("Unable to read perf file descriptor\n");
+		exit(-1);
+	}
+
+	perf_header_attr__add_id(h_attr, read_data.id);
+
 	assert(fd[nr_cpu][counter] >= 0);
 	fcntl(fd[nr_cpu][counter], F_SETFL, O_NONBLOCK);
 
@@ -445,11 +485,6 @@ static void open_counters(int cpu, pid_t pid)
 {
 	int counter;
 
-	if (pid > 0) {
-		pid_synthesize_comm_event(pid, 0);
-		pid_synthesize_mmap_samples(pid);
-	}
-
 	group_fd = -1;
 	for (counter = 0; counter < nr_counters; counter++)
 		create_counter(counter, cpu, pid);
@@ -459,17 +494,16 @@ static void open_counters(int cpu, pid_t pid)
 
 static void atexit_header(void)
 {
-	file_header.data_size += bytes_written;
+	header->data_size += bytes_written;
 
-	if (pwrite(output, &file_header, sizeof(file_header), 0) == -1)
-		perror("failed to write on file headers");
+	perf_header__write(header, output);
 }
 
 static int __cmd_record(int argc, const char **argv)
 {
 	int i, counter;
 	struct stat st;
-	pid_t pid;
+	pid_t pid = 0;
 	int flags;
 	int ret;
 
@@ -500,22 +534,31 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
-	if (!file_new) {
-		if (read(output, &file_header, sizeof(file_header)) == -1) {
-			perror("failed to read file headers");
-			exit(-1);
-		}
-
-		lseek(output, file_header.data_size, SEEK_CUR);
-	}
+	if (!file_new)
+		header = perf_header__read(output);
+	else
+		header = perf_header__new();
 
 	atexit(atexit_header);
 
 	if (!system_wide) {
-		open_counters(-1, target_pid != -1 ? target_pid : getpid());
+		pid = target_pid;
+		if (pid == -1)
+			pid = getpid();
+
+		open_counters(-1, pid);
 	} else for (i = 0; i < nr_cpus; i++)
 		open_counters(i, target_pid);
 
+	if (file_new)
+		perf_header__write(header, output);
+
+	if (!system_wide) {
+		pid_synthesize_comm_event(pid, 0);
+		pid_synthesize_mmap_samples(pid);
+	} else
+		synthesize_all();
+
 	if (target_pid == -1 && argc) {
 		pid = fork();
 		if (pid < 0)
@@ -539,10 +582,7 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
-	if (system_wide)
-		synthesize_samples();
-
-	while (!done) {
+	for (;;) {
 		int hits = samples;
 
 		for (i = 0; i < nr_cpu; i++) {
@@ -550,8 +590,11 @@ static int __cmd_record(int argc, const char **argv)
 				mmap_read(&mmap_array[i][counter]);
 		}
 
-		if (hits == samples)
+		if (hits == samples) {
+			if (done)
+				break;
 			ret = poll(event_array, nr_poll, 100);
+		}
 	}
 
 	/*
@@ -600,6 +643,10 @@ static const struct option options[] = {
 		    "do call-graph (stack chain/backtrace) recording"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
+	OPT_BOOLEAN('s', "stat", &inherit_stat,
+		    "per thread counts"),
+	OPT_BOOLEAN('n', "no-samples", &no_samples,
+		    "don't sample"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5eb5566..135b783 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -15,8 +15,11 @@
 #include "util/rbtree.h"
 #include "util/symbol.h"
 #include "util/string.h"
+#include "util/callchain.h"
+#include "util/strlist.h"
 
 #include "perf.h"
+#include "util/header.h"
 
 #include "util/parse-options.h"
 #include "util/parse-events.h"
@@ -30,6 +33,8 @@ static char		*vmlinux = NULL;
 
 static char		default_sort_order[] = "comm,dso";
 static char		*sort_order = default_sort_order;
+static char		*dso_list_str, *comm_list_str, *sym_list_str;
+static struct strlist	*dso_list, *comm_list, *sym_list;
 
 static int		input;
 static int		show_mask = SHOW_KERNEL | SHOW_USER | SHOW_HV;
@@ -51,6 +56,9 @@ static char		*parent_pattern = default_parent_pattern;
 static regex_t		parent_regex;
 
 static int		exclude_other = 1;
+static int		callchain;
+
+static u64		sample_type;
 
 struct ip_event {
 	struct perf_event_header header;
@@ -59,11 +67,6 @@ struct ip_event {
 	unsigned char __more_data[];
 };
 
-struct ip_callchain {
-	u64 nr;
-	u64 ips[0];
-};
-
 struct mmap_event {
 	struct perf_event_header header;
 	u32 pid, tid;
@@ -97,6 +100,13 @@ struct lost_event {
 	u64 lost;
 };
 
+struct read_event {
+	struct perf_event_header header;
+	u32 pid,tid;
+	u64 value;
+	u64 format[3];
+};
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -105,6 +115,7 @@ typedef union event_union {
 	struct fork_event		fork;
 	struct period_event		period;
 	struct lost_event		lost;
+	struct read_event		read;
 } event_t;
 
 static LIST_HEAD(dsos);
@@ -229,7 +240,7 @@ static u64 vdso__map_ip(struct map *map, u64 ip)
 
 static inline int is_anon_memory(const char *filename)
 {
-     return strcmp(filename, "//anon") == 0;
+	return strcmp(filename, "//anon") == 0;
 }
 
 static struct map *map__new(struct mmap_event *event)
@@ -400,9 +411,27 @@ static void thread__insert_map(struct thread *self, struct map *map)
 
 	list_for_each_entry_safe(pos, tmp, &self->maps, node) {
 		if (map__overlap(pos, map)) {
-			list_del_init(&pos->node);
-			/* XXX leaks dsos */
-			free(pos);
+			if (verbose >= 2) {
+				printf("overlapping maps:\n");
+				map__fprintf(map, stdout);
+				map__fprintf(pos, stdout);
+			}
+
+			if (map->start <= pos->start && map->end > pos->start)
+				pos->start = map->end;
+
+			if (map->end >= pos->end && map->start < pos->end)
+				pos->end = map->start;
+
+			if (verbose >= 2) {
+				printf("after collision:\n");
+				map__fprintf(pos, stdout);
+			}
+
+			if (pos->start >= pos->end) {
+				list_del_init(&pos->node);
+				free(pos);
+			}
 		}
 	}
 
@@ -464,17 +493,19 @@ static size_t threads__fprintf(FILE *fp)
 static struct rb_root hist;
 
 struct hist_entry {
-	struct rb_node	 rb_node;
-
-	struct thread	 *thread;
-	struct map	 *map;
-	struct dso	 *dso;
-	struct symbol	 *sym;
-	struct symbol	 *parent;
-	u64		 ip;
-	char		 level;
-
-	u64		 count;
+	struct rb_node		rb_node;
+
+	struct thread		*thread;
+	struct map		*map;
+	struct dso		*dso;
+	struct symbol		*sym;
+	struct symbol		*parent;
+	u64			ip;
+	char			level;
+	struct callchain_node	callchain;
+	struct rb_root		sorted_chain;
+
+	u64			count;
 };
 
 /*
@@ -745,6 +776,48 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 }
 
 static size_t
+callchain__fprintf(FILE *fp, struct callchain_node *self, u64 total_samples)
+{
+	struct callchain_list *chain;
+	size_t ret = 0;
+
+	if (!self)
+		return 0;
+
+	ret += callchain__fprintf(fp, self->parent, total_samples);
+
+
+	list_for_each_entry(chain, &self->val, list)
+		ret += fprintf(fp, "                %p\n", (void *)chain->ip);
+
+	return ret;
+}
+
+static size_t
+hist_entry_callchain__fprintf(FILE *fp, struct hist_entry *self,
+			      u64 total_samples)
+{
+	struct rb_node *rb_node;
+	struct callchain_node *chain;
+	size_t ret = 0;
+
+	rb_node = rb_first(&self->sorted_chain);
+	while (rb_node) {
+		double percent;
+
+		chain = rb_entry(rb_node, struct callchain_node, rb_node);
+		percent = chain->hit * 100.0 / total_samples;
+		ret += fprintf(fp, "           %6.2f%%\n", percent);
+		ret += callchain__fprintf(fp, chain, total_samples);
+		ret += fprintf(fp, "\n");
+		rb_node = rb_next(rb_node);
+	}
+
+	return ret;
+}
+
+
+static size_t
 hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 {
 	struct sort_entry *se;
@@ -784,6 +857,9 @@ hist_entry__fprintf(FILE *fp, struct hist_entry *self, u64 total_samples)
 
 	ret += fprintf(fp, "\n");
 
+	if (callchain)
+		hist_entry_callchain__fprintf(fp, self, total_samples);
+
 	return ret;
 }
 
@@ -797,7 +873,7 @@ resolve_symbol(struct thread *thread, struct map **mapp,
 {
 	struct dso *dso = dsop ? *dsop : NULL;
 	struct map *map = mapp ? *mapp : NULL;
-	uint64_t ip = *ipp;
+	u64 ip = *ipp;
 
 	if (!thread)
 		return NULL;
@@ -814,7 +890,6 @@ resolve_symbol(struct thread *thread, struct map **mapp,
 			*mapp = map;
 got_map:
 		ip = map->map_ip(map, ip);
-		*ipp  = ip;
 
 		dso = map->dso;
 	} else {
@@ -828,6 +903,8 @@ got_map:
 		dso = kernel_dso;
 	}
 	dprintf(" ...... dso: %s\n", dso ? dso->name : "<not found>");
+	dprintf(" ...... map: %Lx -> %Lx\n", *ipp, ip);
+	*ipp  = ip;
 
 	if (dsop)
 		*dsop = dso;
@@ -867,6 +944,7 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 		.level	= level,
 		.count	= count,
 		.parent = NULL,
+		.sorted_chain = RB_ROOT
 	};
 	int cmp;
 
@@ -909,6 +987,8 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 
 		if (!cmp) {
 			he->count += count;
+			if (callchain)
+				append_chain(&he->callchain, chain);
 			return 0;
 		}
 
@@ -922,6 +1002,10 @@ hist_entry__add(struct thread *thread, struct map *map, struct dso *dso,
 	if (!he)
 		return -ENOMEM;
 	*he = entry;
+	if (callchain) {
+		callchain_init(&he->callchain);
+		append_chain(&he->callchain, chain);
+	}
 	rb_link_node(&he->rb_node, parent, p);
 	rb_insert_color(&he->rb_node, &hist);
 
@@ -998,6 +1082,9 @@ static void output__insert_entry(struct hist_entry *he)
 	struct rb_node *parent = NULL;
 	struct hist_entry *iter;
 
+	if (callchain)
+		sort_chain_to_rbtree(&he->sorted_chain, &he->callchain);
+
 	while (*p != NULL) {
 		parent = *p;
 		iter = rb_entry(parent, struct hist_entry, rb_node);
@@ -1115,7 +1202,7 @@ static int validate_chain(struct ip_callchain *chain, event_t *event)
 }
 
 static int
-process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
+process_sample_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	char level;
 	int show = 0;
@@ -1127,12 +1214,12 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	void *more_data = event->ip.__more_data;
 	struct ip_callchain *chain = NULL;
 
-	if (event->header.type & PERF_SAMPLE_PERIOD) {
+	if (sample_type & PERF_SAMPLE_PERIOD) {
 		period = *(u64 *)more_data;
 		more_data += sizeof(u64);
 	}
 
-	dprintf("%p [%p]: PERF_EVENT (IP, %d): %d: %p period: %Ld\n",
+	dprintf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d: %p period: %Ld\n",
 		(void *)(offset + head),
 		(void *)(long)(event->header.size),
 		event->header.misc,
@@ -1140,7 +1227,7 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 		(void *)(long)ip,
 		(long long)period);
 
-	if (event->header.type & PERF_SAMPLE_CALLCHAIN) {
+	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
 		int i;
 
 		chain = (void *)more_data;
@@ -1166,6 +1253,9 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 		return -1;
 	}
 
+	if (comm_list && !strlist__has_entry(comm_list, thread->comm))
+		return 0;
+
 	if (event->header.misc & PERF_EVENT_MISC_KERNEL) {
 		show = SHOW_KERNEL;
 		level = 'k';
@@ -1188,6 +1278,12 @@ process_overflow_event(event_t *event, unsigned long offset, unsigned long head)
 	if (show & show_mask) {
 		struct symbol *sym = resolve_symbol(thread, &map, &dso, &ip);
 
+		if (dso_list && dso && dso->name && !strlist__has_entry(dso_list, dso->name))
+			return 0;
+
+		if (sym_list && sym && !strlist__has_entry(sym_list, sym->name))
+			return 0;
+
 		if (hist_entry__add(thread, map, dso, sym, ip, chain, level, period)) {
 			eprintf("problem incrementing symbol count, skipping event\n");
 			return -1;
@@ -1328,14 +1424,27 @@ static void trace_event(event_t *event)
 }
 
 static int
+process_read_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	dprintf("%p [%p]: PERF_EVENT_READ: %d %d %Lu\n",
+			(void *)(offset + head),
+			(void *)(long)(event->header.size),
+			event->read.pid,
+			event->read.tid,
+			event->read.value);
+
+	return 0;
+}
+
+static int
 process_event(event_t *event, unsigned long offset, unsigned long head)
 {
 	trace_event(event);
 
-	if (event->header.misc & PERF_EVENT_MISC_OVERFLOW)
-		return process_overflow_event(event, offset, head);
-
 	switch (event->header.type) {
+	case PERF_EVENT_SAMPLE:
+		return process_sample_event(event, offset, head);
+
 	case PERF_EVENT_MMAP:
 		return process_mmap_event(event, offset, head);
 
@@ -1351,6 +1460,9 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	case PERF_EVENT_LOST:
 		return process_lost_event(event, offset, head);
 
+	case PERF_EVENT_READ:
+		return process_read_event(event, offset, head);
+
 	/*
 	 * We dont process them right now but they are fine:
 	 */
@@ -1366,13 +1478,30 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static struct perf_file_header		file_header;
+static struct perf_header	*header;
+
+static u64 perf_header__sample_type(void)
+{
+	u64 sample_type = 0;
+	int i;
+
+	for (i = 0; i < header->attrs; i++) {
+		struct perf_header_attr *attr = header->attr[i];
+
+		if (!sample_type)
+			sample_type = attr->attr.sample_type;
+		else if (sample_type != attr->attr.sample_type)
+			die("non matching sample_type");
+	}
+
+	return sample_type;
+}
 
 static int __cmd_report(void)
 {
 	int ret, rc = EXIT_FAILURE;
 	unsigned long offset = 0;
-	unsigned long head = sizeof(file_header);
+	unsigned long head, shift;
 	struct stat stat;
 	event_t *event;
 	uint32_t size;
@@ -1400,13 +1529,12 @@ static int __cmd_report(void)
 		exit(0);
 	}
 
-	if (read(input, &file_header, sizeof(file_header)) == -1) {
-		perror("failed to read file headers");
-		exit(-1);
-	}
+	header = perf_header__read(input);
+	head = header->data_offset;
 
-	if (sort__has_parent &&
-	    !(file_header.sample_type & PERF_SAMPLE_CALLCHAIN)) {
+	sample_type = perf_header__sample_type();
+
+	if (sort__has_parent && !(sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		fprintf(stderr, "selected --sort parent, but no callchain data\n");
 		exit(-1);
 	}
@@ -1426,6 +1554,11 @@ static int __cmd_report(void)
 		cwd = NULL;
 		cwdlen = 0;
 	}
+
+	shift = page_size * (head / page_size);
+	offset += shift;
+	head -= shift;
+
 remap:
 	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
 			   MAP_SHARED, input, offset);
@@ -1442,9 +1575,10 @@ more:
 		size = 8;
 
 	if (head + event->header.size >= page_size * mmap_window) {
-		unsigned long shift = page_size * (head / page_size);
 		int ret;
 
+		shift = page_size * (head / page_size);
+
 		ret = munmap(buf, page_size * mmap_window);
 		assert(ret == 0);
 
@@ -1482,7 +1616,7 @@ more:
 
 	head += size;
 
-	if (offset + head >= sizeof(file_header) + file_header.data_size)
+	if (offset + head >= header->data_offset + header->data_size)
 		goto done;
 
 	if (offset + head < stat.st_size)
@@ -1536,6 +1670,13 @@ static const struct option options[] = {
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &exclude_other,
 		    "Only display entries with parent-match"),
+	OPT_BOOLEAN('c', "callchain", &callchain, "Display callchains"),
+	OPT_STRING('d', "dsos", &dso_list_str, "dso[,dso...]",
+		   "only consider symbols in these dsos"),
+	OPT_STRING('C', "comms", &comm_list_str, "comm[,comm...]",
+		   "only consider symbols in these comms"),
+	OPT_STRING('S', "symbols", &sym_list_str, "symbol[,symbol...]",
+		   "only consider these symbols"),
 	OPT_END()
 };
 
@@ -1554,6 +1695,19 @@ static void setup_sorting(void)
 	free(str);
 }
 
+static void setup_list(struct strlist **list, const char *list_str,
+		       const char *list_name)
+{
+	if (list_str) {
+		*list = strlist__new(true, list_str);
+		if (!*list) {
+			fprintf(stderr, "problems parsing %s list\n",
+				list_name);
+			exit(129);
+		}
+	}
+}
+
 int cmd_report(int argc, const char **argv, const char *prefix)
 {
 	symbol__init();
@@ -1575,6 +1729,10 @@ int cmd_report(int argc, const char **argv, const char *prefix)
 	if (argc)
 		usage_with_options(report_usage, options);
 
+	setup_list(&dso_list, dso_list_str, "dso");
+	setup_list(&comm_list, comm_list_str, "comm");
+	setup_list(&sym_list, sym_list_str, "symbol");
+
 	setup_pager();
 
 	return __cmd_report();
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 6d3eeac..2e03524 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -32,6 +32,7 @@
  *   Wu Fengguang <fengguang.wu@intel.com>
  *   Mike Galbraith <efault@gmx.de>
  *   Paul Mackerras <paulus@samba.org>
+ *   Jaswinder Singh Rajput <jaswinder@kernel.org>
  *
  * Released under the GPL v2. (and only v2, not any later version)
  */
@@ -45,7 +46,7 @@
 #include <sys/prctl.h>
 #include <math.h>
 
-static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
+static struct perf_counter_attr default_attrs[] = {
 
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_TASK_CLOCK	},
   { .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_CONTEXT_SWITCHES},
@@ -59,42 +60,28 @@ static struct perf_counter_attr default_attrs[MAX_COUNTERS] = {
 
 };
 
+#define MAX_RUN			100
+
 static int			system_wide			=  0;
-static int			inherit				=  1;
 static int			verbose				=  0;
-
-static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
-
-static int			target_pid			= -1;
 static int			nr_cpus				=  0;
-static unsigned int		page_size;
+static int			run_idx				=  0;
 
+static int			run_count			=  1;
+static int			inherit				=  1;
 static int			scale				=  1;
+static int			target_pid			= -1;
+static int			null_run			=  0;
 
-static const unsigned int default_count[] = {
-	1000000,
-	1000000,
-	  10000,
-	  10000,
-	1000000,
-	  10000,
-};
-
-#define MAX_RUN 100
-
-static int			run_count		=  1;
-static int			run_idx			=  0;
-
-static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
-static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
-
-//static u64			event_hist[MAX_RUN][MAX_COUNTERS][3];
-
+static int			fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static u64			runtime_nsecs[MAX_RUN];
 static u64			walltime_nsecs[MAX_RUN];
 static u64			runtime_cycles[MAX_RUN];
 
+static u64			event_res[MAX_RUN][MAX_COUNTERS][3];
+static u64			event_scaled[MAX_RUN][MAX_COUNTERS];
+
 static u64			event_res_avg[MAX_COUNTERS][3];
 static u64			event_res_noise[MAX_COUNTERS][3];
 
@@ -109,7 +96,10 @@ static u64			walltime_nsecs_noise;
 static u64			runtime_cycles_avg;
 static u64			runtime_cycles_noise;
 
-static void create_perf_stat_counter(int counter)
+#define ERR_PERF_OPEN \
+"Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n"
+
+static void create_perf_stat_counter(int counter, int pid)
 {
 	struct perf_counter_attr *attr = attrs + counter;
 
@@ -119,20 +109,21 @@ static void create_perf_stat_counter(int counter)
 
 	if (system_wide) {
 		int cpu;
-		for (cpu = 0; cpu < nr_cpus; cpu ++) {
+		for (cpu = 0; cpu < nr_cpus; cpu++) {
 			fd[cpu][counter] = sys_perf_counter_open(attr, -1, cpu, -1, 0);
-			if (fd[cpu][counter] < 0 && verbose) {
-				printf("Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n", counter, fd[cpu][counter], strerror(errno));
-			}
+			if (fd[cpu][counter] < 0 && verbose)
+				fprintf(stderr, ERR_PERF_OPEN, counter,
+					fd[cpu][counter], strerror(errno));
 		}
 	} else {
-		attr->inherit	= inherit;
-		attr->disabled	= 1;
-
-		fd[0][counter] = sys_perf_counter_open(attr, 0, -1, -1, 0);
-		if (fd[0][counter] < 0 && verbose) {
-			printf("Error: counter %d, sys_perf_counter_open() syscall returned with %d (%s)\n", counter, fd[0][counter], strerror(errno));
-		}
+		attr->inherit	     = inherit;
+		attr->disabled	     = 1;
+		attr->enable_on_exec = 1;
+
+		fd[0][counter] = sys_perf_counter_open(attr, pid, -1, -1, 0);
+		if (fd[0][counter] < 0 && verbose)
+			fprintf(stderr, ERR_PERF_OPEN, counter,
+				fd[0][counter], strerror(errno));
 	}
 }
 
@@ -168,7 +159,7 @@ static void read_counter(int counter)
 	count[0] = count[1] = count[2] = 0;
 
 	nv = scale ? 3 : 1;
-	for (cpu = 0; cpu < nr_cpus; cpu ++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		if (fd[cpu][counter] < 0)
 			continue;
 
@@ -215,32 +206,67 @@ static int run_perf_stat(int argc, const char **argv)
 	int status = 0;
 	int counter;
 	int pid;
+	int child_ready_pipe[2], go_pipe[2];
+	char buf;
 
 	if (!system_wide)
 		nr_cpus = 1;
 
-	for (counter = 0; counter < nr_counters; counter++)
-		create_perf_stat_counter(counter);
-
-	/*
-	 * Enable counters and exec the command:
-	 */
-	t0 = rdclock();
-	prctl(PR_TASK_PERF_COUNTERS_ENABLE);
+	if (pipe(child_ready_pipe) < 0 || pipe(go_pipe) < 0) {
+		perror("failed to create pipes");
+		exit(1);
+	}
 
 	if ((pid = fork()) < 0)
 		perror("failed to fork");
 
 	if (!pid) {
-		if (execvp(argv[0], (char **)argv)) {
-			perror(argv[0]);
-			exit(-1);
-		}
+		close(child_ready_pipe[0]);
+		close(go_pipe[1]);
+		fcntl(go_pipe[0], F_SETFD, FD_CLOEXEC);
+
+		/*
+		 * Do a dummy execvp to get the PLT entry resolved,
+		 * so we avoid the resolver overhead on the real
+		 * execvp call.
+		 */
+		execvp("", (char **)argv);
+
+		/*
+		 * Tell the parent we're ready to go
+		 */
+		close(child_ready_pipe[1]);
+
+		/*
+		 * Wait until the parent tells us to go.
+		 */
+		read(go_pipe[0], &buf, 1);
+
+		execvp(argv[0], (char **)argv);
+
+		perror(argv[0]);
+		exit(-1);
 	}
 
+	/*
+	 * Wait for the child to be ready to exec.
+	 */
+	close(child_ready_pipe[1]);
+	close(go_pipe[0]);
+	read(child_ready_pipe[0], &buf, 1);
+	close(child_ready_pipe[0]);
+
+	for (counter = 0; counter < nr_counters; counter++)
+		create_perf_stat_counter(counter, pid);
+
+	/*
+	 * Enable counters and exec the command:
+	 */
+	t0 = rdclock();
+
+	close(go_pipe[1]);
 	wait(&status);
 
-	prctl(PR_TASK_PERF_COUNTERS_DISABLE);
 	t1 = rdclock();
 
 	walltime_nsecs[run_idx] = t1 - t0;
@@ -262,7 +288,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 {
 	double msecs = (double)count[0] / 1000000;
 
-	fprintf(stderr, " %14.6f  %-20s", msecs, event_name(counter));
+	fprintf(stderr, " %14.6f  %-24s", msecs, event_name(counter));
 
 	if (attrs[counter].type == PERF_TYPE_SOFTWARE &&
 		attrs[counter].config == PERF_COUNT_SW_TASK_CLOCK) {
@@ -276,7 +302,7 @@ static void nsec_printout(int counter, u64 *count, u64 *noise)
 
 static void abs_printout(int counter, u64 *count, u64 *noise)
 {
-	fprintf(stderr, " %14Ld  %-20s", count[0], event_name(counter));
+	fprintf(stderr, " %14Ld  %-24s", count[0], event_name(counter));
 
 	if (runtime_cycles_avg &&
 		attrs[counter].type == PERF_TYPE_HARDWARE &&
@@ -306,7 +332,7 @@ static void print_counter(int counter)
 	scaled = event_scaled_avg[counter];
 
 	if (scaled == -1) {
-		fprintf(stderr, " %14s  %-20s\n",
+		fprintf(stderr, " %14s  %-24s\n",
 			"<not counted>", event_name(counter));
 		return;
 	}
@@ -364,8 +390,11 @@ static void calc_avg(void)
 				event_res_avg[j]+1, event_res[i][j]+1);
 			update_avg("counter/2", j,
 				event_res_avg[j]+2, event_res[i][j]+2);
-			update_avg("scaled", j,
-				event_scaled_avg + j, event_scaled[i]+j);
+			if (event_scaled[i][j] != -1)
+				update_avg("scaled", j,
+					event_scaled_avg + j, event_scaled[i]+j);
+			else
+				event_scaled_avg[j] = -1;
 		}
 	}
 	runtime_nsecs_avg /= run_count;
@@ -429,11 +458,14 @@ static void print_stat(int argc, const char **argv)
 	for (counter = 0; counter < nr_counters; counter++)
 		print_counter(counter);
 
-
 	fprintf(stderr, "\n");
-	fprintf(stderr, " %14.9f  seconds time elapsed.\n",
+	fprintf(stderr, " %14.9f  seconds time elapsed",
 			(double)walltime_nsecs_avg/1e9);
-	fprintf(stderr, "\n");
+	if (run_count > 1) {
+		fprintf(stderr, "   ( +- %7.3f%% )",
+			100.0*(double)walltime_nsecs_noise/(double)walltime_nsecs_avg);
+	}
+	fprintf(stderr, "\n\n");
 }
 
 static volatile int signr = -1;
@@ -466,13 +498,15 @@ static const struct option options[] = {
 	OPT_INTEGER('p', "pid", &target_pid,
 		    "stat events on existing pid"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
-			    "system-wide collection from all CPUs"),
+		    "system-wide collection from all CPUs"),
 	OPT_BOOLEAN('S', "scale", &scale,
-			    "scale/normalize counters"),
+		    "scale/normalize counters"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_INTEGER('r', "repeat", &run_count,
 		    "repeat command and print average + stddev (max: 100)"),
+	OPT_BOOLEAN('n', "null", &null_run,
+		    "null run - dont start any counters"),
 	OPT_END()
 };
 
@@ -480,18 +514,17 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 {
 	int status;
 
-	page_size = sysconf(_SC_PAGE_SIZE);
-
-	memcpy(attrs, default_attrs, sizeof(attrs));
-
 	argc = parse_options(argc, argv, options, stat_usage, 0);
 	if (!argc)
 		usage_with_options(stat_usage, options);
 	if (run_count <= 0 || run_count > MAX_RUN)
 		usage_with_options(stat_usage, options);
 
-	if (!nr_counters)
-		nr_counters = 8;
+	/* Set attrs and nr_counters if no event is selected and !null_run */
+	if (!null_run && !nr_counters) {
+		memcpy(attrs, default_attrs, sizeof(default_attrs));
+		nr_counters = ARRAY_SIZE(default_attrs);
+	}
 
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
 	assert(nr_cpus <= MAX_NR_CPUS);
@@ -511,7 +544,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix)
 	status = 0;
 	for (run_idx = 0; run_idx < run_count; run_idx++) {
 		if (run_count != 1 && verbose)
-			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx+1);
+			fprintf(stderr, "[ perf stat: executing run #%d ... ]\n", run_idx + 1);
 		status = run_perf_stat(argc, argv);
 	}
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5352b5e..cf0d21f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -392,11 +392,11 @@ static void record_ip(u64 ip, int counter)
 	samples--;
 }
 
-static void process_event(u64 ip, int counter)
+static void process_event(u64 ip, int counter, int user)
 {
 	samples++;
 
-	if (ip < min_ip || ip > max_ip) {
+	if (user) {
 		userspace_samples++;
 		return;
 	}
@@ -509,9 +509,10 @@ static void mmap_read_counter(struct mmap_data *md)
 
 		old += size;
 
-		if (event->header.misc & PERF_EVENT_MISC_OVERFLOW) {
-			if (event->header.type & PERF_SAMPLE_IP)
-				process_event(event->ip.ip, md->counter);
+		if (event->header.type == PERF_EVENT_SAMPLE) {
+			int user =
+	(event->header.misc & PERF_EVENT_MISC_CPUMODE_MASK) == PERF_EVENT_MISC_USER;
+			process_event(event->ip.ip, md->counter, user);
 		}
 	}
 
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index bccb529..a49842b 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -19,7 +19,7 @@
 #include <sys/syscall.h>
 
 #include "../../include/linux/perf_counter.h"
-#include "types.h"
+#include "util/types.h"
 
 /*
  * prctl(PR_TASK_PERF_COUNTERS_DISABLE) will (cheaply) disable all
@@ -66,10 +66,9 @@ sys_perf_counter_open(struct perf_counter_attr *attr,
 #define MAX_COUNTERS			256
 #define MAX_NR_CPUS			256
 
-struct perf_file_header {
-	u64	version;
-	u64	sample_type;
-	u64	data_size;
+struct ip_callchain {
+	u64 nr;
+	u64 ips[0];
 };
 
 #endif
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
new file mode 100644
index 0000000..ad3c285
--- /dev/null
+++ b/tools/perf/util/callchain.c
@@ -0,0 +1,174 @@
+/*
+ * Copyright (C) 2009, Frederic Weisbecker <fweisbec@gmail.com>
+ *
+ * Handle the callchains from the stream in an ad-hoc radix tree and then
+ * sort them in an rbtree.
+ *
+ */
+
+#include <stdlib.h>
+#include <stdio.h>
+#include <stdbool.h>
+#include <errno.h>
+
+#include "callchain.h"
+
+
+static void rb_insert_callchain(struct rb_root *root, struct callchain_node *chain)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct callchain_node *rnode;
+
+	while (*p) {
+		parent = *p;
+		rnode = rb_entry(parent, struct callchain_node, rb_node);
+
+		if (rnode->hit < chain->hit)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	rb_link_node(&chain->rb_node, parent, p);
+	rb_insert_color(&chain->rb_node, root);
+}
+
+/*
+ * Once we get every callchains from the stream, we can now
+ * sort them by hit
+ */
+void sort_chain_to_rbtree(struct rb_root *rb_root, struct callchain_node *node)
+{
+	struct callchain_node *child;
+
+	list_for_each_entry(child, &node->children, brothers)
+		sort_chain_to_rbtree(rb_root, child);
+
+	if (node->hit)
+		rb_insert_callchain(rb_root, node);
+}
+
+static struct callchain_node *create_child(struct callchain_node *parent)
+{
+	struct callchain_node *new;
+
+	new = malloc(sizeof(*new));
+	if (!new) {
+		perror("not enough memory to create child for code path tree");
+		return NULL;
+	}
+	new->parent = parent;
+	INIT_LIST_HEAD(&new->children);
+	INIT_LIST_HEAD(&new->val);
+	list_add_tail(&new->brothers, &parent->children);
+
+	return new;
+}
+
+static void
+fill_node(struct callchain_node *node, struct ip_callchain *chain, int start)
+{
+	int i;
+
+	for (i = start; i < chain->nr; i++) {
+		struct callchain_list *call;
+
+		call = malloc(sizeof(*chain));
+		if (!call) {
+			perror("not enough memory for the code path tree");
+			return;
+		}
+		call->ip = chain->ips[i];
+		list_add_tail(&call->list, &node->val);
+	}
+	node->val_nr = i - start;
+}
+
+static void add_child(struct callchain_node *parent, struct ip_callchain *chain)
+{
+	struct callchain_node *new;
+
+	new = create_child(parent);
+	fill_node(new, chain, parent->val_nr);
+
+	new->hit = 1;
+}
+
+static void
+split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
+		struct callchain_list *to_split, int idx)
+{
+	struct callchain_node *new;
+
+	/* split */
+	new = create_child(parent);
+	list_move_tail(&to_split->list, &new->val);
+	new->hit = parent->hit;
+	parent->hit = 0;
+	parent->val_nr = idx;
+
+	/* create the new one */
+	add_child(parent, chain);
+}
+
+static int
+__append_chain(struct callchain_node *root, struct ip_callchain *chain,
+		int start);
+
+static int
+__append_chain_children(struct callchain_node *root, struct ip_callchain *chain)
+{
+	struct callchain_node *rnode;
+
+	/* lookup in childrens */
+	list_for_each_entry(rnode, &root->children, brothers) {
+		int ret = __append_chain(rnode, chain, root->val_nr);
+		if (!ret)
+			return 0;
+	}
+	return -1;
+}
+
+static int
+__append_chain(struct callchain_node *root, struct ip_callchain *chain,
+		int start)
+{
+	struct callchain_list *cnode;
+	int i = start;
+	bool found = false;
+
+	/* lookup in the current node */
+	list_for_each_entry(cnode, &root->val, list) {
+		if (cnode->ip != chain->ips[i++])
+			break;
+		if (!found)
+			found = true;
+		if (i == chain->nr)
+			break;
+	}
+
+	/* matches not, relay on the parent */
+	if (!found)
+		return -1;
+
+	/* we match only a part of the node. Split it and add the new chain */
+	if (i < root->val_nr) {
+		split_add_child(root, chain, cnode, i);
+		return 0;
+	}
+
+	/* we match 100% of the path, increment the hit */
+	if (i == root->val_nr) {
+		root->hit++;
+		return 0;
+	}
+
+	return __append_chain_children(root, chain);
+}
+
+void append_chain(struct callchain_node *root, struct ip_callchain *chain)
+{
+	if (__append_chain_children(root, chain) == -1)
+		add_child(root, chain);
+}
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
new file mode 100644
index 0000000..fa1cd2f
--- /dev/null
+++ b/tools/perf/util/callchain.h
@@ -0,0 +1,33 @@
+#ifndef __PERF_CALLCHAIN_H
+#define __PERF_CALLCHAIN_H
+
+#include "../perf.h"
+#include "list.h"
+#include "rbtree.h"
+
+
+struct callchain_node {
+	struct callchain_node	*parent;
+	struct list_head	brothers;
+	struct list_head 	children;
+	struct list_head 	val;
+	struct rb_node		rb_node;
+	int			val_nr;
+	int			hit;
+};
+
+struct callchain_list {
+	unsigned long		ip;
+	struct list_head	list;
+};
+
+static inline void callchain_init(struct callchain_node *node)
+{
+	INIT_LIST_HEAD(&node->brothers);
+	INIT_LIST_HEAD(&node->children);
+	INIT_LIST_HEAD(&node->val);
+}
+
+void append_chain(struct callchain_node *root, struct ip_callchain *chain);
+void sort_chain_to_rbtree(struct rb_root *rb_root, struct callchain_node *node);
+#endif
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
new file mode 100644
index 0000000..450384b
--- /dev/null
+++ b/tools/perf/util/header.c
@@ -0,0 +1,242 @@
+#include <sys/types.h>
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+
+#include "util.h"
+#include "header.h"
+
+/*
+ *
+ */
+
+struct perf_header_attr *perf_header_attr__new(struct perf_counter_attr *attr)
+{
+	struct perf_header_attr *self = malloc(sizeof(*self));
+
+	if (!self)
+		die("nomem");
+
+	self->attr = *attr;
+	self->ids = 0;
+	self->size = 1;
+	self->id = malloc(sizeof(u64));
+
+	if (!self->id)
+		die("nomem");
+
+	return self;
+}
+
+void perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
+{
+	int pos = self->ids;
+
+	self->ids++;
+	if (self->ids > self->size) {
+		self->size *= 2;
+		self->id = realloc(self->id, self->size * sizeof(u64));
+		if (!self->id)
+			die("nomem");
+	}
+	self->id[pos] = id;
+}
+
+/*
+ *
+ */
+
+struct perf_header *perf_header__new(void)
+{
+	struct perf_header *self = malloc(sizeof(*self));
+
+	if (!self)
+		die("nomem");
+
+	self->frozen = 0;
+
+	self->attrs = 0;
+	self->size = 1;
+	self->attr = malloc(sizeof(void *));
+
+	if (!self->attr)
+		die("nomem");
+
+	self->data_offset = 0;
+	self->data_size = 0;
+
+	return self;
+}
+
+void perf_header__add_attr(struct perf_header *self,
+			   struct perf_header_attr *attr)
+{
+	int pos = self->attrs;
+
+	if (self->frozen)
+		die("frozen");
+
+	self->attrs++;
+	if (self->attrs > self->size) {
+		self->size *= 2;
+		self->attr = realloc(self->attr, self->size * sizeof(void *));
+		if (!self->attr)
+			die("nomem");
+	}
+	self->attr[pos] = attr;
+}
+
+static const char *__perf_magic = "PERFFILE";
+
+#define PERF_MAGIC	(*(u64 *)__perf_magic)
+
+struct perf_file_section {
+	u64 offset;
+	u64 size;
+};
+
+struct perf_file_attr {
+	struct perf_counter_attr	attr;
+	struct perf_file_section	ids;
+};
+
+struct perf_file_header {
+	u64				magic;
+	u64				size;
+	u64				attr_size;
+	struct perf_file_section	attrs;
+	struct perf_file_section	data;
+};
+
+static void do_write(int fd, void *buf, size_t size)
+{
+	while (size) {
+		int ret = write(fd, buf, size);
+
+		if (ret < 0)
+			die("failed to write");
+
+		size -= ret;
+		buf += ret;
+	}
+}
+
+void perf_header__write(struct perf_header *self, int fd)
+{
+	struct perf_file_header f_header;
+	struct perf_file_attr   f_attr;
+	struct perf_header_attr	*attr;
+	int i;
+
+	lseek(fd, sizeof(f_header), SEEK_SET);
+
+
+	for (i = 0; i < self->attrs; i++) {
+		attr = self->attr[i];
+
+		attr->id_offset = lseek(fd, 0, SEEK_CUR);
+		do_write(fd, attr->id, attr->ids * sizeof(u64));
+	}
+
+
+	self->attr_offset = lseek(fd, 0, SEEK_CUR);
+
+	for (i = 0; i < self->attrs; i++) {
+		attr = self->attr[i];
+
+		f_attr = (struct perf_file_attr){
+			.attr = attr->attr,
+			.ids  = {
+				.offset = attr->id_offset,
+				.size   = attr->ids * sizeof(u64),
+			}
+		};
+		do_write(fd, &f_attr, sizeof(f_attr));
+	}
+
+
+	self->data_offset = lseek(fd, 0, SEEK_CUR);
+
+	f_header = (struct perf_file_header){
+		.magic	   = PERF_MAGIC,
+		.size	   = sizeof(f_header),
+		.attr_size = sizeof(f_attr),
+		.attrs = {
+			.offset = self->attr_offset,
+			.size   = self->attrs * sizeof(f_attr),
+		},
+		.data = {
+			.offset = self->data_offset,
+			.size	= self->data_size,
+		},
+	};
+
+	lseek(fd, 0, SEEK_SET);
+	do_write(fd, &f_header, sizeof(f_header));
+	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+
+	self->frozen = 1;
+}
+
+static void do_read(int fd, void *buf, size_t size)
+{
+	while (size) {
+		int ret = read(fd, buf, size);
+
+		if (ret < 0)
+			die("failed to read");
+
+		size -= ret;
+		buf += ret;
+	}
+}
+
+struct perf_header *perf_header__read(int fd)
+{
+	struct perf_header	*self = perf_header__new();
+	struct perf_file_header f_header;
+	struct perf_file_attr	f_attr;
+	u64			f_id;
+
+	int nr_attrs, nr_ids, i, j;
+
+	lseek(fd, 0, SEEK_SET);
+	do_read(fd, &f_header, sizeof(f_header));
+
+	if (f_header.magic	!= PERF_MAGIC		||
+	    f_header.size	!= sizeof(f_header)	||
+	    f_header.attr_size	!= sizeof(f_attr))
+		die("incompatible file format");
+
+	nr_attrs = f_header.attrs.size / sizeof(f_attr);
+	lseek(fd, f_header.attrs.offset, SEEK_SET);
+
+	for (i = 0; i < nr_attrs; i++) {
+		struct perf_header_attr *attr;
+		off_t tmp = lseek(fd, 0, SEEK_CUR);
+
+		do_read(fd, &f_attr, sizeof(f_attr));
+
+		attr = perf_header_attr__new(&f_attr.attr);
+
+		nr_ids = f_attr.ids.size / sizeof(u64);
+		lseek(fd, f_attr.ids.offset, SEEK_SET);
+
+		for (j = 0; j < nr_ids; j++) {
+			do_read(fd, &f_id, sizeof(f_id));
+
+			perf_header_attr__add_id(attr, f_id);
+		}
+		perf_header__add_attr(self, attr);
+		lseek(fd, tmp, SEEK_SET);
+	}
+
+	self->data_offset = f_header.data.offset;
+	self->data_size   = f_header.data.size;
+
+	lseek(fd, self->data_offset + self->data_size, SEEK_SET);
+
+	self->frozen = 1;
+
+	return self;
+}
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
new file mode 100644
index 0000000..b5ef53a
--- /dev/null
+++ b/tools/perf/util/header.h
@@ -0,0 +1,37 @@
+#ifndef _PERF_HEADER_H
+#define _PERF_HEADER_H
+
+#include "../../../include/linux/perf_counter.h"
+#include <sys/types.h>
+#include "types.h"
+
+struct perf_header_attr {
+	struct perf_counter_attr attr;
+	int ids, size;
+	u64 *id;
+	off_t id_offset;
+};
+
+struct perf_header {
+	int frozen;
+	int attrs, size;
+	struct perf_header_attr **attr;
+	off_t attr_offset;
+	u64 data_offset;
+	u64 data_size;
+};
+
+struct perf_header *perf_header__read(int fd);
+void perf_header__write(struct perf_header *self, int fd);
+
+void perf_header__add_attr(struct perf_header *self,
+			   struct perf_header_attr *attr);
+
+struct perf_header_attr *
+perf_header_attr__new(struct perf_counter_attr *attr);
+void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
+
+
+struct perf_header *perf_header__new(void);
+
+#endif /* _PERF_HEADER_H */
diff --git a/tools/perf/util/help.c b/tools/perf/util/help.c
index 6653f7d..17a00e0 100644
--- a/tools/perf/util/help.c
+++ b/tools/perf/util/help.c
@@ -126,21 +126,6 @@ static int is_executable(const char *name)
 	    !S_ISREG(st.st_mode))
 		return 0;
 
-#ifdef __MINGW32__
-	/* cannot trust the executable bit, peek into the file instead */
-	char buf[3] = { 0 };
-	int n;
-	int fd = open(name, O_RDONLY);
-	st.st_mode &= ~S_IXUSR;
-	if (fd >= 0) {
-		n = read(fd, buf, 2);
-		if (n == 2)
-			/* DOS executables start with "MZ" */
-			if (!strcmp(buf, "#!") || !strcmp(buf, "MZ"))
-				st.st_mode |= S_IXUSR;
-		close(fd);
-	}
-#endif
 	return st.st_mode & S_IXUSR;
 }
 
diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index a28bcca..1915de2 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -9,7 +9,6 @@
 
 static int spawned_pager;
 
-#ifndef __MINGW32__
 static void pager_preexec(void)
 {
 	/*
@@ -24,7 +23,6 @@ static void pager_preexec(void)
 
 	setenv("LESS", "FRSX", 0);
 }
-#endif
 
 static const char *pager_argv[] = { "sh", "-c", NULL, NULL };
 static struct child_process pager_process;
@@ -70,9 +68,8 @@ void setup_pager(void)
 	pager_argv[2] = pager;
 	pager_process.argv = pager_argv;
 	pager_process.in = -1;
-#ifndef __MINGW32__
 	pager_process.preexec_cb = pager_preexec;
-#endif
+
 	if (start_command(&pager_process))
 		return;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 35d04da..4d042f1 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -16,32 +16,28 @@ struct event_symbol {
 	u8	type;
 	u64	config;
 	char	*symbol;
+	char	*alias;
 };
 
-#define C(x, y) .type = PERF_TYPE_##x, .config = PERF_COUNT_##y
-#define CR(x, y) .type = PERF_TYPE_##x, .config = y
+#define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
+#define CSW(x) .type = PERF_TYPE_SOFTWARE, .config = PERF_COUNT_SW_##x
 
 static struct event_symbol event_symbols[] = {
-  { C(HARDWARE, HW_CPU_CYCLES),		"cpu-cycles",		},
-  { C(HARDWARE, HW_CPU_CYCLES),		"cycles",		},
-  { C(HARDWARE, HW_INSTRUCTIONS),	"instructions",		},
-  { C(HARDWARE, HW_CACHE_REFERENCES),	"cache-references",	},
-  { C(HARDWARE, HW_CACHE_MISSES),	"cache-misses",		},
-  { C(HARDWARE, HW_BRANCH_INSTRUCTIONS),"branch-instructions",	},
-  { C(HARDWARE, HW_BRANCH_INSTRUCTIONS),"branches",		},
-  { C(HARDWARE, HW_BRANCH_MISSES),	"branch-misses",	},
-  { C(HARDWARE, HW_BUS_CYCLES),		"bus-cycles",		},
-
-  { C(SOFTWARE, SW_CPU_CLOCK),		"cpu-clock",		},
-  { C(SOFTWARE, SW_TASK_CLOCK),		"task-clock",		},
-  { C(SOFTWARE, SW_PAGE_FAULTS),	"page-faults",		},
-  { C(SOFTWARE, SW_PAGE_FAULTS),	"faults",		},
-  { C(SOFTWARE, SW_PAGE_FAULTS_MIN),	"minor-faults",		},
-  { C(SOFTWARE, SW_PAGE_FAULTS_MAJ),	"major-faults",		},
-  { C(SOFTWARE, SW_CONTEXT_SWITCHES),	"context-switches",	},
-  { C(SOFTWARE, SW_CONTEXT_SWITCHES),	"cs",			},
-  { C(SOFTWARE, SW_CPU_MIGRATIONS),	"cpu-migrations",	},
-  { C(SOFTWARE, SW_CPU_MIGRATIONS),	"migrations",		},
+  { CHW(CPU_CYCLES),		"cpu-cycles",		"cycles"	},
+  { CHW(INSTRUCTIONS),		"instructions",		""		},
+  { CHW(CACHE_REFERENCES),	"cache-references",	""		},
+  { CHW(CACHE_MISSES),		"cache-misses",		""		},
+  { CHW(BRANCH_INSTRUCTIONS),	"branch-instructions",	"branches"	},
+  { CHW(BRANCH_MISSES),		"branch-misses",	""		},
+  { CHW(BUS_CYCLES),		"bus-cycles",		""		},
+
+  { CSW(CPU_CLOCK),		"cpu-clock",		""		},
+  { CSW(TASK_CLOCK),		"task-clock",		""		},
+  { CSW(PAGE_FAULTS),		"page-faults",		"faults"	},
+  { CSW(PAGE_FAULTS_MIN),	"minor-faults",		""		},
+  { CSW(PAGE_FAULTS_MAJ),	"major-faults",		""		},
+  { CSW(CONTEXT_SWITCHES),	"context-switches",	"cs"		},
+  { CSW(CPU_MIGRATIONS),	"cpu-migrations",	"migrations"	},
 };
 
 #define __PERF_COUNTER_FIELD(config, name) \
@@ -74,26 +70,70 @@ static char *sw_event_names[] = {
 
 #define MAX_ALIASES 8
 
-static char *hw_cache [][MAX_ALIASES] = {
-	{ "L1-data"		, "l1-d", "l1d"					},
-	{ "L1-instruction"	, "l1-i", "l1i"					},
-	{ "L2"			, "l2"						},
-	{ "Data-TLB"		, "dtlb", "d-tlb"				},
-	{ "Instruction-TLB"	, "itlb", "i-tlb"				},
-	{ "Branch"		, "bpu" , "btb", "bpc"				},
+static char *hw_cache[][MAX_ALIASES] = {
+ { "L1-d$",	"l1-d",		"l1d",		"L1-data",		},
+ { "L1-i$",	"l1-i",		"l1i",		"L1-instruction",	},
+ { "LLC",	"L2"							},
+ { "dTLB",	"d-tlb",	"Data-TLB",				},
+ { "iTLB",	"i-tlb",	"Instruction-TLB",			},
+ { "branch",	"branches",	"bpu",		"btb",		"bpc",	},
 };
 
-static char *hw_cache_op [][MAX_ALIASES] = {
-	{ "Load"		, "read"					},
-	{ "Store"		, "write"					},
-	{ "Prefetch"		, "speculative-read", "speculative-load"	},
+static char *hw_cache_op[][MAX_ALIASES] = {
+ { "load",	"loads",	"read",					},
+ { "store",	"stores",	"write",				},
+ { "prefetch",	"prefetches",	"speculative-read", "speculative-load",	},
 };
 
-static char *hw_cache_result [][MAX_ALIASES] = {
-	{ "Reference"		, "ops", "access"				},
-	{ "Miss"								},
+static char *hw_cache_result[][MAX_ALIASES] = {
+ { "refs",	"Reference",	"ops",		"access",		},
+ { "misses",	"miss",							},
 };
 
+#define C(x)		PERF_COUNT_HW_CACHE_##x
+#define CACHE_READ	(1 << C(OP_READ))
+#define CACHE_WRITE	(1 << C(OP_WRITE))
+#define CACHE_PREFETCH	(1 << C(OP_PREFETCH))
+#define COP(x)		(1 << x)
+
+/*
+ * cache operartion stat
+ * L1I : Read and prefetch only
+ * ITLB and BPU : Read-only
+ */
+static unsigned long hw_cache_stat[C(MAX)] = {
+ [C(L1D)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
+ [C(L1I)]	= (CACHE_READ | CACHE_PREFETCH),
+ [C(LL)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
+ [C(DTLB)]	= (CACHE_READ | CACHE_WRITE | CACHE_PREFETCH),
+ [C(ITLB)]	= (CACHE_READ),
+ [C(BPU)]	= (CACHE_READ),
+};
+
+static int is_cache_op_valid(u8 cache_type, u8 cache_op)
+{
+	if (hw_cache_stat[cache_type] & COP(cache_op))
+		return 1;	/* valid */
+	else
+		return 0;	/* invalid */
+}
+
+static char *event_cache_name(u8 cache_type, u8 cache_op, u8 cache_result)
+{
+	static char name[50];
+
+	if (cache_result) {
+		sprintf(name, "%s-%s-%s", hw_cache[cache_type][0],
+			hw_cache_op[cache_op][0],
+			hw_cache_result[cache_result][0]);
+	} else {
+		sprintf(name, "%s-%s", hw_cache[cache_type][0],
+			hw_cache_op[cache_op][1]);
+	}
+
+	return name;
+}
+
 char *event_name(int counter)
 {
 	u64 config = attrs[counter].config;
@@ -113,7 +153,6 @@ char *event_name(int counter)
 
 	case PERF_TYPE_HW_CACHE: {
 		u8 cache_type, cache_op, cache_result;
-		static char name[100];
 
 		cache_type   = (config >>  0) & 0xff;
 		if (cache_type > PERF_COUNT_HW_CACHE_MAX)
@@ -127,12 +166,10 @@ char *event_name(int counter)
 		if (cache_result > PERF_COUNT_HW_CACHE_RESULT_MAX)
 			return "unknown-ext-hardware-cache-result";
 
-		sprintf(name, "%s-Cache-%s-%ses",
-			hw_cache[cache_type][0],
-			hw_cache_op[cache_op][0],
-			hw_cache_result[cache_result][0]);
+		if (!is_cache_op_valid(cache_type, cache_op))
+			return "invalid-cache";
 
-		return name;
+		return event_cache_name(cache_type, cache_op, cache_result);
 	}
 
 	case PERF_TYPE_SOFTWARE:
@@ -163,7 +200,8 @@ static int parse_aliases(const char *str, char *names[][MAX_ALIASES], int size)
 	return -1;
 }
 
-static int parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
+static int
+parse_generic_hw_symbols(const char *str, struct perf_counter_attr *attr)
 {
 	int cache_type = -1, cache_op = 0, cache_result = 0;
 
@@ -182,6 +220,9 @@ static int parse_generic_hw_symbols(const char *str, struct perf_counter_attr *a
 	if (cache_op == -1)
 		cache_op = PERF_COUNT_HW_CACHE_OP_READ;
 
+	if (!is_cache_op_valid(cache_type, cache_op))
+		return -EINVAL;
+
 	cache_result = parse_aliases(str, hw_cache_result,
 					PERF_COUNT_HW_CACHE_RESULT_MAX);
 	/*
@@ -196,6 +237,19 @@ static int parse_generic_hw_symbols(const char *str, struct perf_counter_attr *a
 	return 0;
 }
 
+static int check_events(const char *str, unsigned int i)
+{
+	if (!strncmp(str, event_symbols[i].symbol,
+		     strlen(event_symbols[i].symbol)))
+		return 1;
+
+	if (strlen(event_symbols[i].alias))
+		if (!strncmp(str, event_symbols[i].alias,
+			     strlen(event_symbols[i].alias)))
+			return 1;
+	return 0;
+}
+
 /*
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
@@ -235,9 +289,7 @@ static int parse_event_symbols(const char *str, struct perf_counter_attr *attr)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(event_symbols); i++) {
-		if (!strncmp(str, event_symbols[i].symbol,
-			     strlen(event_symbols[i].symbol))) {
-
+		if (check_events(str, i)) {
 			attr->type = event_symbols[i].type;
 			attr->config = event_symbols[i].config;
 
@@ -289,6 +341,7 @@ void print_events(void)
 {
 	struct event_symbol *syms = event_symbols;
 	unsigned int i, type, prev_type = -1;
+	char name[40];
 
 	fprintf(stderr, "\n");
 	fprintf(stderr, "List of pre-defined events (to be used in -e):\n");
@@ -301,14 +354,18 @@ void print_events(void)
 		if (type != prev_type)
 			fprintf(stderr, "\n");
 
-		fprintf(stderr, "  %-30s [%s]\n", syms->symbol,
+		if (strlen(syms->alias))
+			sprintf(name, "%s OR %s", syms->symbol, syms->alias);
+		else
+			strcpy(name, syms->symbol);
+		fprintf(stderr, "  %-40s [%s]\n", name,
 			event_type_descriptors[type]);
 
 		prev_type = type;
 	}
 
 	fprintf(stderr, "\n");
-	fprintf(stderr, "  %-30s [raw hardware event descriptor]\n",
+	fprintf(stderr, "  %-40s [raw hardware event descriptor]\n",
 		"rNNN");
 	fprintf(stderr, "\n");
 
diff --git a/tools/perf/util/run-command.c b/tools/perf/util/run-command.c
index b2f5e85..a393534 100644
--- a/tools/perf/util/run-command.c
+++ b/tools/perf/util/run-command.c
@@ -65,7 +65,6 @@ int start_command(struct child_process *cmd)
 		cmd->err = fderr[0];
 	}
 
-#ifndef __MINGW32__
 	fflush(NULL);
 	cmd->pid = fork();
 	if (!cmd->pid) {
@@ -118,71 +117,6 @@ int start_command(struct child_process *cmd)
 		}
 		exit(127);
 	}
-#else
-	int s0 = -1, s1 = -1, s2 = -1;	/* backups of stdin, stdout, stderr */
-	const char **sargv = cmd->argv;
-	char **env = environ;
-
-	if (cmd->no_stdin) {
-		s0 = dup(0);
-		dup_devnull(0);
-	} else if (need_in) {
-		s0 = dup(0);
-		dup2(fdin[0], 0);
-	} else if (cmd->in) {
-		s0 = dup(0);
-		dup2(cmd->in, 0);
-	}
-
-	if (cmd->no_stderr) {
-		s2 = dup(2);
-		dup_devnull(2);
-	} else if (need_err) {
-		s2 = dup(2);
-		dup2(fderr[1], 2);
-	}
-
-	if (cmd->no_stdout) {
-		s1 = dup(1);
-		dup_devnull(1);
-	} else if (cmd->stdout_to_stderr) {
-		s1 = dup(1);
-		dup2(2, 1);
-	} else if (need_out) {
-		s1 = dup(1);
-		dup2(fdout[1], 1);
-	} else if (cmd->out > 1) {
-		s1 = dup(1);
-		dup2(cmd->out, 1);
-	}
-
-	if (cmd->dir)
-		die("chdir in start_command() not implemented");
-	if (cmd->env) {
-		env = copy_environ();
-		for (; *cmd->env; cmd->env++)
-			env = env_setenv(env, *cmd->env);
-	}
-
-	if (cmd->perf_cmd) {
-		cmd->argv = prepare_perf_cmd(cmd->argv);
-	}
-
-	cmd->pid = mingw_spawnvpe(cmd->argv[0], cmd->argv, env);
-
-	if (cmd->env)
-		free_environ(env);
-	if (cmd->perf_cmd)
-		free(cmd->argv);
-
-	cmd->argv = sargv;
-	if (s0 >= 0)
-		dup2(s0, 0), close(s0);
-	if (s1 >= 0)
-		dup2(s1, 1), close(s1);
-	if (s2 >= 0)
-		dup2(s2, 2), close(s2);
-#endif
 
 	if (cmd->pid < 0) {
 		int err = errno;
@@ -288,14 +222,6 @@ int run_command_v_opt_cd_env(const char **argv, int opt, const char *dir, const
 	return run_command(&cmd);
 }
 
-#ifdef __MINGW32__
-static __stdcall unsigned run_thread(void *data)
-{
-	struct async *async = data;
-	return async->proc(async->fd_for_proc, async->data);
-}
-#endif
-
 int start_async(struct async *async)
 {
 	int pipe_out[2];
@@ -304,7 +230,6 @@ int start_async(struct async *async)
 		return error("cannot create pipe: %s", strerror(errno));
 	async->out = pipe_out[0];
 
-#ifndef __MINGW32__
 	/* Flush stdio before fork() to avoid cloning buffers */
 	fflush(NULL);
 
@@ -319,33 +244,17 @@ int start_async(struct async *async)
 		exit(!!async->proc(pipe_out[1], async->data));
 	}
 	close(pipe_out[1]);
-#else
-	async->fd_for_proc = pipe_out[1];
-	async->tid = (HANDLE) _beginthreadex(NULL, 0, run_thread, async, 0, NULL);
-	if (!async->tid) {
-		error("cannot create thread: %s", strerror(errno));
-		close_pair(pipe_out);
-		return -1;
-	}
-#endif
+
 	return 0;
 }
 
 int finish_async(struct async *async)
 {
-#ifndef __MINGW32__
 	int ret = 0;
 
 	if (wait_or_whine(async->pid))
 		ret = error("waitpid (async) failed");
-#else
-	DWORD ret = 0;
-	if (WaitForSingleObject(async->tid, INFINITE) != WAIT_OBJECT_0)
-		ret = error("waiting for thread failed: %lu", GetLastError());
-	else if (!GetExitCodeThread(async->tid, &ret))
-		ret = error("cannot get thread exit code: %lu", GetLastError());
-	CloseHandle(async->tid);
-#endif
+
 	return ret;
 }
 
diff --git a/tools/perf/util/run-command.h b/tools/perf/util/run-command.h
index 328289f..cc1837d 100644
--- a/tools/perf/util/run-command.h
+++ b/tools/perf/util/run-command.h
@@ -79,12 +79,7 @@ struct async {
 	int (*proc)(int fd, void *data);
 	void *data;
 	int out;	/* caller reads from here and closes it */
-#ifndef __MINGW32__
 	pid_t pid;
-#else
-	HANDLE tid;
-	int fd_for_proc;
-#endif
 };
 
 int start_async(struct async *async);
diff --git a/tools/perf/util/strbuf.c b/tools/perf/util/strbuf.c
index eaba093..464e7ca 100644
--- a/tools/perf/util/strbuf.c
+++ b/tools/perf/util/strbuf.c
@@ -259,7 +259,7 @@ size_t strbuf_fread(struct strbuf *sb, size_t size, FILE *f)
 	res = fread(sb->buf + sb->len, 1, size, f);
 	if (res > 0)
 		strbuf_setlen(sb, sb->len + res);
-	else if (res < 0 && oldalloc == 0)
+	else if (oldalloc == 0)
 		strbuf_release(sb);
 	return res;
 }
diff --git a/tools/perf/util/string.h b/tools/perf/util/string.h
index 37b0325..3dca2f6 100644
--- a/tools/perf/util/string.h
+++ b/tools/perf/util/string.h
@@ -1,7 +1,7 @@
 #ifndef _PERF_STRING_H_
 #define _PERF_STRING_H_
 
-#include "../types.h"
+#include "types.h"
 
 int hex2u64(const char *ptr, u64 *val);
 
diff --git a/tools/perf/util/strlist.c b/tools/perf/util/strlist.c
new file mode 100644
index 0000000..025a78e
--- /dev/null
+++ b/tools/perf/util/strlist.c
@@ -0,0 +1,184 @@
+/*
+ * (c) 2009 Arnaldo Carvalho de Melo <acme@redhat.com>
+ *
+ * Licensed under the GPLv2.
+ */
+
+#include "strlist.h"
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+static struct str_node *str_node__new(const char *s, bool dupstr)
+{
+	struct str_node *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		if (dupstr) {
+			s = strdup(s);
+			if (s == NULL)
+				goto out_delete;
+		}
+		self->s = s;
+	}
+
+	return self;
+
+out_delete:
+	free(self);
+	return NULL;
+}
+
+static void str_node__delete(struct str_node *self, bool dupstr)
+{
+	if (dupstr)
+		free((void *)self->s);
+	free(self);
+}
+
+int strlist__add(struct strlist *self, const char *new_entry)
+{
+	struct rb_node **p = &self->entries.rb_node;
+	struct rb_node *parent = NULL;
+	struct str_node *sn;
+
+	while (*p != NULL) {
+		int rc;
+
+		parent = *p;
+		sn = rb_entry(parent, struct str_node, rb_node);
+		rc = strcmp(sn->s, new_entry);
+
+		if (rc > 0)
+			p = &(*p)->rb_left;
+		else if (rc < 0)
+			p = &(*p)->rb_right;
+		else
+			return -EEXIST;
+	}
+
+	sn = str_node__new(new_entry, self->dupstr);
+	if (sn == NULL)
+		return -ENOMEM;
+
+	rb_link_node(&sn->rb_node, parent, p);
+	rb_insert_color(&sn->rb_node, &self->entries);
+
+	return 0;
+}
+
+int strlist__load(struct strlist *self, const char *filename)
+{
+	char entry[1024];
+	int err;
+	FILE *fp = fopen(filename, "r");
+
+	if (fp == NULL)
+		return errno;
+
+	while (fgets(entry, sizeof(entry), fp) != NULL) {
+		const size_t len = strlen(entry);
+
+		if (len == 0)
+			continue;
+		entry[len - 1] = '\0';
+
+		err = strlist__add(self, entry);
+		if (err != 0)
+			goto out;
+	}
+
+	err = 0;
+out:
+	fclose(fp);
+	return err;
+}
+
+void strlist__remove(struct strlist *self, struct str_node *sn)
+{
+	rb_erase(&sn->rb_node, &self->entries);
+	str_node__delete(sn, self->dupstr);
+}
+
+bool strlist__has_entry(struct strlist *self, const char *entry)
+{
+	struct rb_node **p = &self->entries.rb_node;
+	struct rb_node *parent = NULL;
+
+	while (*p != NULL) {
+		struct str_node *sn;
+		int rc;
+
+		parent = *p;
+		sn = rb_entry(parent, struct str_node, rb_node);
+		rc = strcmp(sn->s, entry);
+
+		if (rc > 0)
+			p = &(*p)->rb_left;
+		else if (rc < 0)
+			p = &(*p)->rb_right;
+		else
+			return true;
+	}
+
+	return false;
+}
+
+static int strlist__parse_list_entry(struct strlist *self, const char *s)
+{
+	if (strncmp(s, "file://", 7) == 0)
+		return strlist__load(self, s + 7);
+
+	return strlist__add(self, s);
+}
+
+int strlist__parse_list(struct strlist *self, const char *s)
+{
+	char *sep;
+	int err;
+
+	while ((sep = strchr(s, ',')) != NULL) {
+		*sep = '\0';
+		err = strlist__parse_list_entry(self, s);
+		*sep = ',';
+		if (err != 0)
+			return err;
+		s = sep + 1;
+	}
+
+	return *s ? strlist__parse_list_entry(self, s) : 0;
+}
+
+struct strlist *strlist__new(bool dupstr, const char *slist)
+{
+	struct strlist *self = malloc(sizeof(*self));
+
+	if (self != NULL) {
+		self->entries = RB_ROOT;
+		self->dupstr = dupstr;
+		if (slist && strlist__parse_list(self, slist) != 0)
+			goto out_error;
+	}
+
+	return self;
+out_error:
+	free(self);
+	return NULL;
+}
+
+void strlist__delete(struct strlist *self)
+{
+	if (self != NULL) {
+		struct str_node *pos;
+		struct rb_node *next = rb_first(&self->entries);
+
+		while (next) {
+			pos = rb_entry(next, struct str_node, rb_node);
+			next = rb_next(&pos->rb_node);
+			strlist__remove(self, pos);
+		}
+		self->entries = RB_ROOT;
+		free(self);
+	}
+}
diff --git a/tools/perf/util/strlist.h b/tools/perf/util/strlist.h
new file mode 100644
index 0000000..2fb117f
--- /dev/null
+++ b/tools/perf/util/strlist.h
@@ -0,0 +1,32 @@
+#ifndef STRLIST_H_
+#define STRLIST_H_
+
+#include "rbtree.h"
+#include <stdbool.h>
+
+struct str_node {
+	struct rb_node rb_node;
+	const char     *s;
+};
+
+struct strlist {
+	struct rb_root entries;
+	bool dupstr;
+};
+
+struct strlist *strlist__new(bool dupstr, const char *slist);
+void strlist__delete(struct strlist *self);
+
+void strlist__remove(struct strlist *self, struct str_node *sn);
+int strlist__load(struct strlist *self, const char *filename);
+int strlist__add(struct strlist *self, const char *str);
+
+bool strlist__has_entry(struct strlist *self, const char *entry);
+
+static inline bool strlist__empty(const struct strlist *self)
+{
+	return rb_first(&self->entries) == NULL;
+}
+
+int strlist__parse_list(struct strlist *self, const char *s);
+#endif /* STRLIST_H_ */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 86e1437..78c2efd 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -520,7 +520,9 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 	nr_syms = shdr.sh_size / shdr.sh_entsize;
 
 	memset(&sym, 0, sizeof(sym));
-
+	self->prelinked = elf_section_by_name(elf, &ehdr, &shdr,
+					      ".gnu.prelink_undo",
+					      NULL) != NULL;
 	elf_symtab__for_each_symbol(syms, nr_syms, index, sym) {
 		struct symbol *f;
 		u64 obj_start;
@@ -535,7 +537,13 @@ static int dso__load_sym(struct dso *self, int fd, const char *name,
 		gelf_getshdr(sec, &shdr);
 		obj_start = sym.st_value;
 
-		sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+		if (self->prelinked) {
+			if (verbose >= 2)
+				printf("adjusting symbol: st_value: %Lx sh_addr: %Lx sh_offset: %Lx\n",
+					(u64)sym.st_value, (u64)shdr.sh_addr, (u64)shdr.sh_offset);
+
+			sym.st_value -= shdr.sh_addr - shdr.sh_offset;
+		}
 
 		f = symbol__new(sym.st_value, sym.st_size,
 				elf_sym__name(&sym, symstrs),
@@ -569,6 +577,8 @@ int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 	if (!name)
 		return -1;
 
+	self->prelinked = 0;
+
 	if (strncmp(self->name, "/tmp/perf-", 10) == 0)
 		return dso__load_perf_map(self, filter, verbose);
 
@@ -629,7 +639,7 @@ int dso__load_kernel(struct dso *self, const char *vmlinux,
 	if (vmlinux)
 		err = dso__load_vmlinux(self, vmlinux, filter, verbose);
 
-	if (err)
+	if (err < 0)
 		err = dso__load_kallsyms(self, filter, verbose);
 
 	return err;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index ea332e5..2c48ace 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -2,7 +2,7 @@
 #define _PERF_SYMBOL_ 1
 
 #include <linux/types.h>
-#include "../types.h"
+#include "types.h"
 #include "list.h"
 #include "rbtree.h"
 
@@ -20,8 +20,9 @@ struct symbol {
 struct dso {
 	struct list_head node;
 	struct rb_root	 syms;
-	unsigned int	 sym_priv_size;
 	struct symbol    *(*find_symbol)(struct dso *, u64 ip);
+	unsigned int	 sym_priv_size;
+	unsigned char	 prelinked;
 	char		 name[0];
 };
 
diff --git a/tools/perf/types.h b/tools/perf/util/types.h
similarity index 100%
rename from tools/perf/types.h
rename to tools/perf/util/types.h
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index b8cfed7..b4be607 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -67,7 +67,6 @@
 #include <assert.h>
 #include <regex.h>
 #include <utime.h>
-#ifndef __MINGW32__
 #include <sys/wait.h>
 #include <sys/poll.h>
 #include <sys/socket.h>
@@ -81,20 +80,6 @@
 #include <netdb.h>
 #include <pwd.h>
 #include <inttypes.h>
-#if defined(__CYGWIN__)
-#undef _XOPEN_SOURCE
-#include <grp.h>
-#define _XOPEN_SOURCE 600
-#include "compat/cygwin.h"
-#else
-#undef _ALL_SOURCE /* AIX 5.3L defines a struct list with _ALL_SOURCE. */
-#include <grp.h>
-#define _ALL_SOURCE 1
-#endif
-#else 	/* __MINGW32__ */
-/* pull in Windows compatibility stuff */
-#include "compat/mingw.h"
-#endif	/* __MINGW32__ */
 
 #ifndef NO_ICONV
 #include <iconv.h>
