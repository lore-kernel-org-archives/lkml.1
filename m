Return-Path: <linux-kernel-owner+w=401wt.eu-S932233AbZJEA6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233AbZJEA6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758216AbZJEA63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:58:29 -0400
Received: from mail.perches.com ([173.55.12.10]:1725 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758245AbZJEAzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:18 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 10/21] arch/x86/kernel/cpu/: use pr_<level> and add pr_fmt(fmt)
Date: Sun,  4 Oct 2009 17:53:37 -0700
Message-Id: <4f927a40825ed15ed00953272221660937775b9e.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Converted printk(KERN_<level> to pr_<level>(
Removed "CPU: " prefixes
Some file now use KBUILD_MODNAME instead of "CPU: "

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    9 +++--
 arch/x86/kernel/cpu/amd.c                  |   26 +++++++-------
 arch/x86/kernel/cpu/bugs.c                 |   23 +++++++-----
 arch/x86/kernel/cpu/bugs_64.c              |    4 ++-
 arch/x86/kernel/cpu/centaur.c              |   12 ++++---
 arch/x86/kernel/cpu/common.c               |   54 +++++++++++++--------------
 arch/x86/kernel/cpu/cpu_debug.c            |    4 ++-
 arch/x86/kernel/cpu/cyrix.c                |   12 ++++---
 arch/x86/kernel/cpu/intel.c                |   14 ++++---
 arch/x86/kernel/cpu/intel_cacheinfo.c      |   14 ++++---
 arch/x86/kernel/cpu/perf_event.c           |   10 ++++--
 arch/x86/kernel/cpu/perfctr-watchdog.c     |   11 +++---
 arch/x86/kernel/cpu/transmeta.c            |   20 ++++++-----
 arch/x86/kernel/cpu/vmware.c               |   11 +++---
 14 files changed, 123 insertions(+), 101 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index c965e52..4a4f08d 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -2,6 +2,9 @@
  *	Routines to indentify additional cpu features that are scattered in
  *	cpuid space.
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/cpu.h>
 
 #include <asm/pat.h>
@@ -128,11 +131,9 @@ void __cpuinit detect_extended_topology(struct cpuinfo_x86 *c)
 	c->x86_max_cores = (core_level_siblings / smp_num_siblings);
 
 
-	printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-	       c->phys_proc_id);
+	pr_info("Physical Processor ID: %d\n", c->phys_proc_id);
 	if (c->x86_max_cores > 1)
-		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-		       c->cpu_core_id);
+		pr_info("Processor Core ID: %d\n", c->cpu_core_id);
 	return;
 #endif
 }
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index c910a71..0ddccff 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/mm.h>
@@ -71,7 +73,7 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 		void (*f_vide)(void);
 		unsigned long d, d2;
 
-		printk(KERN_INFO "AMD K6 stepping B detected - ");
+		pr_info("AMD K6 stepping B detected - ");
 
 		/*
 		 * It looks like AMD fixed the 2.6.2 bug and improved indirect
@@ -87,11 +89,10 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 		d = d2-d;
 
 		if (d > 20*K6_BUG_LOOP)
-			printk(KERN_CONT
-				"system stability may be impaired when more than 32 MB are used.\n");
+			pr_cont("system stability may be impaired when more than 32 MB are used.\n");
 		else
-			printk(KERN_CONT "probably OK (after B9730xxxx).\n");
-		printk(KERN_INFO "Please see http://membres.lycos.fr/poulot/k6bug.html\n");
+			pr_cont("probably OK (after B9730xxxx).\n");
+		pr_info("Please see http://membres.lycos.fr/poulot/k6bug.html\n");
 	}
 
 	/* K6 with old style WHCR */
@@ -109,7 +110,7 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 			wbinvd();
 			wrmsr(MSR_K6_WHCR, l, h);
 			local_irq_restore(flags);
-			printk(KERN_INFO "Enabling old style K6 write allocation for %d Mb\n",
+			pr_info("Enabling old style K6 write allocation for %d Mb\n",
 				mbytes);
 		}
 		return;
