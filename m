Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbZAZRRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbZAZRRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 12:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZAZRRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 12:17:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55165 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZAZRRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 12:17:41 -0500
Date: Mon, 26 Jan 2009 18:17:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [git pull] x86 fixes
Message-ID: <20090126171723.GA32030@elte.hu>
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

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus


out-of-topic modifications in x86-fixes-for-linus:
--------------------------------------------------
include/asm-generic/bitops/__ffs.h # c839994: x86, generic: mark complex bitops
include/asm-generic/bitops/__fls.h # c839994: x86, generic: mark complex bitops
include/asm-generic/bitops/fls.h   # c839994: x86, generic: mark complex bitops
include/asm-generic/bitops/fls64.h # c839994: x86, generic: mark complex bitops
kernel/workqueue.c                 # 8ccad40: work_on_cpu: Use our own workqueu
                                   # 31ad908: work_on_cpu: don't try to get_onl

 Thanks,

	Ingo

------------------>
Andi Kleen (2):
      x86, generic: mark complex bitops.h inlines as __always_inline
      x86: use early clobbers in usercopy*.c

Cliff Wickman (1):
      x86, UV: cpu_relax in uv_wait_completion

Dan Magenheimer (1):
      xen: actually release memory when shrinking domain

Eric Anholt (1):
      x86: work around PAGE_KERNEL_WC not getting WC in iomap_atomic_prot_pfn.

Gary Hade (1):
      x86: remove kernel_physical_mapping_init() from init section

H. Peter Anvin (2):
      x86: add MSR_IA32_MISC_ENABLE bits to <asm/msr-index.h>
      x86: unmask CPUID levels on Intel CPUs

Ian Campbell (2):
      xen: handle highmem pages correctly when shrinking a domain
      xen: unitialised return value in xenbus_write_transaction

Ingo Molnar (5):
      x86, cpufreq: remove leftover copymask_copy()
      fix: crash: IP: __bitmap_intersects+0x48/0x73
      Revert "x86: signal: change type of paramter for sys_rt_sigreturn()"
      x86: use standard PIT frequency
      x86: unmask CPUID levels on Intel CPUs, fix

Jan Beulich (2):
      x86: avoid early crash in disable_local_APIC()
      x86: fix assumed to be contiguous leaf page tables for kmap_atomic region (take 2)

Jeff Mahoney (1):
      x86: define ARCH_WANT_FRAME_POINTERS

Leonardo Potenza (1):
      x86: fix section mismatch warnings in kernel/setup_percpu.c

Mike Travis (2):
      x86: put trigger in to detect mismatched apic versions
      cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write

Peter Zijlstra (1):
      x86, mm: fix pte_free()

Rakib Mullick (1):
      x86: fix section mismatch warning

Rusty Russell (2):
      work_on_cpu: don't try to get_online_cpus() in work_on_cpu.
      work_on_cpu: Use our own workqueue.

Suresh Siddha (3):
      x86, pat: fix reserve_memtype() for legacy 1MB range
      x86: fix page attribute corruption with cpa()
      x86: fix PTE corruption issue while mapping RAM using /dev/mem

Thomas Renninger (1):
      x86: mtrr fix debug boot parameter


 arch/x86/include/asm/bitops.h              |   14 ++++++--
 arch/x86/include/asm/io.h                  |    1 -
 arch/x86/include/asm/msr-index.h           |   29 ++++++++++++++++
 arch/x86/include/asm/pgalloc.h             |    1 +
 arch/x86/include/asm/syscalls.h            |    2 +-
 arch/x86/include/asm/timex.h               |   13 ++-----
 arch/x86/kernel/apic.c                     |    9 +++++
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   35 +++++++------------
 arch/x86/kernel/cpu/intel.c                |   13 +++++++
 arch/x86/kernel/cpu/mtrr/generic.c         |   12 ++++---
 arch/x86/kernel/setup_percpu.c             |    2 +-
 arch/x86/kernel/signal.c                   |   11 +++++-
 arch/x86/kernel/tlb_uv.c                   |    1 +
 arch/x86/kernel/vmi_32.c                   |    2 +-
 arch/x86/lib/usercopy_32.c                 |    4 +-
 arch/x86/lib/usercopy_64.c                 |    4 +-
 arch/x86/mm/init_32.c                      |   48 +++++++++++++++++++++++++--
 arch/x86/mm/init_64.c                      |    2 +-
 arch/x86/mm/iomap_32.c                     |   10 ++++++
 arch/x86/mm/ioremap.c                      |   25 --------------
 arch/x86/mm/pageattr.c                     |   49 +++++++++++++++++++--------
 arch/x86/mm/pat.c                          |   43 +++++++++++++++++-------
 drivers/xen/balloon.c                      |    8 ++++
 drivers/xen/xenfs/xenbus.c                 |   11 +++---
 include/asm-generic/bitops/__ffs.h         |    2 +-
 include/asm-generic/bitops/__fls.h         |    2 +-
 include/asm-generic/bitops/fls.h           |    2 +-
 include/asm-generic/bitops/fls64.h         |    4 +-
 kernel/workqueue.c                         |   20 ++++++------
 lib/Kconfig.debug                          |    9 +++++
 30 files changed, 260 insertions(+), 128 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index e02a359..02b47a6 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -3,6 +3,9 @@
 
 /*
  * Copyright 1992, Linus Torvalds.
+ *
+ * Note: inlines with more than a single statement should be marked
+ * __always_inline to avoid problems with older gcc's inlining heuristics.
  */
 
 #ifndef _LINUX_BITOPS_H
