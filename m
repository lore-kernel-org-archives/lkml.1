Return-Path: <linux-kernel-owner+w=401wt.eu-S1752572AbZISUId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbZISUId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 16:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbZISUId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 16:08:33 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44809 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200AbZISUI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 16:08:27 -0400
Date: Sat, 19 Sep 2009 22:08:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: [GIT PULL] perfcounters for v2.6.32, part 2
Message-ID: <20090919200800.GA14777@elte.hu>
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

Please pull the latest perfcounters-core-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-core-for-linus

This is the second (final) bit of perfcounter updates. Amongst other 
things it adds two new tools: 'perf timeline' (boot and runtime time 
analysis based on SVGs), and 'perf sched' (a family of text based tools 
for scheduler analysis). It also rounds up BTS support.

Note, two commits with 'mingo' as the author snuck in from a box where i 
did not have Git set up properly:

 mingo (2):
      perf sched: Print PIDs too
      perf sched: Add support for sched:sched_stat_runtime events

The signoff line is correct, but can redo the tree if these commits are 
a problem. Should not occur in the future.

 Thanks,

	Ingo

------------------>
Arjan van de Ven (12):
      perf: Add a timestamp to fork events
      perf: Store trace event name/id pairs in perf.data
      perf: Allow perf utilities to have "callback" options without arguments
      perf: Add a sample_event type to the event_union
      tracing, perf: Convert the power tracer into an event tracer
      perf: Add a SVG helper library file
      perf: Add the timechart tool
      perf timechart: Add "perf timechart record"
      perf utils: Be consistent about minimum text size in the svghelper
      tracing, x86, cpuidle: Move the end point of a C state in the power tracer
      perf: Add timechart help text and add timechart to "perf help"
      perf utils: Use a define for the maximum length of a trace event

Frederic Weisbecker (11):
      perf tools: Allow the specification of all tracepoints at once
      perf sched: Fix bad event alignment
      perf sched: Make it easier to plug in new sub profilers
      perf sched: Add sched latency profiling
      perf sched: Rename struct lat_snapshot to struct work atoms
      perf sched: Add involuntarily sleeping task in work atoms
      perf sched: Export the total, max latency and total runtime to thread atoms list
      perf sched: Fix nsec to msec conversion
      perf sched: Implement multidimensional sorting
      perf tools: Add an option to multiplex counters in a single channel
      perf tools: Fix processing of randomly serialized sched traces

Ian Schram (1):
      perf_counter: Fix perf_copy_attr() pointer arithmetic

Ingo Molnar (22):
      perf: Add 'perf sched' tool
      perf sched: Import schedbench.c
      perf sched: Implement the scheduling workload replay engine
      perf sched: Tighten up the code
      perf sched: Clean up latency and replay sub-commands
      perf sched: Display time in milliseconds, reorganize output
      perf sched: Add runtime stats
      perf sched: Output runtime and context switch totals
      perf sched: Add 'perf sched latency' and 'perf sched replay'
      perf sched: Finish latency => atom rename and misc cleanups
      perf sched: Clean up PID sorting logic
      perf sched: Implement the 'perf sched record' subcommand
      perf_counter: Allow mmap if paranoid checks are turned off
      perf sched: Add 'perf sched trace', improve documentation
      perf_counter, sched: Add sched_stat_runtime tracepoint
      perf tools: Implement counter output multiplexing
      perf sched: Fix 'perf sched latency' output on 32-bit systems
      perf sched: Account for lost events, increase default buffering
      perf sched: Sanity check context switch events
      perf sched: Make idle thread and comm/pid names more consistent
      perf sched: Add 'perf sched map' scheduling event map printout
      perf sched: Determine the number of CPUs automatically

Li Zefan (3):
      perf tools: Fix memory leak in read_ftrace_printk()
      perf tools: Increase MAX_EVENT_LENGTH
      perf trace: Sample timestamp and cpu when using record flag

Markus Metzger (1):
      x86, perf_counter, bts: Optimize BTS overflow handling

Mike Galbraith (1):
      perf sched: Add --input=file option to builtin-sched.c

Peter Zijlstra (5):
      perf_counter: Do not throttle single swcounter events
      perf_counter: Allow for a wakeup watermark
      perf record: Disable profiling before draining the buffer
      perf_counter: Fix up swcounter throttling
      sched_clock: Make it NMI safe

mingo (2):
      perf sched: Print PIDs too
      perf sched: Add support for sched:sched_stat_runtime events


 Documentation/trace/power.txt               |   17 -
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c  |    7 +-
 arch/x86/kernel/cpu/perf_counter.c          |   60 +-
 arch/x86/kernel/process.c                   |   25 +-
 drivers/cpuidle/cpuidle.c                   |    2 +
 include/linux/perf_counter.h                |   80 +-
 include/trace/events/power.h                |   81 ++
 include/trace/events/sched.h                |   33 +
 kernel/perf_counter.c                       |  394 +++---
 kernel/sched_clock.c                        |  122 +-
 kernel/sched_fair.c                         |    1 +
 kernel/trace/Makefile                       |    2 +-
 kernel/trace/power-traces.c                 |   20 +
 kernel/trace/trace.h                        |    3 -
 kernel/trace/trace_entries.h                |   17 -
 kernel/trace/trace_power.c                  |  218 ---
 scripts/tracing/power.pl                    |  108 --
 tools/perf/Documentation/perf-sched.txt     |   41 +
 tools/perf/Documentation/perf-timechart.txt |   35 +
 tools/perf/Documentation/perf-trace.txt     |   25 +
 tools/perf/Makefile                         |    9 +
 tools/perf/builtin-record.c                 |   56 +-
 tools/perf/builtin-sched.c                  | 2004 +++++++++++++++++++++++++++
 tools/perf/builtin-timechart.c              | 1151 +++++++++++++++
 tools/perf/builtin.h                        |    6 +-
 tools/perf/command-list.txt                 |    3 +
 tools/perf/perf.c                           |    2 +
 tools/perf/util/event.h                     |   10 +-
 tools/perf/util/header.c                    |   67 +-
 tools/perf/util/header.h                    |    6 +
 tools/perf/util/parse-events.c              |  237 +++-
 tools/perf/util/parse-options.h             |    2 +
 tools/perf/util/svghelper.c                 |  384 +++++
 tools/perf/util/svghelper.h                 |   25 +
 tools/perf/util/thread.c                    |    4 +-
 tools/perf/util/thread.h                    |    9 +-
 tools/perf/util/trace-event-info.c          |    7 +-
 tools/perf/util/trace-event-parse.c         |   45 +-
 tools/perf/util/trace-event-read.c          |    6 +-
 tools/perf/util/trace-event.h               |    5 +
 40 files changed, 4570 insertions(+), 759 deletions(-)
 delete mode 100644 Documentation/trace/power.txt
 create mode 100644 include/trace/events/power.h
 create mode 100644 kernel/trace/power-traces.c
 delete mode 100644 kernel/trace/trace_power.c
 delete mode 100644 scripts/tracing/power.pl
 create mode 100644 tools/perf/Documentation/perf-sched.txt
 create mode 100644 tools/perf/Documentation/perf-timechart.txt
 create mode 100644 tools/perf/Documentation/perf-trace.txt
 create mode 100644 tools/perf/builtin-sched.c
 create mode 100644 tools/perf/builtin-timechart.c
 create mode 100644 tools/perf/util/svghelper.c
 create mode 100644 tools/perf/util/svghelper.h

diff --git a/Documentation/trace/power.txt b/Documentation/trace/power.txt
deleted file mode 100644
index cd805e1..0000000
--- a/Documentation/trace/power.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-The power tracer collects detailed information about C-state and P-state
-transitions, instead of just looking at the high-level "average"
-information.
-
-There is a helper script found in scrips/tracing/power.pl in the kernel
-sources which can be used to parse this information and create a
-Scalable Vector Graphics (SVG) picture from the trace data.
-
-To use this tracer:
-
-	echo 0 > /sys/kernel/debug/tracing/tracing_enabled
-	echo power > /sys/kernel/debug/tracing/current_tracer
-	echo 1 > /sys/kernel/debug/tracing/tracing_enabled
-	sleep 1
-	echo 0 > /sys/kernel/debug/tracing/tracing_enabled
-	cat /sys/kernel/debug/tracing/trace | \
-		perl scripts/tracing/power.pl > out.sv
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 4109679..479cc8c 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -33,7 +33,7 @@
 #include <linux/cpufreq.h>
 #include <linux/compiler.h>
 #include <linux/dmi.h>
-#include <trace/power.h>
+#include <trace/events/power.h>
 
 #include <linux/acpi.h>
 #include <linux/io.h>
@@ -72,8 +72,6 @@ static DEFINE_PER_CPU(struct acpi_cpufreq_data *, drv_data);
 
 static DEFINE_PER_CPU(struct aperfmperf, old_perf);
 
-DEFINE_TRACE(power_mark);
-
 /* acpi_perf_data is a pointer to percpu data. */
 static struct acpi_processor_performance *acpi_perf_data;
 
@@ -332,7 +330,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	unsigned int next_perf_state = 0; /* Index into perf table */
 	unsigned int i;
 	int result = 0;
-	struct power_trace it;
 
 	dprintk("acpi_cpufreq_target %d (%d)\n", target_freq, policy->cpu);
 
@@ -364,7 +361,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		}
 	}
 
-	trace_power_mark(&it, POWER_PSTATE, next_perf_state);
+	trace_power_frequency(POWER_PSTATE, data->freq_table[next_state].frequency);
 
 	switch (data->cpu_feature) {
 	case SYSTEM_INTEL_MSR_CAPABLE:
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 2732e2c..dbdf712 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -36,10 +36,10 @@ static u64 perf_counter_mask __read_mostly;
 #define BTS_RECORD_SIZE		24
 
 /* The size of a per-cpu BTS buffer in bytes: */
-#define BTS_BUFFER_SIZE		(BTS_RECORD_SIZE * 1024)
+#define BTS_BUFFER_SIZE		(BTS_RECORD_SIZE * 2048)
 
 /* The BTS overflow threshold in bytes from the end of the buffer: */
-#define BTS_OVFL_TH		(BTS_RECORD_SIZE * 64)
+#define BTS_OVFL_TH		(BTS_RECORD_SIZE * 128)
 
 
 /*
@@ -1488,8 +1488,7 @@ void perf_counter_print_debug(void)
 	local_irq_restore(flags);
 }
 
-static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc,
-				       struct perf_sample_data *data)
+static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc)
 {
 	struct debug_store *ds = cpuc->ds;
 	struct bts_record {
@@ -1498,8 +1497,11 @@ static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc,
 		u64	flags;
 	};
 	struct perf_counter *counter = cpuc->counters[X86_PMC_IDX_FIXED_BTS];
-	unsigned long orig_ip = data->regs->ip;
 	struct bts_record *at, *top;
+	struct perf_output_handle handle;
+	struct perf_event_header header;
+	struct perf_sample_data data;
+	struct pt_regs regs;
 
 	if (!counter)
 		return;
@@ -1510,19 +1512,38 @@ static void intel_pmu_drain_bts_buffer(struct cpu_hw_counters *cpuc,
 	at  = (struct bts_record *)(unsigned long)ds->bts_buffer_base;
 	top = (struct bts_record *)(unsigned long)ds->bts_index;
 
+	if (top <= at)
+		return;
+
 	ds->bts_index = ds->bts_buffer_base;
 
+
+	data.period	= counter->hw.last_period;
+	data.addr	= 0;
+	regs.ip		= 0;
+
+	/*
+	 * Prepare a generic sample, i.e. fill in the invariant fields.
+	 * We will overwrite the from and to address before we output
+	 * the sample.
+	 */
+	perf_prepare_sample(&header, &data, counter, &regs);
+
+	if (perf_output_begin(&handle, counter,
+			      header.size * (top - at), 1, 1))
+		return;
+
 	for (; at < top; at++) {
-		data->regs->ip	= at->from;
-		data->addr	= at->to;
+		data.ip		= at->from;
+		data.addr	= at->to;
 
-		perf_counter_output(counter, 1, data);
+		perf_output_sample(&handle, &header, &data, counter);
 	}
 
-	data->regs->ip	= orig_ip;
-	data->addr	= 0;
+	perf_output_end(&handle);
 
 	/* There's new data available. */
+	counter->hw.interrupts++;
 	counter->pending_kill = POLL_IN;
 }
 
@@ -1552,13 +1573,9 @@ static void x86_pmu_disable(struct perf_counter *counter)
 	x86_perf_counter_update(counter, hwc, idx);
 
 	/* Drain the remaining BTS records. */
-	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS)) {
-		struct perf_sample_data data;
-		struct pt_regs regs;
+	if (unlikely(idx == X86_PMC_IDX_FIXED_BTS))
+		intel_pmu_drain_bts_buffer(cpuc);
 
-		data.regs = &regs;
-		intel_pmu_drain_bts_buffer(cpuc, &data);
-	}
 	cpuc->counters[idx] = NULL;
 	clear_bit(idx, cpuc->used_mask);
 
@@ -1619,7 +1636,6 @@ static int p6_pmu_handle_irq(struct pt_regs *regs)
 	int idx, handled = 0;
 	u64 val;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -1644,7 +1660,7 @@ static int p6_pmu_handle_irq(struct pt_regs *regs)
 		if (!x86_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			p6_pmu_disable_counter(hwc, idx);
 	}
 
@@ -1665,13 +1681,12 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	int bit, loops;
 	u64 ack, status;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
 
 	perf_disable();
-	intel_pmu_drain_bts_buffer(cpuc, &data);
+	intel_pmu_drain_bts_buffer(cpuc);
 	status = intel_pmu_get_status();
 	if (!status) {
 		perf_enable();
@@ -1702,7 +1717,7 @@ again:
 
 		data.period = counter->hw.last_period;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			intel_pmu_disable_counter(&counter->hw, bit);
 	}
 
@@ -1729,7 +1744,6 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 	int idx, handled = 0;
 	u64 val;
 
-	data.regs = regs;
 	data.addr = 0;
 
 	cpuc = &__get_cpu_var(cpu_hw_counters);
@@ -1754,7 +1768,7 @@ static int amd_pmu_handle_irq(struct pt_regs *regs)
 		if (!x86_perf_counter_set_period(counter, hwc, idx))
 			continue;
 
-		if (perf_counter_overflow(counter, 1, &data))
+		if (perf_counter_overflow(counter, 1, &data, regs))
 			amd_pmu_disable_counter(hwc, idx);
 	}
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 071166a..847ab41 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -9,7 +9,7 @@
 #include <linux/pm.h>
 #include <linux/clockchips.h>
 #include <linux/random.h>
-#include <trace/power.h>
+#include <trace/events/power.h>
 #include <asm/system.h>
 #include <asm/apic.h>
 #include <asm/syscalls.h>
@@ -25,9 +25,6 @@ EXPORT_SYMBOL(idle_nomwait);
 
 struct kmem_cache *task_xstate_cachep;
 
-DEFINE_TRACE(power_start);
-DEFINE_TRACE(power_end);
-
 int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 {
 	*dst = *src;
@@ -299,9 +296,7 @@ static inline int hlt_use_halt(void)
 void default_idle(void)
 {
 	if (hlt_use_halt()) {
-		struct power_trace it;
-
-		trace_power_start(&it, POWER_CSTATE, 1);
+		trace_power_start(POWER_CSTATE, 1);
 		current_thread_info()->status &= ~TS_POLLING;
 		/*
 		 * TS_POLLING-cleared state must be visible before we
@@ -314,7 +309,6 @@ void default_idle(void)
 		else
 			local_irq_enable();
 		current_thread_info()->status |= TS_POLLING;
-		trace_power_end(&it);
 	} else {
 		local_irq_enable();
 		/* loop is done by the caller */
@@ -372,9 +366,7 @@ EXPORT_SYMBOL_GPL(cpu_idle_wait);
  */
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
-	struct power_trace it;
-
-	trace_power_start(&it, POWER_CSTATE, (ax>>4)+1);
+	trace_power_start(POWER_CSTATE, (ax>>4)+1);
 	if (!need_resched()) {
 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
@@ -384,15 +376,13 @@ void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 		if (!need_resched())
 			__mwait(ax, cx);
 	}
-	trace_power_end(&it);
 }
 
 /* Default MONITOR/MWAIT with no hints, used for default C1 state */
 static void mwait_idle(void)
 {
-	struct power_trace it;
 	if (!need_resched()) {
-		trace_power_start(&it, POWER_CSTATE, 1);
+		trace_power_start(POWER_CSTATE, 1);
 		if (cpu_has(&current_cpu_data, X86_FEATURE_CLFLUSH_MONITOR))
 			clflush((void *)&current_thread_info()->flags);
 
@@ -402,7 +392,6 @@ static void mwait_idle(void)
 			__sti_mwait(0, 0);
 		else
 			local_irq_enable();
-		trace_power_end(&it);
 	} else
 		local_irq_enable();
 }
@@ -414,13 +403,11 @@ static void mwait_idle(void)
  */
 static void poll_idle(void)
 {
-	struct power_trace it;
-
-	trace_power_start(&it, POWER_CSTATE, 0);
+	trace_power_start(POWER_CSTATE, 0);
 	local_irq_enable();
 	while (!need_resched())
 		cpu_relax();
-	trace_power_end(&it);
+	trace_power_end(0);
 }
 
 /*
diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index 8504a21..ad41f19 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -17,6 +17,7 @@
 #include <linux/cpuidle.h>
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
+#include <trace/events/power.h>
 
 #include "cpuidle.h"
 
@@ -91,6 +92,7 @@ static void cpuidle_idle_call(void)
 	/* give the governor an opportunity to reflect on the outcome */
 	if (cpuidle_curr_governor->reflect)
 		cpuidle_curr_governor->reflect(dev);
+	trace_power_end(0);
 }
 
 /**
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 972f90d..bd34100 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -199,10 +199,14 @@ struct perf_counter_attr {
 				inherit_stat   :  1, /* per task counts       */
 				enable_on_exec :  1, /* next exec enables     */
 				task           :  1, /* trace fork/exit       */
+				watermark      :  1, /* wakeup_watermark      */
 
-				__reserved_1   : 50;
+				__reserved_1   : 49;
 
-	__u32			wakeup_events;	/* wakeup every n events */
+	union {
+		__u32		wakeup_events;	  /* wakeup every n events */
+		__u32		wakeup_watermark; /* bytes before wakeup   */
+	};
 	__u32			__reserved_2;
 
 	__u64			__reserved_3;
@@ -332,6 +336,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
+	 *	u64				time;
 	 * };
 	 */
 	PERF_EVENT_EXIT			= 4,
@@ -352,6 +357,7 @@ enum perf_event_type {
 	 *	struct perf_event_header	header;
 	 *	u32				pid, ppid;
 	 *	u32				tid, ptid;
+	 *	{ u64				time;     } && PERF_SAMPLE_TIME
 	 * };
 	 */
 	PERF_EVENT_FORK			= 7,
@@ -521,6 +527,8 @@ struct perf_mmap_data {
 	atomic_t			wakeup;		/* needs a wakeup    */
 	atomic_t			lost;		/* nr records lost   */
 
+	long				watermark;	/* wakeup watermark  */
+
 	struct perf_counter_mmap_page   *user_page;
 	void				*data_pages[0];
 };
@@ -685,6 +693,17 @@ struct perf_cpu_context {
 	int				recursion[4];
 };
 
+struct perf_output_handle {
+	struct perf_counter	*counter;
+	struct perf_mmap_data	*data;
+	unsigned long		head;
+	unsigned long		offset;
+	int			nmi;
+	int			sample;
+	int			locked;
+	unsigned long		flags;
+};
+
 #ifdef CONFIG_PERF_COUNTERS
 
 /*
@@ -716,16 +735,38 @@ extern int hw_perf_group_sched_in(struct perf_counter *group_leader,
 extern void perf_counter_update_userpage(struct perf_counter *counter);
 
 struct perf_sample_data {
-	struct pt_regs			*regs;
+	u64				type;
+
+	u64				ip;
+	struct {
+		u32	pid;
+		u32	tid;
+	}				tid_entry;
+	u64				time;
 	u64				addr;
+	u64				id;
+	u64				stream_id;
+	struct {
+		u32	cpu;
+		u32	reserved;
+	}				cpu_entry;
 	u64				period;
+	struct perf_callchain_entry	*callchain;
 	struct perf_raw_record		*raw;
 };
 
+extern void perf_output_sample(struct perf_output_handle *handle,
+			       struct perf_event_header *header,
+			       struct perf_sample_data *data,
+			       struct perf_counter *counter);
+extern void perf_prepare_sample(struct perf_event_header *header,
+				struct perf_sample_data *data,
+				struct perf_counter *counter,
+				struct pt_regs *regs);
+
 extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
-				 struct perf_sample_data *data);
-extern void perf_counter_output(struct perf_counter *counter, int nmi,
-				struct perf_sample_data *data);
+				 struct perf_sample_data *data,
+				 struct pt_regs *regs);
 
 /*
  * Return 1 for a software counter, 0 for a hardware counter
@@ -775,6 +816,12 @@ extern void perf_tpcounter_event(int event_id, u64 addr, u64 count,
 #define perf_instruction_pointer(regs)	instruction_pointer(regs)
 #endif
 
+extern int perf_output_begin(struct perf_output_handle *handle,
+			     struct perf_counter *counter, unsigned int size,
+			     int nmi, int sample);
+extern void perf_output_end(struct perf_output_handle *handle);
+extern void perf_output_copy(struct perf_output_handle *handle,
+			     const void *buf, unsigned int len);
 #else
 static inline void
 perf_counter_task_sched_in(struct task_struct *task, int cpu)		{ }
@@ -801,7 +848,28 @@ static inline void perf_counter_mmap(struct vm_area_struct *vma)	{ }
 static inline void perf_counter_comm(struct task_struct *tsk)		{ }
 static inline void perf_counter_fork(struct task_struct *tsk)		{ }
 static inline void perf_counter_init(void)				{ }
+
+static inline int
+perf_output_begin(struct perf_output_handle *handle, struct perf_counter *c,
+		  unsigned int size, int nmi, int sample)		{ }
+static inline void perf_output_end(struct perf_output_handle *handle)	{ }
+static inline void
+perf_output_copy(struct perf_output_handle *handle,
+		 const void *buf, unsigned int len)			{ }
+static inline void
+perf_output_sample(struct perf_output_handle *handle,
+		   struct perf_event_header *header,
+		   struct perf_sample_data *data,
+		   struct perf_counter *counter)			{ }
+static inline void
+perf_prepare_sample(struct perf_event_header *header,
+		    struct perf_sample_data *data,
+		    struct perf_counter *counter,
+		    struct pt_regs *regs)				{ }
 #endif
 
+#define perf_output_put(handle, x) \
+	perf_output_copy((handle), &(x), sizeof(x))
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_PERF_COUNTER_H */
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
new file mode 100644
index 0000000..ea6d579
--- /dev/null
+++ b/include/trace/events/power.h
@@ -0,0 +1,81 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM power
+
+#if !defined(_TRACE_POWER_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_POWER_H
+
+#include <linux/ktime.h>
+#include <linux/tracepoint.h>
+
+#ifndef _TRACE_POWER_ENUM_
+#define _TRACE_POWER_ENUM_
+enum {
+	POWER_NONE = 0,
+	POWER_CSTATE = 1,
+	POWER_PSTATE = 2,
+};
+#endif
+
+
+
+TRACE_EVENT(power_start,
+
+	TP_PROTO(unsigned int type, unsigned int state),
+
+	TP_ARGS(type, state),
+
+	TP_STRUCT__entry(
+		__field(	u64,		type		)
+		__field(	u64,		state		)
+	),
+
+	TP_fast_assign(
+		__entry->type = type;
+		__entry->state = state;
+	),
+
+	TP_printk("type=%lu state=%lu", (unsigned long)__entry->type, (unsigned long)__entry->state)
+);
+
+TRACE_EVENT(power_end,
+
+	TP_PROTO(int dummy),
+
+	TP_ARGS(dummy),
+
+	TP_STRUCT__entry(
+		__field(	u64,		dummy		)
+	),
+
+	TP_fast_assign(
+		__entry->dummy = 0xffff;
+	),
+
+	TP_printk("dummy=%lu", (unsigned long)__entry->dummy)
+
+);
+
+
+TRACE_EVENT(power_frequency,
+
+	TP_PROTO(unsigned int type, unsigned int state),
+
+	TP_ARGS(type, state),
+
+	TP_STRUCT__entry(
+		__field(	u64,		type		)
+		__field(	u64,		state		)
+	),
+
+	TP_fast_assign(
+		__entry->type = type;
+		__entry->state = state;
+	),
+
+	TP_printk("type=%lu state=%lu", (unsigned long)__entry->type, (unsigned long) __entry->state)
+);
+
+#endif /* _TRACE_POWER_H */
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index b48f1ad..4069c43 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -380,6 +380,39 @@ TRACE_EVENT(sched_stat_wait,
 );
 
 /*
+ * Tracepoint for accounting runtime (time the task is executing
+ * on a CPU).
+ */
+TRACE_EVENT(sched_stat_runtime,
+
+	TP_PROTO(struct task_struct *tsk, u64 runtime, u64 vruntime),
+
+	TP_ARGS(tsk, runtime, vruntime),
+
+	TP_STRUCT__entry(
+		__array( char,	comm,	TASK_COMM_LEN	)
+		__field( pid_t,	pid			)
+		__field( u64,	runtime			)
+		__field( u64,	vruntime			)
+	),
+
+	TP_fast_assign(
+		memcpy(__entry->comm, tsk->comm, TASK_COMM_LEN);
+		__entry->pid		= tsk->pid;
+		__entry->runtime	= runtime;
+		__entry->vruntime	= vruntime;
+	)
+	TP_perf_assign(
+		__perf_count(runtime);
+	),
+
+	TP_printk("task: %s:%d runtime: %Lu [ns], vruntime: %Lu [ns]",
+			__entry->comm, __entry->pid,
+			(unsigned long long)__entry->runtime,
+			(unsigned long long)__entry->vruntime)
+);
+
+/*
  * Tracepoint for accounting sleep time (time the task is not runnable,
  * including iowait, see below).
  */
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 8cb94a5..cc768ab 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2176,6 +2176,13 @@ static int perf_mmap_data_alloc(struct perf_counter *counter, int nr_pages)
 	data->nr_pages = nr_pages;
 	atomic_set(&data->lock, -1);
 
