Return-Path: <linux-kernel-owner+w=401wt.eu-S1760997AbZFJVNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760997AbZFJVNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 17:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZFJVM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 17:12:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33059 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756838AbZFJVMy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 17:12:54 -0400
Date: Wed, 10 Jun 2009 23:12:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/cleanups for v2.6.31
Message-ID: <20090610211240.GA1425@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
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

Please pull the latest x86-cleanups-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cleanups-for-linus

 Thanks,

	Ingo

------------------>
Cyrill Gorcunov (1):
      x86, nmi: Use predefined numbers instead of hardcoded one

Huang Weiyi (1):
      x86: mce: remove duplicated #include

Ingo Molnar (2):
      x86 early quirks: eliminate unused function
      x86: clean up arch/x86/kernel/tsc_sync.c a bit

Jaswinder Singh Rajput (12):
      x86: apic/x2apic_cluster.c x86_cpu_to_logical_apicid should be static
      x86: clean up declarations and variables
      x86: vdso/vma.c declare vdso_enabled and arch_setup_additional_pages before they get used
      x86: avoid multiple declaration of kstack_depth_to_print
      x86: msr-index.h remove duplicate MSR C001_0015 declaration
      x86, mtrr: replace MTRRcap_MSR with msr-index's MSR_MTRRcap
      x86, mtrr: replace MTRRfix64K_00000_MSR with msr-index's MSR_MTRRfix64K_00000
      x86, mtrr: replace MTRRfix16K_80000_MSR with msr-index's MSR_MTRRfix16K_80000
      x86, mtrr: remove mtrr MSRs double declaration
      x86, mtrr: replace MTRRfix4K_C0000_MSR with msr-index's MSR_MTRRfix4K_C0000
      x86, mtrr: replace MTRRdefType_MSR with msr-index's MSR_MTRRdefType
      x86: asm/processor.h: remove double declaration

Remis Lima Baima (1):
      x86: added 'ifndef _ASM_X86_IOMAP_H' to iomap.h

Samuel Bronson (1):
      x86: use symbolic name for VM86_SIGNAL when used as vm86 default return


 arch/x86/include/asm/apic.h               |    3 ++
 arch/x86/include/asm/hw_irq.h             |    4 ++
 arch/x86/include/asm/iomap.h              |    5 +++
 arch/x86/include/asm/msr-index.h          |    1 -
 arch/x86/include/asm/nmi.h                |    2 +-
 arch/x86/include/asm/pgtable.h            |    2 +
 arch/x86/include/asm/pgtable_64.h         |    6 ----
 arch/x86/include/asm/processor.h          |    3 --
 arch/x86/include/asm/syscalls.h           |   45 +++++++++++++++-------------
 arch/x86/include/asm/traps.h              |    1 -
 arch/x86/kernel/apic/io_apic.c            |    1 +
 arch/x86/kernel/apic/nmi.c                |    2 +-
 arch/x86/kernel/apic/probe_32.c           |    1 -
 arch/x86/kernel/apic/x2apic_cluster.c     |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |    1 -
 arch/x86/kernel/cpu/mtrr/cleanup.c        |    4 +-
 arch/x86/kernel/cpu/mtrr/generic.c        |   24 ++++++++--------
 arch/x86/kernel/cpu/mtrr/main.c           |    2 +-
 arch/x86/kernel/cpu/mtrr/mtrr.h           |   15 ---------
 arch/x86/kernel/cpu/mtrr/state.c          |    6 ++--
 arch/x86/kernel/dumpstack.h               |    1 -
 arch/x86/kernel/early-quirks.c            |    2 +
 arch/x86/kernel/irq.c                     |    1 +
 arch/x86/kernel/process.c                 |    1 +
 arch/x86/kernel/tsc.c                     |    8 ++--
 arch/x86/kernel/tsc_sync.c                |   14 ++++-----
 arch/x86/kernel/vm86_32.c                 |    4 +-
 arch/x86/mm/init.c                        |    1 +
 arch/x86/vdso/vma.c                       |    1 +
 29 files changed, 78 insertions(+), 85 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 42f2f83..5773660 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -478,6 +478,9 @@ static inline unsigned int read_apic_id(void)
 extern void default_setup_apic_routing(void);
 
 #ifdef CONFIG_X86_32