@@ -53,7 +56,8 @@
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
-static inline void set_bit(unsigned int nr, volatile unsigned long *addr)
+static __always_inline void
+set_bit(unsigned int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "orb %1,%0"
@@ -90,7 +94,8 @@ static inline void __set_bit(int nr, volatile unsigned long *addr)
  * you should call smp_mb__before_clear_bit() and/or smp_mb__after_clear_bit()
  * in order to ensure changes are visible on other processors.
  */
-static inline void clear_bit(int nr, volatile unsigned long *addr)
+static __always_inline void
+clear_bit(int nr, volatile unsigned long *addr)
 {
 	if (IS_IMMEDIATE(nr)) {
 		asm volatile(LOCK_PREFIX "andb %1,%0"
@@ -204,7 +209,8 @@ static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
  *
  * This is the same as test_and_set_bit on x86.
  */
-static inline int test_and_set_bit_lock(int nr, volatile unsigned long *addr)
+static __always_inline int
+test_and_set_bit_lock(int nr, volatile unsigned long *addr)
 {
 	return test_and_set_bit(nr, addr);
 }
@@ -300,7 +306,7 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 	return oldbit;
 }
 
-static inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
+static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
 		(((unsigned long *)addr)[nr / BITS_PER_LONG])) != 0;
diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 05cfed4..1dbbdf4 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -99,7 +99,6 @@ extern void __iomem *ioremap_wc(unsigned long offset, unsigned long size);
  * A boot-time mapping is currently limited to at most 16 pages.
  */
 extern void early_ioremap_init(void);
-extern void early_ioremap_clear(void);
 extern void early_ioremap_reset(void);
 extern void __iomem *early_ioremap(unsigned long offset, unsigned long size);
 extern void __iomem *early_memremap(unsigned long offset, unsigned long size);
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index cb58643..358acc5 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -202,6 +202,35 @@
 #define MSR_IA32_THERM_STATUS		0x0000019c
 #define MSR_IA32_MISC_ENABLE		0x000001a0
 
+/* MISC_ENABLE bits: architectural */
+#define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
+#define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
+#define MSR_IA32_MISC_ENABLE_EMON		(1ULL << 7)
+#define MSR_IA32_MISC_ENABLE_BTS_UNAVAIL	(1ULL << 11)
+#define MSR_IA32_MISC_ENABLE_PEBS_UNAVAIL	(1ULL << 12)
+#define MSR_IA32_MISC_ENABLE_ENHANCED_SPEEDSTEP	(1ULL << 16)
+#define MSR_IA32_MISC_ENABLE_MWAIT		(1ULL << 18)
+#define MSR_IA32_MISC_ENABLE_LIMIT_CPUID	(1ULL << 22)
+#define MSR_IA32_MISC_ENABLE_XTPR_DISABLE	(1ULL << 23)
+#define MSR_IA32_MISC_ENABLE_XD_DISABLE		(1ULL << 34)
+
+/* MISC_ENABLE bits: model-specific, meaning may vary from core to core */
+#define MSR_IA32_MISC_ENABLE_X87_COMPAT		(1ULL << 2)
+#define MSR_IA32_MISC_ENABLE_TM1		(1ULL << 3)
+#define MSR_IA32_MISC_ENABLE_SPLIT_LOCK_DISABLE	(1ULL << 4)
+#define MSR_IA32_MISC_ENABLE_L3CACHE_DISABLE	(1ULL << 6)
+#define MSR_IA32_MISC_ENABLE_SUPPRESS_LOCK	(1ULL << 8)
+#define MSR_IA32_MISC_ENABLE_PREFETCH_DISABLE	(1ULL << 9)
+#define MSR_IA32_MISC_ENABLE_FERR		(1ULL << 10)
+#define MSR_IA32_MISC_ENABLE_FERR_MULTIPLEX	(1ULL << 10)
+#define MSR_IA32_MISC_ENABLE_TM2		(1ULL << 13)
+#define MSR_IA32_MISC_ENABLE_ADJ_PREF_DISABLE	(1ULL << 19)
+#define MSR_IA32_MISC_ENABLE_SPEEDSTEP_LOCK	(1ULL << 20)
+#define MSR_IA32_MISC_ENABLE_L1D_CONTEXT	(1ULL << 24)
+#define MSR_IA32_MISC_ENABLE_DCU_PREF_DISABLE	(1ULL << 37)
+#define MSR_IA32_MISC_ENABLE_TURBO_DISABLE	(1ULL << 38)
+#define MSR_IA32_MISC_ENABLE_IP_PREF_DISABLE	(1ULL << 39)
+
 /* Intel Model 6 */
 #define MSR_P6_EVNTSEL0			0x00000186
 #define MSR_P6_EVNTSEL1			0x00000187
diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgalloc.h
index cb7c151..dd14c54 100644
--- a/arch/x86/include/asm/pgalloc.h
+++ b/arch/x86/include/asm/pgalloc.h
@@ -42,6 +42,7 @@ static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 
 static inline void pte_free(struct mm_struct *mm, struct page *pte)
 {
+	pgtable_page_dtor(pte);
 	__free_page(pte);
 }
 
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 9c6797c..c0b0bda 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -40,7 +40,7 @@ asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
 asmlinkage int sys_sigaltstack(unsigned long);
 asmlinkage unsigned long sys_sigreturn(unsigned long);
-asmlinkage int sys_rt_sigreturn(struct pt_regs);
+asmlinkage int sys_rt_sigreturn(unsigned long);
 
 /* kernel/ioport.c */
 asmlinkage long sys_iopl(unsigned long);
diff --git a/arch/x86/include/asm/timex.h b/arch/x86/include/asm/timex.h
index 1287dc1..b5c9d45 100644
--- a/arch/x86/include/asm/timex.h
+++ b/arch/x86/include/asm/timex.h
@@ -1,18 +1,13 @@
-/* x86 architecture timex specifications */
 #ifndef _ASM_X86_TIMEX_H
 #define _ASM_X86_TIMEX_H
 
 #include <asm/processor.h>
 #include <asm/tsc.h>
 
-#ifdef CONFIG_X86_ELAN
-#  define PIT_TICK_RATE 1189200 /* AMD Elan has different frequency! */
-#elif defined(CONFIG_X86_RDC321X)
-#  define PIT_TICK_RATE 1041667 /* Underlying HZ for R8610 */
-#else
-#  define PIT_TICK_RATE 1193182 /* Underlying HZ */
-#endif
-#define CLOCK_TICK_RATE	PIT_TICK_RATE
+/* The PIT ticks at this frequency (in HZ): */
+#define PIT_TICK_RATE		1193182
+
+#define CLOCK_TICK_RATE		PIT_TICK_RATE
 
 #define ARCH_HAS_READ_CURRENT_TIMER
 
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 0f830e4..4b6df24 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -895,6 +895,10 @@ void disable_local_APIC(void)
 {
 	unsigned int value;
 
+	/* APIC hasn't been mapped yet */
+	if (!apic_phys)
+		return;
+
 	clear_local_APIC();
 
 	/*
@@ -1833,6 +1837,11 @@ void __cpuinit generic_processor_info(int apicid, int version)
 	num_processors++;
 	cpu = cpumask_next_zero(-1, cpu_present_mask);
 
+	if (version != apic_version[boot_cpu_physical_apicid])
+		WARN_ONCE(1,
+			"ACPI: apic version mismatch, bootcpu: %x cpu %d: %x\n",
+			apic_version[boot_cpu_physical_apicid], cpu, version);
+
 	physid_set(apicid, phys_cpu_present_map);
 	if (apicid == boot_cpu_physical_apicid) {
 		/*
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 6f11e02..4b1c319 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -145,13 +145,14 @@ typedef union {
 
 struct drv_cmd {
 	unsigned int type;
-	cpumask_var_t mask;
+	const struct cpumask *mask;
 	drv_addr_union addr;
 	u32 val;
 };
 
-static void do_drv_read(struct drv_cmd *cmd)
+static long do_drv_read(void *_cmd)
 {
+	struct drv_cmd *cmd = _cmd;
 	u32 h;
 
 	switch (cmd->type) {
@@ -166,10 +167,12 @@ static void do_drv_read(struct drv_cmd *cmd)
 	default:
 		break;
 	}
+	return 0;
 }
 
-static void do_drv_write(struct drv_cmd *cmd)
+static long do_drv_write(void *_cmd)
 {
+	struct drv_cmd *cmd = _cmd;
 	u32 lo, hi;
 
 	switch (cmd->type) {
@@ -186,30 +189,23 @@ static void do_drv_write(struct drv_cmd *cmd)
 	default:
 		break;
 	}
+	return 0;
 }
 
 static void drv_read(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
 	cmd->val = 0;
 
-	set_cpus_allowed_ptr(current, cmd->mask);
-	do_drv_read(cmd);
-	set_cpus_allowed_ptr(current, &saved_mask);
+	work_on_cpu(cpumask_any(cmd->mask), do_drv_read, cmd);
 }
 
 static void drv_write(struct drv_cmd *cmd)
 {
-	cpumask_t saved_mask = current->cpus_allowed;
 	unsigned int i;
 
 	for_each_cpu(i, cmd->mask) {
-		set_cpus_allowed_ptr(current, cpumask_of(i));
-		do_drv_write(cmd);
+		work_on_cpu(i, do_drv_write, cmd);
 	}
-
-	set_cpus_allowed_ptr(current, &saved_mask);
-	return;
 }
 
 static u32 get_cur_val(const struct cpumask *mask)
@@ -235,8 +231,7 @@ static u32 get_cur_val(const struct cpumask *mask)
 		return 0;
 	}
 
-	cpumask_copy(cmd.mask, mask);
-
+	cmd.mask = mask;
 	drv_read(&cmd);
 
 	dprintk("get_cur_val = %u\n", cmd.val);
@@ -368,7 +363,7 @@ static unsigned int get_cur_freq_on_cpu(unsigned int cpu)
 	return freq;
 }
 
-static unsigned int check_freqs(const cpumask_t *mask, unsigned int freq,
+static unsigned int check_freqs(const struct cpumask *mask, unsigned int freq,
 				struct acpi_cpufreq_data *data)
 {
 	unsigned int cur_freq;
@@ -403,9 +398,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 		return -ENODEV;
 	}
 
-	if (unlikely(!alloc_cpumask_var(&cmd.mask, GFP_KERNEL)))
-		return -ENOMEM;
-
 	perf = data->acpi_data;
 	result = cpufreq_frequency_table_target(policy,
 						data->freq_table,
@@ -450,9 +442,9 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 
 	/* cpufreq holds the hotplug lock, so we are safe from here on */
 	if (policy->shared_type != CPUFREQ_SHARED_TYPE_ANY)
-		cpumask_and(cmd.mask, cpu_online_mask, policy->cpus);
+		cmd.mask = policy->cpus;
 	else
-		cpumask_copy(cmd.mask, cpumask_of(policy->cpu));
+		cmd.mask = cpumask_of(policy->cpu);
 
 	freqs.old = perf->states[perf->state].core_frequency * 1000;
 	freqs.new = data->freq_table[next_state].frequency;
@@ -479,7 +471,6 @@ static int acpi_cpufreq_target(struct cpufreq_policy *policy,
 	perf->state = next_perf_state;
 
 out:
-	free_cpumask_var(cmd.mask);
 	return result;
 }
 
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 8ea6929..549f2ad 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -29,6 +29,19 @@
 
 static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
 {
+	/* Unmask CPUID levels if masked: */
+	if (c->x86 == 6 && c->x86_model >= 15) {
+		u64 misc_enable;
+
+		rdmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+
+		if (misc_enable & MSR_IA32_MISC_ENABLE_LIMIT_CPUID) {
+			misc_enable &= ~MSR_IA32_MISC_ENABLE_LIMIT_CPUID;
+			wrmsrl(MSR_IA32_MISC_ENABLE, misc_enable);
+			c->cpuid_level = cpuid_eax(0);
+		}
+	}
+
 	if ((c->x86 == 0xf && c->x86_model >= 0x03) ||
 		(c->x86 == 0x6 && c->x86_model >= 0x0e))
 		set_cpu_cap(c, X86_FEATURE_CONSTANT_TSC);
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index b59ddcc..0c0a455 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -33,11 +33,13 @@ u64 mtrr_tom2;
 struct mtrr_state_type mtrr_state = {};
 EXPORT_SYMBOL_GPL(mtrr_state);
 
-#undef MODULE_PARAM_PREFIX
-#define MODULE_PARAM_PREFIX "mtrr."
-
-static int mtrr_show;
-module_param_named(show, mtrr_show, bool, 0);
+static int __initdata mtrr_show;
+static int __init mtrr_debug(char *opt)
+{
+	mtrr_show = 1;
+	return 0;
+}
+early_param("mtrr.show", mtrr_debug);
 
 /*
  * Returns the effective MTRR type for the region
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 55c4607..0116107 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -136,7 +136,7 @@ static void __init setup_cpu_pda_map(void)
 #ifdef CONFIG_X86_64
 
 /* correctly size the local cpu masks */
-static void setup_cpu_local_masks(void)
+static void __init setup_cpu_local_masks(void)
 {
 	alloc_bootmem_cpumask_var(&cpu_initialized_mask);
 	alloc_bootmem_cpumask_var(&cpu_callin_mask);
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 89bb766..df0587f 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -632,9 +632,16 @@ badframe:
 }
 
 #ifdef CONFIG_X86_32
-asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
+/*
+ * Note: do not pass in pt_regs directly as with tail-call optimization
+ * GCC will incorrectly stomp on the caller's frame and corrupt user-space
+ * register state:
+ */
+asmlinkage int sys_rt_sigreturn(unsigned long __unused)
 {
-	return do_rt_sigreturn(&regs);
+	struct pt_regs *regs = (struct pt_regs *)&__unused;
+
+	return do_rt_sigreturn(regs);
 }
 #else /* !CONFIG_X86_32 */
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index f885023..6812b82 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -200,6 +200,7 @@ static int uv_wait_completion(struct bau_desc *bau_desc,
 				destination_timeouts = 0;
 			}
 		}
+		cpu_relax();
 	}
 	return FLUSH_COMPLETE;
 }
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index 23206ba..1d3302c 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -858,7 +858,7 @@ void __init vmi_init(void)
 #endif
 }
 
