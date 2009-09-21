Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbZIUMxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbZIUMxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 08:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756000AbZIUMxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 08:53:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:54222 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999AbZIUMxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 08:53:03 -0400
Date: Mon, 21 Sep 2009 12:52:34 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perfcounters/rename] perf_counter: Rename 'event' to event_id/hw_event
Message-ID: <tip-dfc65094d0313cc48969fa60bcf33d693aeb05a7@git.kernel.org>
Git-Commit-ID: dfc65094d0313cc48969fa60bcf33d693aeb05a7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 21 Sep 2009 12:52:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfc65094d0313cc48969fa60bcf33d693aeb05a7
Gitweb:     http://git.kernel.org/tip/dfc65094d0313cc48969fa60bcf33d693aeb05a7
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Mon, 21 Sep 2009 11:31:35 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 21 Sep 2009 12:54:59 +0200

perf_counter: Rename 'event' to event_id/hw_event

In preparation to the renames, to avoid a namespace clash.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/perf_counter.c |   48 ++++++++++++++++++------------------
 kernel/perf_counter.c              |   26 +++++++++---------
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index a6c8b27..b1f1156 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -124,9 +124,9 @@ static const u64 p6_perfmon_event_map[] =
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,
 };
 
-static u64 p6_pmu_event_map(int event)
+static u64 p6_pmu_event_map(int hw_event)
 {
-	return p6_perfmon_event_map[event];
+	return p6_perfmon_event_map[hw_event];
 }
 
 /*
@@ -137,7 +137,7 @@ static u64 p6_pmu_event_map(int event)
  */
 #define P6_NOP_COUNTER			0x0000002EULL
 
-static u64 p6_pmu_raw_event(u64 event)
+static u64 p6_pmu_raw_event(u64 hw_event)
 {
 #define P6_EVNTSEL_EVENT_MASK		0x000000FFULL
 #define P6_EVNTSEL_UNIT_MASK		0x0000FF00ULL
@@ -152,7 +152,7 @@ static u64 p6_pmu_raw_event(u64 event)
 	 P6_EVNTSEL_INV_MASK   |	\
 	 P6_EVNTSEL_COUNTER_MASK)
 
-	return event & P6_EVNTSEL_MASK;
+	return hw_event & P6_EVNTSEL_MASK;
 }
 
 
@@ -170,16 +170,16 @@ static const u64 intel_perfmon_event_map[] =
   [PERF_COUNT_HW_BUS_CYCLES]		= 0x013c,
 };
 
-static u64 intel_pmu_event_map(int event)
+static u64 intel_pmu_event_map(int hw_event)
 {
-	return intel_perfmon_event_map[event];
+	return intel_perfmon_event_map[hw_event];
 }
 
 /*
- * Generalized hw caching related event table, filled
+ * Generalized hw caching related hw_event table, filled
  * in on a per model basis. A value of 0 means
- * 'not supported', -1 means 'event makes no sense on
- * this CPU', any other value means the raw event
+ * 'not supported', -1 means 'hw_event makes no sense on
+ * this CPU', any other value means the raw hw_event
  * ID.
  */
 
@@ -463,7 +463,7 @@ static const u64 atom_hw_cache_event_ids
  },
 };
 
-static u64 intel_pmu_raw_event(u64 event)
+static u64 intel_pmu_raw_event(u64 hw_event)
 {
 #define CORE_EVNTSEL_EVENT_MASK		0x000000FFULL
 #define CORE_EVNTSEL_UNIT_MASK		0x0000FF00ULL
@@ -478,7 +478,7 @@ static u64 intel_pmu_raw_event(u64 event)
 	 CORE_EVNTSEL_INV_MASK  |	\
 	 CORE_EVNTSEL_COUNTER_MASK)
 
-	return event & CORE_EVNTSEL_MASK;
+	return hw_event & CORE_EVNTSEL_MASK;
 }
 
 static const u64 amd_hw_cache_event_ids
@@ -585,12 +585,12 @@ static const u64 amd_perfmon_event_map[] =
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
 };
 
-static u64 amd_pmu_event_map(int event)
+static u64 amd_pmu_event_map(int hw_event)
 {
-	return amd_perfmon_event_map[event];
+	return amd_perfmon_event_map[hw_event];
 }
 
-static u64 amd_pmu_raw_event(u64 event)
+static u64 amd_pmu_raw_event(u64 hw_event)
 {
 #define K7_EVNTSEL_EVENT_MASK	0x7000000FFULL
 #define K7_EVNTSEL_UNIT_MASK	0x00000FF00ULL
@@ -605,7 +605,7 @@ static u64 amd_pmu_raw_event(u64 event)
 	 K7_EVNTSEL_INV_MASK   |	\
 	 K7_EVNTSEL_COUNTER_MASK)
 
