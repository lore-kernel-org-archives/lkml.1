Return-Path: <linux-kernel-owner+w=401wt.eu-S1762845AbYBSXNr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762845AbYBSXNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:13:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbYBSXNj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:13:39 -0500
Received: from www.tglx.de ([62.245.132.106]:40048 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756704AbYBSXNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:13:34 -0500
Date: Wed, 20 Feb 2008 00:13:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [GIT pull] x86 updates
Message-ID: <alpine.LFD.1.00.0802192357550.7583@apollo.tec.linutronix.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

please pull x86 updates from:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git master

The major part of this pull are sparse fixes, section fixups,
documentation updates and cleanups.

The bugfix part is:

    - fix the ioremap page_is_ram() protection
    - exclude vsyscall files from stackprotect
    - switch the iodelay back to 0x80 default
    - fix vdso_install breakage

The vdso_install breakage fix from Sam solves the same problem in

    arch/powerpc/Makefile

The patch came as bundle. Please let me know, if you want the powerpc
fix split out and merged via the powerpc tree.

Thanks,

	tglx
---
Adrian Bunk (5):
      remove mca-pentium
      x86: make mxcsr_feature_mask static again
      x86: unexport io_delay_type
      x86: don't make irq_return global
      x86: don't make swapper_pg_fixmap global

Ahmed S. Darwish (1):
      x86: i8259A: remove redundant irq_descinitialization

Andi Kleen (1):
      x86: CPA: remove BUG_ON for LRU/Compound pages

Arjan van de Ven (2):
      x86: fix WARN_ON() message: teach page_is_ram() about the special 4Kb bios data page
      x86: fix page_is_ram() thinko

Cyrill Gorcunov (3):
      x86 cleanup: suspend_asm_64.S - use X86_CR4_PGE instead of numeric value
      x86: lds - Use PAGE_SIZE instead of numeric constant
      x86: lds - Use THREAD_SIZE instead of numeric constant

H. Peter Anvin (1):
      x86: add pgd_large() on 64-bit, for consistency

Harvey Harrison (3):
      x86, kprobes: remove sparse warnings from x86
      x86: sparse error in efi_32.c
      x86: sparse warning in efi.c

Ingo Molnar (3):
      x86: exclude vsyscall files from stackprotect
      x86: clean up csum-wrappers_64.c some more
      x86: change IO delay back to 0x80

Li Zefan (1):
      x86: fix compile warning building without CONFIG_SYSCTL

Marcin Slusarz (1):
      x86: fix printout ugliness in cpu info printk

Mike Travis (1):
      x86: minor cleanup of comments in processor.h

Nick Andrew (1):
      x86: docs fixes to Documentation/i386/IO-APIC.txt

Paolo Ciarrocchi (2):
      x86: coding style fixes in arch/x86/lib/io_64.c
      x86: coding style fixes in arch/x86/lib/csum-wrappers_64.c

Sam Ravnborg (7):
      x86: fix section mismatch warning in setup_64.c:nearby_node
      x86: fix section mismatch in setup_64.c:srat_detect_node
      x86: fix section mismatch warning in topology.c:arch_register_cpu
      x86: fix section mismatch in srat_64.c:reserve_hotadd
      x86: fix section mismatch in head_64.S:initial_code
      x86: annotate pci/common.s:pci_scan_bus_with_sysdata with __devinit
      x86: fix vdso_install breaks user "make install"

 Documentation/i386/IO-APIC.txt      |   32 ++++----
 Documentation/kernel-parameters.txt |    2 -
 arch/powerpc/Makefile               |    2 +-
 arch/x86/Kconfig.debug              |    2 +-
 arch/x86/Makefile                   |    2 +-
 arch/x86/kernel/Makefile            |   10 ++-
 arch/x86/kernel/cpu/bugs.c          |    8 --
 arch/x86/kernel/efi.c               |    2 +-
 arch/x86/kernel/efi_32.c            |    1 +
 arch/x86/kernel/entry_32.S          |    2 +-
 arch/x86/kernel/entry_64.S          |    2 +-
 arch/x86/kernel/head_32.S           |    2 +-
 arch/x86/kernel/head_64.S           |    2 +-
 arch/x86/kernel/i387.c              |    2 +-
 arch/x86/kernel/i8259_32.c          |   25 ++-----
 arch/x86/kernel/io_delay.c          |    1 -
 arch/x86/kernel/kprobes.c           |    4 +-
 arch/x86/kernel/nmi_32.c            |   21 ++---
 arch/x86/kernel/nmi_64.c            |   21 ++---
 arch/x86/kernel/setup_32.c          |    1 -
 arch/x86/kernel/setup_64.c          |    6 +-
 arch/x86/kernel/topology.c          |    2 +-
 arch/x86/kernel/vmlinux_32.lds.S    |   26 +++---
 arch/x86/kernel/vmlinux_64.lds.S    |   30 ++++----
 arch/x86/lib/csum-wrappers_64.c     |  147 +++++++++++++++++++----------------
 arch/x86/lib/io_64.c                |   18 +++--
 arch/x86/mm/ioremap.c               |   24 ++++--
 arch/x86/mm/pageattr.c              |    5 -
 arch/x86/mm/srat_64.c               |    3 +-
 arch/x86/pci/common.c               |    2 +-
 arch/x86/power/hibernate_asm_64.S   |    5 +-
 include/asm-x86/i387.h              |    1 -
 include/asm-x86/pgtable_64.h        |    1 +
 include/asm-x86/processor.h         |    5 -
 34 files changed, 208 insertions(+), 211 deletions(-)
diff --git a/Documentation/i386/IO-APIC.txt b/Documentation/i386/IO-APIC.txt
index 435e69e..f951666 100644
--- a/Documentation/i386/IO-APIC.txt
+++ b/Documentation/i386/IO-APIC.txt
@@ -1,12 +1,14 @@
 Most (all) Intel-MP compliant SMP boards have the so-called 'IO-APIC',
-which is an enhanced interrupt controller, it enables us to route
-hardware interrupts to multiple CPUs, or to CPU groups.
+which is an enhanced interrupt controller. It enables us to route
+hardware interrupts to multiple CPUs, or to CPU groups. Without an
+IO-APIC, interrupts from hardware will be delivered only to the
+CPU which boots the operating system (usually CPU#0).
 
 Linux supports all variants of compliant SMP boards, including ones with
-multiple IO-APICs. (multiple IO-APICs are used in high-end servers to
-distribute IRQ load further).
+multiple IO-APICs. Multiple IO-APICs are used in high-end servers to
+distribute IRQ load further.
 
-There are (a few) known breakages in certain older boards, which bugs are
+There are (a few) known breakages in certain older boards, such bugs are
 usually worked around by the kernel. If your MP-compliant SMP board does
 not boot Linux, then consult the linux-smp mailing list archives first.
 
@@ -28,18 +30,18 @@ If your box boots fine with enabled IO-APIC IRQs, then your
   hell:~>
   <----------------------------
 
-some interrupts are still listed as 'XT PIC', but this is not a problem,
+Some interrupts are still listed as 'XT PIC', but this is not a problem;
 none of those IRQ sources is performance-critical.
 
 
-in the unlikely case that your board does not create a working mp-table,
+In the unlikely case that your board does not create a working mp-table,
 you can use the pirq= boot parameter to 'hand-construct' IRQ entries. This
-is nontrivial though and cannot be automated. One sample /etc/lilo.conf
+is non-trivial though and cannot be automated. One sample /etc/lilo.conf
 entry:
 
 	append="pirq=15,11,10"
 
-the actual numbers depend on your system, on your PCI cards and on their
+The actual numbers depend on your system, on your PCI cards and on their
 PCI slot position. Usually PCI slots are 'daisy chained' before they are
 connected to the PCI chipset IRQ routing facility (the incoming PIRQ1-4
 lines):
@@ -54,7 +56,7 @@ lines):
      PIRQ1 ----| |-  `----| |-  `----| |-  `----| |--------| |
                `-'        `-'        `-'        `-'        `-'
 
-every PCI card emits a PCI IRQ, which can be INTA,INTB,INTC,INTD:
+Every PCI card emits a PCI IRQ, which can be INTA, INTB, INTC or INTD:
 
                                ,-.
                          INTD--| |
@@ -95,21 +97,21 @@ card (IRQ11) in Slot3, and have Slot1 empty:
 [value '0' is a generic 'placeholder', reserved for empty (or non-IRQ emitting)
 slots.]
 
-generally, it's always possible to find out the correct pirq= settings, just
+Generally, it's always possible to find out the correct pirq= settings, just
 permute all IRQ numbers properly ... it will take some time though. An
 'incorrect' pirq line will cause the booting process to hang, or a device
-won't function properly (if it's inserted as eg. a module).
+won't function properly (e.g. if it's inserted as a module).
 