-void vmi_activate(void)
+void __init vmi_activate(void)
 {
 	unsigned long flags;
 
diff --git a/arch/x86/lib/usercopy_32.c b/arch/x86/lib/usercopy_32.c
index 4a20b2f..7c8ca91 100644
--- a/arch/x86/lib/usercopy_32.c
+++ b/arch/x86/lib/usercopy_32.c
@@ -56,7 +56,7 @@ do {									   \
 		"	jmp 2b\n"					   \
 		".previous\n"						   \
 		_ASM_EXTABLE(0b,3b)					   \
-		: "=d"(res), "=c"(count), "=&a" (__d0), "=&S" (__d1),	   \
+		: "=&d"(res), "=&c"(count), "=&a" (__d0), "=&S" (__d1),	   \
 		  "=&D" (__d2)						   \
 		: "i"(-EFAULT), "0"(count), "1"(count), "3"(src), "4"(dst) \
 		: "memory");						   \
@@ -218,7 +218,7 @@ long strnlen_user(const char __user *s, long n)
 		"	.align 4\n"
 		"	.long 0b,2b\n"
 		".previous"
-		:"=r" (n), "=D" (s), "=a" (res), "=c" (tmp)
+		:"=&r" (n), "=&D" (s), "=&a" (res), "=&c" (tmp)
 		:"0" (n), "1" (s), "2" (0), "3" (mask)
 		:"cc");
 	return res & mask;