+	if (counter->attr.watermark) {
+		data->watermark = min_t(long, PAGE_SIZE * nr_pages,
+				      counter->attr.wakeup_watermark);
+	}
+	if (!data->watermark)
+		data->watermark = max(PAGE_SIZE, PAGE_SIZE * nr_pages / 4);
+
 	rcu_assign_pointer(counter->data, data);
 
 	return 0;
@@ -2315,7 +2322,8 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	lock_limit >>= PAGE_SHIFT;
 	locked = vma->vm_mm->locked_vm + extra;
 
-	if ((locked > lock_limit) && !capable(CAP_IPC_LOCK)) {
+	if ((locked > lock_limit) && perf_paranoid_tracepoint_raw() &&
+		!capable(CAP_IPC_LOCK)) {
 		ret = -EPERM;
 		goto unlock;
 	}
@@ -2504,35 +2512,15 @@ __weak struct perf_callchain_entry *perf_callchain(struct pt_regs *regs)
 /*
  * Output
  */
-
-struct perf_output_handle {
-	struct perf_counter	*counter;
-	struct perf_mmap_data	*data;
-	unsigned long		head;
-	unsigned long		offset;
-	int			nmi;
-	int			sample;
-	int			locked;
-	unsigned long		flags;
-};
-
-static bool perf_output_space(struct perf_mmap_data *data,
-			      unsigned int offset, unsigned int head)
+static bool perf_output_space(struct perf_mmap_data *data, unsigned long tail,
+			      unsigned long offset, unsigned long head)
 {
-	unsigned long tail;
 	unsigned long mask;
 
 	if (!data->writable)
 		return true;
 
 	mask = (data->nr_pages << PAGE_SHIFT) - 1;
-	/*
-	 * Userspace could choose to issue a mb() before updating the tail
-	 * pointer. So that all reads will be completed before the write is
-	 * issued.
-	 */
-	tail = ACCESS_ONCE(data->user_page->data_tail);
-	smp_rmb();
 
 	offset = (offset - tail) & mask;
 	head   = (head   - tail) & mask;
@@ -2633,8 +2621,8 @@ out:
 	local_irq_restore(handle->flags);
 }
 
-static void perf_output_copy(struct perf_output_handle *handle,
-			     const void *buf, unsigned int len)
+void perf_output_copy(struct perf_output_handle *handle,
+		      const void *buf, unsigned int len)
 {
 	unsigned int pages_mask;
 	unsigned int offset;
@@ -2669,16 +2657,13 @@ static void perf_output_copy(struct perf_output_handle *handle,
 	WARN_ON_ONCE(((long)(handle->head - handle->offset)) < 0);
 }
 
-#define perf_output_put(handle, x) \
-	perf_output_copy((handle), &(x), sizeof(x))
-
-static int perf_output_begin(struct perf_output_handle *handle,
-			     struct perf_counter *counter, unsigned int size,
-			     int nmi, int sample)
+int perf_output_begin(struct perf_output_handle *handle,
+		      struct perf_counter *counter, unsigned int size,
+		      int nmi, int sample)
 {
 	struct perf_counter *output_counter;
 	struct perf_mmap_data *data;
-	unsigned int offset, head;
+	unsigned long tail, offset, head;
 	int have_lost;
 	struct {
 		struct perf_event_header header;
@@ -2716,16 +2701,23 @@ static int perf_output_begin(struct perf_output_handle *handle,
 	perf_output_lock(handle);
 
 	do {
+		/*
+		 * Userspace could choose to issue a mb() before updating the
+		 * tail pointer. So that all reads will be completed before the
+		 * write is issued.
+		 */
+		tail = ACCESS_ONCE(data->user_page->data_tail);
+		smp_rmb();
 		offset = head = atomic_long_read(&data->head);
 		head += size;
-		if (unlikely(!perf_output_space(data, offset, head)))
+		if (unlikely(!perf_output_space(data, tail, offset, head)))
 			goto fail;
 	} while (atomic_long_cmpxchg(&data->head, offset, head) != offset);
 
 	handle->offset	= offset;
 	handle->head	= head;
 
-	if ((offset >> PAGE_SHIFT) != (head >> PAGE_SHIFT))
+	if (head - tail > data->watermark)
 		atomic_set(&data->wakeup, 1);
 
 	if (have_lost) {
@@ -2749,7 +2741,7 @@ out:
 	return -ENOSPC;
 }
 
-static void perf_output_end(struct perf_output_handle *handle)
+void perf_output_end(struct perf_output_handle *handle)
 {
 	struct perf_counter *counter = handle->counter;
 	struct perf_mmap_data *data = handle->data;
@@ -2863,156 +2855,176 @@ static void perf_output_read(struct perf_output_handle *handle,
 		perf_output_read_one(handle, counter);
 }
 
-void perf_counter_output(struct perf_counter *counter, int nmi,
-				struct perf_sample_data *data)
+void perf_output_sample(struct perf_output_handle *handle,
+			struct perf_event_header *header,
+			struct perf_sample_data *data,
+			struct perf_counter *counter)
 {
-	int ret;
-	u64 sample_type = counter->attr.sample_type;
-	struct perf_output_handle handle;
-	struct perf_event_header header;
-	u64 ip;
-	struct {
-		u32 pid, tid;
-	} tid_entry;
-	struct perf_callchain_entry *callchain = NULL;
-	int callchain_size = 0;
-	u64 time;
-	struct {
-		u32 cpu, reserved;
-	} cpu_entry;
+	u64 sample_type = data->type;
 
-	header.type = PERF_EVENT_SAMPLE;
-	header.size = sizeof(header);
+	perf_output_put(handle, *header);
 
-	header.misc = 0;
-	header.misc |= perf_misc_flags(data->regs);
-
-	if (sample_type & PERF_SAMPLE_IP) {
-		ip = perf_instruction_pointer(data->regs);
-		header.size += sizeof(ip);
-	}
-
-	if (sample_type & PERF_SAMPLE_TID) {
-		/* namespace issues */
-		tid_entry.pid = perf_counter_pid(counter, current);
-		tid_entry.tid = perf_counter_tid(counter, current);
-
-		header.size += sizeof(tid_entry);
-	}
+	if (sample_type & PERF_SAMPLE_IP)
+		perf_output_put(handle, data->ip);
 
-	if (sample_type & PERF_SAMPLE_TIME) {
-		/*
-		 * Maybe do better on x86 and provide cpu_clock_nmi()
-		 */
-		time = sched_clock();
+	if (sample_type & PERF_SAMPLE_TID)
+		perf_output_put(handle, data->tid_entry);
 
-		header.size += sizeof(u64);
-	}
+	if (sample_type & PERF_SAMPLE_TIME)
+		perf_output_put(handle, data->time);
 
 	if (sample_type & PERF_SAMPLE_ADDR)
-		header.size += sizeof(u64);
+		perf_output_put(handle, data->addr);
 
 	if (sample_type & PERF_SAMPLE_ID)
-		header.size += sizeof(u64);
+		perf_output_put(handle, data->id);
 
 	if (sample_type & PERF_SAMPLE_STREAM_ID)
-		header.size += sizeof(u64);
-
-	if (sample_type & PERF_SAMPLE_CPU) {
-		header.size += sizeof(cpu_entry);
+		perf_output_put(handle, data->stream_id);
 
-		cpu_entry.cpu = raw_smp_processor_id();
-		cpu_entry.reserved = 0;
-	}
+	if (sample_type & PERF_SAMPLE_CPU)
+		perf_output_put(handle, data->cpu_entry);
 
 	if (sample_type & PERF_SAMPLE_PERIOD)
-		header.size += sizeof(u64);
+		perf_output_put(handle, data->period);
 
 	if (sample_type & PERF_SAMPLE_READ)
-		header.size += perf_counter_read_size(counter);
+		perf_output_read(handle, counter);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
-		callchain = perf_callchain(data->regs);
+		if (data->callchain) {
+			int size = 1;
 
-		if (callchain) {
-			callchain_size = (1 + callchain->nr) * sizeof(u64);
-			header.size += callchain_size;
-		} else
-			header.size += sizeof(u64);
+			if (data->callchain)
+				size += data->callchain->nr;
+
+			size *= sizeof(u64);
+
+			perf_output_copy(handle, data->callchain, size);
+		} else {
+			u64 nr = 0;
+			perf_output_put(handle, nr);
+		}
 	}
 
 	if (sample_type & PERF_SAMPLE_RAW) {
-		int size = sizeof(u32);
+		if (data->raw) {
+			perf_output_put(handle, data->raw->size);
+			perf_output_copy(handle, data->raw->data,
+					 data->raw->size);
+		} else {
+			struct {
+				u32	size;
+				u32	data;
+			} raw = {
+				.size = sizeof(u32),
+				.data = 0,
+			};
+			perf_output_put(handle, raw);
+		}
+	}
+}
 
-		if (data->raw)
-			size += data->raw->size;
-		else
-			size += sizeof(u32);
+void perf_prepare_sample(struct perf_event_header *header,
+			 struct perf_sample_data *data,
+			 struct perf_counter *counter,
+			 struct pt_regs *regs)
+{
+	u64 sample_type = counter->attr.sample_type;
 
-		WARN_ON_ONCE(size & (sizeof(u64)-1));
-		header.size += size;
-	}
+	data->type = sample_type;
 
-	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
-	if (ret)
-		return;
+	header->type = PERF_EVENT_SAMPLE;
+	header->size = sizeof(*header);
 
-	perf_output_put(&handle, header);
+	header->misc = 0;
+	header->misc |= perf_misc_flags(regs);
 
-	if (sample_type & PERF_SAMPLE_IP)
-		perf_output_put(&handle, ip);
+	if (sample_type & PERF_SAMPLE_IP) {
+		data->ip = perf_instruction_pointer(regs);
 
-	if (sample_type & PERF_SAMPLE_TID)
-		perf_output_put(&handle, tid_entry);
+		header->size += sizeof(data->ip);
+	}
 
-	if (sample_type & PERF_SAMPLE_TIME)
-		perf_output_put(&handle, time);
+	if (sample_type & PERF_SAMPLE_TID) {
+		/* namespace issues */
+		data->tid_entry.pid = perf_counter_pid(counter, current);
+		data->tid_entry.tid = perf_counter_tid(counter, current);
+
+		header->size += sizeof(data->tid_entry);
+	}
+
+	if (sample_type & PERF_SAMPLE_TIME) {
+		data->time = perf_clock();
+
+		header->size += sizeof(data->time);
+	}
 
 	if (sample_type & PERF_SAMPLE_ADDR)
-		perf_output_put(&handle, data->addr);
+		header->size += sizeof(data->addr);
 
 	if (sample_type & PERF_SAMPLE_ID) {
-		u64 id = primary_counter_id(counter);
+		data->id = primary_counter_id(counter);
 
-		perf_output_put(&handle, id);
+		header->size += sizeof(data->id);
 	}
 
-	if (sample_type & PERF_SAMPLE_STREAM_ID)
-		perf_output_put(&handle, counter->id);
+	if (sample_type & PERF_SAMPLE_STREAM_ID) {
+		data->stream_id = counter->id;
 
-	if (sample_type & PERF_SAMPLE_CPU)
-		perf_output_put(&handle, cpu_entry);
+		header->size += sizeof(data->stream_id);
+	}
+
+	if (sample_type & PERF_SAMPLE_CPU) {
+		data->cpu_entry.cpu		= raw_smp_processor_id();
+		data->cpu_entry.reserved	= 0;
+
+		header->size += sizeof(data->cpu_entry);
+	}
 
 	if (sample_type & PERF_SAMPLE_PERIOD)
-		perf_output_put(&handle, data->period);
+		header->size += sizeof(data->period);
 
 	if (sample_type & PERF_SAMPLE_READ)
-		perf_output_read(&handle, counter);
+		header->size += perf_counter_read_size(counter);
 
 	if (sample_type & PERF_SAMPLE_CALLCHAIN) {
-		if (callchain)
-			perf_output_copy(&handle, callchain, callchain_size);
-		else {
-			u64 nr = 0;
-			perf_output_put(&handle, nr);
-		}
+		int size = 1;
+
+		data->callchain = perf_callchain(regs);
+
+		if (data->callchain)
+			size += data->callchain->nr;
+
+		header->size += size * sizeof(u64);
 	}
 
 	if (sample_type & PERF_SAMPLE_RAW) {
-		if (data->raw) {
-			perf_output_put(&handle, data->raw->size);
-			perf_output_copy(&handle, data->raw->data, data->raw->size);
-		} else {
-			struct {
-				u32	size;
-				u32	data;
-			} raw = {
-				.size = sizeof(u32),
-				.data = 0,
-			};
-			perf_output_put(&handle, raw);
-		}
+		int size = sizeof(u32);
+
+		if (data->raw)
+			size += data->raw->size;
+		else
+			size += sizeof(u32);
+
+		WARN_ON_ONCE(size & (sizeof(u64)-1));
+		header->size += size;
 	}
+}
+
+static void perf_counter_output(struct perf_counter *counter, int nmi,
+				struct perf_sample_data *data,
+				struct pt_regs *regs)
+{
+	struct perf_output_handle handle;
+	struct perf_event_header header;
+
+	perf_prepare_sample(&header, data, counter, regs);
+
+	if (perf_output_begin(&handle, counter, header.size, nmi, 1))
+		return;
+
+	perf_output_sample(&handle, &header, data, counter);
 
 	perf_output_end(&handle);
 }
@@ -3071,6 +3083,7 @@ struct perf_task_event {
 		u32				ppid;
 		u32				tid;
 		u32				ptid;
+		u64				time;
 	} event;
 };
 
@@ -3078,9 +3091,12 @@ static void perf_counter_task_output(struct perf_counter *counter,
 				     struct perf_task_event *task_event)
 {
 	struct perf_output_handle handle;
-	int size = task_event->event.header.size;
+	int size;
 	struct task_struct *task = task_event->task;
-	int ret = perf_output_begin(&handle, counter, size, 0, 0);
+	int ret;
+
+	size  = task_event->event.header.size;
+	ret = perf_output_begin(&handle, counter, size, 0, 0);
 
 	if (ret)
 		return;
@@ -3091,7 +3107,10 @@ static void perf_counter_task_output(struct perf_counter *counter,
 	task_event->event.tid = perf_counter_tid(counter, task);
 	task_event->event.ptid = perf_counter_tid(counter, current);
 
+	task_event->event.time = perf_clock();
+
 	perf_output_put(&handle, task_event->event);
+
 	perf_output_end(&handle);
 }
 
@@ -3473,7 +3492,7 @@ static void perf_log_throttle(struct perf_counter *counter, int enable)
 			.misc = 0,
 			.size = sizeof(throttle_event),
 		},
-		.time		= sched_clock(),
+		.time		= perf_clock(),
 		.id		= primary_counter_id(counter),
 		.stream_id	= counter->id,
 	};
@@ -3493,14 +3512,16 @@ static void perf_log_throttle(struct perf_counter *counter, int enable)
  * Generic counter overflow handling, sampling.
  */
 
-int perf_counter_overflow(struct perf_counter *counter, int nmi,
-			  struct perf_sample_data *data)
+static int __perf_counter_overflow(struct perf_counter *counter, int nmi,
+				   int throttle, struct perf_sample_data *data,
+				   struct pt_regs *regs)
 {
 	int events = atomic_read(&counter->event_limit);
-	int throttle = counter->pmu->unthrottle != NULL;
 	struct hw_perf_counter *hwc = &counter->hw;
 	int ret = 0;
 
+	throttle = (throttle && counter->pmu->unthrottle != NULL);
+
 	if (!throttle) {
 		hwc->interrupts++;
 	} else {
@@ -3523,7 +3544,7 @@ int perf_counter_overflow(struct perf_counter *counter, int nmi,
 	}
 
 	if (counter->attr.freq) {
-		u64 now = sched_clock();
+		u64 now = perf_clock();
 		s64 delta = now - hwc->freq_stamp;
 
 		hwc->freq_stamp = now;
@@ -3549,10 +3570,17 @@ int perf_counter_overflow(struct perf_counter *counter, int nmi,
 			perf_counter_disable(counter);
 	}
 
-	perf_counter_output(counter, nmi, data);
+	perf_counter_output(counter, nmi, data, regs);
 	return ret;
 }
 
+int perf_counter_overflow(struct perf_counter *counter, int nmi,
+			  struct perf_sample_data *data,
+			  struct pt_regs *regs)
+{
+	return __perf_counter_overflow(counter, nmi, 1, data, regs);
+}
+
 /*
  * Generic software counter infrastructure
  */
@@ -3588,9 +3616,11 @@ again:
 }
 
 static void perf_swcounter_overflow(struct perf_counter *counter,
-				    int nmi, struct perf_sample_data *data)
+				    int nmi, struct perf_sample_data *data,
+				    struct pt_regs *regs)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
+	int throttle = 0;
 	u64 overflow;
 
 	data->period = counter->hw.last_period;
@@ -3600,13 +3630,15 @@ static void perf_swcounter_overflow(struct perf_counter *counter,
 		return;
 
 	for (; overflow; overflow--) {
-		if (perf_counter_overflow(counter, nmi, data)) {
+		if (__perf_counter_overflow(counter, nmi, throttle,
+					    data, regs)) {
 			/*
 			 * We inhibit the overflow from happening when
 			 * hwc->interrupts == MAX_INTERRUPTS.
 			 */
 			break;
 		}
+		throttle = 1;
 	}
 }
 
@@ -3618,7 +3650,8 @@ static void perf_swcounter_unthrottle(struct perf_counter *counter)
 }
 
 static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
-			       int nmi, struct perf_sample_data *data)
+			       int nmi, struct perf_sample_data *data,
+			       struct pt_regs *regs)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
 
@@ -3627,11 +3660,11 @@ static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
 	if (!hwc->sample_period)
 		return;
 
-	if (!data->regs)
+	if (!regs)
 		return;
 
 	if (!atomic64_add_negative(nr, &hwc->period_left))
-		perf_swcounter_overflow(counter, nmi, data);
+		perf_swcounter_overflow(counter, nmi, data, regs);
 }
 
 static int perf_swcounter_is_counting(struct perf_counter *counter)
@@ -3690,7 +3723,8 @@ static int perf_swcounter_match(struct perf_counter *counter,
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 				     enum perf_type_id type,
 				     u32 event, u64 nr, int nmi,
-				     struct perf_sample_data *data)
+				     struct perf_sample_data *data,
+				     struct pt_regs *regs)
 {
 	struct perf_counter *counter;
 
@@ -3699,8 +3733,8 @@ static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
-		if (perf_swcounter_match(counter, type, event, data->regs))
-			perf_swcounter_add(counter, nr, nmi, data);
+		if (perf_swcounter_match(counter, type, event, regs))
+			perf_swcounter_add(counter, nr, nmi, data, regs);
 	}
 	rcu_read_unlock();
 }
@@ -3721,7 +3755,8 @@ static int *perf_swcounter_recursion_context(struct perf_cpu_context *cpuctx)
 
 static void do_perf_swcounter_event(enum perf_type_id type, u32 event,
 				    u64 nr, int nmi,
-				    struct perf_sample_data *data)
+				    struct perf_sample_data *data,
+				    struct pt_regs *regs)
 {
 	struct perf_cpu_context *cpuctx = &get_cpu_var(perf_cpu_context);
 	int *recursion = perf_swcounter_recursion_context(cpuctx);
@@ -3734,7 +3769,7 @@ static void do_perf_swcounter_event(enum perf_type_id type, u32 event,
 	barrier();
 
 	perf_swcounter_ctx_event(&cpuctx->ctx, type, event,
-				 nr, nmi, data);
+				 nr, nmi, data, regs);
 	rcu_read_lock();
 	/*
 	 * doesn't really matter which of the child contexts the
@@ -3742,7 +3777,7 @@ static void do_perf_swcounter_event(enum perf_type_id type, u32 event,
 	 */
 	ctx = rcu_dereference(current->perf_counter_ctxp);
 	if (ctx)
-		perf_swcounter_ctx_event(ctx, type, event, nr, nmi, data);
+		perf_swcounter_ctx_event(ctx, type, event, nr, nmi, data, regs);
 	rcu_read_unlock();
 
 	barrier();
@@ -3756,11 +3791,11 @@ void __perf_swcounter_event(u32 event, u64 nr, int nmi,
 			    struct pt_regs *regs, u64 addr)
 {
 	struct perf_sample_data data = {
-		.regs = regs,
 		.addr = addr,
 	};
 
-	do_perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi, &data);
+	do_perf_swcounter_event(PERF_TYPE_SOFTWARE, event, nr, nmi,
+				&data, regs);
 }
 
 static void perf_swcounter_read(struct perf_counter *counter)
@@ -3797,6 +3832,7 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 {
 	enum hrtimer_restart ret = HRTIMER_RESTART;
 	struct perf_sample_data data;
+	struct pt_regs *regs;
 	struct perf_counter *counter;
 	u64 period;
 
@@ -3804,17 +3840,17 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 	counter->pmu->read(counter);
 
 	data.addr = 0;
-	data.regs = get_irq_regs();
+	regs = get_irq_regs();
 	/*
 	 * In case we exclude kernel IPs or are somehow not in interrupt
 	 * context, provide the next best thing, the user IP.
 	 */
-	if ((counter->attr.exclude_kernel || !data.regs) &&
+	if ((counter->attr.exclude_kernel || !regs) &&
 			!counter->attr.exclude_user)
-		data.regs = task_pt_regs(current);
+		regs = task_pt_regs(current);
 
-	if (data.regs) {
-		if (perf_counter_overflow(counter, 0, &data))
+	if (regs) {
+		if (perf_counter_overflow(counter, 0, &data, regs))
 			ret = HRTIMER_NORESTART;
 	}
 
@@ -3950,15 +3986,17 @@ void perf_tpcounter_event(int event_id, u64 addr, u64 count, void *record,
 	};
 
 	struct perf_sample_data data = {
-		.regs = get_irq_regs(),
 		.addr = addr,
 		.raw = &raw,
 	};
 
-	if (!data.regs)
-		data.regs = task_pt_regs(current);
+	struct pt_regs *regs = get_irq_regs();
+
+	if (!regs)
+		regs = task_pt_regs(current);
 
-	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, count, 1, &data);
+	do_perf_swcounter_event(PERF_TYPE_TRACEPOINT, event_id, count, 1,
+				&data, regs);
 }
 EXPORT_SYMBOL_GPL(perf_tpcounter_event);
 
@@ -4170,8 +4208,8 @@ done:
 static int perf_copy_attr(struct perf_counter_attr __user *uattr,
 			  struct perf_counter_attr *attr)
 {
-	int ret;
 	u32 size;
+	int ret;
 
 	if (!access_ok(VERIFY_WRITE, uattr, PERF_ATTR_SIZE_VER0))
 		return -EFAULT;
@@ -4196,19 +4234,19 @@ static int perf_copy_attr(struct perf_counter_attr __user *uattr,
 
 	/*
 	 * If we're handed a bigger struct than we know of,
-	 * ensure all the unknown bits are 0.
+	 * ensure all the unknown bits are 0 - i.e. new
+	 * user-space does not rely on any kernel feature
+	 * extensions we dont know about yet.
 	 */
 	if (size > sizeof(*attr)) {
-		unsigned long val;
-		unsigned long __user *addr;
-		unsigned long __user *end;
+		unsigned char __user *addr;
+		unsigned char __user *end;
+		unsigned char val;
 
-		addr = PTR_ALIGN((void __user *)uattr + sizeof(*attr),
-				sizeof(unsigned long));
-		end  = PTR_ALIGN((void __user *)uattr + size,
-				sizeof(unsigned long));
+		addr = (void __user *)uattr + sizeof(*attr);
+		end  = (void __user *)uattr + size;
 
-		for (; addr < end; addr += sizeof(unsigned long)) {
+		for (; addr < end; addr++) {
 			ret = get_user(val, addr);
 			if (ret)
 				return ret;
diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
index e1d16c9..ac2e1dc 100644
--- a/kernel/sched_clock.c
+++ b/kernel/sched_clock.c
@@ -48,13 +48,6 @@ static __read_mostly int sched_clock_running;
 __read_mostly int sched_clock_stable;
 
 struct sched_clock_data {
-	/*
-	 * Raw spinlock - this is a special case: this might be called
-	 * from within instrumentation code so we dont want to do any
-	 * instrumentation ourselves.
-	 */
-	raw_spinlock_t		lock;
-
 	u64			tick_raw;
 	u64			tick_gtod;
 	u64			clock;
@@ -80,7 +73,6 @@ void sched_clock_init(void)
 	for_each_possible_cpu(cpu) {
 		struct sched_clock_data *scd = cpu_sdc(cpu);
 
-		scd->lock = (raw_spinlock_t)__RAW_SPIN_LOCK_UNLOCKED;
 		scd->tick_raw = 0;
 		scd->tick_gtod = ktime_now;
 		scd->clock = ktime_now;
@@ -109,14 +101,19 @@ static inline u64 wrap_max(u64 x, u64 y)
  *  - filter out backward motion
  *  - use the GTOD tick value to create a window to filter crazy TSC values
  */
-static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
+static u64 sched_clock_local(struct sched_clock_data *scd)
 {
-	s64 delta = now - scd->tick_raw;
-	u64 clock, min_clock, max_clock;
+	u64 now, clock, old_clock, min_clock, max_clock;
+	s64 delta;
 
+again:
+	now = sched_clock();
+	delta = now - scd->tick_raw;
 	if (unlikely(delta < 0))
 		delta = 0;
 
+	old_clock = scd->clock;
+
 	/*
 	 * scd->clock = clamp(scd->tick_gtod + delta,
 	 *		      max(scd->tick_gtod, scd->clock),
@@ -124,84 +121,73 @@ static u64 __update_sched_clock(struct sched_clock_data *scd, u64 now)
 	 */
 
 	clock = scd->tick_gtod + delta;
-	min_clock = wrap_max(scd->tick_gtod, scd->clock);
-	max_clock = wrap_max(scd->clock, scd->tick_gtod + TICK_NSEC);
+	min_clock = wrap_max(scd->tick_gtod, old_clock);
+	max_clock = wrap_max(old_clock, scd->tick_gtod + TICK_NSEC);
 
 	clock = wrap_max(clock, min_clock);
 	clock = wrap_min(clock, max_clock);
 
-	scd->clock = clock;
+	if (cmpxchg(&scd->clock, old_clock, clock) != old_clock)
+		goto again;
 
-	return scd->clock;
+	return clock;
 }
 
-static void lock_double_clock(struct sched_clock_data *data1,
-				struct sched_clock_data *data2)
+static u64 sched_clock_remote(struct sched_clock_data *scd)
 {
-	if (data1 < data2) {
-		__raw_spin_lock(&data1->lock);
-		__raw_spin_lock(&data2->lock);
+	struct sched_clock_data *my_scd = this_scd();
+	u64 this_clock, remote_clock;
+	u64 *ptr, old_val, val;
+
+	sched_clock_local(my_scd);
+again:
+	this_clock = my_scd->clock;
+	remote_clock = scd->clock;
+
+	/*
+	 * Use the opportunity that we have both locks
+	 * taken to couple the two clocks: we take the
+	 * larger time as the latest time for both
+	 * runqueues. (this creates monotonic movement)
+	 */
+	if (likely((s64)(remote_clock - this_clock) < 0)) {
+		ptr = &scd->clock;
+		old_val = remote_clock;
+		val = this_clock;
 	} else {
-		__raw_spin_lock(&data2->lock);
-		__raw_spin_lock(&data1->lock);
+		/*
+		 * Should be rare, but possible:
+		 */
+		ptr = &my_scd->clock;
+		old_val = this_clock;
+		val = remote_clock;
 	}
+
+	if (cmpxchg(ptr, old_val, val) != old_val)
+		goto again;
+
+	return val;
 }
 
 u64 sched_clock_cpu(int cpu)
 {
-	u64 now, clock, this_clock, remote_clock;
 	struct sched_clock_data *scd;
+	u64 clock;
+
+	WARN_ON_ONCE(!irqs_disabled());
 
 	if (sched_clock_stable)
 		return sched_clock();
 
-	scd = cpu_sdc(cpu);
-
-	/*
-	 * Normally this is not called in NMI context - but if it is,
-	 * trying to do any locking here is totally lethal.
-	 */
-	if (unlikely(in_nmi()))
-		return scd->clock;
-
 	if (unlikely(!sched_clock_running))
 		return 0ull;
 
-	WARN_ON_ONCE(!irqs_disabled());
-	now = sched_clock();
-
-	if (cpu != raw_smp_processor_id()) {
-		struct sched_clock_data *my_scd = this_scd();
-
-		lock_double_clock(scd, my_scd);
-
-		this_clock = __update_sched_clock(my_scd, now);
-		remote_clock = scd->clock;
-
-		/*
-		 * Use the opportunity that we have both locks
-		 * taken to couple the two clocks: we take the
-		 * larger time as the latest time for both
-		 * runqueues. (this creates monotonic movement)
-		 */
-		if (likely((s64)(remote_clock - this_clock) < 0)) {
-			clock = this_clock;
-			scd->clock = clock;
-		} else {
-			/*
-			 * Should be rare, but possible:
-			 */
-			clock = remote_clock;
-			my_scd->clock = remote_clock;
-		}
-
-		__raw_spin_unlock(&my_scd->lock);
-	} else {
-		__raw_spin_lock(&scd->lock);
-		clock = __update_sched_clock(scd, now);
-	}
+	scd = cpu_sdc(cpu);
 
-	__raw_spin_unlock(&scd->lock);
+	if (cpu != smp_processor_id())
+		clock = sched_clock_remote(scd);
+	else
+		clock = sched_clock_local(scd);
 
 	return clock;
 }
@@ -223,11 +209,9 @@ void sched_clock_tick(void)
 	now_gtod = ktime_to_ns(ktime_get());
 	now = sched_clock();
 
-	__raw_spin_lock(&scd->lock);
 	scd->tick_raw = now;
 	scd->tick_gtod = now_gtod;
-	__update_sched_clock(scd, now);
-	__raw_spin_unlock(&scd->lock);
+	sched_clock_local(scd);
 }
 
 /*
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 10d218a..990b188 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -513,6 +513,7 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	if (entity_is_task(curr)) {
 		struct task_struct *curtask = task_of(curr);
 
+		trace_sched_stat_runtime(curtask, delta_exec, curr->vruntime);
 		cpuacct_charge(curtask, delta_exec);
 		account_group_exec_runtime(curtask, delta_exec);
 	}
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 844164d..26f03ac 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -42,7 +42,6 @@ obj-$(CONFIG_BOOT_TRACER) += trace_boot.o
 obj-$(CONFIG_FUNCTION_GRAPH_TRACER) += trace_functions_graph.o
 obj-$(CONFIG_TRACE_BRANCH_PROFILING) += trace_branch.o
 obj-$(CONFIG_HW_BRANCH_TRACER) += trace_hw_branches.o
-obj-$(CONFIG_POWER_TRACER) += trace_power.o
 obj-$(CONFIG_KMEMTRACE) += kmemtrace.o
 obj-$(CONFIG_WORKQUEUE_TRACER) += trace_workqueue.o
 obj-$(CONFIG_BLK_DEV_IO_TRACE) += blktrace.o
@@ -54,5 +53,6 @@ obj-$(CONFIG_EVENT_TRACING) += trace_export.o
 obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
+obj-$(CONFIG_EVENT_TRACING) += power-traces.o
 
 libftrace-y := ftrace.o
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
new file mode 100644
index 0000000..e06c6e3
--- /dev/null
+++ b/kernel/trace/power-traces.c
@@ -0,0 +1,20 @@
+/*
+ * Power trace points
+ *
+ * Copyright (C) 2009 Arjan van de Ven <arjan@linux.intel.com>
+ */
+
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+
+#define CREATE_TRACE_POINTS
+#include <trace/events/power.h>
+
+EXPORT_TRACEPOINT_SYMBOL_GPL(power_start);
+EXPORT_TRACEPOINT_SYMBOL_GPL(power_end);
+EXPORT_TRACEPOINT_SYMBOL_GPL(power_frequency);
+
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 86bcff9..405cb85 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -11,7 +11,6 @@
 #include <linux/ftrace.h>
 #include <trace/boot.h>
 #include <linux/kmemtrace.h>
-#include <trace/power.h>
 
 #include <linux/trace_seq.h>
 #include <linux/ftrace_event.h>
@@ -37,7 +36,6 @@ enum trace_type {
 	TRACE_HW_BRANCHES,
 	TRACE_KMEM_ALLOC,
 	TRACE_KMEM_FREE,
-	TRACE_POWER,
 	TRACE_BLK,
 
 	__TRACE_LAST_TYPE,
@@ -207,7 +205,6 @@ extern void __ftrace_bad_type(void);
 		IF_ASSIGN(var, ent, struct ftrace_graph_ret_entry,	\
 			  TRACE_GRAPH_RET);		\
 		IF_ASSIGN(var, ent, struct hw_branch_entry, TRACE_HW_BRANCHES);\
-		IF_ASSIGN(var, ent, struct trace_power, TRACE_POWER); \
 		IF_ASSIGN(var, ent, struct kmemtrace_alloc_entry,	\
 			  TRACE_KMEM_ALLOC);	\
 		IF_ASSIGN(var, ent, struct kmemtrace_free_entry,	\
diff --git a/kernel/trace/trace_entries.h b/kernel/trace/trace_entries.h
index a431748..ead3d72 100644
--- a/kernel/trace/trace_entries.h
+++ b/kernel/trace/trace_entries.h
@@ -330,23 +330,6 @@ FTRACE_ENTRY(hw_branch, hw_branch_entry,
 	F_printk("from: %llx to: %llx", __entry->from, __entry->to)
 );
 
-FTRACE_ENTRY(power, trace_power,
-
-	TRACE_POWER,
-
-	F_STRUCT(
-		__field_struct(	struct power_trace,	state_data	)
-		__field_desc(	s64,	state_data,	stamp		)
-		__field_desc(	s64,	state_data,	end		)
-		__field_desc(	int,	state_data,	type		)
-		__field_desc(	int,	state_data,	state		)
-	),
-
-	F_printk("%llx->%llx type:%u state:%u",
-		 __entry->stamp, __entry->end,
-		 __entry->type, __entry->state)
-);
-
 FTRACE_ENTRY(kmem_alloc, kmemtrace_alloc_entry,
 
 	TRACE_KMEM_ALLOC,
diff --git a/kernel/trace/trace_power.c b/kernel/trace/trace_power.c
deleted file mode 100644
index fe1a00f..0000000
--- a/kernel/trace/trace_power.c
+++ /dev/null
@@ -1,218 +0,0 @@
-/*
- * ring buffer based C-state tracer
- *
- * Arjan van de Ven <arjan@linux.intel.com>
- * Copyright (C) 2008 Intel Corporation
- *
- * Much is borrowed from trace_boot.c which is
- * Copyright (C) 2008 Frederic Weisbecker <fweisbec@gmail.com>
- *
- */
-
-#include <linux/init.h>
-#include <linux/debugfs.h>
-#include <trace/power.h>
-#include <linux/kallsyms.h>
-#include <linux/module.h>
-
-#include "trace.h"
-#include "trace_output.h"
-
-static struct trace_array *power_trace;
-static int __read_mostly trace_power_enabled;
-
-static void probe_power_start(struct power_trace *it, unsigned int type,
-				unsigned int level)
-{
-	if (!trace_power_enabled)
-		return;
-
-	memset(it, 0, sizeof(struct power_trace));
-	it->state = level;
-	it->type = type;
-	it->stamp = ktime_get();
-}
-
-
-static void probe_power_end(struct power_trace *it)
-{
-	struct ftrace_event_call *call = &event_power;
-	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
-	struct trace_power *entry;
-	struct trace_array_cpu *data;
-	struct trace_array *tr = power_trace;
-
-	if (!trace_power_enabled)
-		return;
-
-	buffer = tr->buffer;
-
-	preempt_disable();
-	it->end = ktime_get();
-	data = tr->data[smp_processor_id()];
-
-	event = trace_buffer_lock_reserve(buffer, TRACE_POWER,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		goto out;
-	entry	= ring_buffer_event_data(event);
-	entry->state_data = *it;
-	if (!filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, 0, 0);
- out:
-	preempt_enable();
-}
-
-static void probe_power_mark(struct power_trace *it, unsigned int type,
-				unsigned int level)
-{
-	struct ftrace_event_call *call = &event_power;
-	struct ring_buffer_event *event;
-	struct ring_buffer *buffer;
-	struct trace_power *entry;
-	struct trace_array_cpu *data;
-	struct trace_array *tr = power_trace;
-
-	if (!trace_power_enabled)
-		return;
-
-	buffer = tr->buffer;
-
-	memset(it, 0, sizeof(struct power_trace));
-	it->state = level;
-	it->type = type;
-	it->stamp = ktime_get();
-	preempt_disable();
-	it->end = it->stamp;
-	data = tr->data[smp_processor_id()];
-
-	event = trace_buffer_lock_reserve(buffer, TRACE_POWER,
-					  sizeof(*entry), 0, 0);
-	if (!event)
-		goto out;
-	entry	= ring_buffer_event_data(event);
-	entry->state_data = *it;
-	if (!filter_check_discard(call, entry, buffer, event))
-		trace_buffer_unlock_commit(buffer, event, 0, 0);
- out:
-	preempt_enable();
-}
-
-static int tracing_power_register(void)
-{
-	int ret;
-
-	ret = register_trace_power_start(probe_power_start);
-	if (ret) {
-		pr_info("power trace: Couldn't activate tracepoint"
-			" probe to trace_power_start\n");
-		return ret;
-	}
-	ret = register_trace_power_end(probe_power_end);
-	if (ret) {
-		pr_info("power trace: Couldn't activate tracepoint"
-			" probe to trace_power_end\n");
-		goto fail_start;
-	}
-	ret = register_trace_power_mark(probe_power_mark);
-	if (ret) {
-		pr_info("power trace: Couldn't activate tracepoint"
-			" probe to trace_power_mark\n");
-		goto fail_end;
-	}
-	return ret;
-fail_end:
-	unregister_trace_power_end(probe_power_end);
-fail_start:
-	unregister_trace_power_start(probe_power_start);
-	return ret;
-}
-
-static void start_power_trace(struct trace_array *tr)
-{
-	trace_power_enabled = 1;
-}
-
-static void stop_power_trace(struct trace_array *tr)
-{
-	trace_power_enabled = 0;
-}
-
-static void power_trace_reset(struct trace_array *tr)
-{
-	trace_power_enabled = 0;
-	unregister_trace_power_start(probe_power_start);
-	unregister_trace_power_end(probe_power_end);
-	unregister_trace_power_mark(probe_power_mark);
-}
-
-
-static int power_trace_init(struct trace_array *tr)
-{
-	power_trace = tr;
-
-	trace_power_enabled = 1;
-	tracing_power_register();
-
-	tracing_reset_online_cpus(tr);
-	return 0;
-}
-
-static enum print_line_t power_print_line(struct trace_iterator *iter)
-{
-	int ret = 0;
-	struct trace_entry *entry = iter->ent;
-	struct trace_power *field ;
-	struct power_trace *it;
-	struct trace_seq *s = &iter->seq;
-	struct timespec stamp;
-	struct timespec duration;
-
-	trace_assign_type(field, entry);
-	it = &field->state_data;
-	stamp = ktime_to_timespec(it->stamp);
-	duration = ktime_to_timespec(ktime_sub(it->end, it->stamp));
-
-	if (entry->type == TRACE_POWER) {
-		if (it->type == POWER_CSTATE)
-			ret = trace_seq_printf(s, "[%5ld.%09ld] CSTATE: Going to C%i on cpu %i for %ld.%09ld\n",
-					  stamp.tv_sec,
-					  stamp.tv_nsec,
-					  it->state, iter->cpu,
-					  duration.tv_sec,
-					  duration.tv_nsec);
-		if (it->type == POWER_PSTATE)
-			ret = trace_seq_printf(s, "[%5ld.%09ld] PSTATE: Going to P%i on cpu %i\n",
-					  stamp.tv_sec,
-					  stamp.tv_nsec,
-					  it->state, iter->cpu);
-		if (!ret)
-			return TRACE_TYPE_PARTIAL_LINE;
-		return TRACE_TYPE_HANDLED;
-	}
-	return TRACE_TYPE_UNHANDLED;
-}
-
-static void power_print_header(struct seq_file *s)
-{
-	seq_puts(s, "#   TIMESTAMP      STATE  EVENT\n");
-	seq_puts(s, "#       |            |      |\n");
-}
-
-static struct tracer power_tracer __read_mostly =
-{
-	.name		= "power",
-	.init		= power_trace_init,
-	.start		= start_power_trace,
-	.stop		= stop_power_trace,
-	.reset		= power_trace_reset,
-	.print_line	= power_print_line,
-	.print_header	= power_print_header,
-};
-
-static int init_power_trace(void)
-{
-	return register_tracer(&power_tracer);
-}
-device_initcall(init_power_trace);
diff --git a/scripts/tracing/power.pl b/scripts/tracing/power.pl
deleted file mode 100644
index 4f729b3..0000000
--- a/scripts/tracing/power.pl
+++ /dev/null
@@ -1,108 +0,0 @@
-#!/usr/bin/perl
-
-# Copyright 2008, Intel Corporation
-#
-# This file is part of the Linux kernel
-#
-# This program file is free software; you can redistribute it and/or modify it
-# under the terms of the GNU General Public License as published by the
-# Free Software Foundation; version 2 of the License.
-#
-# This program is distributed in the hope that it will be useful, but WITHOUT
-# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
-# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
-# for more details.
-#
-# You should have received a copy of the GNU General Public License
-# along with this program in a file named COPYING; if not, write to the
-# Free Software Foundation, Inc.,
-# 51 Franklin Street, Fifth Floor,
-# Boston, MA 02110-1301 USA
-#
-# Authors:
-# 	Arjan van de Ven <arjan@linux.intel.com>
-
-
-#
-# This script turns a cstate ftrace output into a SVG graphic that shows
-# historic C-state information
-#
-#
-# 	cat /sys/kernel/debug/tracing/trace | perl power.pl > out.svg
-#
-
-my @styles;
-my $base = 0;
-
-my @pstate_last;
-my @pstate_level;
-
-$styles[0] = "fill:rgb(0,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[1] = "fill:rgb(0,255,0);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[2] = "fill:rgb(255,0,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[3] = "fill:rgb(255,255,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[4] = "fill:rgb(255,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[5] = "fill:rgb(0,255,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[6] = "fill:rgb(0,128,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[7] = "fill:rgb(0,255,128);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-$styles[8] = "fill:rgb(0,25,20);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-
-
-print "<?xml version=\"1.0\" standalone=\"no\"?> \n";
-print "<svg width=\"10000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
-
-my $scale = 30000.0;
-while (<>) {
-	my $line = $_;
-	if ($line =~ /([0-9\.]+)\] CSTATE: Going to C([0-9]) on cpu ([0-9]+) for ([0-9\.]+)/) {
-		if ($base == 0) {
-			$base = $1;
-		}
-		my $time = $1 - $base;
-		$time = $time * $scale;
-		my $C = $2;
-		my $cpu = $3;
-		my $y = 400 * $cpu;
-		my $duration = $4 * $scale;
-		my $msec = int($4 * 100000)/100.0;
-		my $height = $C * 20;
-		$style = $styles[$C];
-
-		$y = $y + 140 - $height;
-
-		$x2 = $time + 4;
-		$y2 = $y + 4;
-
-
-		print "<rect x=\"$time\" width=\"$duration\" y=\"$y\" height=\"$height\" style=\"$style\"/>\n";
-		print "<text transform=\"translate($x2,$y2) rotate(90)\">C$C $msec</text>\n";
-	}
-	if ($line =~ /([0-9\.]+)\] PSTATE: Going to P([0-9]) on cpu ([0-9]+)/) {
-		my $time = $1 - $base;
-		my $state = $2;
-		my $cpu = $3;
-
-		if (defined($pstate_last[$cpu])) {
-			my $from = $pstate_last[$cpu];
-			my $oldstate = $pstate_state[$cpu];
-			my $duration = ($time-$from) * $scale;
-
-			$from = $from * $scale;
-			my $to = $from + $duration;
-			my $height = 140 - ($oldstate * (140/8));
-
-			my $y = 400 * $cpu + 200 + $height;
-			my $y2 = $y+4;
-			my $style = $styles[8];
-
-			print "<rect x=\"$from\" y=\"$y\" width=\"$duration\" height=\"5\" style=\"$style\"/>\n";
-			print "<text transform=\"translate($from,$y2)\">P$oldstate (cpu $cpu)</text>\n";
-		};
-
-		$pstate_last[$cpu] = $time;
-		$pstate_state[$cpu] = $state;
-	}
-}
-
-
-print "</svg>\n";
diff --git a/tools/perf/Documentation/perf-sched.txt b/tools/perf/Documentation/perf-sched.txt
new file mode 100644
index 0000000..1ce7919
--- /dev/null
+++ b/tools/perf/Documentation/perf-sched.txt
@@ -0,0 +1,41 @@
+perf-sched(1)
+==============
+
+NAME
+----
+perf-sched - Tool to trace/measure scheduler properties (latencies)
+
+SYNOPSIS
+--------
+[verse]
+'perf sched' {record|latency|replay|trace}
+
+DESCRIPTION
+-----------
+There's four variants of perf sched:
+
+  'perf sched record <command>' to record the scheduling events
+  of an arbitrary workload.
+
+  'perf sched latency' to report the per task scheduling latencies
+  and other scheduling properties of the workload.
+
+  'perf sched trace' to see a detailed trace of the workload that
+  was recorded.
+
+  'perf sched replay' to simulate the workload that was recorded
+  via perf sched record. (this is done by starting up mockup threads
+  that mimic the workload based on the events in the trace. These
+  threads can then replay the timings (CPU runtime and sleep patterns)
+  of the workload as it occured when it was recorded - and can repeat
+  it a number of times, measuring its performance.)
+
+OPTIONS
+-------
+-D::
+--dump-raw-trace=::
+        Display verbose dump of the sched data.
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/Documentation/perf-timechart.txt b/tools/perf/Documentation/perf-timechart.txt
new file mode 100644
index 0000000..61e0104
--- /dev/null
+++ b/tools/perf/Documentation/perf-timechart.txt
@@ -0,0 +1,35 @@
+perf-timechart(1)
+=================
+
+NAME
+----
+perf-timechart - Tool to visualize total system behavior during a workload
+
+SYNOPSIS
+--------
+[verse]
+'perf timechart' {record}
+
+DESCRIPTION
+-----------
+There are two variants of perf timechart:
+
+  'perf timechart record <command>' to record the system level events
+  of an arbitrary workload.
+
+  'perf timechart' to turn a trace into a Scalable Vector Graphics file,
+  that can be viewed with popular SVG viewers such as 'Inkscape'.
+
+OPTIONS
+-------
+-o::
+--output=::
+        Select the output file (default: output.svg)
+-i::
+--input=::
+        Select the input file (default: perf.data)
+
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/Documentation/perf-trace.txt b/tools/perf/Documentation/perf-trace.txt
new file mode 100644
index 0000000..41ed753
--- /dev/null
+++ b/tools/perf/Documentation/perf-trace.txt
@@ -0,0 +1,25 @@
+perf-trace(1)
+==============
+
+NAME
+----
+perf-trace - Read perf.data (created by perf record) and display trace output
+
+SYNOPSIS
+--------
+[verse]
+'perf trace' [-i <file> | --input=file] symbol_name
+
+DESCRIPTION
+-----------
+This command reads the input file and displays the trace recorded.
+
+OPTIONS
+-------
+-D::
+--dump-raw-trace=::
+        Display verbose dump of the trace data.
+
+SEE ALSO
+--------
+linkperf:perf-record[1]
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 9f8d207..0aba8b6 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -373,13 +373,16 @@ LIB_OBJS += util/thread.o
 LIB_OBJS += util/trace-event-parse.o
 LIB_OBJS += util/trace-event-read.o
 LIB_OBJS += util/trace-event-info.o
+LIB_OBJS += util/svghelper.o
 
 BUILTIN_OBJS += builtin-annotate.o
 BUILTIN_OBJS += builtin-help.o
+BUILTIN_OBJS += builtin-sched.o
 BUILTIN_OBJS += builtin-list.o
 BUILTIN_OBJS += builtin-record.o
 BUILTIN_OBJS += builtin-report.o
 BUILTIN_OBJS += builtin-stat.o
+BUILTIN_OBJS += builtin-timechart.o
 BUILTIN_OBJS += builtin-top.o
 BUILTIN_OBJS += builtin-trace.o
 
@@ -710,6 +713,12 @@ builtin-help.o: builtin-help.c common-cmds.h PERF-CFLAGS
 		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
 		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
 
+builtin-timechart.o: builtin-timechart.c common-cmds.h PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $*.o -c $(ALL_CFLAGS) \
+		'-DPERF_HTML_PATH="$(htmldir_SQ)"' \
+		'-DPERF_MAN_PATH="$(mandir_SQ)"' \
+		'-DPERF_INFO_PATH="$(infodir_SQ)"' $<
+
 $(BUILT_INS): perf$X
 	$(QUIET_BUILT_IN)$(RM) $@ && \
 	ln perf$X $@ 2>/dev/null || \
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 99a12fe..2459e5a 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -48,6 +48,8 @@ static int			call_graph			= 0;
 static int			inherit_stat			= 0;
 static int			no_samples			= 0;
 static int			sample_address			= 0;
+static int			multiplex			= 0;
+static int			multiplex_fd			= -1;
 
 static long			samples;
 static struct timeval		last_read;
@@ -470,19 +472,28 @@ try_again:
 	 */
 	if (group && group_fd == -1)
 		group_fd = fd[nr_cpu][counter];
+	if (multiplex && multiplex_fd == -1)
+		multiplex_fd = fd[nr_cpu][counter];
 
-	event_array[nr_poll].fd = fd[nr_cpu][counter];
-	event_array[nr_poll].events = POLLIN;
-	nr_poll++;
-
-	mmap_array[nr_cpu][counter].counter = counter;
-	mmap_array[nr_cpu][counter].prev = 0;
-	mmap_array[nr_cpu][counter].mask = mmap_pages*page_size - 1;
-	mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
-			PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter], 0);
-	if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
-		error("failed to mmap with %d (%s)\n", errno, strerror(errno));
-		exit(-1);
+	if (multiplex && fd[nr_cpu][counter] != multiplex_fd) {
+		int ret;
+
+		ret = ioctl(fd[nr_cpu][counter], PERF_COUNTER_IOC_SET_OUTPUT, multiplex_fd);
+		assert(ret != -1);
+	} else {
+		event_array[nr_poll].fd = fd[nr_cpu][counter];
+		event_array[nr_poll].events = POLLIN;
+		nr_poll++;
+
+		mmap_array[nr_cpu][counter].counter = counter;
+		mmap_array[nr_cpu][counter].prev = 0;
+		mmap_array[nr_cpu][counter].mask = mmap_pages*page_size - 1;
+		mmap_array[nr_cpu][counter].base = mmap(NULL, (mmap_pages+1)*page_size,
+				PROT_READ|PROT_WRITE, MAP_SHARED, fd[nr_cpu][counter], 0);
+		if (mmap_array[nr_cpu][counter].base == MAP_FAILED) {
+			error("failed to mmap with %d (%s)\n", errno, strerror(errno));
+			exit(-1);
+		}
 	}
 
 	ioctl(fd[nr_cpu][counter], PERF_COUNTER_IOC_ENABLE);
@@ -513,6 +524,7 @@ static int __cmd_record(int argc, const char **argv)
 	pid_t pid = 0;
 	int flags;
 	int ret;
+	unsigned long waking = 0;
 
 	page_size = sysconf(_SC_PAGE_SIZE);
 	nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
@@ -614,17 +626,29 @@ static int __cmd_record(int argc, const char **argv)
 		int hits = samples;
 
 		for (i = 0; i < nr_cpu; i++) {
-			for (counter = 0; counter < nr_counters; counter++)
-				mmap_read(&mmap_array[i][counter]);
+			for (counter = 0; counter < nr_counters; counter++) {
+				if (mmap_array[i][counter].base)
+					mmap_read(&mmap_array[i][counter]);
+			}
 		}
 
 		if (hits == samples) {
 			if (done)
 				break;
-			ret = poll(event_array, nr_poll, 100);
+			ret = poll(event_array, nr_poll, -1);
+			waking++;
+		}
+
+		if (done) {
+			for (i = 0; i < nr_cpu; i++) {
+				for (counter = 0; counter < nr_counters; counter++)
+					ioctl(fd[i][counter], PERF_COUNTER_IOC_DISABLE);
+			}
 		}
 	}
 
+	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
+
 	/*
 	 * Approximate RIP event size: 24 bytes.
 	 */
@@ -681,6 +705,8 @@ static const struct option options[] = {
 		    "Sample addresses"),
 	OPT_BOOLEAN('n', "no-samples", &no_samples,
 		    "don't sample"),
+	OPT_BOOLEAN('M', "multiplex", &multiplex,
+		    "multiplex counter output in a single channel"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
new file mode 100644
index 0000000..275d79c
--- /dev/null
+++ b/tools/perf/builtin-sched.c
@@ -0,0 +1,2004 @@
+#include "builtin.h"
+#include "perf.h"
+
+#include "util/util.h"
+#include "util/cache.h"
+#include "util/symbol.h"
+#include "util/thread.h"
+#include "util/header.h"
+
+#include "util/parse-options.h"
+#include "util/trace-event.h"
+
+#include "util/debug.h"
+
+#include <sys/types.h>
+#include <sys/prctl.h>
+
+#include <semaphore.h>
+#include <pthread.h>
+#include <math.h>
+
+static char			const *input_name = "perf.data";
+static int			input;
+static unsigned long		page_size;
+static unsigned long		mmap_window = 32;
+
+static unsigned long		total_comm = 0;
+
+static struct rb_root		threads;
+static struct thread		*last_match;
+
+static struct perf_header	*header;
+static u64			sample_type;
+
+static char			default_sort_order[] = "avg, max, switch, runtime";
+static char			*sort_order = default_sort_order;
+
+#define PR_SET_NAME		15               /* Set process name */
+#define MAX_CPUS		4096
+
+#define BUG_ON(x)		assert(!(x))
+
+static u64			run_measurement_overhead;
+static u64			sleep_measurement_overhead;
+
+#define COMM_LEN		20
+#define SYM_LEN			129
+
+#define MAX_PID			65536
+
+static unsigned long		nr_tasks;
+
+struct sched_atom;
+
+struct task_desc {
+	unsigned long		nr;
+	unsigned long		pid;
+	char			comm[COMM_LEN];
+
+	unsigned long		nr_events;
+	unsigned long		curr_event;
+	struct sched_atom	**atoms;
+
+	pthread_t		thread;
+	sem_t			sleep_sem;
+
+	sem_t			ready_for_work;
+	sem_t			work_done_sem;
+
+	u64			cpu_usage;
+};
+
+enum sched_event_type {
+	SCHED_EVENT_RUN,
+	SCHED_EVENT_SLEEP,
+	SCHED_EVENT_WAKEUP,
+};
+
+struct sched_atom {
+	enum sched_event_type	type;
+	u64			timestamp;
+	u64			duration;
+	unsigned long		nr;
+	int			specific_wait;
+	sem_t			*wait_sem;
+	struct task_desc	*wakee;
+};
+
+static struct task_desc		*pid_to_task[MAX_PID];
+
+static struct task_desc		**tasks;
+
+static pthread_mutex_t		start_work_mutex = PTHREAD_MUTEX_INITIALIZER;
+static u64			start_time;
+
+static pthread_mutex_t		work_done_wait_mutex = PTHREAD_MUTEX_INITIALIZER;
+
+static unsigned long		nr_run_events;
+static unsigned long		nr_sleep_events;
+static unsigned long		nr_wakeup_events;
+
+static unsigned long		nr_sleep_corrections;
+static unsigned long		nr_run_events_optimized;
+
+static unsigned long		targetless_wakeups;
+static unsigned long		multitarget_wakeups;
+
+static u64			cpu_usage;
+static u64			runavg_cpu_usage;
+static u64			parent_cpu_usage;
+static u64			runavg_parent_cpu_usage;
+
+static unsigned long		nr_runs;
+static u64			sum_runtime;
+static u64			sum_fluct;
+static u64			run_avg;
+
+static unsigned long		replay_repeat = 10;
+static unsigned long		nr_timestamps;
+static unsigned long		nr_unordered_timestamps;
+static unsigned long		nr_state_machine_bugs;
+static unsigned long		nr_context_switch_bugs;
+static unsigned long		nr_events;
+static unsigned long		nr_lost_chunks;
+static unsigned long		nr_lost_events;
+
+#define TASK_STATE_TO_CHAR_STR "RSDTtZX"
+
+enum thread_state {
+	THREAD_SLEEPING = 0,
+	THREAD_WAIT_CPU,
+	THREAD_SCHED_IN,
+	THREAD_IGNORE
+};
+
+struct work_atom {
+	struct list_head	list;
+	enum thread_state	state;
+	u64			sched_out_time;
+	u64			wake_up_time;
+	u64			sched_in_time;
+	u64			runtime;
+};
+
+struct work_atoms {
+	struct list_head	work_list;
+	struct thread		*thread;
+	struct rb_node		node;
+	u64			max_lat;
+	u64			total_lat;
+	u64			nb_atoms;
+	u64			total_runtime;
+};
+
+typedef int (*sort_fn_t)(struct work_atoms *, struct work_atoms *);
+
+static struct rb_root		atom_root, sorted_atom_root;
+
+static u64			all_runtime;
+static u64			all_count;
+
+
+static u64 get_nsecs(void)
+{
+	struct timespec ts;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+
+	return ts.tv_sec * 1000000000ULL + ts.tv_nsec;
+}
+
+static void burn_nsecs(u64 nsecs)
+{
+	u64 T0 = get_nsecs(), T1;
+
+	do {
+		T1 = get_nsecs();
+	} while (T1 + run_measurement_overhead < T0 + nsecs);
+}
+
+static void sleep_nsecs(u64 nsecs)
+{
+	struct timespec ts;
+
+	ts.tv_nsec = nsecs % 999999999;
+	ts.tv_sec = nsecs / 999999999;
+
+	nanosleep(&ts, NULL);
+}
+
+static void calibrate_run_measurement_overhead(void)
+{
+	u64 T0, T1, delta, min_delta = 1000000000ULL;
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		T0 = get_nsecs();
+		burn_nsecs(0);
+		T1 = get_nsecs();
+		delta = T1-T0;
+		min_delta = min(min_delta, delta);
+	}
+	run_measurement_overhead = min_delta;
+
+	printf("run measurement overhead: %Ld nsecs\n", min_delta);
+}
+
+static void calibrate_sleep_measurement_overhead(void)
+{
+	u64 T0, T1, delta, min_delta = 1000000000ULL;
+	int i;
+
+	for (i = 0; i < 10; i++) {
+		T0 = get_nsecs();
+		sleep_nsecs(10000);
+		T1 = get_nsecs();
+		delta = T1-T0;
+		min_delta = min(min_delta, delta);
+	}
+	min_delta -= 10000;
+	sleep_measurement_overhead = min_delta;
+
+	printf("sleep measurement overhead: %Ld nsecs\n", min_delta);
+}
+
+static struct sched_atom *
+get_new_event(struct task_desc *task, u64 timestamp)
+{
+	struct sched_atom *event = calloc(1, sizeof(*event));
+	unsigned long idx = task->nr_events;
+	size_t size;
+
+	event->timestamp = timestamp;
+	event->nr = idx;
+
+	task->nr_events++;
+	size = sizeof(struct sched_atom *) * task->nr_events;
+	task->atoms = realloc(task->atoms, size);
+	BUG_ON(!task->atoms);
+
+	task->atoms[idx] = event;
+
+	return event;
+}
+
+static struct sched_atom *last_event(struct task_desc *task)
+{
+	if (!task->nr_events)
+		return NULL;
+
+	return task->atoms[task->nr_events - 1];
+}
+
+static void
+add_sched_event_run(struct task_desc *task, u64 timestamp, u64 duration)
+{
+	struct sched_atom *event, *curr_event = last_event(task);
+
+	/*
+	 * optimize an existing RUN event by merging this one
+	 * to it:
+	 */
+	if (curr_event && curr_event->type == SCHED_EVENT_RUN) {
+		nr_run_events_optimized++;
+		curr_event->duration += duration;
+		return;
+	}
+
+	event = get_new_event(task, timestamp);
+
+	event->type = SCHED_EVENT_RUN;
+	event->duration = duration;
+
+	nr_run_events++;
+}
+
+static void
+add_sched_event_wakeup(struct task_desc *task, u64 timestamp,
+		       struct task_desc *wakee)
+{
+	struct sched_atom *event, *wakee_event;
+
+	event = get_new_event(task, timestamp);
+	event->type = SCHED_EVENT_WAKEUP;
+	event->wakee = wakee;
+
+	wakee_event = last_event(wakee);
+	if (!wakee_event || wakee_event->type != SCHED_EVENT_SLEEP) {
+		targetless_wakeups++;
+		return;
+	}
+	if (wakee_event->wait_sem) {
+		multitarget_wakeups++;
+		return;
+	}
+
+	wakee_event->wait_sem = calloc(1, sizeof(*wakee_event->wait_sem));
+	sem_init(wakee_event->wait_sem, 0, 0);
+	wakee_event->specific_wait = 1;
+	event->wait_sem = wakee_event->wait_sem;
+
+	nr_wakeup_events++;
+}
+
+static void
+add_sched_event_sleep(struct task_desc *task, u64 timestamp,
+		      u64 task_state __used)
+{
+	struct sched_atom *event = get_new_event(task, timestamp);
+
+	event->type = SCHED_EVENT_SLEEP;
+
+	nr_sleep_events++;
+}
+
+static struct task_desc *register_pid(unsigned long pid, const char *comm)
+{
+	struct task_desc *task;
+
+	BUG_ON(pid >= MAX_PID);
+
+	task = pid_to_task[pid];
+
+	if (task)
+		return task;
+
+	task = calloc(1, sizeof(*task));
+	task->pid = pid;
+	task->nr = nr_tasks;
+	strcpy(task->comm, comm);
+	/*
+	 * every task starts in sleeping state - this gets ignored
+	 * if there's no wakeup pointing to this sleep state:
+	 */
+	add_sched_event_sleep(task, 0, 0);
+
+	pid_to_task[pid] = task;
+	nr_tasks++;
+	tasks = realloc(tasks, nr_tasks*sizeof(struct task_task *));
+	BUG_ON(!tasks);
+	tasks[task->nr] = task;
+
+	if (verbose)
+		printf("registered task #%ld, PID %ld (%s)\n", nr_tasks, pid, comm);
+
+	return task;
+}
+
+
+static void print_task_traces(void)
+{
+	struct task_desc *task;
+	unsigned long i;
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		printf("task %6ld (%20s:%10ld), nr_events: %ld\n",
+			task->nr, task->comm, task->pid, task->nr_events);
+	}
+}
+
+static void add_cross_task_wakeups(void)
+{
+	struct task_desc *task1, *task2;
+	unsigned long i, j;
+
+	for (i = 0; i < nr_tasks; i++) {
+		task1 = tasks[i];
+		j = i + 1;
+		if (j == nr_tasks)
+			j = 0;
+		task2 = tasks[j];
+		add_sched_event_wakeup(task1, 0, task2);
+	}
+}
+
+static void
+process_sched_event(struct task_desc *this_task __used, struct sched_atom *atom)
+{
+	int ret = 0;
+	u64 now;
+	long long delta;
+
+	now = get_nsecs();
+	delta = start_time + atom->timestamp - now;
+
+	switch (atom->type) {
+		case SCHED_EVENT_RUN:
+			burn_nsecs(atom->duration);
+			break;
+		case SCHED_EVENT_SLEEP:
+			if (atom->wait_sem)
+				ret = sem_wait(atom->wait_sem);
+			BUG_ON(ret);
+			break;
+		case SCHED_EVENT_WAKEUP:
+			if (atom->wait_sem)
+				ret = sem_post(atom->wait_sem);
+			BUG_ON(ret);
+			break;
+		default:
+			BUG_ON(1);
+	}
+}
+
+static u64 get_cpu_usage_nsec_parent(void)
+{
+	struct rusage ru;
+	u64 sum;
+	int err;
+
+	err = getrusage(RUSAGE_SELF, &ru);
+	BUG_ON(err);
+
+	sum =  ru.ru_utime.tv_sec*1e9 + ru.ru_utime.tv_usec*1e3;
+	sum += ru.ru_stime.tv_sec*1e9 + ru.ru_stime.tv_usec*1e3;
+
+	return sum;
+}
+
+static u64 get_cpu_usage_nsec_self(void)
+{
+	char filename [] = "/proc/1234567890/sched";
+	unsigned long msecs, nsecs;
+	char *line = NULL;
+	u64 total = 0;
+	size_t len = 0;
+	ssize_t chars;
+	FILE *file;
+	int ret;
+
+	sprintf(filename, "/proc/%d/sched", getpid());
+	file = fopen(filename, "r");
+	BUG_ON(!file);
+
+	while ((chars = getline(&line, &len, file)) != -1) {
+		ret = sscanf(line, "se.sum_exec_runtime : %ld.%06ld\n",
+			&msecs, &nsecs);
+		if (ret == 2) {
+			total = msecs*1e6 + nsecs;
+			break;
+		}
+	}
+	if (line)
+		free(line);
+	fclose(file);
+
+	return total;
+}
+
+static void *thread_func(void *ctx)
+{
+	struct task_desc *this_task = ctx;
+	u64 cpu_usage_0, cpu_usage_1;
+	unsigned long i, ret;
+	char comm2[22];
+
+	sprintf(comm2, ":%s", this_task->comm);
+	prctl(PR_SET_NAME, comm2);
+
+again:
+	ret = sem_post(&this_task->ready_for_work);
+	BUG_ON(ret);
+	ret = pthread_mutex_lock(&start_work_mutex);
+	BUG_ON(ret);
+	ret = pthread_mutex_unlock(&start_work_mutex);
+	BUG_ON(ret);
+
+	cpu_usage_0 = get_cpu_usage_nsec_self();
+
+	for (i = 0; i < this_task->nr_events; i++) {
+		this_task->curr_event = i;
+		process_sched_event(this_task, this_task->atoms[i]);
+	}
+
+	cpu_usage_1 = get_cpu_usage_nsec_self();
+	this_task->cpu_usage = cpu_usage_1 - cpu_usage_0;
+
+	ret = sem_post(&this_task->work_done_sem);
+	BUG_ON(ret);
+
+	ret = pthread_mutex_lock(&work_done_wait_mutex);
+	BUG_ON(ret);
+	ret = pthread_mutex_unlock(&work_done_wait_mutex);
+	BUG_ON(ret);
+
+	goto again;
+}
+
+static void create_tasks(void)
+{
+	struct task_desc *task;
+	pthread_attr_t attr;
+	unsigned long i;
+	int err;
+
+	err = pthread_attr_init(&attr);
+	BUG_ON(err);
+	err = pthread_attr_setstacksize(&attr, (size_t)(16*1024));
+	BUG_ON(err);
+	err = pthread_mutex_lock(&start_work_mutex);
+	BUG_ON(err);
+	err = pthread_mutex_lock(&work_done_wait_mutex);
+	BUG_ON(err);
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		sem_init(&task->sleep_sem, 0, 0);
+		sem_init(&task->ready_for_work, 0, 0);
+		sem_init(&task->work_done_sem, 0, 0);
+		task->curr_event = 0;
+		err = pthread_create(&task->thread, &attr, thread_func, task);
+		BUG_ON(err);
+	}
+}
+
+static void wait_for_tasks(void)
+{
+	u64 cpu_usage_0, cpu_usage_1;
+	struct task_desc *task;
+	unsigned long i, ret;
+
+	start_time = get_nsecs();
+	cpu_usage = 0;
+	pthread_mutex_unlock(&work_done_wait_mutex);
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		ret = sem_wait(&task->ready_for_work);
+		BUG_ON(ret);
+		sem_init(&task->ready_for_work, 0, 0);
+	}
+	ret = pthread_mutex_lock(&work_done_wait_mutex);
+	BUG_ON(ret);
+
+	cpu_usage_0 = get_cpu_usage_nsec_parent();
+
+	pthread_mutex_unlock(&start_work_mutex);
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		ret = sem_wait(&task->work_done_sem);
+		BUG_ON(ret);
+		sem_init(&task->work_done_sem, 0, 0);
+		cpu_usage += task->cpu_usage;
+		task->cpu_usage = 0;
+	}
+
+	cpu_usage_1 = get_cpu_usage_nsec_parent();
+	if (!runavg_cpu_usage)
+		runavg_cpu_usage = cpu_usage;
+	runavg_cpu_usage = (runavg_cpu_usage*9 + cpu_usage)/10;
+
+	parent_cpu_usage = cpu_usage_1 - cpu_usage_0;
+	if (!runavg_parent_cpu_usage)
+		runavg_parent_cpu_usage = parent_cpu_usage;
+	runavg_parent_cpu_usage = (runavg_parent_cpu_usage*9 +
+				   parent_cpu_usage)/10;
+
+	ret = pthread_mutex_lock(&start_work_mutex);
+	BUG_ON(ret);
+
+	for (i = 0; i < nr_tasks; i++) {
+		task = tasks[i];
+		sem_init(&task->sleep_sem, 0, 0);
+		task->curr_event = 0;
+	}
+}
+
+static void run_one_test(void)
+{
+	u64 T0, T1, delta, avg_delta, fluct, std_dev;
+
+	T0 = get_nsecs();
+	wait_for_tasks();
+	T1 = get_nsecs();
+
+	delta = T1 - T0;
+	sum_runtime += delta;
+	nr_runs++;
+
+	avg_delta = sum_runtime / nr_runs;
+	if (delta < avg_delta)
+		fluct = avg_delta - delta;
+	else
+		fluct = delta - avg_delta;
+	sum_fluct += fluct;
+	std_dev = sum_fluct / nr_runs / sqrt(nr_runs);
+	if (!run_avg)
+		run_avg = delta;
+	run_avg = (run_avg*9 + delta)/10;
+
+	printf("#%-3ld: %0.3f, ",
+		nr_runs, (double)delta/1000000.0);
+
+	printf("ravg: %0.2f, ",
+		(double)run_avg/1e6);
+
+	printf("cpu: %0.2f / %0.2f",
+		(double)cpu_usage/1e6, (double)runavg_cpu_usage/1e6);
+
+#if 0
+	/*
+	 * rusage statistics done by the parent, these are less
+	 * accurate than the sum_exec_runtime based statistics:
+	 */
+	printf(" [%0.2f / %0.2f]",
+		(double)parent_cpu_usage/1e6,
+		(double)runavg_parent_cpu_usage/1e6);
+#endif
+
+	printf("\n");
+
+	if (nr_sleep_corrections)
+		printf(" (%ld sleep corrections)\n", nr_sleep_corrections);
+	nr_sleep_corrections = 0;
+}
+
+static void test_calibrations(void)
+{
+	u64 T0, T1;
+
+	T0 = get_nsecs();
+	burn_nsecs(1e6);
+	T1 = get_nsecs();
+
+	printf("the run test took %Ld nsecs\n", T1-T0);
+
+	T0 = get_nsecs();
+	sleep_nsecs(1e6);
+	T1 = get_nsecs();
+
+	printf("the sleep test took %Ld nsecs\n", T1-T0);
+}
+
+static int
+process_comm_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	struct thread *thread;
+
+	thread = threads__findnew(event->comm.pid, &threads, &last_match);
+
+	dump_printf("%p [%p]: perf_event_comm: %s:%d\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->comm.comm, event->comm.pid);
+
+	if (thread == NULL ||
+	    thread__set_comm(thread, event->comm.comm)) {
+		dump_printf("problem processing perf_event_comm, skipping event.\n");
+		return -1;
+	}
+	total_comm++;
+
+	return 0;
+}
+
+
+struct raw_event_sample {
+	u32 size;
+	char data[0];
+};
+
+#define FILL_FIELD(ptr, field, event, data)	\
+	ptr.field = (typeof(ptr.field)) raw_field_value(event, #field, data)
+
+#define FILL_ARRAY(ptr, array, event, data)			\
+do {								\
+	void *__array = raw_field_ptr(event, #array, data);	\
+	memcpy(ptr.array, __array, sizeof(ptr.array));	\
+} while(0)
+
+#define FILL_COMMON_FIELDS(ptr, event, data)			\
+do {								\
+	FILL_FIELD(ptr, common_type, event, data);		\
+	FILL_FIELD(ptr, common_flags, event, data);		\
+	FILL_FIELD(ptr, common_preempt_count, event, data);	\
+	FILL_FIELD(ptr, common_pid, event, data);		\
+	FILL_FIELD(ptr, common_tgid, event, data);		\
+} while (0)
+
+
+
+struct trace_switch_event {
+	u32 size;
+
+	u16 common_type;
+	u8 common_flags;
+	u8 common_preempt_count;
+	u32 common_pid;
+	u32 common_tgid;
+
+	char prev_comm[16];
+	u32 prev_pid;
+	u32 prev_prio;
+	u64 prev_state;
+	char next_comm[16];
+	u32 next_pid;
+	u32 next_prio;
+};
+
+struct trace_runtime_event {
+	u32 size;
+
+	u16 common_type;
+	u8 common_flags;
+	u8 common_preempt_count;
+	u32 common_pid;
+	u32 common_tgid;
+
+	char comm[16];
+	u32 pid;
+	u64 runtime;
+	u64 vruntime;
+};
+
+struct trace_wakeup_event {
+	u32 size;
+
+	u16 common_type;
+	u8 common_flags;
+	u8 common_preempt_count;
+	u32 common_pid;
+	u32 common_tgid;
+
+	char comm[16];
+	u32 pid;
+
+	u32 prio;
+	u32 success;
+	u32 cpu;
+};
+
+struct trace_fork_event {
+	u32 size;
+
+	u16 common_type;
+	u8 common_flags;
+	u8 common_preempt_count;
+	u32 common_pid;
+	u32 common_tgid;
+
+	char parent_comm[16];
+	u32 parent_pid;
+	char child_comm[16];
+	u32 child_pid;
+};
+
+struct trace_sched_handler {
+	void (*switch_event)(struct trace_switch_event *,
+			     struct event *,
+			     int cpu,
+			     u64 timestamp,
+			     struct thread *thread);
+
+	void (*runtime_event)(struct trace_runtime_event *,
+			      struct event *,
+			      int cpu,
+			      u64 timestamp,
+			      struct thread *thread);
+
+	void (*wakeup_event)(struct trace_wakeup_event *,
+			     struct event *,
+			     int cpu,
+			     u64 timestamp,
+			     struct thread *thread);
+
+	void (*fork_event)(struct trace_fork_event *,
+			   struct event *,
+			   int cpu,
+			   u64 timestamp,
+			   struct thread *thread);
+};
+
+
+static void
+replay_wakeup_event(struct trace_wakeup_event *wakeup_event,
+		    struct event *event,
+		    int cpu __used,
+		    u64 timestamp __used,
+		    struct thread *thread __used)
+{
+	struct task_desc *waker, *wakee;
+
+	if (verbose) {
+		printf("sched_wakeup event %p\n", event);
+
+		printf(" ... pid %d woke up %s/%d\n",
+			wakeup_event->common_pid,
+			wakeup_event->comm,
+			wakeup_event->pid);
+	}
+
+	waker = register_pid(wakeup_event->common_pid, "<unknown>");
+	wakee = register_pid(wakeup_event->pid, wakeup_event->comm);
+
+	add_sched_event_wakeup(waker, timestamp, wakee);
+}
+
+static u64 cpu_last_switched[MAX_CPUS];
+
+static void
+replay_switch_event(struct trace_switch_event *switch_event,
+		    struct event *event,
+		    int cpu,
+		    u64 timestamp,
+		    struct thread *thread __used)
+{
+	struct task_desc *prev, *next;
+	u64 timestamp0;
+	s64 delta;
+
+	if (verbose)
+		printf("sched_switch event %p\n", event);
+
+	if (cpu >= MAX_CPUS || cpu < 0)
+		return;
+
+	timestamp0 = cpu_last_switched[cpu];
+	if (timestamp0)
+		delta = timestamp - timestamp0;
+	else
+		delta = 0;
+
+	if (delta < 0)
+		die("hm, delta: %Ld < 0 ?\n", delta);
+
+	if (verbose) {
+		printf(" ... switch from %s/%d to %s/%d [ran %Ld nsecs]\n",
+			switch_event->prev_comm, switch_event->prev_pid,
+			switch_event->next_comm, switch_event->next_pid,
+			delta);
+	}
+
+	prev = register_pid(switch_event->prev_pid, switch_event->prev_comm);
+	next = register_pid(switch_event->next_pid, switch_event->next_comm);
+
+	cpu_last_switched[cpu] = timestamp;
+
+	add_sched_event_run(prev, timestamp, delta);
+	add_sched_event_sleep(prev, timestamp, switch_event->prev_state);
+}
+
+
+static void
+replay_fork_event(struct trace_fork_event *fork_event,
+		  struct event *event,
+		  int cpu __used,
+		  u64 timestamp __used,
+		  struct thread *thread __used)
+{
+	if (verbose) {
+		printf("sched_fork event %p\n", event);
+		printf("... parent: %s/%d\n", fork_event->parent_comm, fork_event->parent_pid);
+		printf("...  child: %s/%d\n", fork_event->child_comm, fork_event->child_pid);
+	}
+	register_pid(fork_event->parent_pid, fork_event->parent_comm);
+	register_pid(fork_event->child_pid, fork_event->child_comm);
+}
+
+static struct trace_sched_handler replay_ops  = {
+	.wakeup_event		= replay_wakeup_event,
+	.switch_event		= replay_switch_event,
+	.fork_event		= replay_fork_event,
+};
+
+struct sort_dimension {
+	const char		*name;
+	sort_fn_t		cmp;
+	struct list_head	list;
+};
+
+static LIST_HEAD(cmp_pid);
+
+static int
+thread_lat_cmp(struct list_head *list, struct work_atoms *l, struct work_atoms *r)
+{
+	struct sort_dimension *sort;
+	int ret = 0;
+
+	BUG_ON(list_empty(list));
+
+	list_for_each_entry(sort, list, list) {
+		ret = sort->cmp(l, r);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+static struct work_atoms *
+thread_atoms_search(struct rb_root *root, struct thread *thread,
+			 struct list_head *sort_list)
+{
+	struct rb_node *node = root->rb_node;
+	struct work_atoms key = { .thread = thread };
+
+	while (node) {
+		struct work_atoms *atoms;
+		int cmp;
+
+		atoms = container_of(node, struct work_atoms, node);
+
+		cmp = thread_lat_cmp(sort_list, &key, atoms);
+		if (cmp > 0)
+			node = node->rb_left;
+		else if (cmp < 0)
+			node = node->rb_right;
+		else {
+			BUG_ON(thread != atoms->thread);
+			return atoms;
+		}
+	}
+	return NULL;
+}
+
+static void
+__thread_latency_insert(struct rb_root *root, struct work_atoms *data,
+			 struct list_head *sort_list)
+{
+	struct rb_node **new = &(root->rb_node), *parent = NULL;
+
+	while (*new) {
+		struct work_atoms *this;
+		int cmp;
+
+		this = container_of(*new, struct work_atoms, node);
+		parent = *new;
+
+		cmp = thread_lat_cmp(sort_list, data, this);
+
+		if (cmp > 0)
+			new = &((*new)->rb_left);
+		else
+			new = &((*new)->rb_right);
+	}
+
+	rb_link_node(&data->node, parent, new);
+	rb_insert_color(&data->node, root);
+}
+
+static void thread_atoms_insert(struct thread *thread)
+{
+	struct work_atoms *atoms;
+
+	atoms = calloc(sizeof(*atoms), 1);
+	if (!atoms)
+		die("No memory");
+
+	atoms->thread = thread;
+	INIT_LIST_HEAD(&atoms->work_list);
+	__thread_latency_insert(&atom_root, atoms, &cmp_pid);
+}
+
+static void
+latency_fork_event(struct trace_fork_event *fork_event __used,
+		   struct event *event __used,
+		   int cpu __used,
+		   u64 timestamp __used,
+		   struct thread *thread __used)
+{
+	/* should insert the newcomer */
+}
+
+__used
+static char sched_out_state(struct trace_switch_event *switch_event)
+{
+	const char *str = TASK_STATE_TO_CHAR_STR;
+
+	return str[switch_event->prev_state];
+}
+
+static void
+add_sched_out_event(struct work_atoms *atoms,
+		    char run_state,
+		    u64 timestamp)
+{
+	struct work_atom *atom;
+
+	atom = calloc(sizeof(*atom), 1);
+	if (!atom)
+		die("Non memory");
+
+	atom->sched_out_time = timestamp;
+
+	if (run_state == 'R') {
+		atom->state = THREAD_WAIT_CPU;
+		atom->wake_up_time = atom->sched_out_time;
+	}
+
+	list_add_tail(&atom->list, &atoms->work_list);
+}
+
+static void
+add_runtime_event(struct work_atoms *atoms, u64 delta, u64 timestamp __used)
+{
+	struct work_atom *atom;
+
+	BUG_ON(list_empty(&atoms->work_list));
+
+	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
+
+	atom->runtime += delta;
+	atoms->total_runtime += delta;
+}
+
+static void
+add_sched_in_event(struct work_atoms *atoms, u64 timestamp)
+{
+	struct work_atom *atom;
+	u64 delta;
+
+	if (list_empty(&atoms->work_list))
+		return;
+
+	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
+
+	if (atom->state != THREAD_WAIT_CPU)
+		return;
+
+	if (timestamp < atom->wake_up_time) {
+		atom->state = THREAD_IGNORE;
+		return;
+	}
+
+	atom->state = THREAD_SCHED_IN;
+	atom->sched_in_time = timestamp;
+
+	delta = atom->sched_in_time - atom->wake_up_time;
+	atoms->total_lat += delta;
+	if (delta > atoms->max_lat)
+		atoms->max_lat = delta;
+	atoms->nb_atoms++;
+}
+
+static void
+latency_switch_event(struct trace_switch_event *switch_event,
+		     struct event *event __used,
+		     int cpu,
+		     u64 timestamp,
+		     struct thread *thread __used)
+{
+	struct work_atoms *out_events, *in_events;
+	struct thread *sched_out, *sched_in;
+	u64 timestamp0;
+	s64 delta;
+
+	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
+
+	timestamp0 = cpu_last_switched[cpu];
+	cpu_last_switched[cpu] = timestamp;
+	if (timestamp0)
+		delta = timestamp - timestamp0;
+	else
+		delta = 0;
+
+	if (delta < 0)
+		die("hm, delta: %Ld < 0 ?\n", delta);
+
+
+	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
+	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
+
+	out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
+	if (!out_events) {
+		thread_atoms_insert(sched_out);
+		out_events = thread_atoms_search(&atom_root, sched_out, &cmp_pid);
+		if (!out_events)
+			die("out-event: Internal tree error");
+	}
+	add_sched_out_event(out_events, sched_out_state(switch_event), timestamp);
+
+	in_events = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
+	if (!in_events) {
+		thread_atoms_insert(sched_in);
+		in_events = thread_atoms_search(&atom_root, sched_in, &cmp_pid);
+		if (!in_events)
+			die("in-event: Internal tree error");
+		/*
+		 * Take came in we have not heard about yet,
+		 * add in an initial atom in runnable state:
+		 */
+		add_sched_out_event(in_events, 'R', timestamp);
+	}
+	add_sched_in_event(in_events, timestamp);
+}
+
+static void
+latency_runtime_event(struct trace_runtime_event *runtime_event,
+		     struct event *event __used,
+		     int cpu,
+		     u64 timestamp,
+		     struct thread *this_thread __used)
+{
+	struct work_atoms *atoms;
+	struct thread *thread;
+
+	BUG_ON(cpu >= MAX_CPUS || cpu < 0);
+
+	thread = threads__findnew(runtime_event->pid, &threads, &last_match);
+	atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
+	if (!atoms) {
+		thread_atoms_insert(thread);
+		atoms = thread_atoms_search(&atom_root, thread, &cmp_pid);
+		if (!atoms)
+			die("in-event: Internal tree error");
+		add_sched_out_event(atoms, 'R', timestamp);
+	}
+
+	add_runtime_event(atoms, runtime_event->runtime, timestamp);
+}
+
+static void
+latency_wakeup_event(struct trace_wakeup_event *wakeup_event,
+		     struct event *__event __used,
+		     int cpu __used,
+		     u64 timestamp,
+		     struct thread *thread __used)
+{
+	struct work_atoms *atoms;
+	struct work_atom *atom;
+	struct thread *wakee;
+
+	/* Note for later, it may be interesting to observe the failing cases */
+	if (!wakeup_event->success)
+		return;
+
+	wakee = threads__findnew(wakeup_event->pid, &threads, &last_match);
+	atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
+	if (!atoms) {
+		thread_atoms_insert(wakee);
+		atoms = thread_atoms_search(&atom_root, wakee, &cmp_pid);
+		if (!atoms)
+			die("wakeup-event: Internal tree error");
+		add_sched_out_event(atoms, 'S', timestamp);
+	}
+
+	BUG_ON(list_empty(&atoms->work_list));
+
+	atom = list_entry(atoms->work_list.prev, struct work_atom, list);
+
+	if (atom->state != THREAD_SLEEPING)
+		nr_state_machine_bugs++;
+
+	nr_timestamps++;
+	if (atom->sched_out_time > timestamp) {
+		nr_unordered_timestamps++;
+		return;
+	}
+
+	atom->state = THREAD_WAIT_CPU;
+	atom->wake_up_time = timestamp;
+}
+
+static struct trace_sched_handler lat_ops  = {
+	.wakeup_event		= latency_wakeup_event,
+	.switch_event		= latency_switch_event,
+	.runtime_event		= latency_runtime_event,
+	.fork_event		= latency_fork_event,
+};
+
+static void output_lat_thread(struct work_atoms *work_list)
+{
+	int i;
+	int ret;
+	u64 avg;
+
+	if (!work_list->nb_atoms)
+		return;
+	/*
+	 * Ignore idle threads:
+	 */
+	if (!strcmp(work_list->thread->comm, "swapper"))
+		return;
+
+	all_runtime += work_list->total_runtime;
+	all_count += work_list->nb_atoms;
+
+	ret = printf("  %s:%d ", work_list->thread->comm, work_list->thread->pid);
+
+	for (i = 0; i < 24 - ret; i++)
+		printf(" ");
+
+	avg = work_list->total_lat / work_list->nb_atoms;
+
+	printf("|%11.3f ms |%9llu | avg:%9.3f ms | max:%9.3f ms |\n",
+	      (double)work_list->total_runtime / 1e6,
+		 work_list->nb_atoms, (double)avg / 1e6,
+		 (double)work_list->max_lat / 1e6);
+}
+
+static int pid_cmp(struct work_atoms *l, struct work_atoms *r)
+{
+	if (l->thread->pid < r->thread->pid)
+		return -1;
+	if (l->thread->pid > r->thread->pid)
+		return 1;
+
+	return 0;
+}
+
+static struct sort_dimension pid_sort_dimension = {
+	.name			= "pid",
+	.cmp			= pid_cmp,
+};
+
+static int avg_cmp(struct work_atoms *l, struct work_atoms *r)
+{
+	u64 avgl, avgr;
+
+	if (!l->nb_atoms)
+		return -1;
+
+	if (!r->nb_atoms)
+		return 1;
+
+	avgl = l->total_lat / l->nb_atoms;
+	avgr = r->total_lat / r->nb_atoms;
+
+	if (avgl < avgr)
+		return -1;
+	if (avgl > avgr)
+		return 1;
+
+	return 0;
+}
+
+static struct sort_dimension avg_sort_dimension = {
+	.name			= "avg",
+	.cmp			= avg_cmp,
+};
+
+static int max_cmp(struct work_atoms *l, struct work_atoms *r)
+{
+	if (l->max_lat < r->max_lat)
+		return -1;
+	if (l->max_lat > r->max_lat)
+		return 1;
+
+	return 0;
+}
+
+static struct sort_dimension max_sort_dimension = {
+	.name			= "max",
+	.cmp			= max_cmp,
+};
+
+static int switch_cmp(struct work_atoms *l, struct work_atoms *r)
+{
+	if (l->nb_atoms < r->nb_atoms)
+		return -1;
+	if (l->nb_atoms > r->nb_atoms)
+		return 1;
+
+	return 0;
+}
+
+static struct sort_dimension switch_sort_dimension = {
+	.name			= "switch",
+	.cmp			= switch_cmp,
+};
+
+static int runtime_cmp(struct work_atoms *l, struct work_atoms *r)
+{
+	if (l->total_runtime < r->total_runtime)
+		return -1;
+	if (l->total_runtime > r->total_runtime)
+		return 1;
+
+	return 0;
+}
+
+static struct sort_dimension runtime_sort_dimension = {
+	.name			= "runtime",
+	.cmp			= runtime_cmp,
+};
+
+static struct sort_dimension *available_sorts[] = {
+	&pid_sort_dimension,
+	&avg_sort_dimension,
+	&max_sort_dimension,
+	&switch_sort_dimension,
+	&runtime_sort_dimension,
+};
+
+#define NB_AVAILABLE_SORTS	(int)(sizeof(available_sorts) / sizeof(struct sort_dimension *))
+
+static LIST_HEAD(sort_list);
+
+static int sort_dimension__add(char *tok, struct list_head *list)
+{
+	int i;
+
+	for (i = 0; i < NB_AVAILABLE_SORTS; i++) {
+		if (!strcmp(available_sorts[i]->name, tok)) {
+			list_add_tail(&available_sorts[i]->list, list);
+
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static void setup_sorting(void);
+
+static void sort_lat(void)
+{
+	struct rb_node *node;
+
+	for (;;) {
+		struct work_atoms *data;
+		node = rb_first(&atom_root);
+		if (!node)
+			break;
+
+		rb_erase(node, &atom_root);
+		data = rb_entry(node, struct work_atoms, node);
+		__thread_latency_insert(&sorted_atom_root, data, &sort_list);
+	}
+}
+
+static struct trace_sched_handler *trace_handler;
+
+static void
+process_sched_wakeup_event(struct raw_event_sample *raw,
+			   struct event *event,
+			   int cpu __used,
+			   u64 timestamp __used,
+			   struct thread *thread __used)
+{
+	struct trace_wakeup_event wakeup_event;
+
+	FILL_COMMON_FIELDS(wakeup_event, event, raw->data);
+
+	FILL_ARRAY(wakeup_event, comm, event, raw->data);
+	FILL_FIELD(wakeup_event, pid, event, raw->data);
+	FILL_FIELD(wakeup_event, prio, event, raw->data);
+	FILL_FIELD(wakeup_event, success, event, raw->data);
+	FILL_FIELD(wakeup_event, cpu, event, raw->data);
+
+	if (trace_handler->wakeup_event)
+		trace_handler->wakeup_event(&wakeup_event, event, cpu, timestamp, thread);
+}
+
+/*
+ * Track the current task - that way we can know whether there's any
+ * weird events, such as a task being switched away that is not current.
+ */
+static int max_cpu;
+
+static u32 curr_pid[MAX_CPUS] = { [0 ... MAX_CPUS-1] = -1 };
+
+static struct thread *curr_thread[MAX_CPUS];
+
+static char next_shortname1 = 'A';
+static char next_shortname2 = '0';
+
+static void
+map_switch_event(struct trace_switch_event *switch_event,
+		 struct event *event __used,
+		 int this_cpu,
+		 u64 timestamp,
+		 struct thread *thread __used)
+{
+	struct thread *sched_out, *sched_in;
+	int new_shortname;
+	u64 timestamp0;
+	s64 delta;
+	int cpu;
+
+	BUG_ON(this_cpu >= MAX_CPUS || this_cpu < 0);
+
+	if (this_cpu > max_cpu)
+		max_cpu = this_cpu;
+
+	timestamp0 = cpu_last_switched[this_cpu];
+	cpu_last_switched[this_cpu] = timestamp;
+	if (timestamp0)
+		delta = timestamp - timestamp0;
+	else
+		delta = 0;
+
+	if (delta < 0)
+		die("hm, delta: %Ld < 0 ?\n", delta);
+
+
+	sched_out = threads__findnew(switch_event->prev_pid, &threads, &last_match);
+	sched_in = threads__findnew(switch_event->next_pid, &threads, &last_match);
+
+	curr_thread[this_cpu] = sched_in;
+
+	printf("  ");
+
+	new_shortname = 0;
+	if (!sched_in->shortname[0]) {
+		sched_in->shortname[0] = next_shortname1;
+		sched_in->shortname[1] = next_shortname2;
+
+		if (next_shortname1 < 'Z') {
+			next_shortname1++;
+		} else {
+			next_shortname1='A';
+			if (next_shortname2 < '9') {
+				next_shortname2++;
+			} else {
+				next_shortname2='0';
+			}
+		}
+		new_shortname = 1;
+	}
+
+	for (cpu = 0; cpu <= max_cpu; cpu++) {
+		if (cpu != this_cpu)
+			printf(" ");
+		else
+			printf("*");
+
+		if (curr_thread[cpu]) {
+			if (curr_thread[cpu]->pid)
+				printf("%2s ", curr_thread[cpu]->shortname);
+			else
+				printf(".  ");
+		} else
+			printf("   ");
+	}
+
+	printf("  %12.6f secs ", (double)timestamp/1e9);
+	if (new_shortname) {
+		printf("%s => %s:%d\n",
+			sched_in->shortname, sched_in->comm, sched_in->pid);
+	} else {
+		printf("\n");
+	}
+}
+
+
+static void
+process_sched_switch_event(struct raw_event_sample *raw,
+			   struct event *event,
+			   int this_cpu,
+			   u64 timestamp __used,
+			   struct thread *thread __used)
+{
+	struct trace_switch_event switch_event;
+
+	FILL_COMMON_FIELDS(switch_event, event, raw->data);
+
+	FILL_ARRAY(switch_event, prev_comm, event, raw->data);
+	FILL_FIELD(switch_event, prev_pid, event, raw->data);
+	FILL_FIELD(switch_event, prev_prio, event, raw->data);
+	FILL_FIELD(switch_event, prev_state, event, raw->data);
+	FILL_ARRAY(switch_event, next_comm, event, raw->data);
+	FILL_FIELD(switch_event, next_pid, event, raw->data);
+	FILL_FIELD(switch_event, next_prio, event, raw->data);
+
+	if (curr_pid[this_cpu] != (u32)-1) {
+		/*
+		 * Are we trying to switch away a PID that is
+		 * not current?
+		 */
+		if (curr_pid[this_cpu] != switch_event.prev_pid)
+			nr_context_switch_bugs++;
+	}
+	if (trace_handler->switch_event)
+		trace_handler->switch_event(&switch_event, event, this_cpu, timestamp, thread);
+
+	curr_pid[this_cpu] = switch_event.next_pid;
+}
+
+static void
+process_sched_runtime_event(struct raw_event_sample *raw,
+			   struct event *event,
+			   int cpu __used,
+			   u64 timestamp __used,
+			   struct thread *thread __used)
+{
+	struct trace_runtime_event runtime_event;
+
+	FILL_ARRAY(runtime_event, comm, event, raw->data);
+	FILL_FIELD(runtime_event, pid, event, raw->data);
+	FILL_FIELD(runtime_event, runtime, event, raw->data);
+	FILL_FIELD(runtime_event, vruntime, event, raw->data);
+
+	if (trace_handler->runtime_event)
+		trace_handler->runtime_event(&runtime_event, event, cpu, timestamp, thread);
+}
+
+static void
+process_sched_fork_event(struct raw_event_sample *raw,
+			 struct event *event,
+			 int cpu __used,
+			 u64 timestamp __used,
+			 struct thread *thread __used)
+{
+	struct trace_fork_event fork_event;
+
+	FILL_COMMON_FIELDS(fork_event, event, raw->data);
+
+	FILL_ARRAY(fork_event, parent_comm, event, raw->data);
+	FILL_FIELD(fork_event, parent_pid, event, raw->data);
+	FILL_ARRAY(fork_event, child_comm, event, raw->data);
+	FILL_FIELD(fork_event, child_pid, event, raw->data);
+
+	if (trace_handler->fork_event)
+		trace_handler->fork_event(&fork_event, event, cpu, timestamp, thread);
+}
+
+static void
+process_sched_exit_event(struct event *event,
+			 int cpu __used,
+			 u64 timestamp __used,
+			 struct thread *thread __used)
+{
+	if (verbose)
+		printf("sched_exit event %p\n", event);
+}
+
+static void
+process_raw_event(event_t *raw_event __used, void *more_data,
+		  int cpu, u64 timestamp, struct thread *thread)
+{
+	struct raw_event_sample *raw = more_data;
+	struct event *event;
+	int type;
+
+	type = trace_parse_common_type(raw->data);
+	event = trace_find_event(type);
+
+	if (!strcmp(event->name, "sched_switch"))
+		process_sched_switch_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_stat_runtime"))
+		process_sched_runtime_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_wakeup"))
+		process_sched_wakeup_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_wakeup_new"))
+		process_sched_wakeup_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_process_fork"))
+		process_sched_fork_event(raw, event, cpu, timestamp, thread);
+	if (!strcmp(event->name, "sched_process_exit"))
+		process_sched_exit_event(event, cpu, timestamp, thread);
+}
+
+static int
+process_sample_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	char level;
+	int show = 0;
+	struct dso *dso = NULL;
+	struct thread *thread;
+	u64 ip = event->ip.ip;
+	u64 timestamp = -1;
+	u32 cpu = -1;
+	u64 period = 1;
+	void *more_data = event->ip.__more_data;
+	int cpumode;
+
+	thread = threads__findnew(event->ip.pid, &threads, &last_match);
+
+	if (sample_type & PERF_SAMPLE_TIME) {
+		timestamp = *(u64 *)more_data;
+		more_data += sizeof(u64);
+	}
+
+	if (sample_type & PERF_SAMPLE_CPU) {
+		cpu = *(u32 *)more_data;
+		more_data += sizeof(u32);
+		more_data += sizeof(u32); /* reserved */
+	}
+
+	if (sample_type & PERF_SAMPLE_PERIOD) {
+		period = *(u64 *)more_data;
+		more_data += sizeof(u64);
+	}
+
+	dump_printf("%p [%p]: PERF_EVENT_SAMPLE (IP, %d): %d/%d: %p period: %Ld\n",
+		(void *)(offset + head),
+		(void *)(long)(event->header.size),
+		event->header.misc,
+		event->ip.pid, event->ip.tid,
+		(void *)(long)ip,
+		(long long)period);
+
+	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
+
+	if (thread == NULL) {
+		eprintf("problem processing %d event, skipping it.\n",
+			event->header.type);
+		return -1;
+	}
+
+	cpumode = event->header.misc & PERF_EVENT_MISC_CPUMODE_MASK;
+
+	if (cpumode == PERF_EVENT_MISC_KERNEL) {
+		show = SHOW_KERNEL;
+		level = 'k';
+
+		dso = kernel_dso;
+
+		dump_printf(" ...... dso: %s\n", dso->name);
+
+	} else if (cpumode == PERF_EVENT_MISC_USER) {
+
+		show = SHOW_USER;
+		level = '.';
+
+	} else {
+		show = SHOW_HV;
+		level = 'H';
+
+		dso = hypervisor_dso;
+
+		dump_printf(" ...... dso: [hypervisor]\n");
+	}
+
+	if (sample_type & PERF_SAMPLE_RAW)
+		process_raw_event(event, more_data, cpu, timestamp, thread);
+
+	return 0;
+}
+
+static int
+process_event(event_t *event, unsigned long offset, unsigned long head)
+{
+	trace_event(event);
+
+	nr_events++;
+	switch (event->header.type) {
+	case PERF_EVENT_MMAP:
+		return 0;
+	case PERF_EVENT_LOST:
+		nr_lost_chunks++;
+		nr_lost_events += event->lost.lost;
+		return 0;
+
+	case PERF_EVENT_COMM:
+		return process_comm_event(event, offset, head);
+
+	case PERF_EVENT_EXIT ... PERF_EVENT_READ:
+		return 0;
+
+	case PERF_EVENT_SAMPLE:
+		return process_sample_event(event, offset, head);
+
+	case PERF_EVENT_MAX:
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static int read_events(void)
+{
+	int ret, rc = EXIT_FAILURE;
+	unsigned long offset = 0;
+	unsigned long head = 0;
+	struct stat perf_stat;
+	event_t *event;
+	uint32_t size;
+	char *buf;
+
+	trace_report();
+	register_idle_thread(&threads, &last_match);
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		perror("failed to open file");
+		exit(-1);
+	}
+
+	ret = fstat(input, &perf_stat);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!perf_stat.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+	header = perf_header__read(input);
+	head = header->data_offset;
+	sample_type = perf_header__sample_type(header);
+
+	if (!(sample_type & PERF_SAMPLE_RAW))
+		die("No trace sample to read. Did you call perf record "
+		    "without -R?");
+
+	if (load_kernel() < 0) {
+		perror("failed to load kernel symbols");
+		return EXIT_FAILURE;
+	}
+
+remap:
+	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
+			   MAP_SHARED, input, offset);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	size = event->header.size;
+	if (!size)
+		size = 8;
+
+	if (head + event->header.size >= page_size * mmap_window) {
+		unsigned long shift = page_size * (head / page_size);
+		int res;
+
+		res = munmap(buf, page_size * mmap_window);
+		assert(res == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+
+	if (!size || process_event(event, offset, head) < 0) {
+
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
+	}
+
+	head += size;
+
+	if (offset + head < (unsigned long)perf_stat.st_size)
+		goto more;
+
+	rc = EXIT_SUCCESS;
+	close(input);
+
+	return rc;
+}
+
+static void print_bad_events(void)
+{
+	if (nr_unordered_timestamps && nr_timestamps) {
+		printf("  INFO: %.3f%% unordered timestamps (%ld out of %ld)\n",
+			(double)nr_unordered_timestamps/(double)nr_timestamps*100.0,
+			nr_unordered_timestamps, nr_timestamps);
+	}
+	if (nr_lost_events && nr_events) {
+		printf("  INFO: %.3f%% lost events (%ld out of %ld, in %ld chunks)\n",
+			(double)nr_lost_events/(double)nr_events*100.0,
+			nr_lost_events, nr_events, nr_lost_chunks);
+	}
+	if (nr_state_machine_bugs && nr_timestamps) {
+		printf("  INFO: %.3f%% state machine bugs (%ld out of %ld)",
+			(double)nr_state_machine_bugs/(double)nr_timestamps*100.0,
+			nr_state_machine_bugs, nr_timestamps);
+		if (nr_lost_events)
+			printf(" (due to lost events?)");
+		printf("\n");
+	}
+	if (nr_context_switch_bugs && nr_timestamps) {
+		printf("  INFO: %.3f%% context switch bugs (%ld out of %ld)",
+			(double)nr_context_switch_bugs/(double)nr_timestamps*100.0,
+			nr_context_switch_bugs, nr_timestamps);
+		if (nr_lost_events)
+			printf(" (due to lost events?)");
+		printf("\n");
+	}
+}
+
+static void __cmd_lat(void)
+{
+	struct rb_node *next;
+
+	setup_pager();
+	read_events();
+	sort_lat();
+
+	printf("\n -----------------------------------------------------------------------------------------\n");
+	printf("  Task                  |   Runtime ms  | Switches | Average delay ms | Maximum delay ms |\n");
+	printf(" -----------------------------------------------------------------------------------------\n");
+
+	next = rb_first(&sorted_atom_root);
+
+	while (next) {
+		struct work_atoms *work_list;
+
+		work_list = rb_entry(next, struct work_atoms, node);
+		output_lat_thread(work_list);
+		next = rb_next(next);
+	}
+
+	printf(" -----------------------------------------------------------------------------------------\n");
+	printf("  TOTAL:                |%11.3f ms |%9Ld |\n",
+		(double)all_runtime/1e6, all_count);
+
+	printf(" ---------------------------------------------------\n");
+
+	print_bad_events();
+	printf("\n");
+
+}
+
+static struct trace_sched_handler map_ops  = {
+	.wakeup_event		= NULL,
+	.switch_event		= map_switch_event,
+	.runtime_event		= NULL,
+	.fork_event		= NULL,
+};
+
+static void __cmd_map(void)
+{
+	max_cpu = sysconf(_SC_NPROCESSORS_CONF);
+
+	setup_pager();
+	read_events();
+	print_bad_events();
+}
+
+static void __cmd_replay(void)
+{
+	unsigned long i;
+
+	calibrate_run_measurement_overhead();
+	calibrate_sleep_measurement_overhead();
+
+	test_calibrations();
+
+	read_events();
+
+	printf("nr_run_events:        %ld\n", nr_run_events);
+	printf("nr_sleep_events:      %ld\n", nr_sleep_events);
+	printf("nr_wakeup_events:     %ld\n", nr_wakeup_events);
+
+	if (targetless_wakeups)
+		printf("target-less wakeups:  %ld\n", targetless_wakeups);
+	if (multitarget_wakeups)
+		printf("multi-target wakeups: %ld\n", multitarget_wakeups);
+	if (nr_run_events_optimized)
+		printf("run atoms optimized: %ld\n",
+			nr_run_events_optimized);
+
+	print_task_traces();
+	add_cross_task_wakeups();
+
+	create_tasks();
+	printf("------------------------------------------------------------\n");
+	for (i = 0; i < replay_repeat; i++)
+		run_one_test();
+}
+
+
+static const char * const sched_usage[] = {
+	"perf sched [<options>] {record|latency|map|replay|trace}",
+	NULL
+};
+
+static const struct option sched_options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+static const char * const latency_usage[] = {
+	"perf sched latency [<options>]",
+	NULL
+};
+
+static const struct option latency_options[] = {
+	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
+		   "sort by key(s): runtime, switch, avg, max"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+static const char * const replay_usage[] = {
+	"perf sched replay [<options>]",
+	NULL
+};
+
+static const struct option replay_options[] = {
+	OPT_INTEGER('r', "repeat", &replay_repeat,
+		    "repeat the workload replay N times (-1: infinite)"),
+	OPT_BOOLEAN('v', "verbose", &verbose,
+		    "be more verbose (show symbol address, etc)"),
+	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
+		    "dump raw trace in ASCII"),
+	OPT_END()
+};
+
+static void setup_sorting(void)
+{
+	char *tmp, *tok, *str = strdup(sort_order);
+
+	for (tok = strtok_r(str, ", ", &tmp);
+			tok; tok = strtok_r(NULL, ", ", &tmp)) {
+		if (sort_dimension__add(tok, &sort_list) < 0) {
+			error("Unknown --sort key: `%s'", tok);
+			usage_with_options(latency_usage, latency_options);
+		}
+	}
+
+	free(str);
+
+	sort_dimension__add((char *)"pid", &cmp_pid);
+}
+
+static const char *record_args[] = {
+	"record",
+	"-a",
+	"-R",
+	"-M",
+	"-f",
+	"-m", "1024",
+	"-c", "1",
+	"-e", "sched:sched_switch:r",
+	"-e", "sched:sched_stat_wait:r",
+	"-e", "sched:sched_stat_sleep:r",
+	"-e", "sched:sched_stat_iowait:r",
+	"-e", "sched:sched_stat_runtime:r",
+	"-e", "sched:sched_process_exit:r",
+	"-e", "sched:sched_process_fork:r",
+	"-e", "sched:sched_wakeup:r",
+	"-e", "sched:sched_migrate_task:r",
+};
+
+static int __cmd_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+
+	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = strdup(record_args[i]);
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	BUG_ON(i != rec_argc);
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
+int cmd_sched(int argc, const char **argv, const char *prefix __used)
+{
+	symbol__init();
+	page_size = getpagesize();
+
+	argc = parse_options(argc, argv, sched_options, sched_usage,
+			     PARSE_OPT_STOP_AT_NON_OPTION);
+	if (!argc)
+		usage_with_options(sched_usage, sched_options);
+
+	if (!strncmp(argv[0], "rec", 3)) {
+		return __cmd_record(argc, argv);
+	} else if (!strncmp(argv[0], "lat", 3)) {
+		trace_handler = &lat_ops;
+		if (argc > 1) {
+			argc = parse_options(argc, argv, latency_options, latency_usage, 0);
+			if (argc)
+				usage_with_options(latency_usage, latency_options);
+		}
+		setup_sorting();
+		__cmd_lat();
+	} else if (!strcmp(argv[0], "map")) {
+		trace_handler = &map_ops;
+		setup_sorting();
+		__cmd_map();
+	} else if (!strncmp(argv[0], "rep", 3)) {
+		trace_handler = &replay_ops;
+		if (argc) {
+			argc = parse_options(argc, argv, replay_options, replay_usage, 0);
+			if (argc)
+				usage_with_options(replay_usage, replay_options);
+		}
+		__cmd_replay();
+	} else if (!strcmp(argv[0], "trace")) {
+		/*
+		 * Aliased to 'perf trace' for now:
+		 */
+		return cmd_trace(argc, argv, prefix);
+	} else {
+		usage_with_options(sched_usage, sched_options);
+	}
+
+	return 0;
+}
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
new file mode 100644
index 0000000..58d737e
--- /dev/null
+++ b/tools/perf/builtin-timechart.c
@@ -0,0 +1,1151 @@
+/*
+ * builtin-timechart.c - make an svg timechart of system activity
+ *
+ * (C) Copyright 2009 Intel Corporation
+ *
+ * Authors:
+ *     Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include "builtin.h"
+
+#include "util/util.h"
+
+#include "util/color.h"
+#include <linux/list.h>
+#include "util/cache.h"
+#include <linux/rbtree.h>
+#include "util/symbol.h"
+#include "util/string.h"
+#include "util/callchain.h"
+#include "util/strlist.h"
+
+#include "perf.h"
+#include "util/header.h"
+#include "util/parse-options.h"
+#include "util/parse-events.h"
+#include "util/svghelper.h"
+
+static char		const *input_name = "perf.data";
+static char		const *output_name = "output.svg";
+
+
+static unsigned long	page_size;
+static unsigned long	mmap_window = 32;
+static u64		sample_type;
+
+static unsigned int	numcpus;
+static u64		min_freq;	/* Lowest CPU frequency seen */
+static u64		max_freq;	/* Highest CPU frequency seen */
+static u64		turbo_frequency;
+
+static u64		first_time, last_time;
+
+
+static struct perf_header	*header;
+
+struct per_pid;
+struct per_pidcomm;
+
+struct cpu_sample;
+struct power_event;
+struct wake_event;
+
+struct sample_wrapper;
+
+/*
+ * Datastructure layout:
+ * We keep an list of "pid"s, matching the kernels notion of a task struct.
+ * Each "pid" entry, has a list of "comm"s.
+ *	this is because we want to track different programs different, while
+ *	exec will reuse the original pid (by design).
+ * Each comm has a list of samples that will be used to draw
+ * final graph.
+ */
+
+struct per_pid {
+	struct per_pid *next;
+
+	int		pid;
+	int		ppid;
+
+	u64		start_time;
+	u64		end_time;
+	u64		total_time;
+	int		display;
+
+	struct per_pidcomm *all;
+	struct per_pidcomm *current;
+
+	int painted;
+};
+
+
+struct per_pidcomm {
+	struct per_pidcomm *next;
+
+	u64		start_time;
+	u64		end_time;
+	u64		total_time;
+
+	int		Y;
+	int		display;
+
+	long		state;
+	u64		state_since;
+
+	char		*comm;
+
+	struct cpu_sample *samples;
+};
+
+struct sample_wrapper {
+	struct sample_wrapper *next;
+
+	u64		timestamp;
+	unsigned char	data[0];
+};
+
+#define TYPE_NONE	0
+#define TYPE_RUNNING	1
+#define TYPE_WAITING	2
+#define TYPE_BLOCKED	3
+
+struct cpu_sample {
+	struct cpu_sample *next;
+
+	u64 start_time;
+	u64 end_time;
+	int type;
+	int cpu;
+};
+
+static struct per_pid *all_data;
+
+#define CSTATE 1
+#define PSTATE 2
+
+struct power_event {
+	struct power_event *next;
+	int type;
+	int state;
+	u64 start_time;
+	u64 end_time;
+	int cpu;
+};
+
+struct wake_event {
+	struct wake_event *next;
+	int waker;
+	int wakee;
+	u64 time;
+};
+
+static struct power_event    *power_events;
+static struct wake_event     *wake_events;
+
+struct sample_wrapper *all_samples;
+
+static struct per_pid *find_create_pid(int pid)
+{
+	struct per_pid *cursor = all_data;
+
+	while (cursor) {
+		if (cursor->pid == pid)
+			return cursor;
+		cursor = cursor->next;
+	}
+	cursor = malloc(sizeof(struct per_pid));
+	assert(cursor != NULL);
+	memset(cursor, 0, sizeof(struct per_pid));
+	cursor->pid = pid;
+	cursor->next = all_data;
+	all_data = cursor;
+	return cursor;
+}
+
+static void pid_set_comm(int pid, char *comm)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	p = find_create_pid(pid);
+	c = p->all;
+	while (c) {
+		if (c->comm && strcmp(c->comm, comm) == 0) {
+			p->current = c;
+			return;
+		}
+		if (!c->comm) {
+			c->comm = strdup(comm);
+			p->current = c;
+			return;
+		}
+		c = c->next;
+	}
+	c = malloc(sizeof(struct per_pidcomm));
+	assert(c != NULL);
+	memset(c, 0, sizeof(struct per_pidcomm));
+	c->comm = strdup(comm);
+	p->current = c;
+	c->next = p->all;
+	p->all = c;
+}
+
+static void pid_fork(int pid, int ppid, u64 timestamp)
+{
+	struct per_pid *p, *pp;
+	p = find_create_pid(pid);
+	pp = find_create_pid(ppid);
+	p->ppid = ppid;
+	if (pp->current && pp->current->comm && !p->current)
+		pid_set_comm(pid, pp->current->comm);
+
+	p->start_time = timestamp;
+	if (p->current) {
+		p->current->start_time = timestamp;
+		p->current->state_since = timestamp;
+	}
+}
+
+static void pid_exit(int pid, u64 timestamp)
+{
+	struct per_pid *p;
+	p = find_create_pid(pid);
+	p->end_time = timestamp;
+	if (p->current)
+		p->current->end_time = timestamp;
+}
+
+static void
+pid_put_sample(int pid, int type, unsigned int cpu, u64 start, u64 end)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	struct cpu_sample *sample;
+
+	p = find_create_pid(pid);
+	c = p->current;
+	if (!c) {
+		c = malloc(sizeof(struct per_pidcomm));
+		assert(c != NULL);
+		memset(c, 0, sizeof(struct per_pidcomm));
+		p->current = c;
+		c->next = p->all;
+		p->all = c;
+	}
+
+	sample = malloc(sizeof(struct cpu_sample));
+	assert(sample != NULL);
+	memset(sample, 0, sizeof(struct cpu_sample));
+	sample->start_time = start;
+	sample->end_time = end;
+	sample->type = type;
+	sample->next = c->samples;
+	sample->cpu = cpu;
+	c->samples = sample;
+
+	if (sample->type == TYPE_RUNNING && end > start && start > 0) {
+		c->total_time += (end-start);
+		p->total_time += (end-start);
+	}
+
+	if (c->start_time == 0 || c->start_time > start)
+		c->start_time = start;
+	if (p->start_time == 0 || p->start_time > start)
+		p->start_time = start;
+
+	if (cpu > numcpus)
+		numcpus = cpu;
+}
+
+#define MAX_CPUS 4096
+
+static u64 cpus_cstate_start_times[MAX_CPUS];
+static int cpus_cstate_state[MAX_CPUS];
+static u64 cpus_pstate_start_times[MAX_CPUS];
+static u64 cpus_pstate_state[MAX_CPUS];
+
+static int
+process_comm_event(event_t *event)
+{
+	pid_set_comm(event->comm.pid, event->comm.comm);
+	return 0;
+}
+static int
+process_fork_event(event_t *event)
+{
+	pid_fork(event->fork.pid, event->fork.ppid, event->fork.time);
+	return 0;
+}
+
+static int
+process_exit_event(event_t *event)
+{
+	pid_exit(event->fork.pid, event->fork.time);
+	return 0;
+}
+
+struct trace_entry {
+	u32			size;
+	unsigned short		type;
+	unsigned char		flags;
+	unsigned char		preempt_count;
+	int			pid;
+	int			tgid;
+};
+
+struct power_entry {
+	struct trace_entry te;
+	s64	type;
+	s64	value;
+};
+
+#define TASK_COMM_LEN 16
+struct wakeup_entry {
+	struct trace_entry te;
+	char comm[TASK_COMM_LEN];
+	int   pid;
+	int   prio;
+	int   success;
+};
+
+/*
+ * trace_flag_type is an enumeration that holds different
+ * states when a trace occurs. These are:
+ *  IRQS_OFF            - interrupts were disabled
+ *  IRQS_NOSUPPORT      - arch does not support irqs_disabled_flags
+ *  NEED_RESCED         - reschedule is requested
+ *  HARDIRQ             - inside an interrupt handler
+ *  SOFTIRQ             - inside a softirq handler
+ */
+enum trace_flag_type {
+	TRACE_FLAG_IRQS_OFF		= 0x01,
+	TRACE_FLAG_IRQS_NOSUPPORT	= 0x02,
+	TRACE_FLAG_NEED_RESCHED		= 0x04,
+	TRACE_FLAG_HARDIRQ		= 0x08,
+	TRACE_FLAG_SOFTIRQ		= 0x10,
+};
+
+
+
+struct sched_switch {
+	struct trace_entry te;
+	char prev_comm[TASK_COMM_LEN];
+	int  prev_pid;
+	int  prev_prio;
+	long prev_state; /* Arjan weeps. */
+	char next_comm[TASK_COMM_LEN];
+	int  next_pid;
+	int  next_prio;
+};
+
+static void c_state_start(int cpu, u64 timestamp, int state)
+{
+	cpus_cstate_start_times[cpu] = timestamp;
+	cpus_cstate_state[cpu] = state;
+}
+
+static void c_state_end(int cpu, u64 timestamp)
+{
+	struct power_event *pwr;
+	pwr = malloc(sizeof(struct power_event));
+	if (!pwr)
+		return;
+	memset(pwr, 0, sizeof(struct power_event));
+
+	pwr->state = cpus_cstate_state[cpu];
+	pwr->start_time = cpus_cstate_start_times[cpu];
+	pwr->end_time = timestamp;
+	pwr->cpu = cpu;
+	pwr->type = CSTATE;
+	pwr->next = power_events;
+
+	power_events = pwr;
+}
+
+static void p_state_change(int cpu, u64 timestamp, u64 new_freq)
+{
+	struct power_event *pwr;
+	pwr = malloc(sizeof(struct power_event));
+
+	if (new_freq > 8000000) /* detect invalid data */
+		return;
+
+	if (!pwr)
+		return;
+	memset(pwr, 0, sizeof(struct power_event));
+
+	pwr->state = cpus_pstate_state[cpu];
+	pwr->start_time = cpus_pstate_start_times[cpu];
+	pwr->end_time = timestamp;
+	pwr->cpu = cpu;
+	pwr->type = PSTATE;
+	pwr->next = power_events;
+
+	if (!pwr->start_time)
+		pwr->start_time = first_time;
+
+	power_events = pwr;
+
+	cpus_pstate_state[cpu] = new_freq;
+	cpus_pstate_start_times[cpu] = timestamp;
+
+	if ((u64)new_freq > max_freq)
+		max_freq = new_freq;
+
+	if (new_freq < min_freq || min_freq == 0)
+		min_freq = new_freq;
+
+	if (new_freq == max_freq - 1000)
+			turbo_frequency = max_freq;
+}
+
+static void
+sched_wakeup(int cpu, u64 timestamp, int pid, struct trace_entry *te)
+{
+	struct wake_event *we;
+	struct per_pid *p;
+	struct wakeup_entry *wake = (void *)te;
+
+	we = malloc(sizeof(struct wake_event));
+	if (!we)
+		return;
+
+	memset(we, 0, sizeof(struct wake_event));
+	we->time = timestamp;
+	we->waker = pid;
+
+	if ((te->flags & TRACE_FLAG_HARDIRQ) || (te->flags & TRACE_FLAG_SOFTIRQ))
+		we->waker = -1;
+
+	we->wakee = wake->pid;
+	we->next = wake_events;
+	wake_events = we;
+	p = find_create_pid(we->wakee);
+
+	if (p && p->current && p->current->state == TYPE_NONE) {
+		p->current->state_since = timestamp;
+		p->current->state = TYPE_WAITING;
+	}
+	if (p && p->current && p->current->state == TYPE_BLOCKED) {
+		pid_put_sample(p->pid, p->current->state, cpu, p->current->state_since, timestamp);
+		p->current->state_since = timestamp;
+		p->current->state = TYPE_WAITING;
+	}
+}
+
+static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
+{
+	struct per_pid *p = NULL, *prev_p;
+	struct sched_switch *sw = (void *)te;
+
+
+	prev_p = find_create_pid(sw->prev_pid);
+
+	p = find_create_pid(sw->next_pid);
+
+	if (prev_p->current && prev_p->current->state != TYPE_NONE)
+		pid_put_sample(sw->prev_pid, TYPE_RUNNING, cpu, prev_p->current->state_since, timestamp);
+	if (p && p->current) {
+		if (p->current->state != TYPE_NONE)
+			pid_put_sample(sw->next_pid, p->current->state, cpu, p->current->state_since, timestamp);
+
+			p->current->state_since = timestamp;
+			p->current->state = TYPE_RUNNING;
+	}
+
+	if (prev_p->current) {
+		prev_p->current->state = TYPE_NONE;
+		prev_p->current->state_since = timestamp;
+		if (sw->prev_state & 2)
+			prev_p->current->state = TYPE_BLOCKED;
+		if (sw->prev_state == 0)
+			prev_p->current->state = TYPE_WAITING;
+	}
+}
+
+
+static int
+process_sample_event(event_t *event)
+{
+	int cursor = 0;
+	u64 addr = 0;
+	u64 stamp = 0;
+	u32 cpu = 0;
+	u32 pid = 0;
+	struct trace_entry *te;
+
+	if (sample_type & PERF_SAMPLE_IP)
+		cursor++;
+
+	if (sample_type & PERF_SAMPLE_TID) {
+		pid = event->sample.array[cursor]>>32;
+		cursor++;
+	}
+	if (sample_type & PERF_SAMPLE_TIME) {
+		stamp = event->sample.array[cursor++];
+
+		if (!first_time || first_time > stamp)
+			first_time = stamp;
+		if (last_time < stamp)
+			last_time = stamp;
+
+	}
+	if (sample_type & PERF_SAMPLE_ADDR)
+		addr = event->sample.array[cursor++];
+	if (sample_type & PERF_SAMPLE_ID)
+		cursor++;
+	if (sample_type & PERF_SAMPLE_STREAM_ID)
+		cursor++;
+	if (sample_type & PERF_SAMPLE_CPU)
+		cpu = event->sample.array[cursor++] & 0xFFFFFFFF;
+	if (sample_type & PERF_SAMPLE_PERIOD)
+		cursor++;
+
+	te = (void *)&event->sample.array[cursor];
+
+	if (sample_type & PERF_SAMPLE_RAW && te->size > 0) {
+		char *event_str;
+		struct power_entry *pe;
+
+		pe = (void *)te;
+
+		event_str = perf_header__find_event(te->type);
+
+		if (!event_str)
+			return 0;
+
+		if (strcmp(event_str, "power:power_start") == 0)
+			c_state_start(cpu, stamp, pe->value);
+
+		if (strcmp(event_str, "power:power_end") == 0)
+			c_state_end(cpu, stamp);
+
+		if (strcmp(event_str, "power:power_frequency") == 0)
+			p_state_change(cpu, stamp, pe->value);
+
+		if (strcmp(event_str, "sched:sched_wakeup") == 0)
+			sched_wakeup(cpu, stamp, pid, te);
+
+		if (strcmp(event_str, "sched:sched_switch") == 0)
+			sched_switch(cpu, stamp, te);
+	}
+	return 0;
+}
+
+/*
+ * After the last sample we need to wrap up the current C/P state
+ * and close out each CPU for these.
+ */
+static void end_sample_processing(void)
+{
+	u64 cpu;
+	struct power_event *pwr;
+
+	for (cpu = 0; cpu < numcpus; cpu++) {
+		pwr = malloc(sizeof(struct power_event));
+		if (!pwr)
+			return;
+		memset(pwr, 0, sizeof(struct power_event));
+
+		/* C state */
+#if 0
+		pwr->state = cpus_cstate_state[cpu];
+		pwr->start_time = cpus_cstate_start_times[cpu];
+		pwr->end_time = last_time;
+		pwr->cpu = cpu;
+		pwr->type = CSTATE;
+		pwr->next = power_events;
+
+		power_events = pwr;
+#endif
+		/* P state */
+
+		pwr = malloc(sizeof(struct power_event));
+		if (!pwr)
+			return;
+		memset(pwr, 0, sizeof(struct power_event));
+
+		pwr->state = cpus_pstate_state[cpu];
+		pwr->start_time = cpus_pstate_start_times[cpu];
+		pwr->end_time = last_time;
+		pwr->cpu = cpu;
+		pwr->type = PSTATE;
+		pwr->next = power_events;
+
+		if (!pwr->start_time)
+			pwr->start_time = first_time;
+		if (!pwr->state)
+			pwr->state = min_freq;
+		power_events = pwr;
+	}
+}
+
+static u64 sample_time(event_t *event)
+{
+	int cursor;
+
+	cursor = 0;
+	if (sample_type & PERF_SAMPLE_IP)
+		cursor++;
+	if (sample_type & PERF_SAMPLE_TID)
+		cursor++;
+	if (sample_type & PERF_SAMPLE_TIME)
+		return event->sample.array[cursor];
+	return 0;
+}
+
+
+/*
+ * We first queue all events, sorted backwards by insertion.
+ * The order will get flipped later.
+ */
+static int
+queue_sample_event(event_t *event)
+{
+	struct sample_wrapper *copy, *prev;
+	int size;
+
+	size = event->sample.header.size + sizeof(struct sample_wrapper) + 8;
+
+	copy = malloc(size);
+	if (!copy)
+		return 1;
+
+	memset(copy, 0, size);
+
+	copy->next = NULL;
+	copy->timestamp = sample_time(event);
+
+	memcpy(&copy->data, event, event->sample.header.size);
+
+	/* insert in the right place in the list */
+
+	if (!all_samples) {
+		/* first sample ever */
+		all_samples = copy;
+		return 0;
+	}
+
+	if (all_samples->timestamp < copy->timestamp) {
+		/* insert at the head of the list */
+		copy->next = all_samples;
+		all_samples = copy;
+		return 0;
+	}
+
+	prev = all_samples;
+	while (prev->next) {
+		if (prev->next->timestamp < copy->timestamp) {
+			copy->next = prev->next;
+			prev->next = copy;
+			return 0;
+		}
+		prev = prev->next;
+	}
+	/* insert at the end of the list */
+	prev->next = copy;
+
+	return 0;
+}
+
+static void sort_queued_samples(void)
+{
+	struct sample_wrapper *cursor, *next;
+
+	cursor = all_samples;
+	all_samples = NULL;
+
+	while (cursor) {
+		next = cursor->next;
+		cursor->next = all_samples;
+		all_samples = cursor;
+		cursor = next;
+	}
+}
+
+/*
+ * Sort the pid datastructure
+ */
+static void sort_pids(void)
+{
+	struct per_pid *new_list, *p, *cursor, *prev;
+	/* sort by ppid first, then by pid, lowest to highest */
+
+	new_list = NULL;
+
+	while (all_data) {
+		p = all_data;
+		all_data = p->next;
+		p->next = NULL;
+
+		if (new_list == NULL) {
+			new_list = p;
+			p->next = NULL;
+			continue;
+		}
+		prev = NULL;
+		cursor = new_list;
+		while (cursor) {
+			if (cursor->ppid > p->ppid ||
+				(cursor->ppid == p->ppid && cursor->pid > p->pid)) {
+				/* must insert before */
+				if (prev) {
+					p->next = prev->next;
+					prev->next = p;
+					cursor = NULL;
+					continue;
+				} else {
+					p->next = new_list;
+					new_list = p;
+					cursor = NULL;
+					continue;
+				}
+			}
+
+			prev = cursor;
+			cursor = cursor->next;
+			if (!cursor)
+				prev->next = p;
+		}
+	}
+	all_data = new_list;
+}
+
+
+static void draw_c_p_states(void)
+{
+	struct power_event *pwr;
+	pwr = power_events;
+
+	/*
+	 * two pass drawing so that the P state bars are on top of the C state blocks
+	 */
+	while (pwr) {
+		if (pwr->type == CSTATE)
+			svg_cstate(pwr->cpu, pwr->start_time, pwr->end_time, pwr->state);
+		pwr = pwr->next;
+	}
+
+	pwr = power_events;
+	while (pwr) {
+		if (pwr->type == PSTATE) {
+			if (!pwr->state)
+				pwr->state = min_freq;
+			svg_pstate(pwr->cpu, pwr->start_time, pwr->end_time, pwr->state);
+		}
+		pwr = pwr->next;
+	}
+}
+
+static void draw_wakeups(void)
+{
+	struct wake_event *we;
+	struct per_pid *p;
+	struct per_pidcomm *c;
+
+	we = wake_events;
+	while (we) {
+		int from = 0, to = 0;
+
+		/* locate the column of the waker and wakee */
+		p = all_data;
+		while (p) {
+			if (p->pid == we->waker || p->pid == we->wakee) {
+				c = p->all;
+				while (c) {
+					if (c->Y && c->start_time <= we->time && c->end_time >= we->time) {
+						if (p->pid == we->waker)
+							from = c->Y;
+						if (p->pid == we->wakee)
+							to = c->Y;
+					}
+					c = c->next;
+				}
+			}
+			p = p->next;
+		}
+
+		if (we->waker == -1)
+			svg_interrupt(we->time, to);
+		else if (from && to && abs(from - to) == 1)
+			svg_wakeline(we->time, from, to);
+		else
+			svg_partial_wakeline(we->time, from, to);
+		we = we->next;
+	}
+}
+
+static void draw_cpu_usage(void)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	struct cpu_sample *sample;
+	p = all_data;
+	while (p) {
+		c = p->all;
+		while (c) {
+			sample = c->samples;
+			while (sample) {
+				if (sample->type == TYPE_RUNNING)
+					svg_process(sample->cpu, sample->start_time, sample->end_time, "sample", c->comm);
+
+				sample = sample->next;
+			}
+			c = c->next;
+		}
+		p = p->next;
+	}
+}
+
+static void draw_process_bars(void)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	struct cpu_sample *sample;
+	int Y = 0;
+
+	Y = 2 * numcpus + 2;
+
+	p = all_data;
+	while (p) {
+		c = p->all;
+		while (c) {
+			if (!c->display) {
+				c->Y = 0;
+				c = c->next;
+				continue;
+			}
+
+			svg_box(Y, p->start_time, p->end_time, "process");
+			sample = c->samples;
+			while (sample) {
+				if (sample->type == TYPE_RUNNING)
+					svg_sample(Y, sample->cpu, sample->start_time, sample->end_time, "sample");
+				if (sample->type == TYPE_BLOCKED)
+					svg_box(Y, sample->start_time, sample->end_time, "blocked");
+				if (sample->type == TYPE_WAITING)
+					svg_box(Y, sample->start_time, sample->end_time, "waiting");
+				sample = sample->next;
+			}
+
+			if (c->comm) {
+				char comm[256];
+				if (c->total_time > 5000000000) /* 5 seconds */
+					sprintf(comm, "%s:%i (%2.2fs)", c->comm, p->pid, c->total_time / 1000000000.0);
+				else
+					sprintf(comm, "%s:%i (%3.1fms)", c->comm, p->pid, c->total_time / 1000000.0);
+
+				svg_text(Y, c->start_time, comm);
+			}
+			c->Y = Y;
+			Y++;
+			c = c->next;
+		}
+		p = p->next;
+	}
+}
+
+static int determine_display_tasks(u64 threshold)
+{
+	struct per_pid *p;
+	struct per_pidcomm *c;
+	int count = 0;
+
+	p = all_data;
+	while (p) {
+		p->display = 0;
+		if (p->start_time == 1)
+			p->start_time = first_time;
+
+		/* no exit marker, task kept running to the end */
+		if (p->end_time == 0)
+			p->end_time = last_time;
+		if (p->total_time >= threshold)
+			p->display = 1;
+
+		c = p->all;
+
+		while (c) {
+			c->display = 0;
+
+			if (c->start_time == 1)
+				c->start_time = first_time;
+
+			if (c->total_time >= threshold) {
+				c->display = 1;
+				count++;
+			}
+
+			if (c->end_time == 0)
+				c->end_time = last_time;
+
+			c = c->next;
+		}
+		p = p->next;
+	}
+	return count;
+}
+
+
+
+#define TIME_THRESH 10000000
+
+static void write_svg_file(const char *filename)
+{
+	u64 i;
+	int count;
+
+	numcpus++;
+
+
+	count = determine_display_tasks(TIME_THRESH);
+
+	/* We'd like to show at least 15 tasks; be less picky if we have fewer */
+	if (count < 15)
+		count = determine_display_tasks(TIME_THRESH / 10);
+
+	open_svg(filename, numcpus, count);
+
+	svg_time_grid(first_time, last_time);
+	svg_legenda();
+
+	for (i = 0; i < numcpus; i++)
+		svg_cpu_box(i, max_freq, turbo_frequency);
+
+	draw_cpu_usage();
+	draw_process_bars();
+	draw_c_p_states();
+	draw_wakeups();
+
+	svg_close();
+}
+
+static int
+process_event(event_t *event)
+{
+
+	switch (event->header.type) {
+
+	case PERF_EVENT_COMM:
+		return process_comm_event(event);
+	case PERF_EVENT_FORK:
+		return process_fork_event(event);
+	case PERF_EVENT_EXIT:
+		return process_exit_event(event);
+	case PERF_EVENT_SAMPLE:
+		return queue_sample_event(event);
+
+	/*
+	 * We dont process them right now but they are fine:
+	 */
+	case PERF_EVENT_MMAP:
+	case PERF_EVENT_THROTTLE:
+	case PERF_EVENT_UNTHROTTLE:
+		return 0;
+
+	default:
+		return -1;
+	}
+
+	return 0;
+}
+
+static void process_samples(void)
+{
+	struct sample_wrapper *cursor;
+	event_t *event;
+
+	sort_queued_samples();
+
+	cursor = all_samples;
+	while (cursor) {
+		event = (void *)&cursor->data;
+		cursor = cursor->next;
+		process_sample_event(event);
+	}
+}
+
+
+static int __cmd_timechart(void)
+{
+	int ret, rc = EXIT_FAILURE;
+	unsigned long offset = 0;
+	unsigned long head, shift;
+	struct stat statbuf;
+	event_t *event;
+	uint32_t size;
+	char *buf;
+	int input;
+
+	input = open(input_name, O_RDONLY);
+	if (input < 0) {
+		fprintf(stderr, " failed to open file: %s", input_name);
+		if (!strcmp(input_name, "perf.data"))
+			fprintf(stderr, "  (try 'perf record' first)");
+		fprintf(stderr, "\n");
+		exit(-1);
+	}
+
+	ret = fstat(input, &statbuf);
+	if (ret < 0) {
+		perror("failed to stat file");
+		exit(-1);
+	}
+
+	if (!statbuf.st_size) {
+		fprintf(stderr, "zero-sized file, nothing to do!\n");
+		exit(0);
+	}
+
+	header = perf_header__read(input);
+	head = header->data_offset;
+
+	sample_type = perf_header__sample_type(header);
+
+	shift = page_size * (head / page_size);
+	offset += shift;
+	head -= shift;
+
+remap:
+	buf = (char *)mmap(NULL, page_size * mmap_window, PROT_READ,
+			   MAP_SHARED, input, offset);
+	if (buf == MAP_FAILED) {
+		perror("failed to mmap file");
+		exit(-1);
+	}
+
+more:
+	event = (event_t *)(buf + head);
+
+	size = event->header.size;
+	if (!size)
+		size = 8;
+
+	if (head + event->header.size >= page_size * mmap_window) {
+		int ret2;
+
+		shift = page_size * (head / page_size);
+
+		ret2 = munmap(buf, page_size * mmap_window);
+		assert(ret2 == 0);
+
+		offset += shift;
+		head -= shift;
+		goto remap;
+	}
+
+	size = event->header.size;
+
+	if (!size || process_event(event) < 0) {
+
+		printf("%p [%p]: skipping unknown header type: %d\n",
+			(void *)(offset + head),
+			(void *)(long)(event->header.size),
+			event->header.type);
+
+		/*
+		 * assume we lost track of the stream, check alignment, and
+		 * increment a single u64 in the hope to catch on again 'soon'.
+		 */
+
+		if (unlikely(head & 7))
+			head &= ~7ULL;
+
+		size = 8;
+	}
+
+	head += size;
+
+	if (offset + head >= header->data_offset + header->data_size)
+		goto done;
+
+	if (offset + head < (unsigned long)statbuf.st_size)
+		goto more;
+
+done:
+	rc = EXIT_SUCCESS;
+	close(input);
+
+
+	process_samples();
+
+	end_sample_processing();
+
+	sort_pids();
+
+	write_svg_file(output_name);
+
+	printf("Written %2.1f seconds of trace to %s.\n", (last_time - first_time) / 1000000000.0, output_name);
+
+	return rc;
+}
+
+static const char * const timechart_usage[] = {
+	"perf timechart [<options>] {record}",
+	NULL
+};
+
+static const char *record_args[] = {
+	"record",
+	"-a",
+	"-R",
+	"-M",
+	"-f",
+	"-c", "1",
+	"-e", "power:power_start",
+	"-e", "power:power_end",
+	"-e", "power:power_frequency",
+	"-e", "sched:sched_wakeup",
+	"-e", "sched:sched_switch",
+};
+
+static int __cmd_record(int argc, const char **argv)
+{
+	unsigned int rec_argc, i, j;
+	const char **rec_argv;
+
+	rec_argc = ARRAY_SIZE(record_args) + argc - 1;
+	rec_argv = calloc(rec_argc + 1, sizeof(char *));
+
+	for (i = 0; i < ARRAY_SIZE(record_args); i++)
+		rec_argv[i] = strdup(record_args[i]);
+
+	for (j = 1; j < (unsigned int)argc; j++, i++)
+		rec_argv[i] = argv[j];
+
+	return cmd_record(i, rec_argv, NULL);
+}
+
+static const struct option options[] = {
+	OPT_STRING('i', "input", &input_name, "file",
+		    "input file name"),
+	OPT_STRING('o', "output", &output_name, "file",
+		    "output file name"),
+	OPT_END()
+};
+
+
+int cmd_timechart(int argc, const char **argv, const char *prefix __used)
+{
+	symbol__init();
+
+	page_size = getpagesize();
+
+	argc = parse_options(argc, argv, options, timechart_usage,
+			PARSE_OPT_STOP_AT_NON_OPTION);
+
+	if (argc && !strncmp(argv[0], "rec", 3))
+		return __cmd_record(argc, argv);
+	else if (argc)
+		usage_with_options(timechart_usage, options);
+
+	setup_pager();
+
+	return __cmd_timechart();
+}
diff --git a/tools/perf/builtin.h b/tools/perf/builtin.h
index 3a63e41..e11d8d2 100644
--- a/tools/perf/builtin.h
+++ b/tools/perf/builtin.h
@@ -16,12 +16,14 @@ extern int check_pager_config(const char *cmd);
 
 extern int cmd_annotate(int argc, const char **argv, const char *prefix);
 extern int cmd_help(int argc, const char **argv, const char *prefix);
+extern int cmd_sched(int argc, const char **argv, const char *prefix);
+extern int cmd_list(int argc, const char **argv, const char *prefix);
 extern int cmd_record(int argc, const char **argv, const char *prefix);
 extern int cmd_report(int argc, const char **argv, const char *prefix);
 extern int cmd_stat(int argc, const char **argv, const char *prefix);
+extern int cmd_timechart(int argc, const char **argv, const char *prefix);
 extern int cmd_top(int argc, const char **argv, const char *prefix);
-extern int cmd_version(int argc, const char **argv, const char *prefix);
-extern int cmd_list(int argc, const char **argv, const char *prefix);
 extern int cmd_trace(int argc, const char **argv, const char *prefix);
+extern int cmd_version(int argc, const char **argv, const char *prefix);
 
 #endif
diff --git a/tools/perf/command-list.txt b/tools/perf/command-list.txt
index eebce30..00326e2 100644
--- a/tools/perf/command-list.txt
+++ b/tools/perf/command-list.txt
@@ -4,7 +4,10 @@
 #
 perf-annotate			mainporcelain common
 perf-list			mainporcelain common
+perf-sched			mainporcelain common
 perf-record			mainporcelain common
 perf-report			mainporcelain common
 perf-stat			mainporcelain common
+perf-timechart			mainporcelain common
 perf-top			mainporcelain common
+perf-trace			mainporcelain common
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index fe4589d..19fc7fe 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -289,10 +289,12 @@ static void handle_internal_command(int argc, const char **argv)
 		{ "record", cmd_record, 0 },
 		{ "report", cmd_report, 0 },
 		{ "stat", cmd_stat, 0 },
+		{ "timechart", cmd_timechart, 0 },
 		{ "top", cmd_top, 0 },
 		{ "annotate", cmd_annotate, 0 },
 		{ "version", cmd_version, 0 },
 		{ "trace", cmd_trace, 0 },
+		{ "sched", cmd_sched, 0 },
 	};
 	unsigned int i;
 	static const char ext[] = STRIP_EXTENSION;
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index fa2d4e9..018d414 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -39,6 +39,7 @@ struct fork_event {
 	struct perf_event_header header;
 	u32 pid, ppid;
 	u32 tid, ptid;
+	u64 time;
 };
 
 struct lost_event {
@@ -52,13 +53,19 @@ struct lost_event {
  */
 struct read_event {
 	struct perf_event_header header;
-	u32 pid,tid;
+	u32 pid, tid;
 	u64 value;
 	u64 time_enabled;
 	u64 time_running;
 	u64 id;
 };
 
+struct sample_event{
+	struct perf_event_header        header;
+	u64 array[];
+};
+
+
 typedef union event_union {
 	struct perf_event_header	header;
 	struct ip_event			ip;
@@ -67,6 +74,7 @@ typedef union event_union {
 	struct fork_event		fork;
 	struct lost_event		lost;
 	struct read_event		read;
+	struct sample_event		sample;
 } event_t;
 
 struct map {
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index ec4d4c2..bb4fca3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -7,9 +7,8 @@
 #include "header.h"
 
 /*
- *
+ * Create new perf.data header attribute:
  */
-
 struct perf_header_attr *perf_header_attr__new(struct perf_counter_attr *attr)
 {
 	struct perf_header_attr *self = malloc(sizeof(*self));
@@ -43,9 +42,8 @@ void perf_header_attr__add_id(struct perf_header_attr *self, u64 id)
 }
 
 /*
- *
+ * Create new perf.data header:
  */
-
 struct perf_header *perf_header__new(void)
 {
 	struct perf_header *self = malloc(sizeof(*self));
@@ -86,6 +84,46 @@ void perf_header__add_attr(struct perf_header *self,
 	self->attr[pos] = attr;
 }
 
+#define MAX_EVENT_NAME 64
+
+struct perf_trace_event_type {
+	u64	event_id;
+	char	name[MAX_EVENT_NAME];
+};
+
+static int event_count;
+static struct perf_trace_event_type *events;
+
+void perf_header__push_event(u64 id, const char *name)
+{
+	if (strlen(name) > MAX_EVENT_NAME)
+		printf("Event %s will be truncated\n", name);
+
+	if (!events) {
+		events = malloc(sizeof(struct perf_trace_event_type));
+		if (!events)
+			die("nomem");
+	} else {
+		events = realloc(events, (event_count + 1) * sizeof(struct perf_trace_event_type));
+		if (!events)
+			die("nomem");
+	}
+	memset(&events[event_count], 0, sizeof(struct perf_trace_event_type));
+	events[event_count].event_id = id;
+	strncpy(events[event_count].name, name, MAX_EVENT_NAME - 1);
+	event_count++;
+}
+
+char *perf_header__find_event(u64 id)
+{
+	int i;
+	for (i = 0 ; i < event_count; i++) {
+		if (events[i].event_id == id)
+			return events[i].name;
+	}
+	return NULL;
+}
+
 static const char *__perf_magic = "PERFFILE";
 
 #define PERF_MAGIC	(*(u64 *)__perf_magic)
@@ -106,6 +144,7 @@ struct perf_file_header {
 	u64				attr_size;
 	struct perf_file_section	attrs;
 	struct perf_file_section	data;
+	struct perf_file_section	event_types;
 };
 
 static void do_write(int fd, void *buf, size_t size)
@@ -154,6 +193,11 @@ void perf_header__write(struct perf_header *self, int fd)
 		do_write(fd, &f_attr, sizeof(f_attr));
 	}
 
+	self->event_offset = lseek(fd, 0, SEEK_CUR);
+	self->event_size = event_count * sizeof(struct perf_trace_event_type);
+	if (events)
+		do_write(fd, events, self->event_size);
+
 
 	self->data_offset = lseek(fd, 0, SEEK_CUR);
 
@@ -169,6 +213,10 @@ void perf_header__write(struct perf_header *self, int fd)
 			.offset = self->data_offset,
 			.size	= self->data_size,
 		},
+		.event_types = {
+			.offset = self->event_offset,
+			.size	= self->event_size,
+		},
 	};
 
 	lseek(fd, 0, SEEK_SET);
@@ -234,6 +282,17 @@ struct perf_header *perf_header__read(int fd)
 		lseek(fd, tmp, SEEK_SET);
 	}
 
+	if (f_header.event_types.size) {
+		lseek(fd, f_header.event_types.offset, SEEK_SET);
+		events = malloc(f_header.event_types.size);
+		if (!events)
+			die("nomem");
+		do_read(fd, events, f_header.event_types.size);
+		event_count =  f_header.event_types.size / sizeof(struct perf_trace_event_type);
+	}
+	self->event_offset = f_header.event_types.offset;
+	self->event_size   = f_header.event_types.size;
+
 	self->data_offset = f_header.data.offset;
 	self->data_size   = f_header.data.size;
 
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 5d0a72e..7b0e84a 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -19,6 +19,8 @@ struct perf_header {
 	s64 attr_offset;
 	u64 data_offset;
 	u64 data_size;
+	u64 event_offset;
+	u64 event_size;
 };
 
 struct perf_header *perf_header__read(int fd);
@@ -27,6 +29,10 @@ void perf_header__write(struct perf_header *self, int fd);
 void perf_header__add_attr(struct perf_header *self,
 			   struct perf_header_attr *attr);
 
+void perf_header__push_event(u64 id, const char *name);
+char *perf_header__find_event(u64 id);
+
+
 struct perf_header_attr *
 perf_header_attr__new(struct perf_counter_attr *attr);
 void perf_header_attr__add_id(struct perf_header_attr *self, u64 id);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index a587d41..89172fd 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -6,6 +6,7 @@
 #include "exec_cmd.h"
 #include "string.h"
 #include "cache.h"
+#include "header.h"
 
 int					nr_counters;
 
@@ -18,6 +19,12 @@ struct event_symbol {
 	const char	*alias;
 };
 
+enum event_result {
+	EVT_FAILED,
+	EVT_HANDLED,
+	EVT_HANDLED_ALL
+};
+
 char debugfs_path[MAXPATHLEN];
 
 #define CHW(x) .type = PERF_TYPE_HARDWARE, .config = PERF_COUNT_HW_##x
@@ -139,7 +146,7 @@ static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
 	   (strcmp(evt_dirent.d_name, "..")) &&				       \
 	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
 
-#define MAX_EVENT_LENGTH 30
+#define MAX_EVENT_LENGTH 512
 
 int valid_debugfs_mount(const char *debugfs)
 {
@@ -344,7 +351,7 @@ static int parse_aliases(const char **str, const char *names[][MAX_ALIASES], int
 	return -1;
 }
 
-static int
+static enum event_result
 parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
 {
 	const char *s = *str;
@@ -356,7 +363,7 @@ parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
 	 * then bail out:
 	 */
 	if (cache_type == -1)
-		return 0;
+		return EVT_FAILED;
 
 	while ((cache_op == -1 || cache_result == -1) && *s == '-') {
 		++s;
@@ -402,27 +409,115 @@ parse_generic_hw_event(const char **str, struct perf_counter_attr *attr)
 	attr->type = PERF_TYPE_HW_CACHE;
 
 	*str = s;
-	return 1;
+	return EVT_HANDLED;
+}
+
+static enum event_result
+parse_single_tracepoint_event(char *sys_name,
+			      const char *evt_name,
+			      unsigned int evt_length,
+			      char *flags,
+			      struct perf_counter_attr *attr,
+			      const char **strp)
+{
+	char evt_path[MAXPATHLEN];
+	char id_buf[4];
+	u64 id;
+	int fd;
+
+	if (flags) {
+		if (!strncmp(flags, "record", strlen(flags))) {
+			attr->sample_type |= PERF_SAMPLE_RAW;
+			attr->sample_type |= PERF_SAMPLE_TIME;
+			attr->sample_type |= PERF_SAMPLE_CPU;
+		}
+	}
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
+		 sys_name, evt_name);
+
+	fd = open(evt_path, O_RDONLY);
+	if (fd < 0)
+		return EVT_FAILED;
+
+	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
+		close(fd);
+		return EVT_FAILED;
+	}
+
+	close(fd);
+	id = atoll(id_buf);
+	attr->config = id;
+	attr->type = PERF_TYPE_TRACEPOINT;
+	*strp = evt_name + evt_length;
+
+	return EVT_HANDLED;
+}
+
+/* sys + ':' + event + ':' + flags*/
+#define MAX_EVOPT_LEN	(MAX_EVENT_LENGTH * 2 + 2 + 128)
+static enum event_result
+parse_subsystem_tracepoint_event(char *sys_name, char *flags)
+{
+	char evt_path[MAXPATHLEN];
+	struct dirent *evt_ent;
+	DIR *evt_dir;
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s", debugfs_path, sys_name);
+	evt_dir = opendir(evt_path);
+
+	if (!evt_dir) {
+		perror("Can't open event dir");
+		return EVT_FAILED;
+	}
+
+	while ((evt_ent = readdir(evt_dir))) {
+		char event_opt[MAX_EVOPT_LEN + 1];
+		int len;
+		unsigned int rem = MAX_EVOPT_LEN;
+
+		if (!strcmp(evt_ent->d_name, ".")
+		    || !strcmp(evt_ent->d_name, "..")
+		    || !strcmp(evt_ent->d_name, "enable")
+		    || !strcmp(evt_ent->d_name, "filter"))
+			continue;
+
+		len = snprintf(event_opt, MAX_EVOPT_LEN, "%s:%s", sys_name,
+			       evt_ent->d_name);
+		if (len < 0)
+			return EVT_FAILED;
+
+		rem -= len;
+		if (flags) {
+			if (rem < strlen(flags) + 1)
+				return EVT_FAILED;
+
+			strcat(event_opt, ":");
+			strcat(event_opt, flags);
+		}
+
+		if (parse_events(NULL, event_opt, 0))
+			return EVT_FAILED;
+	}
+
+	return EVT_HANDLED_ALL;
 }
 
-static int parse_tracepoint_event(const char **strp,
+
+static enum event_result parse_tracepoint_event(const char **strp,
 				    struct perf_counter_attr *attr)
 {
 	const char *evt_name;
 	char *flags;
 	char sys_name[MAX_EVENT_LENGTH];
-	char id_buf[4];
-	int fd;
 	unsigned int sys_length, evt_length;
-	u64 id;
-	char evt_path[MAXPATHLEN];
 
 	if (valid_debugfs_mount(debugfs_path))
 		return 0;
 
 	evt_name = strchr(*strp, ':');
 	if (!evt_name)
-		return 0;
+		return EVT_FAILED;
 
 	sys_length = evt_name - *strp;
 	if (sys_length >= MAX_EVENT_LENGTH)
@@ -434,32 +529,22 @@ static int parse_tracepoint_event(const char **strp,
 
 	flags = strchr(evt_name, ':');
 	if (flags) {
-		*flags = '\0';
+		/* split it out: */
+		evt_name = strndup(evt_name, flags - evt_name);
 		flags++;
-		if (!strncmp(flags, "record", strlen(flags)))
-			attr->sample_type |= PERF_SAMPLE_RAW;
 	}
 
 	evt_length = strlen(evt_name);
 	if (evt_length >= MAX_EVENT_LENGTH)
-		return 0;
-
-	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
-		 sys_name, evt_name);
-	fd = open(evt_path, O_RDONLY);
-	if (fd < 0)
-		return 0;
+		return EVT_FAILED;
 
-	if (read(fd, id_buf, sizeof(id_buf)) < 0) {
-		close(fd);
-		return 0;
-	}
-	close(fd);
-	id = atoll(id_buf);
-	attr->config = id;
-	attr->type = PERF_TYPE_TRACEPOINT;
-	*strp = evt_name + evt_length;
-	return 1;
+	if (!strcmp(evt_name, "*")) {
+		*strp = evt_name + evt_length;
+		return parse_subsystem_tracepoint_event(sys_name, flags);
+	} else
+		return parse_single_tracepoint_event(sys_name, evt_name,
+						     evt_length, flags,
+						     attr, strp);
 }
 
 static int check_events(const char *str, unsigned int i)
@@ -477,7 +562,7 @@ static int check_events(const char *str, unsigned int i)
 	return 0;
 }
 
-static int
+static enum event_result
 parse_symbolic_event(const char **strp, struct perf_counter_attr *attr)
 {
 	const char *str = *strp;
@@ -490,31 +575,32 @@ parse_symbolic_event(const char **strp, struct perf_counter_attr *attr)
 			attr->type = event_symbols[i].type;
 			attr->config = event_symbols[i].config;
 			*strp = str + n;
-			return 1;
+			return EVT_HANDLED;
 		}
 	}
-	return 0;
+	return EVT_FAILED;
 }
 
-static int parse_raw_event(const char **strp, struct perf_counter_attr *attr)
+static enum event_result
+parse_raw_event(const char **strp, struct perf_counter_attr *attr)
 {
 	const char *str = *strp;
 	u64 config;
 	int n;
 
 	if (*str != 'r')
-		return 0;
+		return EVT_FAILED;
 	n = hex2u64(str + 1, &config);
 	if (n > 0) {
 		*strp = str + n + 1;
 		attr->type = PERF_TYPE_RAW;
 		attr->config = config;
-		return 1;
+		return EVT_HANDLED;
 	}
-	return 0;
+	return EVT_FAILED;
 }
 
-static int
+static enum event_result
 parse_numeric_event(const char **strp, struct perf_counter_attr *attr)
 {
 	const char *str = *strp;
@@ -530,13 +616,13 @@ parse_numeric_event(const char **strp, struct perf_counter_attr *attr)
 			attr->type = type;
 			attr->config = config;
 			*strp = endp;
-			return 1;
+			return EVT_HANDLED;
 		}
 	}
-	return 0;
+	return EVT_FAILED;
 }
 
-static int
+static enum event_result
 parse_event_modifier(const char **strp, struct perf_counter_attr *attr)
 {
 	const char *str = *strp;
@@ -569,37 +655,84 @@ parse_event_modifier(const char **strp, struct perf_counter_attr *attr)
  * Each event can have multiple symbolic names.
  * Symbolic names are (almost) exactly matched.
  */
-static int parse_event_symbols(const char **str, struct perf_counter_attr *attr)
+static enum event_result
+parse_event_symbols(const char **str, struct perf_counter_attr *attr)
 {
-	if (!(parse_tracepoint_event(str, attr) ||
-	      parse_raw_event(str, attr) ||
-	      parse_numeric_event(str, attr) ||
-	      parse_symbolic_event(str, attr) ||
-	      parse_generic_hw_event(str, attr)))
-		return 0;
+	enum event_result ret;
+
+	ret = parse_tracepoint_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	ret = parse_raw_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	ret = parse_numeric_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	ret = parse_symbolic_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
 
+	ret = parse_generic_hw_event(str, attr);
+	if (ret != EVT_FAILED)
+		goto modifier;
+
+	return EVT_FAILED;
+
+modifier:
 	parse_event_modifier(str, attr);
 
-	return 1;
+	return ret;
 }
 
+static void store_event_type(const char *orgname)
+{
+	char filename[PATH_MAX], *c;
+	FILE *file;
+	int id;
+
+	sprintf(filename, "/sys/kernel/debug/tracing/events/%s/id", orgname);
+	c = strchr(filename, ':');
+	if (c)
+		*c = '/';
+
+	file = fopen(filename, "r");
+	if (!file)
+		return;
+	if (fscanf(file, "%i", &id) < 1)
+		die("cannot store event ID");
+	fclose(file);
+	perf_header__push_event(id, orgname);
+}
+
+
 int parse_events(const struct option *opt __used, const char *str, int unset __used)
 {
 	struct perf_counter_attr attr;
+	enum event_result ret;
+
+	if (strchr(str, ':'))
+		store_event_type(str);
 
 	for (;;) {
 		if (nr_counters == MAX_COUNTERS)
 			return -1;
 
 		memset(&attr, 0, sizeof(attr));
-		if (!parse_event_symbols(&str, &attr))
+		ret = parse_event_symbols(&str, &attr);
+		if (ret == EVT_FAILED)
 			return -1;
 
 		if (!(*str == 0 || *str == ',' || isspace(*str)))
 			return -1;
 
-		attrs[nr_counters] = attr;
-		nr_counters++;
+		if (ret != EVT_HANDLED_ALL) {
+			attrs[nr_counters] = attr;
+			nr_counters++;
+		}
 
 		if (*str == 0)
 			break;
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index 8aa3464..2ee248f 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -104,6 +104,8 @@ struct option {
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), .argh = "time", .help = (h), .callback = parse_opt_approxidate_cb }
 #define OPT_CALLBACK(s, l, v, a, h, f) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f) }
+#define OPT_CALLBACK_NOOPT(s, l, v, a, h, f) \
+	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .flags = PARSE_OPT_NOARG }
 #define OPT_CALLBACK_DEFAULT(s, l, v, a, h, f, d) \
 	{ .type = OPTION_CALLBACK, .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h), .callback = (f), .defval = (intptr_t)d, .flags = PARSE_OPT_LASTARG_DEFAULT }
 
diff --git a/tools/perf/util/svghelper.c b/tools/perf/util/svghelper.c
new file mode 100644
index 0000000..b0fcecd
--- /dev/null
+++ b/tools/perf/util/svghelper.c
@@ -0,0 +1,384 @@
+/*
+ * svghelper.c - helper functions for outputting svg
+ *
+ * (C) Copyright 2009 Intel Corporation
+ *
+ * Authors:
+ *     Arjan van de Ven <arjan@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+
+#include "svghelper.h"
+
+static u64 first_time, last_time;
+static u64 turbo_frequency, max_freq;
+
+
+#define SLOT_MULT 30.0
+#define SLOT_HEIGHT 25.0
+#define WIDTH 1000.0
+
+#define MIN_TEXT_SIZE 0.001
+
+static u64 total_height;
+static FILE *svgfile;
+
+static double cpu2slot(int cpu)
+{
+	return 2 * cpu + 1;
+}
+
+static double cpu2y(int cpu)
+{
+	return cpu2slot(cpu) * SLOT_MULT;
+}
+
+static double time2pixels(u64 time)
+{
+	double X;
+
+	X = WIDTH * (time - first_time) / (last_time - first_time);
+	return X;
+}
+
+void open_svg(const char *filename, int cpus, int rows)
+{
+
+	svgfile = fopen(filename, "w");
+	if (!svgfile) {
+		fprintf(stderr, "Cannot open %s for output\n", filename);
+		return;
+	}
+	total_height = (1 + rows + cpu2slot(cpus)) * SLOT_MULT;
+	fprintf(svgfile, "<?xml version=\"1.0\" standalone=\"no\"?> \n");
+	fprintf(svgfile, "<svg width=\"%4.1f\" height=\"%llu\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n", WIDTH, total_height);
+
+	fprintf(svgfile, "<defs>\n  <style type=\"text/css\">\n    <![CDATA[\n");
+
+	fprintf(svgfile, "      rect          { stroke-width: 1; }\n");
+	fprintf(svgfile, "      rect.process  { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:1;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.process2 { fill:rgb(180,180,180); fill-opacity:0.9; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.sample   { fill:rgb(  0,  0,255); fill-opacity:0.8; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.blocked  { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.waiting  { fill:rgb(255,255,  0); fill-opacity:0.3; stroke-width:0;   stroke:rgb(  0,  0,  0); } \n");
+	fprintf(svgfile, "      rect.cpu      { fill:rgb(192,192,192); fill-opacity:0.2; stroke-width:0.5; stroke:rgb(128,128,128); } \n");
+	fprintf(svgfile, "      rect.pstate   { fill:rgb(128,128,128); fill-opacity:0.8; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c1       { fill:rgb(255,214,214); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c2       { fill:rgb(255,172,172); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c3       { fill:rgb(255,130,130); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c4       { fill:rgb(255, 88, 88); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c5       { fill:rgb(255, 44, 44); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      rect.c6       { fill:rgb(255,  0,  0); fill-opacity:0.5; stroke-width:0; } \n");
+	fprintf(svgfile, "      line.pstate   { stroke:rgb(255,255,  0); stroke-opacity:0.8; stroke-width:2; } \n");
+
+	fprintf(svgfile, "    ]]>\n   </style>\n</defs>\n");
+}
+
+void svg_box(int Yslot, u64 start, u64 end, const char *type)
+{
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT, type);
+}
+
+void svg_sample(int Yslot, int cpu, u64 start, u64 end, const char *type)
+{
+	double text_size;
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+		time2pixels(start), time2pixels(end)-time2pixels(start), Yslot * SLOT_MULT, SLOT_HEIGHT, type);
+
+	text_size = (time2pixels(end)-time2pixels(start));
+	if (cpu > 9)
+		text_size = text_size/2;
+	if (text_size > 1.25)
+		text_size = 1.25;
+	if (text_size > MIN_TEXT_SIZE)
+		fprintf(svgfile, "<text transform=\"translate(%1.8f,%1.8f)\" font-size=\"%1.6fpt\">%i</text>\n",
+			time2pixels(start), Yslot *  SLOT_MULT + SLOT_HEIGHT - 1, text_size,  cpu + 1);
+
+}
+
+static char *cpu_model(void)
+{
+	static char cpu_m[255];
+	char buf[256];
+	FILE *file;
+
+	cpu_m[0] = 0;
+	/* CPU type */
+	file = fopen("/proc/cpuinfo", "r");
+	if (file) {
+		while (fgets(buf, 255, file)) {
+			if (strstr(buf, "model name")) {
+				strncpy(cpu_m, &buf[13], 255);
+				break;
+			}
+		}
+		fclose(file);
+	}
+	return cpu_m;
+}
+
+void svg_cpu_box(int cpu, u64 __max_freq, u64 __turbo_freq)
+{
+	char cpu_string[80];
+	if (!svgfile)
+		return;
+
+	max_freq = __max_freq;
+	turbo_frequency = __turbo_freq;
+
+	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"cpu\"/>\n",
+		time2pixels(first_time),
+		time2pixels(last_time)-time2pixels(first_time),
+		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
+
+	sprintf(cpu_string, "CPU %i", (int)cpu+1);
+	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\">%s</text>\n",
+		10+time2pixels(first_time), cpu2y(cpu) + SLOT_HEIGHT/2, cpu_string);
+
+	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\" font-size=\"1.25pt\">%s</text>\n",
+		10+time2pixels(first_time), cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - 4, cpu_model());
+}
+
+void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name)
+{
+	double width;
+
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<rect x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\" class=\"%s\"/>\n",
+		time2pixels(start), time2pixels(end)-time2pixels(start), cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT, type);
+	width = time2pixels(end)-time2pixels(start);
+	if (width > 6)
+		width = 6;
+
+	if (width > MIN_TEXT_SIZE)
+		fprintf(svgfile, "<text  transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"%3.4fpt\">%s</text>\n",
+			time2pixels(start), cpu2y(cpu), width, name);
+}
+
+void svg_cstate(int cpu, u64 start, u64 end, int type)
+{
+	double width;
+	char style[128];
+
+	if (!svgfile)
+		return;
+
+
+	if (type > 6)
+		type = 6;
+	sprintf(style, "c%i", type);
+
+	fprintf(svgfile, "<rect class=\"%s\" x=\"%4.8f\" width=\"%4.8f\" y=\"%4.1f\" height=\"%4.1f\"/>\n",
+		style,
+		time2pixels(start), time2pixels(end)-time2pixels(start),
+		cpu2y(cpu), SLOT_MULT+SLOT_HEIGHT);
+
+	width = time2pixels(end)-time2pixels(start);
+	if (width > 6)
+		width = 6;
+
+	if (width > MIN_TEXT_SIZE)
+		fprintf(svgfile, "<text  transform=\"translate(%4.8f,%4.8f) rotate(90)\" font-size=\"%3.4fpt\">C%i</text>\n",
+			time2pixels(start), cpu2y(cpu), width, type);
+}
+
+static char *HzToHuman(unsigned long hz)
+{
+	static char buffer[1024];
+	unsigned long long Hz;
+
+	memset(buffer, 0, 1024);
+
+	Hz = hz;
+
+	/* default: just put the Number in */
+	sprintf(buffer, "%9lli", Hz);
+
+	if (Hz > 1000)
+		sprintf(buffer, " %6lli Mhz", (Hz+500)/1000);
+
+	if (Hz > 1500000)
+		sprintf(buffer, " %6.2f Ghz", (Hz+5000.0)/1000000);
+
+	if (Hz == turbo_frequency)
+		sprintf(buffer, "Turbo");
+
+	return buffer;
+}
+
+void svg_pstate(int cpu, u64 start, u64 end, u64 freq)
+{
+	double height = 0;
+
+	if (!svgfile)
+		return;
+
+	if (max_freq)
+		height = freq * 1.0 / max_freq * (SLOT_HEIGHT + SLOT_MULT);
+	height = 1 + cpu2y(cpu) + SLOT_MULT + SLOT_HEIGHT - height;
+	fprintf(svgfile, "<line x1=\"%4.8f\" x2=\"%4.8f\" y1=\"%4.1f\" y2=\"%4.1f\" class=\"pstate\"/>\n",
+		time2pixels(start), time2pixels(end), height, height);
+	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\" font-size=\"0.25pt\">%s</text>\n",
+		time2pixels(start), height+0.9, HzToHuman(freq));
+
+}
+
+
+void svg_partial_wakeline(u64 start, int row1, int row2)
+{
+	double height;
+
+	if (!svgfile)
+		return;
+
+
+	if (row1 < row2) {
+		if (row1)
+			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+				time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
+
+		if (row2)
+			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+				time2pixels(start), row2 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row2 * SLOT_MULT);
+	} else {
+		if (row2)
+			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+				time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT + SLOT_MULT/32);
+
+		if (row1)
+			fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+				time2pixels(start), row1 * SLOT_MULT - SLOT_MULT/32,  time2pixels(start), row1 * SLOT_MULT);
+	}
+	height = row1 * SLOT_MULT;
+	if (row2 > row1)
+		height += SLOT_HEIGHT;
+	if (row1)
+		fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
+			time2pixels(start), height);
+}
+
+void svg_wakeline(u64 start, int row1, int row2)
+{
+	double height;
+
+	if (!svgfile)
+		return;
+
+
+	if (row1 < row2)
+		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			time2pixels(start), row1 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row2 * SLOT_MULT);
+	else
+		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%4.2f\" style=\"stroke:rgb(32,255,32);stroke-width:0.009\"/>\n",
+			time2pixels(start), row2 * SLOT_MULT + SLOT_HEIGHT,  time2pixels(start), row1 * SLOT_MULT);
+
+	height = row1 * SLOT_MULT;
+	if (row2 > row1)
+		height += SLOT_HEIGHT;
+	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(32,255,32)\"/>\n",
+			time2pixels(start), height);
+}
+
+void svg_interrupt(u64 start, int row)
+{
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
+			time2pixels(start), row * SLOT_MULT);
+	fprintf(svgfile, "<circle  cx=\"%4.8f\" cy=\"%4.2f\" r = \"0.01\"  style=\"fill:rgb(255,128,128)\"/>\n",
+			time2pixels(start), row * SLOT_MULT + SLOT_HEIGHT);
+}
+
+void svg_text(int Yslot, u64 start, const char *text)
+{
+	if (!svgfile)
+		return;
+
+	fprintf(svgfile, "<text transform=\"translate(%4.8f,%4.8f)\">%s</text>\n",
+		time2pixels(start), Yslot * SLOT_MULT+SLOT_HEIGHT/2, text);
+}
+
+static void svg_legenda_box(int X, const char *text, const char *style)
+{
+	double boxsize;
+	boxsize = SLOT_HEIGHT / 2;
+
+	fprintf(svgfile, "<rect x=\"%i\" width=\"%4.8f\" y=\"0\" height=\"%4.1f\" class=\"%s\"/>\n",
+		X, boxsize, boxsize, style);
+	fprintf(svgfile, "<text transform=\"translate(%4.8f, %4.8f)\" font-size=\"%4.4fpt\">%s</text>\n",
+		X + boxsize + 5, boxsize, 0.8 * boxsize, text);
+}
+
+void svg_legenda(void)
+{
+	if (!svgfile)
+		return;
+
+	svg_legenda_box(0,	"Running", "sample");
+	svg_legenda_box(100,	"Idle","rect.c1");
+	svg_legenda_box(200,	"Deeper Idle", "rect.c3");
+	svg_legenda_box(350,	"Deepest Idle", "rect.c6");
+	svg_legenda_box(550,	"Sleeping", "process2");
+	svg_legenda_box(650,	"Waiting for cpu", "waiting");
+	svg_legenda_box(800,	"Blocked on IO", "blocked");
+}
+
+void svg_time_grid(u64 start, u64 end)
+{
+	u64 i;
+
+	first_time = start;
+	last_time = end;
+
+	first_time = first_time / 100000000 * 100000000;
+
+	if (!svgfile)
+		return;
+
+	i = first_time;
+	while (i < last_time) {
+		int color = 220;
+		double thickness = 0.075;
+		if ((i % 100000000) == 0) {
+			thickness = 0.5;
+			color = 192;
+		}
+		if ((i % 1000000000) == 0) {
+			thickness = 2.0;
+			color = 128;
+		}
+
+		fprintf(svgfile, "<line x1=\"%4.8f\" y1=\"%4.2f\" x2=\"%4.8f\" y2=\"%llu\" style=\"stroke:rgb(%i,%i,%i);stroke-width:%1.3f\"/>\n",
+			time2pixels(i), SLOT_MULT/2, time2pixels(i), total_height, color, color, color, thickness);
+
+		i += 10000000;
+	}
+}
+
+void svg_close(void)
+{
+	if (svgfile) {
+		fprintf(svgfile, "</svg>\n");
+		fclose(svgfile);
+		svgfile = NULL;
+	}
+}
diff --git a/tools/perf/util/svghelper.h b/tools/perf/util/svghelper.h
new file mode 100644
index 0000000..ad79b5d
--- /dev/null
+++ b/tools/perf/util/svghelper.h
@@ -0,0 +1,25 @@
+#ifndef _INCLUDE_GUARD_SVG_HELPER_
+#define _INCLUDE_GUARD_SVG_HELPER_
+
+#include "types.h"
+
+extern void open_svg(const char *filename, int cpus, int rows);
+extern void svg_box(int Yslot, u64 start, u64 end, const char *type);
+extern void svg_sample(int Yslot, int cpu, u64 start, u64 end, const char *type);
+extern void svg_cpu_box(int cpu, u64 max_frequency, u64 turbo_frequency);
+
+
+extern void svg_process(int cpu, u64 start, u64 end, const char *type, const char *name);
+extern void svg_cstate(int cpu, u64 start, u64 end, int type);
+extern void svg_pstate(int cpu, u64 start, u64 end, u64 freq);
+
+
+extern void svg_time_grid(u64 start, u64 end);
+extern void svg_legenda(void);
+extern void svg_wakeline(u64 start, int row1, int row2);
+extern void svg_partial_wakeline(u64 start, int row1, int row2);
+extern void svg_interrupt(u64 start, int row);
+extern void svg_text(int Yslot, u64 start, const char *text);
+extern void svg_close(void);
+
+#endif
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 7635928..45efb5d 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -8,7 +8,7 @@
 
 static struct thread *thread__new(pid_t pid)
 {
-	struct thread *self = malloc(sizeof(*self));
+	struct thread *self = calloc(1, sizeof(*self));
 
 	if (self != NULL) {
 		self->pid = pid;
@@ -85,7 +85,7 @@ register_idle_thread(struct rb_root *threads, struct thread **last_match)
 {
 	struct thread *thread = threads__findnew(0, threads, last_match);
 
-	if (!thread || thread__set_comm(thread, "[init]")) {
+	if (!thread || thread__set_comm(thread, "swapper")) {
 		fprintf(stderr, "problem inserting idle task.\n");
 		exit(-1);
 	}
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 634f280..32aea3c 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -4,10 +4,11 @@
 #include "symbol.h"
 
 struct thread {
-	struct rb_node	 rb_node;
-	struct list_head maps;
-	pid_t		 pid;
-	char		 *comm;
+	struct rb_node		rb_node;
+	struct list_head	maps;
+	pid_t			pid;
+	char			shortname[3];
+	char			*comm;
 };
 
 int thread__set_comm(struct thread *self, const char *comm);
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 6c9302a..1fd824c 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -458,7 +458,7 @@ static void read_proc_kallsyms(void)
 static void read_ftrace_printk(void)
 {
 	unsigned int size, check_size;
-	const char *path;
+	char *path;
 	struct stat st;
 	int ret;
 
@@ -468,14 +468,15 @@ static void read_ftrace_printk(void)
 		/* not found */
 		size = 0;
 		write_or_die(&size, 4);
-		return;
+		goto out;
 	}
 	size = get_size(path);
 	write_or_die(&size, 4);
 	check_size = copy_file(path);
 	if (size != check_size)
 		die("error in size of file '%s'", path);
-
+out:
+	put_tracing_file(path);
 }
 
 static struct tracepoint_path *
diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 629e602..f6a8437 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -1776,6 +1776,29 @@ static unsigned long long read_size(void *ptr, int size)
 	}
 }
 
+unsigned long long
+raw_field_value(struct event *event, const char *name, void *data)
+{
+	struct format_field *field;
+
+	field = find_any_field(event, name);
+	if (!field)
+		return 0ULL;
+
+	return read_size(data + field->offset, field->size);
+}
+
+void *raw_field_ptr(struct event *event, const char *name, void *data)
+{
+	struct format_field *field;
+
+	field = find_any_field(event, name);
+	if (!field)
+		return NULL;
+
+	return data + field->offset;
+}
+
 static int get_common_info(const char *type, int *offset, int *size)
 {
 	struct event *event;
@@ -1799,7 +1822,7 @@ static int get_common_info(const char *type, int *offset, int *size)
 	return 0;
 }
 
-static int parse_common_type(void *data)
+int trace_parse_common_type(void *data)
 {
 	static int type_offset;
 	static int type_size;
@@ -1832,7 +1855,7 @@ static int parse_common_pid(void *data)
 	return read_size(data + pid_offset, pid_size);
 }
 
-static struct event *find_event(int id)
+struct event *trace_find_event(int id)
 {
 	struct event *event;
 
@@ -2420,8 +2443,8 @@ get_return_for_leaf(int cpu, int cur_pid, unsigned long long cur_func,
 	int type;
 	int pid;
 
-	type = parse_common_type(next->data);
-	event = find_event(type);
+	type = trace_parse_common_type(next->data);
+	event = trace_find_event(type);
 	if (!event)
 		return NULL;
 
@@ -2502,8 +2525,8 @@ print_graph_entry_leaf(struct event *event, void *data, struct record *ret_rec)
 	int type;
 	int i;
 
-	type = parse_common_type(ret_rec->data);
-	ret_event = find_event(type);
+	type = trace_parse_common_type(ret_rec->data);
+	ret_event = trace_find_event(type);
 
 	field = find_field(ret_event, "rettime");
 	if (!field)
@@ -2696,11 +2719,13 @@ void print_event(int cpu, void *data, int size, unsigned long long nsecs,
 	nsecs -= secs * NSECS_PER_SEC;
 	usecs = nsecs / NSECS_PER_USEC;
 
-	type = parse_common_type(data);
+	type = trace_parse_common_type(data);
 
-	event = find_event(type);
-	if (!event)
-		die("ug! no event found for type %d", type);
+	event = trace_find_event(type);
+	if (!event) {
+		printf("ug! no event found for type %d\n", type);
+		return;
+	}
 
 	pid = parse_common_pid(data);
 
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index a1217a1..1b5c847 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -458,12 +458,13 @@ struct record *trace_read_data(int cpu)
 	return data;
 }
 
-void trace_report (void)
+void trace_report(void)
 {
 	const char *input_file = "trace.info";
 	char buf[BUFSIZ];
 	char test[] = { 23, 8, 68 };
 	char *version;
+	int show_version = 0;
 	int show_funcs = 0;
 	int show_printk = 0;
 
@@ -480,7 +481,8 @@ void trace_report (void)
 		die("not a trace file (missing tracing)");
 
 	version = read_string();
-	printf("version = %s\n", version);
+	if (show_version)
+		printf("version = %s\n", version);
 	free(version);
 
 	read_or_die(buf, 1);
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 420294a..d35ebf1 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -234,6 +234,11 @@ extern int header_page_data_offset;
 extern int header_page_data_size;
 
 int parse_header_page(char *buf, unsigned long size);
+int trace_parse_common_type(void *data);
+struct event *trace_find_event(int id);
+unsigned long long
+raw_field_value(struct event *event, const char *name, void *data);
+void *raw_field_ptr(struct event *event, const char *name, void *data);
 
 void read_tracing_data(struct perf_counter_attr *pattrs, int nb_counters);
 