-If you have 2 PCI buses, then you can use up to 8 pirq values. Although such
+If you have 2 PCI buses, then you can use up to 8 pirq values, although such
 boards tend to have a good configuration.
 
 Be prepared that it might happen that you need some strange pirq line:
 
 	append="pirq=0,0,0,0,0,0,9,11"
 
-use smart try-and-err techniques to find out the correct pirq line ...
+Use smart trial-and-error techniques to find out the correct pirq line ...
 
-good luck and mail to linux-smp@vger.kernel.org or
+Good luck and mail to linux-smp@vger.kernel.org or
 linux-kernel@vger.kernel.org if you have any problems that are not covered
 by this document.
 
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a4fc7fc..7278295 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1056,8 +1056,6 @@ and is between 256 and 4096 characters. It is defined in the file
 			[SCSI] Maximum number of LUNs received.
 			Should be between 1 and 16384.
 
-	mca-pentium	[BUGS=X86-32]
-
 	mcatest=	[IA-64]
 
 	mce		[X86-32] Machine Check Exception
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 6845482..1c6ce35 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -176,7 +176,7 @@ define archhelp
   @echo '  *_defconfig     - Select default config from arch/$(ARCH)/configs'
 endef
 
-install: vdso_install
+install:
 	$(Q)$(MAKE) $(build)=$(boot) install
 
 vdso_install:
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 864affc..702eb39 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -156,7 +156,7 @@ config IO_DELAY_TYPE_NONE
 
 choice
 	prompt "IO delay type"
-	default IO_DELAY_0XED
+	default IO_DELAY_0X80
 
 config IO_DELAY_0X80
 	bool "port 0x80 based port-IO delay [recommended]"
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 204af43..f1e739a 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -229,7 +229,7 @@ zdisk bzdisk: vmlinux
 fdimage fdimage144 fdimage288 isoimage: vmlinux
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) $@
 
-install: vdso_install
+install:
 	$(Q)$(MAKE) $(build)=$(boot) BOOTIMAGE=$(KBUILD_IMAGE) install
 
 PHONY += vdso_install
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 76ec0f8..4eb5ce8 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -6,7 +6,15 @@ extra-y                := head_$(BITS).o init_task.o vmlinux.lds
 extra-$(CONFIG_X86_64) += head64.o
 
 CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
