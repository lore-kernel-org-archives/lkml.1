Return-Path: <linux-kernel-owner+w=401wt.eu-S1754399AbYGUPXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbYGUPXG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbYGUPWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:22:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33379 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbYGUPWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:22:48 -0400
Date: Mon, 21 Jul 2008 17:22:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [git pull] 4096 CPUs support updates for v2.6.27
Message-ID: <20080721152229.GA19688@elte.hu>
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

Please pull the latest 4096 cpus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git cpus4096-for-linus

this topic was driven by Mike Travis @ SGI and deals with various small 
details related to turning default distribution kernels into able to 
boot and run on 4096 CPU boxes. Rather crazy.

There are two main types of changes: reduce kernel stack footprint 
(having a 512 byte cpumask on the kernel stack hurts), and update 
various CPU iterators to not go from 1 to 4096 but just from 1 to 2 on 
90% of the boxes that have 2 or less CPUs. Neither could be done 
automatically so these are all manual changes.

Thanks,

	Ingo

------------------>
Alexander van Heukelum (1):
      cpumask: make for_each_cpu_mask a bit smaller

Ingo Molnar (2):
      Revert "cpumask: introduce new APIs"
      cpumask: Optimize cpumask_of_cpu in lib/smp_processor_id.c, fix

Mike Travis (28):
      sched: replace MAX_NUMNODES with nr_node_ids in kernel/sched.c
      cpu: change some globals to statics in drivers/base/cpu.c v2
      x86: Add performance variants of cpumask operators
      acpi: use performance variant for_each_cpu_mask_nr
      cpufreq: use performance variant for_each_cpu_mask_nr
      core: use performance variant for_each_cpu_mask_nr
      mm: use performance variant for_each_cpu_mask_nr
      net: use performance variant for_each_cpu_mask_nr
      x86: use performance variant for_each_cpu_mask_nr
      infiniband: use performance variant for_each_cpu_mask_nr
      clocksource/events: use performance variant for_each_cpu_mask_nr
      net: Pass reference to cpumask variable in net/sunrpc/svc.c
      cpumask: Replace cpumask_of_cpu with cpumask_of_cpu_ptr
      cpumask: Optimize cpumask_of_cpu in arch/x86/kernel/io_apic_64.c
      cpumask: Optimize cpumask_of_cpu in arch/x86/kernel/ldt.c
      cpumask: Optimize cpumask_of_cpu in drivers/misc/sgi-xp/xpc_main.c
      cpumask: Optimize cpumask_of_cpu in kernel/time/tick-common.c
      cpumask: Optimize cpumask_of_cpu in lib/smp_processor_id.c
      cpumask: Provide a generic set of CPUMASK_ALLOC macros
      cpumask: Use optimized CPUMASK_ALLOC macros in the centrino_target
      NR_CPUS: Replace NR_CPUS in arch/x86/kernel/cpu/mcheck/mce_64.c
      NR_CPUS: Replace NR_CPUS in arch/x86/kernel/cpu/proc.c
      NR_CPUS: Replace NR_CPUS in arch/x86/kernel/genx2apic_uv_x.c
      NR_CPUS: Replace NR_CPUS in arch/x86/kernel/genapic_flat_64.c
      NR_CPUS: Replace per_cpu(..., smp_processor_id()) with __get_cpu_var
      NR_CPUS: Replace NR_CPUS in cpufreq userspace routines
      cpumask: Provide a generic set of CPUMASK_ALLOC macros, FIXUP
      NR_CPUS: Replace NR_CPUS in speedstep-centrino.c


 arch/x86/kernel/acpi/cstate.c                    |    3 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |   16 ++-
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c        |    6 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |   23 ++--
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |  157 +++++++++++++--------
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    7 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    5 +-
 arch/x86/kernel/cpu/mcheck/mce_64.c              |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c          |    4 +-
 arch/x86/kernel/cpu/proc.c                       |    2 +-
 arch/x86/kernel/genapic_flat_64.c                |    2 +-
 arch/x86/kernel/genx2apic_uv_x.c                 |    4 +-
 arch/x86/kernel/io_apic_64.c                     |   12 +-
 arch/x86/kernel/ldt.c                            |    6 +-
 arch/x86/kernel/microcode.c                      |   13 ++-
 arch/x86/kernel/reboot.c                         |   14 ++-
 arch/x86/kernel/smpboot.c                        |    8 +-
 arch/x86/xen/smp.c                               |    4 +-
 drivers/acpi/processor_throttling.c              |   17 ++-
 drivers/base/cpu.c                               |    4 +-
 drivers/cpufreq/cpufreq.c                        |   14 +-
 drivers/cpufreq/cpufreq_conservative.c           |    2 +-
 drivers/cpufreq/cpufreq_ondemand.c               |    4 +-
 drivers/cpufreq/cpufreq_userspace.c              |   79 ++++++-----
 drivers/firmware/dcdbas.c                        |    3 +-
 drivers/infiniband/hw/ehca/ehca_irq.c            |    4 +-
 drivers/misc/sgi-xp/xpc_main.c                   |    3 +-
 include/asm-x86/ipi.h                            |    2 +-
 include/asm-x86/processor.h                      |    2 +-
 include/linux/cpumask.h                          |  166 +++++++++++++++++-----
 kernel/cpu.c                                     |    2 +-
 kernel/rcuclassic.c                              |    2 +-
 kernel/rcupreempt.c                              |   10 +-
 kernel/sched.c                                   |   36 +++---
 kernel/sched_fair.c                              |    2 +-
 kernel/sched_rt.c                                |    4 +-
 kernel/stop_machine.c                            |    3 +-
 kernel/taskstats.c                               |    4 +-
 kernel/time/clocksource.c                        |    4 +-
 kernel/time/tick-broadcast.c                     |    3 +-
 kernel/time/tick-common.c                        |   14 +-
 kernel/trace/trace_sysprof.c                     |    4 +-
 kernel/workqueue.c                               |    6 +-
 lib/cpumask.c                                    |    9 ++
 lib/smp_processor_id.c                           |    6 +-
 mm/allocpercpu.c                                 |    4 +-
 mm/vmstat.c                                      |    2 +-
 net/core/dev.c                                   |    4 +-
 net/iucv/iucv.c                                  |    2 +-
 net/sunrpc/svc.c                                 |    3 +-
 50 files changed, 442 insertions(+), 270 deletions(-)

diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index c2502eb..9220cf4 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -73,6 +73,7 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr(new_mask, cpu);
 	int retval;
 	unsigned int eax, ebx, ecx, edx;
 	unsigned int edx_part;