+
+extern struct apic apic_default;
+
 /*
  * Set up the logical destination ID.
  *
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index b762ea4..be9ae41 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -78,7 +78,11 @@ extern void eisa_set_level_irq(unsigned int irq);
 /* SMP */
 extern void smp_apic_timer_interrupt(struct pt_regs *);
 extern void smp_spurious_interrupt(struct pt_regs *);
+extern void smp_generic_interrupt(struct pt_regs *);
 extern void smp_error_interrupt(struct pt_regs *);
+#ifdef CONFIG_X86_IO_APIC
+extern asmlinkage void smp_irq_move_cleanup_interrupt(void);
+#endif
 #ifdef CONFIG_SMP
 extern void smp_reschedule_interrupt(struct pt_regs *);
 extern void smp_call_function_interrupt(struct pt_regs *);
diff --git a/arch/x86/include/asm/iomap.h b/arch/x86/include/asm/iomap.h
index 86af260..0e9fe1d 100644
--- a/arch/x86/include/asm/iomap.h
+++ b/arch/x86/include/asm/iomap.h
@@ -1,3 +1,6 @@
+#ifndef _ASM_X86_IOMAP_H
+#define _ASM_X86_IOMAP_H
+
 /*
  * Copyright © 2008 Ingo Molnar
  *
@@ -31,3 +34,5 @@ iomap_atomic_prot_pfn(unsigned long pfn, enum km_type type, pgprot_t prot);
 
 void
 iounmap_atomic(void *kvaddr, enum km_type type);
+
+#endif /* _ASM_X86_IOMAP_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index ec41fc1..4d58d04 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -121,7 +121,6 @@
 #define MSR_K8_TOP_MEM1			0xc001001a
 #define MSR_K8_TOP_MEM2			0xc001001d
 #define MSR_K8_SYSCFG			0xc0010010
-#define MSR_K8_HWCR			0xc0010015
 #define MSR_K8_INT_PENDING_MSG		0xc0010055
 /* C1E active bits in int pending message */
 #define K8_INTP_C1E_ACTIVE_MASK		0x18000000
diff --git a/arch/x86/include/asm/nmi.h b/arch/x86/include/asm/nmi.h
index c45a0a5..c972644 100644
--- a/arch/x86/include/asm/nmi.h
+++ b/arch/x86/include/asm/nmi.h
@@ -64,7 +64,7 @@ static inline int nmi_watchdog_active(void)
 	 * but since they are power of two we could use a
 	 * cheaper way --cvg
 	 */
-	return nmi_watchdog & 0x3;
+	return nmi_watchdog & (NMI_LOCAL_APIC | NMI_IO_APIC);
 }
 #endif
 
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 29d96d1..3f8d09d 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -503,6 +503,8 @@ static inline int pgd_none(pgd_t pgd)
 
 #ifndef __ASSEMBLY__
 
