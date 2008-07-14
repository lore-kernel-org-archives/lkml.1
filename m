Return-Path: <linux-kernel-owner+w=401wt.eu-S1756533AbYGNP5F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533AbYGNP5F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 11:57:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755863AbYGNP4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 11:56:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770AbYGNP4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 11:56:49 -0400
Subject: [PATCH] x86-kernel: declare some functions before they get used
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
       kernelnewbies <kernelnewbies@nl.linux.org>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain
Date: Mon, 14 Jul 2008 21:26:04 +0530
Message-Id: <1216050964.2719.4.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 arch/x86/kernel/acpi/sleep.h              |    1 -
 arch/x86/kernel/e820_32.c                 |    1 +
 arch/x86/kernel/head32.c                  |    1 +
 arch/x86/kernel/ldt.c                     |    1 +
 arch/x86/kernel/mpparse.c                 |    2 -
 arch/x86/kernel/nmi_32.c                  |    2 -
 arch/x86/kernel/pci-dma.c                 |    1 +
 arch/x86/kernel/process_32.c              |    1 +
 arch/x86/kernel/setup_32.c                |    2 -
 arch/x86/kernel/signal_32.c               |    1 +
 arch/x86/kernel/time_32.c                 |    1 +
 arch/x86/kernel/tls.c                     |    1 +
 arch/x86/kernel/traps_32.c                |   20 -------
 arch/x86/kernel/traps_64.c                |   22 --------
 arch/x86/kernel/vm86_32.c                 |    1 +
 arch/x86/kernel/vsmp_64.c                 |    1 +
 arch/x86/mach-visws/mpparse.c             |    2 -
 arch/x86/mm/discontig_32.c                |    2 -
 include/asm-x86/apic.h                    |    9 +++
 include/asm-x86/current_32.h              |    2 +
 include/asm-x86/dma-mapping.h             |    1 +
 include/asm-x86/dma.h                     |    3 +-
 include/asm-x86/i387.h                    |    1 +
 include/asm-x86/io.h                      |    2 +
 include/asm-x86/io_64.h                   |    1 -
 include/asm-x86/io_apic.h                 |    2 +
 include/asm-x86/mach-default/mach_traps.h |   60 ++++++++++++++++++++
 include/asm-x86/mpspec.h                  |    4 +-
 include/asm-x86/nmi.h                     |   16 +++++-
 include/asm-x86/pci-direct.h              |    3 +
 include/asm-x86/processor.h               |    5 ++
 include/asm-x86/ptrace.h                  |    2 +
 include/asm-x86/setup.h                   |   11 ++++
 include/asm-x86/signal.h                  |    5 ++
 include/asm-x86/smp.h                     |    1 -
 include/asm-x86/syscalls.h                |   85 +++++++++++++++++++++++++++++
 include/asm-x86/time.h                    |    2 +
 include/asm-x86/timer.h                   |    5 ++-
 include/linux/syscalls.h                  |    4 ++
 include/linux/timer.h                     |    3 +
 40 files changed, 228 insertions(+), 62 deletions(-)
 create mode 100644 include/asm-x86/syscalls.h

diff --git a/arch/x86/kernel/acpi/sleep.h b/arch/x86/kernel/acpi/sleep.h
index adbcbaa..f3ee645 100644
--- a/arch/x86/kernel/acpi/sleep.h
+++ b/arch/x86/kernel/acpi/sleep.h
@@ -6,7 +6,6 @@
 
 extern char wakeup_code_start, wakeup_code_end;
 
-extern unsigned long saved_video_mode;
 extern long saved_magic;
 
 extern int wakeup_pmode_return;
diff --git a/arch/x86/kernel/e820_32.c b/arch/x86/kernel/e820_32.c
index ed733e7..fddc412 100644
--- a/arch/x86/kernel/e820_32.c
+++ b/arch/x86/kernel/e820_32.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/pfn.h>
+#include <linux/pci.h>
 #include <linux/uaccess.h>
 #include <linux/suspend.h>
 
diff --git a/arch/x86/kernel/head32.c b/arch/x86/kernel/head32.c
index 3db0590..76c002c 100644
--- a/arch/x86/kernel/head32.c
+++ b/arch/x86/kernel/head32.c
@@ -7,6 +7,7 @@
 
 #include <linux/init.h>
 #include <linux/start_kernel.h>