-CFLAGS_vsyscall_64.o := $(PROFILING) -g0
+
+#
+# vsyscalls (which work on the user stack) should have
+# no stack-protector checks:
+#
+nostackp := $(call cc-option, -fno-stack-protector)
+CFLAGS_vsyscall_64.o	:= $(PROFILING) -g0 $(nostackp)
+CFLAGS_hpet.o		:= $(nostackp)
+CFLAGS_tsc_64.o		:= $(nostackp)
 
 obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 9b95edc..027e5c0 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -25,14 +25,6 @@ static int __init no_halt(char *s)
 
 __setup("no-hlt", no_halt);
 
-static int __init mca_pentium(char *s)
-{
-	mca_pentium_flag = 1;
-	return 1;
-}
-
-__setup("mca-pentium", mca_pentium);
-
 static int __init no_387(char *s)
 {
 	boot_cpu_data.hard_math = 0;
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index 0c0eeb1..759e02b 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL(efi);
 
 struct efi_memory_map memmap;
 
-struct efi efi_phys __initdata;
+static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
 static int __init setup_noefi(char *arg)
diff --git a/arch/x86/kernel/efi_32.c b/arch/x86/kernel/efi_32.c
index cb91f98..5d23d85 100644
--- a/arch/x86/kernel/efi_32.c
+++ b/arch/x86/kernel/efi_32.c
@@ -28,6 +28,7 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
+#include <asm/efi.h>
 
 /*
  * To make EFI call EFI runtime service in physical addressing mode we need
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 824e21b..4b87c32 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -409,7 +409,7 @@ restore_nocheck_notrace:
 	RESTORE_REGS
 	addl $4, %esp			# skip orig_eax/error_code
 	CFI_ADJUST_CFA_OFFSET -4
-ENTRY(irq_return)
+irq_return:
 	INTERRUPT_RETURN
 .section .fixup,"ax"
 iret_exc:
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 6be39a3..2ad9a1b 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -583,7 +583,7 @@ retint_restore_args:	/* return to kernel space */
 restore_args:
 	RESTORE_ARGS 0,8,0
 
-ENTRY(irq_return)
+irq_return:
 	INTERRUPT_RETURN
 
 	.section __ex_table, "a"
diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 74ef4a4..25eb985 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -612,7 +612,7 @@ ENTRY(swapper_pg_pmd)
 ENTRY(swapper_pg_dir)
 	.fill 1024,4,0
 #endif
-ENTRY(swapper_pg_fixmap)
+swapper_pg_fixmap:
 	.fill 1024,4,0
 ENTRY(empty_zero_page)
 	.fill 4096,1,0
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 53e5820..eb41504 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -255,7 +255,7 @@ ENTRY(secondary_startup_64)
 	lretq
 
 	/* SMP bootup changes these two */
-	__CPUINITDATA
+	__REFDATA
 	.align	8
 	ENTRY(initial_code)
 	.quad	x86_64_start_kernel
diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
index 26719bd..763dfc4 100644
--- a/arch/x86/kernel/i387.c
+++ b/arch/x86/kernel/i387.c
@@ -39,7 +39,7 @@
 #define HAVE_HWFP 1
 #endif
 
-unsigned int mxcsr_feature_mask __read_mostly = 0xffffffffu;
+static unsigned int mxcsr_feature_mask __read_mostly = 0xffffffffu;
 
 void mxcsr_feature_mask_init(void)
 {
diff --git a/arch/x86/kernel/i8259_32.c b/arch/x86/kernel/i8259_32.c
index 2d25b77..fe63196 100644
--- a/arch/x86/kernel/i8259_32.c
+++ b/arch/x86/kernel/i8259_32.c
@@ -26,8 +26,6 @@
  * present in the majority of PC/AT boxes.
  * plus some generic x86 specific things if generic specifics makes
  * any sense at all.
- * this file should become arch/i386/kernel/irq.c when the old irq.c
- * moves to arch independent land
  */
 
 static int i8259A_auto_eoi;
@@ -362,23 +360,12 @@ void __init init_ISA_irqs (void)
 #endif
 	init_8259A(0);
 
-	for (i = 0; i < NR_IRQS; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = NULL;
-		irq_desc[i].depth = 1;
-
-		if (i < 16) {
-			/*
-			 * 16 old-style INTA-cycle interrupts:
-			 */
-			set_irq_chip_and_handler_name(i, &i8259A_chip,
-						      handle_level_irq, "XT");
-		} else {
-			/*
-			 * 'high' PCI IRQs filled in on demand
-			 */
-			irq_desc[i].chip = &no_irq_chip;
-		}
+	/*
+	 * 16 old-style INTA-cycle interrupts:
+	 */
+	for (i = 0; i < 16; i++) {
+		set_irq_chip_and_handler_name(i, &i8259A_chip,
+					      handle_level_irq, "XT");
 	}
 }
 
diff --git a/arch/x86/kernel/io_delay.c b/arch/x86/kernel/io_delay.c
index bd49321..c706a30 100644
--- a/arch/x86/kernel/io_delay.c
+++ b/arch/x86/kernel/io_delay.c
@@ -13,7 +13,6 @@
 #include <asm/io.h>
 
 int io_delay_type __read_mostly = CONFIG_DEFAULT_IO_DELAY_TYPE;
-EXPORT_SYMBOL_GPL(io_delay_type);
 
 static int __initdata io_delay_override;
 
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index a99e764..34a5912 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -581,7 +581,7 @@ static int __kprobes kprobe_handler(struct pt_regs *regs)
  * When a retprobed function returns, this code saves registers and
  * calls trampoline_handler() runs, which calls the kretprobe's handler.
  */
-void __kprobes kretprobe_trampoline_holder(void)
+static void __used __kprobes kretprobe_trampoline_holder(void)
 {
 	asm volatile (
 			".global kretprobe_trampoline\n"
@@ -673,7 +673,7 @@ void __kprobes kretprobe_trampoline_holder(void)
 /*
  * Called from kretprobe_trampoline
  */
-void * __kprobes trampoline_handler(struct pt_regs *regs)
+static __used __kprobes void *trampoline_handler(struct pt_regs *regs)
 {
 	struct kretprobe_instance *ri = NULL;
 	struct hlist_head *head, empty_rp;
diff --git a/arch/x86/kernel/nmi_32.c b/arch/x86/kernel/nmi_32.c
index edd4136..6a0aa70 100644
--- a/arch/x86/kernel/nmi_32.c
+++ b/arch/x86/kernel/nmi_32.c
@@ -46,9 +46,6 @@ static unsigned int nmi_hz = HZ;
 
 static DEFINE_PER_CPU(short, wd_enabled);
 
-/* local prototypes */
-static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
-
 static int endflag __initdata = 0;
 
 #ifdef CONFIG_SMP
@@ -391,15 +388,6 @@ __kprobes int nmi_watchdog_tick(struct pt_regs * regs, unsigned reason)
 	return rc;
 }
 
-int do_nmi_callback(struct pt_regs * regs, int cpu)
-{
-#ifdef CONFIG_SYSCTL
-	if (unknown_nmi_panic)
-		return unknown_nmi_panic_callback(regs, cpu);
-#endif
-	return 0;
-}
-
 #ifdef CONFIG_SYSCTL
 
 static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu)
@@ -453,6 +441,15 @@ int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
 
 #endif
 
+int do_nmi_callback(struct pt_regs *regs, int cpu)
+{
+#ifdef CONFIG_SYSCTL
+	if (unknown_nmi_panic)
+		return unknown_nmi_panic_callback(regs, cpu);
+#endif
+	return 0;
+}
+
 void __trigger_all_cpu_backtrace(void)
 {
 	int i;
diff --git a/arch/x86/kernel/nmi_64.c b/arch/x86/kernel/nmi_64.c
index fb99484..9a4fde7 100644
--- a/arch/x86/kernel/nmi_64.c
+++ b/arch/x86/kernel/nmi_64.c
@@ -46,9 +46,6 @@ static unsigned int nmi_hz = HZ;
 
 static DEFINE_PER_CPU(short, wd_enabled);
 
-/* local prototypes */
-static int unknown_nmi_panic_callback(struct pt_regs *regs, int cpu);
-
 /* Run after command line and cpu_init init, but before all other checks */
 void nmi_watchdog_default(void)
 {
@@ -394,15 +391,6 @@ asmlinkage __kprobes void do_nmi(struct pt_regs * regs, long error_code)
 	nmi_exit();
 }
 
-int do_nmi_callback(struct pt_regs * regs, int cpu)
-{
-#ifdef CONFIG_SYSCTL
-	if (unknown_nmi_panic)
-		return unknown_nmi_panic_callback(regs, cpu);
-#endif
-	return 0;
-}
-
 void stop_nmi(void)
 {
 	acpi_nmi_disable();
@@ -464,6 +452,15 @@ int proc_nmi_enabled(struct ctl_table *table, int write, struct file *file,
 
 #endif
 
+int do_nmi_callback(struct pt_regs *regs, int cpu)
+{
+#ifdef CONFIG_SYSCTL
+	if (unknown_nmi_panic)
+		return unknown_nmi_panic_callback(regs, cpu);
+#endif
+	return 0;
+}
+
 void __trigger_all_cpu_backtrace(void)
 {
 	int i;
diff --git a/arch/x86/kernel/setup_32.c b/arch/x86/kernel/setup_32.c
index 691ab4c..a1d7071 100644
--- a/arch/x86/kernel/setup_32.c
+++ b/arch/x86/kernel/setup_32.c
@@ -164,7 +164,6 @@ unsigned long mmu_cr4_features = X86_CR4_PAE;
 unsigned int machine_id;
 unsigned int machine_submodel_id;
 unsigned int BIOS_revision;
-unsigned int mca_pentium_flag;
 
 /* Boot loader ID as an integer, for the benefit of proc_dointvec */
 int bootloader_type;
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index c0d8208..6fd804f 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -518,7 +518,7 @@ static void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 }
 
 #ifdef CONFIG_NUMA
-static int nearby_node(int apicid)
+static int __cpuinit nearby_node(int apicid)
 {
 	int i, node;
 
@@ -791,7 +791,7 @@ static int __cpuinit intel_num_cpu_cores(struct cpuinfo_x86 *c)
 		return 1;
 }
 
-static void srat_detect_node(void)
+static void __cpuinit srat_detect_node(void)
 {
 #ifdef CONFIG_NUMA
 	unsigned node;
@@ -1046,7 +1046,7 @@ __setup("noclflush", setup_noclflush);
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
 	if (c->x86_model_id[0])
-		printk(KERN_INFO "%s", c->x86_model_id);
+		printk(KERN_CONT "%s", c->x86_model_id);
 
 	if (c->x86_mask || c->cpuid_level >= 0)
 		printk(KERN_CONT " stepping %02x\n", c->x86_mask);
diff --git a/arch/x86/kernel/topology.c b/arch/x86/kernel/topology.c
index a40051b..0fcc95a 100644
--- a/arch/x86/kernel/topology.c
+++ b/arch/x86/kernel/topology.c
@@ -34,7 +34,7 @@
 static DEFINE_PER_CPU(struct x86_cpu, cpu_devices);
 
 #ifdef CONFIG_HOTPLUG_CPU
-int arch_register_cpu(int num)
+int __ref arch_register_cpu(int num)
 {
 	/*
 	 * CPU0 cannot be offlined due to several
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index f1148ac..2ffa965 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -38,7 +38,7 @@ SECTIONS
 
   /* read-only */
   .text : AT(ADDR(.text) - LOAD_OFFSET) {
-	. = ALIGN(4096); /* not really needed, already page aligned */
+	. = ALIGN(PAGE_SIZE); /* not really needed, already page aligned */
 	*(.text.page_aligned)
 	TEXT_TEXT
 	SCHED_TEXT
@@ -70,21 +70,21 @@ SECTIONS
   RODATA
 
   /* writeable */
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data : AT(ADDR(.data) - LOAD_OFFSET) {	/* Data */
 	DATA_DATA
 	CONSTRUCTORS
 	} :data
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
   	__nosave_begin = .;
 	*(.data.nosave)
-  	. = ALIGN(4096);
+  	. = ALIGN(PAGE_SIZE);
   	__nosave_end = .;
   }
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
 	*(.data.page_aligned)
 	*(.data.idt)
@@ -108,7 +108,7 @@ SECTIONS
   }
 
   /* might get freed after init */
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
   	__smp_locks = .;
 	*(.smp_locks)
@@ -120,10 +120,10 @@ SECTIONS
    * after boot. Always make sure that ALIGN() directive is present after
    * the section which contains __smp_alt_end.
    */
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
 
   /* will be freed after init */
-  . = ALIGN(4096);		/* Init code and data */
+  . = ALIGN(PAGE_SIZE);		/* Init code and data */
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
   	__init_begin = .;
 	_sinittext = .;
@@ -174,23 +174,23 @@ SECTIONS
 	EXIT_DATA
   }
 #if defined(CONFIG_BLK_DEV_INITRD)
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
 	__initramfs_start = .;
 	*(.init.ramfs)
 	__initramfs_end = .;
   }
 #endif
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data.percpu  : AT(ADDR(.data.percpu) - LOAD_OFFSET) {
 	__per_cpu_start = .;
 	*(.data.percpu)
 	*(.data.percpu.shared_aligned)
 	__per_cpu_end = .;
   }
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   /* freed after init ends here */
-	
+
   .bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 	__init_end = .;
 	__bss_start = .;		/* BSS */
@@ -200,7 +200,7 @@ SECTIONS
 	__bss_stop = .;
   	_end = . ;
 	/* This is where the kernel creates the early boot page tables */
-	. = ALIGN(4096);
+	. = ALIGN(PAGE_SIZE);
 	pg0 = . ;
   }
 
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 0992b99..fab1322 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -37,7 +37,7 @@ SECTIONS
 	KPROBES_TEXT
 	*(.fixup)
 	*(.gnu.warning)
-	_etext = .;			/* End of text section */
+	_etext = .;		/* End of text section */
   } :text = 0x9090
 
   . = ALIGN(16);		/* Exception table */
@@ -60,7 +60,7 @@ SECTIONS
   	__tracedata_end = .;
   }
 
-  . = ALIGN(PAGE_SIZE);        /* Align data segment to page size boundary */
+  . = ALIGN(PAGE_SIZE);		/* Align data segment to page size boundary */
 				/* Data */
   .data : AT(ADDR(.data) - LOAD_OFFSET) {
 	DATA_DATA
@@ -119,7 +119,7 @@ SECTIONS
   .vsyscall_3 ADDR(.vsyscall_0) + 3072: AT(VLOAD(.vsyscall_3))
 		{ *(.vsyscall_3) }
 
-  . = VSYSCALL_VIRT_ADDR + 4096;
+  . = VSYSCALL_VIRT_ADDR + PAGE_SIZE;
 
 #undef VSYSCALL_ADDR
 #undef VSYSCALL_PHYS_ADDR
@@ -129,28 +129,28 @@ SECTIONS
 #undef VVIRT_OFFSET
 #undef VVIRT
 
-  . = ALIGN(8192);		/* init_task */
+  . = ALIGN(THREAD_SIZE);	/* init_task */
   .data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
 	*(.data.init_task)
   }:data.init
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   .data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
 	*(.data.page_aligned)
   }
 
   /* might get freed after init */
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __smp_alt_begin = .;
   __smp_locks = .;
   .smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
 	*(.smp_locks)
   }
   __smp_locks_end = .;
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __smp_alt_end = .;
 