@@ -130,7 +131,7 @@ static void __cpuinit init_amd_k6(struct cpuinfo_x86 *c)
 			wbinvd();
 			wrmsr(MSR_K6_WHCR, l, h);
 			local_irq_restore(flags);
-			printk(KERN_INFO "Enabling new style K6 write allocation for %d Mb\n",
+			pr_info("Enabling new style K6 write allocation for %d Mb\n",
 				mbytes);
 		}
 
@@ -204,7 +205,7 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 	 */
 	if (c->x86_model >= 6 && c->x86_model <= 10) {
 		if (!cpu_has(c, X86_FEATURE_XMM)) {
-			printk(KERN_INFO "Enabling disabled K7/SSE Support.\n");
+			pr_info("Enabling disabled K7/SSE Support.\n");
 			rdmsr(MSR_K7_HWCR, l, h);
 			l &= ~0x00008000;
 			wrmsr(MSR_K7_HWCR, l, h);
@@ -220,9 +221,8 @@ static void __cpuinit init_amd_k7(struct cpuinfo_x86 *c)
 	if ((c->x86_model == 8 && c->x86_mask >= 1) || (c->x86_model > 8)) {
 		rdmsr(MSR_K7_CLK_CTL, l, h);
 		if ((l & 0xfff00000) != 0x20000000) {
-			printk(KERN_INFO
-			    "CPU: CLK_CTL MSR was %x. Reprogramming to %x\n",
-					l, ((l & 0x000fffff)|0x20000000));
+			pr_info("CLK_CTL MSR was %x. Reprogramming to %x\n",
+				l, ((l & 0x000fffff)|0x20000000));
 			wrmsr(MSR_K7_CLK_CTL, (l & 0x000fffff)|0x20000000, h);
 		}
 	}
@@ -376,7 +376,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 	}
 	numa_set_node(cpu, node);
 
-	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
+	pr_info("CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
 #endif
 }
 
@@ -580,7 +580,7 @@ static void __cpuinit init_amd(struct cpuinfo_x86 *c)
 		 * benefit in doing so.
 		 */
 		if (!rdmsrl_safe(MSR_K8_TSEG_ADDR, &tseg)) {
-			printk(KERN_DEBUG "tseg: %010llx\n", tseg);
+			pr_dbg("tseg: %010llx\n", tseg);
 			if ((tseg>>PMD_SHIFT) <
 				(max_low_pfn_mapped>>(PMD_SHIFT-PAGE_SHIFT)) ||
 				((tseg>>PMD_SHIFT) <
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 01a2652..a663be7 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -7,6 +7,9 @@
  *	- Channing Corn (tests & fixes),
  *	- Andrew D. Balsa (code cleanup).
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/utsname.h>
 #include <asm/bugs.h>
@@ -54,8 +57,8 @@ static void __init check_fpu(void)
 
 	if (!boot_cpu_data.hard_math) {
 #ifndef CONFIG_MATH_EMULATION
-		printk(KERN_EMERG "No coprocessor found and no math emulation present.\n");
-		printk(KERN_EMERG "Giving up.\n");
+		pr_emerg("No coprocessor found and no math emulation present.\n");
+		pr_emerg("Giving up.\n");
 		for (;;) ;
 #endif
 		return;
@@ -81,7 +84,7 @@ static void __init check_fpu(void)
 
 	boot_cpu_data.fdiv_bug = fdiv_bug;
 	if (boot_cpu_data.fdiv_bug)
-		printk(KERN_WARNING "Hmm, FPU with FDIV bug.\n");
+		pr_warning("Hmm, FPU with FDIV bug.\n");
 }
 
 static void __init check_hlt(void)
@@ -89,16 +92,16 @@ static void __init check_hlt(void)
 	if (paravirt_enabled())
 		return;
 
-	printk(KERN_INFO "Checking 'hlt' instruction... ");
+	pr_info("Checking 'hlt' instruction... ");
 	if (!boot_cpu_data.hlt_works_ok) {
-		printk("disabled\n");
+		pr_cont("disabled\n");
 		return;
 	}
 	halt();
 	halt();
 	halt();
 	halt();
-	printk(KERN_CONT "OK.\n");
+	pr_cont("OK.\n");
 }
 
 /*
@@ -111,7 +114,7 @@ static void __init check_popad(void)
 #ifndef CONFIG_X86_POPAD_OK
 	int res, inp = (int) &res;
 
-	printk(KERN_INFO "Checking for popad bug... ");
+	pr_info("Checking for popad bug... ");
 	__asm__ __volatile__(
 	  "movl $12345678,%%eax; movl $0,%%edi; pusha; popa; movl (%%edx,%%edi),%%ecx "
 	  : "=&a" (res)
@@ -122,9 +125,9 @@ static void __init check_popad(void)
 	 * CPU hard. Too bad.
 	 */
 	if (res != 12345678)
-		printk(KERN_CONT "Buggy.\n");
+		pr_cont("Buggy.\n");
 	else
-		printk(KERN_CONT "OK.\n");
+		pr_cont("OK.\n");
 #endif
 }
 
@@ -156,7 +159,7 @@ void __init check_bugs(void)
 {
 	identify_boot_cpu();
 #ifndef CONFIG_SMP
-	printk(KERN_INFO "CPU: ");
+	pr_info("");
 	print_cpu_info(&boot_cpu_data);
 #endif
 	check_config();
diff --git a/arch/x86/kernel/cpu/bugs_64.c b/arch/x86/kernel/cpu/bugs_64.c
index 04f0fe5..2ac1675 100644
--- a/arch/x86/kernel/cpu/bugs_64.c
+++ b/arch/x86/kernel/cpu/bugs_64.c
@@ -3,6 +3,8 @@
  *  Copyright (C) 2000  SuSE
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <asm/alternative.h>
@@ -15,7 +17,7 @@ void __init check_bugs(void)
 {
 	identify_boot_cpu();
 #if !defined(CONFIG_SMP)
-	printk(KERN_INFO "CPU: ");
+	pr_info("");
 	print_cpu_info(&boot_cpu_data);
 #endif
 	alternative_instructions();
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index c95e831..45e369e 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/bitops.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -260,7 +262,7 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 			rdmsr(MSR_VIA_FCR, lo, hi);
 			lo |= ACE_FCR;		/* enable ACE unit */
 			wrmsr(MSR_VIA_FCR, lo, hi);
-			printk(KERN_INFO "CPU: Enabled ACE h/w crypto\n");
+			pr_info("Enabled ACE h/w crypto\n");
 		}
 
 		/* enable RNG unit, if present and disabled */
@@ -268,7 +270,7 @@ static void __cpuinit init_c3(struct cpuinfo_x86 *c)
 			rdmsr(MSR_VIA_RNG, lo, hi);
 			lo |= RNG_ENABLE;	/* enable RNG unit */
 			wrmsr(MSR_VIA_RNG, lo, hi);
-			printk(KERN_INFO "CPU: Enabled h/w RNG\n");
+			pr_info("Enabled h/w RNG\n");
 		}
 
 		/* store Centaur Extended Feature Flags as
@@ -361,7 +363,7 @@ static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 			name = "C6";
 			fcr_set = ECX8|DSMC|EDCTLB|EMMX|ERETSTK;
 			fcr_clr = DPDC;
-			printk(KERN_NOTICE "Disabling bugged TSC.\n");
+			pr_notice("Disabling bugged TSC.\n");
 			clear_cpu_cap(c, X86_FEATURE_TSC);
 #ifdef CONFIG_X86_OOSTORE
 			centaur_create_optimal_mcr();
@@ -436,11 +438,11 @@ static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 		newlo = (lo|fcr_set) & (~fcr_clr);
 
 		if (newlo != lo) {
-			printk(KERN_INFO "Centaur FCR was 0x%X now 0x%X\n",
+			pr_info("Centaur FCR was 0x%X now 0x%X\n",
 				lo, newlo);
 			wrmsr(MSR_IDT_FCR1, newlo, hi);
 		} else {
-			printk(KERN_INFO "Centaur FCR is 0x%X\n", lo);
+			pr_info("Centaur FCR is 0x%X\n", lo);
 		}
 		/* Emulate MTRRs using Centaur's MCR. */
 		set_cpu_cap(c, X86_FEATURE_CENTAUR_MCR);
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index cc25c2b..fae817e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) "cpu: " fmt
+
 #include <linux/bootmem.h>
 #include <linux/linkage.h>
 #include <linux/bitops.h>
@@ -218,7 +220,7 @@ static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 	lo |= 0x200000;
 	wrmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
 
-	printk(KERN_NOTICE "CPU serial number disabled.\n");
+	pr_notice("CPU serial number disabled.\n");
 	clear_cpu_cap(c, X86_FEATURE_PN);
 
 	/* Disabling the serial number may affect the cpuid level */
@@ -288,9 +290,8 @@ static void __cpuinit filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
 		if (!warn)
 			continue;
 
-		printk(KERN_WARNING
-		       "CPU: CPU feature %s disabled, no CPUID level 0x%x\n",
-				x86_cap_flags[df->feature], df->level);
+		pr_warning("CPU feature %s disabled, no CPUID level 0x%x\n",
+			   x86_cap_flags[df->feature], df->level);
 	}
 }
 