+#include <asm/setup.h>
 
 void __init i386_start_kernel(void)
 {
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 0224c36..40f0de5 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -12,6 +12,7 @@
 #include <linux/mm.h>
 #include <linux/smp.h>
 #include <linux/vmalloc.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 404683b..de02b64 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -805,8 +805,6 @@ int es7000_plat;
 
 #define MP_ISA_BUS		0
 
-extern struct mp_ioapic_routing mp_ioapic_routing[MAX_IO_APICS];
-
 static int mp_find_ioapic(int gsi)
 {
 	int i = 0;
diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index 84160f7..54e4ce6 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -314,8 +314,6 @@ void touch_nmi_watchdog(void)
 }
 EXPORT_SYMBOL(touch_nmi_watchdog);
 
-extern void die_nmi(struct pt_regs *, const char *msg);
-
 notrace __kprobes int
 nmi_watchdog_tick(struct pt_regs *regs, unsigned reason)
 {
diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index dc00a13..ea8baa9 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -2,6 +2,7 @@
 #include <linux/dmar.h>
 #include <linux/bootmem.h>
 #include <linux/pci.h>
+#include <linux/io.h>
 
 #include <asm/proto.h>
 #include <asm/dma.h>
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index e2db9ac..136fb73 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -37,6 +37,7 @@
 #include <linux/tick.h>
 #include <linux/percpu.h>
 #include <linux/prctl.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 5a2f8e0..cc3177d 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -196,7 +196,6 @@ struct ist_info ist_info;
 EXPORT_SYMBOL(ist_info);
 #endif
 
-extern void early_cpu_init(void);
 extern int root_mountflags;
 
 unsigned long saved_video_mode;
@@ -446,7 +445,6 @@ static void __init reserve_ebda_region(void)
 }
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
-static void __init setup_bootmem_allocator(void);
 static unsigned long __init setup_memory(void)
 {
 	/*
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d923736..954a3b8 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -20,6 +20,7 @@
 #include <linux/elf.h>
 #include <linux/smp.h>
 #include <linux/mm.h>
+#include <linux/syscalls.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
diff --git a/arch/x86/kernel/time_32.c b/arch/x86/kernel/time_32.c
index 2ff21f3..9a0b4ca 100644
--- a/arch/x86/kernel/time_32.c
+++ b/arch/x86/kernel/time_32.c
@@ -31,6 +31,7 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/time.h>
+#include <linux/timer.h>
 #include <linux/mca.h>
 
 #include <asm/arch_hooks.h>
diff --git a/arch/x86/kernel/tls.c b/arch/x86/kernel/tls.c
index ab6bf37..90bc24c 100644
--- a/arch/x86/kernel/tls.c
+++ b/arch/x86/kernel/tls.c
@@ -3,6 +3,7 @@
 #include <linux/sched.h>
 #include <linux/user.h>
 #include <linux/regset.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/desc.h>
diff --git a/arch/x86/kernel/traps_32.c b/arch/x86/kernel/traps_32.c
index 08d752d..3174a0f 100644
--- a/arch/x86/kernel/traps_32.c
+++ b/arch/x86/kernel/traps_32.c
@@ -78,26 +78,6 @@ char ignore_fpu_irq;
 gate_desc idt_table[256]
 	__attribute__((__section__(".data.idt"))) = { { { { 0, 0 } } }, };
 
-asmlinkage void divide_error(void);
-asmlinkage void debug(void);
-asmlinkage void nmi(void);
-asmlinkage void int3(void);
-asmlinkage void overflow(void);
-asmlinkage void bounds(void);
-asmlinkage void invalid_op(void);
-asmlinkage void device_not_available(void);
-asmlinkage void coprocessor_segment_overrun(void);
-asmlinkage void invalid_TSS(void);
-asmlinkage void segment_not_present(void);
-asmlinkage void stack_segment(void);
-asmlinkage void general_protection(void);
-asmlinkage void page_fault(void);
-asmlinkage void coprocessor_error(void);
-asmlinkage void simd_coprocessor_error(void);
-asmlinkage void alignment_check(void);
-asmlinkage void spurious_interrupt_bug(void);
-asmlinkage void machine_check(void);
-
 int kstack_depth_to_print = 24;
 static unsigned int code_bytes = 64;
 
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index adff76e..c06b526 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -54,28 +54,6 @@
 #include <asm/nmi.h>
 #include <asm/stacktrace.h>
 
-asmlinkage void divide_error(void);
-asmlinkage void debug(void);
-asmlinkage void nmi(void);
-asmlinkage void int3(void);
-asmlinkage void overflow(void);
-asmlinkage void bounds(void);
-asmlinkage void invalid_op(void);
-asmlinkage void device_not_available(void);
-asmlinkage void double_fault(void);
-asmlinkage void coprocessor_segment_overrun(void);
-asmlinkage void invalid_TSS(void);
-asmlinkage void segment_not_present(void);
-asmlinkage void stack_segment(void);
-asmlinkage void general_protection(void);
-asmlinkage void page_fault(void);
-asmlinkage void coprocessor_error(void);
-asmlinkage void simd_coprocessor_error(void);
-asmlinkage void reserved(void);
-asmlinkage void alignment_check(void);
-asmlinkage void machine_check(void);
-asmlinkage void spurious_interrupt_bug(void);
-
 static unsigned int code_bytes = 64;
 
 static inline void conditional_sti(struct pt_regs *regs)
diff --git a/arch/x86/kernel/vm86_32.c b/arch/x86/kernel/vm86_32.c
index 38f566f..d77e312 100644
--- a/arch/x86/kernel/vm86_32.c
+++ b/arch/x86/kernel/vm86_32.c
@@ -41,6 +41,7 @@
 #include <linux/ptrace.h>
 #include <linux/audit.h>
 #include <linux/stddef.h>
+#include <linux/syscalls.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index ba8c0b7..eeece6a 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -18,6 +18,7 @@
 #include <asm/pci-direct.h>
 #include <asm/io.h>
 #include <asm/paravirt.h>
+#include <mach_apicdef.h>
 
 #if defined CONFIG_PCI && defined CONFIG_PARAVIRT
 /*
diff --git a/arch/x86/mach-visws/mpparse.c b/arch/x86/mach-visws/mpparse.c
index 57484e9..86a3be8 100644
--- a/arch/x86/mach-visws/mpparse.c
+++ b/arch/x86/mach-visws/mpparse.c
@@ -13,8 +13,6 @@ int smp_found_config;
 
 int pic_mode;
 
-extern unsigned int __cpuinitdata maxcpus;
-
 /*
  * The Visual Workstation is Intel MP compliant in the hardware
  * sense, but it doesn't have a BIOS(-configuration table).
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index 914ccf9..c6d01a5 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -98,7 +98,6 @@ unsigned long node_memmap_size_bytes(int nid, unsigned long start_pfn,
 }
 #endif
 
-extern unsigned long find_max_low_pfn(void);
 extern void add_one_highpage_init(struct page *, int, int);
 extern unsigned long highend_pfn, highstart_pfn;
 
@@ -310,7 +309,6 @@ void __init remap_numa_kva(void)
 }
 #endif /* CONFIG_DISCONTIGMEM */
 
-extern void setup_bootmem_allocator(void);
 unsigned long __init setup_memory(void)
 {
 	int nid;
diff --git a/include/asm-x86/apic.h b/include/asm-x86/apic.h
index be9639a..fb7a6bd 100644
--- a/include/asm-x86/apic.h
+++ b/include/asm-x86/apic.h
@@ -125,8 +125,17 @@ extern void enable_NMI_through_LVT0(void);
  */
 #ifdef CONFIG_X86_64
 extern void early_init_lapic_mapping(void);
+extern asmlinkage void smp_spurious_interrupt(void);
+extern asmlinkage void smp_error_interrupt(void);
+#else
+extern void smp_spurious_interrupt(struct pt_regs *);
+extern void smp_error_interrupt(struct pt_regs *);
 #endif
 
+extern unsigned int maxcpus;
+extern void smp_apic_timer_interrupt(struct pt_regs *);
+extern int setup_profiling_timer(unsigned int);
+
 extern u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask);
 extern u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask);
 
diff --git a/include/asm-x86/current_32.h b/include/asm-x86/current_32.h
index 5af9bdb..e48a3ad 100644
--- a/include/asm-x86/current_32.h
+++ b/include/asm-x86/current_32.h
@@ -12,6 +12,8 @@ static __always_inline struct task_struct *get_current(void)
 	return x86_read_percpu(current_task);
 }
 