-  . = ALIGN(4096);		/* Init code and data */
+  . = ALIGN(PAGE_SIZE);		/* Init code and data */
   __init_begin = .;
   .init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 	_sinittext = .;
@@ -191,7 +191,7 @@ SECTIONS
   .altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
 	*(.altinstructions)
   }
-  __alt_instructions_end = .; 
+  __alt_instructions_end = .;
   .altinstr_replacement : AT(ADDR(.altinstr_replacement) - LOAD_OFFSET) {
 	*(.altinstr_replacement)
   }
@@ -207,25 +207,25 @@ SECTIONS
 /* vdso blob that is mapped into user space */
   vdso_start = . ;
   .vdso  : AT(ADDR(.vdso) - LOAD_OFFSET) { *(.vdso) }
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   vdso_end = .;
 
 #ifdef CONFIG_BLK_DEV_INITRD
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __initramfs_start = .;
   .init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) { *(.init.ramfs) }
   __initramfs_end = .;
 #endif
 
-  PERCPU(4096)
+  PERCPU(PAGE_SIZE)
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __init_end = .;
 
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __nosave_begin = .;
   .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) { *(.data.nosave) }
-  . = ALIGN(4096);
+  . = ALIGN(PAGE_SIZE);
   __nosave_end = .;
 
   __bss_start = .;		/* BSS */