diff --git a/arch/x86/lib/usercopy_64.c b/arch/x86/lib/usercopy_64.c
index 64d6c84..ec13cb5 100644
--- a/arch/x86/lib/usercopy_64.c
+++ b/arch/x86/lib/usercopy_64.c
@@ -32,7 +32,7 @@ do {									   \
 		"	jmp 2b\n"					   \
 		".previous\n"						   \
 		_ASM_EXTABLE(0b,3b)					   \
-		: "=r"(res), "=c"(count), "=&a" (__d0), "=&S" (__d1),	   \
+		: "=&r"(res), "=&c"(count), "=&a" (__d0), "=&S" (__d1),	   \
 		  "=&D" (__d2)						   \
 		: "i"(-EFAULT), "0"(count), "1"(count), "3"(src), "4"(dst) \
 		: "memory");						   \
@@ -86,7 +86,7 @@ unsigned long __clear_user(void __user *addr, unsigned long size)
 		".previous\n"
 		_ASM_EXTABLE(0b,3b)
 		_ASM_EXTABLE(1b,2b)
-		: [size8] "=c"(size), [dst] "=&D" (__d0)
+		: [size8] "=&c"(size), [dst] "=&D" (__d0)
 		: [size1] "r"(size & 7), "[size8]" (size / 8), "[dst]"(addr),
 		  [zero] "r" (0UL), [eight] "r" (8UL));
 	return size;
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 88f1b10..2cef050 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -138,6 +138,47 @@ static pte_t * __init one_page_table_init(pmd_t *pmd)
 	return pte_offset_kernel(pmd, 0);
 }
 