+DECLARE_PER_CPU(int, cpu_number);
+
 #define current get_current()
 
 #endif /* !(_I386_CURRENT_H) */
diff --git a/include/asm-x86/dma-mapping.h b/include/asm-x86/dma-mapping.h
index a1a4dc7..1c9fc36 100644
--- a/include/asm-x86/dma-mapping.h
+++ b/include/asm-x86/dma-mapping.h
@@ -58,6 +58,7 @@ struct dma_mapping_ops {
 };
 
 extern const struct dma_mapping_ops *dma_ops;
+extern const struct dma_mapping_ops nommu_dma_ops;
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
 {
diff --git a/include/asm-x86/dma.h b/include/asm-x86/dma.h
index ca1098a..3b75000 100644
--- a/include/asm-x86/dma.h
+++ b/include/asm-x86/dma.h
@@ -150,7 +150,8 @@
 
 #define DMA_AUTOINIT		0x10
 
-
+struct device;
+struct page *dma_alloc_pages(struct device *, gfp_t, unsigned);
 extern spinlock_t  dma_spin_lock;
 
 static inline unsigned long claim_dma_lock(void)
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 37672f7..4878989 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -24,6 +24,7 @@ extern void mxcsr_feature_mask_init(void);
 extern int init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
 extern void init_thread_xstate(void);
+extern int dump_fpu(struct pt_regs *, struct user_i387_struct *);
 
 extern user_regset_active_fn fpregs_active, xfpregs_active;
 extern user_regset_get_fn fpregs_get, xfpregs_get, fpregs_soft_get;
diff --git a/include/asm-x86/io.h b/include/asm-x86/io.h
index d5b11f6..7f79067 100644
--- a/include/asm-x86/io.h
+++ b/include/asm-x86/io.h
@@ -3,6 +3,8 @@
 
 #define ARCH_HAS_IOREMAP_WC
 
+extern int iommu_bio_merge;
+
 #ifdef CONFIG_X86_32
 # include "io_32.h"
 #else
diff --git a/include/asm-x86/io_64.h b/include/asm-x86/io_64.h
index 0930bed..d379199 100644
--- a/include/asm-x86/io_64.h
+++ b/include/asm-x86/io_64.h
@@ -304,7 +304,6 @@ void memset_io(volatile void __iomem *a, int b, size_t c);
 
 #define flush_write_buffers()
 
-extern int iommu_bio_merge;
 #define BIO_VMERGE_BOUNDARY iommu_bio_merge
 
 /*
diff --git a/include/asm-x86/io_apic.h b/include/asm-x86/io_apic.h
index d593e14..7f0ed6d 100644
--- a/include/asm-x86/io_apic.h
+++ b/include/asm-x86/io_apic.h
@@ -122,6 +122,8 @@ struct mp_ioapic_routing {
 /* I/O APIC entries */
 extern struct mpc_config_ioapic mp_ioapics[MAX_IO_APICS];
 
+extern struct mp_ioapic_routing mp_ioapic_routing[MAX_IO_APICS];
+
 /* # of MP IRQ source entries */
 extern int mp_irq_entries;
 
diff --git a/include/asm-x86/mach-default/mach_traps.h b/include/asm-x86/mach-default/mach_traps.h
index 2fe7705..23cd7e3 100644
--- a/include/asm-x86/mach-default/mach_traps.h
+++ b/include/asm-x86/mach-default/mach_traps.h
@@ -36,4 +36,64 @@ static inline void reassert_nmi(void)
 		unlock_cmos();
 }
 
