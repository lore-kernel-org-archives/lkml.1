Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbZFBUSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbZFBUSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 16:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbZFBURz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 16:17:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:39516 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754867AbZFBURt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 16:17:49 -0400
Date: Tue, 2 Jun 2009 20:17:15 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, eranian@googlemail.com,
       jkacur@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       mtosatti@redhat.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, eranian@googlemail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, mtosatti@redhat.com,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
Subject: [tip:perfcounters/core] perf_counter: Rename perf_counter_hw_event => perf_counter_attr
Message-ID: <tip-0d48696f87e3618b0d35bd3e4e9d7c188d51e7de@git.kernel.org>
Git-Commit-ID: 0d48696f87e3618b0d35bd3e4e9d7c188d51e7de
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Jun 2009 20:17:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d48696f87e3618b0d35bd3e4e9d7c188d51e7de
Gitweb:     http://git.kernel.org/tip/0d48696f87e3618b0d35bd3e4e9d7c188d51e7de
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 2 Jun 2009 19:22:16 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 2 Jun 2009 21:45:33 +0200

perf_counter: Rename perf_counter_hw_event => perf_counter_attr

The structure isn't hw only and when I read event, I think about those
things that fall out the other end. Rename the thing.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Kacur <jkacur@redhat.com>
Cc: Stephane Eranian <eranian@googlemail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/powerpc/kernel/perf_counter.c |   38 ++++++------
 arch/x86/kernel/cpu/perf_counter.c |   16 +++---
 include/linux/perf_counter.h       |   34 +++++-----
 include/linux/syscalls.h           |    4 +-
 kernel/perf_counter.c              |  116 ++++++++++++++++++------------------
 5 files changed, 104 insertions(+), 104 deletions(-)

diff --git a/arch/powerpc/kernel/perf_counter.c b/arch/powerpc/kernel/perf_counter.c
index c963332..ea54686 100644
--- a/arch/powerpc/kernel/perf_counter.c
+++ b/arch/powerpc/kernel/perf_counter.c
@@ -262,13 +262,13 @@ static int check_excludes(struct perf_counter **ctrs, unsigned int cflags[],
 		}
 		counter = ctrs[i];
 		if (first) {
-			eu = counter->hw_event.exclude_user;
-			ek = counter->hw_event.exclude_kernel;
-			eh = counter->hw_event.exclude_hv;
+			eu = counter->attr.exclude_user;
+			ek = counter->attr.exclude_kernel;
+			eh = counter->attr.exclude_hv;
 			first = 0;
-		} else if (counter->hw_event.exclude_user != eu ||
-			   counter->hw_event.exclude_kernel != ek ||
-			   counter->hw_event.exclude_hv != eh) {
+		} else if (counter->attr.exclude_user != eu ||
+			   counter->attr.exclude_kernel != ek ||
+			   counter->attr.exclude_hv != eh) {
 			return -EAGAIN;
 		}
 	}
@@ -483,16 +483,16 @@ void hw_perf_enable(void)
 
 	/*
 	 * Add in MMCR0 freeze bits corresponding to the
-	 * hw_event.exclude_* bits for the first counter.
+	 * attr.exclude_* bits for the first counter.
 	 * We have already checked that all counters have the
 	 * same values for these bits as the first counter.
 	 */
 	counter = cpuhw->counter[0];
-	if (counter->hw_event.exclude_user)
+	if (counter->attr.exclude_user)
 		cpuhw->mmcr[0] |= MMCR0_FCP;
-	if (counter->hw_event.exclude_kernel)
+	if (counter->attr.exclude_kernel)
 		cpuhw->mmcr[0] |= freeze_counters_kernel;