+extern int direct_gbpages;
+
 /* local pte updates need not use xchg for locking */
 static inline pte_t native_local_ptep_get_and_clear(pte_t *ptep)
 {
diff --git a/arch/x86/include/asm/pgtable_64.h b/arch/x86/include/asm/pgtable_64.h
index 6b87bc6..abde308 100644
--- a/arch/x86/include/asm/pgtable_64.h
+++ b/arch/x86/include/asm/pgtable_64.h
@@ -25,10 +25,6 @@ extern pgd_t init_level4_pgt[];
 
 extern void paging_init(void);
 
-#endif /* !__ASSEMBLY__ */
-
-#ifndef __ASSEMBLY__
-
 #define pte_ERROR(e)					\
 	printk("%s:%d: bad pte %p(%016lx).\n",		\
 	       __FILE__, __LINE__, &(e), pte_val(e))
@@ -135,8 +131,6 @@ static inline int pgd_large(pgd_t pgd) { return 0; }
 
 #define update_mmu_cache(vma, address, pte) do { } while (0)
 
-extern int direct_gbpages;
-
 /* Encode and de-code a swap entry */
 #if _PAGE_BIT_FILE < _PAGE_BIT_PROTNONE
 #define SWP_TYPE_BITS (_PAGE_BIT_FILE - _PAGE_BIT_PRESENT - 1)
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 34c5237..85628ea 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -403,9 +403,6 @@ DECLARE_PER_CPU(unsigned long, stack_canary);
 extern unsigned int xstate_size;
 extern void free_thread_xstate(struct task_struct *);
 extern struct kmem_cache *task_xstate_cachep;
-extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
-extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
-extern unsigned short num_cache_leaves;
 
 struct thread_struct {
 	/* Cached TLS descriptors: */
diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 7043408..372b76e 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -1,7 +1,7 @@
 /*
  * syscalls.h - Linux syscall interfaces (arch-specific)
  *
- * Copyright (c) 2008 Jaswinder Singh
+ * Copyright (c) 2008 Jaswinder Singh Rajput
  *
  * This file is released under the GPLv2.
  * See the file COPYING for more details.
@@ -12,50 +12,55 @@
 
 #include <linux/compiler.h>
 #include <linux/linkage.h>
-#include <linux/types.h>
 #include <linux/signal.h>
+#include <linux/types.h>
 
 /* Common in X86_32 and X86_64 */
 /* kernel/ioport.c */
 asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
 
+/* kernel/process.c */
+int sys_fork(struct pt_regs *);
+int sys_vfork(struct pt_regs *);
+
 /* kernel/ldt.c */
 asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
 
+/* kernel/signal.c */
+long sys_rt_sigreturn(struct pt_regs *);
+
 /* kernel/tls.c */
 asmlinkage int sys_set_thread_area(struct user_desc __user *);
 asmlinkage int sys_get_thread_area(struct user_desc __user *);
 
 /* X86_32 only */
 #ifdef CONFIG_X86_32
+/* kernel/ioport.c */
+long sys_iopl(struct pt_regs *);
+
 /* kernel/process_32.c */
-int sys_fork(struct pt_regs *);
 int sys_clone(struct pt_regs *);
-int sys_vfork(struct pt_regs *);
 int sys_execve(struct pt_regs *);
 
-/* kernel/signal_32.c */
+/* kernel/signal.c */
 asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
 asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
 int sys_sigaltstack(struct pt_regs *);
 unsigned long sys_sigreturn(struct pt_regs *);
-long sys_rt_sigreturn(struct pt_regs *);
-
-/* kernel/ioport.c */
-long sys_iopl(struct pt_regs *);
 
 /* kernel/sys_i386_32.c */
+struct mmap_arg_struct;
+struct sel_arg_struct;
+struct oldold_utsname;
+struct old_utsname;
+
 asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
 			  unsigned long, unsigned long, unsigned long);
-struct mmap_arg_struct;
 asmlinkage int old_mmap(struct mmap_arg_struct __user *);
-struct sel_arg_struct;
 asmlinkage int old_select(struct sel_arg_struct __user *);
 asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
-struct old_utsname;
 asmlinkage int sys_uname(struct old_utsname __user *);
-struct oldold_utsname;
 asmlinkage int sys_olduname(struct oldold_utsname __user *);
 
 /* kernel/vm86_32.c */
@@ -65,29 +70,27 @@ int sys_vm86(struct pt_regs *);
 #else /* CONFIG_X86_32 */
 
 /* X86_64 only */
+/* kernel/ioport.c */
+asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
+
 /* kernel/process_64.c */
-asmlinkage long sys_fork(struct pt_regs *);
 asmlinkage long sys_clone(unsigned long, unsigned long,
 			  void __user *, void __user *,
 			  struct pt_regs *);
-asmlinkage long sys_vfork(struct pt_regs *);
 asmlinkage long sys_execve(char __user *, char __user * __user *,
 			   char __user * __user *,
 			   struct pt_regs *);
 long sys_arch_prctl(int, unsigned long);
 
-/* kernel/ioport.c */
-asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
-
-/* kernel/signal_64.c */
+/* kernel/signal.c */
 asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
 				struct pt_regs *);