+/* traps */
+
+/* Common in X86_32 and X86_64 */
+asmlinkage void divide_error(void);
+asmlinkage void debug(void);
+asmlinkage void nmi(void);
+asmlinkage void int3(void);
+asmlinkage void overflow(void);
+asmlinkage void bounds(void);
+asmlinkage void invalid_op(void);
+asmlinkage void device_not_available(void);
+asmlinkage void coprocessor_segment_overrun(void);
+asmlinkage void invalid_TSS(void);
+asmlinkage void segment_not_present(void);
+asmlinkage void stack_segment(void);
+asmlinkage void general_protection(void);
+asmlinkage void page_fault(void);
+asmlinkage void coprocessor_error(void);
+asmlinkage void simd_coprocessor_error(void);
+asmlinkage void alignment_check(void);
+asmlinkage void spurious_interrupt_bug(void);
+
+void do_divide_error(struct pt_regs *, long);
+void do_overflow(struct pt_regs *, long);
+void do_bounds(struct pt_regs *, long);
+void do_coprocessor_segment_overrun(struct pt_regs *, long);
+void do_invalid_TSS(struct pt_regs *, long);
+void do_segment_not_present(struct pt_regs *, long);
+void do_stack_segment(struct pt_regs *, long);
+void do_alignment_check(struct pt_regs *, long);
+void do_invalid_op(struct pt_regs *, long);
+void do_general_protection(struct pt_regs *, long);
+
+#ifdef CONFIG_X86_32
+
+asmlinkage void machine_check(void);
+
+void do_iret_error(struct pt_regs *, long);
+void do_int3(struct pt_regs *regs, long);
+void do_debug(struct pt_regs *, long);
+void math_error(void __user *);
+void do_coprocessor_error(struct pt_regs *, long);
+void do_simd_coprocessor_error(struct pt_regs *, long);
+void do_spurious_interrupt_bug(struct pt_regs *, long);
+unsigned long patch_espfix_desc(unsigned long , unsigned long);
+asmlinkage void math_emulate(long);
+
+#else /* CONFIG_X86_32 */
+
+asmlinkage void double_fault(void);
+asmlinkage void reserved(void);
+
+asmlinkage void do_int3(struct pt_regs *, long);
+asmlinkage void do_stack_segment(struct pt_regs *, long);
+asmlinkage void do_debug(struct pt_regs *, unsigned long);
+asmlinkage void do_coprocessor_error(struct pt_regs *);
+asmlinkage void do_simd_coprocessor_error(struct pt_regs *);
+asmlinkage void do_spurious_interrupt_bug(struct pt_regs *);
+
+#endif /* CONFIG_X86_32 */
 #endif /* !_MACH_TRAPS_H */