@@ -391,8 +392,8 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 
 	if (n >= 0x80000005) {
 		cpuid(0x80000005, &dummy, &ebx, &ecx, &edx);
-		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), D cache %dK (%d bytes/line)\n",
-				edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
+		pr_info("L1 I Cache: %dK (%d bytes/line), D cache %dK (%d bytes/line)\n",
+			edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
 		c->x86_cache_size = (ecx>>24) + (edx>>24);
 #ifdef CONFIG_X86_64
 		/* On K8 L1 TLB is inclusive, so don't count it */
@@ -423,8 +424,7 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 
 	c->x86_cache_size = l2size;
 
-	printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
-			l2size, ecx & 0xFF);
+	pr_info("L2 Cache: %dK (%d bytes/line)\n", l2size, ecx & 0xFF);
 }
 
 void __cpuinit detect_ht(struct cpuinfo_x86 *c)
@@ -447,7 +447,7 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 	smp_num_siblings = (ebx & 0xff0000) >> 16;
 
 	if (smp_num_siblings == 1) {
-		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
+		pr_info("Hyper-Threading is disabled\n");
 		goto out;
 	}
 
@@ -455,7 +455,7 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 		goto out;
 
 	if (smp_num_siblings > nr_cpu_ids) {
-		pr_warning("CPU: Unsupported number of siblings %d",
+		pr_warning("Unsupported number of siblings %d",
 			   smp_num_siblings);
 		smp_num_siblings = 1;
 		return;
@@ -475,10 +475,8 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 
 out:
 	if ((c->x86_max_cores * smp_num_siblings) > 1) {
-		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
-		       c->phys_proc_id);
-		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
-		       c->cpu_core_id);
+		pr_info("Physical Processor ID: %d\n", c->phys_proc_id);
+		pr_info("Processor Core ID: %d\n", c->cpu_core_id);
 	}
 #endif
 }