-long sys_rt_sigreturn(struct pt_regs *);
 
 /* kernel/sys_x86_64.c */
+struct new_utsname;
+
 asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
 			 unsigned long, unsigned long, unsigned long);
-struct new_utsname;
 asmlinkage long sys_uname(struct new_utsname __user *);
 
 #endif /* CONFIG_X86_32 */
diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 0d53425..9aa3ab2 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -74,7 +74,6 @@ static inline int get_si_code(unsigned long condition)
 }
 
 extern int panic_on_unrecovered_nmi;
-extern int kstack_depth_to_print;
 
 void math_error(void __user *);
 void math_emulate(struct math_emu_info *);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 767fe7e..870c92d 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -59,6 +59,7 @@
 #include <asm/setup.h>
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
+#include <asm/hw_irq.h>
 #include <asm/uv/uv_hub.h>
 #include <asm/uv/uv_irq.h>
 
diff --git a/arch/x86/kernel/apic/nmi.c b/arch/x86/kernel/apic/nmi.c
index d6bd624..0205631 100644
--- a/arch/x86/kernel/apic/nmi.c
+++ b/arch/x86/kernel/apic/nmi.c
@@ -104,7 +104,7 @@ static __init void nmi_cpu_busy(void *data)
 }
 #endif
 
-static void report_broken_nmi(int cpu, int *prev_nmi_count)
+static void report_broken_nmi(int cpu, unsigned int *prev_nmi_count)
 {
 	printk(KERN_CONT "\n");
 
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 01eda2a..440a8bc 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -160,7 +160,6 @@ extern struct apic apic_summit;
 extern struct apic apic_bigsmp;
 extern struct apic apic_es7000;
 extern struct apic apic_es7000_cluster;
-extern struct apic apic_default;
 
 struct apic *apic = &apic_default;
 EXPORT_SYMBOL_GPL(apic);
diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 4a903e2..8e4cbb2 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -10,7 +10,7 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 
-DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
+static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
index d6b72df..aedf976 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
@@ -15,7 +15,6 @@
 #include <asm/hw_irq.h>
 #include <asm/idle.h>
 #include <asm/therm_throt.h>
-#include <asm/apic.h>
 
 asmlinkage void smp_thermal_interrupt(void)
 {
diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index ce0fe4b..1d584a1 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -808,7 +808,7 @@ int __init mtrr_cleanup(unsigned address_bits)
 
 	if (!is_cpu(INTEL) || enable_mtrr_cleanup < 1)
 		return 0;
-	rdmsr(MTRRdefType_MSR, def, dummy);
+	rdmsr(MSR_MTRRdefType, def, dummy);
 	def &= 0xff;
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
@@ -1003,7 +1003,7 @@ int __init mtrr_trim_uncached_memory(unsigned long end_pfn)
 	 */
 	if (!is_cpu(INTEL) || disable_mtrr_trim)
 		return 0;
-	rdmsr(MTRRdefType_MSR, def, dummy);
+	rdmsr(MSR_MTRRdefType, def, dummy);
 	def &= 0xff;
 	if (def != MTRR_TYPE_UNCACHABLE)
 		return 0;
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 0b776c0..e930a31 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -20,9 +20,9 @@ struct fixed_range_block {
 };
 
 static struct fixed_range_block fixed_range_blocks[] = {
-	{ MTRRfix64K_00000_MSR, 1 }, /* one  64k MTRR  */
-	{ MTRRfix16K_80000_MSR, 2 }, /* two  16k MTRRs */
-	{ MTRRfix4K_C0000_MSR,  8 }, /* eight 4k MTRRs */
+	{ MSR_MTRRfix64K_00000, 1 }, /* one  64k MTRR  */
+	{ MSR_MTRRfix16K_80000, 2 }, /* two  16k MTRRs */
+	{ MSR_MTRRfix4K_C0000,  8 }, /* eight 4k MTRRs */
 	{}
 };
 
@@ -194,12 +194,12 @@ get_fixed_ranges(mtrr_type * frs)
 
 	k8_check_syscfg_dram_mod_en();
 
-	rdmsr(MTRRfix64K_00000_MSR, p[0], p[1]);
+	rdmsr(MSR_MTRRfix64K_00000, p[0], p[1]);
 
 	for (i = 0; i < 2; i++)
-		rdmsr(MTRRfix16K_80000_MSR + i, p[2 + i * 2], p[3 + i * 2]);
+		rdmsr(MSR_MTRRfix16K_80000 + i, p[2 + i * 2], p[3 + i * 2]);
 	for (i = 0; i < 8; i++)
-		rdmsr(MTRRfix4K_C0000_MSR + i, p[6 + i * 2], p[7 + i * 2]);
+		rdmsr(MSR_MTRRfix4K_C0000 + i, p[6 + i * 2], p[7 + i * 2]);
 }
 
 void mtrr_save_fixed_ranges(void *info)
@@ -306,7 +306,7 @@ void __init get_mtrr_state(void)
 
 	vrs = mtrr_state.var_ranges;
 
-	rdmsr(MTRRcap_MSR, lo, dummy);
+	rdmsr(MSR_MTRRcap, lo, dummy);
 	mtrr_state.have_fixed = (lo >> 8) & 1;
 
 	for (i = 0; i < num_var_ranges; i++)
@@ -314,7 +314,7 @@ void __init get_mtrr_state(void)
 	if (mtrr_state.have_fixed)
 		get_fixed_ranges(mtrr_state.fixed_ranges);
 
-	rdmsr(MTRRdefType_MSR, lo, dummy);
+	rdmsr(MSR_MTRRdefType, lo, dummy);
 	mtrr_state.def_type = (lo & 0xff);
 	mtrr_state.enabled = (lo & 0xc00) >> 10;
 
@@ -579,10 +579,10 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 	__flush_tlb();
 
 	/*  Save MTRR state */
-	rdmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
+	rdmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
 
 	/*  Disable MTRRs, and set the default type to uncached  */
-	mtrr_wrmsr(MTRRdefType_MSR, deftype_lo & ~0xcff, deftype_hi);
+	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo & ~0xcff, deftype_hi);
 }
 
 static void post_set(void) __releases(set_atomicity_lock)
