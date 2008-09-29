Return-Path: <linux-kernel-owner+w=401wt.eu-S1755262AbYI2SG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262AbYI2SG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbYI2SDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:06 -0400
Received: from relay2.sgi.com ([192.48.171.30]:36461 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753957AbYI2SCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:52 -0400
Message-Id: <20080929180251.363067000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:02:59 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 09/31] cpumask: get rid of _nr functions
Content-Disposition: inline; filename=get-rid-of-_nr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |    6 +--
 arch/x86/kernel/cpu/cpufreq/p4-clockmod.c        |    6 +--
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    8 ++---
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |   10 +++---
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    4 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    2 -
 arch/x86/kernel/cpu/mcheck/mce_amd_64.c          |    4 +-
 arch/x86/kernel/io_apic.c                        |    8 ++---
 arch/x86/kernel/smpboot.c                        |    8 ++---
 arch/x86/xen/smp.c                               |    4 +-
 drivers/acpi/processor_throttling.c              |    6 +--
 drivers/cpufreq/cpufreq.c                        |   14 ++++----
 drivers/cpufreq/cpufreq_conservative.c           |    2 -
 drivers/cpufreq/cpufreq_ondemand.c               |    4 +-
 drivers/infiniband/hw/ehca/ehca_irq.c            |    2 -
 include/asm-x86/ipi.h                            |    4 +-
 kernel/cpu.c                                     |    2 -
 kernel/rcuclassic.c                              |    2 -
 kernel/rcupreempt.c                              |   10 +++---
 kernel/sched.c                                   |   36 +++++++++++------------
 kernel/sched_fair.c                              |    2 -
 kernel/sched_rt.c                                |    4 +-
 kernel/smp.c                                     |    2 -
 kernel/taskstats.c                               |    4 +-
 kernel/time/clocksource.c                        |    2 -
 kernel/time/tick-broadcast.c                     |    4 +-
 kernel/workqueue.c                               |    6 +--
 mm/allocpercpu.c                                 |    4 +-
 mm/quicklist.c                                   |    2 -
 mm/vmstat.c                                      |    2 -
 net/core/dev.c                                   |    4 +-
 net/iucv/iucv.c                                  |    2 -
 32 files changed, 90 insertions(+), 90 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -202,7 +202,7 @@ static void drv_write(struct drv_cmd *cm
 	cpumask_t saved_mask = current->cpus_allowed;
 	unsigned int i;
 
-	for_each_cpu_mask_nr(i, cmd->mask) {
+	for_each_cpu_mask(i, cmd->mask) {
 		set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
 		do_drv_write(cmd);
 	}
@@ -451,7 +451,7 @@ static int acpi_cpufreq_target(struct cp
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
 	freqs.new = data->freq_table[next_state].frequency;
-	for_each_cpu_mask_nr(i, cmd.mask) {
+	for_each_cpu_mask(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -466,7 +466,7 @@ static int acpi_cpufreq_target(struct cp
 		}
 	}
 
-	for_each_cpu_mask_nr(i, cmd.mask) {
+	for_each_cpu_mask(i, cmd.mask) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/p4-clockmod.c
@@ -122,7 +122,7 @@ static int cpufreq_p4_target(struct cpuf
 		return 0;
 
 	/* notifiers */
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu_mask(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -130,11 +130,11 @@ static int cpufreq_p4_target(struct cpuf
 	/* run on each logical CPU, see section 13.15.3 of IA32 Intel Architecture Software
 	 * Developer's Manual, Volume 3
 	 */
-	for_each_cpu_mask_nr(i, policy->cpus)
+	for_each_cpu_mask(i, policy->cpus)
 		cpufreq_p4_setdc(i, p4clockmod_table[newstate].index);
 
 	/* notifiers */
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu_mask(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -963,7 +963,7 @@ static int transition_frequency_fidvid(s
 	freqs.old = find_khz_freq_from_fid(data->currfid);
 	freqs.new = find_khz_freq_from_fid(fid);
 
-	for_each_cpu_mask_nr(i, *(data->available_cores)) {
+	for_each_cpu_mask(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -971,7 +971,7 @@ static int transition_frequency_fidvid(s
 	res = transition_fid_vid(data, fid, vid);
 	freqs.new = find_khz_freq_from_fid(data->currfid);
 
-	for_each_cpu_mask_nr(i, *(data->available_cores)) {
+	for_each_cpu_mask(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -994,7 +994,7 @@ static int transition_frequency_pstate(s
 	freqs.old = find_khz_freq_from_pstate(data->powernow_table, data->currpstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu_mask_nr(i, *(data->available_cores)) {
+	for_each_cpu_mask(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -1002,7 +1002,7 @@ static int transition_frequency_pstate(s
 	res = transition_pstate(data, pstate);
 	freqs.new = find_khz_freq_from_pstate(data->powernow_table, pstate);
 
-	for_each_cpu_mask_nr(i, *(data->available_cores)) {
+	for_each_cpu_mask(i, *(data->available_cores)) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -600,7 +600,7 @@ static int centrino_target (struct cpufr
 	*saved_mask = current->cpus_allowed;
 	first_cpu = 1;
 	cpus_clear(*covered_cpus);
-	for_each_cpu_mask_nr(j, *online_policy_cpus) {
+	for_each_cpu_mask(j, *online_policy_cpus) {
 		/*
 		 * Support for SMP systems.
 		 * Make sure we are running on CPU that wants to change freq
@@ -641,7 +641,7 @@ static int centrino_target (struct cpufr
 			dprintk("target=%dkHz old=%d new=%d msr=%04x\n",
 				target_freq, freqs.old, freqs.new, msr);
 
-			for_each_cpu_mask_nr(k, *online_policy_cpus) {
+			for_each_cpu_mask(k, *online_policy_cpus) {
 				freqs.cpu = k;
 				cpufreq_notify_transition(&freqs,
 					CPUFREQ_PRECHANGE);
@@ -664,7 +664,7 @@ static int centrino_target (struct cpufr
 		preempt_enable();
 	}
 
-	for_each_cpu_mask_nr(k, *online_policy_cpus) {
+	for_each_cpu_mask(k, *online_policy_cpus) {
 		freqs.cpu = k;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
@@ -678,7 +678,7 @@ static int centrino_target (struct cpufr
 		 */
 
 		if (!cpus_empty(*covered_cpus))
-			for_each_cpu_mask_nr(j, *covered_cpus) {
+			for_each_cpu_mask(j, *covered_cpus) {
 				set_cpus_allowed_ptr(current,
 						     &cpumask_of_cpu(j));
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
@@ -687,7 +687,7 @@ static int centrino_target (struct cpufr
 		tmp = freqs.new;
 		freqs.new = freqs.old;
 		freqs.old = tmp;
-		for_each_cpu_mask_nr(j, *online_policy_cpus) {
+		for_each_cpu_mask(j, *online_policy_cpus) {
 			freqs.cpu = j;
 			cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 			cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -279,7 +279,7 @@ static int speedstep_target (struct cpuf
 
 	cpus_allowed = current->cpus_allowed;
 
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu_mask(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_PRECHANGE);
 	}
@@ -292,7 +292,7 @@ static int speedstep_target (struct cpuf
 	/* allow to be run on all CPUs */
 	set_cpus_allowed_ptr(current, &cpus_allowed);
 
-	for_each_cpu_mask_nr(i, policy->cpus) {
+	for_each_cpu_mask(i, policy->cpus) {
 		freqs.cpu = i;
 		cpufreq_notify_transition(&freqs, CPUFREQ_POSTCHANGE);
 	}
--- struct-cpumasks.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ struct-cpumasks/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -513,7 +513,7 @@ static void __cpuinit cache_remove_share
 	int sibling;
 
 	this_leaf = CPUID4_INFO_IDX(cpu, index);
-	for_each_cpu_mask_nr(sibling, this_leaf->shared_cpu_map) {
+	for_each_cpu_mask(sibling, this_leaf->shared_cpu_map) {
 		sibling_leaf = CPUID4_INFO_IDX(sibling, index);
 		cpu_clear(cpu, sibling_leaf->shared_cpu_map);
 	}
--- struct-cpumasks.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
+++ struct-cpumasks/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
@@ -527,7 +527,7 @@ static __cpuinit int threshold_create_ba
 	if (err)
 		goto out_free;
 
-	for_each_cpu_mask_nr(i, b->cpus) {
+	for_each_cpu_mask(i, b->cpus) {
 		if (i == cpu)
 			continue;
 
@@ -617,7 +617,7 @@ static void threshold_remove_bank(unsign
 #endif
 
 	/* remove all sibling symlinks before unregistering */
-	for_each_cpu_mask_nr(i, b->cpus) {
+	for_each_cpu_mask(i, b->cpus) {
 		if (i == cpu)
 			continue;
 
--- struct-cpumasks.orig/arch/x86/kernel/io_apic.c
+++ struct-cpumasks/arch/x86/kernel/io_apic.c
@@ -1237,7 +1237,7 @@ static int __assign_irq_vector(int irq, 
 			return 0;
 	}
 
-	for_each_online_cpu_mask_nr(cpu, *mask) {
+	for_each_cpu_in(cpu, mask, cpu_online_map) {
 		int new_cpu;
 		int vector, offset;
 
@@ -1261,7 +1261,7 @@ next:
 		if (vector == SYSCALL_VECTOR)
 			goto next;
 #endif
-		for_each_online_cpu_mask_nr(new_cpu, tmpmask)
+		for_each_cpu_in(new_cpu, tmpmask, cpu_online_map)
 			if (per_cpu(vector_irq, new_cpu)[vector] != -1)
 				goto next;
 		/* Found one! */
@@ -1271,7 +1271,7 @@ next:
 			cfg->move_in_progress = 1;
 			cfg->old_domain = cfg->domain;
 		}
-		for_each_cpu_mask_nr(new_cpu, tmpmask)
+		for_each_cpu_in(new_cpu, tmpmask, cpu_online_map)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		cfg->vector = vector;
 		cfg->domain = tmpmask;
@@ -1302,7 +1302,7 @@ static void __clear_irq_vector(int irq)
 
 	vector = cfg->vector;
 	cpus_and(mask, cfg->domain, cpu_online_map);
-	for_each_cpu_mask_nr(cpu, mask)
+	for_each_cpu_mask(cpu, mask)
 		per_cpu(vector_irq, cpu)[vector] = -1;
 
 	cfg->vector = 0;
--- struct-cpumasks.orig/arch/x86/kernel/smpboot.c
+++ struct-cpumasks/arch/x86/kernel/smpboot.c
@@ -448,7 +448,7 @@ void __cpuinit set_cpu_sibling_map(int c
 	cpu_set(cpu, cpu_sibling_setup_map);
 
 	if (smp_num_siblings > 1) {
-		for_each_cpu_mask_nr(i, cpu_sibling_setup_map) {
+		for_each_cpu_mask(i, cpu_sibling_setup_map) {
 			if (c->phys_proc_id == cpu_data(i).phys_proc_id &&
 			    c->cpu_core_id == cpu_data(i).cpu_core_id) {
 				cpu_set(i, per_cpu(cpu_sibling_map, cpu));
@@ -471,7 +471,7 @@ void __cpuinit set_cpu_sibling_map(int c
 		return;
 	}
 
-	for_each_cpu_mask_nr(i, cpu_sibling_setup_map) {
+	for_each_cpu_mask(i, cpu_sibling_setup_map) {
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpu_set(i, c->llc_shared_map);
@@ -1268,7 +1268,7 @@ static void remove_siblinginfo(int cpu)
 	int sibling;
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 
-	for_each_cpu_mask_nr(sibling, per_cpu(cpu_core_map, cpu)) {
+	for_each_cpu_mask(sibling, per_cpu(cpu_core_map, cpu)) {
 		cpu_clear(cpu, per_cpu(cpu_core_map, sibling));
 		/*/
 		 * last thread sibling in this cpu core going down
@@ -1277,7 +1277,7 @@ static void remove_siblinginfo(int cpu)
 			cpu_data(sibling).booted_cores--;
 	}
 
-	for_each_cpu_mask_nr(sibling, per_cpu(cpu_sibling_map, cpu))
+	for_each_cpu_mask(sibling, per_cpu(cpu_sibling_map, cpu))
 		cpu_clear(cpu, per_cpu(cpu_sibling_map, sibling));
 	cpus_clear(per_cpu(cpu_sibling_map, cpu));
 	cpus_clear(per_cpu(cpu_core_map, cpu));
--- struct-cpumasks.orig/arch/x86/xen/smp.c
+++ struct-cpumasks/arch/x86/xen/smp.c
@@ -412,7 +412,7 @@ static void xen_send_IPI_mask(const cpum
 {
 	unsigned cpu;
 
-	for_each_online_cpu_mask_nr(cpu, *mask)
+	for_each_cpu_mask(cpu, mask)
 		xen_send_IPI_one(cpu, vector);
 }
 
@@ -423,7 +423,7 @@ static void xen_smp_send_call_function_i
 	xen_send_IPI_mask(&mask, XEN_CALL_FUNCTION_VECTOR);
 
 	/* Make sure other vcpus get a chance to run if they need to. */
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu_mask(cpu, mask) {
 		if (xen_vcpu_stolen(cpu)) {
 			HYPERVISOR_sched_op(SCHEDOP_yield, 0);
 			break;
--- struct-cpumasks.orig/drivers/acpi/processor_throttling.c
+++ struct-cpumasks/drivers/acpi/processor_throttling.c
@@ -1013,7 +1013,7 @@ int acpi_processor_set_throttling(struct
 	 * affected cpu in order to get one proper T-state.
 	 * The notifier event is THROTTLING_PRECHANGE.
 	 */
-	for_each_cpu_mask_nr(i, online_throttling_cpus) {
+	for_each_cpu_mask(i, online_throttling_cpus) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_PRECHANGE,
 							&t_state);
@@ -1034,7 +1034,7 @@ int acpi_processor_set_throttling(struct
 		 * it is necessary to set T-state for every affected
 		 * cpus.
 		 */
-		for_each_cpu_mask_nr(i, online_throttling_cpus) {
+		for_each_cpu_mask(i, online_throttling_cpus) {
 			match_pr = per_cpu(processors, i);
 			/*
 			 * If the pointer is invalid, we will report the
@@ -1068,7 +1068,7 @@ int acpi_processor_set_throttling(struct
 	 * affected cpu to update the T-states.
 	 * The notifier event is THROTTLING_POSTCHANGE
 	 */
-	for_each_cpu_mask_nr(i, online_throttling_cpus) {
+	for_each_cpu_mask(i, online_throttling_cpus) {
 		t_state.cpu = i;
 		acpi_processor_throttling_notifier(THROTTLING_POSTCHANGE,
 							&t_state);
--- struct-cpumasks.orig/drivers/cpufreq/cpufreq.c
+++ struct-cpumasks/drivers/cpufreq/cpufreq.c
@@ -589,7 +589,7 @@ static ssize_t show_cpus(cpumask_t mask,
 	ssize_t i = 0;
 	unsigned int cpu;
 
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu_mask(cpu, mask) {
 		if (i)
 			i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), " ");
 		i += scnprintf(&buf[i], (PAGE_SIZE - i - 2), "%u", cpu);
@@ -838,7 +838,7 @@ static int cpufreq_add_dev(struct sys_de
 	}
 #endif
 
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu_mask(j, policy->cpus) {
 		if (cpu == j)
 			continue;
 
@@ -901,14 +901,14 @@ static int cpufreq_add_dev(struct sys_de
 	}
 
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu_mask(j, policy->cpus) {
 		per_cpu(cpufreq_cpu_data, j) = policy;
 		per_cpu(policy_cpu, j) = policy->cpu;
 	}
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	/* symlink affected CPUs */
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu_mask(j, policy->cpus) {
 		if (j == cpu)
 			continue;
 		if (!cpu_online(j))
@@ -948,7 +948,7 @@ static int cpufreq_add_dev(struct sys_de
 
 err_out_unregister:
 	spin_lock_irqsave(&cpufreq_driver_lock, flags);
-	for_each_cpu_mask_nr(j, policy->cpus)
+	for_each_cpu_mask(j, policy->cpus)
 		per_cpu(cpufreq_cpu_data, j) = NULL;
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
@@ -1031,7 +1031,7 @@ static int __cpufreq_remove_dev(struct s
 	 * the sysfs links afterwards.
 	 */
 	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask_nr(j, data->cpus) {
+		for_each_cpu_mask(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			per_cpu(cpufreq_cpu_data, j) = NULL;
@@ -1041,7 +1041,7 @@ static int __cpufreq_remove_dev(struct s
 	spin_unlock_irqrestore(&cpufreq_driver_lock, flags);
 
 	if (unlikely(cpus_weight(data->cpus) > 1)) {
-		for_each_cpu_mask_nr(j, data->cpus) {
+		for_each_cpu_mask(j, data->cpus) {
 			if (j == cpu)
 				continue;
 			dprintk("removing link for cpu %u\n", j);
--- struct-cpumasks.orig/drivers/cpufreq/cpufreq_conservative.c
+++ struct-cpumasks/drivers/cpufreq/cpufreq_conservative.c
@@ -497,7 +497,7 @@ static int cpufreq_governor_dbs(struct c
 			return rc;
 		}
 
-		for_each_cpu_mask_nr(j, policy->cpus) {
+		for_each_cpu_mask(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
--- struct-cpumasks.orig/drivers/cpufreq/cpufreq_ondemand.c
+++ struct-cpumasks/drivers/cpufreq/cpufreq_ondemand.c
@@ -367,7 +367,7 @@ static void dbs_check_cpu(struct cpu_dbs
 
 	/* Get Idle Time */
 	idle_ticks = UINT_MAX;
-	for_each_cpu_mask_nr(j, policy->cpus) {
+	for_each_cpu_mask(j, policy->cpus) {
 		cputime64_t total_idle_ticks;
 		unsigned int tmp_idle_ticks;
 		struct cpu_dbs_info_s *j_dbs_info;
@@ -521,7 +521,7 @@ static int cpufreq_governor_dbs(struct c
 			return rc;
 		}
 
-		for_each_cpu_mask_nr(j, policy->cpus) {
+		for_each_cpu_mask(j, policy->cpus) {
 			struct cpu_dbs_info_s *j_dbs_info;
 			j_dbs_info = &per_cpu(cpu_dbs_info, j);
 			j_dbs_info->cur_policy = policy;
--- struct-cpumasks.orig/drivers/infiniband/hw/ehca/ehca_irq.c
+++ struct-cpumasks/drivers/infiniband/hw/ehca/ehca_irq.c
@@ -650,7 +650,7 @@ static inline int find_next_online_cpu(s
 		ehca_dmp(&cpu_online_map, sizeof(cpumask_t), "");
 
 	spin_lock_irqsave(&pool->last_cpu_lock, flags);
-	cpu = next_cpu_nr(pool->last_cpu, cpu_online_map);
+	cpu = next_cpu(pool->last_cpu, cpu_online_map);
 	if (cpu >= nr_cpu_ids)
 		cpu = first_cpu(cpu_online_map);
 	pool->last_cpu = cpu;
--- struct-cpumasks.orig/include/asm-x86/ipi.h
+++ struct-cpumasks/include/asm-x86/ipi.h
@@ -128,7 +128,7 @@ static inline void send_IPI_mask_sequenc
 	 * - mbligh
 	 */
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, *mask) {
+	for_each_cpu_mask(query_cpu, *mask) {
 		__send_IPI_dest_field(per_cpu(x86_cpu_to_apicid, query_cpu),
 				      vector, APIC_DEST_PHYSICAL);
 	}
@@ -144,7 +144,7 @@ static inline void send_IPI_mask_allbuts
 	/* See Hack comment above */
 
 	local_irq_save(flags);
-	for_each_cpu_mask_nr(query_cpu, *mask)
+	for_each_cpu_mask(query_cpu, *mask)
 		if (query_cpu != this_cpu)
 			__send_IPI_dest_field(
 				per_cpu(x86_cpu_to_apicid, query_cpu),
--- struct-cpumasks.orig/kernel/cpu.c
+++ struct-cpumasks/kernel/cpu.c
@@ -445,7 +445,7 @@ void __ref enable_nonboot_cpus(void)
 		goto out;
 
 	printk("Enabling non-boot CPUs ...\n");
-	for_each_cpu_mask_nr(cpu, frozen_cpus) {
+	for_each_cpu_mask(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
 			printk("CPU%d is up\n", cpu);
--- struct-cpumasks.orig/kernel/rcuclassic.c
+++ struct-cpumasks/kernel/rcuclassic.c
@@ -112,7 +112,7 @@ static void force_quiescent_state(struct
 		 */
 		cpus_and(cpumask, rcp->cpumask, cpu_online_map);
 		cpu_clear(rdp->cpu, cpumask);
-		for_each_cpu_mask_nr(cpu, cpumask)
+		for_each_cpu_mask(cpu, cpumask)
 			smp_send_reschedule(cpu);
 	}
 	spin_unlock_irqrestore(&rcp->lock, flags);
--- struct-cpumasks.orig/kernel/rcupreempt.c
+++ struct-cpumasks/kernel/rcupreempt.c
@@ -748,7 +748,7 @@ rcu_try_flip_idle(void)
 
 	/* Now ask each CPU for acknowledgement of the flip. */
 
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
+	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
 		per_cpu(rcu_flip_flag, cpu) = rcu_flipped;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -766,7 +766,7 @@ rcu_try_flip_waitack(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_a1);
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		if (rcu_try_flip_waitack_needed(cpu) &&
 		    per_cpu(rcu_flip_flag, cpu) != rcu_flip_seen) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_ae1);
@@ -798,7 +798,7 @@ rcu_try_flip_waitzero(void)
 	/* Check to see if the sum of the "last" counters is zero. */
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_z1);
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		sum += RCU_DATA_CPU(cpu)->rcu_flipctr[lastidx];
 	if (sum != 0) {
 		RCU_TRACE_ME(rcupreempt_trace_try_flip_ze1);
@@ -813,7 +813,7 @@ rcu_try_flip_waitzero(void)
 	smp_mb();  /*  ^^^^^^^^^^^^ */
 
 	/* Call for a memory barrier from each CPU. */
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map) {
+	for_each_cpu_mask(cpu, rcu_cpu_online_map) {
 		per_cpu(rcu_mb_flag, cpu) = rcu_mb_needed;
 		dyntick_save_progress_counter(cpu);
 	}
@@ -833,7 +833,7 @@ rcu_try_flip_waitmb(void)
 	int cpu;
 
 	RCU_TRACE_ME(rcupreempt_trace_try_flip_m1);
-	for_each_cpu_mask_nr(cpu, rcu_cpu_online_map)
+	for_each_cpu_mask(cpu, rcu_cpu_online_map)
 		if (rcu_try_flip_waitmb_needed(cpu) &&
 		    per_cpu(rcu_mb_flag, cpu) != rcu_mb_done) {
 			RCU_TRACE_ME(rcupreempt_trace_try_flip_me1);
--- struct-cpumasks.orig/kernel/sched.c
+++ struct-cpumasks/kernel/sched.c
@@ -2069,7 +2069,7 @@ find_idlest_group(struct sched_domain *s
 		/* Tally up the load of all CPUs in the group */
 		avg_load = 0;
 
-		for_each_cpu_mask_nr(i, group->cpumask) {
+		for_each_cpu_mask(i, group->cpumask) {
 			/* Bias balancing toward cpus of our domain */
 			if (local_group)
 				load = source_load(i, load_idx);
@@ -2111,7 +2111,7 @@ find_idlest_cpu(struct sched_group *grou
 	/* Traverse only the allowed CPUs */
 	cpus_and(*tmp, group->cpumask, p->cpus_allowed);
 
-	for_each_cpu_mask_nr(i, *tmp) {
+	for_each_cpu_mask(i, *tmp) {
 		load = weighted_cpuload(i);
 
 		if (load < min_load || (load == min_load && i == this_cpu)) {
@@ -3129,7 +3129,7 @@ find_busiest_group(struct sched_domain *
 		max_cpu_load = 0;
 		min_cpu_load = ~0UL;
 
-		for_each_cpu_mask_nr(i, group->cpumask) {
+		for_each_cpu_mask(i, group->cpumask) {
 			struct rq *rq;
 
 			if (!cpu_isset(i, *cpus))
@@ -3408,7 +3408,7 @@ find_busiest_queue(struct sched_group *g
 	unsigned long max_load = 0;
 	int i;
 
-	for_each_cpu_mask_nr(i, group->cpumask) {
+	for_each_cpu_mask(i, group->cpumask) {
 		unsigned long wl;
 
 		if (!cpu_isset(i, *cpus))
@@ -3950,7 +3950,7 @@ static void run_rebalance_domains(struct
 		int balance_cpu;
 
 		cpu_clear(this_cpu, cpus);
-		for_each_cpu_mask_nr(balance_cpu, cpus) {
+		for_each_cpu_mask(balance_cpu, cpus) {
 			/*
 			 * If this cpu gets work to do, stop the load balancing
 			 * work being done for other cpus. Next load
@@ -6961,7 +6961,7 @@ init_sched_build_groups(const cpumask_t 
 
 	cpus_clear(*covered);
 
-	for_each_cpu_mask_nr(i, *span) {
+	for_each_cpu_mask(i, *span) {
 		struct sched_group *sg;
 		int group = group_fn(i, cpu_map, &sg, tmpmask);
 		int j;
@@ -6972,7 +6972,7 @@ init_sched_build_groups(const cpumask_t 
 		cpus_clear(sg->cpumask);
 		sg->__cpu_power = 0;
 
-		for_each_cpu_mask_nr(j, *span) {
+		for_each_cpu_mask(j, *span) {
 			if (group_fn(j, cpu_map, NULL, tmpmask) != group)
 				continue;
 
@@ -7172,7 +7172,7 @@ static void init_numa_sched_groups_power
 	if (!sg)
 		return;
 	do {
-		for_each_cpu_mask_nr(j, sg->cpumask) {
+		for_each_cpu_mask(j, sg->cpumask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(phys_domains, j);
@@ -7197,7 +7197,7 @@ static void free_sched_groups(const cpum
 {
 	int cpu, i;
 
-	for_each_cpu_mask_nr(cpu, *cpu_map) {
+	for_each_cpu_mask(cpu, *cpu_map) {
 		struct sched_group **sched_group_nodes
 			= sched_group_nodes_bycpu[cpu];
 
@@ -7436,7 +7436,7 @@ static int __build_sched_domains(const c
 	/*
 	 * Set up domains for cpus specified by the cpu_map.
 	 */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu_mask(i, *cpu_map) {
 		struct sched_domain *sd = NULL, *p;
 		SCHED_CPUMASK_VAR(nodemask, allmasks);
 
@@ -7503,7 +7503,7 @@ static int __build_sched_domains(const c
 
 #ifdef CONFIG_SCHED_SMT
 	/* Set up CPU (sibling) groups */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu_mask(i, *cpu_map) {
 		SCHED_CPUMASK_VAR(this_sibling_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7520,7 +7520,7 @@ static int __build_sched_domains(const c
 
 #ifdef CONFIG_SCHED_MC
 	/* Set up multi-core groups */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu_mask(i, *cpu_map) {
 		SCHED_CPUMASK_VAR(this_core_map, allmasks);
 		SCHED_CPUMASK_VAR(send_covered, allmasks);
 
@@ -7587,7 +7587,7 @@ static int __build_sched_domains(const c
 			goto error;
 		}
 		sched_group_nodes[i] = sg;
-		for_each_cpu_mask_nr(j, *nodemask) {
+		for_each_cpu_mask(j, *nodemask) {
 			struct sched_domain *sd;
 
 			sd = &per_cpu(node_domains, j);
@@ -7633,21 +7633,21 @@ static int __build_sched_domains(const c
 
 	/* Calculate CPU power for physical packages and nodes */
 #ifdef CONFIG_SCHED_SMT
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu_mask(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(cpu_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 #ifdef CONFIG_SCHED_MC
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu_mask(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(core_domains, i);
 
 		init_sched_groups_power(i, sd);
 	}
 #endif
 
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu_mask(i, *cpu_map) {
 		struct sched_domain *sd = &per_cpu(phys_domains, i);
 
 		init_sched_groups_power(i, sd);
@@ -7667,7 +7667,7 @@ static int __build_sched_domains(const c
 #endif
 
 	/* Attach the domains */
-	for_each_cpu_mask_nr(i, *cpu_map) {
+	for_each_cpu_mask(i, *cpu_map) {
 		struct sched_domain *sd;
 #ifdef CONFIG_SCHED_SMT
 		sd = &per_cpu(cpu_domains, i);
@@ -7750,7 +7750,7 @@ static void detach_destroy_domains(const
 
 	unregister_sched_domain_sysctl();
 
-	for_each_cpu_mask_nr(i, *cpu_map)
+	for_each_cpu_mask(i, *cpu_map)
 		cpu_attach_domain(NULL, &def_root_domain, i);
 	synchronize_sched();
 	arch_destroy_sched_domains(cpu_map, &tmpmask);
--- struct-cpumasks.orig/kernel/sched_fair.c
+++ struct-cpumasks/kernel/sched_fair.c
@@ -978,7 +978,7 @@ static int wake_idle(int cpu, struct tas
 			&& !task_hot(p, task_rq(p)->clock, sd))) {
 			cpus_and(tmp, sd->span, p->cpus_allowed);
 			cpus_and(tmp, tmp, cpu_active_map);
-			for_each_cpu_mask_nr(i, tmp) {
+			for_each_cpu_mask(i, tmp) {
 				if (idle_cpu(i)) {
 					if (i != task_cpu(p)) {
 						schedstat_inc(p,
--- struct-cpumasks.orig/kernel/sched_rt.c
+++ struct-cpumasks/kernel/sched_rt.c
@@ -245,7 +245,7 @@ static int do_balance_runtime(struct rt_
 
 	spin_lock(&rt_b->rt_runtime_lock);
 	rt_period = ktime_to_ns(rt_b->rt_period);
-	for_each_cpu_mask_nr(i, rd->span) {
+	for_each_cpu_mask(i, rd->span) {
 		struct rt_rq *iter = sched_rt_period_rt_rq(rt_b, i);
 		s64 diff;
 
@@ -1179,7 +1179,7 @@ static int pull_rt_task(struct rq *this_
 
 	next = pick_next_task_rt(this_rq);
 
-	for_each_cpu_mask_nr(cpu, this_rq->rd->rto_mask) {
+	for_each_cpu_mask(cpu, this_rq->rd->rto_mask) {
 		if (this_cpu == cpu)
 			continue;
 
--- struct-cpumasks.orig/kernel/smp.c
+++ struct-cpumasks/kernel/smp.c
@@ -295,7 +295,7 @@ static void smp_call_function_mask_quies
 	data.func = quiesce_dummy;
 	data.info = NULL;
 
-	for_each_cpu_mask_nr(cpu, *mask) {
+	for_each_cpu_mask(cpu, *mask) {
 		data.flags = CSD_FLAG_WAIT;
 		generic_exec_single(cpu, &data);
 	}
--- struct-cpumasks.orig/kernel/taskstats.c
+++ struct-cpumasks/kernel/taskstats.c
@@ -301,7 +301,7 @@ static int add_del_listener(pid_t pid, c
 		return -EINVAL;
 
 	if (isadd == REGISTER) {
-		for_each_cpu_mask_nr(cpu, mask) {
+		for_each_cpu_mask(cpu, mask) {
 			s = kmalloc_node(sizeof(struct listener), GFP_KERNEL,
 					 cpu_to_node(cpu));
 			if (!s)
@@ -320,7 +320,7 @@ static int add_del_listener(pid_t pid, c
 
 	/* Deregister or cleanup */
 cleanup:
-	for_each_cpu_mask_nr(cpu, mask) {
+	for_each_cpu_mask(cpu, mask) {
 		listeners = &per_cpu(listener_array, cpu);
 		down_write(&listeners->sem);
 		list_for_each_entry_safe(s, tmp, &listeners->list, list) {
--- struct-cpumasks.orig/kernel/time/clocksource.c
+++ struct-cpumasks/kernel/time/clocksource.c
@@ -151,7 +151,7 @@ static void clocksource_watchdog(unsigne
 		 * Cycle through CPUs to check if the CPUs stay
 		 * synchronized to each other.
 		 */
-		int next_cpu = next_cpu_nr(raw_smp_processor_id(), cpu_online_map);
+		int next_cpu = next_cpu(raw_smp_processor_id(), cpu_online_map);
 
 		if (next_cpu >= nr_cpu_ids)
 			next_cpu = first_cpu(cpu_online_map);
--- struct-cpumasks.orig/kernel/time/tick-broadcast.c
+++ struct-cpumasks/kernel/time/tick-broadcast.c
@@ -399,7 +399,7 @@ again:
 	mask = CPU_MASK_NONE;
 	now = ktime_get();
 	/* Find all expired events */
-	for_each_cpu_mask_nr(cpu, tick_broadcast_oneshot_mask) {
+	for_each_cpu_mask(cpu, tick_broadcast_oneshot_mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev->next_event.tv64 <= now.tv64)
 			cpu_set(cpu, mask);
@@ -496,7 +496,7 @@ static void tick_broadcast_init_next_eve
 	struct tick_device *td;
 	int cpu;
 
-	for_each_cpu_mask_nr(cpu, *mask) {
+	for_each_cpu_mask(cpu, *mask) {
 		td = &per_cpu(tick_cpu_device, cpu);
 		if (td->evtdev)
 			td->evtdev->next_event = expires;
--- struct-cpumasks.orig/kernel/workqueue.c
+++ struct-cpumasks/kernel/workqueue.c
@@ -415,7 +415,7 @@ void flush_workqueue(struct workqueue_st
 	might_sleep();
 	lock_map_acquire(&wq->lockdep_map);
 	lock_map_release(&wq->lockdep_map);
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu_mask(cpu, *cpu_map)
 		flush_cpu_workqueue(per_cpu_ptr(wq->cpu_wq, cpu));
 }
 EXPORT_SYMBOL_GPL(flush_workqueue);
@@ -546,7 +546,7 @@ static void wait_on_work(struct work_str
 	wq = cwq->wq;
 	cpu_map = wq_cpu_map(wq);
 
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu_mask(cpu, *cpu_map)
 		wait_on_cpu_work(per_cpu_ptr(wq->cpu_wq, cpu), work);
 }
 
@@ -906,7 +906,7 @@ void destroy_workqueue(struct workqueue_
 	list_del(&wq->list);
 	spin_unlock(&workqueue_lock);
 
-	for_each_cpu_mask_nr(cpu, *cpu_map)
+	for_each_cpu_mask(cpu, *cpu_map)
 		cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));
  	cpu_maps_update_done();
 
--- struct-cpumasks.orig/mm/allocpercpu.c
+++ struct-cpumasks/mm/allocpercpu.c
@@ -34,7 +34,7 @@ static void percpu_depopulate(void *__pd
 static void __percpu_depopulate_mask(void *__pdata, cpumask_t *mask)
 {
 	int cpu;
-	for_each_cpu_mask_nr(cpu, *mask)
+	for_each_cpu_mask(cpu, *mask)
 		percpu_depopulate(__pdata, cpu);
 }
 
@@ -86,7 +86,7 @@ static int __percpu_populate_mask(void *
 	int cpu;
 
 	cpus_clear(populated);
-	for_each_cpu_mask_nr(cpu, *mask)
+	for_each_cpu_mask(cpu, *mask)
 		if (unlikely(!percpu_populate(__pdata, size, gfp, cpu))) {
 			__percpu_depopulate_mask(__pdata, &populated);
 			return -ENOMEM;
--- struct-cpumasks.orig/mm/quicklist.c
+++ struct-cpumasks/mm/quicklist.c
@@ -42,7 +42,7 @@ static unsigned long max_pages(unsigned 
 
 	max = node_free_pages / FRACTION_OF_NODE_MEM;
 
-	num_cpus_on_node = cpus_weight_nr(*cpumask_on_node);
+	num_cpus_on_node = cpus_weight(*cpumask_on_node);
 	max /= num_cpus_on_node;
 
 	return max(max, min_pages);
--- struct-cpumasks.orig/mm/vmstat.c
+++ struct-cpumasks/mm/vmstat.c
@@ -27,7 +27,7 @@ static void sum_vm_events(unsigned long 
 
 	memset(ret, 0, NR_VM_EVENT_ITEMS * sizeof(unsigned long));
 
-	for_each_cpu_mask_nr(cpu, *cpumask) {
+	for_each_cpu_mask(cpu, *cpumask) {
 		struct vm_event_state *this = &per_cpu(vm_event_states, cpu);
 
 		for (i = 0; i < NR_VM_EVENT_ITEMS; i++)
--- struct-cpumasks.orig/net/core/dev.c
+++ struct-cpumasks/net/core/dev.c
@@ -2410,7 +2410,7 @@ out:
 	 */
 	if (!cpus_empty(net_dma.channel_mask)) {
 		int chan_idx;
-		for_each_cpu_mask_nr(chan_idx, net_dma.channel_mask) {
+		for_each_cpu_mask(chan_idx, net_dma.channel_mask) {
 			struct dma_chan *chan = net_dma.channels[chan_idx];
 			if (chan)
 				dma_async_memcpy_issue_pending(chan);
@@ -4552,7 +4552,7 @@ static void net_dma_rebalance(struct net
 	i = 0;
 	cpu = first_cpu(cpu_online_map);
 
-	for_each_cpu_mask_nr(chan_idx, net_dma->channel_mask) {
+	for_each_cpu_mask(chan_idx, net_dma->channel_mask) {
 		chan = net_dma->channels[chan_idx];
 
 		n = ((num_online_cpus() / cpus_weight(net_dma->channel_mask))
--- struct-cpumasks.orig/net/iucv/iucv.c
+++ struct-cpumasks/net/iucv/iucv.c
@@ -497,7 +497,7 @@ static void iucv_setmask_up(void)
 	/* Disable all cpu but the first in cpu_irq_cpumask. */
 	cpumask = iucv_irq_cpumask;
 	cpu_clear(first_cpu(iucv_irq_cpumask), cpumask);
-	for_each_cpu_mask_nr(cpu, cpumask)
+	for_each_cpu_mask(cpu, cpumask)
 		smp_call_function_single(cpu, iucv_block_cpu, NULL, 1);
 }
 

-- 