diff --git a/include/asm-x86/mpspec.h b/include/asm-x86/mpspec.h
index 57a991b..28b1529 100644
--- a/include/asm-x86/mpspec.h
+++ b/include/asm-x86/mpspec.h
@@ -21,11 +21,11 @@ extern int pic_mode;
 /* Each PCI slot may be a combo card with its own bus.  4 IRQ pins per slot. */
 #define MAX_IRQ_SOURCES (MAX_MP_BUSSES * 4)
 
+#endif
+
 extern void early_find_smp_config(void);
 extern void early_get_smp_config(void);
 
-#endif
-
 #if defined(CONFIG_MCA) || defined(CONFIG_EISA)
 extern int mp_bus_id_to_type[MAX_MP_BUSSES];
 #endif
diff --git a/include/asm-x86/nmi.h b/include/asm-x86/nmi.h
index 1e36302..7e729d7 100644
--- a/include/asm-x86/nmi.h
+++ b/include/asm-x86/nmi.h
@@ -36,13 +36,23 @@ static inline void unset_nmi_pm_callback(struct pm_dev *dev)
 
 #endif /* CONFIG_PM */
 
+/* Common in X86_64 and X86_32 */
+extern void do_nmi(struct pt_regs *, long);
+
 #ifdef CONFIG_X86_64
+
 extern void default_do_nmi(struct pt_regs *);
-extern void die_nmi(char *str, struct pt_regs *regs, int do_panic);
+extern void die_nmi(char *, struct pt_regs *, int);
 extern void nmi_watchdog_default(void);
-#else
+
+#else /* CONFIG_X86_64 */
+
+/* kernel/traps_32.c */
+extern void die_nmi(struct pt_regs *, const char *);
+
 #define nmi_watchdog_default() do {} while (0)
-#endif
+
+#endif /* CONFIG_X86_64 */
 
 extern int check_nmi_watchdog(void);
 extern int nmi_watchdog_enabled;
diff --git a/include/asm-x86/pci-direct.h b/include/asm-x86/pci-direct.h
index 5b21485..d741b8f 100644
--- a/include/asm-x86/pci-direct.h
+++ b/include/asm-x86/pci-direct.h
@@ -14,4 +14,7 @@ extern void write_pci_config_byte(u8 bus, u8 slot, u8 func, u8 offset, u8 val);
 
 extern int early_pci_allowed(void);
 