diff --git a/arch/x86/lib/csum-wrappers_64.c b/arch/x86/lib/csum-wrappers_64.c
index fd42a4a..459b58a 100644
--- a/arch/x86/lib/csum-wrappers_64.c
+++ b/arch/x86/lib/csum-wrappers_64.c
@@ -1,117 +1,129 @@
-/* Copyright 2002,2003 Andi Kleen, SuSE Labs.
+/*
+ * Copyright 2002, 2003 Andi Kleen, SuSE Labs.
  * Subject to the GNU Public License v.2
- * 
+ *
  * Wrappers of assembly checksum functions for x86-64.
  */
-
 #include <asm/checksum.h>
 #include <linux/module.h>
 
-/** 
- * csum_partial_copy_from_user - Copy and checksum from user space. 
- * @src: source address (user space) 
+/**
+ * csum_partial_copy_from_user - Copy and checksum from user space.
+ * @src: source address (user space)
  * @dst: destination address
  * @len: number of bytes to be copied.
  * @isum: initial sum that is added into the result (32bit unfolded)
  * @errp: set to -EFAULT for an bad source address.
- * 
+ *
  * Returns an 32bit unfolded checksum of the buffer.
- * src and dst are best aligned to 64bits. 
- */ 
+ * src and dst are best aligned to 64bits.
+ */
 __wsum
 csum_partial_copy_from_user(const void __user *src, void *dst,
 			    int len, __wsum isum, int *errp)