@@ -503,8 +501,8 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c)
 	}
 
 	printk_once(KERN_ERR
-			"CPU: vendor_id '%s' unknown, using generic init.\n" \
-			"CPU: Your system may be unstable.\n", v);
+		    pr_fmt("vendor_id '%s' unknown, using generic init.\n"
+			   "Your system may be unstable.\n"), v);
 
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	this_cpu = &default_cpu;
@@ -659,7 +657,7 @@ void __init early_cpu_init(void)
 	const struct cpu_dev *const *cdev;
 	int count = 0;
 
-	printk(KERN_INFO "KERNEL supported cpus:\n");
+	pr_info("KERNEL supported cpus:\n");
 	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
 		const struct cpu_dev *cpudev = *cdev;
 		unsigned int j;
@@ -672,8 +670,8 @@ void __init early_cpu_init(void)
 		for (j = 0; j < 2; j++) {
 			if (!cpudev->c_ident[j])
 				continue;
-			printk(KERN_INFO "  %s %s\n", cpudev->c_vendor,
-				cpudev->c_ident[j]);
+			pr_info("  %s %s\n",
+				cpudev->c_vendor, cpudev->c_ident[j]);
 		}
 	}
 
@@ -908,7 +906,7 @@ static void __cpuinit print_cpu_msr(void)
 		for (index = index_min; index < index_max; index++) {
 			if (rdmsrl_amd_safe(index, &val))
 				continue;
-			printk(KERN_INFO " MSR%08x: %016llx\n", index, val);
+			pr_info(" MSR%08x: %016llx\n", index, val);
 		}
 	}
 }
@@ -946,17 +944,17 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 	}
 
 	if (vendor && !strstr(c->x86_model_id, vendor))
-		printk(KERN_CONT "%s ", vendor);
+		pr_cont("%s ", vendor);
 
 	if (c->x86_model_id[0])
-		printk(KERN_CONT "%s", c->x86_model_id);
+		pr_cont("%s", c->x86_model_id);
 	else
-		printk(KERN_CONT "%d86", c->x86);
+		pr_cont("%d86", c->x86);
 
 	if (c->x86_mask || c->cpuid_level >= 0)
-		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
+		pr_cont(" stepping %02x\n", c->x86_mask);
 	else
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 
 #ifdef CONFIG_SMP
 	if (c->cpu_index < show_msr)
@@ -1115,7 +1113,7 @@ void __cpuinit cpu_init(void)
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask))
 		panic("CPU#%d already initialized!\n", cpu);
 
-	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
+	pr_info("Initializing CPU#%d\n", cpu);
 
 	clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
 
@@ -1203,12 +1201,12 @@ void __cpuinit cpu_init(void)
 	struct thread_struct *thread = &curr->thread;
 
 	if (cpumask_test_and_set_cpu(cpu, cpu_initialized_mask)) {
-		printk(KERN_WARNING "CPU#%d already initialized!\n", cpu);
+		pr_warning("CPU#%d already initialized!\n", cpu);
 		for (;;)
 			local_irq_enable();
 	}
 
-	printk(KERN_INFO "Initializing CPU#%d\n", cpu);
+	pr_info("Initializing CPU#%d\n", cpu);
 
 	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
 		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index dca325c..d1ffd64 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -6,6 +6,8 @@
  * For licencing details see kernel-base/COPYING
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/interrupt.h>
 #include <linux/compiler.h>
 #include <linux/seq_file.h>
@@ -208,7 +210,7 @@ static void print_cpu_data(struct seq_file *seq, unsigned type,
 			seq_printf(seq, " %08x: %08x_%08x\n",
 				   type, high, low);
 	} else
-		printk(KERN_INFO " %08x: %08x_%08x\n", type, high, low);
+		pr_info(" %08x: %08x_%08x\n", type, high, low);
 }
 
 /* This function can also be called with seq = NULL for printk */
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index 19807b8..0bc8ff5 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/bitops.h>
 #include <linux/delay.h>
@@ -104,7 +106,7 @@ static void __cpuinit check_cx686_slop(struct cpuinfo_x86 *c)
 		local_irq_restore(flags);
 
 		if (ccr5 & 2) { /* possible wrong calibration done */
-			printk(KERN_INFO "Recalibrating delay loop with SLOP bit reset\n");
+			pr_info("Recalibrating delay loop with SLOP bit reset\n");
 			calibrate_delay();
 			c->loops_per_jiffy = loops_per_jiffy;
 		}
@@ -116,7 +118,7 @@ static void __cpuinit set_cx86_reorder(void)
 {
 	u8 ccr3;
 
-	printk(KERN_INFO "Enable Memory access reorder on Cyrix/NSC processor.\n");
+	pr_info("Enable Memory access reorder on Cyrix/NSC processor.\n");
 	ccr3 = getCx86(CX86_CCR3);
 	setCx86(CX86_CCR3, (ccr3 & 0x0f) | 0x10); /* enable MAPEN */
 
@@ -129,7 +131,7 @@ static void __cpuinit set_cx86_reorder(void)
 
 static void __cpuinit set_cx86_memwb(void)
 {
-	printk(KERN_INFO "Enable Memory-Write-back mode on Cyrix/NSC processor.\n");
+	pr_info("Enable Memory-Write-back mode on Cyrix/NSC processor.\n");
 
 	/* CCR2 bit 2: unlock NW bit */
 	setCx86_old(CX86_CCR2, getCx86_old(CX86_CCR2) & ~0x04);
@@ -269,7 +271,7 @@ static void __cpuinit init_cyrix(struct cpuinfo_x86 *c)
 		 *  VSA1 we work around however.
 		 */
 
-		printk(KERN_INFO "Working around Cyrix MediaGX virtual DMA bugs.\n");
+		pr_info("Working around Cyrix MediaGX virtual DMA bugs.\n");
 		isa_dma_bridge_buggy = 2;
 
 		/* We do this before the PCI layer is running. However we
@@ -426,7 +428,7 @@ static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
 		if (dir0 == 5 || dir0 == 3) {
 			unsigned char ccr3;
 			unsigned long flags;
-			printk(KERN_INFO "Enabling CPUID on Cyrix processor.\n");
+			pr_info("Enabling CPUID on Cyrix processor.\n");
 			local_irq_save(flags);
 			ccr3 = getCx86(CX86_CCR3);
 			/* enable MAPEN  */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 40e1835..2175edb 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/kernel.h>
 
@@ -102,7 +104,7 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
 
 		if (misc_enable & MSR_IA32_MISC_ENABLE_FAST_STRING) {
-			printk(KERN_INFO "kmemcheck: Disabling fast string operations\n");
+			pr_info("kmemcheck: Disabling fast string operations\n");
 
 			misc_enable &= ~MSR_IA32_MISC_ENABLE_FAST_STRING;
 			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
@@ -125,7 +127,7 @@ int __cpuinit ppro_with_ram_bug(void)
 	    boot_cpu_data.x86 == 6 &&
 	    boot_cpu_data.x86_model == 1 &&
 	    boot_cpu_data.x86_mask < 8) {
-		printk(KERN_INFO "Pentium Pro with Errata#50 detected. Taking evasive action.\n");
+		pr_info("Pentium Pro with Errata#50 detected. Taking evasive action.\n");
 		return 1;
 	}
 	return 0;
@@ -185,7 +187,7 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 		c->f00f_bug = 1;
 		if (!f00f_workaround_enabled) {
 			trap_init_f00f_bug();
-			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
+			pr_notice("Intel Pentium with F0 0F bug - workaround enabled.\n");
 			f00f_workaround_enabled = 1;
 		}
 	}
@@ -205,8 +207,8 @@ static void __cpuinit intel_workarounds(struct cpuinfo_x86 *c)
 	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
 		rdmsr(MSR_IA32_MISC_ENABLE, lo, hi);
 		if ((lo & MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE) == 0) {
-			printk (KERN_INFO "CPU: C0 stepping P4 Xeon detected.\n");
-			printk (KERN_INFO "CPU: Disabling hardware prefetching (Errata 037)\n");
+			pr_info("C0 stepping P4 Xeon detected.\n");
+			pr_info("Disabling hardware prefetching (Errata 037)\n");
 			lo |= MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE;
 			wrmsr(MSR_IA32_MISC_ENABLE, lo, hi);
 		}
@@ -267,7 +269,7 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
 		node = first_node(node_online_map);
 	numa_set_node(cpu, node);
 
-	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
+	pr_info("CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
 #endif
 }
 
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 804c40e..ce3aefe 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -7,6 +7,8 @@
  *	Andi Kleen / Andreas Herrmann	: CPUID4 emulation on AMD.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/device.h>
@@ -489,20 +491,20 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	}
 
 	if (trace)
-		printk(KERN_INFO "CPU: Trace cache: %dK uops", trace);
+		pr_info("Trace cache: %dK uops", trace);
 	else if (l1i)
-		printk(KERN_INFO "CPU: L1 I cache: %dK", l1i);
+		pr_info("L1 I cache: %dK", l1i);
 
 	if (l1d)
-		printk(KERN_CONT ", L1 D cache: %dK\n", l1d);
+		pr_cont(", L1 D cache: %dK\n", l1d);
 	else
-		printk(KERN_CONT "\n");
+		pr_cont("\n");
 
 	if (l2)
-		printk(KERN_INFO "CPU: L2 cache: %dK\n", l2);
+		pr_info("L2 cache: %dK\n", l2);
 
 	if (l3)
-		printk(KERN_INFO "CPU: L3 cache: %dK\n", l3);
+		pr_info("L3 cache: %dK\n", l3);
 
 	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b5801c3..4b0f0f7 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -11,6 +11,8 @@
  *  For licencing details see kernel-base/COPYING
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/perf_event.h>
 #include <linux/capability.h>
 #include <linux/notifier.h>
@@ -1612,7 +1614,7 @@ static void intel_pmu_reset(void)
 
 	local_irq_save(flags);
 
-	printk("clearing PMU state on CPU#%d\n", smp_processor_id());
+	pr_info("clearing PMU state on CPU#%d\n", smp_processor_id());
 
 	for (idx = 0; idx < x86_pmu.num_events; idx++) {
 		checking_wrmsrl(x86_pmu.eventsel + idx, 0ull);
@@ -2064,7 +2066,8 @@ void __init init_hw_perf_events(void)
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
 	if (x86_pmu.num_events > X86_PMC_MAX_GENERIC) {
-		WARN(1, KERN_ERR "hw perf events %d > max(%d), clipping!",
+		WARN(1,
+		     KERN_ERR pr_fmt("hw perf events %d > max(%d), clipping!"),
 		     x86_pmu.num_events, X86_PMC_MAX_GENERIC);
 		x86_pmu.num_events = X86_PMC_MAX_GENERIC;
 	}
@@ -2072,7 +2075,8 @@ void __init init_hw_perf_events(void)
 	perf_max_events = x86_pmu.num_events;
 
 	if (x86_pmu.num_events_fixed > X86_PMC_MAX_FIXED) {
-		WARN(1, KERN_ERR "hw perf events fixed %d > max(%d), clipping!",
+		WARN(1,
+		     KERN_ERR pr_fmt("hw perf events fixed %d > max(%d), clipping!"),
 		     x86_pmu.num_events_fixed, X86_PMC_MAX_FIXED);
 		x86_pmu.num_events_fixed = X86_PMC_MAX_FIXED;
 	}
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index fab786f..0636316 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -11,6 +11,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/percpu.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
@@ -211,7 +213,7 @@ void enable_lapic_nmi_watchdog(void)
 	if (!wd_ops)
 		return;
 	if (!wd_ops->reserve()) {
-		printk(KERN_ERR "NMI watchdog: cannot reserve perfctrs\n");
+		pr_err("cannot reserve perfctrs\n");
 		return;
 	}
 
@@ -757,19 +759,18 @@ int lapic_watchdog_init(unsigned nmi_hz)
 	if (!wd_ops) {
 		probe_nmi_watchdog();
 		if (!wd_ops) {
-			printk(KERN_INFO "NMI watchdog: CPU not supported\n");
+			pr_info("CPU not supported\n");
 			return -1;
 		}
 
 		if (!wd_ops->reserve()) {
-			printk(KERN_ERR
-				"NMI watchdog: cannot reserve perfctrs\n");
+			pr_err("cannot reserve perfctrs\n");
 			return -1;
 		}
 	}
 
 	if (!(wd_ops->setup(nmi_hz))) {
-		printk(KERN_ERR "Cannot setup NMI watchdog on CPU %d\n",
+		pr_err("Cannot setup NMI watchdog on CPU %d\n",
 		       raw_smp_processor_id());
 		return -1;
 	}
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index bb62b3e..c73d9ec 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -1,3 +1,5 @@
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/init.h>
@@ -34,7 +36,7 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 	if (max >= 0x80860001) {
 		cpuid(0x80860001, &dummy, &cpu_rev, &cpu_freq, &cpu_flags);
 		if (cpu_rev != 0x02000000) {
-			printk(KERN_INFO "CPU: Processor revision %u.%u.%u.%u, %u MHz\n",
+			pr_info("Processor revision %u.%u.%u.%u, %u MHz\n",
 				(cpu_rev >> 24) & 0xff,
 				(cpu_rev >> 16) & 0xff,
 				(cpu_rev >> 8) & 0xff,
@@ -45,15 +47,15 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 	if (max >= 0x80860002) {
 		cpuid(0x80860002, &new_cpu_rev, &cms_rev1, &cms_rev2, &dummy);
 		if (cpu_rev == 0x02000000) {
-			printk(KERN_INFO "CPU: Processor revision %08X, %u MHz\n",
+			pr_info("Processor revision %08X, %u MHz\n",
 				new_cpu_rev, cpu_freq);
 		}
-		printk(KERN_INFO "CPU: Code Morphing Software revision %u.%u.%u-%u-%u\n",
-		       (cms_rev1 >> 24) & 0xff,
-		       (cms_rev1 >> 16) & 0xff,
-		       (cms_rev1 >> 8) & 0xff,
-		       cms_rev1 & 0xff,
-		       cms_rev2);
+		pr_info("Code Morphing Software revision %u.%u.%u-%u-%u\n",
+			(cms_rev1 >> 24) & 0xff,
+			(cms_rev1 >> 16) & 0xff,
+			(cms_rev1 >> 8) & 0xff,
+			cms_rev1 & 0xff,
+			cms_rev2);
 	}
 	if (max >= 0x80860006) {
 		cpuid(0x80860003,
@@ -77,7 +79,7 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 		      (void *)&cpu_info[56],
 		      (void *)&cpu_info[60]);
 		cpu_info[64] = '\0';
-		printk(KERN_INFO "CPU: %s\n", cpu_info);
+		pr_info("%s\n", cpu_info);
 	}
 
 	/* Unhide possibly hidden capability flags */
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index 1cbed97..0582ca6 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -21,6 +21,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/dmi.h>
 #include <asm/div64.h>
 #include <asm/vmware.h>
@@ -58,9 +60,9 @@ static unsigned long vmware_get_tsc_khz(void)
 	tsc_hz = eax | (((uint64_t)ebx) << 32);
 	do_div(tsc_hz, 1000);
 	BUG_ON(tsc_hz >> 32);
-	printk(KERN_INFO "TSC freq read from hypervisor : %lu.%03lu MHz\n",
-			 (unsigned long) tsc_hz / 1000,
-			 (unsigned long) tsc_hz % 1000);
+	pr_info("TSC freq read from hypervisor : %lu.%03lu MHz\n",
+		(unsigned long) tsc_hz / 1000,
+		(unsigned long) tsc_hz % 1000);
 	return tsc_hz;
 }
 
@@ -73,8 +75,7 @@ void __init vmware_platform_setup(void)
 	if (ebx != UINT_MAX)
 		x86_platform.calibrate_tsc = vmware_get_tsc_khz;
 	else
-		printk(KERN_WARNING
-		       "Failed to get TSC freq from the hypervisor\n");
+		pr_warning("Failed to get TSC freq from the hypervisor\n");
 }
 
 /*
-- 
1.6.3.1.10.g659a0.dirty