-	if (counter->hw_event.exclude_hv)
+	if (counter->attr.exclude_hv)
 		cpuhw->mmcr[0] |= MMCR0_FCHV;
 
 	/*
@@ -786,10 +786,10 @@ static int can_go_on_limited_pmc(struct perf_counter *counter, u64 ev,
 	int n;
 	u64 alt[MAX_EVENT_ALTERNATIVES];
 
-	if (counter->hw_event.exclude_user
-	    || counter->hw_event.exclude_kernel
-	    || counter->hw_event.exclude_hv
-	    || counter->hw_event.sample_period)
+	if (counter->attr.exclude_user
+	    || counter->attr.exclude_kernel
+	    || counter->attr.exclude_hv
+	    || counter->attr.sample_period)
 		return 0;
 
 	if (ppmu->limited_pmc_event(ev))
@@ -855,13 +855,13 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 
 	if (!ppmu)
 		return ERR_PTR(-ENXIO);
-	if (!perf_event_raw(&counter->hw_event)) {
-		ev = perf_event_id(&counter->hw_event);
+	if (!perf_event_raw(&counter->attr)) {
+		ev = perf_event_id(&counter->attr);
 		if (ev >= ppmu->n_generic || ppmu->generic_events[ev] == 0)
 			return ERR_PTR(-EOPNOTSUPP);
 		ev = ppmu->generic_events[ev];
 	} else {
-		ev = perf_event_config(&counter->hw_event);
+		ev = perf_event_config(&counter->attr);
 	}
 	counter->hw.config_base = ev;
 	counter->hw.idx = 0;
@@ -872,7 +872,7 @@ const struct pmu *hw_perf_counter_init(struct perf_counter *counter)
 	 * the user set it to.
 	 */
 	if (!firmware_has_feature(FW_FEATURE_LPAR))