-{ 
+{
 	might_sleep();
 	*errp = 0;
-	if (likely(access_ok(VERIFY_READ,src, len))) { 
-		/* Why 6, not 7? To handle odd addresses aligned we
-		   would need to do considerable complications to fix the
-		   checksum which is defined as an 16bit accumulator. The
-		   fix alignment code is primarily for performance
-		   compatibility with 32bit and that will handle odd
-		   addresses slowly too. */
-		if (unlikely((unsigned long)src & 6)) {			
-			while (((unsigned long)src & 6) && len >= 2) { 
-				__u16 val16;			
-				*errp = __get_user(val16, (const __u16 __user *)src);
-				if (*errp)
-					return isum;
-				*(__u16 *)dst = val16;
-				isum = (__force __wsum)add32_with_carry(
-						(__force unsigned)isum, val16);
-				src += 2; 
-				dst += 2; 
-				len -= 2;
-			}
+
+	if (!likely(access_ok(VERIFY_READ, src, len)))
+		goto out_err;
+
+	/*
+	 * Why 6, not 7? To handle odd addresses aligned we
+	 * would need to do considerable complications to fix the
+	 * checksum which is defined as an 16bit accumulator. The
+	 * fix alignment code is primarily for performance
+	 * compatibility with 32bit and that will handle odd
+	 * addresses slowly too.
+	 */
+	if (unlikely((unsigned long)src & 6)) {
+		while (((unsigned long)src & 6) && len >= 2) {
+			__u16 val16;
+
+			*errp = __get_user(val16, (const __u16 __user *)src);
+			if (*errp)
+				return isum;
+
+			*(__u16 *)dst = val16;
+			isum = (__force __wsum)add32_with_carry(
+					(__force unsigned)isum, val16);
+			src += 2;
+			dst += 2;
+			len -= 2;
 		}
-		isum = csum_partial_copy_generic((__force const void *)src,
-					dst, len, isum, errp, NULL);
-		if (likely(*errp == 0)) 
-			return isum;
-	} 
+	}
+	isum = csum_partial_copy_generic((__force const void *)src,
+				dst, len, isum, errp, NULL);
+	if (unlikely(*errp))
+		goto out_err;
+
+	return isum;
+
+out_err:
 	*errp = -EFAULT;
-	memset(dst,0,len); 
-	return isum;		
-} 
+	memset(dst, 0, len);
 
+	return isum;
+}
 EXPORT_SYMBOL(csum_partial_copy_from_user);
 
-/** 
- * csum_partial_copy_to_user - Copy and checksum to user space. 
+/**
+ * csum_partial_copy_to_user - Copy and checksum to user space.
  * @src: source address
  * @dst: destination address (user space)
  * @len: number of bytes to be copied.
  * @isum: initial sum that is added into the result (32bit unfolded)
  * @errp: set to -EFAULT for an bad destination address.
- * 
+ *
  * Returns an 32bit unfolded checksum of the buffer.
  * src and dst are best aligned to 64bits.
- */ 
+ */
 __wsum
 csum_partial_copy_to_user(const void *src, void __user *dst,
 			  int len, __wsum isum, int *errp)
-{ 
+{
 	might_sleep();
+
 	if (unlikely(!access_ok(VERIFY_WRITE, dst, len))) {
 		*errp = -EFAULT;
-		return 0; 
+		return 0;
 	}
 
 	if (unlikely((unsigned long)dst & 6)) {
-		while (((unsigned long)dst & 6) && len >= 2) { 
+		while (((unsigned long)dst & 6) && len >= 2) {
 			__u16 val16 = *(__u16 *)src;
+
 			isum = (__force __wsum)add32_with_carry(
 					(__force unsigned)isum, val16);
 			*errp = __put_user(val16, (__u16 __user *)dst);
 			if (*errp)
 				return isum;
-			src += 2; 
-			dst += 2; 
+			src += 2;
+			dst += 2;
 			len -= 2;
 		}
 	}
 
 	*errp = 0;
-	return csum_partial_copy_generic(src, (void __force *)dst,len,isum,NULL,errp); 
-} 
-
+	return csum_partial_copy_generic(src, (void __force *)dst,
+					 len, isum, NULL, errp);
+}
 EXPORT_SYMBOL(csum_partial_copy_to_user);
 
-/** 
+/**
  * csum_partial_copy_nocheck - Copy and checksum.
  * @src: source address
  * @dst: destination address
  * @len: number of bytes to be copied.
  * @isum: initial sum that is added into the result (32bit unfolded)
- * 
+ *
  * Returns an 32bit unfolded checksum of the buffer.
- */ 
+ */
 __wsum
 csum_partial_copy_nocheck(const void *src, void *dst, int len, __wsum sum)
-{ 
-	return csum_partial_copy_generic(src,dst,len,sum,NULL,NULL);
-} 
+{
+	return csum_partial_copy_generic(src, dst, len, sum, NULL, NULL);
+}
 EXPORT_SYMBOL(csum_partial_copy_nocheck);
 
 __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
@@ -119,17 +131,20 @@ __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 			__u32 len, unsigned short proto, __wsum sum)
 {
 	__u64 rest, sum64;
-     
+
 	rest = (__force __u64)htonl(len) + (__force __u64)htons(proto) +
 		(__force __u64)sum;
-	asm("  addq (%[saddr]),%[sum]\n"
-	    "  adcq 8(%[saddr]),%[sum]\n"
-	    "  adcq (%[daddr]),%[sum]\n" 
-	    "  adcq 8(%[daddr]),%[sum]\n"
-	    "  adcq $0,%[sum]\n"
-	    : [sum] "=r" (sum64) 
-	    : "[sum]" (rest),[saddr] "r" (saddr), [daddr] "r" (daddr));
-	return csum_fold((__force __wsum)add32_with_carry(sum64 & 0xffffffff, sum64>>32));
-}
 
+	asm("	addq (%[saddr]),%[sum]\n"
+	    "	adcq 8(%[saddr]),%[sum]\n"
+	    "	adcq (%[daddr]),%[sum]\n"
+	    "	adcq 8(%[daddr]),%[sum]\n"
+	    "	adcq $0,%[sum]\n"
+
+	    : [sum] "=r" (sum64)
+	    : "[sum]" (rest), [saddr] "r" (saddr), [daddr] "r" (daddr));
+
+	return csum_fold(
+	       (__force __wsum)add32_with_carry(sum64 & 0xffffffff, sum64>>32));
+}
 EXPORT_SYMBOL(csum_ipv6_magic);
diff --git a/arch/x86/lib/io_64.c b/arch/x86/lib/io_64.c
index 87b4a4e..3f1eb59 100644
--- a/arch/x86/lib/io_64.c
+++ b/arch/x86/lib/io_64.c
@@ -1,23 +1,25 @@
 #include <linux/string.h>
-#include <asm/io.h>
 #include <linux/module.h>
+#include <asm/io.h>
 
-void __memcpy_toio(unsigned long dst,const void*src,unsigned len)
+void __memcpy_toio(unsigned long dst, const void *src, unsigned len)
 {
-	__inline_memcpy((void *) dst,src,len);
+	__inline_memcpy((void *)dst, src, len);
 }
 EXPORT_SYMBOL(__memcpy_toio);
 
-void __memcpy_fromio(void *dst,unsigned long src,unsigned len)
+void __memcpy_fromio(void *dst, unsigned long src, unsigned len)
 {
-	__inline_memcpy(dst,(const void *) src,len);
+	__inline_memcpy(dst, (const void *)src, len);
 }
 EXPORT_SYMBOL(__memcpy_fromio);
 
 void memset_io(volatile void __iomem *a, int b, size_t c)
 {
-	/* XXX: memset can mangle the IO patterns quite a bit.
-	   perhaps it would be better to use a dumb one */
-	memset((void *)a,b,c);
+	/*
+	 * TODO: memset can mangle the IO patterns quite a bit.
+	 * perhaps it would be better to use a dumb one:
+	 */
+	memset((void *)a, b, c);
 }
 EXPORT_SYMBOL(memset_io);
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 9f42d7e..f4c95ae 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -42,6 +42,22 @@ int page_is_ram(unsigned long pagenr)
 	unsigned long addr, end;
 	int i;
 
