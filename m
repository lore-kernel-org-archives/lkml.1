Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZHJSft@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZHJSft (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 14:35:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZHJSft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 14:35:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51347 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbZHJSfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 14:35:45 -0400
Date: Mon, 10 Aug 2009 20:35:18 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: [GIT PULL] perfcounters fixes/updates
Message-ID: <20090810183518.GA14399@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 2.3
X-ELTE-SpamLevel: ss
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=2.3 required=5.9 tests=BAYES_00,TVD_STOCK1 autolearn=no SpamAssassin version=3.2.5
	3.8 TVD_STOCK1             BODY: TVD_STOCK1
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perfcounters-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perfcounters-fixes-for-linus

I hope this is still fine ... most of the changes are fixes (and 
only affect perfcounters) and most of the diffstat is for the 
tooling side, but if it's too much we could trim it a bit and leave 
out some of the bits that are not strictly fixes:

  perf_counter tools: Fix/resurrect perf top annotation in a simple interactive form
  perf_counter tools: Allow perf top top users to switch between weighted and individual counter display
  perf top: Improve interactive key handling

OTOH it's all for new-in-.31 code so it felt better to have it in.

( This isnt even all the stuff - we do have a fair amount of stuff
  put aside for .32 already - but the fixes/tweaks stream is still 
  coming in strong. I guess it's partly due to much bigger uptick in 
  initial use and interest in perfcounters than i'd have anticipated 
  for an August. People are supposed to be away on vacation or what. )

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf report: Add debug help for the finding of symbol bugs - show the symtab origin (DSO, build-id, kernel, etc)

Brice Goglin (1):
      perf stat: Fix tool option consistency: rename -S/--scale to -c/--scale

Carlos R. Mafra (1):
      perf: "Longum est iter per praecepta, breve et efficax per exempla"

Frederic Weisbecker (9):
      perf tools: Fix call-chain cumul hit based sub-total (fractal mode)
      perf tools: callchain: Fix spurious 'perf report' warnings: ignore empty callchains
      perf tools: callchain: Fix 'perf report' display to be callchain by default
      perf tools: callchain: Fix sum of percentages to be 100% by displaying amount of ignored chains in fractal mode
      perf_counter: Work around gcc warning by initializing tracepoint record unconditionally
      perf_counter: Fix tracepoint sampling to be part of generic sampling
      perf tools: callchain: Fix bad rounding of minimum rate
      perf_counter: Subtract the buffer size field from the event record size
      perf_counter: Zero dead bytes from ftrace raw samples size alignment

Mike Galbraith (5):
      perf_counter tools: Fix/resurrect perf top annotation in a simple interactive form
      perf_counter tools: Allow perf top top users to switch between weighted and individual counter display
      perf top: Improve interactive key handling
      perf top: Update man page
      perf_counter tools: Fix libbfd detection for systems with libz dependency

Paul Mackerras (1):
      perf_counter/powerpc: Fix oops on cpus without perf_counter hardware support

Peter Zijlstra (7):
      perf_counter: Fix software counters for fast moving event sources
      perf tools: Fix multi-counter stat bug caused by incorrect reading of perf.data file header
      perf report: Fix per task mult-counter stat reporting
      perf list: Fix the output to not include tracepoints without an id
      perf_counter: Fix a race on perf_counter_ctx
      perf_counter: Correct PERF_SAMPLE_RAW output
      perf_counter: Require CAP_SYS_ADMIN for raw tracepoint data

Pierre Habouzit (2):
      perf util: Fix do_read() to fail on EOF instead of busy-looping
      perf record: Fix the -A UI for empty or non-existent perf.data


 arch/powerpc/kernel/perf_counter.c         |    8 +
 include/linux/perf_counter.h               |   12 +-
 include/trace/ftrace.h                     |   15 +-
 kernel/perf_counter.c                      |  239 ++++++++-----
 tools/perf/Documentation/perf-examples.txt |  225 +++++++++++
 tools/perf/Documentation/perf-stat.txt     |    2 +-
 tools/perf/Documentation/perf-top.txt      |  112 +++++-
 tools/perf/Makefile                        |    4 +
 tools/perf/builtin-record.c                |   12 +-
 tools/perf/builtin-report.c                |   99 +++++-
 tools/perf/builtin-stat.c                  |    2 +-
 tools/perf/builtin-top.c                   |  552 +++++++++++++++++++++++++---
 tools/perf/util/callchain.c                |   32 +-
 tools/perf/util/callchain.h                |    8 +-
 tools/perf/util/header.c                   |    5 +-
 tools/perf/util/parse-events.c             |   26 ++-
 tools/perf/util/parse-events.h             |    1 +
 tools/perf/util/symbol.c                   |   57 +++-
 tools/perf/util/symbol.h                   |    2 +
 19 files changed, 1212 insertions(+), 201 deletions(-)
 create mode 100644 tools/perf/Documentation/perf-examples.txt

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index 809fdf9..70e1f57 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -518,6 +518,8 @@ void hw_perf_disable(void)
 	struct cpu_hw_counters *cpuhw;
 	unsigned long flags;
 
+	if (!ppmu)
+		return;
 	local_irq_save(flags);
 	cpuhw = &__get_cpu_var(cpu_hw_counters);
 
@@ -572,6 +574,8 @@ void hw_perf_enable(void)
 	int n_lim;
 	int idx;
 
+	if (!ppmu)
+		return;
 	local_irq_save(flags);
 	cpuhw = &__get_cpu_var(cpu_hw_counters);
 	if (!cpuhw->disabled) {
@@ -737,6 +741,8 @@ int hw_perf_group_sched_in(struct perf_counter *group_leader,
 	long i, n, n0;
 	struct perf_counter *sub;
 
+	if (!ppmu)
+		return 0;
 	cpuhw = &__get_cpu_var(cpu_hw_counters);
 	n0 = cpuhw->n_counters;
 	n = collect_events(group_leader, ppmu->n_counter - n0,
@@ -1281,6 +1287,8 @@ void hw_perf_counter_setup(int cpu)
 {
 	struct cpu_hw_counters *cpuhw = &per_cpu(cpu_hw_counters, cpu);
 
+	if (!ppmu)
+		return;
 	memset(cpuhw, 0, sizeof(*cpuhw));
 	cpuhw->mmcr[0] = MMCR0_FC;
 }
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index a67dd5c..a9d823a 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -121,7 +121,7 @@ enum perf_counter_sample_format {
 	PERF_SAMPLE_CPU				= 1U << 7,
 	PERF_SAMPLE_PERIOD			= 1U << 8,
 	PERF_SAMPLE_STREAM_ID			= 1U << 9,
-	PERF_SAMPLE_TP_RECORD			= 1U << 10,
+	PERF_SAMPLE_RAW				= 1U << 10,
 
 	PERF_SAMPLE_MAX = 1U << 11,		/* non-ABI */
 };
@@ -369,6 +369,8 @@ enum perf_event_type {
 	 *
 	 *	{ u64			nr,
 	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
+	 *	{ u32			size;
+	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
 	 * };
 	 */
 	PERF_EVENT_SAMPLE		= 9,
@@ -414,9 +416,9 @@ struct perf_callchain_entry {
 	__u64				ip[PERF_MAX_STACK_DEPTH];
 };
 
-struct perf_tracepoint_record {
-	int				size;
-	char				*record;
+struct perf_raw_record {
+	u32				size;
+	void				*data;
 };
 
 struct task_struct;
@@ -687,7 +689,7 @@ struct perf_sample_data {
 	struct pt_regs			*regs;
 	u64				addr;
 	u64				period;
-	void				*private;
+	struct perf_raw_record		*raw;
 };
 
 extern int perf_counter_overflow(struct perf_counter *counter, int nmi,
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 7fb16d9..f64fbaa 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -637,12 +637,20 @@ __attribute__((section("_ftrace_events"))) event_##call = {		\
  *	pc = preempt_count();
  *
  *	__data_size = ftrace_get_offsets_<call>(&__data_offsets, args);
- *	__entry_size = __data_size + sizeof(*entry);
+ *
+ *	// Below we want to get the aligned size by taking into account
+ *	// the u32 field that will later store the buffer size
+ *	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),
+ *			     sizeof(u64));
+ *	__entry_size -= sizeof(u32);
  *
  *	do {
  *		char raw_data[__entry_size]; <- allocate our sample in the stack
  *		struct trace_entry *ent;
  *
+ *		zero dead bytes from alignment to avoid stack leak to userspace:
+ *
+ *		*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;
  *		entry = (struct ftrace_raw_<call> *)raw_data;
  *		ent = &entry->ent;
  *		tracing_generic_entry_update(ent, irq_flags, pc);
@@ -685,12 +693,15 @@ static void ftrace_profile_##call(proto)				\
 	pc = preempt_count();						\
 									\
 	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
-	__entry_size = ALIGN(__data_size + sizeof(*entry), sizeof(u64));\
+	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
+			     sizeof(u64));				\
+	__entry_size -= sizeof(u32);					\
 									\
 	do {								\
 		char raw_data[__entry_size];				\
 		struct trace_entry *ent;				\
 									\
+		*(u64 *)(&raw_data[__entry_size - sizeof(u64)]) = 0ULL;	\
 		entry = (struct ftrace_raw_##call *)raw_data;		\
 		ent = &entry->ent;					\
 		tracing_generic_entry_update(ent, irq_flags, pc);	\
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 8681021..b0b20a0 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -2646,7 +2646,6 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		u64 counter;
 	} group_entry;
 	struct perf_callchain_entry *callchain = NULL;
-	struct perf_tracepoint_record *tp;
 	int callchain_size = 0;
 	u64 time;
 	struct {
@@ -2715,9 +2714,16 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 			header.size += sizeof(u64);
 	}
 
-	if (sample_type & PERF_SAMPLE_TP_RECORD) {
-		tp = data->private;
-		header.size += tp->size;
+	if (sample_type & PERF_SAMPLE_RAW) {
+		int size = sizeof(u32);
+
+		if (data->raw)
+			size += data->raw->size;
+		else
+			size += sizeof(u32);
+
+		WARN_ON_ONCE(size & (sizeof(u64)-1));
+		header.size += size;
 	}
 
 	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
@@ -2783,8 +2789,21 @@ static void perf_counter_output(struct perf_counter *counter, int nmi,
 		}
 	}
 
-	if (sample_type & PERF_SAMPLE_TP_RECORD)
-		perf_output_copy(&handle, tp->record, tp->size);
+	if (sample_type & PERF_SAMPLE_RAW) {
+		if (data->raw) {
+			perf_output_put(&handle, data->raw->size);
+			perf_output_copy(&handle, data->raw->data, data->raw->size);
+		} else {
+			struct {
+				u32	size;
+				u32	data;
+			} raw = {
+				.size = sizeof(u32),
+				.data = 0,
+			};
+			perf_output_put(&handle, raw);
+		}
+	}
 
 	perf_output_end(&handle);
 }
@@ -2849,7 +2868,8 @@ perf_counter_read_event(struct perf_counter *counter,
  */
 
 struct perf_task_event {
-	struct task_struct	*task;
+	struct task_struct		*task;
+	struct perf_counter_context	*task_ctx;
 
 	struct {
 		struct perf_event_header	header;
@@ -2909,24 +2929,23 @@ static void perf_counter_task_ctx(struct perf_counter_context *ctx,
 static void perf_counter_task_event(struct perf_task_event *task_event)
 {
 	struct perf_cpu_context *cpuctx;
-	struct perf_counter_context *ctx;
+	struct perf_counter_context *ctx = task_event->task_ctx;
 
 	cpuctx = &get_cpu_var(perf_cpu_context);
 	perf_counter_task_ctx(&cpuctx->ctx, task_event);
 	put_cpu_var(perf_cpu_context);
 
 	rcu_read_lock();
-	/*
-	 * doesn't really matter which of the child contexts the
-	 * events ends up in.
-	 */
-	ctx = rcu_dereference(current->perf_counter_ctxp);
+	if (!ctx)
+		ctx = rcu_dereference(task_event->task->perf_counter_ctxp);
 	if (ctx)
 		perf_counter_task_ctx(ctx, task_event);
 	rcu_read_unlock();
 }
 
-static void perf_counter_task(struct task_struct *task, int new)
+static void perf_counter_task(struct task_struct *task,
+			      struct perf_counter_context *task_ctx,
+			      int new)
 {
 	struct perf_task_event task_event;
 
@@ -2936,8 +2955,9 @@ static void perf_counter_task(struct task_struct *task, int new)
 		return;
 
 	task_event = (struct perf_task_event){
-		.task	= task,
-		.event  = {
+		.task	  = task,
+		.task_ctx = task_ctx,
+		.event    = {
 			.header = {
 				.type = new ? PERF_EVENT_FORK : PERF_EVENT_EXIT,
 				.misc = 0,
@@ -2955,7 +2975,7 @@ static void perf_counter_task(struct task_struct *task, int new)
 
 void perf_counter_fork(struct task_struct *task)
 {
-	perf_counter_task(task, 1);
+	perf_counter_task(task, NULL, 1);
 }
 
 /*
@@ -3344,87 +3364,81 @@ int perf_counter_overflow(struct perf_counter *counter, int nmi,
  * Generic software counter infrastructure
  */
 
-static void perf_swcounter_update(struct perf_counter *counter)
+/*
+ * We directly increment counter->count and keep a second value in
+ * counter->hw.period_left to count intervals. This period counter
+ * is kept in the range [-sample_period, 0] so that we can use the
+ * sign as trigger.
+ */
+
+static u64 perf_swcounter_set_period(struct perf_counter *counter)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
-	u64 prev, now;
-	s64 delta;
+	u64 period = hwc->last_period;
+	u64 nr, offset;
+	s64 old, val;
+
+	hwc->last_period = hwc->sample_period;
 
 again:
-	prev = atomic64_read(&hwc->prev_count);
-	now = atomic64_read(&hwc->count);
-	if (atomic64_cmpxchg(&hwc->prev_count, prev, now) != prev)
-		goto again;
+	old = val = atomic64_read(&hwc->period_left);
+	if (val < 0)
+		return 0;
 
-	delta = now - prev;
+	nr = div64_u64(period + val, period);
+	offset = nr * period;
+	val -= offset;
+	if (atomic64_cmpxchg(&hwc->period_left, old, val) != old)
+		goto again;
 
-	atomic64_add(delta, &counter->count);
-	atomic64_sub(delta, &hwc->period_left);
+	return nr;
 }
 
-static void perf_swcounter_set_period(struct perf_counter *counter)
+static void perf_swcounter_overflow(struct perf_counter *counter,
+				    int nmi, struct perf_sample_data *data)
 {
 	struct hw_perf_counter *hwc = &counter->hw;
-	s64 left = atomic64_read(&hwc->period_left);
-	s64 period = hwc->sample_period;
+	u64 overflow;
 
-	if (unlikely(left <= -period)) {
-		left = period;
-		atomic64_set(&hwc->period_left, left);
-		hwc->last_period = period;
-	}
+	data->period = counter->hw.last_period;
+	overflow = perf_swcounter_set_period(counter);
 
-	if (unlikely(left <= 0)) {
-		left += period;
-		atomic64_add(period, &hwc->period_left);
-		hwc->last_period = period;
-	}
+	if (hwc->interrupts == MAX_INTERRUPTS)
+		return;
 
-	atomic64_set(&hwc->prev_count, -left);
-	atomic64_set(&hwc->count, -left);
+	for (; overflow; overflow--) {
+		if (perf_counter_overflow(counter, nmi, data)) {
+			/*
+			 * We inhibit the overflow from happening when
+			 * hwc->interrupts == MAX_INTERRUPTS.
+			 */
+			break;
+		}
+	}
 }
 
-static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
+static void perf_swcounter_unthrottle(struct perf_counter *counter)
 {
-	enum hrtimer_restart ret = HRTIMER_RESTART;
-	struct perf_sample_data data;
-	struct perf_counter *counter;
-	u64 period;
-
-	counter	= container_of(hrtimer, struct perf_counter, hw.hrtimer);
-	counter->pmu->read(counter);
-
-	data.addr = 0;
-	data.regs = get_irq_regs();
 	/*
-	 * In case we exclude kernel IPs or are somehow not in interrupt
-	 * context, provide the next best thing, the user IP.
+	 * Nothing to do, we already reset hwc->interrupts.
 	 */
-	if ((counter->attr.exclude_kernel || !data.regs) &&
-			!counter->attr.exclude_user)
-		data.regs = task_pt_regs(current);
+}
 
-	if (data.regs) {
-		if (perf_counter_overflow(counter, 0, &data))
-			ret = HRTIMER_NORESTART;
-	}
+static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
+			       int nmi, struct perf_sample_data *data)
+{
+	struct hw_perf_counter *hwc = &counter->hw;
 
-	period = max_t(u64, 10000, counter->hw.sample_period);
-	hrtimer_forward_now(hrtimer, ns_to_ktime(period));
+	atomic64_add(nr, &counter->count);
 
-	return ret;
-}
+	if (!hwc->sample_period)
+		return;
 
-static void perf_swcounter_overflow(struct perf_counter *counter,
-				    int nmi, struct perf_sample_data *data)
-{
-	data->period = counter->hw.last_period;
+	if (!data->regs)
+		return;
 
-	perf_swcounter_update(counter);
-	perf_swcounter_set_period(counter);
-	if (perf_counter_overflow(counter, nmi, data))
-		/* soft-disable the counter */
-		;
+	if (!atomic64_add_negative(nr, &hwc->period_left))
+		perf_swcounter_overflow(counter, nmi, data);
 }
 
 static int perf_swcounter_is_counting(struct perf_counter *counter)
@@ -3488,15 +3502,6 @@ static int perf_swcounter_match(struct perf_counter *counter,
 	return 1;
 }
 
-static void perf_swcounter_add(struct perf_counter *counter, u64 nr,
-			       int nmi, struct perf_sample_data *data)
-{
-	int neg = atomic64_add_negative(nr, &counter->hw.count);
-
-	if (counter->hw.sample_period && !neg && data->regs)
-		perf_swcounter_overflow(counter, nmi, data);
-}
-
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 				     enum perf_type_id type,
 				     u32 event, u64 nr, int nmi,
@@ -3575,27 +3580,66 @@ void __perf_swcounter_event(u32 event, u64 nr, int nmi,
 
 static void perf_swcounter_read(struct perf_counter *counter)
 {
-	perf_swcounter_update(counter);
 }
 
 static int perf_swcounter_enable(struct perf_counter *counter)
 {
-	perf_swcounter_set_period(counter);
+	struct hw_perf_counter *hwc = &counter->hw;
+
+	if (hwc->sample_period) {
+		hwc->last_period = hwc->sample_period;
+		perf_swcounter_set_period(counter);
+	}
 	return 0;
 }
 
 static void perf_swcounter_disable(struct perf_counter *counter)
 {
-	perf_swcounter_update(counter);
 }
 
 static const struct pmu perf_ops_generic = {
 	.enable		= perf_swcounter_enable,
 	.disable	= perf_swcounter_disable,
 	.read		= perf_swcounter_read,
+	.unthrottle	= perf_swcounter_unthrottle,
 };
 
 /*
+ * hrtimer based swcounter callback
+ */
+
+static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
+{
+	enum hrtimer_restart ret = HRTIMER_RESTART;
+	struct perf_sample_data data;
+	struct perf_counter *counter;
+	u64 period;
+
+	counter	= container_of(hrtimer, struct perf_counter, hw.hrtimer);
+	counter->pmu->read(counter);
+
+	data.addr = 0;
+	data.regs = get_irq_regs();
+	/*
+	 * In case we exclude kernel IPs or are somehow not in interrupt
+	 * context, provide the next best thing, the user IP.
+	 */
+	if ((counter->attr.exclude_kernel || !data.regs) &&
+			!counter->attr.exclude_user)
+		data.regs = task_pt_regs(current);
+
+	if (data.regs) {
+		if (perf_counter_overflow(counter, 0, &data))
+			ret = HRTIMER_NORESTART;
+	}
+
+	period = max_t(u64, 10000, counter->hw.sample_period);
+	hrtimer_forward_now(hrtimer, ns_to_ktime(period));
+
+	return ret;
+}
+
+/*
  * Software counter: cpu wall time clock
  */
 
@@ -3715,15 +3759,15 @@ static const struct pmu perf_ops_task_clock = {
 void perf_tpcounter_event(int event_id, u64 addr, u64 count, void *record,
 			  int entry_size)
 {
-	struct perf_tracepoint_record tp = {
+	struct perf_raw_record raw = {
 		.size = entry_size,
-		.record = record,
+		.data = record,
 	};
 
 	struct perf_sample_data data = {
 		.regs = get_irq_regs(),
 		.addr = addr,
-		.private = &tp,
+		.raw = &raw,
 	};
 
 	if (!data.regs)
@@ -3743,6 +3787,14 @@ static void tp_perf_counter_destroy(struct perf_counter *counter)
 
 static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 {
+	/*
+	 * Raw tracepoint data is a severe data leak, only allow root to
+	 * have these.
+	 */
+	if ((counter->attr.sample_type & PERF_SAMPLE_RAW) &&
+			!capable(CAP_SYS_ADMIN))
+		return ERR_PTR(-EPERM);
+
 	if (ftrace_profile_enable(counter->attr.config))
 		return NULL;
 
@@ -4285,7 +4337,7 @@ void perf_counter_exit_task(struct task_struct *child)
 	unsigned long flags;
 
 	if (likely(!child->perf_counter_ctxp)) {
-		perf_counter_task(child, 0);
+		perf_counter_task(child, NULL, 0);
 		return;
 	}
 
@@ -4305,6 +4357,7 @@ void perf_counter_exit_task(struct task_struct *child)
 	 * incremented the context's refcount before we do put_ctx below.
 	 */
 	spin_lock(&child_ctx->lock);
+	child->perf_counter_ctxp = NULL;
 	/*
 	 * If this context is a clone; unclone it so it can't get
 	 * swapped to another process while we're removing all
@@ -4318,9 +4371,7 @@ void perf_counter_exit_task(struct task_struct *child)
 	 * won't get any samples after PERF_EVENT_EXIT. We can however still
 	 * get a few PERF_EVENT_READ events.
 	 */
-	perf_counter_task(child, 0);
-
-	child->perf_counter_ctxp = NULL;
+	perf_counter_task(child, child_ctx, 0);
 
 	/*
 	 * We can recurse on the same lock type through:
diff --git a/tools/perf/Documentation/perf-examples.txt b/tools/perf/Documentation/perf-examples.txt
new file mode 100644
index 0000000..8eb6c48
--- /dev/null
+++ b/tools/perf/Documentation/perf-examples.txt
@@ -0,0 +1,225 @@
+
+		------------------------------
+		****** perf by examples ******
+		------------------------------
+
+[ From an e-mail by Ingo Molnar, http://lkml.org/lkml/2009/8/4/346 ]
+
+
+First, discovery/enumeration of available counters can be done via
+'perf list':
+
+titan:~> perf list
+  [...]
+  kmem:kmalloc                             [Tracepoint event]
+  kmem:kmem_cache_alloc                    [Tracepoint event]
+  kmem:kmalloc_node                        [Tracepoint event]
+  kmem:kmem_cache_alloc_node               [Tracepoint event]
+  kmem:kfree                               [Tracepoint event]
+  kmem:kmem_cache_free                     [Tracepoint event]
+  kmem:mm_page_free_direct                 [Tracepoint event]
+  kmem:mm_pagevec_free                     [Tracepoint event]
+  kmem:mm_page_alloc                       [Tracepoint event]
+  kmem:mm_page_alloc_zone_locked           [Tracepoint event]
+  kmem:mm_page_pcpu_drain                  [Tracepoint event]
+  kmem:mm_page_alloc_extfrag               [Tracepoint event]
+
+Then any (or all) of the above event sources can be activated and
+measured. For example the page alloc/free properties of a 'hackbench
+run' are:
+
+ titan:~> perf stat -e kmem:mm_page_pcpu_drain -e kmem:mm_page_alloc
+ -e kmem:mm_pagevec_free -e kmem:mm_page_free_direct ./hackbench 10
+ Time: 0.575
+
+ Performance counter stats for './hackbench 10':
+
+          13857  kmem:mm_page_pcpu_drain
+          27576  kmem:mm_page_alloc
+           6025  kmem:mm_pagevec_free
+          20934  kmem:mm_page_free_direct
+
+    0.613972165  seconds time elapsed
+
+You can observe the statistical properties as well, by using the
+'repeat the workload N times' feature of perf stat:
+
+ titan:~> perf stat --repeat 5 -e kmem:mm_page_pcpu_drain -e
+   kmem:mm_page_alloc -e kmem:mm_pagevec_free -e
+   kmem:mm_page_free_direct ./hackbench 10
+ Time: 0.627
+ Time: 0.644
+ Time: 0.564
+ Time: 0.559
+ Time: 0.626
+
+ Performance counter stats for './hackbench 10' (5 runs):
+
+          12920  kmem:mm_page_pcpu_drain    ( +-   3.359% )
+          25035  kmem:mm_page_alloc         ( +-   3.783% )
+           6104  kmem:mm_pagevec_free       ( +-   0.934% )
+          18376  kmem:mm_page_free_direct   ( +-   4.941% )
+
+    0.643954516  seconds time elapsed   ( +-   2.363% )
+
+Furthermore, these tracepoints can be used to sample the workload as
+well. For example the page allocations done by a 'git gc' can be
+captured the following way:
+
+ titan:~/git> perf record -f -e kmem:mm_page_alloc -c 1 ./git gc
+ Counting objects: 1148, done.
+ Delta compression using up to 2 threads.
+ Compressing objects: 100% (450/450), done.
+ Writing objects: 100% (1148/1148), done.
+ Total 1148 (delta 690), reused 1148 (delta 690)
+ [ perf record: Captured and wrote 0.267 MB perf.data (~11679 samples) ]
+
+To check which functions generated page allocations:
+
+ titan:~/git> perf report
+ # Samples: 10646
+ #
+ # Overhead          Command               Shared Object
+ # ........  ...............  ..........................
+ #
+    23.57%       git-repack  /lib64/libc-2.5.so
+    21.81%              git  /lib64/libc-2.5.so
+    14.59%              git  ./git
+    11.79%       git-repack  ./git
+     7.12%              git  /lib64/ld-2.5.so
+     3.16%       git-repack  /lib64/libpthread-2.5.so
+     2.09%       git-repack  /bin/bash
+     1.97%               rm  /lib64/libc-2.5.so
+     1.39%               mv  /lib64/ld-2.5.so
+     1.37%               mv  /lib64/libc-2.5.so
+     1.12%       git-repack  /lib64/ld-2.5.so
+     0.95%               rm  /lib64/ld-2.5.so
+     0.90%  git-update-serv  /lib64/libc-2.5.so
+     0.73%  git-update-serv  /lib64/ld-2.5.so
+     0.68%             perf  /lib64/libpthread-2.5.so
+     0.64%       git-repack  /usr/lib64/libz.so.1.2.3
+
+Or to see it on a more finegrained level:
+
+titan:~/git> perf report --sort comm,dso,symbol
+# Samples: 10646
+#
+# Overhead          Command               Shared Object  Symbol
+# ........  ...............  ..........................  ......
+#
+     9.35%       git-repack  ./git                       [.] insert_obj_hash
+     9.12%              git  ./git                       [.] insert_obj_hash
+     7.31%              git  /lib64/libc-2.5.so          [.] memcpy
+     6.34%       git-repack  /lib64/libc-2.5.so          [.] _int_malloc
+     6.24%       git-repack  /lib64/libc-2.5.so          [.] memcpy
+     5.82%       git-repack  /lib64/libc-2.5.so          [.] __GI___fork
+     5.47%              git  /lib64/libc-2.5.so          [.] _int_malloc
+     2.99%              git  /lib64/libc-2.5.so          [.] memset
+
+Furthermore, call-graph sampling can be done too, of page
+allocations - to see precisely what kind of page allocations there
+are:
+
+ titan:~/git> perf record -f -g -e kmem:mm_page_alloc -c 1 ./git gc
+ Counting objects: 1148, done.
+ Delta compression using up to 2 threads.
+ Compressing objects: 100% (450/450), done.
+ Writing objects: 100% (1148/1148), done.
+ Total 1148 (delta 690), reused 1148 (delta 690)
+ [ perf record: Captured and wrote 0.963 MB perf.data (~42069 samples) ]
+
+ titan:~/git> perf report -g
+ # Samples: 10686
+ #
+ # Overhead          Command               Shared Object
+ # ........  ...............  ..........................
+ #
+    23.25%       git-repack  /lib64/libc-2.5.so
+                |
+                |--50.00%-- _int_free
+                |
+                |--37.50%-- __GI___fork
+                |          make_child
+                |
+                |--12.50%-- ptmalloc_unlock_all2
+                |          make_child
+                |
+                 --6.25%-- __GI_strcpy
+    21.61%              git  /lib64/libc-2.5.so
+                |
+                |--30.00%-- __GI_read
+                |          |
+                |           --83.33%-- git_config_from_file
+                |                     git_config
+                |                     |
+   [...]
+
+Or you can observe the whole system's page allocations for 10
+seconds:
+
+titan:~/git> perf stat -a -e kmem:mm_page_pcpu_drain -e
+kmem:mm_page_alloc -e kmem:mm_pagevec_free -e
+kmem:mm_page_free_direct sleep 10
+
+ Performance counter stats for 'sleep 10':
+
+         171585  kmem:mm_page_pcpu_drain
+         322114  kmem:mm_page_alloc
+          73623  kmem:mm_pagevec_free
+         254115  kmem:mm_page_free_direct
+
+   10.000591410  seconds time elapsed
+
+Or observe how fluctuating the page allocations are, via statistical
+analysis done over ten 1-second intervals:
+
+ titan:~/git> perf stat --repeat 10 -a -e kmem:mm_page_pcpu_drain -e
+   kmem:mm_page_alloc -e kmem:mm_pagevec_free -e
+   kmem:mm_page_free_direct sleep 1
+
+ Performance counter stats for 'sleep 1' (10 runs):
+
+          17254  kmem:mm_page_pcpu_drain    ( +-   3.709% )
+          34394  kmem:mm_page_alloc         ( +-   4.617% )
+           7509  kmem:mm_pagevec_free       ( +-   4.820% )
+          25653  kmem:mm_page_free_direct   ( +-   3.672% )
+
+    1.058135029  seconds time elapsed   ( +-   3.089% )
+
+Or you can annotate the recorded 'git gc' run on a per symbol basis
+and check which instructions/source-code generated page allocations:
+
+ titan:~/git> perf annotate __GI___fork
+ ------------------------------------------------
+  Percent |      Source code & Disassembly of libc-2.5.so
+ ------------------------------------------------
+          :
+          :
+          :      Disassembly of section .plt:
+          :      Disassembly of section .text:
+          :
+          :      00000031a2e95560 <__fork>:
+ [...]
+     0.00 :        31a2e95602:   b8 38 00 00 00          mov    $0x38,%eax
+     0.00 :        31a2e95607:   0f 05                   syscall
+    83.42 :        31a2e95609:   48 3d 00 f0 ff ff       cmp    $0xfffffffffffff000,%rax
+     0.00 :        31a2e9560f:   0f 87 4d 01 00 00       ja     31a2e95762 <__fork+0x202>
+     0.00 :        31a2e95615:   85 c0                   test   %eax,%eax
+
+( this shows that 83.42% of __GI___fork's page allocations come from
+  the 0x38 system call it performs. )
+
+etc. etc. - a lot more is possible. I could list a dozen of
+other different usecases straight away - neither of which is
+possible via /proc/vmstat.
+
+/proc/vmstat is not in the same league really, in terms of
+expressive power of system analysis and performance
+analysis.
+
+All that the above results needed were those new tracepoints
+in include/tracing/events/kmem.h.
+
+	Ingo
+
+
diff --git a/tools/perf/Documentation/perf-stat.txt b/tools/perf/Documentation/perf-stat.txt
index 0d74346..484080d 100644
--- a/tools/perf/Documentation/perf-stat.txt
+++ b/tools/perf/Documentation/perf-stat.txt
@@ -40,7 +40,7 @@ OPTIONS
 -a::
         system-wide collection
 
--S::
+-c::
         scale counter values
 
 EXAMPLES
diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 539d012..4a7d558 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -3,36 +3,122 @@ perf-top(1)
 
 NAME
 ----
-perf-top - Run a command and profile it
+perf-top - System profiling tool.
 
 SYNOPSIS
 --------
 [verse]
-'perf top' [-e <EVENT> | --event=EVENT] [-l] [-a] <command>
+'perf top' [-e <EVENT> | --event=EVENT] [<options>]
 
 DESCRIPTION
 -----------
-This command runs a command and gathers a performance counter profile
-from it.
+This command generates and displays a performance counter profile in realtime.
 
 
 OPTIONS
 -------
-<command>...::
-	Any command you can specify in a shell.
+-a::
+--all-cpus::
+        System-wide collection.  (default)
+
+-c <count>::
+--count=<count>::
+	Event period to sample.
+
+-C <cpu>::
+--CPU=<cpu>::
+	CPU to profile.
+
+-d <seconds>::
+--delay=<seconds>::
+	Number of seconds to delay between refreshes.
 
--e::
---event=::
+-e <event>::
+--event=<event>::
 	Select the PMU event. Selection can be a symbolic event name
 	(use 'perf list' to list all events) or a raw PMU
 	event (eventsel+umask) in the form of rNNN where NNN is a
-	 hexadecimal event descriptor.
+	hexadecimal event descriptor.
 
--a::
-        system-wide collection
+-E <entries>::
+--entries=<entries>::
+	Display this many functions.
+
+-f <count>::
+--count-filter=<count>::
+	Only display functions with more events than this.
+
+-F <freq>::
+--freq=<freq>::
+	Profile at this frequency.
+
+-i::
+--inherit::
+	Child tasks inherit counters, only makes sens with -p option.
+
+-k <path>::
+--vmlinux=<path>::
+	Path to vmlinux.  Required for annotation functionality.
+
+-m <pages>::
+--mmap-pages=<pages>::
+	Number of mmapped data pages.
+
+-p <pid>::
+--pid=<pid>::
+	Profile events on existing pid.
+
+-r <priority>::
+--realtime=<priority>::
+	Collect data with this RT SCHED_FIFO priority.
+
+-s <symbol>::
+--sym-annotate=<symbol>::
+        Annotate this symbol.  Requires -k option.
+
+-v::
+--verbose::
+	Be more verbose (show counter open errors, etc).
+
+-z::
+--zero::
+	Zero history across display updates.
+
+INTERACTIVE PROMPTING KEYS
+--------------------------
+
+[d]::
+	Display refresh delay.
+
+[e]::
+	Number of entries to display.
+
+[E]::
+	Event to display when multiple counters are active.
+
+[f]::
+	Profile display filter (>= hit count).
+
+[F]::
+	Annotation display filter (>= % of total).
+
+[s]::
+	Annotate symbol.
+
+[S]::
+	Stop annotation, return to full profile display.
+
+[w]::
+	Toggle between weighted sum and individual count[E]r profile.
+
+[z]::
+	Toggle event count zeroing across display updates.
+
+[qQ]::
+	Quit.
+
+Pressing any unmapped key displays a menu, and prompts for input.
 
--l::
-        scale counter values
 
 SEE ALSO
 --------
diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 1916e44..60411e9 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -387,10 +387,14 @@ else
 
 	has_bfd_iberty := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty > /dev/null 2>&1 && echo y")
 
+	has_bfd_iberty_z := $(shell sh -c "(echo '\#include <bfd.h>'; echo 'int main(void) { bfd_demangle(0, 0, 0); return 0; }') | $(CC) -x c - $(ALL_CFLAGS) -o /dev/null $(ALL_LDFLAGS) -lbfd -liberty -lz > /dev/null 2>&1 && echo y")
+
 	ifeq ($(has_bfd),y)
 		EXTLIBS += -lbfd
 	else ifeq ($(has_bfd_iberty),y)
 		EXTLIBS += -lbfd -liberty
+	else ifeq ($(has_bfd_iberty_z),y)
+		EXTLIBS += -lbfd -liberty -lz
 	else
 		msg := $(warning No bfd.h/libbfd found, install binutils-dev[el] to gain symbol demangling)
 		BASIC_CFLAGS += -DNO_DEMANGLE
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 90c9808..0345aad 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -525,10 +525,14 @@ static int __cmd_record(int argc, const char **argv)
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 
-	if (!stat(output_name, &st) && !force && !append_file) {
-		fprintf(stderr, "Error, output file %s exists, use -A to append or -f to overwrite.\n",
-				output_name);
-		exit(-1);
+	if (!stat(output_name, &st) && st.st_size) {
+		if (!force && !append_file) {
+			fprintf(stderr, "Error, output file %s exists, use -A to append or -f to overwrite.\n",
+					output_name);
+			exit(-1);
+		}
+	} else {
+		append_file = 0;
 	}
 
 	flags = O_CREAT|O_RDWR;
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 8cb58d6..99274ce 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -68,7 +68,7 @@ static int		callchain;
 
 static
 struct callchain_param	callchain_param = {
-	.mode	= CHAIN_GRAPH_ABS,
+	.mode	= CHAIN_GRAPH_REL,
 	.min_percent = 0.5
 };
 
@@ -112,7 +112,9 @@ struct read_event {
 	struct perf_event_header header;
 	u32 pid,tid;
 	u64 value;
-	u64 format[3];
+	u64 time_enabled;
+	u64 time_running;
+	u64 id;
 };
 
 typedef union event_union {
@@ -698,7 +700,8 @@ sort__sym_print(FILE *fp, struct hist_entry *self, unsigned int width __used)
 	size_t ret = 0;
 
 	if (verbose)
-		ret += repsep_fprintf(fp, "%#018llx  ", (u64)self->ip);
+		ret += repsep_fprintf(fp, "%#018llx %c ", (u64)self->ip,
+				      dso__symtab_origin(self->dso));
 
 	ret += repsep_fprintf(fp, "[%c] ", self->level);
 	if (self->sym) {
@@ -888,6 +891,21 @@ ipchain__fprintf_graph(FILE *fp, struct callchain_list *chain, int depth,
 	return ret;
 }
 
+static struct symbol *rem_sq_bracket;
+static struct callchain_list rem_hits;
+
+static void init_rem_hits(void)
+{
+	rem_sq_bracket = malloc(sizeof(*rem_sq_bracket) + 6);
+	if (!rem_sq_bracket) {
+		fprintf(stderr, "Not enough memory to display remaining hits\n");
+		return;
+	}
+
+	strcpy(rem_sq_bracket->name, "[...]");
+	rem_hits.sym = rem_sq_bracket;
+}
+
 static size_t
 callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 			u64 total_samples, int depth, int depth_mask)
@@ -897,25 +915,34 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 	struct callchain_list *chain;
 	int new_depth_mask = depth_mask;
 	u64 new_total;
+	u64 remaining;
 	size_t ret = 0;
 	int i;
 
 	if (callchain_param.mode == CHAIN_GRAPH_REL)
-		new_total = self->cumul_hit;
+		new_total = self->children_hit;
 	else
 		new_total = total_samples;
 
+	remaining = new_total;
+
 	node = rb_first(&self->rb_root);
 	while (node) {
+		u64 cumul;
+
 		child = rb_entry(node, struct callchain_node, rb_node);
+		cumul = cumul_hits(child);
+		remaining -= cumul;
 
 		/*
 		 * The depth mask manages the output of pipes that show
 		 * the depth. We don't want to keep the pipes of the current
-		 * level for the last child of this depth
+		 * level for the last child of this depth.
+		 * Except if we have remaining filtered hits. They will
+		 * supersede the last child
 		 */
 		next = rb_next(node);
-		if (!next)
+		if (!next && (callchain_param.mode != CHAIN_GRAPH_REL || !remaining))
 			new_depth_mask &= ~(1 << (depth - 1));
 
 		/*
@@ -930,7 +957,7 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 			ret += ipchain__fprintf_graph(fp, chain, depth,
 						      new_depth_mask, i++,
 						      new_total,
-						      child->cumul_hit);
+						      cumul);
 		}
 		ret += callchain__fprintf_graph(fp, child, new_total,
 						depth + 1,
@@ -938,6 +965,19 @@ callchain__fprintf_graph(FILE *fp, struct callchain_node *self,
 		node = next;
 	}
 
+	if (callchain_param.mode == CHAIN_GRAPH_REL &&
+		remaining && remaining != new_total) {
+
+		if (!rem_sq_bracket)
+			return ret;
+
+		new_depth_mask &= ~(1 << (depth - 1));
+
+		ret += ipchain__fprintf_graph(fp, &rem_hits, depth,
+					      new_depth_mask, 0, new_total,
+					      remaining);
+	}
+
 	return ret;
 }
 
@@ -1358,6 +1398,8 @@ static size_t output__fprintf(FILE *fp, u64 total_samples)
 	unsigned int width;
 	char *col_width = col_width_list_str;
 
+	init_rem_hits();
+
 	fprintf(fp, "# Samples: %Ld\n", (u64)total_samples);
 	fprintf(fp, "#\n");
 
@@ -1429,6 +1471,8 @@ print_entries:
 	}
 	fprintf(fp, "\n");
 
+	free(rem_sq_bracket);
+
 	return ret;
 }
 
@@ -1690,14 +1734,37 @@ static void trace_event(event_t *event)
 	dprintf(".\n");
 }
 
+static struct perf_header	*header;
+
+static struct perf_counter_attr *perf_header__find_attr(u64 id)
+{
+	int i;
+
+	for (i = 0; i < header->attrs; i++) {
+		struct perf_header_attr *attr = header->attr[i];
+		int j;
+
+		for (j = 0; j < attr->ids; j++) {
+			if (attr->id[j] == id)
+				return &attr->attr;
+		}
+	}
+
+	return NULL;
+}
+
 static int
 process_read_event(event_t *event, unsigned long offset, unsigned long head)
 {
-	dprintf("%p [%p]: PERF_EVENT_READ: %d %d %Lu\n",
+	struct perf_counter_attr *attr = perf_header__find_attr(event->read.id);
+
+	dprintf("%p [%p]: PERF_EVENT_READ: %d %d %s %Lu\n",
 			(void *)(offset + head),
 			(void *)(long)(event->header.size),
 			event->read.pid,
 			event->read.tid,
+			attr ? __event_name(attr->type, attr->config)
+			     : "FAIL",
 			event->read.value);
 
 	return 0;
@@ -1743,8 +1810,6 @@ process_event(event_t *event, unsigned long offset, unsigned long head)
 	return 0;
 }
 
-static struct perf_header	*header;
-
 static u64 perf_header__sample_type(void)
 {
 	u64 sample_type = 0;
@@ -1812,6 +1877,13 @@ static int __cmd_report(void)
 					" -g?\n");
 			exit(-1);
 		}
+	} else if (callchain_param.mode != CHAIN_NONE && !callchain) {
+			callchain = 1;
+			if (register_callchain_param(&callchain_param) < 0) {
+				fprintf(stderr, "Can't register callchain"
+						" params\n");
+				exit(-1);
+			}
 	}
 
 	if (load_kernel() < 0) {
@@ -1950,6 +2022,13 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 	else if (!strncmp(tok, "fractal", strlen(arg)))
 		callchain_param.mode = CHAIN_GRAPH_REL;
 
+	else if (!strncmp(tok, "none", strlen(arg))) {
+		callchain_param.mode = CHAIN_NONE;
+		callchain = 0;
+
+		return 0;
+	}
+
 	else
 		return -1;
 
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f9510ee..b4b06c7 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -496,7 +496,7 @@ static const struct option options[] = {
 		    "stat events on existing pid"),
 	OPT_BOOLEAN('a', "all-cpus", &system_wide,
 		    "system-wide collection from all CPUs"),
-	OPT_BOOLEAN('S', "scale", &scale,
+	OPT_BOOLEAN('c', "scale", &scale,
 		    "scale/normalize counters"),
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f139f1a..7de28ce 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -31,6 +31,8 @@
 #include <fcntl.h>
 
 #include <stdio.h>
+#include <termios.h>
+#include <unistd.h>
 
 #include <errno.h>
 #include <time.h>
@@ -54,7 +56,7 @@ static int			system_wide			=  0;
 
 static int			default_interval		= 100000;
 
-static u64			count_filter			=  5;
+static int			count_filter			=  5;
 static int			print_entries			= 15;
 
 static int			target_pid			= -1;
@@ -69,15 +71,28 @@ static int			freq				=  0;
 static int			verbose				=  0;
 static char			*vmlinux			=  NULL;
 
-static char			*sym_filter;
-static unsigned long		filter_start;
-static unsigned long		filter_end;
-
 static int			delay_secs			=  2;
 static int			zero;
 static int			dump_symtab;
 
 /*
+ * Source
+ */
+
+struct source_line {
+	u64			eip;
+	unsigned long		count[MAX_COUNTERS];
+	char			*line;
+	struct source_line	*next;
+};
+
+static char			*sym_filter			=  NULL;
+struct sym_entry		*sym_filter_entry		=  NULL;
+static int			sym_pcnt_filter			=  5;
+static int			sym_counter			=  0;
+static int			display_weighted		= -1;
+
+/*
  * Symbols
  */
 
@@ -91,9 +106,237 @@ struct sym_entry {
 	unsigned long		snap_count;
 	double			weight;
 	int			skip;
+	struct source_line	*source;
+	struct source_line	*lines;
+	struct source_line	**lines_tail;
+	pthread_mutex_t		source_lock;
 };
 
-struct sym_entry		*sym_filter_entry;
+/*
+ * Source functions
+ */
+
+static void parse_source(struct sym_entry *syme)
+{
+	struct symbol *sym;
+	struct module *module;
+	struct section *section = NULL;
+	FILE *file;
+	char command[PATH_MAX*2], *path = vmlinux;
+	u64 start, end, len;
+
+	if (!syme)
+		return;
+
+	if (syme->lines) {
+		pthread_mutex_lock(&syme->source_lock);
+		goto out_assign;
+	}
+
+	sym = (struct symbol *)(syme + 1);
+	module = sym->module;
+
+	if (module)
+		path = module->path;
+	if (!path)
+		return;
+
+	start = sym->obj_start;
+	if (!start)
+		start = sym->start;
+
+	if (module) {
+		section = module->sections->find_section(module->sections, ".text");
+		if (section)
+			start -= section->vma;
+	}
+
+	end = start + sym->end - sym->start + 1;
+	len = sym->end - sym->start;
+
+	sprintf(command, "objdump --start-address=0x%016Lx --stop-address=0x%016Lx -dS %s", start, end, path);
+
+	file = popen(command, "r");
+	if (!file)
+		return;
+
+	pthread_mutex_lock(&syme->source_lock);
+	syme->lines_tail = &syme->lines;
+	while (!feof(file)) {
+		struct source_line *src;
+		size_t dummy = 0;
+		char *c;
+
+		src = malloc(sizeof(struct source_line));
+		assert(src != NULL);
+		memset(src, 0, sizeof(struct source_line));
+
+		if (getline(&src->line, &dummy, file) < 0)
+			break;
+		if (!src->line)
+			break;
+
+		c = strchr(src->line, '\n');
+		if (c)
+			*c = 0;
+
+		src->next = NULL;
+		*syme->lines_tail = src;
+		syme->lines_tail = &src->next;
+
+		if (strlen(src->line)>8 && src->line[8] == ':') {
+			src->eip = strtoull(src->line, NULL, 16);
+			if (section)
+				src->eip += section->vma;
+		}
+		if (strlen(src->line)>8 && src->line[16] == ':') {
+			src->eip = strtoull(src->line, NULL, 16);
+			if (section)
+				src->eip += section->vma;
+		}
+	}
+	pclose(file);
+out_assign:
+	sym_filter_entry = syme;
+	pthread_mutex_unlock(&syme->source_lock);
+}
+
+static void __zero_source_counters(struct sym_entry *syme)
+{
+	int i;
+	struct source_line *line;
+
+	line = syme->lines;
+	while (line) {
+		for (i = 0; i < nr_counters; i++)
+			line->count[i] = 0;
+		line = line->next;
+	}
+}
+
+static void record_precise_ip(struct sym_entry *syme, int counter, u64 ip)
+{
+	struct source_line *line;
+
+	if (syme != sym_filter_entry)
+		return;
+
+	if (pthread_mutex_trylock(&syme->source_lock))
+		return;
+
+	if (!syme->source)
+		goto out_unlock;
+
+	for (line = syme->lines; line; line = line->next) {
+		if (line->eip == ip) {
+			line->count[counter]++;
+			break;
+		}
+		if (line->eip > ip)
+			break;
+	}
+out_unlock:
+	pthread_mutex_unlock(&syme->source_lock);
+}
+
+static void lookup_sym_source(struct sym_entry *syme)
+{
+	struct symbol *symbol = (struct symbol *)(syme + 1);
+	struct source_line *line;
+	char pattern[PATH_MAX];
+	char *idx;
+
+	sprintf(pattern, "<%s>:", symbol->name);
+
+	if (symbol->module) {
+		idx = strstr(pattern, "\t");
+		if (idx)
+			*idx = 0;
+	}
+
+	pthread_mutex_lock(&syme->source_lock);
+	for (line = syme->lines; line; line = line->next) {
+		if (strstr(line->line, pattern)) {
+			syme->source = line;
+			break;
+		}
+	}
+	pthread_mutex_unlock(&syme->source_lock);
+}
+
+static void show_lines(struct source_line *queue, int count, int total)
+{
+	int i;
+	struct source_line *line;
+
+	line = queue;
+	for (i = 0; i < count; i++) {
+		float pcnt = 100.0*(float)line->count[sym_counter]/(float)total;
+
+		printf("%8li %4.1f%%\t%s\n", line->count[sym_counter], pcnt, line->line);
+		line = line->next;
+	}
+}
+
+#define TRACE_COUNT     3
+
+static void show_details(struct sym_entry *syme)
+{
+	struct symbol *symbol;
+	struct source_line *line;
+	struct source_line *line_queue = NULL;
+	int displayed = 0;
+	int line_queue_count = 0, total = 0, more = 0;
+
+	if (!syme)
+		return;
+
+	if (!syme->source)
+		lookup_sym_source(syme);
+
+	if (!syme->source)
+		return;
+
+	symbol = (struct symbol *)(syme + 1);
+	printf("Showing %s for %s\n", event_name(sym_counter), symbol->name);
+	printf("  Events  Pcnt (>=%d%%)\n", sym_pcnt_filter);
+
+	pthread_mutex_lock(&syme->source_lock);
+	line = syme->source;
+	while (line) {
+		total += line->count[sym_counter];
+		line = line->next;
+	}
+
+	line = syme->source;
+	while (line) {
+		float pcnt = 0.0;
+
+		if (!line_queue_count)
+			line_queue = line;
+		line_queue_count++;
+
+		if (line->count[sym_counter])
+			pcnt = 100.0 * line->count[sym_counter] / (float)total;
+		if (pcnt >= (float)sym_pcnt_filter) {
+			if (displayed <= print_entries)
+				show_lines(line_queue, line_queue_count, total);
+			else more++;
+			displayed += line_queue_count;
+			line_queue_count = 0;
+			line_queue = NULL;
+		} else if (line_queue_count > TRACE_COUNT) {
+			line_queue = line_queue->next;
+			line_queue_count--;
+		}
+
+		line->count[sym_counter] = zero ? 0 : line->count[sym_counter] * 7 / 8;
+		line = line->next;
+	}
+	pthread_mutex_unlock(&syme->source_lock);
+	if (more)
+		printf("%d lines not displayed, maybe increase display entries [e]\n", more);
+}
 
 struct dso			*kernel_dso;
 
@@ -112,6 +355,9 @@ static double sym_weight(const struct sym_entry *sym)
 	double weight = sym->snap_count;
 	int counter;
 
+	if (!display_weighted)
+		return weight;
+
 	for (counter = 1; counter < nr_counters-1; counter++)
 		weight *= sym->count[counter];
 
@@ -159,7 +405,7 @@ static void rb_insert_active_sym(struct rb_root *tree, struct sym_entry *se)
 static void print_sym_table(void)
 {
 	int printed = 0, j;
-	int counter;
+	int counter, snap = !display_weighted ? sym_counter : 0;
 	float samples_per_sec = samples/delay_secs;
 	float ksamples_per_sec = (samples-userspace_samples)/delay_secs;
 	float sum_ksamples = 0.0;
@@ -175,7 +421,7 @@ static void print_sym_table(void)
 	pthread_mutex_unlock(&active_symbols_lock);
 
 	list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
-		syme->snap_count = syme->count[0];
+		syme->snap_count = syme->count[snap];
 		if (syme->snap_count != 0) {
 			syme->weight = sym_weight(syme);
 			rb_insert_active_sym(&tmp, syme);
@@ -195,7 +441,7 @@ static void print_sym_table(void)
 		samples_per_sec,
 		100.0 - (100.0*((samples_per_sec-ksamples_per_sec)/samples_per_sec)));
 
-	if (nr_counters == 1) {
+	if (nr_counters == 1 || !display_weighted) {
 		printf("%Ld", (u64)attrs[0].sample_period);
 		if (freq)
 			printf("Hz ");
@@ -203,7 +449,9 @@ static void print_sym_table(void)
 			printf(" ");
 	}
 
-	for (counter = 0; counter < nr_counters; counter++) {
+	if (!display_weighted)
+		printf("%s", event_name(sym_counter));
+	else for (counter = 0; counter < nr_counters; counter++) {
 		if (counter)
 			printf("/");
 
@@ -228,6 +476,11 @@ static void print_sym_table(void)
 
 	printf("------------------------------------------------------------------------------\n\n");
 
+	if (sym_filter_entry) {
+		show_details(sym_filter_entry);
+		return;
+	}
+
 	if (nr_counters == 1)
 		printf("             samples    pcnt");
 	else
@@ -242,13 +495,13 @@ static void print_sym_table(void)
 		struct symbol *sym = (struct symbol *)(syme + 1);
 		double pcnt;
 
-		if (++printed > print_entries || syme->snap_count < count_filter)
+		if (++printed > print_entries || (int)syme->snap_count < count_filter)
 			continue;
 
 		pcnt = 100.0 - (100.0 * ((sum_ksamples - syme->snap_count) /
 					 sum_ksamples));
 
-		if (nr_counters == 1)
+		if (nr_counters == 1 || !display_weighted)
 			printf("%20.2f - ", syme->weight);
 		else
 			printf("%9.1f %10ld - ", syme->weight, syme->snap_count);
@@ -261,19 +514,250 @@ static void print_sym_table(void)
 	}
 }
 
+static void prompt_integer(int *target, const char *msg)
+{
+	char *buf = malloc(0), *p;
+	size_t dummy = 0;
+	int tmp;
+
+	fprintf(stdout, "\n%s: ", msg);
+	if (getline(&buf, &dummy, stdin) < 0)
+		return;
+
+	p = strchr(buf, '\n');
+	if (p)
+		*p = 0;
+
+	p = buf;
+	while(*p) {
+		if (!isdigit(*p))
+			goto out_free;
+		p++;
+	}
+	tmp = strtoul(buf, NULL, 10);
+	*target = tmp;
+out_free:
+	free(buf);
+}
+
+static void prompt_percent(int *target, const char *msg)
+{
+	int tmp = 0;
+
+	prompt_integer(&tmp, msg);
+	if (tmp >= 0 && tmp <= 100)
+		*target = tmp;
+}
+
+static void prompt_symbol(struct sym_entry **target, const char *msg)
+{
+	char *buf = malloc(0), *p;
+	struct sym_entry *syme = *target, *n, *found = NULL;
+	size_t dummy = 0;
+
+	/* zero counters of active symbol */
+	if (syme) {
+		pthread_mutex_lock(&syme->source_lock);
+		__zero_source_counters(syme);
+		*target = NULL;
+		pthread_mutex_unlock(&syme->source_lock);
+	}
+
+	fprintf(stdout, "\n%s: ", msg);
+	if (getline(&buf, &dummy, stdin) < 0)
+		goto out_free;
+
+	p = strchr(buf, '\n');
+	if (p)
+		*p = 0;
+
+	pthread_mutex_lock(&active_symbols_lock);
+	syme = list_entry(active_symbols.next, struct sym_entry, node);
+	pthread_mutex_unlock(&active_symbols_lock);
+
+	list_for_each_entry_safe_from(syme, n, &active_symbols, node) {
+		struct symbol *sym = (struct symbol *)(syme + 1);
+
+		if (!strcmp(buf, sym->name)) {
+			found = syme;
+			break;
+		}
+	}
+
+	if (!found) {
+		fprintf(stderr, "Sorry, %s is not active.\n", sym_filter);
+		sleep(1);
+		return;
+	} else
+		parse_source(found);
+
+out_free:
+	free(buf);
+}
+
+static void print_mapped_keys(void)
+{
+	char *name = NULL;
+
+	if (sym_filter_entry) {
+		struct symbol *sym = (struct symbol *)(sym_filter_entry+1);
+		name = sym->name;
+	}
+
+	fprintf(stdout, "\nMapped keys:\n");
+	fprintf(stdout, "\t[d]     display refresh delay.             \t(%d)\n", delay_secs);
+	fprintf(stdout, "\t[e]     display entries (lines).           \t(%d)\n", print_entries);
+
+	if (nr_counters > 1)
+		fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(sym_counter));
+
+	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", count_filter);
+
+	if (vmlinux) {
+		fprintf(stdout, "\t[F]     annotate display filter (percent). \t(%d%%)\n", sym_pcnt_filter);
+		fprintf(stdout, "\t[s]     annotate symbol.                   \t(%s)\n", name?: "NULL");
+		fprintf(stdout, "\t[S]     stop annotation.\n");
+	}
+
+	if (nr_counters > 1)
+		fprintf(stdout, "\t[w]     toggle display weighted/count[E]r. \t(%d)\n", display_weighted ? 1 : 0);
+
+	fprintf(stdout, "\t[z]     toggle sample zeroing.             \t(%d)\n", zero ? 1 : 0);
+	fprintf(stdout, "\t[qQ]    quit.\n");
+}
+
+static int key_mapped(int c)
+{
+	switch (c) {
+		case 'd':
+		case 'e':
+		case 'f':
+		case 'z':
+		case 'q':
+		case 'Q':
+			return 1;
+		case 'E':
+		case 'w':
+			return nr_counters > 1 ? 1 : 0;
+		case 'F':
+		case 's':
+		case 'S':
+			return vmlinux ? 1 : 0;
+	}
+
+	return 0;
+}
+
+static void handle_keypress(int c)
+{
+	if (!key_mapped(c)) {
+		struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
+		struct termios tc, save;
+
+		print_mapped_keys();
+		fprintf(stdout, "\nEnter selection, or unmapped key to continue: ");
+		fflush(stdout);
+
+		tcgetattr(0, &save);
+		tc = save;
+		tc.c_lflag &= ~(ICANON | ECHO);
+		tc.c_cc[VMIN] = 0;
+		tc.c_cc[VTIME] = 0;
+		tcsetattr(0, TCSANOW, &tc);
+
+		poll(&stdin_poll, 1, -1);
+		c = getc(stdin);
+
+		tcsetattr(0, TCSAFLUSH, &save);
+		if (!key_mapped(c))
+			return;
+	}
+
+	switch (c) {
+		case 'd':
+			prompt_integer(&delay_secs, "Enter display delay");
+			break;
+		case 'e':
+			prompt_integer(&print_entries, "Enter display entries (lines)");
+			break;
+		case 'E':
+			if (nr_counters > 1) {
+				int i;
+
+				fprintf(stderr, "\nAvailable events:");
+				for (i = 0; i < nr_counters; i++)
+					fprintf(stderr, "\n\t%d %s", i, event_name(i));
+
+				prompt_integer(&sym_counter, "Enter details event counter");
+
+				if (sym_counter >= nr_counters) {
+					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(0));
+					sym_counter = 0;
+					sleep(1);
+				}
+			} else sym_counter = 0;
+			break;
+		case 'f':
+			prompt_integer(&count_filter, "Enter display event count filter");
+			break;
+		case 'F':
+			prompt_percent(&sym_pcnt_filter, "Enter details display event filter (percent)");
+			break;
+		case 'q':
+		case 'Q':
+			printf("exiting.\n");
+			exit(0);
+		case 's':
+			prompt_symbol(&sym_filter_entry, "Enter details symbol");
+			break;
+		case 'S':
+			if (!sym_filter_entry)
+				break;
+			else {
+				struct sym_entry *syme = sym_filter_entry;
+
+				pthread_mutex_lock(&syme->source_lock);
+				sym_filter_entry = NULL;
+				__zero_source_counters(syme);
+				pthread_mutex_unlock(&syme->source_lock);
+			}
+			break;
+		case 'w':
+			display_weighted = ~display_weighted;
+			break;
+		case 'z':
+			zero = ~zero;
+			break;
+	}
+}
+
 static void *display_thread(void *arg __used)
 {
 	struct pollfd stdin_poll = { .fd = 0, .events = POLLIN };
-	int delay_msecs = delay_secs * 1000;
+	struct termios tc, save;
+	int delay_msecs, c;
+
+	tcgetattr(0, &save);
+	tc = save;
+	tc.c_lflag &= ~(ICANON | ECHO);
+	tc.c_cc[VMIN] = 0;
+	tc.c_cc[VTIME] = 0;
 
-	printf("PerfTop refresh period: %d seconds\n", delay_secs);
+repeat:
+	delay_msecs = delay_secs * 1000;
+	tcsetattr(0, TCSANOW, &tc);
+	/* trash return*/
+	getc(stdin);
 
 	do {
 		print_sym_table();
 	} while (!poll(&stdin_poll, 1, delay_msecs) == 1);
 
-	printf("key pressed - exiting.\n");
-	exit(0);
+	c = getc(stdin);
+	tcsetattr(0, TCSAFLUSH, &save);
+
+	handle_keypress(c);
+	goto repeat;
 
 	return NULL;
 }
@@ -293,7 +777,6 @@ static const char *skip_symbols[] = {
 
 static int symbol_filter(struct dso *self, struct symbol *sym)
 {
-	static int filter_match;
 	struct sym_entry *syme;
 	const char *name = sym->name;
 	int i;
@@ -315,6 +798,10 @@ static int symbol_filter(struct dso *self, struct symbol *sym)
 		return 1;
 
 	syme = dso__sym_priv(self, sym);
+	pthread_mutex_init(&syme->source_lock, NULL);
+	if (!sym_filter_entry && sym_filter && !strcmp(name, sym_filter))
+		sym_filter_entry = syme;
+
 	for (i = 0; skip_symbols[i]; i++) {
 		if (!strcmp(skip_symbols[i], name)) {
 			syme->skip = 1;
@@ -322,29 +809,6 @@ static int symbol_filter(struct dso *self, struct symbol *sym)
 		}
 	}
 
-	if (filter_match == 1) {
-		filter_end = sym->start;
-		filter_match = -1;
-		if (filter_end - filter_start > 10000) {
-			fprintf(stderr,
-				"hm, too large filter symbol <%s> - skipping.\n",
-				sym_filter);
-			fprintf(stderr, "symbol filter start: %016lx\n",
-				filter_start);
-			fprintf(stderr, "                end: %016lx\n",
-				filter_end);
-			filter_end = filter_start = 0;
-			sym_filter = NULL;
-			sleep(1);
-		}
-	}
-
-	if (filter_match == 0 && sym_filter && !strcmp(name, sym_filter)) {
-		filter_match = 1;
-		filter_start = sym->start;
-	}
-
-
 	return 0;
 }
 
@@ -380,8 +844,6 @@ out_delete_dso:
 	return -1;
 }
 
-#define TRACE_COUNT     3
-
 /*
  * Binary search in the histogram table and record the hit:
  */
@@ -394,6 +856,7 @@ static void record_ip(u64 ip, int counter)
 
 		if (!syme->skip) {
 			syme->count[counter]++;
+			record_precise_ip(syme, counter, ip);
 			pthread_mutex_lock(&active_symbols_lock);
 			if (list_empty(&syme->node) || !syme->node.next)
 				__list_insert_active_sym(syme);
@@ -690,8 +1153,8 @@ static const struct option options[] = {
 			    "put the counters into a counter group"),
 	OPT_BOOLEAN('i', "inherit", &inherit,
 		    "child tasks inherit counters"),
-	OPT_STRING('s', "sym-filter", &sym_filter, "pattern",
-		    "only display symbols matchig this pattern"),
+	OPT_STRING('s', "sym-annotate", &sym_filter, "symbol name",
+		    "symbol to annotate - requires -k option"),
 	OPT_BOOLEAN('z', "zero", &zero,
 		    "zero history across updates"),
 	OPT_INTEGER('F', "freq", &freq,
@@ -734,6 +1197,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 		delay_secs = 1;
 
 	parse_symbols();
+	parse_source(sym_filter_entry);
 
 	/*
 	 * Fill in the ones not specifically initialized via -c:
diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 9d3c814..0114734 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -13,6 +13,7 @@
 #include <stdio.h>
 #include <stdbool.h>
 #include <errno.h>
+#include <math.h>
 
 #include "callchain.h"
 
@@ -26,10 +27,14 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 	struct rb_node **p = &root->rb_node;
 	struct rb_node *parent = NULL;
 	struct callchain_node *rnode;
+	u64 chain_cumul = cumul_hits(chain);
 
 	while (*p) {
+		u64 rnode_cumul;
+
 		parent = *p;
 		rnode = rb_entry(parent, struct callchain_node, rb_node);
+		rnode_cumul = cumul_hits(rnode);
 
 		switch (mode) {
 		case CHAIN_FLAT:
@@ -40,7 +45,7 @@ rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 			break;
 		case CHAIN_GRAPH_ABS: /* Falldown */
 		case CHAIN_GRAPH_REL:
-			if (rnode->cumul_hit < chain->cumul_hit)
+			if (rnode_cumul < chain_cumul)
 				p = &(*p)->rb_left;
 			else
 				p = &(*p)->rb_right;
@@ -87,7 +92,7 @@ static void __sort_chain_graph_abs(struct callchain_node *node,
 
 	chain_for_each_child(child, node) {
 		__sort_chain_graph_abs(child, min_hit);
-		if (child->cumul_hit >= min_hit)
+		if (cumul_hits(child) >= min_hit)
 			rb_insert_callchain(&node->rb_root, child,
 					    CHAIN_GRAPH_ABS);
 	}
@@ -108,11 +113,11 @@ static void __sort_chain_graph_rel(struct callchain_node *node,
 	u64 min_hit;
 
 	node->rb_root = RB_ROOT;
-	min_hit = node->cumul_hit * min_percent / 100.0;
+	min_hit = ceil(node->children_hit * min_percent);
 
 	chain_for_each_child(child, node) {
 		__sort_chain_graph_rel(child, min_percent);
-		if (child->cumul_hit >= min_hit)
+		if (cumul_hits(child) >= min_hit)
 			rb_insert_callchain(&node->rb_root, child,
 					    CHAIN_GRAPH_REL);
 	}
@@ -122,7 +127,7 @@ static void
 sort_chain_graph_rel(struct rb_root *rb_root, struct callchain_node *chain_root,
 		     u64 min_hit __used, struct callchain_param *param)
 {
-	__sort_chain_graph_rel(chain_root, param->min_percent);
+	__sort_chain_graph_rel(chain_root, param->min_percent / 100.0);
 	rb_root->rb_node = chain_root->rb_root.rb_node;
 }
 
@@ -211,7 +216,8 @@ add_child(struct callchain_node *parent, struct ip_callchain *chain,
 	new = create_child(parent, false);
 	fill_node(new, chain, start, syms);
 
-	new->cumul_hit = new->hit = 1;
+	new->children_hit = 0;
+	new->hit = 1;
 }
 
 /*
@@ -241,7 +247,8 @@ split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
 
 	/* split the hits */
 	new->hit = parent->hit;
-	new->cumul_hit = parent->cumul_hit;
+	new->children_hit = parent->children_hit;
+	parent->children_hit = cumul_hits(new);
 	new->val_nr = parent->val_nr - idx_local;
 	parent->val_nr = idx_local;
 
@@ -249,6 +256,7 @@ split_add_child(struct callchain_node *parent, struct ip_callchain *chain,
 	if (idx_total < chain->nr) {
 		parent->hit = 0;
 		add_child(parent, chain, idx_total, syms);
+		parent->children_hit++;
 	} else {
 		parent->hit = 1;
 	}
@@ -269,13 +277,13 @@ __append_chain_children(struct callchain_node *root, struct ip_callchain *chain,
 		unsigned int ret = __append_chain(rnode, chain, start, syms);
 
 		if (!ret)
-			goto cumul;
+			goto inc_children_hit;
 	}
 	/* nothing in children, add to the current node */
 	add_child(root, chain, start, syms);
 
-cumul:
-	root->cumul_hit++;
+inc_children_hit:
+	root->children_hit++;
 }
 
 static int
@@ -317,8 +325,6 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 	/* we match 100% of the path, increment the hit */
 	if (i - start == root->val_nr && i == chain->nr) {
 		root->hit++;
-		root->cumul_hit++;
-
 		return 0;
 	}
 
@@ -331,5 +337,7 @@ __append_chain(struct callchain_node *root, struct ip_callchain *chain,
 void append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		  struct symbol **syms)
 {
+	if (!chain->nr)
+		return;
 	__append_chain_children(root, chain, syms, 0);
 }
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 7812122..a926ae4 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -7,6 +7,7 @@
 #include "symbol.h"
 
 enum chain_mode {
+	CHAIN_NONE,
 	CHAIN_FLAT,
 	CHAIN_GRAPH_ABS,
 	CHAIN_GRAPH_REL
@@ -21,7 +22,7 @@ struct callchain_node {
 	struct rb_root		rb_root; /* sorted tree of children */
 	unsigned int		val_nr;
 	u64			hit;
-	u64			cumul_hit; /* hit + hits of children */
+	u64			children_hit;
 };
 
 struct callchain_param;
@@ -48,6 +49,11 @@ static inline void callchain_init(struct callchain_node *node)
 	INIT_LIST_HEAD(&node->val);
 }
 
+static inline u64 cumul_hits(struct callchain_node *node)
+{
+	return node->hit + node->children_hit;
+}
+
 int register_callchain_param(struct callchain_param *param);
 void append_chain(struct callchain_node *root, struct ip_callchain *chain,
 		  struct symbol **syms);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 450384b..b92a457 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -185,6 +185,8 @@ static void do_read(int fd, void *buf, size_t size)
 
 		if (ret < 0)
 			die("failed to read");
+		if (ret == 0)
+			die("failed to read: missing data");
 
 		size -= ret;
 		buf += ret;
@@ -213,9 +215,10 @@ struct perf_header *perf_header__read(int fd)
 
 	for (i = 0; i < nr_attrs; i++) {
 		struct perf_header_attr *attr;
-		off_t tmp = lseek(fd, 0, SEEK_CUR);
+		off_t tmp;
 
 		do_read(fd, &f_attr, sizeof(f_attr));
+		tmp = lseek(fd, 0, SEEK_CUR);
 
 		attr = perf_header_attr__new(&f_attr.attr);
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 7bdad8d..4858d83 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -121,13 +121,29 @@ static unsigned long hw_cache_stat[C(MAX)] = {
 	   (strcmp(sys_dirent.d_name, ".")) &&				       \
 	   (strcmp(sys_dirent.d_name, "..")))
 
+static int tp_event_has_id(struct dirent *sys_dir, struct dirent *evt_dir)
+{
+	char evt_path[MAXPATHLEN];
+	int fd;
+
+	snprintf(evt_path, MAXPATHLEN, "%s/%s/%s/id", debugfs_path,
+			sys_dir->d_name, evt_dir->d_name);
+	fd = open(evt_path, O_RDONLY);
+	if (fd < 0)
+		return -EINVAL;
+	close(fd);
+
+	return 0;
+}
+
 #define for_each_event(sys_dirent, evt_dir, evt_dirent, evt_next, file, st)    \
 	while (!readdir_r(evt_dir, &evt_dirent, &evt_next) && evt_next)        \
 	if (snprintf(file, MAXPATHLEN, "%s/%s/%s", debugfs_path,	       \
 		     sys_dirent.d_name, evt_dirent.d_name) &&		       \
 	   (!stat(file, &st)) && (S_ISDIR(st.st_mode)) &&		       \
 	   (strcmp(evt_dirent.d_name, ".")) &&				       \
-	   (strcmp(evt_dirent.d_name, "..")))
+	   (strcmp(evt_dirent.d_name, "..")) &&				       \
+	   (!tp_event_has_id(&sys_dirent, &evt_dirent)))
 
 #define MAX_EVENT_LENGTH 30
 
@@ -223,9 +239,15 @@ char *event_name(int counter)
 {
 	u64 config = attrs[counter].config;
 	int type = attrs[counter].type;
+
+	return __event_name(type, config);
+}
+
+char *__event_name(int type, u64 config)
+{
 	static char buf[32];
 
-	if (attrs[counter].type == PERF_TYPE_RAW) {
+	if (type == PERF_TYPE_RAW) {
 		sprintf(buf, "raw 0x%llx", config);
 		return buf;
 	}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 1ea5d09..192a962 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -10,6 +10,7 @@ extern int			nr_counters;
 extern struct perf_counter_attr attrs[MAX_COUNTERS];
 
 extern char *event_name(int ctr);
+extern char *__event_name(int type, u64 config);
 
 extern int parse_events(const struct option *opt, const char *str, int unset);
 
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 16ddca2..f1dcede 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -24,6 +24,16 @@ const char *sym_hist_filter;
 #define DMGL_ANSI        (1 << 1)       /* Include const, volatile, etc */
 #endif
 
+enum dso_origin {
+	DSO__ORIG_KERNEL = 0,
+	DSO__ORIG_JAVA_JIT,
+	DSO__ORIG_FEDORA,
+	DSO__ORIG_UBUNTU,
+	DSO__ORIG_BUILDID,
+	DSO__ORIG_DSO,
+	DSO__ORIG_NOT_FOUND,
+};
+
 static struct symbol *symbol__new(u64 start, u64 len,
 				  const char *name, unsigned int priv_size,
 				  u64 obj_start, int verbose)
@@ -81,6 +91,7 @@ struct dso *dso__new(const char *name, unsigned int sym_priv_size)
 		self->sym_priv_size = sym_priv_size;
 		self->find_symbol = dso__find_symbol;
 		self->slen_calculated = 0;
+		self->origin = DSO__ORIG_NOT_FOUND;
 	}
 
 	return self;
@@ -710,7 +721,7 @@ static char *dso__read_build_id(struct dso *self, int verbose)
 		++raw;
 		bid += 2;
 	}
-	if (verbose)
+	if (verbose >= 2)
 		printf("%s(%s): %s\n", __func__, self->name, build_id);
 out_elf_end:
 	elf_end(elf);
@@ -720,11 +731,26 @@ out:
 	return build_id;
 }
 
+char dso__symtab_origin(const struct dso *self)
+{
+	static const char origin[] = {
+		[DSO__ORIG_KERNEL] =   'k',
+		[DSO__ORIG_JAVA_JIT] = 'j',
+		[DSO__ORIG_FEDORA] =   'f',
+		[DSO__ORIG_UBUNTU] =   'u',
+		[DSO__ORIG_BUILDID] =  'b',
+		[DSO__ORIG_DSO] =      'd',
+	};
+
+	if (self == NULL || self->origin == DSO__ORIG_NOT_FOUND)
+		return '!';
+	return origin[self->origin];
+}
+
 int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 {
 	int size = PATH_MAX;
 	char *name = malloc(size), *build_id = NULL;
-	int variant = 0;
 	int ret = -1;
 	int fd;
 
@@ -733,19 +759,26 @@ int dso__load(struct dso *self, symbol_filter_t filter, int verbose)
 
 	self->adjust_symbols = 0;
 
-	if (strncmp(self->name, "/tmp/perf-", 10) == 0)
-		return dso__load_perf_map(self, filter, verbose);
+	if (strncmp(self->name, "/tmp/perf-", 10) == 0) {
+		ret = dso__load_perf_map(self, filter, verbose);
+		self->origin = ret > 0 ? DSO__ORIG_JAVA_JIT :
+					 DSO__ORIG_NOT_FOUND;
+		return ret;
+	}
+
+	self->origin = DSO__ORIG_FEDORA - 1;
 
 more:
 	do {
-		switch (variant) {
-		case 0: /* Fedora */
+		self->origin++;
+		switch (self->origin) {
+		case DSO__ORIG_FEDORA:
 			snprintf(name, size, "/usr/lib/debug%s.debug", self->name);
 			break;
-		case 1: /* Ubuntu */
+		case DSO__ORIG_UBUNTU:
 			snprintf(name, size, "/usr/lib/debug%s", self->name);
 			break;
-		case 2:
+		case DSO__ORIG_BUILDID:
 			build_id = dso__read_build_id(self, verbose);
 			if (build_id != NULL) {
 				snprintf(name, size,
@@ -754,16 +787,15 @@ more:
 				free(build_id);
 				break;
 			}
-			variant++;
+			self->origin++;
 			/* Fall thru */
-		case 3: /* Sane people */
+		case DSO__ORIG_DSO:
 			snprintf(name, size, "%s", self->name);
 			break;
 
 		default:
 			goto out;
 		}
-		variant++;
 
 		fd = open(name, O_RDONLY);
 	} while (fd < 0);
@@ -899,6 +931,9 @@ int dso__load_kernel(struct dso *self, const char *vmlinux,
 	if (err <= 0)
 		err = dso__load_kallsyms(self, filter, verbose);
 
+	if (err > 0)
+		self->origin = DSO__ORIG_KERNEL;
+
 	return err;
 }
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 2f92b21..1e003ec 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -26,6 +26,7 @@ struct dso {
 	unsigned int	 sym_priv_size;
 	unsigned char	 adjust_symbols;
 	unsigned char	 slen_calculated;
+	unsigned char	 origin;
 	char		 name[0];
 };
 
@@ -49,6 +50,7 @@ int dso__load_modules(struct dso *self, symbol_filter_t filter, int verbose);
 int dso__load(struct dso *self, symbol_filter_t filter, int verbose);
 
 size_t dso__fprintf(struct dso *self, FILE *fp);
+char dso__symtab_origin(const struct dso *self);
 
 void symbol__init(void);
 #endif /* _PERF_SYMBOL_ */