@@ -591,7 +591,7 @@ static void post_set(void) __releases(set_atomicity_lock)
 	__flush_tlb();
 
 	/* Intel (P6) standard MTRRs */
-	mtrr_wrmsr(MTRRdefType_MSR, deftype_lo, deftype_hi);
+	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo, deftype_hi);
 		
 	/*  Enable caches  */
 	write_cr0(read_cr0() & 0xbfffffff);
@@ -703,7 +703,7 @@ int generic_validate_add_page(unsigned long base, unsigned long size, unsigned i
 static int generic_have_wrcomb(void)
 {
 	unsigned long config, dummy;
-	rdmsr(MTRRcap_MSR, config, dummy);
+	rdmsr(MSR_MTRRcap, config, dummy);
 	return (config & (1 << 10));
 }
 
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 03cda01..8fc248b 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -104,7 +104,7 @@ static void __init set_num_var_ranges(void)
 	unsigned long config = 0, dummy;
 
 	if (use_intel()) {
-		rdmsr(MTRRcap_MSR, config, dummy);
+		rdmsr(MSR_MTRRcap, config, dummy);
 	} else if (is_cpu(AMD))
 		config = 2;
 	else if (is_cpu(CYRIX) || is_cpu(CENTAUR))
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 77f67f7..7538b76 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -5,21 +5,6 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 
-#define MTRRcap_MSR     0x0fe
-#define MTRRdefType_MSR 0x2ff
-
-#define MTRRfix64K_00000_MSR 0x250
-#define MTRRfix16K_80000_MSR 0x258
-#define MTRRfix16K_A0000_MSR 0x259
-#define MTRRfix4K_C0000_MSR 0x268
-#define MTRRfix4K_C8000_MSR 0x269
-#define MTRRfix4K_D0000_MSR 0x26a
-#define MTRRfix4K_D8000_MSR 0x26b
-#define MTRRfix4K_E0000_MSR 0x26c
-#define MTRRfix4K_E8000_MSR 0x26d
-#define MTRRfix4K_F0000_MSR 0x26e
-#define MTRRfix4K_F8000_MSR 0x26f
-
 #define MTRR_CHANGE_MASK_FIXED     0x01
 #define MTRR_CHANGE_MASK_VARIABLE  0x02
 #define MTRR_CHANGE_MASK_DEFTYPE   0x04
diff --git a/arch/x86/kernel/cpu/mtrr/state.c b/arch/x86/kernel/cpu/mtrr/state.c
index 7f7e275..1f5fb15 100644
--- a/arch/x86/kernel/cpu/mtrr/state.c
+++ b/arch/x86/kernel/cpu/mtrr/state.c
@@ -35,7 +35,7 @@ void set_mtrr_prepare_save(struct set_mtrr_context *ctxt)
 
 		if (use_intel())
 			/*  Save MTRR state */
-			rdmsr(MTRRdefType_MSR, ctxt->deftype_lo, ctxt->deftype_hi);
+			rdmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
 		else
 			/* Cyrix ARRs - everything else were excluded at the top */
 			ctxt->ccr3 = getCx86(CX86_CCR3);
@@ -46,7 +46,7 @@ void set_mtrr_cache_disable(struct set_mtrr_context *ctxt)
 {
 	if (use_intel())
 		/*  Disable MTRRs, and set the default type to uncached  */
-		mtrr_wrmsr(MTRRdefType_MSR, ctxt->deftype_lo & 0xf300UL,
+		mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo & 0xf300UL,
 		      ctxt->deftype_hi);
 	else if (is_cpu(CYRIX))
 		/* Cyrix ARRs - everything else were excluded at the top */
@@ -64,7 +64,7 @@ void set_mtrr_done(struct set_mtrr_context *ctxt)
 		/*  Restore MTRRdefType  */
 		if (use_intel())
 			/* Intel (P6) standard MTRRs */
-			mtrr_wrmsr(MTRRdefType_MSR, ctxt->deftype_lo, ctxt->deftype_hi);
+			mtrr_wrmsr(MSR_MTRRdefType, ctxt->deftype_lo, ctxt->deftype_hi);
 		else
 			/* Cyrix ARRs - everything else was excluded at the top */
 			setCx86(CX86_CCR3, ctxt->ccr3);
diff --git a/arch/x86/kernel/dumpstack.h b/arch/x86/kernel/dumpstack.h
index da87590..81086c2 100644
--- a/arch/x86/kernel/dumpstack.h
+++ b/arch/x86/kernel/dumpstack.h
@@ -29,7 +29,6 @@ show_stack_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *sp, unsigned long bp, char *log_lvl);
 
 extern unsigned int code_bytes;
-extern int kstack_depth_to_print;
 
 /* The form of the top of the frame on the stack */
 struct stack_frame {
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 76b8cd9..ebdb85c 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -97,6 +97,7 @@ static void __init nvidia_bugs(int num, int slot, int func)
 }
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
+#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
 static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
@@ -114,6 +115,7 @@ static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 	d &= 0xff;
 	return d;
 }