+	/*
+	 * A special case is the first 4Kb of memory;
+	 * This is a BIOS owned area, not kernel ram, but generally
+	 * not listed as such in the E820 table.
+	 */
+	if (pagenr == 0)
+		return 0;
+
+	/*
+	 * Second special case: Some BIOSen report the PC BIOS
+	 * area (640->1Mb) as ram even though it is not.
+	 */
+	if (pagenr >= (BIOS_BEGIN >> PAGE_SHIFT) &&
+		    pagenr < (BIOS_END >> PAGE_SHIFT))
+		return 0;
+
 	for (i = 0; i < e820.nr_map; i++) {
 		/*
 		 * Not usable memory:
@@ -51,14 +67,6 @@ int page_is_ram(unsigned long pagenr)
 		addr = (e820.map[i].addr + PAGE_SIZE-1) >> PAGE_SHIFT;
 		end = (e820.map[i].addr + e820.map[i].size) >> PAGE_SHIFT;
 
-		/*
-		 * Sanity check: Some BIOSen report areas as RAM that
-		 * are not. Notably the 640->1Mb area, which is the
-		 * PCI BIOS area.
-		 */
-		if (addr >= (BIOS_BEGIN >> PAGE_SHIFT) &&
-		    end < (BIOS_END >> PAGE_SHIFT))
-			continue;
 
 		if ((pagenr >= addr) && (pagenr < end))
 			return 1;
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 3ee1499..e2a74ea 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -513,7 +513,6 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 	unsigned long address = cpa->vaddr;
 	int do_split, err;
 	unsigned int level;
-	struct page *kpte_page;
 	pte_t *kpte, old_pte;
 
 repeat:
@@ -532,10 +531,6 @@ repeat:
 		return -EINVAL;
 	}
 
-	kpte_page = virt_to_page(kpte);
-	BUG_ON(PageLRU(kpte_page));
-	BUG_ON(PageCompound(kpte_page));
-
 	if (level == PG_LEVEL_4K) {
 		pte_t new_pte;
 		pgprot_t new_prot = pte_pgprot(old_pte);
diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index ecd91ea..845001c 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -166,7 +166,8 @@ static inline int save_add_info(void) {return 0;}
  * Both SPARSE and RESERVE need nodes_add information.
  * This code supports one contiguous hot add area per node.
  */
-static int reserve_hotadd(int node, unsigned long start, unsigned long end)
+static int __init
+reserve_hotadd(int node, unsigned long start, unsigned long end)
 {
 	unsigned long s_pfn = start >> PAGE_SHIFT;
 	unsigned long e_pfn = end >> PAGE_SHIFT;
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index b7c67a1..7b6e3bb 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -541,7 +541,7 @@ void pcibios_disable_device (struct pci_dev *dev)
 		pcibios_disable_irq(dev);
 }
 
-struct pci_bus *pci_scan_bus_with_sysdata(int busno)
+struct pci_bus *__devinit pci_scan_bus_with_sysdata(int busno)
 {
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index 1deb324..0004159 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -20,6 +20,7 @@
 #include <asm/segment.h>
 #include <asm/page.h>
 #include <asm/asm-offsets.h>
+#include <asm/processor-flags.h>
 
 ENTRY(swsusp_arch_suspend)
 	movq	$saved_context, %rax
@@ -60,7 +61,7 @@ ENTRY(restore_image)
 	/* Flush TLB */
 	movq	mmu_cr4_features(%rip), %rax
 	movq	%rax, %rdx
-	andq	$~(1<<7), %rdx	# PGE
+	andq	$~(X86_CR4_PGE), %rdx
 	movq	%rdx, %cr4;  # turn off PGE
 	movq	%cr3, %rcx;  # flush TLB
 	movq	%rcx, %cr3;
@@ -112,7 +113,7 @@ ENTRY(restore_registers)
 	/* Flush TLB, including "global" things (vmalloc) */
 	movq	mmu_cr4_features(%rip), %rax
 	movq	%rax, %rdx
-	andq	$~(1<<7), %rdx;  # PGE
+	andq	$~(X86_CR4_PGE), %rdx
 	movq	%rdx, %cr4;  # turn off PGE
 	movq	%cr3, %rcx;  # flush TLB
 	movq	%rcx, %cr3
diff --git a/include/asm-x86/i387.h b/include/asm-x86/i387.h
index 6b1895c..f377b76 100644
--- a/include/asm-x86/i387.h
+++ b/include/asm-x86/i387.h
@@ -20,7 +20,6 @@
 #include <asm/uaccess.h>
 
 extern void fpu_init(void);
-extern unsigned int mxcsr_feature_mask;
 extern void mxcsr_feature_mask_init(void);
 extern void init_fpu(struct task_struct *child);
 extern asmlinkage void math_state_restore(void);
diff --git a/include/asm-x86/pgtable_64.h b/include/asm-x86/pgtable_64.h
index 7fd5e0e..0a0b77b 100644
--- a/include/asm-x86/pgtable_64.h
+++ b/include/asm-x86/pgtable_64.h
@@ -188,6 +188,7 @@ static inline unsigned long pmd_bad(pmd_t pmd)
 #define pgd_offset(mm, addr) ((mm)->pgd + pgd_index(addr))
 #define pgd_offset_k(address) (init_level4_pgt + pgd_index(address))
 #define pgd_present(pgd) (pgd_val(pgd) & _PAGE_PRESENT)
+static inline int pgd_large(pgd_t pgd) { return 0; }
 #define mk_kernel_pgd(address) ((pgd_t){ (address) | _KERNPG_TABLE })
 
 /* PUD - Level3 access */
diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 149920d..45a2f0a 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -302,10 +302,6 @@ union i387_union {
 };
 
 #ifdef CONFIG_X86_32
-/*
- * the following now lives in the per cpu area:
- * extern	int cpu_llc_id[NR_CPUS];
- */
 DECLARE_PER_CPU(u8, cpu_llc_id);
 #else
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
@@ -671,7 +667,6 @@ extern void init_gdt(int cpu);
 extern unsigned int machine_id;
 extern unsigned int machine_submodel_id;
 extern unsigned int BIOS_revision;
-extern unsigned int mca_pentium_flag;
 
 /* Boot loader type from the setup header */
 extern int bootloader_type;
