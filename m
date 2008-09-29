Return-Path: <linux-kernel-owner+w=401wt.eu-S1754007AbYI2SGF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbYI2SGF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:06:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbYI2SDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:04 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54315 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752472AbYI2SCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:52 -0400
Message-Id: <20080929180251.498092000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:00 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 10/31] cpumask: clean cpumask_of_cpu refs
Content-Disposition: inline; filename=cpumask_of_cpu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/acpi/cstate.c                    |    2 +-
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c       |    6 +++---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c        |    8 ++++----
 arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c |    4 ++--
 arch/x86/kernel/cpu/cpufreq/speedstep-ich.c      |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c            |    2 +-
 arch/x86/kernel/microcode_core.c                 |    6 +++---
 arch/x86/kernel/reboot.c                         |    2 +-
 drivers/acpi/processor_throttling.c              |    6 +++---
 drivers/firmware/dcdbas.c                        |    2 +-
 drivers/misc/sgi-xp/xpc_main.c                   |    2 +-
 drivers/xen/manage.c                             |    2 +-
 kernel/time/tick-common.c                        |    2 +-
 kernel/trace/trace_sysprof.c                     |    2 +-
 net/sunrpc/svc.c                                 |    2 +-
 15 files changed, 25 insertions(+), 25 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/acpi/cstate.c
+++ struct-cpumasks/arch/x86/kernel/acpi/cstate.c
@@ -91,7 +91,7 @@ int acpi_processor_ffh_cstate_probe(unsi
 
 	/* Make sure we are running on right CPU */
 	saved_mask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
 	if (retval)
 		return -1;
 
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -203,7 +203,7 @@ static void drv_write(struct drv_cmd *cm
 	unsigned int i;
 
 	for_each_cpu_mask(i, cmd->mask) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
+		set_cpus_allowed_ptr(current, cpumask_of_cpu(i));
 		do_drv_write(cmd);
 	}
 
@@ -271,7 +271,7 @@ static unsigned int get_measured_perf(un
 	unsigned int retval;
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
 	if (get_cpu() != cpu) {
 		/* We were not able to run on requested processor */
 		put_cpu();
@@ -349,7 +349,7 @@ static unsigned int get_cur_freq_on_cpu(
 	}
 
 	cached_freq = data->freq_table[data->acpi_data->state].frequency;
-	freq = extract_freq(get_cur_val(&cpumask_of_cpu(cpu)), data);
+	freq = extract_freq(get_cur_val(cpumask_of_cpu(cpu)), data);
 	if (freq != cached_freq) {
 		/*
 		 * The dreaded BIOS frequency change behind our back.
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -480,7 +480,7 @@ static int check_supported_cpu(unsigned 
 	unsigned int rc = 0;
 
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
 
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", cpu);
@@ -1027,7 +1027,7 @@ static int powernowk8_target(struct cpuf
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	set_cpus_allowed_ptr(current, cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1153,7 +1153,7 @@ static int __cpuinit powernowk8_cpu_init
 
 	/* only run on specific CPU from here on */
 	oldmask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pol->cpu));
+	set_cpus_allowed_ptr(current, cpumask_of_cpu(pol->cpu));
 
 	if (smp_processor_id() != pol->cpu) {
 		printk(KERN_ERR PFX "limiting to cpu %u failed\n", pol->cpu);
@@ -1250,7 +1250,7 @@ static unsigned int powernowk8_get (unsi
 	if (!data)
 		return -EINVAL;
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu) {
 		printk(KERN_ERR PFX
 			"limiting to CPU %d failed in powernowk8_get\n", cpu);
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/speedstep-centrino.c
@@ -419,7 +419,7 @@ static unsigned int get_cur_freq(unsigne
 	cpumask_t saved_mask;
 
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
 	if (smp_processor_id() != cpu)
 		return 0;
 
@@ -680,7 +680,7 @@ static int centrino_target (struct cpufr
 		if (!cpus_empty(*covered_cpus))
 			for_each_cpu_mask(j, *covered_cpus) {
 				set_cpus_allowed_ptr(current,
-						     &cpumask_of_cpu(j));
+						     cpumask_of_cpu(j));
 				wrmsr(MSR_IA32_PERF_CTL, oldmsr, h);
 			}
 
--- struct-cpumasks.orig/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
+++ struct-cpumasks/arch/x86/kernel/cpu/cpufreq/speedstep-ich.c
@@ -244,7 +244,7 @@ static unsigned int _speedstep_get(const
 
 static unsigned int speedstep_get(unsigned int cpu)
 {
-	return _speedstep_get(&cpumask_of_cpu(cpu));
+	return _speedstep_get(cpumask_of_cpu(cpu));
 }
 
 /**
--- struct-cpumasks.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ struct-cpumasks/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -550,7 +550,7 @@ static int __cpuinit detect_cache_attrib
 		return -ENOMEM;
 
 	oldmask = current->cpus_allowed;
-	retval = set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	retval = set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
 	if (retval)
 		goto out;
 
--- struct-cpumasks.orig/arch/x86/kernel/microcode_core.c
+++ struct-cpumasks/arch/x86/kernel/microcode_core.c
@@ -122,7 +122,7 @@ static int do_microcode_update(const voi
 		if (!uci->valid)
 			continue;
 
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+		set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
 		error = microcode_ops->request_microcode_user(cpu, buf, size);
 		if (error < 0)
 			goto out;
@@ -222,7 +222,7 @@ static ssize_t reload_store(struct sys_d
 
 		get_online_cpus();
 		if (cpu_online(cpu)) {
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+			set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
 			mutex_lock(&microcode_mutex);
 			if (uci->valid) {
 				err = microcode_ops->request_microcode_fw(cpu,
@@ -351,7 +351,7 @@ static void microcode_init_cpu(int cpu)
 {
 	cpumask_t old = current->cpus_allowed;
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+	set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
 	microcode_update_cpu(cpu);
 	set_cpus_allowed_ptr(current, &old);
 }
--- struct-cpumasks.orig/arch/x86/kernel/reboot.c
+++ struct-cpumasks/arch/x86/kernel/reboot.c
@@ -431,7 +431,7 @@ void native_machine_shutdown(void)
 		reboot_cpu_id = smp_processor_id();
 
 	/* Make certain I only run on the appropriate processor */
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(reboot_cpu_id));
+	set_cpus_allowed_ptr(current, cpumask_of_cpu(reboot_cpu_id));
 
 	/* O.K Now that I'm on the appropriate processor,
 	 * stop all of the others.
--- struct-cpumasks.orig/drivers/acpi/processor_throttling.c
+++ struct-cpumasks/drivers/acpi/processor_throttling.c
@@ -838,7 +838,7 @@ static int acpi_processor_get_throttling
 	 * Migrate task to the cpu pointed by pr.
 	 */
 	saved_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
+	set_cpus_allowed_ptr(current, cpumask_of_cpu(pr->id));
 	ret = pr->throttling.acpi_processor_get_throttling(pr);
 	/* restore the previous state */
 	set_cpus_allowed_ptr(current, &saved_mask);
@@ -1025,7 +1025,7 @@ int acpi_processor_set_throttling(struct
 	 * it can be called only for the cpu pointed by pr.
 	 */
 	if (p_throttling->shared_type == DOMAIN_COORD_TYPE_SW_ANY) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(pr->id));
+		set_cpus_allowed_ptr(current, cpumask_of_cpu(pr->id));
 		ret = p_throttling->acpi_processor_set_throttling(pr,
 						t_state.target_state);
 	} else {
@@ -1056,7 +1056,7 @@ int acpi_processor_set_throttling(struct
 				continue;
 			}
 			t_state.cpu = i;
-			set_cpus_allowed_ptr(current, &cpumask_of_cpu(i));
+			set_cpus_allowed_ptr(current, cpumask_of_cpu(i));
 			ret = match_pr->throttling.
 				acpi_processor_set_throttling(
 				match_pr, t_state.target_state);
--- struct-cpumasks.orig/drivers/firmware/dcdbas.c
+++ struct-cpumasks/drivers/firmware/dcdbas.c
@@ -255,7 +255,7 @@ static int smi_request(struct smi_cmd *s
 
 	/* SMI requires CPU 0 */
 	old_mask = current->cpus_allowed;
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(0));
+	set_cpus_allowed_ptr(current, cpumask_of_cpu(0));
 	if (smp_processor_id() != 0) {
 		dev_dbg(&dcdbas_pdev->dev, "%s: failed to get CPU 0\n",
 			__func__);
--- struct-cpumasks.orig/drivers/misc/sgi-xp/xpc_main.c
+++ struct-cpumasks/drivers/misc/sgi-xp/xpc_main.c
@@ -318,7 +318,7 @@ xpc_hb_checker(void *ignore)
 
 	/* this thread was marked active by xpc_hb_init() */
 
-	set_cpus_allowed_ptr(current, &cpumask_of_cpu(XPC_HB_CHECK_CPU));
+	set_cpus_allowed_ptr(current, cpumask_of_cpu(XPC_HB_CHECK_CPU));
 
 	/* set our heartbeating to other partitions into motion */
 	xpc_hb_check_timeout = jiffies + (xpc_hb_check_interval * HZ);
--- struct-cpumasks.orig/drivers/xen/manage.c
+++ struct-cpumasks/drivers/xen/manage.c
@@ -102,7 +102,7 @@ static void do_suspend(void)
 	/* XXX use normal device tree? */
 	xenbus_suspend();
 
-	err = stop_machine(xen_suspend, &cancelled, &cpumask_of_cpu(0));
+	err = stop_machine(xen_suspend, &cancelled, cpumask_of_cpu(0));
 	if (err) {
 		printk(KERN_ERR "failed to start xen_suspend: %d\n", err);
 		goto out;
--- struct-cpumasks.orig/kernel/time/tick-common.c
+++ struct-cpumasks/kernel/time/tick-common.c
@@ -254,7 +254,7 @@ static int tick_check_new_device(struct 
 		curdev = NULL;
 	}
 	clockevents_exchange_device(curdev, newdev);
-	tick_setup_device(td, newdev, cpu, &cpumask_of_cpu(cpu));
+	tick_setup_device(td, newdev, cpu, cpumask_of_cpu(cpu));
 	if (newdev->features & CLOCK_EVT_FEAT_ONESHOT)
 		tick_oneshot_notify();
 
--- struct-cpumasks.orig/kernel/trace/trace_sysprof.c
+++ struct-cpumasks/kernel/trace/trace_sysprof.c
@@ -213,7 +213,7 @@ static void start_stack_timers(void)
 	int cpu;
 
 	for_each_online_cpu(cpu) {
-		set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu));
+		set_cpus_allowed_ptr(current, cpumask_of_cpu(cpu));
 		start_stack_timer(cpu);
 	}
 	set_cpus_allowed_ptr(current, &saved_mask);
--- struct-cpumasks.orig/net/sunrpc/svc.c
+++ struct-cpumasks/net/sunrpc/svc.c
@@ -310,7 +310,7 @@ svc_pool_map_set_cpumask(struct task_str
 	switch (m->mode) {
 	case SVC_POOL_PERCPU:
 	{
-		set_cpus_allowed_ptr(task, &cpumask_of_cpu(node));
+		set_cpus_allowed_ptr(task, cpumask_of_cpu(node));
 		break;
 	}
 	case SVC_POOL_PERNODE:

-- 