-		counter->hw_event.exclude_hv = 0;
+		counter->attr.exclude_hv = 0;
 
 	/*
 	 * If this is a per-task counter, then we can use
@@ -990,7 +990,7 @@ static void record_and_restart(struct perf_counter *counter, long val,
 	 */
 	if (record) {
 		addr = 0;
-		if (counter->hw_event.record_type & PERF_RECORD_ADDR) {
+		if (counter->attr.record_type & PERF_RECORD_ADDR) {
 			/*
 			 * The user wants a data address recorded.
 			 * If we're not doing instruction sampling,
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 904571b..e16e8c1 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -247,11 +247,11 @@ static inline int x86_pmu_initialized(void)
 }
 
 /*
- * Setup the hardware configuration for a given hw_event_type
+ * Setup the hardware configuration for a given attr_type
  */
 static int __hw_perf_counter_init(struct perf_counter *counter)
 {
-	struct perf_counter_hw_event *hw_event = &counter->hw_event;
+	struct perf_counter_attr *attr = &counter->attr;
 	struct hw_perf_counter *hwc = &counter->hw;
 	int err;
 
@@ -279,9 +279,9 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	/*
 	 * Count user and OS events unless requested not to.
 	 */
-	if (!hw_event->exclude_user)
+	if (!attr->exclude_user)
 		hwc->config |= ARCH_PERFMON_EVENTSEL_USR;
-	if (!hw_event->exclude_kernel)
+	if (!attr->exclude_kernel)
 		hwc->config |= ARCH_PERFMON_EVENTSEL_OS;
 
 	if (!hwc->sample_period)
@@ -292,15 +292,15 @@ static int __hw_perf_counter_init(struct perf_counter *counter)
 	/*
 	 * Raw event type provide the config in the event structure
 	 */
-	if (perf_event_raw(hw_event)) {
-		hwc->config |= x86_pmu.raw_event(perf_event_config(hw_event));
+	if (perf_event_raw(attr)) {
+		hwc->config |= x86_pmu.raw_event(perf_event_config(attr));
 	} else {
-		if (perf_event_id(hw_event) >= x86_pmu.max_events)
+		if (perf_event_id(attr) >= x86_pmu.max_events)
 			return -EINVAL;
 		/*
 		 * The generic map:
 		 */
-		hwc->config |= x86_pmu.event_map(perf_event_id(hw_event));
+		hwc->config |= x86_pmu.event_map(perf_event_id(attr));
 	}
 
 	counter->destroy = hw_perf_counter_destroy;
diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 45bdd3b..37d5541 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -22,7 +22,7 @@
  */
 
 /*
- * hw_event.type
+ * attr.type
  */
 enum perf_event_types {
 	PERF_TYPE_HARDWARE		= 0,
@@ -37,10 +37,10 @@ enum perf_event_types {
 };
 
 /*
- * Generalized performance counter event types, used by the hw_event.event_id
+ * Generalized performance counter event types, used by the attr.event_id
  * parameter of the sys_perf_counter_open() syscall:
  */
-enum hw_event_ids {
+enum attr_ids {
 	/*
 	 * Common hardware events, generalized by the kernel:
 	 */
@@ -94,7 +94,7 @@ enum sw_event_ids {
 #define PERF_COUNTER_EVENT_MASK		__PERF_COUNTER_MASK(EVENT)
 
 /*
- * Bits that can be set in hw_event.sample_type to request information
+ * Bits that can be set in attr.sample_type to request information
  * in the overflow packets.
  */
 enum perf_counter_sample_format {
@@ -109,7 +109,7 @@ enum perf_counter_sample_format {
 };
 
 /*
- * Bits that can be set in hw_event.read_format to request that
+ * Bits that can be set in attr.read_format to request that
  * reads on the counter should return the indicated quantities,
  * in increasing order of bit value, after the counter value.
  */
@@ -122,7 +122,7 @@ enum perf_counter_read_format {
 /*
  * Hardware event to monitor via a performance monitoring counter:
  */
-struct perf_counter_hw_event {
+struct perf_counter_attr {
 	/*
 	 * The MSB of the config word signifies if the rest contains cpu
 	 * specific (raw) counter configuration data, if unset, the next
@@ -323,25 +323,25 @@ enum perf_event_type {
 
 struct task_struct;
 
-static inline u64 perf_event_raw(struct perf_counter_hw_event *hw_event)
+static inline u64 perf_event_raw(struct perf_counter_attr *attr)
 {
-	return hw_event->config & PERF_COUNTER_RAW_MASK;
+	return attr->config & PERF_COUNTER_RAW_MASK;
 }
 
-static inline u64 perf_event_config(struct perf_counter_hw_event *hw_event)
+static inline u64 perf_event_config(struct perf_counter_attr *attr)
 {
-	return hw_event->config & PERF_COUNTER_CONFIG_MASK;
+	return attr->config & PERF_COUNTER_CONFIG_MASK;
 }
 
-static inline u64 perf_event_type(struct perf_counter_hw_event *hw_event)
+static inline u64 perf_event_type(struct perf_counter_attr *attr)
 {
-	return (hw_event->config & PERF_COUNTER_TYPE_MASK) >>
+	return (attr->config & PERF_COUNTER_TYPE_MASK) >>
 		PERF_COUNTER_TYPE_SHIFT;
 }
 
-static inline u64 perf_event_id(struct perf_counter_hw_event *hw_event)
+static inline u64 perf_event_id(struct perf_counter_attr *attr)
 {
-	return hw_event->config & PERF_COUNTER_EVENT_MASK;
+	return attr->config & PERF_COUNTER_EVENT_MASK;
 }
 
 /**
@@ -457,7 +457,7 @@ struct perf_counter {
 	u64				tstamp_running;
 	u64				tstamp_stopped;
 
-	struct perf_counter_hw_event	hw_event;
+	struct perf_counter_attr	attr;
 	struct hw_perf_counter		hw;
 
 	struct perf_counter_context	*ctx;
@@ -605,8 +605,8 @@ extern int perf_counter_overflow(struct perf_counter *counter,
  */
 static inline int is_software_counter(struct perf_counter *counter)
 {
-	return !perf_event_raw(&counter->hw_event) &&
-		perf_event_type(&counter->hw_event) != PERF_TYPE_HARDWARE;
+	return !perf_event_raw(&counter->attr) &&
+		perf_event_type(&counter->attr) != PERF_TYPE_HARDWARE;
 }
 
 extern void perf_swcounter_event(u32, u64, int, struct pt_regs *, u64);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 79faae9..c6c84ad 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -55,7 +55,7 @@ struct compat_timeval;
 struct robust_list_head;
 struct getcpu_cache;
 struct old_linux_dirent;
-struct perf_counter_hw_event;
+struct perf_counter_attr;
 
 #include <linux/types.h>
 #include <linux/aio_abi.h>
@@ -758,6 +758,6 @@ int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
 
 asmlinkage long sys_perf_counter_open(
-		const struct perf_counter_hw_event __user *hw_event_uptr,
+		const struct perf_counter_attr __user *attr_uptr,
 		pid_t pid, int cpu, int group_fd, unsigned long flags);
 #endif
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index abe2f3b..317cef7 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -260,7 +260,7 @@ counter_sched_out(struct perf_counter *counter,
 	if (!is_software_counter(counter))
 		cpuctx->active_oncpu--;
 	ctx->nr_active--;
-	if (counter->hw_event.exclusive || !cpuctx->active_oncpu)
+	if (counter->attr.exclusive || !cpuctx->active_oncpu)
 		cpuctx->exclusive = 0;
 }
 
@@ -282,7 +282,7 @@ group_sched_out(struct perf_counter *group_counter,
 	list_for_each_entry(counter, &group_counter->sibling_list, list_entry)
 		counter_sched_out(counter, cpuctx, ctx);
 
-	if (group_counter->hw_event.exclusive)
+	if (group_counter->attr.exclusive)
 		cpuctx->exclusive = 0;
 }
 
@@ -550,7 +550,7 @@ counter_sched_in(struct perf_counter *counter,
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
 
-	if (counter->hw_event.exclusive)
+	if (counter->attr.exclusive)
 		cpuctx->exclusive = 1;
 
 	return 0;
@@ -642,7 +642,7 @@ static int group_can_go_on(struct perf_counter *counter,
 	 * If this group is exclusive and there are already
 	 * counters on the CPU, it can't go on.
 	 */
-	if (counter->hw_event.exclusive && cpuctx->active_oncpu)
+	if (counter->attr.exclusive && cpuctx->active_oncpu)
 		return 0;
 	/*
 	 * Otherwise, try to add it if all previous groups were able
@@ -725,7 +725,7 @@ static void __perf_install_in_context(void *info)
 		 */
 		if (leader != counter)
 			group_sched_out(leader, cpuctx, ctx);
-		if (leader->hw_event.pinned) {
+		if (leader->attr.pinned) {
 			update_group_times(leader);
 			leader->state = PERF_COUNTER_STATE_ERROR;
 		}
@@ -849,7 +849,7 @@ static void __perf_counter_enable(void *info)
 		 */
 		if (leader != counter)
 			group_sched_out(leader, cpuctx, ctx);
-		if (leader->hw_event.pinned) {
+		if (leader->attr.pinned) {
 			update_group_times(leader);
 			leader->state = PERF_COUNTER_STATE_ERROR;
 		}
@@ -927,7 +927,7 @@ static int perf_counter_refresh(struct perf_counter *counter, int refresh)
 	/*
 	 * not supported on inherited counters
 	 */
-	if (counter->hw_event.inherit)
+	if (counter->attr.inherit)
 		return -EINVAL;
 
 	atomic_add(refresh, &counter->event_limit);
@@ -1094,7 +1094,7 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 	 */
 	list_for_each_entry(counter, &ctx->counter_list, list_entry) {
 		if (counter->state <= PERF_COUNTER_STATE_OFF ||
-		    !counter->hw_event.pinned)
+		    !counter->attr.pinned)
 			continue;
 		if (counter->cpu != -1 && counter->cpu != cpu)
 			continue;
@@ -1122,7 +1122,7 @@ __perf_counter_sched_in(struct perf_counter_context *ctx,
 		 * ignore pinned counters since we did them already.
 		 */
 		if (counter->state <= PERF_COUNTER_STATE_OFF ||
-		    counter->hw_event.pinned)
+		    counter->attr.pinned)
 			continue;
 
 		/*
@@ -1204,11 +1204,11 @@ static void perf_adjust_freq(struct perf_counter_context *ctx)
 			interrupts = 2*sysctl_perf_counter_limit/HZ;
 		}
 
-		if (!counter->hw_event.freq || !counter->hw_event.sample_freq)
+		if (!counter->attr.freq || !counter->attr.sample_freq)
 			continue;
 
 		events = HZ * interrupts * counter->hw.sample_period;
-		period = div64_u64(events, counter->hw_event.sample_freq);
+		period = div64_u64(events, counter->attr.sample_freq);
 
 		delta = (s64)(1 + period - counter->hw.sample_period);
 		delta >>= 1;
@@ -1444,11 +1444,11 @@ static void free_counter(struct perf_counter *counter)
 	perf_pending_sync(counter);
 
 	atomic_dec(&nr_counters);
-	if (counter->hw_event.mmap)
+	if (counter->attr.mmap)
 		atomic_dec(&nr_mmap_tracking);
-	if (counter->hw_event.munmap)
+	if (counter->attr.munmap)
 		atomic_dec(&nr_munmap_tracking);
-	if (counter->hw_event.comm)
+	if (counter->attr.comm)
 		atomic_dec(&nr_comm_tracking);
 
 	if (counter->destroy)
@@ -1504,13 +1504,13 @@ perf_read_hw(struct perf_counter *counter, char __user *buf, size_t count)
 	mutex_lock(&counter->child_mutex);
 	values[0] = perf_counter_read(counter);
 	n = 1;
-	if (counter->hw_event.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
+	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_ENABLED)
 		values[n++] = counter->total_time_enabled +
 			atomic64_read(&counter->child_total_time_enabled);
-	if (counter->hw_event.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
+	if (counter->attr.read_format & PERF_FORMAT_TOTAL_TIME_RUNNING)
 		values[n++] = counter->total_time_running +
 			atomic64_read(&counter->child_total_time_running);
-	if (counter->hw_event.read_format & PERF_FORMAT_ID)
+	if (counter->attr.read_format & PERF_FORMAT_ID)
 		values[n++] = counter->id;
 	mutex_unlock(&counter->child_mutex);
 
@@ -1611,7 +1611,7 @@ static int perf_counter_period(struct perf_counter *counter, u64 __user *arg)
 	int ret = 0;
 	u64 value;
 
-	if (!counter->hw_event.sample_period)
+	if (!counter->attr.sample_period)
 		return -EINVAL;
 
 	size = copy_from_user(&value, arg, sizeof(value));
@@ -1622,15 +1622,15 @@ static int perf_counter_period(struct perf_counter *counter, u64 __user *arg)
 		return -EINVAL;
 
 	spin_lock_irq(&ctx->lock);
-	if (counter->hw_event.freq) {
+	if (counter->attr.freq) {
 		if (value > sysctl_perf_counter_limit) {
 			ret = -EINVAL;
 			goto unlock;
 		}
 
-		counter->hw_event.sample_freq = value;
+		counter->attr.sample_freq = value;
 	} else {
-		counter->hw_event.sample_period = value;
+		counter->attr.sample_period = value;
 		counter->hw.sample_period = value;
 
 		perf_log_period(counter, value);
@@ -2299,7 +2299,7 @@ static void perf_output_end(struct perf_output_handle *handle)
 	struct perf_counter *counter = handle->counter;
 	struct perf_mmap_data *data = handle->data;
 
-	int wakeup_events = counter->hw_event.wakeup_events;
+	int wakeup_events = counter->attr.wakeup_events;
 
 	if (handle->overflow && wakeup_events) {
 		int events = atomic_inc_return(&data->events);
@@ -2339,7 +2339,7 @@ static void perf_counter_output(struct perf_counter *counter,
 				int nmi, struct pt_regs *regs, u64 addr)
 {
 	int ret;
-	u64 sample_type = counter->hw_event.sample_type;
+	u64 sample_type = counter->attr.sample_type;
 	struct perf_output_handle handle;
 	struct perf_event_header header;
 	u64 ip;
@@ -2441,7 +2441,7 @@ static void perf_counter_output(struct perf_counter *counter,
 		perf_output_put(&handle, addr);
 
 	if (sample_type & PERF_SAMPLE_CONFIG)
-		perf_output_put(&handle, counter->hw_event.config);
+		perf_output_put(&handle, counter->attr.config);
 
 	if (sample_type & PERF_SAMPLE_CPU)
 		perf_output_put(&handle, cpu_entry);
@@ -2512,7 +2512,7 @@ static void perf_counter_comm_output(struct perf_counter *counter,
 static int perf_counter_comm_match(struct perf_counter *counter,
 				   struct perf_comm_event *comm_event)
 {
-	if (counter->hw_event.comm &&
+	if (counter->attr.comm &&
 	    comm_event->event.header.type == PERF_EVENT_COMM)
 		return 1;
 
@@ -2623,11 +2623,11 @@ static void perf_counter_mmap_output(struct perf_counter *counter,
 static int perf_counter_mmap_match(struct perf_counter *counter,
 				   struct perf_mmap_event *mmap_event)
 {
-	if (counter->hw_event.mmap &&
+	if (counter->attr.mmap &&
 	    mmap_event->event.header.type == PERF_EVENT_MMAP)
 		return 1;
 
-	if (counter->hw_event.munmap &&
+	if (counter->attr.munmap &&
 	    mmap_event->event.header.type == PERF_EVENT_MUNMAP)
 		return 1;
 
@@ -2907,8 +2907,8 @@ static enum hrtimer_restart perf_swcounter_hrtimer(struct hrtimer *hrtimer)
 	 * In case we exclude kernel IPs or are somehow not in interrupt
 	 * context, provide the next best thing, the user IP.
 	 */
-	if ((counter->hw_event.exclude_kernel || !regs) &&
-			!counter->hw_event.exclude_user)
+	if ((counter->attr.exclude_kernel || !regs) &&
+			!counter->attr.exclude_user)
 		regs = task_pt_regs(current);
 
 	if (regs) {
@@ -2982,14 +2982,14 @@ static int perf_swcounter_match(struct perf_counter *counter,
 	if (!perf_swcounter_is_counting(counter))
 		return 0;
 
-	if (counter->hw_event.config != event_config)
+	if (counter->attr.config != event_config)
 		return 0;
 
 	if (regs) {
-		if (counter->hw_event.exclude_user && user_mode(regs))
+		if (counter->attr.exclude_user && user_mode(regs))
 			return 0;
 
-		if (counter->hw_event.exclude_kernel && !user_mode(regs))
+		if (counter->attr.exclude_kernel && !user_mode(regs))
 			return 0;
 	}
 
@@ -3252,12 +3252,12 @@ extern void ftrace_profile_disable(int);
 
 static void tp_perf_counter_destroy(struct perf_counter *counter)
 {
-	ftrace_profile_disable(perf_event_id(&counter->hw_event));
+	ftrace_profile_disable(perf_event_id(&counter->attr));
 }
 
 static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 {
-	int event_id = perf_event_id(&counter->hw_event);
+	int event_id = perf_event_id(&counter->attr);
 	int ret;
 
 	ret = ftrace_profile_enable(event_id);
@@ -3265,7 +3265,7 @@ static const struct pmu *tp_perf_counter_init(struct perf_counter *counter)
 		return NULL;
 
 	counter->destroy = tp_perf_counter_destroy;
-	counter->hw.sample_period = counter->hw_event.sample_period;
+	counter->hw.sample_period = counter->attr.sample_period;
 
 	return &perf_ops_generic;
 }
@@ -3287,7 +3287,7 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
 	 * to be kernel events, and page faults are never hypervisor
 	 * events.
 	 */
-	switch (perf_event_id(&counter->hw_event)) {
+	switch (perf_event_id(&counter->attr)) {
 	case PERF_COUNT_CPU_CLOCK:
 		pmu = &perf_ops_cpu_clock;
 
@@ -3319,7 +3319,7 @@ static const struct pmu *sw_perf_counter_init(struct perf_counter *counter)
  * Allocate and initialize a counter structure
  */
 static struct perf_counter *
-perf_counter_alloc(struct perf_counter_hw_event *hw_event,
+perf_counter_alloc(struct perf_counter_attr *attr,
 		   int cpu,
 		   struct perf_counter_context *ctx,
 		   struct perf_counter *group_leader,
@@ -3352,36 +3352,36 @@ perf_counter_alloc(struct perf_counter_hw_event *hw_event,
 	mutex_init(&counter->mmap_mutex);
 
 	counter->cpu			= cpu;
-	counter->hw_event		= *hw_event;
+	counter->attr		= *attr;
 	counter->group_leader		= group_leader;
 	counter->pmu			= NULL;
 	counter->ctx			= ctx;
 	counter->oncpu			= -1;
 
 	counter->state = PERF_COUNTER_STATE_INACTIVE;
-	if (hw_event->disabled)
+	if (attr->disabled)
 		counter->state = PERF_COUNTER_STATE_OFF;
 
 	pmu = NULL;
 
 	hwc = &counter->hw;
-	if (hw_event->freq && hw_event->sample_freq)
-		hwc->sample_period = div64_u64(TICK_NSEC, hw_event->sample_freq);
+	if (attr->freq && attr->sample_freq)
+		hwc->sample_period = div64_u64(TICK_NSEC, attr->sample_freq);
 	else
-		hwc->sample_period = hw_event->sample_period;
+		hwc->sample_period = attr->sample_period;
 
 	/*
 	 * we currently do not support PERF_SAMPLE_GROUP on inherited counters
 	 */
-	if (hw_event->inherit && (hw_event->sample_type & PERF_SAMPLE_GROUP))
+	if (attr->inherit && (attr->sample_type & PERF_SAMPLE_GROUP))
 		goto done;
 
-	if (perf_event_raw(hw_event)) {
+	if (perf_event_raw(attr)) {
 		pmu = hw_perf_counter_init(counter);
 		goto done;
 	}
 
-	switch (perf_event_type(hw_event)) {
+	switch (perf_event_type(attr)) {
 	case PERF_TYPE_HARDWARE:
 		pmu = hw_perf_counter_init(counter);
 		break;
@@ -3409,11 +3409,11 @@ done:
 	counter->pmu = pmu;
 
 	atomic_inc(&nr_counters);
-	if (counter->hw_event.mmap)
+	if (counter->attr.mmap)
 		atomic_inc(&nr_mmap_tracking);
-	if (counter->hw_event.munmap)
+	if (counter->attr.munmap)
 		atomic_inc(&nr_munmap_tracking);
-	if (counter->hw_event.comm)
+	if (counter->attr.comm)
 		atomic_inc(&nr_comm_tracking);
 
 	return counter;
@@ -3424,17 +3424,17 @@ static atomic64_t perf_counter_id;
 /**
  * sys_perf_counter_open - open a performance counter, associate it to a task/cpu
  *
- * @hw_event_uptr:	event type attributes for monitoring/sampling
+ * @attr_uptr:	event type attributes for monitoring/sampling
  * @pid:		target pid
  * @cpu:		target cpu
  * @group_fd:		group leader counter fd
  */
 SYSCALL_DEFINE5(perf_counter_open,
-		const struct perf_counter_hw_event __user *, hw_event_uptr,
+		const struct perf_counter_attr __user *, attr_uptr,
 		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
 {
 	struct perf_counter *counter, *group_leader;
-	struct perf_counter_hw_event hw_event;
+	struct perf_counter_attr attr;
 	struct perf_counter_context *ctx;
 	struct file *counter_file = NULL;
 	struct file *group_file = NULL;
@@ -3446,7 +3446,7 @@ SYSCALL_DEFINE5(perf_counter_open,
 	if (flags)
 		return -EINVAL;
 
-	if (copy_from_user(&hw_event, hw_event_uptr, sizeof(hw_event)) != 0)
+	if (copy_from_user(&attr, attr_uptr, sizeof(attr)) != 0)
 		return -EFAULT;
 
 	/*
@@ -3484,11 +3484,11 @@ SYSCALL_DEFINE5(perf_counter_open,
 		/*
 		 * Only a group leader can be exclusive or pinned
 		 */
-		if (hw_event.exclusive || hw_event.pinned)
+		if (attr.exclusive || attr.pinned)
 			goto err_put_context;
 	}
 
-	counter = perf_counter_alloc(&hw_event, cpu, ctx, group_leader,
+	counter = perf_counter_alloc(&attr, cpu, ctx, group_leader,
 				     GFP_KERNEL);
 	ret = PTR_ERR(counter);
 	if (IS_ERR(counter))
@@ -3556,7 +3556,7 @@ inherit_counter(struct perf_counter *parent_counter,
 	if (parent_counter->parent)
 		parent_counter = parent_counter->parent;
 
-	child_counter = perf_counter_alloc(&parent_counter->hw_event,
+	child_counter = perf_counter_alloc(&parent_counter->attr,
 					   parent_counter->cpu, child_ctx,
 					   group_leader, GFP_KERNEL);
 	if (IS_ERR(child_counter))
@@ -3565,7 +3565,7 @@ inherit_counter(struct perf_counter *parent_counter,
 
 	/*
 	 * Make the child state follow the state of the parent counter,
-	 * not its hw_event.disabled bit.  We hold the parent's mutex,
+	 * not its attr.disabled bit.  We hold the parent's mutex,
 	 * so we won't race with perf_counter_{en, dis}able_family.
 	 */
 	if (parent_counter->state >= PERF_COUNTER_STATE_INACTIVE)
@@ -3582,7 +3582,7 @@ inherit_counter(struct perf_counter *parent_counter,
 	/*
 	 * inherit into child's child as well:
 	 */
-	child_counter->hw_event.inherit = 1;
+	child_counter->attr.inherit = 1;
 
 	/*
 	 * Get a reference to the parent filp - we will fput it
@@ -3838,7 +3838,7 @@ int perf_counter_init_task(struct task_struct *child)
 		if (counter != counter->group_leader)
 			continue;
 
-		if (!counter->hw_event.inherit) {
+		if (!counter->attr.inherit) {
 			inherited_all = 0;
 			continue;
 		}
