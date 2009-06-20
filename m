Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZFTQty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZFTQty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 12:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZFTQtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 12:49:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50631 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZFTQtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 12:49:42 -0400
Date: Sat, 20 Jun 2009 18:49:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 updates
Message-ID: <20090620164925.GA18251@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

Please pull the latest x86 fixes+updates git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

Various fixes, plus a late batch of MCE cleanups from Hidetoshi 
Seto.

 Thanks,

	Ingo

------------------>
Alexander van Heukelum (3):
      i386: fix return to 16-bit stack from NMI handler
      i386: fix/simplify espfix stack switching, move it into assembly
      x86: de-assembler-ize asm/desc.h

Andi Kleen (1):
      x86: mce: Handle banks == 0 case in K7 quirk

Chris Wright (3):
      amd-iommu: flush domain tlb when attaching a new device
      amd-iommu: disable cmd buffer and evt logging before reprogramming iommu
      amd-iommu: resume cleanup

Cliff Wickman (1):
      x86: correct the conversion of EFI memory types

Cyrill Gorcunov (2):
      x86: mce: Don't touch THERMAL_APIC_VECTOR if no active APIC present
      x86, ioapic: Don't call disconnect_bsp_APIC if no APIC present

Figo.zhang (1):
      x86, io_apic.c: Work around compiler warning

H. Peter Anvin (3):
      x86: cap iomem_resource to addressable physical memory
      x86, boot: use .code16gcc instead of .code16
      x86, mce: mce_intel.c needs <asm/apic.h>

Hidetoshi Seto (17):
      x86, mce: don't init timer if !mce_available
      x86, mce: cleanup mce_start()
      x86, mce: add __read_mostly
      x86, mce: rename static variables around trigger
      x86, mce: sysfs entries for new mce options
      x86, mce: unify mce.h
      x86, mce: make mce_disabled boolean
      x86, mce: unify smp_thermal_interrupt, prepare p4
      x86, mce: unify smp_thermal_interrupt, prepare mce_intel_64
      x86, mce: unify smp_thermal_interrupt, prepare
      x86, mce: unify smp_thermal_interrupt
      x86, mce: squash mce_intel.c into therm_throt.c
      x86, mce: remove intel_set_thermal_handler()
      x86, mce: remove therm_throt.h
      x86, mce: mce.h cleanup
      x86, mce: rename _64.c files which are no longer 64-bit-specific
      x86, mce: fix error path in mce_create_device()

Huang Weiyi (1):
      x86: Remove duplicated #include's

Huang Ying (1):
      x86, mce: fix a race condition about mce_callin and no_way_out

Ingo Molnar (1):
      x86: mm: Read cr2 before prefetching the mmap_lock

Jaswinder Singh Rajput (2):
      x86: apic/io_apic.c: dmar_msi_type should be static
      x86: msr.h linux/types.h is only required for __KERNEL__

Joerg Roedel (3):
      amd-iommu: disable IOMMU hardware on shutdown
      x86: disable IOMMUs on kernel crash
      amd-iommu: set event buffer head and tail to 0 manually

Prarit Bhargava (1):
      x86: nmi: Add Intel processor 0x6f4 to NMI perfctr1 workaround

Randy Dunlap (1):
      x86: atomic_32.h: Fix kernel-doc warnings

Shaohua Li (1):
      x86: change kernel_physical_mapping_init() __init to __meminit

Thomas Gleixner (1):
      x86: hpet: Mark per cpu interrupts IRQF_TIMER to prevent resume failure

Yinghai Lu (2):
      x86: fix duplicated sysfs attribute
      x86: use zalloc_cpumask_var for mce_dev_initialized


 arch/x86/boot/bioscall.S                           |    2 +-
 arch/x86/include/asm/amd_iommu.h                   |    2 +
 arch/x86/include/asm/atomic_32.h                   |    3 +-
 arch/x86/include/asm/desc.h                        |   26 --
 arch/x86/include/asm/mce.h                         |   63 ++++-
 arch/x86/include/asm/msr.h                         |    7 +-
 arch/x86/include/asm/therm_throt.h                 |    9 -
 arch/x86/kernel/amd_iommu.c                        |   16 ++
 arch/x86/kernel/amd_iommu_init.c                   |   26 ++-
 arch/x86/kernel/apic/io_apic.c                     |    9 +-
 arch/x86/kernel/apic/probe_32.c                    |   11 -
 arch/x86/kernel/apic/summit_32.c                   |    1 -
 arch/x86/kernel/cpu/common.c                       |    5 +-
 arch/x86/kernel/cpu/mcheck/Makefile                |    9 +-
 arch/x86/kernel/cpu/mcheck/k7.c                    |    3 +-
 arch/x86/kernel/cpu/mcheck/mce.c                   |  233 +++++++++++++------
 arch/x86/kernel/cpu/mcheck/mce.h                   |   38 ---
 .../kernel/cpu/mcheck/{mce_amd_64.c => mce_amd.c}  |    0
 arch/x86/kernel/cpu/mcheck/mce_intel.c             |  250 ++++++++++++++++----
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c          |  248 -------------------
 arch/x86/kernel/cpu/mcheck/non-fatal.c             |    3 +-
 arch/x86/kernel/cpu/mcheck/p4.c                    |   48 +----
 arch/x86/kernel/cpu/mcheck/p5.c                    |   15 +-
 arch/x86/kernel/cpu/mcheck/p6.c                    |    3 +-
 arch/x86/kernel/cpu/mcheck/therm_throt.c           |  106 ++++++++-
 arch/x86/kernel/cpu/mcheck/winchip.c               |    3 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c             |   12 +-
 arch/x86/kernel/crash.c                            |    6 +
 arch/x86/kernel/efi.c                              |   31 +++-
 arch/x86/kernel/entry_32.S                         |   64 ++++--
 arch/x86/kernel/head_32.S                          |    1 -
 arch/x86/kernel/head_64.S                          |    1 -
 arch/x86/kernel/hpet.c                             |    3 +-
 arch/x86/kernel/pci-dma.c                          |    2 +
 arch/x86/kernel/traps.c                            |    3 +-
 arch/x86/mm/fault.c                                |    4 +-
 arch/x86/mm/init_64.c                              |    2 +-
 37 files changed, 671 insertions(+), 597 deletions(-)
 delete mode 100644 arch/x86/include/asm/therm_throt.h
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce.h
 rename arch/x86/kernel/cpu/mcheck/{mce_amd_64.c => mce_amd.c} (100%)
 delete mode 100644 arch/x86/kernel/cpu/mcheck/mce_intel_64.c

diff --git a/arch/x86/boot/bioscall.S b/arch/x86/boot/bioscall.S
index 5077937..1dfbf64 100644
--- a/arch/x86/boot/bioscall.S
+++ b/arch/x86/boot/bioscall.S
@@ -13,7 +13,7 @@
  * touching registers they shouldn't be.
  */
 
-	.code16
+	.code16gcc
 	.text
 	.globl	intcall
 	.type	intcall, @function
diff --git a/arch/x86/include/asm/amd_iommu.h b/arch/x86/include/asm/amd_iommu.h
index 262e028..bdf96f1 100644
--- a/arch/x86/include/asm/amd_iommu.h
+++ b/arch/x86/include/asm/amd_iommu.h
@@ -29,9 +29,11 @@ extern void amd_iommu_detect(void);
 extern irqreturn_t amd_iommu_int_handler(int irq, void *data);
 extern void amd_iommu_flush_all_domains(void);
 extern void amd_iommu_flush_all_devices(void);
+extern void amd_iommu_shutdown(void);
 #else
 static inline int amd_iommu_init(void) { return -ENODEV; }
 static inline void amd_iommu_detect(void) { }
+static inline void amd_iommu_shutdown(void) { }
 #endif
 
 #endif /* _ASM_X86_AMD_IOMMU_H */