+/* vsmp */
+extern void vsmp_init(void);
+
 #endif
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 5591052..95124ff 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -128,6 +128,8 @@ struct cpuinfo_x86 {
 extern struct cpuinfo_x86	boot_cpu_data;
 extern struct cpuinfo_x86	new_cpu_data;
 
+extern const struct seq_operations cpuinfo_op;
+
 extern struct tss_struct	doublefault_tss;
 extern __u32			cleared_cpu_caps[NCAPINTS];
 
@@ -140,6 +142,9 @@ DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
 #define current_cpu_data	boot_cpu_data
 #endif
 
+extern void early_cpu_init(void);
+extern struct pt_regs *idle_regs(struct pt_regs *);
+
 static inline int hlt_works(int cpu)
 {
 #ifdef CONFIG_X86_32
diff --git a/include/asm-x86/ptrace.h b/include/asm-x86/ptrace.h
index 9f922b0..c99e58e 100644
--- a/include/asm-x86/ptrace.h
+++ b/include/asm-x86/ptrace.h
@@ -139,6 +139,8 @@ extern unsigned long profile_pc(struct pt_regs *regs);
 extern unsigned long
 convert_ip_to_linear(struct task_struct *child, struct pt_regs *regs);
 
+int do_syscall_trace(struct pt_regs *, int);
+
 #ifdef CONFIG_X86_32
 extern void send_sigtrap(struct task_struct *tsk, struct pt_regs *regs,
 			 int error_code);
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index fa6763a..5a00c5a 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -9,6 +9,17 @@
 void vsmp_init(void);
 
 char *machine_specific_memory_setup(void);
+
+extern unsigned long saved_video_mode;
+
+#ifdef CONFIG_X86_32
+extern int user_defined_memmap;
+extern unsigned long find_max_low_pfn(void);
+extern void setup_bootmem_allocator(void);
+#endif /* CONFIG_X86_32 */
+
+extern void i386_start_kernel(void);
+
 #ifndef CONFIG_PARAVIRT
 #define paravirt_post_allocator_init()	do {} while (0)
 #endif
diff --git a/include/asm-x86/signal.h b/include/asm-x86/signal.h
index f15186d..ffe59bb 100644
--- a/include/asm-x86/signal.h
+++ b/include/asm-x86/signal.h
@@ -140,6 +140,11 @@ struct sigaction {
 struct k_sigaction {
 	struct sigaction sa;
 };
+
+#ifdef CONFIG_X86_32
+void do_notify_resume(struct pt_regs *, void *, __u32);
+#endif /* CONFIG_X86_32 */
+
 # else /* __KERNEL__ */
 /* Here we must cater to libcs that poke about in kernel headers.  */
 
diff --git a/include/asm-x86/smp.h b/include/asm-x86/smp.h
index 1ebaa5c..7958087 100644
--- a/include/asm-x86/smp.h
+++ b/include/asm-x86/smp.h
@@ -138,7 +138,6 @@ extern unsigned disabled_cpus __cpuinitdata;
  * from the initial startup. We map APIC_BASE very early in page_setup(),
  * so this is correct in the x86 case.
  */
-DECLARE_PER_CPU(int, cpu_number);
 #define raw_smp_processor_id() (x86_read_percpu(cpu_number))
 extern int safe_smp_processor_id(void);
 
diff --git a/include/asm-x86/syscalls.h b/include/asm-x86/syscalls.h
new file mode 100644
index 0000000..7228f38
--- /dev/null
+++ b/include/asm-x86/syscalls.h
@@ -0,0 +1,85 @@
+#ifndef _ASM_X86_SYSCALLS_H
+#define _ASM_X86_SYSCALLS_H
+#ifdef __KERNEL__
+
+#include <linux/compiler.h>
+#include <linux/linkage.h>
+#include <linux/types.h>
+#include <linux/signal.h>
+
+/* Common in X86_32 and X86_64 */
+/* kernel/ioport.c */
+asmlinkage long sys_ioperm(unsigned long, unsigned long, int);
+
+/* X86_32 only */
+#ifdef CONFIG_X86_32
+/* kernel/process_32.c */
+asmlinkage int sys_fork(struct pt_regs);
+asmlinkage int sys_clone(struct pt_regs);
+asmlinkage int sys_vfork(struct pt_regs);
+asmlinkage int sys_execve(struct pt_regs);
+
+/* kernel/signal_32.c */
+asmlinkage int sys_sigsuspend(int, int, old_sigset_t);
+asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
+			     struct old_sigaction __user *);
+asmlinkage int sys_sigaltstack(unsigned long);
+asmlinkage unsigned long sys_sigreturn(unsigned long);
+asmlinkage int sys_rt_sigreturn(unsigned long);
+
+/* kernel/ioport.c */
+asmlinkage long sys_iopl(unsigned long);
+
+/* kernel/ldt.c */
+asmlinkage int sys_modify_ldt(int, void __user *, unsigned long);
+
+/* kernel/sys_i386_32.c */
+asmlinkage long sys_mmap2(unsigned long, unsigned long, unsigned long,
+			  unsigned long, unsigned long, unsigned long);
+struct mmap_arg_struct;
+asmlinkage int old_mmap(struct mmap_arg_struct __user *);
+struct sel_arg_struct;
+asmlinkage int old_select(struct sel_arg_struct __user *);
+asmlinkage int sys_ipc(uint, int, int, int, void __user *, long);
+struct old_utsname;
+asmlinkage int sys_uname(struct old_utsname __user *);
+struct oldold_utsname;
+asmlinkage int sys_olduname(struct oldold_utsname __user *);
+
+/* kernel/tls.c */
+asmlinkage int sys_set_thread_area(struct user_desc __user *);
+asmlinkage int sys_get_thread_area(struct user_desc __user *);
+
+/* kernel/vm86_32.c */
+asmlinkage int sys_vm86old(struct pt_regs);
+asmlinkage int sys_vm86(struct pt_regs);
+
+#else /* CONFIF_X86_32 */
+
+/* X86_64 only */
+/* kernel/process_64.c */
+asmlinkage long sys_fork(struct pt_regs *);
+asmlinkage long sys_clone(unsigned long, unsigned long,
+			  void __user *, void __user *,
+			  struct pt_regs *);
+asmlinkage long sys_vfork(struct pt_regs *);
+asmlinkage long sys_execve(char __user *, char __user * __user *,
+			   char __user * __user *,
+			   struct pt_regs *);
+
+/* kernel/ioport.c */
+asmlinkage long sys_iopl(unsigned int, struct pt_regs *);
+
+/* kernel/signal_64.c */
+asmlinkage long sys_sigaltstack(const stack_t __user *, stack_t __user *,
+				struct pt_regs *);
+asmlinkage long sys_rt_sigreturn(struct pt_regs *);
+
+/* kernel/sys_x86_64.c */
+asmlinkage long sys_mmap(unsigned long, unsigned long, unsigned long,
+			 unsigned long, unsigned long, unsigned long);
+asmlinkage long sys_uname(struct new_utsname __user *);
+
+#endif /* CONFIF_X86_32 */
+#endif /* __KERNEL__ */
+#endif /* _ASM_X86_SYSCALLS_H */
diff --git a/include/asm-x86/time.h b/include/asm-x86/time.h
index bce72d7..801e735 100644
--- a/include/asm-x86/time.h
+++ b/include/asm-x86/time.h
@@ -46,6 +46,8 @@ static inline int native_set_wallclock(unsigned long nowtime)
 
 #endif
 
+void time_init(void);
+
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
 #else /* !CONFIG_PARAVIRT */
diff --git a/include/asm-x86/timer.h b/include/asm-x86/timer.h
index 4f6fcb0..4351f7b 100644
--- a/include/asm-x86/timer.h
+++ b/include/asm-x86/timer.h
@@ -9,9 +9,12 @@
 unsigned long long native_sched_clock(void);
 unsigned long native_calculate_cpu_khz(void);
 
+#ifdef CONFIG_X86_32
 extern int timer_ack;
-extern int no_timer_check;
 extern int recalibrate_cpu_khz(void);
+#endif /* CONFIG_X86_32 */
+
+extern int no_timer_check;
 
 #ifndef CONFIG_PARAVIRT
 #define calculate_cpu_khz() native_calculate_cpu_khz()
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 0522f36..dfd6744 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -65,6 +65,10 @@ struct getcpu_cache;
 #include <linux/quota.h>
 #include <linux/key.h>
 
+#ifdef CONFIG_X86
+#include <asm/syscalls.h>
+#endif
+
 asmlinkage long sys_time(time_t __user *tloc);
 asmlinkage long sys_stime(time_t __user *tptr);
 asmlinkage long sys_gettimeofday(struct timeval __user *tv,
diff --git a/include/linux/timer.h b/include/linux/timer.h
index d4ba792..fad5b74 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -5,6 +5,9 @@
 #include <linux/ktime.h>
 #include <linux/stddef.h>
 #include <linux/debugobjects.h>
+#ifdef CONFIG_X86
+#include <asm/timer.h>
+#endif /* CONFIG_X86 */
 
 struct tvec_base;
 
-- 
1.5.5.1