+static pte_t *__init page_table_kmap_check(pte_t *pte, pmd_t *pmd,
+					   unsigned long vaddr, pte_t *lastpte)
+{
+#ifdef CONFIG_HIGHMEM
+	/*
+	 * Something (early fixmap) may already have put a pte
+	 * page here, which causes the page table allocation
+	 * to become nonlinear. Attempt to fix it, and if it
+	 * is still nonlinear then we have to bug.
+	 */
+	int pmd_idx_kmap_begin = fix_to_virt(FIX_KMAP_END) >> PMD_SHIFT;
+	int pmd_idx_kmap_end = fix_to_virt(FIX_KMAP_BEGIN) >> PMD_SHIFT;
+
+	if (pmd_idx_kmap_begin != pmd_idx_kmap_end
+	    && (vaddr >> PMD_SHIFT) >= pmd_idx_kmap_begin
+	    && (vaddr >> PMD_SHIFT) <= pmd_idx_kmap_end
+	    && ((__pa(pte) >> PAGE_SHIFT) < table_start
+		|| (__pa(pte) >> PAGE_SHIFT) >= table_end)) {
+		pte_t *newpte;
+		int i;
+
+		BUG_ON(after_init_bootmem);
+		newpte = alloc_low_page();
+		for (i = 0; i < PTRS_PER_PTE; i++)
+			set_pte(newpte + i, pte[i]);
+
+		paravirt_alloc_pte(&init_mm, __pa(newpte) >> PAGE_SHIFT);
+		set_pmd(pmd, __pmd(__pa(newpte)|_PAGE_TABLE));
+		BUG_ON(newpte != pte_offset_kernel(pmd, 0));
+		__flush_tlb_all();
+
+		paravirt_release_pte(__pa(pte) >> PAGE_SHIFT);
+		pte = newpte;
+	}
+	BUG_ON(vaddr < fix_to_virt(FIX_KMAP_BEGIN - 1)
+	       && vaddr > fix_to_virt(FIX_KMAP_END)
+	       && lastpte && lastpte + PTRS_PER_PTE != pte);
+#endif
+	return pte;
+}
+
 /*
  * This function initializes a certain range of kernel virtual memory
  * with new bootmem page tables, everywhere page tables are missing in
@@ -154,6 +195,7 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 	unsigned long vaddr;
 	pgd_t *pgd;
 	pmd_t *pmd;
+	pte_t *pte = NULL;
 
 	vaddr = start;
 	pgd_idx = pgd_index(vaddr);
@@ -165,7 +207,8 @@ page_table_range_init(unsigned long start, unsigned long end, pgd_t *pgd_base)
 		pmd = pmd + pmd_index(vaddr);
 		for (; (pmd_idx < PTRS_PER_PMD) && (vaddr != end);
 							pmd++, pmd_idx++) {
-			one_page_table_init(pmd);
+			pte = page_table_kmap_check(one_page_table_init(pmd),
+			                            pmd, vaddr, pte);
 
 			vaddr += PMD_SIZE;
 		}
@@ -508,7 +551,6 @@ static void __init early_ioremap_page_table_range_init(pgd_t *pgd_base)
 	 * Fixed mappings, only the page table structure has to be
 	 * created - mappings will be set by set_fixmap():
 	 */