@@ -91,7 +92,7 @@ int acpi_processor_ffh_cstate_probe(unsigned int cpu,
 
 	/* Make sure we are running on right CPU */
 	saved_mask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed_ptr(current, new_mask);
 	if (retval)
 		return -1;
 
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index b0c8208..ff2fff5 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -200,10 +200,12 @@ static void drv_read(struct drv_cmd *cmd)
 static void drv_write(struct drv_cmd *cmd)
 {
 	cpumask_t saved_mask = current->cpus_allowed;
+	cpumask_of_cpu_ptr_declare(cpu_mask);
 	unsigned int i;
 
-	for_each_cpu_mask(i, cmd->mask) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
+	for_each_cpu_mask_nr(i, cmd->mask) {
+		cpumask_of_cpu_ptr_next(cpu_mask, i);
+		set_cpus_allowed_ptr(current, cpu_mask);
 		do_drv_write(cmd);
 	}
 
@@ -267,11 +269,12 @@ static unsigned int get_measured_perf(unsigned int cpu)
 	} aperf_cur, mperf_cur;
 
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr(cpu_mask, cpu);
 	unsigned int perf_percent;
 	unsigned int retval;
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpu_mask);
 	if (get_cpu() != cpu) {
 		/* We were not able to run on requested processor */
 		put_cpu();
@@ -337,6 +340,7 @@ static unsigned int get_measured_perf(unsigned int cpu)
 
 static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 {
+	cpumask_of_cpu_ptr(cpu_mask, cpu);
 	struct acpi_cpufreq_data *data = per_cpu(drv_data, cpu);
 	unsigned int freq;
 	unsigned int cached_freq;
@@ -349,7 +353,7 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 	}
 
 	cached_freq = data->freq_table[data->acpi_data->state].frequency;
-	freq = extract_freq(get_cur_val(&cpumask_of_cpu(cpu)), data);
+	freq = extract_freq(get_cur_val(cpu_mask), data);
 	if (freq != cached_freq) {
 		/*
 		 * The dreaded BIOS frequency change behind our back.
@@ -451,7 +455,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
 	freqs.new = data->freq_table[next_state].frequency;
-	for_each_cpu_mask(i, cmd.mask) {
+	for_each_cpu_mask_nr(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -466,7 +470,7 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		}
 	}
 
-	for_each_cpu_mask(i, cmd.mask) {
+	for_each_cpu_mask_nr(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
diff --git a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
index 199e4e0..f1685fb 100644
--- a/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -122,7 +122,7 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy,
 		return 0;
 
 	/* notifiers */
-	for_each_cpu_mask(i, policy->cpus) {
+	for_each_cpu_mask_nr(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -130,11 +130,11 @@ static int cpufreq_p4_target(struct cpufreq_policy *policy,
 	/* run on each logical CPU, see section 13.15.3 of IA32 Intel Architecture Software
 	 * Developer's Manual, Volume 3
 	 */
-	for_each_cpu_mask(i, policy->cpus)
+	for_each_cpu_mask_nr(i, policy->cpus)
 		cpufreq_p4_setdc(i, p4clockmod_table[newstate].index);
 
 	/* notifiers */
-	for_each_cpu_mask(i, policy->cpus) {
+	for_each_cpu_mask_nr(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 206791e..53c7b69 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -479,11 +479,12 @@ static int core_voltage_post_transition(struct powernow_k8_data *data, u32 reqvi
 static int check_supported_cpu(unsigned int cpu)
 {
 	cpumask_t oldmask;
+	cpumask_of_cpu_ptr(cpu_mask, cpu);
 	u32 eax, ebx, ecx, edx;
 	unsigned int rc = 0;
 
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpu_mask);
 
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", cpu);
@@ -966,7 +967,7 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data, unsigned i
 	freqs.old = find_khz_freq_from_fid(data->currfid);
 	freqs.new = find_khz_freq_from_fid(fid);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -974,7 +975,7 @@ static int transition_frequency_fidvid(struct powernow_k8_data *data, unsigned i
 	res = transition_fid_vid(data, fid, vid);
 	freqs.new = find_khz_freq_from_fid(data->currfid);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -997,7 +998,7 @@ static int transition_frequency_pstate(struct powernow_k8_data *data, unsigned i
 	freqs.old = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -1005,7 +1006,7 @@ static int transition_frequency_pstate(struct powernow_k8_data *data, unsigned i
 	res = transition_pstate(data, pstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu_mask(i, *(data->available_cores)) {
+	for_each_cpu_mask_nr(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -1016,6 +1017,7 @@ static int transition_frequency_pstate(struct powernow_k8_data *data, unsigned i
 static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsigned relation)
 {
 	cpumask_t oldmask;
+	cpumask_of_cpu_ptr(cpu_mask, pol->cpu);
 	struct powernow_k8_data *data = per_cpu(powernow_data, pol->cpu);
 	u32 checkfid;
 	u32 checkvid;
@@ -1030,7 +1032,7 @@ static int powernowk8_target(struct cpufreq_policy *pol, unsigned targfreq, unsi
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	set_cpus_allowed_ptr(current, cpu_mask);
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1105,6 +1107,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask;
+	cpumask_of_cpu_ptr_declare(newmask);
 	int rc;
 
 	if (!cpu_online(pol->cpu))
@@ -1156,7 +1159,8 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	cpumask_of_cpu_ptr_next(newmask, pol->cpu);
+	set_cpus_allowed_ptr(current, newmask);
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1178,7 +1182,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 	set_cpus_allowed_ptr(current, &oldmask);
 
 	if (cpu_family == CPU_HW_PSTATE)
-		pol->cpus = cpumask_of_cpu(pol->cpu);
+		pol->cpus = *newmask;
 	else
 		pol->cpus = per_cpu(cpu_core_map, pol->cpu);
 	data->available_cores = &(pol->cpus);
@@ -1244,6 +1248,7 @@ static unsigned int powernowk8_get (unsigned int cpu)
 {
 	struct powernow_k8_data *data;
 	cpumask_t oldmask = current->cpus_allowed;
+	cpumask_of_cpu_ptr(newmask, cpu);
 	unsigned int khz = 0;
 	unsigned int first;
 
@@ -1253,7 +1258,7 @@ static unsigned int powernowk8_get (unsigned int cpu)
 	if (!data)
 		return -EINVAL;
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, newmask);
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX
 			"limiting to CPU %d failed in powernowk8_get\n", cpu);
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
index 908dd34..ca2ac13 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -28,7 +28,8 @@
 #define PFX		"speedstep-centrino: "
 #define MAINTAINER	"cpufreq@lists.linux.org.uk"
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-centrino", msg)
+#define dprintk(msg...) \
+	cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "speedstep-centrino", msg)
 
 #define INTEL_MSR_RANGE	(0xffff)
 
@@ -66,11 +67,12 @@ struct cpu_model
 
 	struct cpufreq_frequency_table *op_points; /* clock/voltage pairs */
 };
-static int centrino_verify_cpu_id(const struct cpuinfo_x86 *c, const struct cpu_id *x);
+static int centrino_verify_cpu_id(const struct cpuinfo_x86 *c,
+				  const struct cpu_id *x);
 
 /* Operating points for current CPU */
-static struct cpu_model *centrino_model[NR_CPUS];
-static const struct cpu_id *centrino_cpu[NR_CPUS];
+static DEFINE_PER_CPU(struct cpu_model *, centrino_model);
+static DEFINE_PER_CPU(const struct cpu_id *, centrino_cpu);
 
 static struct cpufreq_driver centrino_driver;
 
@@ -255,7 +257,7 @@ static int centrino_cpu_init_table(struct cpufreq_policy *policy)
 		return -ENOENT;
 	}
 
-	centrino_model[policy->cpu] = model;
+	per_cpu(centrino_model, policy->cpu) = model;
 
 	dprintk("found \"%s\": max frequency: %dkHz\n",
 	       model->model_name, model->max_freq);
@@ -264,10 +266,14 @@ static int centrino_cpu_init_table(struct cpufreq_policy *policy)
 }
 
 #else
-static inline int centrino_cpu_init_table(struct cpufreq_policy *policy) { return -ENODEV; }
+static inline int centrino_cpu_init_table(struct cpufreq_policy *policy)
+{
+	return -ENODEV;
+}
 #endif /* CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE */
 
-static int centrino_verify_cpu_id(const struct cpuinfo_x86 *c, const struct cpu_id *x)
+static int centrino_verify_cpu_id(const struct cpuinfo_x86 *c,
+				  const struct cpu_id *x)
 {
 	if ((c->x86 == x->x86) &&
 	    (c->x86_model == x->x86_model) &&
@@ -286,23 +292,28 @@ static unsigned extract_clock(unsigned msr, unsigned int cpu, int failsafe)
 	 * for centrino, as some DSDTs are buggy.
 	 * Ideally, this can be done using the acpi_data structure.
 	 */
-	if ((centrino_cpu[cpu] == &cpu_ids[CPU_BANIAS]) ||
-	    (centrino_cpu[cpu] == &cpu_ids[CPU_DOTHAN_A1]) ||
-	    (centrino_cpu[cpu] == &cpu_ids[CPU_DOTHAN_B0])) {
+	if ((per_cpu(centrino_cpu, cpu) == &cpu_ids[CPU_BANIAS]) ||
+	    (per_cpu(centrino_cpu, cpu) == &cpu_ids[CPU_DOTHAN_A1]) ||
+	    (per_cpu(centrino_cpu, cpu) == &cpu_ids[CPU_DOTHAN_B0])) {
 		msr = (msr >> 8) & 0xff;
 		return msr * 100000;
 	}
 
-	if ((!centrino_model[cpu]) || (!centrino_model[cpu]->op_points))
+	if ((!per_cpu(centrino_model, cpu)) ||
+	    (!per_cpu(centrino_model, cpu)->op_points))
 		return 0;
 
 	msr &= 0xffff;
-	for (i=0;centrino_model[cpu]->op_points[i].frequency != CPUFREQ_TABLE_END; i++) {
-		if (msr == centrino_model[cpu]->op_points[i].index)
-			return centrino_model[cpu]->op_points[i].frequency;
+	for (i = 0;
+		per_cpu(centrino_model, cpu)->op_points[i].frequency
+							!= CPUFREQ_TABLE_END;
+	     i++) {
+		if (msr == per_cpu(centrino_model, cpu)->op_points[i].index)
+			return per_cpu(centrino_model, cpu)->
+							op_points[i].frequency;
 	}
 	if (failsafe)
-		return centrino_model[cpu]->op_points[i-1].frequency;
+		return per_cpu(centrino_model, cpu)->op_points[i-1].frequency;
 	else
 		return 0;
 }
@@ -313,9 +324,10 @@ static unsigned int get_cur_freq(unsigned int cpu)
 	unsigned l, h;
 	unsigned clock_freq;
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr(new_mask, cpu);
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, new_mask);
 	if (smp_processor_id() != cpu)
 		return 0;
 
@@ -347,7 +359,8 @@ static int centrino_cpu_init(struct cpufreq_policy *policy)
 	int i;
 
 	/* Only Intel makes Enhanced Speedstep-capable CPUs */
-	if (cpu->x86_vendor != X86_VENDOR_INTEL || !cpu_has(cpu, X86_FEATURE_EST))
+	if (cpu->x86_vendor != X86_VENDOR_INTEL ||
+	    !cpu_has(cpu, X86_FEATURE_EST))
 		return -ENODEV;
 
 	if (cpu_has(cpu, X86_FEATURE_CONSTANT_TSC))
@@ -361,9 +374,9 @@ static int centrino_cpu_init(struct cpufreq_policy *policy)
 			break;
 
 	if (i != N_IDS)
-		centrino_cpu[policy->cpu] = &cpu_ids[i];
+		per_cpu(centrino_cpu, policy->cpu) = &cpu_ids[i];
 
-	if (!centrino_cpu[policy->cpu]) {
+	if (!per_cpu(centrino_cpu, policy->cpu)) {
 		dprintk("found unsupported CPU with "
 		"Enhanced SpeedStep: send /proc/cpuinfo to "
 		MAINTAINER "\n");
@@ -386,23 +399,26 @@ static int centrino_cpu_init(struct cpufreq_policy *policy)
 		/* check to see if it stuck */
 		rdmsr(MSR_IA32_MISC_ENABLE, l, h);
 		if (!(l & (1<<16))) {
-			printk(KERN_INFO PFX "couldn't enable Enhanced SpeedStep\n");
+			printk(KERN_INFO PFX
+				"couldn't enable Enhanced SpeedStep\n");
 			return -ENODEV;
 		}
 	}
 
 	freq = get_cur_freq(policy->cpu);
-
-	policy->cpuinfo.transition_latency = 10000; /* 10uS transition latency */
+	policy->cpuinfo.transition_latency = 10000;
+						/* 10uS transition latency */
 	policy->cur = freq;
 
 	dprintk("centrino_cpu_init: cur=%dkHz\n", policy->cur);
 
-	ret = cpufreq_frequency_table_cpuinfo(policy, centrino_model[policy->cpu]->op_points);
+	ret = cpufreq_frequency_table_cpuinfo(policy,
+		per_cpu(centrino_model, policy->cpu)->op_points);
 	if (ret)
 		return (ret);
 
-	cpufreq_frequency_table_get_attr(centrino_model[policy->cpu]->op_points, policy->cpu);
+	cpufreq_frequency_table_get_attr(
+		per_cpu(centrino_model, policy->cpu)->op_points, policy->cpu);
 
 	return 0;
 }
@@ -411,12 +427,12 @@ static int centrino_cpu_exit(struct cpufreq_policy *policy)
 {
 	unsigned int cpu = policy->cpu;
 
-	if (!centrino_model[cpu])
+	if (!per_cpu(centrino_model, cpu))
 		return -ENODEV;
 
 	cpufreq_frequency_table_put_attr(cpu);
 
-	centrino_model[cpu] = NULL;
+	per_cpu(centrino_model, cpu) = NULL;
 
 	return 0;
 }
@@ -430,17 +446,26 @@ static int centrino_cpu_exit(struct cpufreq_policy *policy)
  */
 static int centrino_verify (struct cpufreq_policy *policy)
 {
-	return cpufreq_frequency_table_verify(policy, centrino_model[policy->cpu]->op_points);
+	return cpufreq_frequency_table_verify(policy,
+			per_cpu(centrino_model, policy->cpu)->op_points);
 }
 
 /**
  * centrino_setpolicy - set a new CPUFreq policy
  * @policy: new policy
  * @target_freq: the target frequency
- * @relation: how that frequency relates to achieved frequency (CPUFREQ_RELATION_L or CPUFREQ_RELATION_H)
+ * @relation: how that frequency relates to achieved frequency
+ *	(CPUFREQ_RELATION_L or CPUFREQ_RELATION_H)
  *
  * Sets a new CPUFreq policy.
  */
+struct allmasks {
+	cpumask_t		online_policy_cpus;
+	cpumask_t		saved_mask;
+	cpumask_t		set_mask;
+	cpumask_t		covered_cpus;
+};
+
 static int centrino_target (struct cpufreq_policy *policy,
 			    unsigned int target_freq,
 			    unsigned int relation)
@@ -448,48 +473,55 @@ static int centrino_target (struct cpufreq_policy *policy,
 	unsigned int    newstate = 0;
 	unsigned int	msr, oldmsr = 0, h = 0, cpu = policy->cpu;
 	struct cpufreq_freqs	freqs;
-	cpumask_t		online_policy_cpus;
-	cpumask_t		saved_mask;
-	cpumask_t		set_mask;
-	cpumask_t		covered_cpus;
 	int			retval = 0;
 	unsigned int		j, k, first_cpu, tmp;
-
-	if (unlikely(centrino_model[cpu] == NULL))
-		return -ENODEV;
+	CPUMASK_ALLOC(allmasks);
+	CPUMASK_PTR(online_policy_cpus, allmasks);
+	CPUMASK_PTR(saved_mask, allmasks);
+	CPUMASK_PTR(set_mask, allmasks);
+	CPUMASK_PTR(covered_cpus, allmasks);
+
+	if (unlikely(allmasks == NULL))
+		return -ENOMEM;
+
+	if (unlikely(per_cpu(centrino_model, cpu) == NULL)) {
+		retval = -ENODEV;
+		goto out;
+	}
 
 	if (unlikely(cpufreq_frequency_table_target(policy,
-			centrino_model[cpu]->op_points,
+			per_cpu(centrino_model, cpu)->op_points,
 			target_freq,
 			relation,
 			&newstate))) {
-		return -EINVAL;
+		retval = -EINVAL;
+		goto out;
 	}
 
 #ifdef CONFIG_HOTPLUG_CPU
 	/* cpufreq holds the hotplug lock, so we are safe from here on */
-	cpus_and(online_policy_cpus, cpu_online_map, policy->cpus);
+	cpus_and(*online_policy_cpus, cpu_online_map, policy->cpus);
 #else
-	online_policy_cpus = policy->cpus;
+	*online_policy_cpus = policy->cpus;
 #endif
 
-	saved_mask = current->cpus_allowed;
+	*saved_mask = current->cpus_allowed;
 	first_cpu = 1;
-	cpus_clear(covered_cpus);
-	for_each_cpu_mask(j, online_policy_cpus) {
+	cpus_clear(*covered_cpus);
+	for_each_cpu_mask_nr(j, *online_policy_cpus) {
 		/*
 		 * Support for SMP systems.
 		 * Make sure we are running on CPU that wants to change freq
 		 */
-		cpus_clear(set_mask);
+		cpus_clear(*set_mask);
 		if (policy->shared_type == CPUFREQ_SHARED_TYPE_ANY)
-			cpus_or(set_mask, set_mask, online_policy_cpus);
+			cpus_or(*set_mask, *set_mask, *online_policy_cpus);
 		else
-			cpu_set(j, set_mask);
+			cpu_set(j, *set_mask);
 
-		set_cpus_allowed_ptr(current, &set_mask);
+		set_cpus_allowed_ptr(current, set_mask);
 		preempt_disable();
-		if (unlikely(!cpu_isset(smp_processor_id(), set_mask))) {
+		if (unlikely(!cpu_isset(smp_processor_id(), *set_mask))) {
 			dprintk("couldn't limit to CPUs in this domain\n");
 			retval = -EAGAIN;
 			if (first_cpu) {
@@ -500,7 +532,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 			break;
 		}
 
-		msr = centrino_model[cpu]->op_points[newstate].index;
+		msr = per_cpu(centrino_model, cpu)->op_points[newstate].index;
 
 		if (first_cpu) {
 			rdmsr(MSR_IA32_PERF_CTL, oldmsr, h);
@@ -517,7 +549,7 @@ static int centrino_target (struct cpufreq_policy *policy,
 			dprintk("target=%dkHz old=%d new=%d msr=%04x\n",
 				target_freq, freqs.old, freqs.new, msr);
 
-			for_each_cpu_mask(k, online_policy_cpus) {
+			for_each_cpu_mask_nr(k, *online_policy_cpus) {
 				freqs.cpu = k;
 				cpufreq_notify_transition(&freqs,
 					CPUFREQ_PRECHANGE);
@@ -536,11 +568,11 @@ static int centrino_target (struct cpufreq_policy *policy,
 			break;
 		}
 
-		cpu_set(j, covered_cpus);
+		cpu_set(j, *covered_cpus);
 		preempt_enable();
 	}
 
-	for_each_cpu_mask(k, online_policy_cpus) {
+	for_each_cpu_mask_nr(k, *online_policy_cpus) {
 		freqs.cpu = k;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -553,10 +585,12 @@ static int centrino_target (struct cpufreq_policy *policy,
 		 * Best effort undo..
 		 */
 
-		if (!cpus_empty(covered_cpus)) {
-			for_each_cpu_mask(j, covered_cpus) {
-				set_cpus_allowed_ptr(current,
-						     &cpumask_of_cpu(j));
+		if (!cpus_empty(*covered_cpus)) {
+			cpumask_of_cpu_ptr_declare(new_mask);
+
+			for_each_cpu_mask_nr(j, *covered_cpus) {
+				cpumask_of_cpu_ptr_next(new_mask, j);
+				set_cpus_allowed_ptr(current, new_mask);
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
 			}
 		}
@@ -564,19 +598,22 @@ static int centrino_target (struct cpufreq_policy *policy,
 		tmp = freqs.new;
 		freqs.new = freqs.old;
 		freqs.old = tmp;
-		for_each_cpu_mask(j, online_policy_cpus) {
+		for_each_cpu_mask_nr(j, *online_policy_cpus) {
 			freqs.cpu = j;
 			cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 		}
 	}
-	set_cpus_allowed_ptr(current, &saved_mask);
-	return 0;
+	set_cpus_allowed_ptr(current, saved_mask);
+	retval = 0;
+	goto out;
 
 migrate_end:
 	preempt_enable();
-	set_cpus_allowed_ptr(current, &saved_mask);
-	return 0;
+	set_cpus_allowed_ptr(current, saved_mask);
+out:
+	CPUMASK_FREE(allmasks);
+	return retval;
 }
 
 static struct freq_attr* centrino_attr[] = {
diff --git a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
index 1b50244..2f3728d 100644
--- a/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ b/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -244,7 +244,8 @@ static unsigned int _speedstep_get(const cpumask_t *cpus)
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	return _speedstep_get(&cpumask_of_cpu(cpu));
+	cpumask_of_cpu_ptr(newmask, cpu);
+	return _speedstep_get(newmask);
 }
 
 /**
@@ -279,7 +280,7 @@ static int speedstep_target (struct cpufreq_policy *policy,
 
 	cpus_allowed = current->cpus_allowed;
 
-	for_each_cpu_mask(i, policy->cpus) {
+	for_each_cpu_mask_nr(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -292,7 +293,7 @@ static int speedstep_target (struct cpufreq_policy *policy,
 	/* allow to be run on all CPUs */
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
-	for_each_cpu_mask(i, policy->cpus) {
+	for_each_cpu_mask_nr(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 2c8afaf..e4b8d18 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -489,7 +489,7 @@ static void __cpuinit cache_remove_shared_cpu_map(unsigned int cpu, int index)
 	int sibling;
 
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
-	for_each_cpu_mask(sibling, this_leaf->shared_cpu_map) {
+	for_each_cpu_mask_nr(sibling, this_leaf->shared_cpu_map) {
 		sibling_leaf = CPUID4_INFO_IDX(sibling, index);	
 		cpu_clear(cpu, sibling_leaf->shared_cpu_map);
 	}
@@ -516,6 +516,7 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 	unsigned long		j;
 	int			retval;
 	cpumask_t		oldmask;
+	cpumask_of_cpu_ptr(newmask, cpu);
 
 	if (num_cache_leaves == 0)
 		return -ENOENT;
@@ -526,7 +527,7 @@ static int __cpuinit detect_cache_attributes(unsigned int cpu)
 		return -ENOMEM;
 
 	oldmask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed_ptr(current, newmask);
 	if (retval)
 		goto out;
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index c4a7ec3..2fe06ab 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -580,7 +580,7 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 	char __user *buf = ubuf;
 	int i, err;
 
-	cpu_tsc = kmalloc(NR_CPUS * sizeof(long), GFP_KERNEL);
+	cpu_tsc = kmalloc(nr_cpu_ids * sizeof(long), GFP_KERNEL);
 	if (!cpu_tsc)
 		return -ENOMEM;
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
index 7c9a813..88736ca 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -527,7 +527,7 @@ static __cpuinit int threshold_create_bank(unsigned int cpu, unsigned int bank)
 	if (err)
 		goto out_free;
 
-	for_each_cpu_mask(i, b->cpus) {
+	for_each_cpu_mask_nr(i, b->cpus) {
 		if (i == cpu)
 			continue;
 
@@ -617,7 +617,7 @@ static void threshold_remove_bank(unsigned int cpu, int bank)
 #endif
 
 	/* remove all sibling symlinks before unregistering */
-	for_each_cpu_mask(i, b->cpus) {
+	for_each_cpu_mask_nr(i, b->cpus) {
 		if (i == cpu)
 			continue;
 
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index 0d0d905..a26c480 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -160,7 +160,7 @@ static void *c_start(struct seq_file *m, loff_t *pos)
 {
 	if (*pos == 0)	/* just in case, cpu 0 is not the first */
 		*pos = first_cpu(cpu_online_map);
-	if ((*pos) < NR_CPUS && cpu_online(*pos))
+	if ((*pos) < nr_cpu_ids && cpu_online(*pos))
 		return &cpu_data(*pos);
 	return NULL;
 }
diff --git a/arch/x86/kernel/genapic_flat_64.c b/arch/x86/kernel/genapic_flat_64.c
index 1a9c688..786548a 100644
--- a/arch/x86/kernel/genapic_flat_64.c
+++ b/arch/x86/kernel/genapic_flat_64.c
@@ -168,7 +168,7 @@ static unsigned int physflat_cpu_mask_to_apicid(cpumask_t cpumask)
 	 * May as well be the first.
 	 */
 	cpu = first_cpu(cpumask);
-	if ((unsigned)cpu < NR_CPUS)
+	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
 		return BAD_APICID;
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 711f11c..3e5d7b8 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -94,7 +94,7 @@ static void uv_send_IPI_mask(cpumask_t mask, int vector)
 {
 	unsigned int cpu;
 
-	for (cpu = 0; cpu < NR_CPUS; ++cpu)
+	for_each_possible_cpu(cpu)
 		if (cpu_isset(cpu, mask))
 			uv_send_IPI_one(cpu, vector);
 }
@@ -128,7 +128,7 @@ static unsigned int uv_cpu_mask_to_apicid(cpumask_t cpumask)
 	 * May as well be the first.
 	 */
 	cpu = first_cpu(cpumask);
-	if ((unsigned)cpu < NR_CPUS)
+	if ((unsigned)cpu < nr_cpu_ids)
 		return per_cpu(x86_cpu_to_apicid, cpu);
 	else
 		return BAD_APICID;
diff --git a/arch/x86/kernel/io_apic_64.c b/arch/x86/kernel/io_apic_64.c
index 6510cde..a85db79 100644
--- a/arch/x86/kernel/io_apic_64.c
+++ b/arch/x86/kernel/io_apic_64.c
@@ -731,7 +731,7 @@ static int __assign_irq_vector(int irq, cpumask_t mask)
 			return 0;
 	}
 
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		cpumask_t domain, new_mask;
 		int new_cpu;
 		int vector, offset;
@@ -752,7 +752,7 @@ next:
 			continue;
 		if (vector == IA32_SYSCALL_VECTOR)
 			goto next;
-		for_each_cpu_mask(new_cpu, new_mask)
+		for_each_cpu_mask_nr(new_cpu, new_mask)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
 		/* Found one! */
@@ -762,7 +762,7 @@ next:
 			cfg->move_in_progress = 1;
 			cfg->old_domain = cfg->domain;
 		}
-		for_each_cpu_mask(new_cpu, new_mask)
+		for_each_cpu_mask_nr(new_cpu, new_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
 		cfg->domain = domain;
@@ -794,7 +794,7 @@ static void __clear_irq_vector(int irq)
 
 	vector = cfg->vector;
 	cpus_and(mask, cfg->domain, cpu_online_map);
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu_mask_nr(cpu, mask)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
 	cfg->vector = 0;
@@ -1372,12 +1372,10 @@ static unsigned int startup_ioapic_irq(unsigned int irq)
 static int ioapic_retrigger_irq(unsigned int irq)
 {
 	struct irq_cfg *cfg = &irq_cfg[irq];
-	cpumask_t mask;
 	unsigned long flags;
 
 	spin_lock_irqsave(&vector_lock, flags);
-	mask = cpumask_of_cpu(first_cpu(cfg->domain));
-	send_IPI_mask(mask, cfg->vector);
+	send_IPI_mask(cpumask_of_cpu(first_cpu(cfg->domain)), cfg->vector);
 	spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index a844957..3fee2aa 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -62,12 +62,12 @@ static int alloc_ldt(mm_context_t *pc, int mincount, int reload)
 
 	if (reload) {
 #ifdef CONFIG_SMP
-		cpumask_t mask;
+		cpumask_of_cpu_ptr_declare(mask);
 
 		preempt_disable();
 		load_LDT(pc);
-		mask = cpumask_of_cpu(smp_processor_id());
-		if (!cpus_equal(current->mm->cpu_vm_mask, mask))
+		cpumask_of_cpu_ptr_next(mask, smp_processor_id());
+		if (!cpus_equal(current->mm->cpu_vm_mask, *mask))
 			smp_call_function(flush_ldt, current->mm, 1);
 		preempt_enable();
 #else
diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 56b9331..5852016 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -388,6 +388,7 @@ static int do_microcode_update (void)
 	void *new_mc = NULL;
 	int cpu;
 	cpumask_t old;
+	cpumask_of_cpu_ptr_declare(newmask);
 
 	old = current->cpus_allowed;
 
@@ -404,7 +405,8 @@ static int do_microcode_update (void)
 
 			if (!uci->valid)
 				continue;
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+			cpumask_of_cpu_ptr_next(newmask, cpu);
+			set_cpus_allowed_ptr(current, newmask);
 			error = get_maching_microcode(new_mc, cpu);
 			if (error < 0)
 				goto out;
@@ -574,6 +576,7 @@ static int apply_microcode_check_cpu(int cpu)
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 	cpumask_t old;
+	cpumask_of_cpu_ptr(newmask, cpu);
 	unsigned int val[2];
 	int err = 0;
 
@@ -582,7 +585,7 @@ static int apply_microcode_check_cpu(int cpu)
 		return 0;
 
 	old = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, newmask);
 
 	/* Check if the microcode we have in memory matches the CPU */
 	if (c->x86_vendor != X86_VENDOR_INTEL || c->x86 < 6 ||
@@ -620,11 +623,12 @@ static int apply_microcode_check_cpu(int cpu)
 static void microcode_init_cpu(int cpu, int resume)
 {
 	cpumask_t old;
+	cpumask_of_cpu_ptr(newmask, cpu);
 	struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
 
 	old = current->cpus_allowed;
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, newmask);
 	mutex_lock(&microcode_mutex);
 	collect_cpu_info(cpu);
 	if (uci->valid && system_state == SYSTEM_RUNNING && !resume)
@@ -656,11 +660,12 @@ static ssize_t reload_store(struct sys_device *dev, const char *buf, size_t sz)
 		return -EINVAL;
 	if (val == 1) {
 		cpumask_t old;
+		cpumask_of_cpu_ptr(newmask, cpu);
 
 		old = current->cpus_allowed;
 
 		get_online_cpus();
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+		set_cpus_allowed_ptr(current, newmask);
 
 		mutex_lock(&microcode_mutex);
 		if (uci->valid)
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index f8a6216..214bbdf 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -403,24 +403,28 @@ void native_machine_shutdown(void)
 {
 	/* Stop the cpus and apics */
 #ifdef CONFIG_SMP
-	int reboot_cpu_id;
 
 	/* The boot cpu is always logical cpu 0 */
-	reboot_cpu_id = 0;
+	int reboot_cpu_id = 0;
+	cpumask_of_cpu_ptr(newmask, reboot_cpu_id);
 
 #ifdef CONFIG_X86_32
 	/* See if there has been given a command line override */
 	if ((reboot_cpu != -1) && (reboot_cpu < NR_CPUS) &&
-		cpu_online(reboot_cpu))
+		cpu_online(reboot_cpu)) {
 		reboot_cpu_id = reboot_cpu;
+		cpumask_of_cpu_ptr_next(newmask, reboot_cpu_id);
+	}
 #endif
 
 	/* Make certain the cpu I'm about to reboot on is online */
-	if (!cpu_online(reboot_cpu_id))
+	if (!cpu_online(reboot_cpu_id)) {
 		reboot_cpu_id = smp_processor_id();
+		cpumask_of_cpu_ptr_next(newmask, reboot_cpu_id);
+	}
 
 	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(reboot_cpu_id));
+	set_cpus_allowed_ptr(current, newmask);
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 687376a..09b98cd 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -438,7 +438,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	cpu_set(cpu, cpu_sibling_setup_map);
 
 	if (smp_num_siblings > 1) {
-		for_each_cpu_mask(i, cpu_sibling_setup_map) {
+		for_each_cpu_mask_nr(i, cpu_sibling_setup_map) {
 			if (c->phys_proc_id == cpu_data(i).phys_proc_id &&
 			    c->cpu_core_id == cpu_data(i).cpu_core_id) {
 				cpu_set(i, per_cpu(cpu_sibling_map, cpu));
@@ -461,7 +461,7 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 		return;
 	}
 
-	for_each_cpu_mask(i, cpu_sibling_setup_map) {
+	for_each_cpu_mask_nr(i, cpu_sibling_setup_map) {
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpu_set(i, c->llc_shared_map);
@@ -1230,7 +1230,7 @@ static void remove_siblinginfo(int cpu)
 	int sibling;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	for_each_cpu_mask(sibling, per_cpu(cpu_core_map, cpu)) {
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_core_map, cpu)) {
 		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
 		/*/
 		 * last thread sibling in this cpu core going down
@@ -1239,7 +1239,7 @@ static void remove_siblinginfo(int cpu)
 			cpu_data(sibling).booted_cores--;
 	}
 
-	for_each_cpu_mask(sibling, per_cpu(cpu_sibling_map, cpu))
+	for_each_cpu_mask_nr(sibling, per_cpu(cpu_sibling_map, cpu))
 		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
 	cpus_clear(per_cpu(cpu_sibling_map, cpu));
 	cpus_clear(per_cpu(cpu_core_map, cpu));
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 233156f..463adec 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -351,7 +351,7 @@ static void xen_send_IPI_mask(cpumask_t mask, enum ipi_vector vector)
 
 	cpus_and(mask, mask, cpu_online_map);
 
-	for_each_cpu_mask(cpu, mask)
+	for_each_cpu_mask_nr(cpu, mask)
 		xen_send_IPI_one(cpu, vector);
 }
 
@@ -362,7 +362,7 @@ void xen_smp_send_call_function_ipi(cpumask_t mask)
 	xen_send_IPI_mask(mask, XEN_CALL_FUNCTION_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		if (xen_vcpu_stolen(cpu)) {
 			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
 			break;
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index 0622ace..a2c3f9c 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -827,6 +827,7 @@ static int acpi_processor_get_throttling_ptc(struct acpi_processor *pr)
 static int acpi_processor_get_throttling(struct acpi_processor *pr)
 {
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr_declare(new_mask);
 	int ret;
 
 	if (!pr)
@@ -838,7 +839,8 @@ static int acpi_processor_get_throttling(struct acpi_processor *pr)
 	 * Migrate task to the cpu pointed by pr.
 	 */
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
+	cpumask_of_cpu_ptr_next(new_mask, pr->id);
+	set_cpus_allowed_ptr(current, new_mask);
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
 	/* restore the previous state */
 	set_cpus_allowed_ptr(current, &saved_mask);
@@ -987,6 +989,7 @@ static int acpi_processor_set_throttling_ptc(struct acpi_processor *pr,
 int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 {
 	cpumask_t saved_mask;
+	cpumask_of_cpu_ptr_declare(new_mask);
 	int ret = 0;
 	unsigned int i;
 	struct acpi_processor *match_pr;
@@ -1013,7 +1016,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 	 * affected cpu in order to get one proper T-state.
 	 * The notifier event is THROTTLING_PRECHANGE.
 	 */
-	for_each_cpu_mask(i, online_throttling_cpus) {
+	for_each_cpu_mask_nr(i, online_throttling_cpus) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_PRECHANGE,
 							&t_state);
@@ -1025,7 +1028,8 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
+		cpumask_of_cpu_ptr_next(new_mask, pr->id);
+		set_cpus_allowed_ptr(current, new_mask);
 		ret = p_throttling->acpi_processor_set_throttling(pr,
 						t_state.target_state);
 	} else {
@@ -1034,7 +1038,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 		 * it is necessary to set T-state for every affected
 		 * cpus.
 		 */
-		for_each_cpu_mask(i, online_throttling_cpus) {
+		for_each_cpu_mask_nr(i, online_throttling_cpus) {
 			match_pr = per_cpu(processors, i);
 			/*
 			 * If the pointer is invalid, we will report the
@@ -1056,7 +1060,8 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 				continue;
 			}
 			t_state.cpu = i;
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
+			cpumask_of_cpu_ptr_next(new_mask, i);
+			set_cpus_allowed_ptr(current, new_mask);
 			ret = match_pr->throttling.
 				acpi_processor_set_throttling(
 				match_pr, t_state.target_state);
@@ -1068,7 +1073,7 @@ int acpi_processor_set_throttling(struct acpi_processor *pr, int state)
 	 * affected cpu to update the T-states.
 	 * The notifier event is THROTTLING_POSTCHANGE
 	 */
-	for_each_cpu_mask(i, online_throttling_cpus) {
+	for_each_cpu_mask_nr(i, online_throttling_cpus) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_POSTCHANGE,
 							&t_state);
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index e38dfed..5000402 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -119,14 +119,14 @@ static ssize_t print_cpus_##type(struct sysdev_class *class, char *buf)	\
 {									\
 	return print_cpus_map(buf, &cpu_##type##_map);			\
 }									\
-struct sysdev_class_attribute attr_##type##_map = 			\
+static struct sysdev_class_attribute attr_##type##_map = 		\
 	_SYSDEV_CLASS_ATTR(type, 0444, print_cpus_##type, NULL)
 
 print_cpus_func(online);
 print_cpus_func(possible);
 print_cpus_func(present);
 
-struct sysdev_class_attribute *cpu_state_attr[] = {
+static struct sysdev_class_attribute *cpu_state_attr[] = {
 	&attr_online_map,
 	&attr_possible_map,
 	&attr_present_map,
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 1d41496..d8f8b1e 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -589,7 +589,7 @@ static ssize_t show_cpus(cpumask_t mask, char *buf)
 	ssize_t i = 0;
 	unsigned int cpu;
 
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		if (i)
 			i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), " ");
 		i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), "%u", cpu);
@@ -835,7 +835,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	}
 #endif
 
-	for_each_cpu_mask(j, policy->cpus) {
+	for_each_cpu_mask_nr(j, policy->cpus) {
 		if (cpu == j)
 			continue;
 
@@ -898,14 +898,14 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 	}
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask(j, policy->cpus) {
+	for_each_cpu_mask_nr(j, policy->cpus) {
 		cpufreq_cpu_data[j] = policy;
 		per_cpu(policy_cpu, j) = policy->cpu;
 	}
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	/* symlink affected CPUs */
-	for_each_cpu_mask(j, policy->cpus) {
+	for_each_cpu_mask_nr(j, policy->cpus) {
 		if (j == cpu)
 			continue;
 		if (!cpu_online(j))
@@ -945,7 +945,7 @@ static int cpufreq_add_dev(struct sys_device *sys_dev)
 
 err_out_unregister:
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask(j, policy->cpus)
+	for_each_cpu_mask_nr(j, policy->cpus)
 		cpufreq_cpu_data[j] = NULL;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -1028,7 +1028,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 	 * links afterwards.
 	 */
 	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask(j, data->cpus) {
+		for_each_cpu_mask_nr(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			cpufreq_cpu_data[j] = NULL;
@@ -1038,7 +1038,7 @@ static int __cpufreq_remove_dev(struct sys_device *sys_dev)
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask(j, data->cpus) {
+		for_each_cpu_mask_nr(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			dprintk("removing link for cpu %u\n", j);
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index 5d3a04b..fe565ee 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -497,7 +497,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			return rc;
 		}
 
-		for_each_cpu_mask(j, policy->cpus) {
+		for_each_cpu_mask_nr(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index d2af20d..33855cb 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -367,7 +367,7 @@ static void dbs_check_cpu(struct cpu_dbs_info_s *this_dbs_info)
 
 	/* Get Idle Time */
 	idle_ticks = UINT_MAX;
-	for_each_cpu_mask(j, policy->cpus) {
+	for_each_cpu_mask_nr(j, policy->cpus) {
 		cputime64_t total_idle_ticks;
 		unsigned int tmp_idle_ticks;
 		struct cpu_dbs_info_s *j_dbs_info;
@@ -521,7 +521,7 @@ static int cpufreq_governor_dbs(struct cpufreq_policy *policy,
 			return rc;
 		}
 
-		for_each_cpu_mask(j, policy->cpus) {
+		for_each_cpu_mask_nr(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
diff --git a/drivers/cpufreq/cpufreq_userspace.c b/drivers/cpufreq/cpufreq_userspace.c
index cb2ac01..32244aa 100644
--- a/drivers/cpufreq/cpufreq_userspace.c
+++ b/drivers/cpufreq/cpufreq_userspace.c
@@ -30,16 +30,18 @@
 /**
  * A few values needed by the userspace governor
  */
-static unsigned int	cpu_max_freq[NR_CPUS];
-static unsigned int	cpu_min_freq[NR_CPUS];
-static unsigned int	cpu_cur_freq[NR_CPUS]; /* current CPU freq */
-static unsigned int	cpu_set_freq[NR_CPUS]; /* CPU freq desired by userspace */
-static unsigned int	cpu_is_managed[NR_CPUS];
+static DEFINE_PER_CPU(unsigned int, cpu_max_freq);
+static DEFINE_PER_CPU(unsigned int, cpu_min_freq);
+static DEFINE_PER_CPU(unsigned int, cpu_cur_freq); /* current CPU freq */
+static DEFINE_PER_CPU(unsigned int, cpu_set_freq); /* CPU freq desired by
+							userspace */
+static DEFINE_PER_CPU(unsigned int, cpu_is_managed);
 
 static DEFINE_MUTEX	(userspace_mutex);
 static int cpus_using_userspace_governor;
 
-#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "userspace", msg)
+#define dprintk(msg...) \
+	cpufreq_debug_printk(CPUFREQ_DEBUG_GOVERNOR, "userspace", msg)
 
 /* keep track of frequency transitions */
 static int
@@ -48,12 +50,12 @@ userspace_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
 {
         struct cpufreq_freqs *freq = data;
 
-	if (!cpu_is_managed[freq->cpu])
+	if (!per_cpu(cpu_is_managed, freq->cpu))
 		return 0;
 
 	dprintk("saving cpu_cur_freq of cpu %u to be %u kHz\n",
 			freq->cpu, freq->new);
-	cpu_cur_freq[freq->cpu] = freq->new;
+	per_cpu(cpu_cur_freq, freq->cpu) = freq->new;
 
         return 0;
 }
@@ -77,15 +79,15 @@ static int cpufreq_set(struct cpufreq_policy *policy, unsigned int freq)
 	dprintk("cpufreq_set for cpu %u, freq %u kHz\n", policy->cpu, freq);
 
 	mutex_lock(&userspace_mutex);
-	if (!cpu_is_managed[policy->cpu])
+	if (!per_cpu(cpu_is_managed, policy->cpu))
 		goto err;
 
-	cpu_set_freq[policy->cpu] = freq;
+	per_cpu(cpu_set_freq, policy->cpu) = freq;
 
-	if (freq < cpu_min_freq[policy->cpu])
-		freq = cpu_min_freq[policy->cpu];
-	if (freq > cpu_max_freq[policy->cpu])
-		freq = cpu_max_freq[policy->cpu];
+	if (freq < per_cpu(cpu_min_freq, policy->cpu))
+		freq = per_cpu(cpu_min_freq, policy->cpu);
+	if (freq > per_cpu(cpu_max_freq, policy->cpu))
+		freq = per_cpu(cpu_max_freq, policy->cpu);
 
 	/*
 	 * We're safe from concurrent calls to ->target() here
@@ -104,7 +106,7 @@ static int cpufreq_set(struct cpufreq_policy *policy, unsigned int freq)
 
 static ssize_t show_speed(struct cpufreq_policy *policy, char *buf)
 {
-	return sprintf(buf, "%u\n", cpu_cur_freq[policy->cpu]);
+	return sprintf(buf, "%u\n", per_cpu(cpu_cur_freq, policy->cpu));
 }
 
 static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
@@ -127,12 +129,17 @@ static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
 		}
 		cpus_using_userspace_governor++;
 
-		cpu_is_managed[cpu] = 1;
-		cpu_min_freq[cpu] = policy->min;
-		cpu_max_freq[cpu] = policy->max;
-		cpu_cur_freq[cpu] = policy->cur;
-		cpu_set_freq[cpu] = policy->cur;
-		dprintk("managing cpu %u started (%u - %u kHz, currently %u kHz)\n", cpu, cpu_min_freq[cpu], cpu_max_freq[cpu], cpu_cur_freq[cpu]);
+		per_cpu(cpu_is_managed, cpu) = 1;
+		per_cpu(cpu_min_freq, cpu) = policy->min;
+		per_cpu(cpu_max_freq, cpu) = policy->max;
+		per_cpu(cpu_cur_freq, cpu) = policy->cur;
+		per_cpu(cpu_set_freq, cpu) = policy->cur;
+		dprintk("managing cpu %u started "
+			"(%u - %u kHz, currently %u kHz)\n",
+				cpu,
+				per_cpu(cpu_min_freq, cpu),
+				per_cpu(cpu_max_freq, cpu),
+				per_cpu(cpu_cur_freq, cpu));
 
 		mutex_unlock(&userspace_mutex);
 		break;
@@ -145,34 +152,34 @@ static int cpufreq_governor_userspace(struct cpufreq_policy *policy,
 					CPUFREQ_TRANSITION_NOTIFIER);
 		}
 
-		cpu_is_managed[cpu] = 0;
-		cpu_min_freq[cpu] = 0;
-		cpu_max_freq[cpu] = 0;
-		cpu_set_freq[cpu] = 0;
+		per_cpu(cpu_is_managed, cpu) = 0;
+		per_cpu(cpu_min_freq, cpu) = 0;
+		per_cpu(cpu_max_freq, cpu) = 0;
+		per_cpu(cpu_set_freq, cpu) = 0;
 		dprintk("managing cpu %u stopped\n", cpu);
 		mutex_unlock(&userspace_mutex);
 		break;
 	case CPUFREQ_GOV_LIMITS:
 		mutex_lock(&userspace_mutex);
-		dprintk("limit event for cpu %u: %u - %u kHz,"
+		dprintk("limit event for cpu %u: %u - %u kHz, "
 			"currently %u kHz, last set to %u kHz\n",
 			cpu, policy->min, policy->max,
-			cpu_cur_freq[cpu], cpu_set_freq[cpu]);
-		if (policy->max < cpu_set_freq[cpu]) {
+			per_cpu(cpu_cur_freq, cpu),
+			per_cpu(cpu_set_freq, cpu));
+		if (policy->max < per_cpu(cpu_set_freq, cpu)) {
 			__cpufreq_driver_target(policy, policy->max,
 						CPUFREQ_RELATION_H);
-		}
-		else if (policy->min > cpu_set_freq[cpu]) {
+		} else if (policy->min > per_cpu(cpu_set_freq, cpu)) {
 			__cpufreq_driver_target(policy, policy->min,
 						CPUFREQ_RELATION_L);
-		}
-		else {
-			__cpufreq_driver_target(policy, cpu_set_freq[cpu],
+		} else {
+			__cpufreq_driver_target(policy,
+						per_cpu(cpu_set_freq, cpu),
 						CPUFREQ_RELATION_L);
 		}
-		cpu_min_freq[cpu] = policy->min;
-		cpu_max_freq[cpu] = policy->max;
-		cpu_cur_freq[cpu] = policy->cur;
+		per_cpu(cpu_min_freq, cpu) = policy->min;
+		per_cpu(cpu_max_freq, cpu) = policy->max;
+		per_cpu(cpu_cur_freq, cpu) = policy->cur;
 		mutex_unlock(&userspace_mutex);
 		break;
 	}
diff --git a/drivers/firmware/dcdbas.c b/drivers/firmware/dcdbas.c
index 25918f7..0b624e9 100644
--- a/drivers/firmware/dcdbas.c
+++ b/drivers/firmware/dcdbas.c
@@ -254,6 +254,7 @@ static ssize_t host_control_on_shutdown_store(struct device *dev,
 static int smi_request(struct smi_cmd *smi_cmd)
 {
 	cpumask_t old_mask;
+	cpumask_of_cpu_ptr(new_mask, 0);
 	int ret = 0;
 
 	if (smi_cmd->magic != SMI_CMD_MAGIC) {
@@ -264,7 +265,7 @@ static int smi_request(struct smi_cmd *smi_cmd)
 
 	/* SMI requires CPU 0 */
 	old_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(0));
+	set_cpus_allowed_ptr(current, new_mask);
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
 			__func__);
diff --git a/drivers/infiniband/hw/ehca/ehca_irq.c b/drivers/infiniband/hw/ehca/ehca_irq.c
index 0792d93..7a64aa9 100644
--- a/drivers/infiniband/hw/ehca/ehca_irq.c
+++ b/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -646,8 +646,8 @@ static inline int find_next_online_cpu(struct ehca_comp_pool *pool)
 		ehca_dmp(&cpu_online_map, sizeof(cpumask_t), "");
 
 	spin_lock_irqsave(&pool->last_cpu_lock, flags);
-	cpu = next_cpu(pool->last_cpu, cpu_online_map);
-	if (cpu == NR_CPUS)
+	cpu = next_cpu_nr(pool->last_cpu, cpu_online_map);
+	if (cpu >= nr_cpu_ids)
 		cpu = first_cpu(cpu_online_map);
 	pool->last_cpu = cpu;
 	spin_unlock_irqrestore(&pool->last_cpu_lock, flags);
diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
index 08256ed..579b01f 100644
--- a/drivers/misc/sgi-xp/xpc_main.c
+++ b/drivers/misc/sgi-xp/xpc_main.c
@@ -229,10 +229,11 @@ xpc_hb_checker(void *ignore)
 	int last_IRQ_count = 0;
 	int new_IRQ_count;
 	int force_IRQ = 0;
+	cpumask_of_cpu_ptr(cpumask, XPC_HB_CHECK_CPU);
 
 	/* this thread was marked active by xpc_hb_init() */
 
-	set_cpus_allowed(current, cpumask_of_cpu(XPC_HB_CHECK_CPU));
+	set_cpus_allowed_ptr(current, cpumask);
 
 	/* set our heartbeating to other partitions into motion */
 	xpc_hb_check_timeout = jiffies + (xpc_hb_check_interval * HZ);
diff --git a/include/asm-x86/ipi.h b/include/asm-x86/ipi.h
index 196d63c..bb1c09f 100644
--- a/include/asm-x86/ipi.h
+++ b/include/asm-x86/ipi.h
@@ -122,7 +122,7 @@ static inline void send_IPI_mask_sequence(cpumask_t mask, int vector)
 	 * - mbligh
 	 */
 	local_irq_save(flags);
-	for_each_cpu_mask(query_cpu, mask) {
+	for_each_cpu_mask_nr(query_cpu, mask) {
 		__send_IPI_dest_field(per_cpu(x86_cpu_to_apicid, query_cpu),
 				      vector, APIC_DEST_PHYSICAL);
 	}
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 55402d2..f92315e 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -134,7 +134,7 @@ extern __u32			cleared_cpu_caps[NCAPINTS];
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
 #define cpu_data(cpu)		per_cpu(cpu_info, cpu)
-#define current_cpu_data	cpu_data(smp_processor_id())
+#define current_cpu_data	__get_cpu_var(cpu_info)
 #else
 #define cpu_data(cpu)		boot_cpu_data
 #define current_cpu_data	boot_cpu_data
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index c24875b..30d59d1 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -17,6 +17,20 @@
  * For details of cpus_onto(), see bitmap_onto in lib/bitmap.c.
  * For details of cpus_fold(), see bitmap_fold in lib/bitmap.c.
  *
+ * . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
+ * Note: The alternate operations with the suffix "_nr" are used
+ *       to limit the range of the loop to nr_cpu_ids instead of
+ *       NR_CPUS when NR_CPUS > 64 for performance reasons.
+ *       If NR_CPUS is <= 64 then most assembler bitmask
+ *       operators execute faster with a constant range, so
+ *       the operator will continue to use NR_CPUS.
+ *
+ *       Another consideration is that nr_cpu_ids is initialized
+ *       to NR_CPUS and isn't lowered until the possible cpus are
+ *       discovered (including any disabled cpus).  So early uses
+ *       will span the entire range of NR_CPUS.
+ * . . . . . . . . . . . . . . . . . . . . . . . . . . . . . . .
+ *
  * The available cpumask operations are:
  *
  * void cpu_set(cpu, mask)		turn on bit 'cpu' in mask
@@ -38,18 +52,60 @@
  * int cpus_empty(mask)			Is mask empty (no bits sets)?
  * int cpus_full(mask)			Is mask full (all bits sets)?
  * int cpus_weight(mask)		Hamming weigh - number of set bits
+ * int cpus_weight_nr(mask)		Same using nr_cpu_ids instead of NR_CPUS
  *
  * void cpus_shift_right(dst, src, n)	Shift right
  * void cpus_shift_left(dst, src, n)	Shift left
  *
  * int first_cpu(mask)			Number lowest set bit, or NR_CPUS
  * int next_cpu(cpu, mask)		Next cpu past 'cpu', or NR_CPUS
+ * int next_cpu_nr(cpu, mask)		Next cpu past 'cpu', or nr_cpu_ids
  *
  * cpumask_t cpumask_of_cpu(cpu)	Return cpumask with bit 'cpu' set
+ *ifdef CONFIG_HAS_CPUMASK_OF_CPU
+ * cpumask_of_cpu_ptr_declare(v)	Declares cpumask_t *v
+ * cpumask_of_cpu_ptr_next(v, cpu)	Sets v = &cpumask_of_cpu_map[cpu]
+ * cpumask_of_cpu_ptr(v, cpu)		Combines above two operations
+ *else
+ * cpumask_of_cpu_ptr_declare(v)	Declares cpumask_t _v and *v = &_v
+ * cpumask_of_cpu_ptr_next(v, cpu)	Sets _v = cpumask_of_cpu(cpu)
+ * cpumask_of_cpu_ptr(v, cpu)		Combines above two operations
+ *endif
  * CPU_MASK_ALL				Initializer - all bits set
  * CPU_MASK_NONE			Initializer - no bits set
  * unsigned long *cpus_addr(mask)	Array of unsigned long's in mask
  *
+ * CPUMASK_ALLOC kmalloc's a structure that is a composite of many cpumask_t
+ * variables, and CPUMASK_PTR provides pointers to each field.
+ *
+ * The structure should be defined something like this:
+ * struct my_cpumasks {
+ *	cpumask_t mask1;
+ *	cpumask_t mask2;
+ * };
+ *
+ * Usage is then:
+ *	CPUMASK_ALLOC(my_cpumasks);
+ *	CPUMASK_PTR(mask1, my_cpumasks);
+ *	CPUMASK_PTR(mask2, my_cpumasks);
+ *
+ *	--- DO NOT reference cpumask_t pointers until this check ---
+ *	if (my_cpumasks == NULL)
+ *		"kmalloc failed"...
+ *
+ * References are now pointers to the cpumask_t variables (*mask1, ...)
+ *
+ *if NR_CPUS > BITS_PER_LONG
+ *   CPUMASK_ALLOC(m)			Declares and allocates struct m *m =
+ *						kmalloc(sizeof(*m), GFP_KERNEL)
+ *   CPUMASK_FREE(m)			Macro for kfree(m)
+ *else
+ *   CPUMASK_ALLOC(m)			Declares struct m _m, *m = &_m
+ *   CPUMASK_FREE(m)			Nop
+ *endif
+ *   CPUMASK_PTR(v, m)			Declares cpumask_t *v = &(m->v)
+ * ------------------------------------------------------------------------
+ *
  * int cpumask_scnprintf(buf, len, mask) Format cpumask for printing
  * int cpumask_parse_user(ubuf, ulen, mask)	Parse ascii string as cpumask
  * int cpulist_scnprintf(buf, len, mask) Format cpumask as list for printing
@@ -59,7 +115,8 @@
  * void cpus_onto(dst, orig, relmap)	*dst = orig relative to relmap
  * void cpus_fold(dst, orig, sz)	dst bits = orig bits mod sz
  *
- * for_each_cpu_mask(cpu, mask)		for-loop cpu over mask
+ * for_each_cpu_mask(cpu, mask)		for-loop cpu over mask using NR_CPUS
+ * for_each_cpu_mask_nr(cpu, mask)	for-loop cpu over mask using nr_cpu_ids
  *
  * int num_online_cpus()		Number of online CPUs
  * int num_possible_cpus()		Number of all possible CPUs
@@ -216,23 +273,19 @@ static inline void __cpus_shift_left(cpumask_t *dstp,
 	bitmap_shift_left(dstp->bits, srcp->bits, n, nbits);
 }
 
-#ifdef CONFIG_SMP
-int __first_cpu(const cpumask_t *srcp);
-#define first_cpu(src) __first_cpu(&(src))
-int __next_cpu(int n, const cpumask_t *srcp);
-#define next_cpu(n, src) __next_cpu((n), &(src))
-#else
-#define first_cpu(src)		({ (void)(src); 0; })
-#define next_cpu(n, src)	({ (void)(src); 1; })
-#endif
 
 #ifdef CONFIG_HAVE_CPUMASK_OF_CPU_MAP
 extern cpumask_t *cpumask_of_cpu_map;
-#define cpumask_of_cpu(cpu)    (cpumask_of_cpu_map[cpu])
-
+#define cpumask_of_cpu(cpu)	(cpumask_of_cpu_map[cpu])
+#define	cpumask_of_cpu_ptr(v, cpu)					\
+		const cpumask_t *v = &cpumask_of_cpu(cpu)
+#define	cpumask_of_cpu_ptr_declare(v)					\
+		const cpumask_t *v
+#define cpumask_of_cpu_ptr_next(v, cpu)					\
+					v = &cpumask_of_cpu(cpu)
 #else
 #define cpumask_of_cpu(cpu)						\
-(*({									\
+({									\
 	typeof(_unused_cpumask_arg_) m;					\
 	if (sizeof(m) == sizeof(unsigned long)) {			\
 		m.bits[0] = 1UL<<(cpu);					\
@@ -240,8 +293,16 @@ extern cpumask_t *cpumask_of_cpu_map;
 		cpus_clear(m);						\
 		cpu_set((cpu), m);					\
 	}								\
-	&m;								\
-}))
+	m;								\
+})
+#define	cpumask_of_cpu_ptr(v, cpu) 					\
+		cpumask_t _##v = cpumask_of_cpu(cpu);			\
+		const cpumask_t *v = &_##v
+#define	cpumask_of_cpu_ptr_declare(v)					\
+		cpumask_t _##v;						\
+		const cpumask_t *v = &_##v
+#define cpumask_of_cpu_ptr_next(v, cpu)					\
+					_##v = cpumask_of_cpu(cpu)
 #endif
 
 #define CPU_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(NR_CPUS)
@@ -281,6 +342,15 @@ extern cpumask_t cpu_mask_all;
 
 #define cpus_addr(src) ((src).bits)
 
+#if NR_CPUS > BITS_PER_LONG
+#define	CPUMASK_ALLOC(m)	struct m *m = kmalloc(sizeof(*m), GFP_KERNEL)
+#define	CPUMASK_FREE(m)		kfree(m)
+#else
+#define	CPUMASK_ALLOC(m)	struct m _m, *m = &_m
+#define	CPUMASK_FREE(m)
+#endif
+#define	CPUMASK_PTR(v, m) 	cpumask_t *v = &(m->v)
+
 #define cpumask_scnprintf(buf, len, src) \
 			__cpumask_scnprintf((buf), (len), &(src), NR_CPUS)
 static inline int __cpumask_scnprintf(char *buf, int len,
@@ -343,20 +413,49 @@ static inline void __cpus_fold(cpumask_t *dstp, const cpumask_t *origp,
 	bitmap_fold(dstp->bits, origp->bits, sz, nbits);
 }
 
-#if NR_CPUS > 1
-#define for_each_cpu_mask(cpu, mask)		\
-	for ((cpu) = first_cpu(mask);		\
-		(cpu) < NR_CPUS;		\
-		(cpu) = next_cpu((cpu), (mask)))
-#else /* NR_CPUS == 1 */
-#define for_each_cpu_mask(cpu, mask)		\
+#if NR_CPUS == 1
+
+#define nr_cpu_ids		1
+#define first_cpu(src)		({ (void)(src); 0; })
+#define next_cpu(n, src)	({ (void)(src); 1; })
+#define any_online_cpu(mask)	0
+#define for_each_cpu_mask(cpu, mask)	\
 	for ((cpu) = 0; (cpu) < 1; (cpu)++, (void)mask)
-#endif /* NR_CPUS */
+
+#else /* NR_CPUS > 1 */
+
+extern int nr_cpu_ids;
+int __first_cpu(const cpumask_t *srcp);
+int __next_cpu(int n, const cpumask_t *srcp);
+int __any_online_cpu(const cpumask_t *mask);
+
+#define first_cpu(src)		__first_cpu(&(src))
+#define next_cpu(n, src)	__next_cpu((n), &(src))
+#define any_online_cpu(mask) __any_online_cpu(&(mask))
+#define for_each_cpu_mask(cpu, mask)			\
+	for ((cpu) = -1;				\
+		(cpu) = next_cpu((cpu), (mask)),	\
+		(cpu) < NR_CPUS; )
+#endif
+
+#if NR_CPUS <= 64
 
 #define next_cpu_nr(n, src)		next_cpu(n, src)
 #define cpus_weight_nr(cpumask)		cpus_weight(cpumask)
 #define for_each_cpu_mask_nr(cpu, mask)	for_each_cpu_mask(cpu, mask)
 
+#else /* NR_CPUS > 64 */
+
+int __next_cpu_nr(int n, const cpumask_t *srcp);
+#define next_cpu_nr(n, src)	__next_cpu_nr((n), &(src))
+#define cpus_weight_nr(cpumask)	__cpus_weight(&(cpumask), nr_cpu_ids)
+#define for_each_cpu_mask_nr(cpu, mask)			\
+	for ((cpu) = -1;				\
+		(cpu) = next_cpu_nr((cpu), (mask)),	\
+		(cpu) < nr_cpu_ids; )
+
+#endif /* NR_CPUS > 64 */
+
 /*
  * The following particular system cpumasks and operations manage
  * possible, present and online cpus.  Each of them is a fixed size
@@ -418,9 +517,9 @@ extern cpumask_t cpu_online_map;
 extern cpumask_t cpu_present_map;
 
 #if NR_CPUS > 1
-#define num_online_cpus()	cpus_weight(cpu_online_map)
-#define num_possible_cpus()	cpus_weight(cpu_possible_map)
-#define num_present_cpus()	cpus_weight(cpu_present_map)
+#define num_online_cpus()	cpus_weight_nr(cpu_online_map)
+#define num_possible_cpus()	cpus_weight_nr(cpu_possible_map)
+#define num_present_cpus()	cpus_weight_nr(cpu_present_map)
 #define cpu_online(cpu)		cpu_isset((cpu), cpu_online_map)
 #define cpu_possible(cpu)	cpu_isset((cpu), cpu_possible_map)
 #define cpu_present(cpu)	cpu_isset((cpu), cpu_present_map)
@@ -435,17 +534,8 @@ extern cpumask_t cpu_present_map;
 
 #define cpu_is_offline(cpu)	unlikely(!cpu_online(cpu))
 
-#ifdef CONFIG_SMP
-extern int nr_cpu_ids;
-#define any_online_cpu(mask) __any_online_cpu(&(mask))
-int __any_online_cpu(const cpumask_t *mask);
-#else
-#define nr_cpu_ids			1
-#define any_online_cpu(mask)		0
-#endif
-
-#define for_each_possible_cpu(cpu)  for_each_cpu_mask((cpu), cpu_possible_map)
-#define for_each_online_cpu(cpu)  for_each_cpu_mask((cpu), cpu_online_map)
-#define for_each_present_cpu(cpu) for_each_cpu_mask((cpu), cpu_present_map)
+#define for_each_possible_cpu(cpu) for_each_cpu_mask_nr((cpu), cpu_possible_map)
+#define for_each_online_cpu(cpu)   for_each_cpu_mask_nr((cpu), cpu_online_map)
+#define for_each_present_cpu(cpu)  for_each_cpu_mask_nr((cpu), cpu_present_map)
 
 #endif /* __LINUX_CPUMASK_H */
diff --git a/kernel/cpu.c b/kernel/cpu.c
index cfb1d43..d26d0b0 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -413,7 +413,7 @@ void __ref enable_nonboot_cpus(void)
 		goto out;
 
 	printk("Enabling non-boot CPUs ...\n");
-	for_each_cpu_mask(cpu, frozen_cpus) {
+	for_each_cpu_mask_nr(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
 			printk("CPU%d is up\n", cpu);
diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
index 16eeeaa..6f8696c 100644
--- a/kernel/rcuclassic.c
+++ b/kernel/rcuclassic.c
@@ -106,7 +106,7 @@ static void force_quiescent_state(struct rcu_data *rdp,
 		 */
 		cpus_and(cpumask, rcp->cpumask, cpu_online_map);
 		cpu_clear(rdp->cpu, cpumask);
-		for_each_cpu_mask(cpu, cpumask)
+		for_each_cpu_mask_nr(cpu, cpumask)
 			smp_send_reschedule(cpu);
 	}
 }
diff --git a/kernel/rcupreempt.c b/kernel/rcupreempt.c
index 6f62b77..2782793 100644
--- a/kernel/rcupreempt.c
+++ b/kernel/rcupreempt.c
@@ -756,7 +756,7 @@ rcu_try_flip_idle(void)
 
 	/* Now ask each CPU for acknowledgement of the flip. */
 
-	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
 		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -774,7 +774,7 @@ rcu_try_flip_waitack(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
-	for_each_cpu_mask(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
 		if (rcu_try_flip_waitack_needed(cpu) &&
 		    per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
@@ -806,7 +806,7 @@ rcu_try_flip_waitzero(void)
 	/* Check to see if the sum of the "last" counters is zero. */
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_z1);
-	for_each_cpu_mask(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
 		sum += RCU_DATA_CPU(cpu)->rcu_flipctr[lastidx];
 	if (sum != 0) {
 		RCU_TRACE_ME(rcupreempt_trace_try_flip_ze1);
@@ -821,7 +821,7 @@ rcu_try_flip_waitzero(void)
 	smp_mb();  /*  ^^^^^^^^^^^^ */
 
 	/* Call for a memory barrier from each CPU. */
-	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
 		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -841,7 +841,7 @@ rcu_try_flip_waitmb(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
-	for_each_cpu_mask(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
 		if (rcu_try_flip_waitmb_needed(cpu) &&
 		    per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
diff --git a/kernel/sched.c b/kernel/sched.c
index 99e6d85..a6d0a7f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2108,7 +2108,7 @@ find_idlest_group(struct sched_domain *sd, struct task_struct *p, int this_cpu)
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
 
-		for_each_cpu_mask(i, group->cpumask) {
+		for_each_cpu_mask_nr(i, group->cpumask) {
 			/* Bias balancing toward cpus of our domain */
 			if (local_group)
 				load = source_load(i, load_idx);
@@ -2150,7 +2150,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu,
 	/* Traverse only the allowed CPUs */
 	cpus_and(*tmp, group->cpumask, p->cpus_allowed);
 
-	for_each_cpu_mask(i, *tmp) {
+	for_each_cpu_mask_nr(i, *tmp) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -3168,7 +3168,7 @@ find_busiest_group(struct sched_domain *sd, int this_cpu,
 		max_cpu_load = 0;
 		min_cpu_load = ~0UL;
 
-		for_each_cpu_mask(i, group->cpumask) {
+		for_each_cpu_mask_nr(i, group->cpumask) {
 			struct rq *rq;
 
 			if (!cpu_isset(i, *cpus))
@@ -3447,7 +3447,7 @@ find_busiest_queue(struct sched_group *group, enum cpu_idle_type idle,
 	unsigned long max_load = 0;
 	int i;
 
-	for_each_cpu_mask(i, group->cpumask) {
+	for_each_cpu_mask_nr(i, group->cpumask) {
 		unsigned long wl;
 
 		if (!cpu_isset(i, *cpus))
@@ -3989,7 +3989,7 @@ static void run_rebalance_domains(struct softirq_action *h)
 		int balance_cpu;
 
 		cpu_clear(this_cpu, cpus);
-		for_each_cpu_mask(balance_cpu, cpus) {
+		for_each_cpu_mask_nr(balance_cpu, cpus) {
 			/*
 			 * If this cpu gets work to do, stop the load balancing
 			 * work being done for other cpus. Next load
@@ -6802,7 +6802,7 @@ init_sched_build_groups(const cpumask_t *span, const cpumask_t *cpu_map,
 
 	cpus_clear(*covered);
 
-	for_each_cpu_mask(i, *span) {
+	for_each_cpu_mask_nr(i, *span) {
 		struct sched_group *sg;
 		int group = group_fn(i, cpu_map, &sg, tmpmask);
 		int j;
@@ -6813,7 +6813,7 @@ init_sched_build_groups(const cpumask_t *span, const cpumask_t *cpu_map,
 		cpus_clear(sg->cpumask);
 		sg->__cpu_power = 0;
 
-		for_each_cpu_mask(j, *span) {
+		for_each_cpu_mask_nr(j, *span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
 				continue;
 
@@ -7013,7 +7013,7 @@ static void init_numa_sched_groups_power(struct sched_group *group_head)
 	if (!sg)
 		return;
 	do {
-		for_each_cpu_mask(j, sg->cpumask) {
+		for_each_cpu_mask_nr(j, sg->cpumask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(phys_domains, j);
@@ -7038,7 +7038,7 @@ static void free_sched_groups(const cpumask_t *cpu_map, cpumask_t *nodemask)
 {
 	int cpu, i;
 
-	for_each_cpu_mask(cpu, *cpu_map) {
+	for_each_cpu_mask_nr(cpu, *cpu_map) {
 		struct sched_group **sched_group_nodes
 			= sched_group_nodes_bycpu[cpu];
 
@@ -7277,7 +7277,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = NULL, *p;
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
 
@@ -7344,7 +7344,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7361,7 +7361,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		SCHED_CPUMASK_VAR(this_core_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7428,7 +7428,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 			goto error;
 		}
 		sched_group_nodes[i] = sg;
-		for_each_cpu_mask(j, *nodemask) {
+		for_each_cpu_mask_nr(j, *nodemask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j);
@@ -7474,21 +7474,21 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(cpu_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 #ifdef CONFIG_SCHED_MC
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(core_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(phys_domains, i);
 
 		init_sched_groups_power(i, sd);
@@ -7508,7 +7508,7 @@ static int __build_sched_domains(const cpumask_t *cpu_map,
 #endif
 
 	/* Attach the domains */
-	for_each_cpu_mask(i, *cpu_map) {
+	for_each_cpu_mask_nr(i, *cpu_map) {
 		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
 		sd = &per_cpu(cpu_domains, i);
@@ -7603,7 +7603,7 @@ static void detach_destroy_domains(const cpumask_t *cpu_map)
 
 	unregister_sched_domain_sysctl();
 
-	for_each_cpu_mask(i, *cpu_map)
+	for_each_cpu_mask_nr(i, *cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
 	arch_destroy_sched_domains(cpu_map, &tmpmask);
diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index f2aa987..bb61fe2 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -1031,7 +1031,7 @@ static int wake_idle(int cpu, struct task_struct *p)
 		    || ((sd->flags & SD_WAKE_IDLE_FAR)
 			&& !task_hot(p, task_rq(p)->clock, sd))) {
 			cpus_and(tmp, sd->span, p->cpus_allowed);
-			for_each_cpu_mask(i, tmp) {
+			for_each_cpu_mask_nr(i, tmp) {
 				if (idle_cpu(i)) {
 					if (i != task_cpu(p)) {
 						schedstat_inc(p,
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 47ceac9..7c96147 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -240,7 +240,7 @@ static int do_balance_runtime(struct rt_rq *rt_rq)
 
 	spin_lock(&rt_b->rt_runtime_lock);
 	rt_period = ktime_to_ns(rt_b->rt_period);
-	for_each_cpu_mask(i, rd->span) {
+	for_each_cpu_mask_nr(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 		s64 diff;
 
@@ -1107,7 +1107,7 @@ static int pull_rt_task(struct rq *this_rq)
 
 	next = pick_next_task_rt(this_rq);
 
-	for_each_cpu_mask(cpu, this_rq->rd->rto_mask) {
+	for_each_cpu_mask_nr(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
 
diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index ba9b205..738b411 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -33,8 +33,9 @@ static int stopmachine(void *cpu)
 {
 	int irqs_disabled = 0;
 	int prepared = 0;
+	cpumask_of_cpu_ptr(cpumask, (int)(long)cpu);
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu((int)(long)cpu));
+	set_cpus_allowed_ptr(current, cpumask);
 
 	/* Ack: we are alive */
 	smp_mb(); /* Theoretically the ack = 0 might not be on this CPU yet. */
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 4a23517..06b1754 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -301,7 +301,7 @@ static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
 		return -EINVAL;
 
 	if (isadd == REGISTER) {
-		for_each_cpu_mask(cpu, mask) {
+		for_each_cpu_mask_nr(cpu, mask) {
 			s = kmalloc_node(sizeof(struct listener), GFP_KERNEL,
 					 cpu_to_node(cpu));
 			if (!s)
@@ -320,7 +320,7 @@ static int add_del_listener(pid_t pid, cpumask_t *maskp, int isadd)
 
 	/* Deregister or cleanup */
 cleanup:
-	for_each_cpu_mask(cpu, mask) {
+	for_each_cpu_mask_nr(cpu, mask) {
 		listeners = &per_cpu(listener_array, cpu);
 		down_write(&listeners->sem);
 		list_for_each_entry_safe(s, tmp, &listeners->list, list) {
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index dadde53..60ceabd 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -145,9 +145,9 @@ static void clocksource_watchdog(unsigned long data)
 		 * Cycle through CPUs to check if the CPUs stay
 		 * synchronized to each other.
 		 */
-		int next_cpu = next_cpu(raw_smp_processor_id(), cpu_online_map);
+		int next_cpu = next_cpu_nr(raw_smp_processor_id(), cpu_online_map);
 
-		if (next_cpu >= NR_CPUS)
+		if (next_cpu >= nr_cpu_ids)
 			next_cpu = first_cpu(cpu_online_map);
 		watchdog_timer.expires += WATCHDOG_INTERVAL;
 		add_timer_on(&watchdog_timer, next_cpu);
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index f48d0f0..31463d3 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -399,8 +399,7 @@ again:
 	mask = CPU_MASK_NONE;
 	now = ktime_get();
 	/* Find all expired events */
-	for (cpu = first_cpu(tick_broadcast_oneshot_mask); cpu != NR_CPUS;
-	     cpu = next_cpu(cpu, tick_broadcast_oneshot_mask)) {
+	for_each_cpu_mask_nr(cpu, tick_broadcast_oneshot_mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
 			cpu_set(cpu, mask);
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 4f38865..bf43284 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -135,7 +135,7 @@ void tick_setup_periodic(struct clock_event_device *dev, int broadcast)
  */
 static void tick_setup_device(struct tick_device *td,
 			      struct clock_event_device *newdev, int cpu,
-			      cpumask_t cpumask)
+			      const cpumask_t *cpumask)
 {
 	ktime_t next_event;
 	void (*handler)(struct clock_event_device *) = NULL;
@@ -169,8 +169,8 @@ static void tick_setup_device(struct tick_device *td,
 	 * When the device is not per cpu, pin the interrupt to the
 	 * current cpu:
 	 */
-	if (!cpus_equal(newdev->cpumask, cpumask))
-		irq_set_affinity(newdev->irq, cpumask);
+	if (!cpus_equal(newdev->cpumask, *cpumask))
+		irq_set_affinity(newdev->irq, *cpumask);
 
 	/*
 	 * When global broadcasting is active, check if the current
@@ -196,20 +196,20 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 	struct tick_device *td;
 	int cpu, ret = NOTIFY_OK;
 	unsigned long flags;
-	cpumask_t cpumask;
+	cpumask_of_cpu_ptr_declare(cpumask);
 
 	spin_lock_irqsave(&tick_device_lock, flags);
 
 	cpu = smp_processor_id();
+	cpumask_of_cpu_ptr_next(cpumask, cpu);
 	if (!cpu_isset(cpu, newdev->cpumask))
 		goto out_bc;
 
 	td = &per_cpu(tick_cpu_device, cpu);
 	curdev = td->evtdev;
-	cpumask = cpumask_of_cpu(cpu);
 
 	/* cpu local device ? */
-	if (!cpus_equal(newdev->cpumask, cpumask)) {
+	if (!cpus_equal(newdev->cpumask, *cpumask)) {
 
 		/*
 		 * If the cpu affinity of the device interrupt can not
@@ -222,7 +222,7 @@ static int tick_check_new_device(struct clock_event_device *newdev)
 		 * If we have a cpu local device already, do not replace it
 		 * by a non cpu local device
 		 */
-		if (curdev && cpus_equal(curdev->cpumask, cpumask))
+		if (curdev && cpus_equal(curdev->cpumask, *cpumask))
 			goto out_bc;
 	}
 
diff --git a/kernel/trace/trace_sysprof.c b/kernel/trace/trace_sysprof.c
index 2301e1e..6352808 100644
--- a/kernel/trace/trace_sysprof.c
+++ b/kernel/trace/trace_sysprof.c
@@ -213,7 +213,9 @@ static void start_stack_timers(void)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+		cpumask_of_cpu_ptr(new_mask, cpu);
+
+		set_cpus_allowed_ptr(current, new_mask);
 		start_stack_timer(cpu);
 	}
 	set_cpus_allowed_ptr(current, &saved_mask);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ce77995..a6d3634 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -397,7 +397,7 @@ void flush_workqueue(struct workqueue_struct *wq)
 	might_sleep();
 	lock_acquire(&wq->lockdep_map, 0, 0, 0, 2, _THIS_IP_);
 	lock_release(&wq->lockdep_map, 1, _THIS_IP_);
-	for_each_cpu_mask(cpu, *cpu_map)
+	for_each_cpu_mask_nr(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -477,7 +477,7 @@ static void wait_on_work(struct work_struct *work)
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu_mask(cpu, *cpu_map)
+	for_each_cpu_mask_nr(cpu, *cpu_map)
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
@@ -813,7 +813,7 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu_mask(cpu, *cpu_map)
+	for_each_cpu_mask_nr(cpu, *cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
 	put_online_cpus();
 
diff --git a/lib/cpumask.c b/lib/cpumask.c
index bb4f76d..5f97dc2 100644
--- a/lib/cpumask.c
+++ b/lib/cpumask.c
@@ -15,6 +15,15 @@ int __next_cpu(int n, const cpumask_t *srcp)
 }
 EXPORT_SYMBOL(__next_cpu);
 
+#if NR_CPUS > 64
+int __next_cpu_nr(int n, const cpumask_t *srcp)
+{
+	return min_t(int, nr_cpu_ids,
+				find_next_bit(srcp->bits, nr_cpu_ids, n+1));
+}
+EXPORT_SYMBOL(__next_cpu_nr);
+#endif
+
 int __any_online_cpu(const cpumask_t *mask)
 {
 	int cpu;
diff --git a/lib/smp_processor_id.c b/lib/smp_processor_id.c
index 3b4dc09..c4381d9 100644
--- a/lib/smp_processor_id.c
+++ b/lib/smp_processor_id.c
@@ -11,7 +11,7 @@ notrace unsigned int debug_smp_processor_id(void)
 {
 	unsigned long preempt_count = preempt_count();
 	int this_cpu = raw_smp_processor_id();
-	cpumask_t this_mask;
+	cpumask_of_cpu_ptr_declare(this_mask);
 
 	if (likely(preempt_count))
 		goto out;
@@ -23,9 +23,9 @@ notrace unsigned int debug_smp_processor_id(void)
 	 * Kernel threads bound to a single CPU can safely use
 	 * smp_processor_id():
 	 */
-	this_mask = cpumask_of_cpu(this_cpu);
+	cpumask_of_cpu_ptr_next(this_mask, this_cpu);
 
-	if (cpus_equal(current->cpus_allowed, this_mask))
+	if (cpus_equal(current->cpus_allowed, *this_mask))
 		goto out;
 
 	/*
diff --git a/mm/allocpercpu.c b/mm/allocpercpu.c
index 05f2b40..8433645 100644
--- a/mm/allocpercpu.c
+++ b/mm/allocpercpu.c
@@ -35,7 +35,7 @@ EXPORT_SYMBOL_GPL(percpu_depopulate);
 void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
 {
 	int cpu;
-	for_each_cpu_mask(cpu, *mask)
+	for_each_cpu_mask_nr(cpu, *mask)
 		percpu_depopulate(__pdata, cpu);
 }
 EXPORT_SYMBOL_GPL(__percpu_depopulate_mask);
@@ -86,7 +86,7 @@ int __percpu_populate_mask(void *__pdata, size_t size, gfp_t gfp,
 	int cpu;
 
 	cpus_clear(populated);
-	for_each_cpu_mask(cpu, *mask)
+	for_each_cpu_mask_nr(cpu, *mask)
 		if (unlikely(!percpu_populate(__pdata, size, gfp, cpu))) {
 			__percpu_depopulate_mask(__pdata, &populated);
 			return -ENOMEM;
diff --git a/mm/vmstat.c b/mm/vmstat.c
index db9eabb..c3d4a78 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -26,7 +26,7 @@ static void sum_vm_events(unsigned long *ret, cpumask_t *cpumask)
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	for_each_cpu_mask(cpu, *cpumask) {
+	for_each_cpu_mask_nr(cpu, *cpumask) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
diff --git a/net/core/dev.c b/net/core/dev.c
index 2eed17b..106d5e6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2376,7 +2376,7 @@ out:
 	 */
 	if (!cpus_empty(net_dma.channel_mask)) {
 		int chan_idx;
-		for_each_cpu_mask(chan_idx, net_dma.channel_mask) {
+		for_each_cpu_mask_nr(chan_idx, net_dma.channel_mask) {
 			struct dma_chan *chan = net_dma.channels[chan_idx];
 			if (chan)
 				dma_async_memcpy_issue_pending(chan);
@@ -4510,7 +4510,7 @@ static void net_dma_rebalance(struct net_dma *net_dma)
 	i = 0;
 	cpu = first_cpu(cpu_online_map);
 
-	for_each_cpu_mask(chan_idx, net_dma->channel_mask) {
+	for_each_cpu_mask_nr(chan_idx, net_dma->channel_mask) {
 		chan = net_dma->channels[chan_idx];
 
 		n = ((num_online_cpus() / cpus_weight(net_dma->channel_mask))
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 265b1b2..705959b 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -497,7 +497,7 @@ static void iucv_setmask_up(void)
 	/* Disable all cpu but the first in cpu_irq_cpumask. */
 	cpumask = iucv_irq_cpumask;
 	cpu_clear(first_cpu(iucv_irq_cpumask), cpumask);
-	for_each_cpu_mask(cpu, cpumask)
+	for_each_cpu_mask_nr(cpu, cpumask)
 		smp_call_function_single(cpu, iucv_block_cpu, NULL, 1);
 }
 
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index 5a32cb7..835d274 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -310,7 +310,8 @@ svc_pool_map_set_cpumask(struct task_struct *task, unsigned int pidx)
 	switch (m->mode) {
 	case SVC_POOL_PERCPU:
 	{
-		set_cpus_allowed_ptr(task, &cpumask_of_cpu(node));
+		cpumask_of_cpu_ptr(cpumask, node);
+		set_cpus_allowed_ptr(task, cpumask);
 		break;
 	}
 	case SVC_POOL_PERNODE:
