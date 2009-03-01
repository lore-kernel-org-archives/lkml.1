Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbZCAO0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbZCAO0T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 09:26:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754489AbZCAO0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 09:26:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:57355 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188AbZCAO0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 09:26:06 -0500
Subject: Re: [git-pull -tip] cpu fixes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1235828025.3379.4.camel@localhost.localdomain>
References: <1235828025.3379.4.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 01 Mar 2009 19:55:36 +0530
Message-Id: <1235917536.3797.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-02-28 at 19:04 +0530, Jaswinder Singh Rajput wrote:
> Hello Ingo,
> 
> Please pull:
> 
> The following changes since commit c6003015dacd7c6fe18c6009115801079d8fdd49:
>   Ingo Molnar (1):
>         Merge branch 'linus'
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
> 
> Jaswinder Singh Rajput (3):
>       x86: decent declarations in perf_counter.c
>       x88: using pr_info in perf_counter.c
>       x86: remove double copy of show_cpuinfo_core for 32 and 64 bit
> 

Hello Ingo,

'x86: remove double copy of show_cpuinfo_core for 32 and 64 bit' already
merged in -tip through peter, So here is new pull request:
The following changes since commit c6003015dacd7c6fe18c6009115801079d8fdd49:
  Ingo Molnar (1):
        Merge branch 'linus'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master

Jaswinder Singh Rajput (2):
      x86: decent declarations in perf_counter.c
      x86: using pr_info in perf_counter.c

 arch/x86/kernel/cpu/perf_counter.c |   62 ++++++++++++++++++------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/cpu/perf_counter.c b/arch/x86/kernel/cpu/perf_counter.c
index 266618a..3b65f19 100644
--- a/arch/x86/kernel/cpu/perf_counter.c
+++ b/arch/x86/kernel/cpu/perf_counter.c
@@ -42,12 +42,12 @@ struct cpu_hw_counters {
  * struct pmc_x86_ops - performance counter x86 ops
  */
 struct pmc_x86_ops {
-	u64 (*save_disable_all)		(void);
-	void (*restore_all)		(u64 ctrl);
-	unsigned eventsel;
-	unsigned perfctr;
-	int (*event_map)		(int event);
-	int max_events;
+	u64		(*save_disable_all)(void);
+	void		(*restore_all)(u64 ctrl);
+	unsigned	eventsel;
+	unsigned	perfctr;
+	int		(*event_map)(int event);
+	int		max_events;
 };
 
 static struct pmc_x86_ops *pmc_ops;
@@ -454,18 +454,18 @@ void perf_counter_print_debug(void)
 	cpuc = &per_cpu(cpu_hw_counters, cpu);
 
 	if (boot_cpu_data.x86_vendor == X86_VENDOR_INTEL) {
-	rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
-	rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
-	rdmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, overflow);
-	rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR_CTRL, fixed);
-
-	printk(KERN_INFO "\n");
-	printk(KERN_INFO "CPU#%d: ctrl:       %016llx\n", cpu, ctrl);
-	printk(KERN_INFO "CPU#%d: status:     %016llx\n", cpu, status);
-	printk(KERN_INFO "CPU#%d: overflow:   %016llx\n", cpu, overflow);
-	printk(KERN_INFO "CPU#%d: fixed:      %016llx\n", cpu, fixed);
+		rdmsrl(MSR_CORE_PERF_GLOBAL_CTRL, ctrl);
+		rdmsrl(MSR_CORE_PERF_GLOBAL_STATUS, status);
+		rdmsrl(MSR_CORE_PERF_GLOBAL_OVF_CTRL, overflow);
+		rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR_CTRL, fixed);
+
+		pr_info("\n");
+		pr_info("CPU#%d: ctrl:       %016llx\n", cpu, ctrl);
+		pr_info("CPU#%d: status:     %016llx\n", cpu, status);
+		pr_info("CPU#%d: overflow:   %016llx\n", cpu, overflow);
+		pr_info("CPU#%d: fixed:      %016llx\n", cpu, fixed);
 	}