diff --git a/arch/x86/include/asm/atomic_32.h b/arch/x86/include/asm/atomic_32.h
index 8cb9c81..2503d4e 100644
--- a/arch/x86/include/asm/atomic_32.h
+++ b/arch/x86/include/asm/atomic_32.h
@@ -257,7 +257,7 @@ typedef struct {
 
 /**
  * atomic64_read - read atomic64 variable
- * @v: pointer of type atomic64_t
+ * @ptr: pointer of type atomic64_t
  *
  * Atomically reads the value of @v.
  * Doesn't imply a read memory barrier.
@@ -294,7 +294,6 @@ atomic64_cmpxchg(atomic64_t *ptr, unsigned long long old_val,
  * atomic64_xchg - xchg atomic64 variable
  * @ptr:      pointer to type atomic64_t
  * @new_val:  value to assign
- * @old_val:  old value that was there
  *
  * Atomically xchgs the value of @ptr to @new_val and returns
  * the old value.
diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index c45f415..c993e9e 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -1,7 +1,6 @@
 #ifndef _ASM_X86_DESC_H
 #define _ASM_X86_DESC_H
 
-#ifndef __ASSEMBLY__
 #include <asm/desc_defs.h>
 #include <asm/ldt.h>
 #include <asm/mmu.h>
@@ -380,29 +379,4 @@ static inline void set_system_intr_gate_ist(int n, void *addr, unsigned ist)
 	_set_gate(n, GATE_INTERRUPT, addr, 0x3, ist, __KERNEL_CS);
 }
 
-#else
-/*
- * GET_DESC_BASE reads the descriptor base of the specified segment.
- *
- * Args:
- *    idx - descriptor index
- *    gdt - GDT pointer
- *    base - 32bit register to which the base will be written
- *    lo_w - lo word of the "base" register
- *    lo_b - lo byte of the "base" register
- *    hi_b - hi byte of the low word of the "base" register
- *
- * Example:
- *    GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah)
- *    Will read the base address of GDT_ENTRY_ESPFIX_SS and put it into %eax.
- */
-#define GET_DESC_BASE(idx, gdt, base, lo_w, lo_b, hi_b) \
-	movb idx * 8 + 4(gdt), lo_b;			\
-	movb idx * 8 + 7(gdt), hi_b;			\
-	shll $16, base;					\
-	movw idx * 8 + 2(gdt), lo_w;
-
-
-#endif /* __ASSEMBLY__ */
-
 #endif /* _ASM_X86_DESC_H */
diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 540a466..5cdd8d1 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -102,15 +102,39 @@ struct mce_log {
 
 #ifdef __KERNEL__
 
+#include <linux/percpu.h>
+#include <linux/init.h>
+#include <asm/atomic.h>
+
 extern int mce_disabled;
+extern int mce_p5_enabled;
 
-#include <asm/atomic.h>
-#include <linux/percpu.h>
+#ifdef CONFIG_X86_MCE
+void mcheck_init(struct cpuinfo_x86 *c);
+#else
+static inline void mcheck_init(struct cpuinfo_x86 *c) {}
+#endif
+
+#ifdef CONFIG_X86_OLD_MCE
+extern int nr_mce_banks;
+void amd_mcheck_init(struct cpuinfo_x86 *c);
+void intel_p4_mcheck_init(struct cpuinfo_x86 *c);
+void intel_p6_mcheck_init(struct cpuinfo_x86 *c);
+#endif
+
+#ifdef CONFIG_X86_ANCIENT_MCE
+void intel_p5_mcheck_init(struct cpuinfo_x86 *c);
+void winchip_mcheck_init(struct cpuinfo_x86 *c);
+static inline void enable_p5_mce(void) { mce_p5_enabled = 1; }
+#else
+static inline void intel_p5_mcheck_init(struct cpuinfo_x86 *c) {}
+static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
+static inline void enable_p5_mce(void) {}
+#endif
 
 void mce_setup(struct mce *m);
 void mce_log(struct mce *m);
 DECLARE_PER_CPU(struct sys_device, mce_dev);
-extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
 
 /*
  * To support more than 128 would need to escape the predefined
@@ -145,12 +169,8 @@ int mce_available(struct cpuinfo_x86 *c);
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
 
-void mce_log_therm_throt_event(__u64 status);
-
 extern atomic_t mce_entry;
 
-void do_machine_check(struct pt_regs *, long);
-
 typedef DECLARE_BITMAP(mce_banks_t, MAX_NR_BANKS);
 DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
 
@@ -167,13 +187,32 @@ void mce_notify_process(void);
 DECLARE_PER_CPU(struct mce, injectm);
 extern struct file_operations mce_chrdev_ops;
 
-#ifdef CONFIG_X86_MCE
-void mcheck_init(struct cpuinfo_x86 *c);
-#else
-#define mcheck_init(c) do { } while (0)
-#endif
+/*
+ * Exception handler
+ */
+
+/* Call the installed machine check handler for this CPU setup. */
+extern void (*machine_check_vector)(struct pt_regs *, long error_code);
+void do_machine_check(struct pt_regs *, long);
+
+/*
+ * Threshold handler
+ */
 
 extern void (*mce_threshold_vector)(void);
+extern void (*threshold_cpu_callback)(unsigned long action, unsigned int cpu);
+
+/*
+ * Thermal handler
+ */
+
+void intel_init_thermal(struct cpuinfo_x86 *c);
+
+#ifdef CONFIG_X86_NEW_MCE
+void mce_log_therm_throt_event(__u64 status);
+#else
+static inline void mce_log_therm_throt_event(__u64 status) {}
+#endif
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index 2260376..48ad9d2 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -3,13 +3,10 @@
 
 #include <asm/msr-index.h>
 
-#ifndef __ASSEMBLY__
-# include <linux/types.h>
-#endif
-
 #ifdef __KERNEL__
 #ifndef __ASSEMBLY__
 
+#include <linux/types.h>
 #include <asm/asm.h>
 #include <asm/errno.h>
 #include <asm/cpumask.h>
@@ -264,6 +261,4 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
 #endif  /* CONFIG_SMP */
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
-
-
 #endif /* _ASM_X86_MSR_H */
diff --git a/arch/x86/include/asm/therm_throt.h b/arch/x86/include/asm/therm_throt.h
deleted file mode 100644
index c62349e..0000000
--- a/arch/x86/include/asm/therm_throt.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef _ASM_X86_THERM_THROT_H
-#define _ASM_X86_THERM_THROT_H
-
-#include <asm/atomic.h>
-
-extern atomic_t therm_throt_en;
-int therm_throt_process(int curr);
-
-#endif /* _ASM_X86_THERM_THROT_H */
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 1c60554..9372f04 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -434,6 +434,16 @@ static void iommu_flush_tlb(struct amd_iommu *iommu, u16 domid)
 	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, 1);
 }
 
+/* Flush the whole IO/TLB for a given protection domain - including PDE */
+static void iommu_flush_tlb_pde(struct amd_iommu *iommu, u16 domid)
+{
+       u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
+
+       INC_STATS_COUNTER(domain_flush_single);
+
+       iommu_queue_inv_iommu_pages(iommu, address, domid, 1, 1);
+}
+
 /*
  * This function is used to flush the IO/TLB for a given protection domain
  * on every IOMMU in the system
@@ -1078,7 +1088,13 @@ static void attach_device(struct amd_iommu *iommu,
 	amd_iommu_pd_table[devid] = domain;
 	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
 
+       /*
+        * We might boot into a crash-kernel here. The crashed kernel
+        * left the caches in the IOMMU dirty. So we have to flush
+        * here to evict all dirty stuff.
+        */
 	iommu_queue_inv_dev_entry(iommu, devid);
+	iommu_flush_tlb_pde(iommu, domain->id);
 }
 
 /*
diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 238989e..10b2acc 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -260,6 +260,14 @@ static void iommu_enable(struct amd_iommu *iommu)
 
 static void iommu_disable(struct amd_iommu *iommu)
 {
+	/* Disable command buffer */
+	iommu_feature_disable(iommu, CONTROL_CMDBUF_EN);
+
+	/* Disable event logging and event interrupts */
+	iommu_feature_disable(iommu, CONTROL_EVT_INT_EN);
+	iommu_feature_disable(iommu, CONTROL_EVT_LOG_EN);
+
+	/* Disable IOMMU hardware itself */
 	iommu_feature_disable(iommu, CONTROL_IOMMU_EN);
 }
 
@@ -478,6 +486,10 @@ static void iommu_enable_event_buffer(struct amd_iommu *iommu)
 	memcpy_toio(iommu->mmio_base + MMIO_EVT_BUF_OFFSET,
 		    &entry, sizeof(entry));
 
+	/* set head and tail to zero manually */
+	writel(0x00, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
+	writel(0x00, iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
+
 	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
 }
 
@@ -1042,6 +1054,7 @@ static void enable_iommus(void)
 	struct amd_iommu *iommu;
 
 	for_each_iommu(iommu) {
+		iommu_disable(iommu);
 		iommu_set_device_table(iommu);
 		iommu_enable_command_buffer(iommu);
 		iommu_enable_event_buffer(iommu);
@@ -1066,12 +1079,6 @@ static void disable_iommus(void)
 
 static int amd_iommu_resume(struct sys_device *dev)
 {
-	/*
-	 * Disable IOMMUs before reprogramming the hardware registers.
-	 * IOMMU is still enabled from the resume kernel.
-	 */
-	disable_iommus();
-
 	/* re-load the hardware */
 	enable_iommus();
 
@@ -1079,8 +1086,8 @@ static int amd_iommu_resume(struct sys_device *dev)
 	 * we have to flush after the IOMMUs are enabled because a
 	 * disabled IOMMU will never execute the commands we send
 	 */
-	amd_iommu_flush_all_domains();
 	amd_iommu_flush_all_devices();
+	amd_iommu_flush_all_domains();
 
 	return 0;
 }
@@ -1273,6 +1280,11 @@ free:
 	goto out;
 }
 
+void amd_iommu_shutdown(void)
+{
+	disable_iommus();
+}
+
 /****************************************************************************
  *
  * Early detect code. This code runs at IOMMU detection time in the DMA
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ef8d929..b7a7920 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -462,7 +462,8 @@ static struct IO_APIC_route_entry ioapic_read_entry(int apic, int pin)
 static void
 __ioapic_write_entry(int apic, int pin, struct IO_APIC_route_entry e)
 {
-	union entry_union eu;
+	union entry_union eu = {{0, 0}};
+
 	eu.entry = e;
 	io_apic_write(apic, 0x11 + 2*pin, eu.w2);
 	io_apic_write(apic, 0x10 + 2*pin, eu.w1);
@@ -2003,7 +2004,9 @@ void disable_IO_APIC(void)
 	/*
 	 * Use virtual wire A mode when interrupt remapping is enabled.
 	 */
-	disconnect_bsp_APIC(!intr_remapping_enabled && ioapic_i8259.pin != -1);
+	if (cpu_has_apic)
+		disconnect_bsp_APIC(!intr_remapping_enabled &&
+				ioapic_i8259.pin != -1);
 }
 
 #ifdef CONFIG_X86_32
@@ -3567,7 +3570,7 @@ static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
 
 #endif /* CONFIG_SMP */
 