-	early_ioremap_clear();
 	vaddr = __fix_to_virt(__end_of_fixed_addresses - 1) & PMD_MASK;
 	end = (FIXADDR_TOP + PMD_SIZE - 1) & PMD_MASK;
 	page_table_range_init(vaddr, end, pgd_base);
@@ -801,7 +843,7 @@ static void __init find_early_table_space(unsigned long end, int use_pse)
 	tables += PAGE_ALIGN(ptes * sizeof(pte_t));
 
 	/* for fixmap */
-	tables += PAGE_SIZE * 2;
+	tables += PAGE_ALIGN(__end_of_fixed_addresses * sizeof(pte_t));
 
 	/*
 	 * RED-PEN putting page tables only on node 0 could
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 23f68e7..e6d36b4 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -596,7 +596,7 @@ static void __init init_gbpages(void)
 		direct_gbpages = 0;
 }
 
-static unsigned long __init kernel_physical_mapping_init(unsigned long start,
+static unsigned long __meminit kernel_physical_mapping_init(unsigned long start,
 						unsigned long end,
 						unsigned long page_size_mask)
 {
diff --git a/arch/x86/mm/iomap_32.c b/arch/x86/mm/iomap_32.c
index d0151d8..ca53224 100644
--- a/arch/x86/mm/iomap_32.c
+++ b/arch/x86/mm/iomap_32.c
@@ -17,6 +17,7 @@
  */
 
 #include <asm/iomap.h>
+#include <asm/pat.h>
 #include <linux/module.h>
 
 /* Map 'pfn' using fixed map 'type' and protections 'prot'
@@ -29,6 +30,15 @@ iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot)
 
 	pagefault_disable();
 
+	/*
+	 * For non-PAT systems, promote PAGE_KERNEL_WC to PAGE_KERNEL_UC_MINUS.
+	 * PAGE_KERNEL_WC maps to PWT, which translates to uncached if the
+	 * MTRR is UC or WC.  UC_MINUS gets the real intention, of the
+	 * user, which is "WC if the MTRR is WC, UC if you can't do that."
+	 */
+	if (!pat_enabled && pgprot_val(prot) == pgprot_val(PAGE_KERNEL_WC))
+		prot = PAGE_KERNEL_UC_MINUS;
+
 	idx = type + KM_TYPE_NR*smp_processor_id();
 	vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
 	set_pte(kmap_pte-idx, pfn_pte(pfn, prot));
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index bd85d42..af750ab 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -557,34 +557,9 @@ void __init early_ioremap_init(void)
 	}
 }
 
-void __init early_ioremap_clear(void)
-{
-	pmd_t *pmd;
-
-	if (early_ioremap_debug)
-		printk(KERN_INFO "early_ioremap_clear()\n");
-
-	pmd = early_ioremap_pmd(fix_to_virt(FIX_BTMAP_BEGIN));
-	pmd_clear(pmd);
-	paravirt_release_pte(__pa(bm_pte) >> PAGE_SHIFT);
-	__flush_tlb_all();
-}
-
 void __init early_ioremap_reset(void)
 {
-	enum fixed_addresses idx;
-	unsigned long addr, phys;
-	pte_t *pte;
-
 	after_paging_init = 1;
-	for (idx = FIX_BTMAP_BEGIN; idx >= FIX_BTMAP_END; idx--) {
-		addr = fix_to_virt(idx);
-		pte = early_ioremap_pte(addr);
-		if (pte_present(*pte)) {
-			phys = pte_val(*pte) & PAGE_MASK;
-			set_fixmap(idx, phys);
-		}
-	}
 }
 
 static void __init __early_set_fixmap(enum fixed_addresses idx,
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index e89d248..84ba748 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -534,6 +534,36 @@ out_unlock:
 	return 0;
 }
 