-	printk(KERN_INFO "CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used);
+	pr_info("CPU#%d: used:       %016llx\n", cpu, *(u64 *)cpuc->used);
 
 	for (idx = 0; idx < nr_counters_generic; idx++) {
 		rdmsrl(pmc_ops->eventsel + idx, pmc_ctrl);
@@ -473,17 +473,17 @@ void perf_counter_print_debug(void)
 
 		prev_left = per_cpu(prev_left[idx], cpu);
 
-		printk(KERN_INFO "CPU#%d:   gen-PMC%d ctrl:  %016llx\n",
+		pr_info("CPU#%d:   gen-PMC%d ctrl:  %016llx\n",
 			cpu, idx, pmc_ctrl);
-		printk(KERN_INFO "CPU#%d:   gen-PMC%d count: %016llx\n",
+		pr_info("CPU#%d:   gen-PMC%d count: %016llx\n",
 			cpu, idx, pmc_count);
-		printk(KERN_INFO "CPU#%d:   gen-PMC%d left:  %016llx\n",
+		pr_info("CPU#%d:   gen-PMC%d left:  %016llx\n",
 			cpu, idx, prev_left);
 	}
 	for (idx = 0; idx < nr_counters_fixed; idx++) {
 		rdmsrl(MSR_ARCH_PERFMON_FIXED_CTR0 + idx, pmc_count);
 
-		printk(KERN_INFO "CPU#%d: fixed-PMC%d count: %016llx\n",
+		pr_info("CPU#%d: fixed-PMC%d count: %016llx\n",
 			cpu, idx, pmc_count);
 	}
 	local_irq_enable();
@@ -561,7 +561,7 @@ perf_handle_group(struct perf_counter *sibling, u64 *status, u64 *overflown)
 /*
  * Maximum interrupt frequency of 100KHz per CPU
  */
-#define PERFMON_MAX_INTERRUPTS 100000/HZ
+#define PERFMON_MAX_INTERRUPTS (100000/HZ)
 
 /*
  * This handler is triggered by the local APIC, so the APIC IRQ handling
@@ -773,10 +773,10 @@ static struct pmc_x86_ops *pmc_intel_init(void)
 	if (eax.split.mask_length <= ARCH_PERFMON_BRANCH_MISSES_RETIRED)
 		return NULL;
 
-	printk(KERN_INFO "Intel Performance Monitoring support detected.\n");
-	printk(KERN_INFO "... version:         %d\n", eax.split.version_id);
-	printk(KERN_INFO "... bit width:       %d\n", eax.split.bit_width);
-	printk(KERN_INFO "... mask length:     %d\n", eax.split.mask_length);
+	pr_info("Intel Performance Monitoring support detected.\n");
+	pr_info("... version:         %d\n", eax.split.version_id);
+	pr_info("... bit width:       %d\n", eax.split.bit_width);
+	pr_info("... mask length:     %d\n", eax.split.mask_length);
 
 	nr_counters_generic = eax.split.num_counters;
 	nr_counters_fixed = edx.split.num_counters_fixed;
@@ -790,7 +790,7 @@ static struct pmc_x86_ops *pmc_amd_init(void)
 	nr_counters_generic = 4;
 	nr_counters_fixed = 0;
 
-	printk(KERN_INFO "AMD Performance Monitoring support detected.\n");
+	pr_info("AMD Performance Monitoring support detected.\n");
 
 	return &pmc_amd_ops;
 }
@@ -811,7 +811,7 @@ void __init init_hw_perf_counters(void)
 	if (!pmc_ops)
 		return;
 
-	printk(KERN_INFO "... num counters:    %d\n", nr_counters_generic);
+	pr_info("... num counters:    %d\n", nr_counters_generic);
 	if (nr_counters_generic > X86_PMC_MAX_GENERIC) {
 		nr_counters_generic = X86_PMC_MAX_GENERIC;
 		WARN(1, KERN_ERR "hw perf counters %d > max(%d), clipping!",
@@ -820,18 +820,18 @@ void __init init_hw_perf_counters(void)
 	perf_counter_mask = (1 << nr_counters_generic) - 1;
 	perf_max_counters = nr_counters_generic;
 
-	printk(KERN_INFO "... value mask:      %016Lx\n", counter_value_mask);
+	pr_info("... value mask:      %016Lx\n", counter_value_mask);
 
 	if (nr_counters_fixed > X86_PMC_MAX_FIXED) {
 		nr_counters_fixed = X86_PMC_MAX_FIXED;
 		WARN(1, KERN_ERR "hw perf counters fixed %d > max(%d), clipping!",
 			nr_counters_fixed, X86_PMC_MAX_FIXED);
 	}
-	printk(KERN_INFO "... fixed counters:  %d\n", nr_counters_fixed);
+	pr_info("... fixed counters:  %d\n", nr_counters_fixed);
 
 	perf_counter_mask |= ((1LL << nr_counters_fixed)-1) << X86_PMC_IDX_FIXED;
 
-	printk(KERN_INFO "... counter mask:    %016Lx\n", perf_counter_mask);
+	pr_info("... counter mask:    %016Lx\n", perf_counter_mask);
 	perf_counters_initialized = true;
 
 	perf_counters_lapic_init(0);