+#endif
 
 static void __init ati_bugs(int num, int slot, int func)
 {
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 3aaf7b9..2188267 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -12,6 +12,7 @@
 #include <asm/io_apic.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
+#include <asm/hw_irq.h>
 
 atomic_t irq_err_count;
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index ca98915..3e21e38 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -11,6 +11,7 @@
 #include <trace/power.h>
 #include <asm/system.h>
 #include <asm/apic.h>
+#include <asm/syscalls.h>
 #include <asm/idle.h>
 #include <asm/uaccess.h>
 #include <asm/i387.h>
diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 7a567eb..a8dc0d0 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -384,13 +384,13 @@ unsigned long native_calibrate_tsc(void)
 {
 	u64 tsc1, tsc2, delta, ref1, ref2;
 	unsigned long tsc_pit_min = ULONG_MAX, tsc_ref_min = ULONG_MAX;
-	unsigned long flags, latch, ms, fast_calibrate, tsc_khz;
+	unsigned long flags, latch, ms, fast_calibrate, hv_tsc_khz;
 	int hpet = is_hpet_enabled(), i, loopmin;
 
-	tsc_khz = get_hypervisor_tsc_freq();
-	if (tsc_khz) {
+	hv_tsc_khz = get_hypervisor_tsc_freq();
+	if (hv_tsc_khz) {
 		printk(KERN_INFO "TSC: Frequency read from the hypervisor\n");
-		return tsc_khz;
+		return hv_tsc_khz;
 	}
 
 	local_irq_save(flags);
diff --git a/arch/x86/kernel/tsc_sync.c b/arch/x86/kernel/tsc_sync.c
index bf36328..027b5b4 100644
--- a/arch/x86/kernel/tsc_sync.c
+++ b/arch/x86/kernel/tsc_sync.c
@@ -34,6 +34,7 @@ static __cpuinitdata atomic_t stop_count;
  * of a critical section, to be able to prove TSC time-warps:
  */
 static __cpuinitdata raw_spinlock_t sync_lock = __RAW_SPIN_LOCK_UNLOCKED;
+
 static __cpuinitdata cycles_t last_tsc;
 static __cpuinitdata cycles_t max_warp;
 static __cpuinitdata int nr_warps;
@@ -113,13 +114,12 @@ void __cpuinit check_tsc_sync_source(int cpu)
 		return;
 
 	if (boot_cpu_has(X86_FEATURE_TSC_RELIABLE)) {
-		printk(KERN_INFO
-		       "Skipping synchronization checks as TSC is reliable.\n");
+		pr_info("Skipping synchronization checks as TSC is reliable.\n");
 		return;
 	}
 
-	printk(KERN_INFO "checking TSC synchronization [CPU#%d -> CPU#%d]:",
-			  smp_processor_id(), cpu);
+	pr_info("checking TSC synchronization [CPU#%d -> CPU#%d]:",
+		smp_processor_id(), cpu);
 
 	/*
 	 * Reset it - in case this is a second bootup:
@@ -143,8 +143,8 @@ void __cpuinit check_tsc_sync_source(int cpu)
 
 	if (nr_warps) {
 		printk("\n");
-		printk(KERN_WARNING "Measured %Ld cycles TSC warp between CPUs,"
-				    " turning off TSC clock.\n", max_warp);
+		pr_warning("Measured %Ld cycles TSC warp between CPUs, "
+			   "turning off TSC clock.\n", max_warp);
 		mark_tsc_unstable("check_tsc_sync_source failed");
 	} else {
 		printk(" passed.\n");
@@ -195,5 +195,3 @@ void __cpuinit check_tsc_sync_target(void)
 	while (atomic_read(&stop_count) != cpus)
 		cpu_relax();
 }
-#undef NR_LOOPS
-
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index d7ac84e..b8035a0 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -318,9 +318,9 @@ static void do_sys_vm86(struct kernel_vm86_struct *info, struct task_struct *tsk
 	}
 
 /*
- * Save old state, set default return value (%ax) to 0
+ * Save old state, set default return value (%ax) to 0 (VM86_SIGNAL)
  */
-	info->regs32->ax = 0;
+	info->regs32->ax = VM86_SIGNAL;
 	tsk->thread.saved_sp0 = tsk->thread.sp0;
 	tsk->thread.saved_fs = info->regs32->fs;
 	tsk->thread.saved_gs = get_user_gs(info->regs32);
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fd3da1d..40924e4 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -1,3 +1,4 @@
+#include <linux/initrd.h>
 #include <linux/ioport.h>
 #include <linux/swap.h>
 
diff --git a/arch/x86/vdso/vma.c b/arch/x86/vdso/vma.c
index 7133cdf..cac0833 100644
--- a/arch/x86/vdso/vma.c
+++ b/arch/x86/vdso/vma.c
@@ -8,6 +8,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/random.h>
+#include <linux/elf.h>
 #include <asm/vsyscall.h>
 #include <asm/vgtod.h>
 #include <asm/proto.h>