-struct irq_chip dmar_msi_type = {
+static struct irq_chip dmar_msi_type = {
 	.name = "DMAR_MSI",
 	.unmask = dmar_msi_unmask,
 	.mask = dmar_msi_mask,
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 440a8bc..0c0182c 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -20,23 +20,12 @@
 #include <asm/apic.h>
 #include <asm/setup.h>
 
-#include <linux/threads.h>
-#include <linux/cpumask.h>
-#include <asm/mpspec.h>
-#include <asm/fixmap.h>
-#include <asm/apicdef.h>
-#include <linux/kernel.h>
-#include <linux/string.h>
 #include <linux/smp.h>
-#include <linux/init.h>
 #include <asm/ipi.h>
 
-#include <linux/smp.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <asm/acpi.h>
 #include <asm/e820.h>
-#include <asm/setup.h>
 
 #ifdef CONFIG_HOTPLUG_CPU
 #define DEFAULT_SEND_IPI	(1)
diff --git a/arch/x86/kernel/apic/summit_32.c b/arch/x86/kernel/apic/summit_32.c
index 344eee4..eafdfbd 100644
--- a/arch/x86/kernel/apic/summit_32.c
+++ b/arch/x86/kernel/apic/summit_32.c
@@ -44,7 +44,6 @@
 #include <asm/ipi.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/init.h>
 #include <linux/gfp.h>
 #include <linux/smp.h>
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3ffdcfa..ba1131a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -108,7 +108,7 @@ DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 	/* data */
 	[GDT_ENTRY_APMBIOS_BASE+2]	= { { { 0x0000ffff, 0x00409200 } } },
 
-	[GDT_ENTRY_ESPFIX_SS]		= { { { 0x00000000, 0x00c09200 } } },
+	[GDT_ENTRY_ESPFIX_SS]		= { { { 0x0000ffff, 0x00cf9200 } } },
 	[GDT_ENTRY_PERCPU]		= { { { 0x0000ffff, 0x00cf9200 } } },
 	GDT_STACK_CANARY_INIT
 #endif
@@ -853,6 +853,9 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 #if defined(CONFIG_NUMA) && defined(CONFIG_X86_64)
 	numa_add_cpu(smp_processor_id());
 #endif
+
+	/* Cap the iomem address space to what is addressable on all CPUs */
+	iomem_resource.end &= (1ULL << c->x86_phys_bits) - 1;
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index 45004fa..188a1ca 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,11 +1,12 @@
-obj-y				=  mce.o therm_throt.o
+obj-y				=  mce.o
 
 obj-$(CONFIG_X86_NEW_MCE)	+= mce-severity.o
 obj-$(CONFIG_X86_OLD_MCE)	+= k7.o p4.o p6.o
 obj-$(CONFIG_X86_ANCIENT_MCE)	+= winchip.o p5.o
-obj-$(CONFIG_X86_MCE_P4THERMAL)	+= mce_intel.o
-obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel_64.o mce_intel.o
-obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd_64.o
+obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
+obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd.o
 obj-$(CONFIG_X86_MCE_NONFATAL)	+= non-fatal.o
 obj-$(CONFIG_X86_MCE_THRESHOLD) += threshold.o
 obj-$(CONFIG_X86_MCE_INJECT)	+= mce-inject.o
+
+obj-$(CONFIG_X86_THERMAL_VECTOR) += therm_throt.o
diff --git a/arch/x86/kernel/cpu/mcheck/k7.c b/arch/x86/kernel/cpu/mcheck/k7.c
index 89e5104..b945d5d 100644
--- a/arch/x86/kernel/cpu/mcheck/k7.c
+++ b/arch/x86/kernel/cpu/mcheck/k7.c
@@ -10,10 +10,9 @@
 
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 /* Machine Check Handler For AMD Athlon/Duron: */
 static void k7_machine_check(struct pt_regs *regs, long error_code)
 {
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index fabba15..284d1de 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -44,7 +44,6 @@
 #include <asm/msr.h>
 
 #include "mce-internal.h"
-#include "mce.h"
 
 /* Handle unconfigured int18 (should never happen) */
 static void unexpected_machine_check(struct pt_regs *regs, long error_code)
@@ -57,7 +56,7 @@ static void unexpected_machine_check(struct pt_regs *regs, long error_code)
 void (*machine_check_vector)(struct pt_regs *, long error_code) =
 						unexpected_machine_check;
 
-int				mce_disabled;
+int mce_disabled __read_mostly;
 
 #ifdef CONFIG_X86_NEW_MCE
 
@@ -76,21 +75,22 @@ DEFINE_PER_CPU(unsigned, mce_exception_count);
  *   2: SIGBUS or log uncorrected errors (if possible), log corrected errors
  *   3: never panic or SIGBUS, log all errors (for testing only)
  */
-static int			tolerant = 1;
-static int			banks;
-static u64			*bank;
-static unsigned long		notify_user;
-static int			rip_msr;
-static int			mce_bootlog = -1;
-static int			monarch_timeout = -1;
-static int			mce_panic_timeout;
-static int			mce_dont_log_ce;
-int				mce_cmci_disabled;
-int				mce_ignore_ce;
-int				mce_ser;
-
-static char			trigger[128];
-static char			*trigger_argv[2] = { trigger, NULL };
+static int			tolerant		__read_mostly = 1;
+static int			banks			__read_mostly;
+static u64			*bank			__read_mostly;
+static int			rip_msr			__read_mostly;
+static int			mce_bootlog		__read_mostly = -1;
+static int			monarch_timeout		__read_mostly = -1;
+static int			mce_panic_timeout	__read_mostly;
+static int			mce_dont_log_ce		__read_mostly;
+int				mce_cmci_disabled	__read_mostly;
+int				mce_ignore_ce		__read_mostly;
+int				mce_ser			__read_mostly;
+
+/* User mode helper program triggered by machine check event */
+static unsigned long		mce_need_notify;
+static char			mce_helper[128];
+static char			*mce_helper_argv[2] = { mce_helper, NULL };
 
 static unsigned long		dont_init_banks;
 
@@ -180,7 +180,7 @@ void mce_log(struct mce *mce)
 	wmb();
 
 	mce->finished = 1;
-	set_bit(0, &notify_user);
+	set_bit(0, &mce_need_notify);
 }
 
 static void print_mce(struct mce *m)
@@ -691,18 +691,21 @@ static atomic_t global_nwo;
  * in the entry order.
  * TBD double check parallel CPU hotunplug
  */
-static int mce_start(int no_way_out, int *order)
+static int mce_start(int *no_way_out)
 {
-	int nwo;
+	int order;
 	int cpus = num_online_cpus();
 	u64 timeout = (u64)monarch_timeout * NSEC_PER_USEC;
 
-	if (!timeout) {
-		*order = -1;
-		return no_way_out;
-	}
+	if (!timeout)
+		return -1;
 
-	atomic_add(no_way_out, &global_nwo);
+	atomic_add(*no_way_out, &global_nwo);
+	/*
+	 * global_nwo should be updated before mce_callin
+	 */
+	smp_wmb();
+	order = atomic_add_return(1, &mce_callin);
 
 	/*
 	 * Wait for everyone.
@@ -710,40 +713,43 @@ static int mce_start(int no_way_out, int *order)
 	while (atomic_read(&mce_callin) != cpus) {
 		if (mce_timed_out(&timeout)) {
 			atomic_set(&global_nwo, 0);
-			*order = -1;
-			return no_way_out;
+			return -1;
 		}
 		ndelay(SPINUNIT);
 	}
 
 	/*
-	 * Cache the global no_way_out state.
+	 * mce_callin should be read before global_nwo
 	 */
-	nwo = atomic_read(&global_nwo);
+	smp_rmb();
 
-	/*
-	 * Monarch starts executing now, the others wait.
-	 */
-	if (*order == 1) {
+	if (order == 1) {
+		/*
+		 * Monarch: Starts executing now, the others wait.
+		 */
 		atomic_set(&mce_executing, 1);
-		return nwo;
+	} else {
+		/*
+		 * Subject: Now start the scanning loop one by one in
+		 * the original callin order.
+		 * This way when there are any shared banks it will be
+		 * only seen by one CPU before cleared, avoiding duplicates.
+		 */
+		while (atomic_read(&mce_executing) < order) {
+			if (mce_timed_out(&timeout)) {
+				atomic_set(&global_nwo, 0);
+				return -1;
+			}
+			ndelay(SPINUNIT);
+		}
 	}
 
 	/*
-	 * Now start the scanning loop one by one
-	 * in the original callin order.
-	 * This way when there are any shared banks it will
-	 * be only seen by one CPU before cleared, avoiding duplicates.
+	 * Cache the global no_way_out state.
 	 */
-	while (atomic_read(&mce_executing) < *order) {
-		if (mce_timed_out(&timeout)) {
-			atomic_set(&global_nwo, 0);
-			*order = -1;
-			return no_way_out;
-		}
-		ndelay(SPINUNIT);
-	}
-	return nwo;
+	*no_way_out = atomic_read(&global_nwo);
+
+	return order;
 }
 
 /*
@@ -863,7 +869,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * check handler.
 	 */
 	int order;
-
 	/*
 	 * If no_way_out gets set, there is no safe way to recover from this
 	 * MCE.  If tolerant is cranked up, we'll try anyway.
@@ -887,7 +892,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	if (!banks)
 		goto out;
 
-	order = atomic_add_return(1, &mce_callin);
 	mce_setup(&m);
 
 	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
@@ -909,7 +913,7 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	 * This way we don't report duplicated events on shared banks
 	 * because the first one to see it will clear it.
 	 */
-	no_way_out = mce_start(no_way_out, &order);
+	order = mce_start(&no_way_out);
 	for (i = 0; i < banks; i++) {
 		__clear_bit(i, toclear);
 		if (!bank[i])
@@ -1118,7 +1122,7 @@ static void mcheck_timer(unsigned long data)
 
 static void mce_do_trigger(struct work_struct *work)
 {
-	call_usermodehelper(trigger, trigger_argv, NULL, UMH_NO_WAIT);
+	call_usermodehelper(mce_helper, mce_helper_argv, NULL, UMH_NO_WAIT);
 }
 
 static DECLARE_WORK(mce_trigger_work, mce_do_trigger);
@@ -1135,7 +1139,7 @@ int mce_notify_irq(void)
 
 	clear_thread_flag(TIF_MCE_NOTIFY);
 
-	if (test_and_clear_bit(0, &notify_user)) {
+	if (test_and_clear_bit(0, &mce_need_notify)) {
 		wake_up_interruptible(&mce_wait);
 
 		/*
@@ -1143,7 +1147,7 @@ int mce_notify_irq(void)
 		 * work_pending is always cleared before the function is
 		 * executed.
 		 */
-		if (trigger[0] && !work_pending(&mce_trigger_work))
+		if (mce_helper[0] && !work_pending(&mce_trigger_work))
 			schedule_work(&mce_trigger_work);
 
 		if (__ratelimit(&ratelimit))
@@ -1245,7 +1249,7 @@ static void mce_cpu_quirks(struct cpuinfo_x86 *c)
 		 * Various K7s with broken bank 0 around. Always disable
 		 * by default.
 		 */
-		 if (c->x86 == 6)
+		 if (c->x86 == 6 && banks > 0)
 			bank[0] = 0;
 	}
 
@@ -1282,8 +1286,7 @@ static void __cpuinit mce_ancient_init(struct cpuinfo_x86 *c)
 		return;
 	switch (c->x86_vendor) {
 	case X86_VENDOR_INTEL:
-		if (mce_p5_enabled())
-			intel_p5_mcheck_init(c);
+		intel_p5_mcheck_init(c);
 		break;
 	case X86_VENDOR_CENTAUR:
 		winchip_mcheck_init(c);
@@ -1609,8 +1612,9 @@ static int mce_resume(struct sys_device *dev)
 static void mce_cpu_restart(void *data)
 {
 	del_timer_sync(&__get_cpu_var(mce_timer));
-	if (mce_available(&current_cpu_data))
-		mce_init();
+	if (!mce_available(&current_cpu_data))
+		return;
+	mce_init();
 	mce_init_timer();
 }
 
@@ -1620,6 +1624,26 @@ static void mce_restart(void)
 	on_each_cpu(mce_cpu_restart, NULL, 1);
 }
 
+/* Toggle features for corrected errors */
+static void mce_disable_ce(void *all)
+{
+	if (!mce_available(&current_cpu_data))
+		return;
+	if (all)
+		del_timer_sync(&__get_cpu_var(mce_timer));
+	cmci_clear();
+}
+
+static void mce_enable_ce(void *all)
+{
+	if (!mce_available(&current_cpu_data))
+		return;
+	cmci_reenable();
+	cmci_recheck();
+	if (all)
+		mce_init_timer();
+}
+
 static struct sysdev_class mce_sysclass = {
 	.suspend	= mce_suspend,
 	.shutdown	= mce_shutdown,
@@ -1659,9 +1683,9 @@ static ssize_t set_bank(struct sys_device *s, struct sysdev_attribute *attr,
 static ssize_t
 show_trigger(struct sys_device *s, struct sysdev_attribute *attr, char *buf)
 {
-	strcpy(buf, trigger);
+	strcpy(buf, mce_helper);
 	strcat(buf, "\n");
-	return strlen(trigger) + 1;
+	return strlen(mce_helper) + 1;
 }
 
 static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
@@ -1670,10 +1694,10 @@ static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
 	char *p;
 	int len;
 
-	strncpy(trigger, buf, sizeof(trigger));
-	trigger[sizeof(trigger)-1] = 0;
-	len = strlen(trigger);
-	p = strchr(trigger, '\n');
+	strncpy(mce_helper, buf, sizeof(mce_helper));
+	mce_helper[sizeof(mce_helper)-1] = 0;
+	len = strlen(mce_helper);
+	p = strchr(mce_helper, '\n');
 
 	if (*p)
 		*p = 0;
@@ -1681,6 +1705,52 @@ static ssize_t set_trigger(struct sys_device *s, struct sysdev_attribute *attr,
 	return len;
 }
 
+static ssize_t set_ignore_ce(struct sys_device *s,
+			     struct sysdev_attribute *attr,
+			     const char *buf, size_t size)
+{
+	u64 new;
+
+	if (strict_strtoull(buf, 0, &new) < 0)
+		return -EINVAL;
+
+	if (mce_ignore_ce ^ !!new) {
+		if (new) {
+			/* disable ce features */
+			on_each_cpu(mce_disable_ce, (void *)1, 1);
+			mce_ignore_ce = 1;
+		} else {
+			/* enable ce features */
+			mce_ignore_ce = 0;
+			on_each_cpu(mce_enable_ce, (void *)1, 1);
+		}
+	}
+	return size;
+}
+
+static ssize_t set_cmci_disabled(struct sys_device *s,
+				 struct sysdev_attribute *attr,
+				 const char *buf, size_t size)
+{
+	u64 new;
+
+	if (strict_strtoull(buf, 0, &new) < 0)
+		return -EINVAL;
+
+	if (mce_cmci_disabled ^ !!new) {
+		if (new) {
+			/* disable cmci */
+			on_each_cpu(mce_disable_ce, NULL, 1);
+			mce_cmci_disabled = 1;
+		} else {
+			/* enable cmci */
+			mce_cmci_disabled = 0;
+			on_each_cpu(mce_enable_ce, NULL, 1);
+		}
+	}
+	return size;
+}
+
 static ssize_t store_int_with_restart(struct sys_device *s,
 				      struct sysdev_attribute *attr,
 				      const char *buf, size_t size)
@@ -1693,6 +1763,7 @@ static ssize_t store_int_with_restart(struct sys_device *s,
 static SYSDEV_ATTR(trigger, 0644, show_trigger, set_trigger);
 static SYSDEV_INT_ATTR(tolerant, 0644, tolerant);
 static SYSDEV_INT_ATTR(monarch_timeout, 0644, monarch_timeout);
+static SYSDEV_INT_ATTR(dont_log_ce, 0644, mce_dont_log_ce);
 
 static struct sysdev_ext_attribute attr_check_interval = {
 	_SYSDEV_ATTR(check_interval, 0644, sysdev_show_int,
@@ -1700,9 +1771,24 @@ static struct sysdev_ext_attribute attr_check_interval = {
 	&check_interval
 };
 
+static struct sysdev_ext_attribute attr_ignore_ce = {
+	_SYSDEV_ATTR(ignore_ce, 0644, sysdev_show_int, set_ignore_ce),
+	&mce_ignore_ce
+};
+
+static struct sysdev_ext_attribute attr_cmci_disabled = {
+	_SYSDEV_ATTR(cmci_disabled, 0644, sysdev_show_int, set_cmci_disabled),
+	&mce_cmci_disabled
+};
+
 static struct sysdev_attribute *mce_attrs[] = {
-	&attr_tolerant.attr, &attr_check_interval.attr, &attr_trigger,
+	&attr_tolerant.attr,
+	&attr_check_interval.attr,
+	&attr_trigger,
 	&attr_monarch_timeout.attr,
+	&attr_dont_log_ce.attr,
+	&attr_ignore_ce.attr,
+	&attr_cmci_disabled.attr,
 	NULL
 };
 
@@ -1712,7 +1798,7 @@ static cpumask_var_t mce_dev_initialized;
 static __cpuinit int mce_create_device(unsigned int cpu)
 {
 	int err;
-	int i;
+	int i, j;
 
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
@@ -1730,9 +1816,9 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 		if (err)
 			goto error;
 	}
-	for (i = 0; i < banks; i++) {
+	for (j = 0; j < banks; j++) {
 		err = sysdev_create_file(&per_cpu(mce_dev, cpu),
-					&bank_attrs[i]);
+					&bank_attrs[j]);
 		if (err)
 			goto error2;
 	}
@@ -1740,8 +1826,8 @@ static __cpuinit int mce_create_device(unsigned int cpu)
 
 	return 0;
 error2:
-	while (--i >= 0)
-		sysdev_remove_file(&per_cpu(mce_dev, cpu), &bank_attrs[i]);
+	while (--j >= 0)
+		sysdev_remove_file(&per_cpu(mce_dev, cpu), &bank_attrs[j]);
 error:
 	while (--i >= 0)
 		sysdev_remove_file(&per_cpu(mce_dev, cpu), mce_attrs[i]);
@@ -1883,7 +1969,7 @@ static __init int mce_init_device(void)
 	if (!mce_available(&boot_cpu_data))
 		return -EIO;
 
-	alloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
+	zalloc_cpumask_var(&mce_dev_initialized, GFP_KERNEL);
 
 	err = mce_init_banks();
 	if (err)
@@ -1915,7 +2001,7 @@ EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
 /* This has to be run for each processor */
 void mcheck_init(struct cpuinfo_x86 *c)
 {
-	if (mce_disabled == 1)
+	if (mce_disabled)
 		return;
 
 	switch (c->x86_vendor) {
@@ -1945,10 +2031,9 @@ void mcheck_init(struct cpuinfo_x86 *c)
 
 static int __init mcheck_enable(char *str)
 {
-	mce_disabled = -1;
+	mce_p5_enabled = 1;
 	return 1;
 }
-
 __setup("mce", mcheck_enable);
 
 #endif /* CONFIG_X86_OLD_MCE */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.h b/arch/x86/kernel/cpu/mcheck/mce.h
deleted file mode 100644
index 84a552b..0000000
--- a/arch/x86/kernel/cpu/mcheck/mce.h
+++ /dev/null
@@ -1,38 +0,0 @@
-#include <linux/init.h>
-#include <asm/mce.h>
-
-#ifdef CONFIG_X86_OLD_MCE
-void amd_mcheck_init(struct cpuinfo_x86 *c);
-void intel_p4_mcheck_init(struct cpuinfo_x86 *c);
-void intel_p6_mcheck_init(struct cpuinfo_x86 *c);
-#endif
-
-#ifdef CONFIG_X86_ANCIENT_MCE
-void intel_p5_mcheck_init(struct cpuinfo_x86 *c);
-void winchip_mcheck_init(struct cpuinfo_x86 *c);
-extern int mce_p5_enable;
-static inline int mce_p5_enabled(void) { return mce_p5_enable; }
-static inline void enable_p5_mce(void) { mce_p5_enable = 1; }
-#else
-static inline void intel_p5_mcheck_init(struct cpuinfo_x86 *c) {}
-static inline void winchip_mcheck_init(struct cpuinfo_x86 *c) {}
-static inline int mce_p5_enabled(void) { return 0; }
-static inline void enable_p5_mce(void) { }
-#endif
-
-/* Call the installed machine check handler for this CPU setup. */
-extern void (*machine_check_vector)(struct pt_regs *, long error_code);
-
-#ifdef CONFIG_X86_OLD_MCE
-
-extern int nr_mce_banks;
-
-void intel_set_thermal_handler(void);
-
-#else
-
-static inline void intel_set_thermal_handler(void) { }
-
-#endif
-
-void intel_init_thermal(struct cpuinfo_x86 *c);
diff --git a/arch/x86/kernel/cpu/mcheck/mce_amd_64.c b/arch/x86/kernel/cpu/mcheck/mce_amd.c
similarity index 100%
rename from arch/x86/kernel/cpu/mcheck/mce_amd_64.c
rename to arch/x86/kernel/cpu/mcheck/mce_amd.c
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel.c b/arch/x86/kernel/cpu/mcheck/mce_intel.c
index 2b011d2..e1acec0 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_intel.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_intel.c
@@ -1,74 +1,226 @@
 /*
- * Common code for Intel machine checks
+ * Intel specific MCE features.
+ * Copyright 2004 Zwane Mwaikambo <zwane@linuxpower.ca>
+ * Copyright (C) 2008, 2009 Intel Corporation
+ * Author: Andi Kleen
  */
-#include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/smp.h>
 
-#include <asm/therm_throt.h>
-#include <asm/processor.h>
-#include <asm/system.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/percpu.h>
 #include <asm/apic.h>
+#include <asm/processor.h>
 #include <asm/msr.h>
+#include <asm/mce.h>
+
+/*
+ * Support for Intel Correct Machine Check Interrupts. This allows
+ * the CPU to raise an interrupt when a corrected machine check happened.
+ * Normally we pick those up using a regular polling timer.
+ * Also supports reliable discovery of shared banks.
+ */
 
-#include "mce.h"
+static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
 
-void intel_init_thermal(struct cpuinfo_x86 *c)
+/*
+ * cmci_discover_lock protects against parallel discovery attempts
+ * which could race against each other.
+ */
+static DEFINE_SPINLOCK(cmci_discover_lock);
+
+#define CMCI_THRESHOLD 1
+
+static int cmci_supported(int *banks)
 {
-	unsigned int cpu = smp_processor_id();
-	int tm2 = 0;
-	u32 l, h;
+	u64 cap;
 
-	/* Thermal monitoring depends on ACPI and clock modulation*/
-	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
-		return;
+	if (mce_cmci_disabled || mce_ignore_ce)
+		return 0;
 
 	/*
-	 * First check if its enabled already, in which case there might
-	 * be some SMM goo which handles it, so we can't even put a handler
-	 * since it might be delivered via SMI already:
+	 * Vendor check is not strictly needed, but the initial
+	 * initialization is vendor keyed and this
+	 * makes sure none of the backdoors are entered otherwise.
 	 */
-	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
-	h = apic_read(APIC_LVTTHMR);
-	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
-		printk(KERN_DEBUG
-		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
-		return;
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return 0;
+	if (!cpu_has_apic || lapic_get_maxlvt() < 6)
+		return 0;
+	rdmsrl(MSR_IA32_MCG_CAP, cap);
+	*banks = min_t(unsigned, MAX_NR_BANKS, cap & 0xff);
+	return !!(cap & MCG_CMCI_P);
+}
+
+/*
+ * The interrupt handler. This is called on every event.
+ * Just call the poller directly to log any events.
+ * This could in theory increase the threshold under high load,
+ * but doesn't for now.
+ */
+static void intel_threshold_interrupt(void)
+{
+	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+	mce_notify_irq();
+}
+
+static void print_update(char *type, int *hdr, int num)
+{
+	if (*hdr == 0)
+		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
+	*hdr = 1;
+	printk(KERN_CONT " %s:%d", type, num);
+}
+
+/*
+ * Enable CMCI (Corrected Machine Check Interrupt) for available MCE banks
+ * on this CPU. Use the algorithm recommended in the SDM to discover shared
+ * banks.
+ */
+static void cmci_discover(int banks, int boot)
+{
+	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
+	unsigned long flags;
+	int hdr = 0;
+	int i;
+
+	spin_lock_irqsave(&cmci_discover_lock, flags);
+	for (i = 0; i < banks; i++) {
+		u64 val;
+
+		if (test_bit(i, owned))
+			continue;
+
+		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+
+		/* Already owned by someone else? */
+		if (val & CMCI_EN) {
+			if (test_and_clear_bit(i, owned) || boot)
+				print_update("SHD", &hdr, i);
+			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+			continue;
+		}
+
+		val |= CMCI_EN | CMCI_THRESHOLD;
+		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+
+		/* Did the enable bit stick? -- the bank supports CMCI */
+		if (val & CMCI_EN) {
+			if (!test_and_set_bit(i, owned) || boot)
+				print_update("CMCI", &hdr, i);
+			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+		} else {
+			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
+		}
 	}
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+	if (hdr)
+		printk(KERN_CONT "\n");
+}
+
+/*
+ * Just in case we missed an event during initialization check
+ * all the CMCI owned banks.
+ */
+void cmci_recheck(void)
+{
+	unsigned long flags;
+	int banks;
+
+	if (!mce_available(&current_cpu_data) || !cmci_supported(&banks))
+		return;
+	local_irq_save(flags);
+	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+	local_irq_restore(flags);
+}
 
-	if (cpu_has(c, X86_FEATURE_TM2) && (l & MSR_IA32_MISC_ENABLE_TM2))
-		tm2 = 1;
+/*
+ * Disable CMCI on this CPU for all banks it owns when it goes down.
+ * This allows other CPUs to claim the banks on rediscovery.
+ */
+void cmci_clear(void)
+{
+	unsigned long flags;
+	int i;
+	int banks;
+	u64 val;
 
-	/* Check whether a vector already exists */
-	if (h & APIC_VECTOR_MASK) {
-		printk(KERN_DEBUG
-		       "CPU%d: Thermal LVT vector (%#x) already installed\n",
-		       cpu, (h & APIC_VECTOR_MASK));
+	if (!cmci_supported(&banks))
 		return;
+	spin_lock_irqsave(&cmci_discover_lock, flags);
+	for (i = 0; i < banks; i++) {
+		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
+			continue;
+		/* Disable CMCI */
+		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		val &= ~(CMCI_EN|CMCI_THRESHOLD_MASK);
+		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		__clear_bit(i, __get_cpu_var(mce_banks_owned));
 	}
+	spin_unlock_irqrestore(&cmci_discover_lock, flags);
+}
+
+/*
+ * After a CPU went down cycle through all the others and rediscover
+ * Must run in process context.
+ */
+void cmci_rediscover(int dying)
+{
+	int banks;
+	int cpu;
+	cpumask_var_t old;
+
+	if (!cmci_supported(&banks))
+		return;
+	if (!alloc_cpumask_var(&old, GFP_KERNEL))
+		return;
+	cpumask_copy(old, &current->cpus_allowed);
 
-	/* We'll mask the thermal vector in the lapic till we're ready: */
-	h = THERMAL_APIC_VECTOR | APIC_DM_FIXED | APIC_LVT_MASKED;
-	apic_write(APIC_LVTTHMR, h);
+	for_each_online_cpu(cpu) {
+		if (cpu == dying)
+			continue;
+		if (set_cpus_allowed_ptr(current, cpumask_of(cpu)))
+			continue;
+		/* Recheck banks in case CPUs don't all have the same */
+		if (cmci_supported(&banks))
+			cmci_discover(banks, 0);
+	}
 
-	rdmsr(MSR_IA32_THERM_INTERRUPT, l, h);
-	wrmsr(MSR_IA32_THERM_INTERRUPT,
-		l | (THERM_INT_LOW_ENABLE | THERM_INT_HIGH_ENABLE), h);
+	set_cpus_allowed_ptr(current, old);
+	free_cpumask_var(old);
+}
 
-	intel_set_thermal_handler();
+/*
+ * Reenable CMCI on this CPU in case a CPU down failed.
+ */
+void cmci_reenable(void)
+{
+	int banks;
+	if (cmci_supported(&banks))
+		cmci_discover(banks, 0);
+}
 
-	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
-	wrmsr(MSR_IA32_MISC_ENABLE, l | MSR_IA32_MISC_ENABLE_TM1, h);
+static void intel_init_cmci(void)
+{
+	int banks;
 
-	/* Unmask the thermal vector: */
-	l = apic_read(APIC_LVTTHMR);
-	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
+	if (!cmci_supported(&banks))
+		return;
 
-	printk(KERN_INFO "CPU%d: Thermal monitoring enabled (%s)\n",
-	       cpu, tm2 ? "TM2" : "TM1");
+	mce_threshold_vector = intel_threshold_interrupt;
+	cmci_discover(banks, 1);
+	/*
+	 * For CPU #0 this runs with still disabled APIC, but that's
+	 * ok because only the vector is set up. We still do another
+	 * check for the banks later for CPU #0 just to make sure
+	 * to not miss any events.
+	 */
+	apic_write(APIC_LVTCMCI, THRESHOLD_APIC_VECTOR|APIC_DM_FIXED);
+	cmci_recheck();
+}
 
-	/* enable thermal throttle processing */
-	atomic_set(&therm_throt_en, 1);
+void mce_intel_feature_init(struct cpuinfo_x86 *c)
+{
+	intel_init_thermal(c);
+	intel_init_cmci();
 }
diff --git a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c b/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
deleted file mode 100644
index f2ef695..0000000
--- a/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
+++ /dev/null
@@ -1,248 +0,0 @@
-/*
- * Intel specific MCE features.
- * Copyright 2004 Zwane Mwaikambo <zwane@linuxpower.ca>
- * Copyright (C) 2008, 2009 Intel Corporation
- * Author: Andi Kleen
- */
-
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/percpu.h>
-#include <asm/processor.h>
-#include <asm/apic.h>
-#include <asm/msr.h>
-#include <asm/mce.h>
-#include <asm/hw_irq.h>
-#include <asm/idle.h>
-#include <asm/therm_throt.h>
-
-#include "mce.h"
-
-asmlinkage void smp_thermal_interrupt(void)
-{
-	__u64 msr_val;
-
-	ack_APIC_irq();
-
-	exit_idle();
-	irq_enter();
-
-	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
-	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT))
-		mce_log_therm_throt_event(msr_val);
-
-	inc_irq_stat(irq_thermal_count);
-	irq_exit();
-}
-
-/*
- * Support for Intel Correct Machine Check Interrupts. This allows
- * the CPU to raise an interrupt when a corrected machine check happened.
- * Normally we pick those up using a regular polling timer.
- * Also supports reliable discovery of shared banks.
- */
-
-static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
-
-/*
- * cmci_discover_lock protects against parallel discovery attempts
- * which could race against each other.
- */
-static DEFINE_SPINLOCK(cmci_discover_lock);
-
-#define CMCI_THRESHOLD 1
-
-static int cmci_supported(int *banks)
-{
-	u64 cap;
-
-	if (mce_cmci_disabled || mce_ignore_ce)
-		return 0;
-
-	/*
-	 * Vendor check is not strictly needed, but the initial
-	 * initialization is vendor keyed and this
-	 * makes sure none of the backdoors are entered otherwise.
-	 */
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
-		return 0;
-	if (!cpu_has_apic || lapic_get_maxlvt() < 6)
-		return 0;
-	rdmsrl(MSR_IA32_MCG_CAP, cap);
-	*banks = min_t(unsigned, MAX_NR_BANKS, cap & 0xff);
-	return !!(cap & MCG_CMCI_P);
-}
-
-/*
- * The interrupt handler. This is called on every event.
- * Just call the poller directly to log any events.
- * This could in theory increase the threshold under high load,
- * but doesn't for now.
- */
-static void intel_threshold_interrupt(void)
-{
-	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
-	mce_notify_irq();
-}
-
-static void print_update(char *type, int *hdr, int num)
-{
-	if (*hdr == 0)
-		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
-	*hdr = 1;
-	printk(KERN_CONT " %s:%d", type, num);
-}
-
-/*
- * Enable CMCI (Corrected Machine Check Interrupt) for available MCE banks
- * on this CPU. Use the algorithm recommended in the SDM to discover shared
- * banks.
- */
-static void cmci_discover(int banks, int boot)
-{
-	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
-	unsigned long flags;
-	int hdr = 0;
-	int i;
-
-	spin_lock_irqsave(&cmci_discover_lock, flags);
-	for (i = 0; i < banks; i++) {
-		u64 val;
-
-		if (test_bit(i, owned))
-			continue;
-
-		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
-
-		/* Already owned by someone else? */
-		if (val & CMCI_EN) {
-			if (test_and_clear_bit(i, owned) || boot)
-				print_update("SHD", &hdr, i);
-			__clear_bit(i, __get_cpu_var(mce_poll_banks));
-			continue;
-		}
-
-		val |= CMCI_EN | CMCI_THRESHOLD;
-		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
-		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
-
-		/* Did the enable bit stick? -- the bank supports CMCI */
-		if (val & CMCI_EN) {
-			if (!test_and_set_bit(i, owned) || boot)
-				print_update("CMCI", &hdr, i);
-			__clear_bit(i, __get_cpu_var(mce_poll_banks));
-		} else {
-			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
-		}
-	}
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
-	if (hdr)
-		printk(KERN_CONT "\n");
-}
-
-/*
- * Just in case we missed an event during initialization check
- * all the CMCI owned banks.
- */
-void cmci_recheck(void)
-{
-	unsigned long flags;
-	int banks;
-
-	if (!mce_available(&current_cpu_data) || !cmci_supported(&banks))
-		return;
-	local_irq_save(flags);
-	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
-	local_irq_restore(flags);
-}
-
-/*
- * Disable CMCI on this CPU for all banks it owns when it goes down.
- * This allows other CPUs to claim the banks on rediscovery.
- */
-void cmci_clear(void)
-{
-	unsigned long flags;
-	int i;
-	int banks;
-	u64 val;
-
-	if (!cmci_supported(&banks))
-		return;
-	spin_lock_irqsave(&cmci_discover_lock, flags);
-	for (i = 0; i < banks; i++) {
-		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
-			continue;
-		/* Disable CMCI */
-		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
-		val &= ~(CMCI_EN|CMCI_THRESHOLD_MASK);
-		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
-		__clear_bit(i, __get_cpu_var(mce_banks_owned));
-	}
-	spin_unlock_irqrestore(&cmci_discover_lock, flags);
-}
-
-/*
- * After a CPU went down cycle through all the others and rediscover
- * Must run in process context.
- */
-void cmci_rediscover(int dying)
-{
-	int banks;
-	int cpu;
-	cpumask_var_t old;
-
-	if (!cmci_supported(&banks))
-		return;
-	if (!alloc_cpumask_var(&old, GFP_KERNEL))
-		return;
-	cpumask_copy(old, &current->cpus_allowed);
-
-	for_each_online_cpu(cpu) {
-		if (cpu == dying)
-			continue;
-		if (set_cpus_allowed_ptr(current, cpumask_of(cpu)))
-			continue;
-		/* Recheck banks in case CPUs don't all have the same */
-		if (cmci_supported(&banks))
-			cmci_discover(banks, 0);
-	}
-
-	set_cpus_allowed_ptr(current, old);
-	free_cpumask_var(old);
-}
-
-/*
- * Reenable CMCI on this CPU in case a CPU down failed.
- */
-void cmci_reenable(void)
-{
-	int banks;
-	if (cmci_supported(&banks))
-		cmci_discover(banks, 0);
-}
-
-static void intel_init_cmci(void)
-{
-	int banks;
-
-	if (!cmci_supported(&banks))
-		return;
-
-	mce_threshold_vector = intel_threshold_interrupt;
-	cmci_discover(banks, 1);
-	/*
-	 * For CPU #0 this runs with still disabled APIC, but that's
-	 * ok because only the vector is set up. We still do another
-	 * check for the banks later for CPU #0 just to make sure
-	 * to not miss any events.
-	 */
-	apic_write(APIC_LVTCMCI, THRESHOLD_APIC_VECTOR|APIC_DM_FIXED);
-	cmci_recheck();
-}
-
-void mce_intel_feature_init(struct cpuinfo_x86 *c)
-{
-	intel_init_thermal(c);
-	intel_init_cmci();
-}
diff --git a/arch/x86/kernel/cpu/mcheck/non-fatal.c b/arch/x86/kernel/cpu/mcheck/non-fatal.c
index 70b7104..f5f2d6f 100644
--- a/arch/x86/kernel/cpu/mcheck/non-fatal.c
+++ b/arch/x86/kernel/cpu/mcheck/non-fatal.c
@@ -17,10 +17,9 @@
 
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 static int		firstbank;
 
 #define MCE_RATE	(15*HZ)	/* timer rate is 15s */
diff --git a/arch/x86/kernel/cpu/mcheck/p4.c b/arch/x86/kernel/cpu/mcheck/p4.c
index 82cee10..4482aea 100644
--- a/arch/x86/kernel/cpu/mcheck/p4.c
+++ b/arch/x86/kernel/cpu/mcheck/p4.c
@@ -1,21 +1,15 @@
 /*
  * P4 specific Machine Check Exception Reporting
  */
-
-#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/smp.h>
 
-#include <asm/therm_throt.h>
 #include <asm/processor.h>
-#include <asm/system.h>
-#include <asm/apic.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 /* as supported by the P4/Xeon family */
 struct intel_mce_extended_msrs {
 	u32 eax;
@@ -33,46 +27,6 @@ struct intel_mce_extended_msrs {
 
 static int mce_num_extended_msrs;
 
-
-#ifdef CONFIG_X86_MCE_P4THERMAL
-
-static void unexpected_thermal_interrupt(struct pt_regs *regs)
-{
-	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
-			smp_processor_id());
-	add_taint(TAINT_MACHINE_CHECK);
-}
-
-/* P4/Xeon Thermal transition interrupt handler: */
-static void intel_thermal_interrupt(struct pt_regs *regs)
-{
-	__u64 msr_val;
-
-	ack_APIC_irq();
-
-	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
-	therm_throt_process(msr_val & THERM_STATUS_PROCHOT);
-}
-
-/* Thermal interrupt handler for this CPU setup: */
-static void (*vendor_thermal_interrupt)(struct pt_regs *regs) =
-						unexpected_thermal_interrupt;
-
-void smp_thermal_interrupt(struct pt_regs *regs)
-{
-	irq_enter();
-	vendor_thermal_interrupt(regs);
-	__get_cpu_var(irq_stat).irq_thermal_count++;
-	irq_exit();
-}
-
-void intel_set_thermal_handler(void)
-{
-	vendor_thermal_interrupt = intel_thermal_interrupt;
-}
-
-#endif /* CONFIG_X86_MCE_P4THERMAL */
-
 /* P4/Xeon Extended MCE MSR retrieval, return 0 if unsupported */
 static void intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
 {
diff --git a/arch/x86/kernel/cpu/mcheck/p5.c b/arch/x86/kernel/cpu/mcheck/p5.c
index 015f481..5c0e653 100644
--- a/arch/x86/kernel/cpu/mcheck/p5.c
+++ b/arch/x86/kernel/cpu/mcheck/p5.c
@@ -10,12 +10,11 @@
 
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 /* By default disabled */
-int		mce_p5_enable;
+int mce_p5_enabled __read_mostly;
 
 /* Machine check handler for Pentium class Intel CPUs: */
 static void pentium_machine_check(struct pt_regs *regs, long error_code)
@@ -43,15 +42,13 @@ void intel_p5_mcheck_init(struct cpuinfo_x86 *c)
 {
 	u32 l, h;
 
-	/* Check for MCE support: */
-	if (!cpu_has(c, X86_FEATURE_MCE))
+	/* Default P5 to off as its often misconnected: */
+	if (!mce_p5_enabled)
 		return;
 
-#ifdef CONFIG_X86_OLD_MCE
-	/* Default P5 to off as its often misconnected: */
-	if (mce_disabled != -1)
+	/* Check for MCE support: */
+	if (!cpu_has(c, X86_FEATURE_MCE))
 		return;
-#endif
 
 	machine_check_vector = pentium_machine_check;
 	/* Make sure the vector pointer is visible before we enable MCEs: */
diff --git a/arch/x86/kernel/cpu/mcheck/p6.c b/arch/x86/kernel/cpu/mcheck/p6.c
index 43c24e6..01e4f81 100644
--- a/arch/x86/kernel/cpu/mcheck/p6.c
+++ b/arch/x86/kernel/cpu/mcheck/p6.c
@@ -10,10 +10,9 @@
 
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 /* Machine Check Handler For PII/PIII */
 static void intel_machine_check(struct pt_regs *regs, long error_code)
 {
diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index 7b1ae2e..bff8dd1 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -13,13 +13,23 @@
  * Credits: Adapted from Zwane Mwaikambo's original code in mce_intel.c.
  *          Inspired by Ross Biro's and Al Borchers' counter code.
  */
+#include <linux/interrupt.h>
 #include <linux/notifier.h>
 #include <linux/jiffies.h>
+#include <linux/kernel.h>
 #include <linux/percpu.h>
 #include <linux/sysdev.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/smp.h>
 #include <linux/cpu.h>
 
-#include <asm/therm_throt.h>
+#include <asm/processor.h>
+#include <asm/system.h>
+#include <asm/apic.h>
+#include <asm/idle.h>
+#include <asm/mce.h>
+#include <asm/msr.h>
 
 /* How long to wait between reporting thermal events */
 #define CHECK_INTERVAL		(300 * HZ)
@@ -27,7 +37,7 @@
 static DEFINE_PER_CPU(__u64, next_check) = INITIAL_JIFFIES;
 static DEFINE_PER_CPU(unsigned long, thermal_throttle_count);
 
-atomic_t therm_throt_en		= ATOMIC_INIT(0);
+static atomic_t therm_throt_en		= ATOMIC_INIT(0);
 
 #ifdef CONFIG_SYSFS
 #define define_therm_throt_sysdev_one_ro(_name)				\
@@ -82,7 +92,7 @@ static struct attribute_group thermal_throttle_attr_group = {
  *          1 : Event should be logged further, and a message has been
  *              printed to the syslog.
  */
-int therm_throt_process(int curr)
+static int therm_throt_process(int curr)
 {
 	unsigned int cpu = smp_processor_id();
 	__u64 tmp_jiffs = get_jiffies_64();
@@ -186,6 +196,94 @@ static __init int thermal_throttle_init_device(void)
 
 	return 0;
 }
-
 device_initcall(thermal_throttle_init_device);
+
 #endif /* CONFIG_SYSFS */
+
+/* Thermal transition interrupt handler */
+static void intel_thermal_interrupt(void)
+{
+	__u64 msr_val;
+
+	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
+	if (therm_throt_process(msr_val & THERM_STATUS_PROCHOT))
+		mce_log_therm_throt_event(msr_val);
+}
+
+static void unexpected_thermal_interrupt(void)
+{
+	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
+			smp_processor_id());
+	add_taint(TAINT_MACHINE_CHECK);
+}
+
+static void (*smp_thermal_vector)(void) = unexpected_thermal_interrupt;
+
+asmlinkage void smp_thermal_interrupt(struct pt_regs *regs)
+{
+	exit_idle();
+	irq_enter();
+	inc_irq_stat(irq_thermal_count);
+	smp_thermal_vector();
+	irq_exit();
+	/* Ack only at the end to avoid potential reentry */
+	ack_APIC_irq();
+}
+
+void intel_init_thermal(struct cpuinfo_x86 *c)
+{
+	unsigned int cpu = smp_processor_id();
+	int tm2 = 0;
+	u32 l, h;
+
+	/* Thermal monitoring depends on ACPI and clock modulation*/
+	if (!cpu_has(c, X86_FEATURE_ACPI) || !cpu_has(c, X86_FEATURE_ACC))
+		return;
+
+	/*
+	 * First check if its enabled already, in which case there might
+	 * be some SMM goo which handles it, so we can't even put a handler
+	 * since it might be delivered via SMI already:
+	 */
+	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
+	h = apic_read(APIC_LVTTHMR);
+	if ((l & MSR_IA32_MISC_ENABLE_TM1) && (h & APIC_DM_SMI)) {
+		printk(KERN_DEBUG
+		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
+		return;
+	}
+
+	if (cpu_has(c, X86_FEATURE_TM2) && (l & MSR_IA32_MISC_ENABLE_TM2))
+		tm2 = 1;
+
+	/* Check whether a vector already exists */
+	if (h & APIC_VECTOR_MASK) {
+		printk(KERN_DEBUG
+		       "CPU%d: Thermal LVT vector (%#x) already installed\n",
+		       cpu, (h & APIC_VECTOR_MASK));
+		return;
+	}
+
+	/* We'll mask the thermal vector in the lapic till we're ready: */
+	h = THERMAL_APIC_VECTOR | APIC_DM_FIXED | APIC_LVT_MASKED;
+	apic_write(APIC_LVTTHMR, h);
+
+	rdmsr(MSR_IA32_THERM_INTERRUPT, l, h);
+	wrmsr(MSR_IA32_THERM_INTERRUPT,
+		l | (THERM_INT_LOW_ENABLE | THERM_INT_HIGH_ENABLE), h);
+
+	smp_thermal_vector = intel_thermal_interrupt;
+
+	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
+	wrmsr(MSR_IA32_MISC_ENABLE, l | MSR_IA32_MISC_ENABLE_TM1, h);
+
+	/* Unmask the thermal vector: */
+	l = apic_read(APIC_LVTTHMR);
+	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
+
+	printk(KERN_INFO "CPU%d: Thermal monitoring enabled (%s)\n",
+	       cpu, tm2 ? "TM2" : "TM1");
+
+	/* enable thermal throttle processing */
+	atomic_set(&therm_throt_en, 1);
+}
diff --git a/arch/x86/kernel/cpu/mcheck/winchip.c b/arch/x86/kernel/cpu/mcheck/winchip.c
index 81b0248..54060f5 100644
--- a/arch/x86/kernel/cpu/mcheck/winchip.c
+++ b/arch/x86/kernel/cpu/mcheck/winchip.c
@@ -9,10 +9,9 @@
 
 #include <asm/processor.h>
 #include <asm/system.h>
+#include <asm/mce.h>
 #include <asm/msr.h>
 
-#include "mce.h"
-
 /* Machine check handler for WinChip C6: */
 static void winchip_machine_check(struct pt_regs *regs, long error_code)
 {
diff --git a/arch/x86/kernel/cpu/perfctr-watchdog.c b/arch/x86/kernel/cpu/perfctr-watchdog.c
index d6f5b9f..5c481f6 100644
--- a/arch/x86/kernel/cpu/perfctr-watchdog.c
+++ b/arch/x86/kernel/cpu/perfctr-watchdog.c
@@ -716,11 +716,15 @@ static void probe_nmi_watchdog(void)
 		wd_ops = &k7_wd_ops;
 		break;
 	case X86_VENDOR_INTEL:
-		/*
-		 * Work around Core Duo (Yonah) errata AE49 where perfctr1
-		 * doesn't have a working enable bit.
+		/* Work around where perfctr1 doesn't have a working enable
+		 * bit as described in the following errata:
+		 * AE49 Core Duo and Intel Core Solo 65 nm
+		 * AN49 Intel Pentium Dual-Core
+		 * AF49 Dual-Core Intel Xeon Processor LV
 		 */
-		if (boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14) {
+		if ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 14) ||
+		    ((boot_cpu_data.x86 == 6 && boot_cpu_data.x86_model == 15 &&
+		     boot_cpu_data.x86_mask == 4))) {
 			intel_arch_wd_ops.perfctr = MSR_ARCH_PERFMON_PERFCTR0;
 			intel_arch_wd_ops.evntsel = MSR_ARCH_PERFMON_EVENTSEL0;
 		}
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index ff95824..5e409dc 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -27,6 +27,7 @@
 #include <asm/cpu.h>
 #include <asm/reboot.h>
 #include <asm/virtext.h>
+#include <asm/iommu.h>
 
 
 #if defined(CONFIG_SMP) && defined(CONFIG_X86_LOCAL_APIC)
@@ -103,5 +104,10 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 #ifdef CONFIG_HPET_TIMER
 	hpet_disable();
 #endif
+
+#ifdef CONFIG_X86_64
+	pci_iommu_shutdown();
+#endif
+
 	crash_save_cpu(regs, safe_smp_processor_id());
 }
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 1736acc..96f7ac0 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -240,10 +240,35 @@ static void __init do_add_efi_memmap(void)
 		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
 		int e820_type;
 
-		if (md->attribute & EFI_MEMORY_WB)
-			e820_type = E820_RAM;
-		else
+		switch (md->type) {
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+		case EFI_CONVENTIONAL_MEMORY:
+			if (md->attribute & EFI_MEMORY_WB)
+				e820_type = E820_RAM;
+			else
+				e820_type = E820_RESERVED;
+			break;
+		case EFI_ACPI_RECLAIM_MEMORY:
+			e820_type = E820_ACPI;
+			break;
+		case EFI_ACPI_MEMORY_NVS:
+			e820_type = E820_NVS;
+			break;
+		case EFI_UNUSABLE_MEMORY:
+			e820_type = E820_UNUSABLE;
+			break;
+		default:
+			/*
+			 * EFI_RESERVED_TYPE EFI_RUNTIME_SERVICES_CODE
+			 * EFI_RUNTIME_SERVICES_DATA EFI_MEMORY_MAPPED_IO
+			 * EFI_MEMORY_MAPPED_IO_PORT_SPACE EFI_PAL_CODE
+			 */
 			e820_type = E820_RESERVED;
+			break;
+		}
 		e820_add_region(start, size, e820_type);
 	}
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index c929add..9f8ce77 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -48,7 +48,6 @@
 #include <asm/segment.h>
 #include <asm/smp.h>
 #include <asm/page_types.h>
-#include <asm/desc.h>
 #include <asm/percpu.h>
 #include <asm/dwarf2.h>
 #include <asm/processor-flags.h>
@@ -84,7 +83,7 @@
 #define preempt_stop(clobbers)	DISABLE_INTERRUPTS(clobbers); TRACE_IRQS_OFF
 #else
 #define preempt_stop(clobbers)
-#define resume_kernel		restore_nocheck
+#define resume_kernel		restore_all
 #endif
 
 .macro TRACE_IRQS_IRET
@@ -372,7 +371,7 @@ END(ret_from_exception)
 ENTRY(resume_kernel)
 	DISABLE_INTERRUPTS(CLBR_ANY)
 	cmpl $0,TI_preempt_count(%ebp)	# non-zero preempt_count ?
-	jnz restore_nocheck
+	jnz restore_all
 need_resched:
 	movl TI_flags(%ebp), %ecx	# need_resched set ?
 	testb $_TIF_NEED_RESCHED, %cl
@@ -540,6 +539,8 @@ syscall_exit:
 	jne syscall_exit_work
 
 restore_all:
+	TRACE_IRQS_IRET
+restore_all_notrace:
 	movl PT_EFLAGS(%esp), %eax	# mix EFLAGS, SS and CS
 	# Warning: PT_OLDSS(%esp) contains the wrong/random values if we
 	# are returning to the kernel.
@@ -551,8 +552,6 @@ restore_all:
 	CFI_REMEMBER_STATE
 	je ldt_ss			# returning to user-space with LDT SS
 restore_nocheck:
-	TRACE_IRQS_IRET
-restore_nocheck_notrace:
 	RESTORE_REGS 4			# skip orig_eax/error_code
 	CFI_ADJUST_CFA_OFFSET -4
 irq_return:
@@ -588,22 +587,34 @@ ldt_ss:
 	jne restore_nocheck
 #endif
 
-	/* If returning to userspace with 16bit stack,
-	 * try to fix the higher word of ESP, as the CPU
-	 * won't restore it.
-	 * This is an "official" bug of all the x86-compatible
-	 * CPUs, which we can try to work around to make
-	 * dosemu and wine happy. */
-	movl PT_OLDESP(%esp), %eax
-	movl %esp, %edx
-	call patch_espfix_desc
+/*
+ * Setup and switch to ESPFIX stack
+ *
+ * We're returning to userspace with a 16 bit stack. The CPU will not
+ * restore the high word of ESP for us on executing iret... This is an
+ * "official" bug of all the x86-compatible CPUs, which we can work
+ * around to make dosemu and wine happy. We do this by preloading the
+ * high word of ESP with the high word of the userspace ESP while
+ * compensating for the offset by changing to the ESPFIX segment with
+ * a base address that matches for the difference.
+ */
+	mov %esp, %edx			/* load kernel esp */
+	mov PT_OLDESP(%esp), %eax	/* load userspace esp */
+	mov %dx, %ax			/* eax: new kernel esp */
+	sub %eax, %edx			/* offset (low word is 0) */
+	PER_CPU(gdt_page, %ebx)
+	shr $16, %edx
+	mov %dl, GDT_ENTRY_ESPFIX_SS * 8 + 4(%ebx) /* bits 16..23 */
+	mov %dh, GDT_ENTRY_ESPFIX_SS * 8 + 7(%ebx) /* bits 24..31 */
 	pushl $__ESPFIX_SS
 	CFI_ADJUST_CFA_OFFSET 4
-	pushl %eax
+	push %eax			/* new kernel esp */
 	CFI_ADJUST_CFA_OFFSET 4
+	/* Disable interrupts, but do not irqtrace this section: we
+	 * will soon execute iret and the tracer was already set to
+	 * the irqstate after the iret */
 	DISABLE_INTERRUPTS(CLBR_EAX)
-	TRACE_IRQS_OFF
-	lss (%esp), %esp
+	lss (%esp), %esp		/* switch to espfix segment */
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp restore_nocheck
 	CFI_ENDPROC
@@ -716,15 +727,24 @@ PTREGSCALL(vm86)
 PTREGSCALL(vm86old)
 
 .macro FIXUP_ESPFIX_STACK
-	/* since we are on a wrong stack, we cant make it a C code :( */
+/*
+ * Switch back for ESPFIX stack to the normal zerobased stack
+ *
+ * We can't call C functions using the ESPFIX stack. This code reads
+ * the high word of the segment base from the GDT and swiches to the
+ * normal stack and adjusts ESP with the matching offset.
+ */
+	/* fixup the stack */
 	PER_CPU(gdt_page, %ebx)
-	GET_DESC_BASE(GDT_ENTRY_ESPFIX_SS, %ebx, %eax, %ax, %al, %ah)
-	addl %esp, %eax
+	mov GDT_ENTRY_ESPFIX_SS * 8 + 4(%ebx), %al /* bits 16..23 */
+	mov GDT_ENTRY_ESPFIX_SS * 8 + 7(%ebx), %ah /* bits 24..31 */
+	shl $16, %eax
+	addl %esp, %eax			/* the adjusted stack pointer */
 	pushl $__KERNEL_DS
 	CFI_ADJUST_CFA_OFFSET 4
 	pushl %eax
 	CFI_ADJUST_CFA_OFFSET 4
-	lss (%esp), %esp
+	lss (%esp), %esp		/* switch to the normal stack segment */
 	CFI_ADJUST_CFA_OFFSET -8
 .endm
 .macro UNWIND_ESPFIX_STACK
@@ -1329,7 +1349,7 @@ nmi_stack_correct:
 	xorl %edx,%edx		# zero error code
 	movl %esp,%eax		# pt_regs pointer
 	call do_nmi
-	jmp restore_nocheck_notrace
+	jmp restore_all_notrace
 	CFI_ENDPROC
 
 nmi_stack_fixup:
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index dc5ed4b..8663afb 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -13,7 +13,6 @@
 #include <asm/segment.h>
 #include <asm/page_types.h>
 #include <asm/pgtable_types.h>
-#include <asm/desc.h>
 #include <asm/cache.h>
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 54b29bb..fa54f78 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -12,7 +12,6 @@
 #include <linux/linkage.h>
 #include <linux/threads.h>
 #include <linux/init.h>
-#include <asm/desc.h>
 #include <asm/segment.h>
 #include <asm/pgtable.h>
 #include <asm/page.h>
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 81408b9..dedc2bd 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -510,7 +510,8 @@ static int hpet_setup_irq(struct hpet_dev *dev)
 {
 
 	if (request_irq(dev->irq, hpet_interrupt_handler,
-			IRQF_DISABLED|IRQF_NOBALANCING, dev->name, dev))
+			IRQF_TIMER | IRQF_DISABLED | IRQF_NOBALANCING,
+			dev->name, dev))
 		return -1;
 
 	disable_irq(dev->irq);
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 745579b..328592f 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -290,6 +290,8 @@ static int __init pci_iommu_init(void)
 void pci_iommu_shutdown(void)
 {
 	gart_iommu_shutdown();
+
+	amd_iommu_shutdown();
 }
 /* Must execute after PCI subsystem */
 fs_initcall(pci_iommu_init);
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 1e1e27b..71f9c74 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -53,6 +53,7 @@
 #include <asm/traps.h>
 #include <asm/desc.h>
 #include <asm/i387.h>
+#include <asm/mce.h>
 
 #include <asm/mach_traps.h>
 
@@ -64,8 +65,6 @@
 #include <asm/setup.h>
 #include <asm/traps.h>
 
-#include "cpu/mcheck/mce.h"
-
 asmlinkage int system_call(void);
 
 /* Do we ignore FPU interrupts ? */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index c6acc63..0482fa6 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -951,11 +951,11 @@ do_page_fault(struct pt_regs *regs, unsigned long error_code)
 	tsk = current;
 	mm = tsk->mm;
 
-	prefetchw(&mm->mmap_sem);
-
 	/* Get the faulting address: */
 	address = read_cr2();
 
+	prefetchw(&mm->mmap_sem);
+
 	if (unlikely(kmmio_fault(regs, address)))
 		return;
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 52bb951..52e1bff 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -527,7 +527,7 @@ phys_pud_update(pgd_t *pgd, unsigned long addr, unsigned long end,
 	return phys_pud_init(pud, addr, end, page_size_mask);
 }
 
-unsigned long __init
+unsigned long __meminit
 kernel_physical_mapping_init(unsigned long start,
 			     unsigned long end,
 			     unsigned long page_size_mask)