-	return event & K7_EVNTSEL_MASK;
+	return hw_event & K7_EVNTSEL_MASK;
 }
 
 /*
@@ -956,7 +956,7 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	}
 
 	/*
-	 * Raw event type provide the config in the event structure
+	 * Raw hw_event type provide the config in the hw_event structure
 	 */
 	if (attr->type == PERF_TYPE_RAW) {
 		hwc->config |= x86_pmu.raw_event(attr->config);
@@ -1245,7 +1245,7 @@ x86_perf_counter_set_period(struct perf_counter *counter,
 		ret = 1;
 	}
 	/*
-	 * Quirk: certain CPUs dont like it if just 1 event is left:
+	 * Quirk: certain CPUs dont like it if just 1 hw_event is left:
 	 */
 	if (unlikely(left < 2))
 		left = 2;
@@ -1337,11 +1337,11 @@ static void amd_pmu_enable_counter(struct hw_perf_counter *hwc, int idx)
 static int
 fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 {
-	unsigned int event;
+	unsigned int hw_event;
 
-	event = hwc->config & ARCH_PERFMON_EVENT_MASK;
+	hw_event = hwc->config & ARCH_PERFMON_EVENT_MASK;
 
-	if (unlikely((event ==
+	if (unlikely((hw_event ==
 		      x86_pmu.event_map(PERF_COUNT_HW_BRANCH_INSTRUCTIONS)) &&
 		     (hwc->sample_period == 1)))
 		return X86_PMC_IDX_FIXED_BTS;
@@ -1349,11 +1349,11 @@ fixed_mode_idx(struct perf_counter *counter, struct hw_perf_counter *hwc)
 	if (!x86_pmu.num_counters_fixed)
 		return -1;
 
-	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_INSTRUCTIONS)))
+	if (unlikely(hw_event == x86_pmu.event_map(PERF_COUNT_HW_INSTRUCTIONS)))
 		return X86_PMC_IDX_FIXED_INSTRUCTIONS;
-	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_CPU_CYCLES)))
+	if (unlikely(hw_event == x86_pmu.event_map(PERF_COUNT_HW_CPU_CYCLES)))
 		return X86_PMC_IDX_FIXED_CPU_CYCLES;
-	if (unlikely(event == x86_pmu.event_map(PERF_COUNT_HW_BUS_CYCLES)))
+	if (unlikely(hw_event == x86_pmu.event_map(PERF_COUNT_HW_BUS_CYCLES)))
 		return X86_PMC_IDX_FIXED_BUS_CYCLES;
 
 	return -1;
@@ -1970,7 +1970,7 @@ static int intel_pmu_init(void)
 
 	/*
 	 * Check whether the Architectural PerfMon supports
-	 * Branch Misses Retired Event or not.
+	 * Branch Misses Retired hw_event or not.
 	 */
 	cpuid(10, &eax.full, &ebx, &unused, &edx.full);
 	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index 13ad73a..62de0db 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -3044,22 +3044,22 @@ perf_counter_read_event(struct perf_counter *counter,
 			struct task_struct *task)
 {
 	struct perf_output_handle handle;
-	struct perf_read_event event = {
+	struct perf_read_event read_event = {
 		.header = {
 			.type = PERF_EVENT_READ,
 			.misc = 0,
-			.size = sizeof(event) + perf_counter_read_size(counter),
+			.size = sizeof(read_event) + perf_counter_read_size(counter),
 		},
 		.pid = perf_counter_pid(counter, task),
 		.tid = perf_counter_tid(counter, task),
 	};
 	int ret;
 
-	ret = perf_output_begin(&handle, counter, event.header.size, 0, 0);
+	ret = perf_output_begin(&handle, counter, read_event.header.size, 0, 0);
 	if (ret)
 		return;
 
-	perf_output_put(&handle, event);
+	perf_output_put(&handle, read_event);
 	perf_output_read(&handle, counter);
 
 	perf_output_end(&handle);
@@ -3698,14 +3698,14 @@ static int perf_swcounter_is_counting(struct perf_counter *counter)
 
 static int perf_swcounter_match(struct perf_counter *counter,
 				enum perf_type_id type,
-				u32 event, struct pt_regs *regs)
+				u32 event_id, struct pt_regs *regs)
 {
 	if (!perf_swcounter_is_counting(counter))
 		return 0;
 
 	if (counter->attr.type != type)
 		return 0;
-	if (counter->attr.config != event)
+	if (counter->attr.config != event_id)
 		return 0;
 
 	if (regs) {
@@ -3721,7 +3721,7 @@ static int perf_swcounter_match(struct perf_counter *counter,
 
 static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 				     enum perf_type_id type,
-				     u32 event, u64 nr, int nmi,
+				     u32 event_id, u64 nr, int nmi,
 				     struct perf_sample_data *data,
 				     struct pt_regs *regs)
 {
@@ -3732,7 +3732,7 @@ static void perf_swcounter_ctx_event(struct perf_counter_context *ctx,
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(counter, &ctx->event_list, event_entry) {
-		if (perf_swcounter_match(counter, type, event, regs))
+		if (perf_swcounter_match(counter, type, event_id, regs))
 			perf_swcounter_add(counter, nr, nmi, data, regs);
 	}
 	rcu_read_unlock();
@@ -4036,17 +4036,17 @@ atomic_t perf_swcounter_enabled[PERF_COUNT_SW_MAX];
 
 static void sw_perf_counter_destroy(struct perf_counter *counter)
 {
-	u64 event = counter->attr.config;
+	u64 event_id = counter->attr.config;
 
 	WARN_ON(counter->parent);
 
-	atomic_dec(&perf_swcounter_enabled[event]);
+	atomic_dec(&perf_swcounter_enabled[event_id]);
 }
 
 static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 {
 	const struct pmu *pmu = NULL;
-	u64 event = counter->attr.config;
+	u64 event_id = counter->attr.config;
 
 	/*
 	 * Software counters (currently) can't in general distinguish
@@ -4055,7 +4055,7 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	 * to be kernel events, and page faults are never hypervisor
 	 * events.
 	 */
-	switch (event) {
+	switch (event_id) {
 	case PERF_COUNT_SW_CPU_CLOCK:
 		pmu = &perf_ops_cpu_clock;
 
@@ -4077,7 +4077,7 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	case PERF_COUNT_SW_CONTEXT_SWITCHES:
 	case PERF_COUNT_SW_CPU_MIGRATIONS:
 		if (!counter->parent) {
-			atomic_inc(&perf_swcounter_enabled[event]);
+			atomic_inc(&perf_swcounter_enabled[event_id]);
 			counter->destroy = sw_perf_counter_destroy;
 		}
 		pmu = &perf_ops_generic;