+static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
+			       int primary)
+{
+	/*
+	 * Ignore all non primary paths.
+	 */
+	if (!primary)
+		return 0;
+
+	/*
+	 * Ignore the NULL PTE for kernel identity mapping, as it is expected
+	 * to have holes.
+	 * Also set numpages to '1' indicating that we processed cpa req for
+	 * one virtual address page and its pfn. TBD: numpages can be set based
+	 * on the initial value and the level returned by lookup_address().
+	 */
+	if (within(vaddr, PAGE_OFFSET,
+		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
+		cpa->numpages = 1;
+		cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
+		return 0;
+	} else {
+		WARN(1, KERN_WARNING "CPA: called for zero pte. "
+			"vaddr = %lx cpa->vaddr = %lx\n", vaddr,
+			*cpa->vaddr);
+
+		return -EFAULT;
+	}
+}
+
 static int __change_page_attr(struct cpa_data *cpa, int primary)
 {
 	unsigned long address;
@@ -549,17 +579,11 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 repeat:
 	kpte = lookup_address(address, &level);
 	if (!kpte)
-		return 0;
+		return __cpa_process_fault(cpa, address, primary);
 
 	old_pte = *kpte;
-	if (!pte_val(old_pte)) {
-		if (!primary)
-			return 0;
-		WARN(1, KERN_WARNING "CPA: called for zero pte. "
-		       "vaddr = %lx cpa->vaddr = %lx\n", address,
-		       *cpa->vaddr);
-		return -EINVAL;
-	}
+	if (!pte_val(old_pte))
+		return __cpa_process_fault(cpa, address, primary);
 
 	if (level == PG_LEVEL_4K) {
 		pte_t new_pte;
@@ -657,12 +681,7 @@ static int cpa_process_alias(struct cpa_data *cpa)
 		vaddr = *cpa->vaddr;
 
 	if (!(within(vaddr, PAGE_OFFSET,
-		    PAGE_OFFSET + (max_low_pfn_mapped << PAGE_SHIFT))
-#ifdef CONFIG_X86_64
-		|| within(vaddr, PAGE_OFFSET + (1UL<<32),
-		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))
-#endif
-	)) {
+		    PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))) {
 
 		alias_cpa = *cpa;
 		temp_cpa_vaddr = (unsigned long) __va(cpa->pfn << PAGE_SHIFT);
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 85cbd3c..ffc88cc 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -333,11 +333,23 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 					      req_type & _PAGE_CACHE_MASK);
 	}
 
-	is_range_ram = pagerange_is_ram(start, end);
-	if (is_range_ram == 1)
-		return reserve_ram_pages_type(start, end, req_type, new_type);
-	else if (is_range_ram < 0)
-		return -EINVAL;
+	if (new_type)
+		*new_type = actual_type;
+
+	/*
+	 * For legacy reasons, some parts of the physical address range in the
+	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
+	 * the e820 tables).  So we will track the memory attributes of this
+	 * legacy 1MB region using the linear memtype_list always.
+	 */
+	if (end >= ISA_END_ADDRESS) {
+		is_range_ram = pagerange_is_ram(start, end);
+		if (is_range_ram == 1)
+			return reserve_ram_pages_type(start, end, req_type,
+						      new_type);
+		else if (is_range_ram < 0)
+			return -EINVAL;
+	}
 
 	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
@@ -347,9 +359,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	new->end	= end;
 	new->type	= actual_type;
 
-	if (new_type)
-		*new_type = actual_type;
-
 	spin_lock(&memtype_lock);
 
 	if (cached_entry && start >= cached_start)
@@ -437,11 +446,19 @@ int free_memtype(u64 start, u64 end)
 	if (is_ISA_range(start, end - 1))
 		return 0;
 
-	is_range_ram = pagerange_is_ram(start, end);
-	if (is_range_ram == 1)
-		return free_ram_pages_type(start, end);
-	else if (is_range_ram < 0)
-		return -EINVAL;
+	/*
+	 * For legacy reasons, some parts of the physical address range in the
+	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
+	 * the e820 tables).  So we will track the memory attributes of this
+	 * legacy 1MB region using the linear memtype_list always.
+	 */
+	if (end >= ISA_END_ADDRESS) {
+		is_range_ram = pagerange_is_ram(start, end);
+		if (is_range_ram == 1)
+			return free_ram_pages_type(start, end);
+		else if (is_range_ram < 0)
+			return -EINVAL;
+	}
 
 	spin_lock(&memtype_lock);
 	list_for_each_entry(entry, &memtype_list, nd) {
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 8dc7109..2ba8f95 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -298,6 +298,14 @@ static int decrease_reservation(unsigned long nr_pages)
 		frame_list[i] = pfn_to_mfn(pfn);
 
 		scrub_page(page);
+
+		if (!PageHighMem(page)) {
+			ret = HYPERVISOR_update_va_mapping(
+				(unsigned long)__va(pfn << PAGE_SHIFT),
+				__pte_ma(0), 0);
+			BUG_ON(ret);
+                }
+
 	}
 
 	/* Ensure that ballooned highmem pages don't have kmaps. */
diff --git a/drivers/xen/xenfs/xenbus.c b/drivers/xen/xenfs/xenbus.c
index 875a4c5..a9592d9 100644
--- a/drivers/xen/xenfs/xenbus.c
+++ b/drivers/xen/xenfs/xenbus.c
@@ -291,7 +291,7 @@ static void watch_fired(struct xenbus_watch *watch,
 static int xenbus_write_transaction(unsigned msg_type,
 				    struct xenbus_file_priv *u)
 {
-	int rc, ret;
+	int rc;
 	void *reply;
 	struct xenbus_transaction_holder *trans = NULL;
 	LIST_HEAD(staging_q);
@@ -326,15 +326,14 @@ static int xenbus_write_transaction(unsigned msg_type,
 	}
 
 	mutex_lock(&u->reply_mutex);
-	ret = queue_reply(&staging_q, &u->u.msg, sizeof(u->u.msg));
-	if (!ret)
-		ret = queue_reply(&staging_q, reply, u->u.msg.len);
-	if (!ret) {
+	rc = queue_reply(&staging_q, &u->u.msg, sizeof(u->u.msg));
+	if (!rc)
+		rc = queue_reply(&staging_q, reply, u->u.msg.len);
+	if (!rc) {
 		list_splice_tail(&staging_q, &u->read_buffers);
 		wake_up(&u->read_waitq);
 	} else {
 		queue_cleanup(&staging_q);
-		rc = ret;
 	}
 	mutex_unlock(&u->reply_mutex);
 
diff --git a/include/asm-generic/bitops/__ffs.h b/include/asm-generic/bitops/__ffs.h
index 9a3274a..937d7c4 100644
--- a/include/asm-generic/bitops/__ffs.h
+++ b/include/asm-generic/bitops/__ffs.h
@@ -9,7 +9,7 @@
  *
  * Undefined if no bit exists, so code should check against 0 first.
  */
-static inline unsigned long __ffs(unsigned long word)
+static __always_inline unsigned long __ffs(unsigned long word)
 {
 	int num = 0;
 
diff --git a/include/asm-generic/bitops/__fls.h b/include/asm-generic/bitops/__fls.h
index be24465..a60a7cc 100644
--- a/include/asm-generic/bitops/__fls.h
+++ b/include/asm-generic/bitops/__fls.h
@@ -9,7 +9,7 @@
  *
  * Undefined if no set bit exists, so code should check against 0 first.
  */
-static inline unsigned long __fls(unsigned long word)
+static __always_inline unsigned long __fls(unsigned long word)
 {
 	int num = BITS_PER_LONG - 1;
 
diff --git a/include/asm-generic/bitops/fls.h b/include/asm-generic/bitops/fls.h
index 850859b..0576d1f 100644
--- a/include/asm-generic/bitops/fls.h
+++ b/include/asm-generic/bitops/fls.h
@@ -9,7 +9,7 @@
  * Note fls(0) = 0, fls(1) = 1, fls(0x80000000) = 32.
  */
 
-static inline int fls(int x)
+static __always_inline int fls(int x)
 {
 	int r = 32;
 
diff --git a/include/asm-generic/bitops/fls64.h b/include/asm-generic/bitops/fls64.h
index 86d403f..b097cf8 100644
--- a/include/asm-generic/bitops/fls64.h
+++ b/include/asm-generic/bitops/fls64.h
@@ -15,7 +15,7 @@
  * at position 64.
  */
 #if BITS_PER_LONG == 32
-static inline int fls64(__u64 x)
+static __always_inline int fls64(__u64 x)
 {
 	__u32 h = x >> 32;
 	if (h)
@@ -23,7 +23,7 @@ static inline int fls64(__u64 x)
 	return fls(x);
 }
 #elif BITS_PER_LONG == 64
-static inline int fls64(__u64 x)
+static __always_inline int fls64(__u64 x)
 {
 	if (x == 0)
 		return 0;
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2f44583..1f0c509 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -971,6 +971,8 @@ undo:
 }
 
 #ifdef CONFIG_SMP
+static struct workqueue_struct *work_on_cpu_wq __read_mostly;
+
 struct work_for_cpu {
 	struct work_struct work;
 	long (*fn)(void *);
@@ -991,8 +993,8 @@ static void do_work_for_cpu(struct work_struct *w)
  * @fn: the function to run
  * @arg: the function arg
  *
- * This will return -EINVAL in the cpu is not online, or the return value
- * of @fn otherwise.
+ * This will return the value @fn returns.
+ * It is up to the caller to ensure that the cpu doesn't go offline.
  */
 long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 {
@@ -1001,14 +1003,8 @@ long work_on_cpu(unsigned int cpu, long (*fn)(void *), void *arg)
 	INIT_WORK(&wfc.work, do_work_for_cpu);
 	wfc.fn = fn;
 	wfc.arg = arg;
-	get_online_cpus();
-	if (unlikely(!cpu_online(cpu)))
-		wfc.ret = -EINVAL;
-	else {
-		schedule_work_on(cpu, &wfc.work);
-		flush_work(&wfc.work);
-	}
-	put_online_cpus();
+	queue_work_on(cpu, work_on_cpu_wq, &wfc.work);
+	flush_work(&wfc.work);
 
 	return wfc.ret;
 }
@@ -1025,4 +1021,8 @@ void __init init_workqueues(void)
 	hotcpu_notifier(workqueue_cpu_callback, 0);
 	keventd_wq = create_workqueue("events");
 	BUG_ON(!keventd_wq);
+#ifdef CONFIG_SMP
+	work_on_cpu_wq = create_workqueue("work_on_cpu");
+	BUG_ON(!work_on_cpu_wq);
+#endif
 }
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 4c9ae60..d30561d 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -570,6 +570,15 @@ config DEBUG_NOTIFIERS
 	  This is a relatively cheap check but if you care about maximum
 	  performance, say N.
 
+#
+# Select this config option from the architecture Kconfig, if it
+# it is preferred to always offer frame pointers as a config
+# option on the architecture (regardless of KERNEL_DEBUG):
+#
+config ARCH_WANT_FRAME_POINTERS
+	bool
+	help
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && \
