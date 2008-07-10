Return-Path: <linux-kernel-owner+w=401wt.eu-S1758858AbYGJRHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758858AbYGJRHr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYGJRHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:07:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38002 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbYGJRHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:07:36 -0400
Date: Thu, 10 Jul 2008 19:07:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: the arch/x86 maintainers <x86@kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [x86, patch] turn x86 VISWS into a generic architecture
Message-ID: <20080710170712.GA14583@elte.hu>
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


here's something i've been working on to simplify the x86 architecture 
code. I've extended generic x86 code with VISWS support and eliminated 
the VISWS subarch. The commits can be seen here (also attached):

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86/generalize-visws

The purpose of this is to eliminate the x86 subarch complications 
altogether from the tree.

[ I couldnt test it on real VISWS hardware, but all the intermediate
  steps booted fine on a real PC, so if there's someone still with a 
  VISWS around, it should be testable. (and bisectable) ]

The majority of the VISWS quirks are now contained in the 
arch/x86/kernel/visws_quirks.c file.

I think x86/Voyager could be converted in a similar way - by using the 
new quirk mechanism i've added. Doing so would largely eliminate most of 
our subarch complications in the x86 space.

	Ingo

------------------>
Ingo Molnar (25):
      x86: add early quirk support
      x86, VisWS: turn into generic arch, make VisWS boot on a regular PC
      x86, VisWS: turn into generic arch, add early init quirks
      x86, VisWS: turn into generic arch, use generic mpparse code
      x86, VisWS: turn into generic arch, install proper PCI quirk
      x86, VisWS: turn into generic arch, update asm-x86/mach-visws/mach_apic.h
      x86, VisWS: turn into generic arch, eliminate include/asm-x86/mach-visws/mach_apic.h
      x86, VisWS: turn into generic arch, enhance include/asm-x86/mach-default/smpboot_hooks.h
      x86, VisWS: turn into generic arch, update include/asm-x86/mach-visws/smpboot_hooks.h
      x86, VisWS: turn into generic arch, eliminate include/asm-x86/mach-visws/smpboot_hooks.h
      x86, VisWS: turn into generic arch, update asm-x86/mach-visws/mach_apicdef.h
      x86, VisWS: turn into generic arch, eliminate asm-x86/mach-visws/mach_apicdef.h
      x86, VisWS: turn into generic arch, create include/asm-x86/visws/
      x86, VisWS: turn into generic arch, move definitions
      x86, VisWS: turn into generic arch, eliminate include/asm-x86/mach-visws/setup_arch.h
      x86, VisWS: turn into generic arch, add NR_IRQS quirk
      x86, VisWS: turn into generic arch, add early quirks to default architectures
      x86, VisWS: turn into generic arch, copy visws files
      x86, VisWS: turn into generic arch, flip over VISWS to generic arch
      x86, VisWS: turn into generic arch, clean up
      x86, VisWS: turn into generic arch, IO-APIC setup fix
      x86, VisWS: turn into generic arch, clean up
      x86, VisWS: turn into generic arch, clean up
      x86, VisWS: turn into generic arch, remove leftover files
      x86, VisWS: turn into generic arch, eliminate Kconfig specials


 arch/x86/Kconfig                                |   62 +-
 arch/x86/Makefile                               |    4 -
 arch/x86/kernel/Makefile                        |    1 +
 arch/x86/kernel/apic_32.c                       |    2 +-
 arch/x86/kernel/e820.c                          |   11 +
 arch/x86/kernel/mpparse.c                       |   20 +-
 arch/x86/kernel/setup.c                         |    1 +
 arch/x86/kernel/visws_quirks.c                  |  707 +++++++++++++++++++++++
 arch/x86/lguest/Kconfig                         |    2 +-
 arch/x86/mach-default/setup.c                   |   32 +-
 arch/x86/mach-visws/Makefile                    |    8 -
 arch/x86/mach-visws/mpparse.c                   |   85 ---
 arch/x86/mach-visws/reboot.c                    |   55 --
 arch/x86/mach-visws/setup.c                     |  183 ------
 arch/x86/mach-visws/traps.c                     |   69 ---
 arch/x86/mach-visws/visws_apic.c                |  296 ----------
 arch/x86/pci/Makefile                           |    4 +-
 arch/x86/pci/visws.c                            |   19 +-
 drivers/acpi/Kconfig                            |    1 -
 drivers/lguest/Kconfig                          |    2 +-
 drivers/video/sgivwfb.c                         |    3 +-
 include/asm-x86/irq_vectors.h                   |    4 +-
 include/asm-x86/mach-default/smpboot_hooks.h    |    6 +
 include/asm-x86/mach-visws/mach_apic.h          |  104 +----
 include/asm-x86/mach-visws/mach_apicdef.h       |   13 +-
 include/asm-x86/mach-visws/setup_arch.h         |    7 +-
 include/asm-x86/mach-visws/smpboot_hooks.h      |   29 +-
 include/asm-x86/setup.h                         |   19 +
 include/asm-x86/{mach-visws => visws}/cobalt.h  |    0
 include/asm-x86/{mach-visws => visws}/lithium.h |    0
 include/asm-x86/{mach-visws => visws}/piix4.h   |    0
 include/asm-x86/visws/sgivw.h                   |    5 +
 32 files changed, 855 insertions(+), 899 deletions(-)
 create mode 100644 arch/x86/kernel/visws_quirks.c
 delete mode 100644 arch/x86/mach-visws/Makefile
 delete mode 100644 arch/x86/mach-visws/mpparse.c
 delete mode 100644 arch/x86/mach-visws/reboot.c
 delete mode 100644 arch/x86/mach-visws/setup.c
 delete mode 100644 arch/x86/mach-visws/traps.c
 delete mode 100644 arch/x86/mach-visws/visws_apic.c
 rename include/asm-x86/{mach-visws => visws}/cobalt.h (100%)
 rename include/asm-x86/{mach-visws => visws}/lithium.h (100%)
 rename include/asm-x86/{mach-visws => visws}/piix4.h (100%)
 create mode 100644 include/asm-x86/visws/sgivw.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3b1b1da..24ff43a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -181,12 +181,12 @@ config X86_64_SMP
 config X86_HT
 	bool
 	depends on SMP
-	depends on (X86_32 && !(X86_VISWS || X86_VOYAGER)) || X86_64
+	depends on (X86_32 && !X86_VOYAGER) || X86_64
 	default y
 
 config X86_BIOS_REBOOT
 	bool
-	depends on !X86_VISWS && !X86_VOYAGER
+	depends on !X86_VOYAGER
 	default y
 
 config X86_TRAMPOLINE
@@ -232,13 +232,13 @@ config SMP
 
 config X86_FIND_SMP_CONFIG
 	def_bool y
-	depends on X86_MPPARSE || X86_VOYAGER || X86_VISWS
+	depends on X86_MPPARSE || X86_VOYAGER
 
 if ACPI
 config X86_MPPARSE
 	def_bool y
 	bool "Enable MPS table"
-	depends on X86_LOCAL_APIC && !X86_VISWS
+	depends on X86_LOCAL_APIC
 	help
 	  For old smp systems that do not have proper acpi support. Newer systems
 	  (esp with 64bit cpus) with acpi support, MADT and DSDT will override it
@@ -247,7 +247,7 @@ endif
 if !ACPI
 config X86_MPPARSE
 	def_bool y
-	depends on X86_LOCAL_APIC && !X86_VISWS
+	depends on X86_LOCAL_APIC
 endif
 
 choice
@@ -281,18 +281,6 @@ config X86_VOYAGER
 	  If you do not specifically know you have a Voyager based machine,
 	  say N here, otherwise the kernel you build will not be bootable.
 
-config X86_VISWS
-	bool "SGI 320/540 (Visual Workstation)"
-	depends on X86_32 && PCI
-	help
-	  The SGI Visual Workstation series is an IA32-based workstation
-	  based on SGI systems chips with some legacy PC hardware attached.
-
-	  Say Y here to create a kernel to run on the SGI 320 or 540.
-
-	  A kernel compiled for the Visual Workstation will not run on PCs
-	  and vice versa. See <file:Documentation/sgi-visws.txt> for details.
-
 config X86_GENERICARCH
        bool "Generic architecture"
 	depends on X86_32
@@ -363,6 +351,18 @@ config X86_VSMP
 
 endchoice
 
+config X86_VISWS
+	bool "SGI 320/540 (Visual Workstation)"
+	depends on X86_32 && PCI
+	help
+	  The SGI Visual Workstation series is an IA32-based workstation
+	  based on SGI systems chips with some legacy PC hardware attached.
+
+	  Say Y here to create a kernel to run on the SGI 320 or 540.
+
+	  A kernel compiled for the Visual Workstation will run on general
+	  PCs as well. See <file:Documentation/sgi-visws.txt> for details.
+
 config SCHED_NO_NO_OMIT_FRAME_POINTER
 	def_bool y
 	prompt "Single-depth WCHAN output"
@@ -391,7 +391,7 @@ config VMI
 	bool "VMI Guest support"
 	select PARAVIRT
 	depends on X86_32
-	depends on !(X86_VISWS || X86_VOYAGER)
+	depends on !X86_VOYAGER
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
@@ -402,7 +402,7 @@ config KVM_CLOCK
 	bool "KVM paravirtualized clock"
 	select PARAVIRT
 	select PARAVIRT_CLOCK
-	depends on !(X86_VISWS || X86_VOYAGER)
+	depends on !X86_VOYAGER
 	help
 	  Turning on this option will allow you to run a paravirtualized clock
 	  when running over the KVM hypervisor. Instead of relying on a PIT
@@ -413,7 +413,7 @@ config KVM_CLOCK
 config KVM_GUEST
 	bool "KVM Guest support"
 	select PARAVIRT
-	depends on !(X86_VISWS || X86_VOYAGER)
+	depends on !X86_VOYAGER
 	help
 	 This option enables various optimizations for running under the KVM
 	 hypervisor.
@@ -422,7 +422,7 @@ source "arch/x86/lguest/Kconfig"
 
 config PARAVIRT
 	bool "Enable paravirtualization code"
-	depends on !(X86_VISWS || X86_VOYAGER)
+	depends on !X86_VOYAGER
 	help
 	  This changes the kernel so it can modify itself when it is run
 	  under a hypervisor, potentially improving performance significantly
@@ -628,7 +628,7 @@ source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
 	bool "Local APIC support on uniprocessors"
-	depends on X86_32 && !SMP && !(X86_VISWS || X86_VOYAGER || X86_GENERICARCH)
+	depends on X86_32 && !SMP && !(X86_VOYAGER || X86_GENERICARCH)
 	help
 	  A local APIC (Advanced Programmable Interrupt Controller) is an
 	  integrated interrupt controller in the CPU. If you have a single-CPU
@@ -653,11 +653,11 @@ config X86_UP_IOAPIC
 
 config X86_LOCAL_APIC
 	def_bool y
-	depends on X86_64 || (X86_32 && (X86_UP_APIC || ((X86_VISWS || SMP) && !X86_VOYAGER) || X86_GENERICARCH))
+	depends on X86_64 || (X86_32 && (X86_UP_APIC || (SMP && !X86_VOYAGER) || X86_GENERICARCH))
 
 config X86_IO_APIC
 	def_bool y
-	depends on X86_64 || (X86_32 && (X86_UP_IOAPIC || (SMP && !(X86_VISWS || X86_VOYAGER)) || X86_GENERICARCH))
+	depends on X86_64 || (X86_32 && (X86_UP_IOAPIC || (SMP && !X86_VOYAGER) || X86_GENERICARCH))
 
 config X86_VISWS_APIC
 	def_bool y
@@ -711,7 +711,7 @@ config X86_MCE_NONFATAL
 
 config X86_MCE_P4THERMAL
 	bool "check for P4 thermal throttling interrupt."
-	depends on X86_32 && X86_MCE && (X86_UP_APIC || SMP) && !X86_VISWS
+	depends on X86_32 && X86_MCE && (X86_UP_APIC || SMP)
 	help
 	  Enabling this feature will cause a message to be printed when the P4
 	  enters thermal throttling.
@@ -1414,7 +1414,7 @@ config X86_APM_BOOT
 
 menuconfig APM
 	tristate "APM (Advanced Power Management) BIOS support"
-	depends on X86_32 && PM_SLEEP && !X86_VISWS
+	depends on X86_32 && PM_SLEEP
 	---help---
 	  APM is a BIOS specification for saving power using several different
 	  techniques. This is mostly useful for battery powered laptops with
@@ -1561,7 +1561,7 @@ config PCI
 
 choice
 	prompt "PCI access mode"
-	depends on X86_32 && PCI && !X86_VISWS
+	depends on X86_32 && PCI
 	default PCI_GOANY
 	---help---
 	  On PCI systems, the BIOS can be used to detect the PCI devices and
@@ -1598,12 +1598,12 @@ endchoice
 
 config PCI_BIOS
 	def_bool y
-	depends on X86_32 && !X86_VISWS && PCI && (PCI_GOBIOS || PCI_GOANY)
+	depends on X86_32 && PCI && (PCI_GOBIOS || PCI_GOANY)
 
 # x86-64 doesn't support PCI BIOS access from long mode so always go direct.
 config PCI_DIRECT
 	def_bool y
-	depends on PCI && (X86_64 || (PCI_GODIRECT || PCI_GOANY || PCI_GOOLPC) || X86_VISWS)
+	depends on PCI && (X86_64 || (PCI_GODIRECT || PCI_GOANY || PCI_GOOLPC))
 
 config PCI_MMCONFIG
 	def_bool y
@@ -1663,7 +1663,7 @@ if X86_32
 
 config ISA
 	bool "ISA support"
-	depends on !(X86_VOYAGER || X86_VISWS)
+	depends on !X86_VOYAGER
 	help
 	  Find out whether you have ISA slots on your motherboard.  ISA is the
 	  name of a bus system, i.e. the way the CPU talks to the other stuff
@@ -1690,7 +1690,7 @@ config EISA
 source "drivers/eisa/Kconfig"
 
 config MCA
-	bool "MCA support" if !(X86_VISWS || X86_VOYAGER)
+	bool "MCA support" if !X86_VOYAGER
 	default y if X86_VOYAGER
 	help
 	  MicroChannel Architecture is found in some IBM PS/2 machines and
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index b03d24b..919ce21 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -113,10 +113,6 @@ mcore-y  := arch/x86/mach-default/
 mflags-$(CONFIG_X86_VOYAGER)	:= -Iinclude/asm-x86/mach-voyager
 mcore-$(CONFIG_X86_VOYAGER)	:= arch/x86/mach-voyager/
 
-# VISWS subarch support
-mflags-$(CONFIG_X86_VISWS)	:= -Iinclude/asm-x86/mach-visws
-mcore-$(CONFIG_X86_VISWS)	:= arch/x86/mach-visws/
-
 # generic subarchitecture
 mflags-$(CONFIG_X86_GENERICARCH):= -Iinclude/asm-x86/mach-generic
 fcore-$(CONFIG_X86_GENERICARCH)	+= arch/x86/mach-generic/
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 59b14c9..f77dd67 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -19,6 +19,7 @@ obj-y			:= process_$(BITS).o signal_$(BITS).o entry_$(BITS).o
 obj-y			+= traps_$(BITS).o irq_$(BITS).o
 obj-y			+= time_$(BITS).o ioport.o ldt.o
 obj-y			+= setup.o i8259.o irqinit_$(BITS).o setup_percpu.o
+obj-$(CONFIG_X86_VISWS)	+= visws_quirks.o
 obj-$(CONFIG_X86_32)	+= probe_roms_32.o
 obj-$(CONFIG_X86_32)	+= sys_i386_32.o i386_ksyms_32.o
 obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 3e94720..3e58b67 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -974,7 +974,7 @@ void __cpuinit setup_local_APIC(void)
 	 * Double-check whether this APIC is really registered.
 	 */
 	if (!apic_id_registered())
-		BUG();
+		WARN_ON_ONCE(1);
 
 	/*
 	 * Intel recommends to set DFR, LDR and TPR before enabling
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 9836a07..269d367 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -1297,6 +1297,11 @@ void __init e820_reserve_resources(void)
 	}
 }
 
+/*
+ * Non-standard memory setup can be specified via this quirk:
+ */
+char * (*arch_memory_setup_quirk)(void);
+
 char *__init default_machine_specific_memory_setup(void)
 {
 	char *who = "BIOS-e820";
@@ -1337,6 +1342,12 @@ char *__init default_machine_specific_memory_setup(void)
 
 char *__init __attribute__((weak)) machine_specific_memory_setup(void)
 {
+	if (arch_memory_setup_quirk) {
+		char *who = arch_memory_setup_quirk();
+
+		if (who)
+			return who;
+	}
 	return default_machine_specific_memory_setup();
 }
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 8b6b1e0..3b25e49 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -726,12 +726,22 @@ static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 static struct intel_mp_floating *mpf_found;
 
 /*
+ * Machine specific quirk for finding the SMP config before other setup
+ * activities destroy the table:
+ */
+int (*mach_get_smp_config_quirk)(unsigned int early);
+
+/*
  * Scan the memory blocks for an SMP configuration block.
  */
-static void __init __get_smp_config(unsigned early)
+static void __init __get_smp_config(unsigned int early)
 {
 	struct intel_mp_floating *mpf = mpf_found;
 
+	if (mach_get_smp_config_quirk) {
+		if (mach_get_smp_config_quirk(early))
+			return;
+	}
 	if (acpi_lapic && early)
 		return;
 	/*
@@ -889,10 +899,16 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 	return 0;
 }
 
-static void __init __find_smp_config(unsigned reserve)
+int (*mach_find_smp_config_quirk)(unsigned int reserve);
+
+static void __init __find_smp_config(unsigned int reserve)
 {
 	unsigned int address;
 
+	if (mach_find_smp_config_quirk) {
+		if (mach_find_smp_config_quirk(reserve))
+			return;
+	}
 	/*
 	 * FIXME: Linux assumes you have 640K of base ram..
 	 * this continues the error...
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index a7c3471..cb3db40 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -596,6 +596,7 @@ void __init setup_arch(char **cmdline_p)
 {
 #ifdef CONFIG_X86_32
 	memcpy(&boot_cpu_data, &new_cpu_data, sizeof(new_cpu_data));
+	visws_early_detect();
 	pre_setup_arch_hook();
 	early_cpu_init();
 #else
diff --git a/arch/x86/kernel/visws_quirks.c b/arch/x86/kernel/visws_quirks.c
new file mode 100644
index 0000000..5c715c2
--- /dev/null
+++ b/arch/x86/kernel/visws_quirks.c
@@ -0,0 +1,707 @@
+/*
+ *  SGI Visual Workstation support and quirks, unmaintained.
+ *
+ *  Split out from setup.c by davej@suse.de
+ *
+ *	Copyright (C) 1999 Bent Hagemark, Ingo Molnar
+ *
+ *  SGI Visual Workstation interrupt controller
+ *
+ *  The Cobalt system ASIC in the Visual Workstation contains a "Cobalt" APIC
+ *  which serves as the main interrupt controller in the system.  Non-legacy
+ *  hardware in the system uses this controller directly.  Legacy devices
+ *  are connected to the PIIX4 which in turn has its 8259(s) connected to
+ *  a of the Cobalt APIC entry.
+ *
+ *  09/02/2000 - Updated for 2.4 by jbarnes@sgi.com
+ *
+ *  25/11/2002 - Updated for 2.5 by Andrey Panin <pazke@orbita1.ru>
+ */
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/smp.h>
+
+#include <asm/visws/cobalt.h>
+#include <asm/visws/piix4.h>
+#include <asm/arch_hooks.h>
+#include <asm/fixmap.h>
+#include <asm/reboot.h>
+#include <asm/setup.h>
+#include <asm/e820.h>
+#include <asm/smp.h>
+#include <asm/io.h>
+
+#include <mach_ipi.h>
+
+#include "mach_apic.h"
+
+#include <linux/init.h>
+#include <linux/smp.h>
+
+#include <linux/kernel_stat.h>
+#include <linux/interrupt.h>
+#include <linux/init.h>
+
+#include <asm/io.h>
+#include <asm/apic.h>
+#include <asm/i8259.h>
+#include <asm/irq_vectors.h>
+#include <asm/visws/cobalt.h>
+#include <asm/visws/lithium.h>
+#include <asm/visws/piix4.h>
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
+
+#include <asm/io.h>
+#include <asm/apic.h>
+#include <asm/arch_hooks.h>
+#include <asm/visws/cobalt.h>
+#include <asm/visws/lithium.h>
+
+char visws_board_type	= -1;
+char visws_board_rev	= -1;
+
+int is_visws_box(void)
+{
+	return visws_board_type >= 0;
+}
+
+static int __init visws_time_init_quirk(void)
+{
+	printk(KERN_INFO "Starting Cobalt Timer system clock\n");
+
+	/* Set the countdown value */
+	co_cpu_write(CO_CPU_TIMEVAL, CO_TIME_HZ/HZ);
+
+	/* Start the timer */
+	co_cpu_write(CO_CPU_CTRL, co_cpu_read(CO_CPU_CTRL) | CO_CTRL_TIMERUN);
+
+	/* Enable (unmask) the timer interrupt */
+	co_cpu_write(CO_CPU_CTRL, co_cpu_read(CO_CPU_CTRL) & ~CO_CTRL_TIMEMASK);
+
+	/*
+	 * Zero return means the generic timer setup code will set up
+	 * the standard vector:
+	 */
+	return 0;
+}
+
+static int __init visws_pre_intr_init_quirk(void)
+{
+	init_VISWS_APIC_irqs();
+
+	/*
+	 * We dont want ISA irqs to be set up by the generic code:
+	 */
+	return 1;
+}
+
+/* Quirk for machine specific memory setup. */
+
+#define MB (1024 * 1024)
+
+unsigned long sgivwfb_mem_phys;
+unsigned long sgivwfb_mem_size;
+EXPORT_SYMBOL(sgivwfb_mem_phys);
+EXPORT_SYMBOL(sgivwfb_mem_size);
+
+long long mem_size __initdata = 0;
+
+static char * __init visws_memory_setup_quirk(void)
+{
+	long long gfx_mem_size = 8 * MB;
+
+	mem_size = boot_params.alt_mem_k;
+
+	if (!mem_size) {
+		printk(KERN_WARNING "Bootloader didn't set memory size, upgrade it !\n");
+		mem_size = 128 * MB;
+	}
+
+	/*
+	 * this hardcodes the graphics memory to 8 MB
+	 * it really should be sized dynamically (or at least
+	 * set as a boot param)
+	 */
+	if (!sgivwfb_mem_size) {
+		printk(KERN_WARNING "Defaulting to 8 MB framebuffer size\n");
+		sgivwfb_mem_size = 8 * MB;
+	}
+
+	/*
+	 * Trim to nearest MB
+	 */
+	sgivwfb_mem_size &= ~((1 << 20) - 1);
+	sgivwfb_mem_phys = mem_size - gfx_mem_size;
+
+	e820_add_region(0, LOWMEMSIZE(), E820_RAM);
+	e820_add_region(HIGH_MEMORY, mem_size - sgivwfb_mem_size - HIGH_MEMORY, E820_RAM);
+	e820_add_region(sgivwfb_mem_phys, sgivwfb_mem_size, E820_RESERVED);
+
+	return "PROM";
+}
+
+static void visws_machine_emergency_restart(void)
+{
+	/*
+	 * Visual Workstations restart after this
+	 * register is poked on the PIIX4
+	 */
+	outb(PIIX4_RESET_VAL, PIIX4_RESET_PORT);
+}
+
+static void visws_machine_power_off(void)
+{
+	unsigned short pm_status;
+/*	extern unsigned int pci_bus0; */
+
+	while ((pm_status = inw(PMSTS_PORT)) & 0x100)
+		outw(pm_status, PMSTS_PORT);
+
+	outw(PM_SUSPEND_ENABLE, PMCNTRL_PORT);
+
+	mdelay(10);
+
+#define PCI_CONF1_ADDRESS(bus, devfn, reg) \
+	(0x80000000 | (bus << 16) | (devfn << 8) | (reg & ~3))
+
+/*	outl(PCI_CONF1_ADDRESS(pci_bus0, SPECIAL_DEV, SPECIAL_REG), 0xCF8); */
+	outl(PIIX_SPECIAL_STOP, 0xCFC);
+}
+
+static int __init visws_get_smp_config_quirk(unsigned int early)
+{
+	/*
+	 * Prevent MP-table parsing by the generic code:
+	 */
+	return 1;
+}
+
+extern unsigned int __cpuinitdata maxcpus;
+
+/*
+ * The Visual Workstation is Intel MP compliant in the hardware
+ * sense, but it doesn't have a BIOS(-configuration table).
+ * No problem for Linux.
+ */
+
+static void __init MP_processor_info (struct mpc_config_processor *m)
+{
+	int ver, logical_apicid;
+	physid_mask_t apic_cpus;
+
+	if (!(m->mpc_cpuflag & CPU_ENABLED))
+		return;
+
+	logical_apicid = m->mpc_apicid;
+	printk(KERN_INFO "%sCPU #%d %u:%u APIC version %d\n",
+	       m->mpc_cpuflag & CPU_BOOTPROCESSOR ? "Bootup " : "",
+	       m->mpc_apicid,
+	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
+	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
+	       m->mpc_apicver);
+
+	if (m->mpc_cpuflag & CPU_BOOTPROCESSOR)
+		boot_cpu_physical_apicid = m->mpc_apicid;
+
+	ver = m->mpc_apicver;
+	if ((ver >= 0x14 && m->mpc_apicid >= 0xff) || m->mpc_apicid >= 0xf) {
+		printk(KERN_ERR "Processor #%d INVALID. (Max ID: %d).\n",
+			m->mpc_apicid, MAX_APICS);
+		return;
+	}
+
+	apic_cpus = apicid_to_cpu_present(m->mpc_apicid);
+	physids_or(phys_cpu_present_map, phys_cpu_present_map, apic_cpus);
+	/*
+	 * Validate version
+	 */
+	if (ver == 0x0) {
+		printk(KERN_ERR "BIOS bug, APIC version is 0 for CPU#%d! "
+			"fixing up to 0x10. (tell your hw vendor)\n",
+			m->mpc_apicid);
+		ver = 0x10;
+	}
+	apic_version[m->mpc_apicid] = ver;
+}
+
+int __init visws_find_smp_config_quirk(unsigned int reserve)
+{
+	struct mpc_config_processor *mp = phys_to_virt(CO_CPU_TAB_PHYS);
+	unsigned short ncpus = readw(phys_to_virt(CO_CPU_NUM_PHYS));
+
+	if (ncpus > CO_CPU_MAX) {
+		printk(KERN_WARNING "find_visws_smp: got cpu count of %d at %p\n",
+			ncpus, mp);
+
+		ncpus = CO_CPU_MAX;
+	}
+
+	if (ncpus > maxcpus)
+		ncpus = maxcpus;
+
+#ifdef CONFIG_X86_LOCAL_APIC
+	smp_found_config = 1;
+#endif
+	while (ncpus--)
+		MP_processor_info(mp++);
+
+	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
+
+	return 1;
+}
+
+extern int visws_trap_init_quirk(void);
+
+void __init visws_early_detect(void)
+{
+	int raw;
+
+	visws_board_type = (char)(inb_p(PIIX_GPI_BD_REG) & PIIX_GPI_BD_REG)
+							 >> PIIX_GPI_BD_SHIFT;
+
+	if (visws_board_type < 0)
+		return;
+
+	/*
+	 * Install special quirks for timer, interrupt and memory setup:
+	 */
+	arch_time_init_quirk		= visws_time_init_quirk;
+	arch_pre_intr_init_quirk	= visws_pre_intr_init_quirk;
+	arch_memory_setup_quirk		= visws_memory_setup_quirk;
+
+	/*
+	 * Fall back to generic behavior for traps:
+	 */
+	arch_intr_init_quirk		= NULL;
+	arch_trap_init_quirk		= visws_trap_init_quirk;
+
+	/*
+	 * Install reboot quirks:
+	 */
+	pm_power_off			= visws_machine_power_off;
+	machine_ops.emergency_restart	= visws_machine_emergency_restart;
+
+	/*
+	 * Do not use broadcast IPIs:
+	 */
+	no_broadcast = 0;
+
+	/*
+	 * Override generic MP-table parsing:
+	 */
+	mach_get_smp_config_quirk	= visws_get_smp_config_quirk;
+	mach_find_smp_config_quirk	= visws_find_smp_config_quirk;
+
+#ifdef CONFIG_X86_IO_APIC
+	/*
+	 * Turn off IO-APIC detection and initialization:
+	 */
+	skip_ioapic_setup		= 1;
+#endif
+
+	/*
+	 * Get Board rev.
+	 * First, we have to initialize the 307 part to allow us access
+	 * to the GPIO registers.  Let's map them at 0x0fc0 which is right
+	 * after the PIIX4 PM section.
+	 */
+	outb_p(SIO_DEV_SEL, SIO_INDEX);
+	outb_p(SIO_GP_DEV, SIO_DATA);	/* Talk to GPIO regs. */
+
+	outb_p(SIO_DEV_MSB, SIO_INDEX);
+	outb_p(SIO_GP_MSB, SIO_DATA);	/* MSB of GPIO base address */
+
+	outb_p(SIO_DEV_LSB, SIO_INDEX);
+	outb_p(SIO_GP_LSB, SIO_DATA);	/* LSB of GPIO base address */
+
+	outb_p(SIO_DEV_ENB, SIO_INDEX);
+	outb_p(1, SIO_DATA);		/* Enable GPIO registers. */
+
+	/*
+	 * Now, we have to map the power management section to write
+	 * a bit which enables access to the GPIO registers.
+	 * What lunatic came up with this shit?
+	 */
+	outb_p(SIO_DEV_SEL, SIO_INDEX);
+	outb_p(SIO_PM_DEV, SIO_DATA);	/* Talk to GPIO regs. */
+
+	outb_p(SIO_DEV_MSB, SIO_INDEX);
+	outb_p(SIO_PM_MSB, SIO_DATA);	/* MSB of PM base address */
+
+	outb_p(SIO_DEV_LSB, SIO_INDEX);
+	outb_p(SIO_PM_LSB, SIO_DATA);	/* LSB of PM base address */
+
+	outb_p(SIO_DEV_ENB, SIO_INDEX);
+	outb_p(1, SIO_DATA);		/* Enable PM registers. */
+
+	/*
+	 * Now, write the PM register which enables the GPIO registers.
+	 */
+	outb_p(SIO_PM_FER2, SIO_PM_INDEX);
+	outb_p(SIO_PM_GP_EN, SIO_PM_DATA);
+
+	/*
+	 * Now, initialize the GPIO registers.
+	 * We want them all to be inputs which is the
+	 * power on default, so let's leave them alone.
+	 * So, let's just read the board rev!
+	 */
+	raw = inb_p(SIO_GP_DATA1);
+	raw &= 0x7f;	/* 7 bits of valid board revision ID. */
+
+	if (visws_board_type == VISWS_320) {
+		if (raw < 0x6) {
+			visws_board_rev = 4;
+		} else if (raw < 0xc) {
+			visws_board_rev = 5;
+		} else {
+			visws_board_rev = 6;
+		}
+	} else if (visws_board_type == VISWS_540) {
+			visws_board_rev = 2;
+		} else {
+			visws_board_rev = raw;
+		}
+
+	printk(KERN_INFO "Silicon Graphics Visual Workstation %s (rev %d) detected\n",
+	       (visws_board_type == VISWS_320 ? "320" :
+	       (visws_board_type == VISWS_540 ? "540" :
+		"unknown")), visws_board_rev);
+}
+
+#define A01234 (LI_INTA_0 | LI_INTA_1 | LI_INTA_2 | LI_INTA_3 | LI_INTA_4)
+#define BCD (LI_INTB | LI_INTC | LI_INTD)
+#define ALLDEVS (A01234 | BCD)
+
+static __init void lithium_init(void)
+{
+	set_fixmap(FIX_LI_PCIA, LI_PCI_A_PHYS);
+	set_fixmap(FIX_LI_PCIB, LI_PCI_B_PHYS);
+
+	if ((li_pcia_read16(PCI_VENDOR_ID) != PCI_VENDOR_ID_SGI) ||
+	    (li_pcia_read16(PCI_DEVICE_ID) != PCI_DEVICE_ID_SGI_LITHIUM)) {
+		printk(KERN_EMERG "Lithium hostbridge %c not found\n", 'A');
+/*		panic("This machine is not SGI Visual Workstation 320/540"); */
+	}
+
+	if ((li_pcib_read16(PCI_VENDOR_ID) != PCI_VENDOR_ID_SGI) ||
+	    (li_pcib_read16(PCI_DEVICE_ID) != PCI_DEVICE_ID_SGI_LITHIUM)) {
+		printk(KERN_EMERG "Lithium hostbridge %c not found\n", 'B');
+/*		panic("This machine is not SGI Visual Workstation 320/540"); */
+	}
+
+	li_pcia_write16(LI_PCI_INTEN, ALLDEVS);
+	li_pcib_write16(LI_PCI_INTEN, ALLDEVS);
+}
+
+static __init void cobalt_init(void)
+{
+	/*
+	 * On normal SMP PC this is used only with SMP, but we have to
+	 * use it and set it up here to start the Cobalt clock
+	 */
+	set_fixmap(FIX_APIC_BASE, APIC_DEFAULT_PHYS_BASE);
+	setup_local_APIC();
+	printk(KERN_INFO "Local APIC Version %#x, ID %#x\n",
+		(unsigned int)apic_read(APIC_LVR),
+		(unsigned int)apic_read(APIC_ID));
+
+	set_fixmap(FIX_CO_CPU, CO_CPU_PHYS);
+	set_fixmap(FIX_CO_APIC, CO_APIC_PHYS);
+	printk(KERN_INFO "Cobalt Revision %#lx, APIC ID %#lx\n",
+		co_cpu_read(CO_CPU_REV), co_apic_read(CO_APIC_ID));
+
+	/* Enable Cobalt APIC being careful to NOT change the ID! */
+	co_apic_write(CO_APIC_ID, co_apic_read(CO_APIC_ID) | CO_APIC_ENABLE);
+
+	printk(KERN_INFO "Cobalt APIC enabled: ID reg %#lx\n",
+		co_apic_read(CO_APIC_ID));
+}
+
+int __init visws_trap_init_quirk(void)
+{
+	lithium_init();
+	cobalt_init();
+
+	return 1;
+}
+
+/*
+ * IRQ controller / APIC support:
+ */
+
+static DEFINE_SPINLOCK(cobalt_lock);
+
+/*
+ * Set the given Cobalt APIC Redirection Table entry to point
+ * to the given IDT vector/index.
+ */
+static inline void co_apic_set(int entry, int irq)
+{
+	co_apic_write(CO_APIC_LO(entry), CO_APIC_LEVEL | (irq + FIRST_EXTERNAL_VECTOR));
+	co_apic_write(CO_APIC_HI(entry), 0);
+}
+
+/*
+ * Cobalt (IO)-APIC functions to handle PCI devices.
+ */
+static inline int co_apic_ide0_hack(void)
+{
+	extern char visws_board_type;
+	extern char visws_board_rev;
+
+	if (visws_board_type == VISWS_320 && visws_board_rev == 5)
+		return 5;
+	return CO_APIC_IDE0;
+}
+
+static int is_co_apic(unsigned int irq)
+{
+	if (IS_CO_APIC(irq))
+		return CO_APIC(irq);
+
+	switch (irq) {
+		case 0: return CO_APIC_CPU;
+		case CO_IRQ_IDE0: return co_apic_ide0_hack();
+		case CO_IRQ_IDE1: return CO_APIC_IDE1;
+		default: return -1;
+	}
+}
+
+
+/*
+ * This is the SGI Cobalt (IO-)APIC:
+ */
+
+static void enable_cobalt_irq(unsigned int irq)
+{
+	co_apic_set(is_co_apic(irq), irq);
+}
+
+static void disable_cobalt_irq(unsigned int irq)
+{
+	int entry = is_co_apic(irq);
+
+	co_apic_write(CO_APIC_LO(entry), CO_APIC_MASK);
+	co_apic_read(CO_APIC_LO(entry));
+}
+
+/*
+ * "irq" really just serves to identify the device.  Here is where we
+ * map this to the Cobalt APIC entry where it's physically wired.
+ * This is called via request_irq -> setup_irq -> irq_desc->startup()
+ */
+static unsigned int startup_cobalt_irq(unsigned int irq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cobalt_lock, flags);
+	if ((irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
+		irq_desc[irq].status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
+	enable_cobalt_irq(irq);
+	spin_unlock_irqrestore(&cobalt_lock, flags);
+	return 0;
+}
+
+static void ack_cobalt_irq(unsigned int irq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cobalt_lock, flags);
+	disable_cobalt_irq(irq);
+	apic_write(APIC_EOI, APIC_EIO_ACK);
+	spin_unlock_irqrestore(&cobalt_lock, flags);
+}
+
+static void end_cobalt_irq(unsigned int irq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cobalt_lock, flags);
+	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
+		enable_cobalt_irq(irq);
+	spin_unlock_irqrestore(&cobalt_lock, flags);
+}
+
+static struct irq_chip cobalt_irq_type = {
+	.typename =	"Cobalt-APIC",
+	.startup =	startup_cobalt_irq,
+	.shutdown =	disable_cobalt_irq,
+	.enable =	enable_cobalt_irq,
+	.disable =	disable_cobalt_irq,
+	.ack =		ack_cobalt_irq,
+	.end =		end_cobalt_irq,
+};
+
+
+/*
+ * This is the PIIX4-based 8259 that is wired up indirectly to Cobalt
+ * -- not the manner expected by the code in i8259.c.
+ *
+ * there is a 'master' physical interrupt source that gets sent to
+ * the CPU. But in the chipset there are various 'virtual' interrupts
+ * waiting to be handled. We represent this to Linux through a 'master'
+ * interrupt controller type, and through a special virtual interrupt-
+ * controller. Device drivers only see the virtual interrupt sources.
+ */
+static unsigned int startup_piix4_master_irq(unsigned int irq)
+{
+	init_8259A(0);
+
+	return startup_cobalt_irq(irq);
+}
+
+static void end_piix4_master_irq(unsigned int irq)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&cobalt_lock, flags);
+	enable_cobalt_irq(irq);
+	spin_unlock_irqrestore(&cobalt_lock, flags);
+}
+
+static struct irq_chip piix4_master_irq_type = {
+	.typename =	"PIIX4-master",
+	.startup =	startup_piix4_master_irq,
+	.ack =		ack_cobalt_irq,
+	.end =		end_piix4_master_irq,
+};
+
+
+static struct irq_chip piix4_virtual_irq_type = {
+	.typename =	"PIIX4-virtual",
+	.shutdown =	disable_8259A_irq,
+	.enable =	enable_8259A_irq,
+	.disable =	disable_8259A_irq,
+};
+
+
+/*
+ * PIIX4-8259 master/virtual functions to handle interrupt requests
+ * from legacy devices: floppy, parallel, serial, rtc.
+ *
+ * None of these get Cobalt APIC entries, neither do they have IDT
+ * entries. These interrupts are purely virtual and distributed from
+ * the 'master' interrupt source: CO_IRQ_8259.
+ *
+ * When the 8259 interrupts its handler figures out which of these
+ * devices is interrupting and dispatches to its handler.
+ *
+ * CAREFUL: devices see the 'virtual' interrupt only. Thus disable/
+ * enable_irq gets the right irq. This 'master' irq is never directly
+ * manipulated by any driver.
+ */
+static irqreturn_t piix4_master_intr(int irq, void *dev_id)
+{
+	int realirq;
+	irq_desc_t *desc;
+	unsigned long flags;
+
+	spin_lock_irqsave(&i8259A_lock, flags);
+
+	/* Find out what's interrupting in the PIIX4 master 8259 */
+	outb(0x0c, 0x20);		/* OCW3 Poll command */
+	realirq = inb(0x20);
+
+	/*
+	 * Bit 7 == 0 means invalid/spurious
+	 */
+	if (unlikely(!(realirq & 0x80)))
+		goto out_unlock;
+
+	realirq &= 7;
+
+	if (unlikely(realirq == 2)) {
+		outb(0x0c, 0xa0);
+		realirq = inb(0xa0);
+
+		if (unlikely(!(realirq & 0x80)))
+			goto out_unlock;
+
+		realirq = (realirq & 7) + 8;
+	}
+
+	/* mask and ack interrupt */
+	cached_irq_mask |= 1 << realirq;
+	if (unlikely(realirq > 7)) {
+		inb(0xa1);
+		outb(cached_slave_mask, 0xa1);
+		outb(0x60 + (realirq & 7), 0xa0);
+		outb(0x60 + 2, 0x20);
+	} else {
+		inb(0x21);
+		outb(cached_master_mask, 0x21);
+		outb(0x60 + realirq, 0x20);
+	}
+
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+
+	desc = irq_desc + realirq;
+
+	/*
+	 * handle this 'virtual interrupt' as a Cobalt one now.
+	 */
+	kstat_cpu(smp_processor_id()).irqs[realirq]++;
+
+	if (likely(desc->action != NULL))
+		handle_IRQ_event(realirq, desc->action);
+
+	if (!(desc->status & IRQ_DISABLED))
+		enable_8259A_irq(realirq);
+
+	return IRQ_HANDLED;
+
+out_unlock:
+	spin_unlock_irqrestore(&i8259A_lock, flags);
+	return IRQ_NONE;
+}
+
+static struct irqaction master_action = {
+	.handler =	piix4_master_intr,
+	.name =		"PIIX4-8259",
+};
+
+static struct irqaction cascade_action = {
+	.handler = 	no_action,
+	.name =		"cascade",
+};
+
+
+void init_VISWS_APIC_irqs(void)
+{
+	int i;
+
+	for (i = 0; i < CO_IRQ_APIC0 + CO_APIC_LAST + 1; i++) {
+		irq_desc[i].status = IRQ_DISABLED;
+		irq_desc[i].action = 0;
+		irq_desc[i].depth = 1;
+
+		if (i == 0) {
+			irq_desc[i].chip = &cobalt_irq_type;
+		}
+		else if (i == CO_IRQ_IDE0) {
+			irq_desc[i].chip = &cobalt_irq_type;
+		}
+		else if (i == CO_IRQ_IDE1) {
+			irq_desc[i].chip = &cobalt_irq_type;
+		}
+		else if (i == CO_IRQ_8259) {
+			irq_desc[i].chip = &piix4_master_irq_type;
+		}
+		else if (i < CO_IRQ_APIC0) {
+			irq_desc[i].chip = &piix4_virtual_irq_type;
+		}
+		else if (IS_CO_APIC(i)) {
+			irq_desc[i].chip = &cobalt_irq_type;
+		}
+	}
+
+	setup_irq(CO_IRQ_8259, &master_action);
+	setup_irq(2, &cascade_action);
+}
diff --git a/arch/x86/lguest/Kconfig b/arch/x86/lguest/Kconfig
index 964dfa3..c70e12b 100644
--- a/arch/x86/lguest/Kconfig
+++ b/arch/x86/lguest/Kconfig
@@ -3,7 +3,7 @@ config LGUEST_GUEST
 	select PARAVIRT
 	depends on X86_32
 	depends on !X86_PAE
-	depends on !(X86_VISWS || X86_VOYAGER)
+	depends on !X86_VOYAGER
 	select VIRTIO
 	select VIRTIO_RING
 	select VIRTIO_CONSOLE
diff --git a/arch/x86/mach-default/setup.c b/arch/x86/mach-default/setup.c
index 2f5e277..48278fa 100644
--- a/arch/x86/mach-default/setup.c
+++ b/arch/x86/mach-default/setup.c
@@ -10,6 +10,14 @@
 #include <asm/e820.h>
 #include <asm/setup.h>
 
+/*
+ * Any quirks to be performed to initialize timers/irqs/etc?
+ */
+int (*arch_time_init_quirk)(void);
+int (*arch_pre_intr_init_quirk)(void);
+int (*arch_intr_init_quirk)(void);
+int (*arch_trap_init_quirk)(void);
+
 #ifdef CONFIG_HOTPLUG_CPU
 #define DEFAULT_SEND_IPI	(1)
 #else
@@ -29,6 +37,10 @@ int no_broadcast=DEFAULT_SEND_IPI;
  **/
 void __init pre_intr_init_hook(void)
 {
+	if (arch_pre_intr_init_quirk) {
+		if (arch_pre_intr_init_quirk())
+			return;
+	}
 	init_ISA_irqs();
 }
 
@@ -52,6 +64,10 @@ static struct irqaction irq2 = {
  **/
 void __init intr_init_hook(void)
 {
+	if (arch_intr_init_quirk) {
+		if (arch_intr_init_quirk())
+			return;
+	}
 #ifdef CONFIG_X86_LOCAL_APIC
 	apic_intr_init();
 #endif
@@ -65,7 +81,7 @@ void __init intr_init_hook(void)
  *
  * Description:
  *	generally used to activate any machine specific identification
- *	routines that may be needed before setup_arch() runs.  On VISWS
+ *	routines that may be needed before setup_arch() runs.  On Voyager
  *	this is used to get the board revision and type.
  **/
 void __init pre_setup_arch_hook(void)
@@ -81,6 +97,10 @@ void __init pre_setup_arch_hook(void)
  **/
 void __init trap_init_hook(void)
 {
+	if (arch_trap_init_quirk) {
+		if (arch_trap_init_quirk())
+			return;
+	}
 }
 
 static struct irqaction irq0  = {
@@ -99,6 +119,16 @@ static struct irqaction irq0  = {
  **/
 void __init time_init_hook(void)
 {
+	if (arch_time_init_quirk) {
+		/*
+		 * A nonzero return code does not mean failure, it means
+		 * that the architecture quirk does not want any
+		 * generic (timer) setup to be performed after this:
+		 */
+		if (arch_time_init_quirk())
+			return;
+	}
+
 	irq0.mask = cpumask_of_cpu(0);
 	setup_irq(0, &irq0);
 }
diff --git a/arch/x86/mach-visws/Makefile b/arch/x86/mach-visws/Makefile
deleted file mode 100644
index 835fd96..0000000
--- a/arch/x86/mach-visws/Makefile
+++ /dev/null
@@ -1,8 +0,0 @@
-#
-# Makefile for the linux kernel.
-#
-
-obj-y				:= setup.o traps.o reboot.o
-
-obj-$(CONFIG_X86_VISWS_APIC)	+= visws_apic.o
-obj-$(CONFIG_X86_LOCAL_APIC)	+= mpparse.o
diff --git a/arch/x86/mach-visws/mpparse.c b/arch/x86/mach-visws/mpparse.c
deleted file mode 100644
index a2fb78c..0000000
--- a/arch/x86/mach-visws/mpparse.c
+++ /dev/null
@@ -1,85 +0,0 @@
-
-#include <linux/init.h>
-#include <linux/smp.h>
-
-#include <asm/smp.h>
-#include <asm/io.h>
-
-#include "cobalt.h"
-#include "mach_apic.h"
-
-extern unsigned int __cpuinitdata maxcpus;
-
-/*
- * The Visual Workstation is Intel MP compliant in the hardware
- * sense, but it doesn't have a BIOS(-configuration table).
- * No problem for Linux.
- */
-
-static void __init MP_processor_info (struct mpc_config_processor *m)
-{
-	int ver, logical_apicid;
-	physid_mask_t apic_cpus;
-
-	if (!(m->mpc_cpuflag & CPU_ENABLED))
-		return;
-
-	logical_apicid = m->mpc_apicid;
-	printk(KERN_INFO "%sCPU #%d %u:%u APIC version %d\n",
-	       m->mpc_cpuflag & CPU_BOOTPROCESSOR ? "Bootup " : "",
-	       m->mpc_apicid,
-	       (m->mpc_cpufeature & CPU_FAMILY_MASK) >> 8,
-	       (m->mpc_cpufeature & CPU_MODEL_MASK) >> 4,
-	       m->mpc_apicver);
-
-	if (m->mpc_cpuflag & CPU_BOOTPROCESSOR)
-		boot_cpu_physical_apicid = m->mpc_apicid;
-
-	ver = m->mpc_apicver;
-	if ((ver >= 0x14 && m->mpc_apicid >= 0xff) || m->mpc_apicid >= 0xf) {
-		printk(KERN_ERR "Processor #%d INVALID. (Max ID: %d).\n",
-			m->mpc_apicid, MAX_APICS);
-		return;
-	}
-
-	apic_cpus = apicid_to_cpu_present(m->mpc_apicid);
-	physids_or(phys_cpu_present_map, phys_cpu_present_map, apic_cpus);
-	/*
-	 * Validate version
-	 */
-	if (ver == 0x0) {
-		printk(KERN_ERR "BIOS bug, APIC version is 0 for CPU#%d! "
-			"fixing up to 0x10. (tell your hw vendor)\n",
-			m->mpc_apicid);
-		ver = 0x10;
-	}
-	apic_version[m->mpc_apicid] = ver;
-}
-
-void __init find_smp_config(void)
-{
-	struct mpc_config_processor *mp = phys_to_virt(CO_CPU_TAB_PHYS);
-	unsigned short ncpus = readw(phys_to_virt(CO_CPU_NUM_PHYS));
-
-	if (ncpus > CO_CPU_MAX) {
-		printk(KERN_WARNING "find_visws_smp: got cpu count of %d at %p\n",
-			ncpus, mp);
-
-		ncpus = CO_CPU_MAX;
-	}
-
-	if (ncpus > maxcpus)
-		ncpus = maxcpus;
-
-#ifdef CONFIG_X86_LOCAL_APIC
-	smp_found_config = 1;
-#endif
-	while (ncpus--)
-		MP_processor_info(mp++);
-
-	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
-}
-
-void __init get_smp_config (void)
-{
-}
diff --git a/arch/x86/mach-visws/reboot.c b/arch/x86/mach-visws/reboot.c
deleted file mode 100644
index 99332ab..0000000
--- a/arch/x86/mach-visws/reboot.c
+++ /dev/null
@@ -1,55 +0,0 @@
-#include <linux/module.h>
-#include <linux/smp.h>
-#include <linux/delay.h>
-
-#include <asm/io.h>
-#include "piix4.h"
-
-void (*pm_power_off)(void);
-EXPORT_SYMBOL(pm_power_off);
-
-void machine_shutdown(void)
-{
-#ifdef CONFIG_SMP
-	smp_send_stop();
-#endif
-}
-
-void machine_emergency_restart(void)
-{
-	/*
-	 * Visual Workstations restart after this
-	 * register is poked on the PIIX4
-	 */
-	outb(PIIX4_RESET_VAL, PIIX4_RESET_PORT);
-}
-
-void machine_restart(char * __unused)
-{
-	machine_shutdown();
-	machine_emergency_restart();
-}
-
-void machine_power_off(void)
-{
-	unsigned short pm_status;
-	extern unsigned int pci_bus0;
-
-	while ((pm_status = inw(PMSTS_PORT)) & 0x100)
-		outw(pm_status, PMSTS_PORT);
-
-	outw(PM_SUSPEND_ENABLE, PMCNTRL_PORT);
-
-	mdelay(10);
-
-#define PCI_CONF1_ADDRESS(bus, devfn, reg) \
-	(0x80000000 | (bus << 16) | (devfn << 8) | (reg & ~3))
-
-	outl(PCI_CONF1_ADDRESS(pci_bus0, SPECIAL_DEV, SPECIAL_REG), 0xCF8);
-	outl(PIIX_SPECIAL_STOP, 0xCFC);
-}
-
-void machine_halt(void)
-{
-}
-
diff --git a/arch/x86/mach-visws/setup.c b/arch/x86/mach-visws/setup.c
deleted file mode 100644
index d67868e..0000000
--- a/arch/x86/mach-visws/setup.c
+++ /dev/null
@@ -1,183 +0,0 @@
-/*
- *  Unmaintained SGI Visual Workstation support.
- *  Split out from setup.c by davej@suse.de
- */
-
-#include <linux/smp.h>
-#include <linux/init.h>
-#include <linux/interrupt.h>
-#include <linux/module.h>
-
-#include <asm/fixmap.h>
-#include <asm/arch_hooks.h>
-#include <asm/io.h>
-#include <asm/e820.h>
-#include <asm/setup.h>
-#include "cobalt.h"
-#include "piix4.h"
-
-int no_broadcast;
-
-char visws_board_type = -1;
-char visws_board_rev = -1;
-
-void __init visws_get_board_type_and_rev(void)
-{
-	int raw;
-
-	visws_board_type = (char)(inb_p(PIIX_GPI_BD_REG) & PIIX_GPI_BD_REG)
-							 >> PIIX_GPI_BD_SHIFT;
-	/*
-	 * Get Board rev.
-	 * First, we have to initialize the 307 part to allow us access
-	 * to the GPIO registers.  Let's map them at 0x0fc0 which is right
-	 * after the PIIX4 PM section.
-	 */
-	outb_p(SIO_DEV_SEL, SIO_INDEX);
-	outb_p(SIO_GP_DEV, SIO_DATA);	/* Talk to GPIO regs. */
-
-	outb_p(SIO_DEV_MSB, SIO_INDEX);
-	outb_p(SIO_GP_MSB, SIO_DATA);	/* MSB of GPIO base address */
-
-	outb_p(SIO_DEV_LSB, SIO_INDEX);
-	outb_p(SIO_GP_LSB, SIO_DATA);	/* LSB of GPIO base address */
-
-	outb_p(SIO_DEV_ENB, SIO_INDEX);
-	outb_p(1, SIO_DATA);		/* Enable GPIO registers. */
-
-	/*
-	 * Now, we have to map the power management section to write
-	 * a bit which enables access to the GPIO registers.
-	 * What lunatic came up with this shit?
-	 */
-	outb_p(SIO_DEV_SEL, SIO_INDEX);
-	outb_p(SIO_PM_DEV, SIO_DATA);	/* Talk to GPIO regs. */
-
-	outb_p(SIO_DEV_MSB, SIO_INDEX);
-	outb_p(SIO_PM_MSB, SIO_DATA);	/* MSB of PM base address */
-
-	outb_p(SIO_DEV_LSB, SIO_INDEX);
-	outb_p(SIO_PM_LSB, SIO_DATA);	/* LSB of PM base address */
-
-	outb_p(SIO_DEV_ENB, SIO_INDEX);
-	outb_p(1, SIO_DATA);		/* Enable PM registers. */
-
-	/*
-	 * Now, write the PM register which enables the GPIO registers.
-	 */
-	outb_p(SIO_PM_FER2, SIO_PM_INDEX);
-	outb_p(SIO_PM_GP_EN, SIO_PM_DATA);
-
-	/*
-	 * Now, initialize the GPIO registers.
-	 * We want them all to be inputs which is the
-	 * power on default, so let's leave them alone.
-	 * So, let's just read the board rev!
-	 */
-	raw = inb_p(SIO_GP_DATA1);
-	raw &= 0x7f;	/* 7 bits of valid board revision ID. */
-
-	if (visws_board_type == VISWS_320) {
-		if (raw < 0x6) {
-			visws_board_rev = 4;
-		} else if (raw < 0xc) {
-			visws_board_rev = 5;
-		} else {
-			visws_board_rev = 6;
-		}
-	} else if (visws_board_type == VISWS_540) {
-			visws_board_rev = 2;
-		} else {
-			visws_board_rev = raw;
-		}
-
-	printk(KERN_INFO "Silicon Graphics Visual Workstation %s (rev %d) detected\n",
-	       (visws_board_type == VISWS_320 ? "320" :
-	       (visws_board_type == VISWS_540 ? "540" :
-		"unknown")), visws_board_rev);
-}
-
-void __init pre_intr_init_hook(void)
-{
-	init_VISWS_APIC_irqs();
-}
-
-void __init intr_init_hook(void)
-{
-#ifdef CONFIG_X86_LOCAL_APIC
-	apic_intr_init();
-#endif
-}
-
-void __init pre_setup_arch_hook()
-{
-	visws_get_board_type_and_rev();
-}
-
-static struct irqaction irq0 = {
-	.handler =	timer_interrupt,
-	.flags =	IRQF_DISABLED | IRQF_IRQPOLL,
-	.name =		"timer",
-};
-
-void __init time_init_hook(void)
-{
-	printk(KERN_INFO "Starting Cobalt Timer system clock\n");
-
-	/* Set the countdown value */
-	co_cpu_write(CO_CPU_TIMEVAL, CO_TIME_HZ/HZ);
-
-	/* Start the timer */
-	co_cpu_write(CO_CPU_CTRL, co_cpu_read(CO_CPU_CTRL) | CO_CTRL_TIMERUN);
-
-	/* Enable (unmask) the timer interrupt */
-	co_cpu_write(CO_CPU_CTRL, co_cpu_read(CO_CPU_CTRL) & ~CO_CTRL_TIMEMASK);
-
-	/* Wire cpu IDT entry to s/w handler (and Cobalt APIC to IDT) */
-	setup_irq(0, &irq0);
-}
-
-/* Hook for machine specific memory setup. */
-
-#define MB (1024 * 1024)
-
-unsigned long sgivwfb_mem_phys;
-unsigned long sgivwfb_mem_size;
-EXPORT_SYMBOL(sgivwfb_mem_phys);
-EXPORT_SYMBOL(sgivwfb_mem_size);
-
-long long mem_size __initdata = 0;
-
-char * __init machine_specific_memory_setup(void)
-{
-	long long gfx_mem_size = 8 * MB;
-
-	mem_size = boot_params.alt_mem_k;
-
-	if (!mem_size) {
-		printk(KERN_WARNING "Bootloader didn't set memory size, upgrade it !\n");
-		mem_size = 128 * MB;
-	}
-
-	/*
-	 * this hardcodes the graphics memory to 8 MB
-	 * it really should be sized dynamically (or at least
-	 * set as a boot param)
-	 */
-	if (!sgivwfb_mem_size) {
-		printk(KERN_WARNING "Defaulting to 8 MB framebuffer size\n");
-		sgivwfb_mem_size = 8 * MB;
-	}
-
-	/*
-	 * Trim to nearest MB
-	 */
-	sgivwfb_mem_size &= ~((1 << 20) - 1);
-	sgivwfb_mem_phys = mem_size - gfx_mem_size;
-
-	e820_add_region(0, LOWMEMSIZE(), E820_RAM);
-	e820_add_region(HIGH_MEMORY, mem_size - sgivwfb_mem_size - HIGH_MEMORY, E820_RAM);
-	e820_add_region(sgivwfb_mem_phys, sgivwfb_mem_size, E820_RESERVED);
-
-	return "PROM";
-}
diff --git a/arch/x86/mach-visws/traps.c b/arch/x86/mach-visws/traps.c
deleted file mode 100644
index bfac6ba..0000000
--- a/arch/x86/mach-visws/traps.c
+++ /dev/null
@@ -1,69 +0,0 @@
-/* VISWS traps */
-
-#include <linux/sched.h>
-#include <linux/kernel.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/pci_ids.h>
-
-#include <asm/io.h>
-#include <asm/arch_hooks.h>
-#include <asm/apic.h>
-#include "cobalt.h"
-#include "lithium.h"
-
-
-#define A01234 (LI_INTA_0 | LI_INTA_1 | LI_INTA_2 | LI_INTA_3 | LI_INTA_4)
-#define BCD (LI_INTB | LI_INTC | LI_INTD)
-#define ALLDEVS (A01234 | BCD)
-
-static __init void lithium_init(void)
-{
-	set_fixmap(FIX_LI_PCIA, LI_PCI_A_PHYS);
-	set_fixmap(FIX_LI_PCIB, LI_PCI_B_PHYS);
-
-	if ((li_pcia_read16(PCI_VENDOR_ID) != PCI_VENDOR_ID_SGI) ||
-	    (li_pcia_read16(PCI_DEVICE_ID) != PCI_DEVICE_ID_SGI_LITHIUM)) {
-		printk(KERN_EMERG "Lithium hostbridge %c not found\n", 'A');
-		panic("This machine is not SGI Visual Workstation 320/540");
-	}
-
-	if ((li_pcib_read16(PCI_VENDOR_ID) != PCI_VENDOR_ID_SGI) ||
-	    (li_pcib_read16(PCI_DEVICE_ID) != PCI_DEVICE_ID_SGI_LITHIUM)) {
-		printk(KERN_EMERG "Lithium hostbridge %c not found\n", 'B');
-		panic("This machine is not SGI Visual Workstation 320/540");
-	}
-
-	li_pcia_write16(LI_PCI_INTEN, ALLDEVS);
-	li_pcib_write16(LI_PCI_INTEN, ALLDEVS);
-}
-
-static __init void cobalt_init(void)
-{
-	/*
-	 * On normal SMP PC this is used only with SMP, but we have to
-	 * use it and set it up here to start the Cobalt clock
-	 */
-	set_fixmap(FIX_APIC_BASE, APIC_DEFAULT_PHYS_BASE);
-	setup_local_APIC();
-	printk(KERN_INFO "Local APIC Version %#x, ID %#x\n",
-		(unsigned int)apic_read(APIC_LVR),
-		(unsigned int)apic_read(APIC_ID));
-
-	set_fixmap(FIX_CO_CPU, CO_CPU_PHYS);
-	set_fixmap(FIX_CO_APIC, CO_APIC_PHYS);
-	printk(KERN_INFO "Cobalt Revision %#lx, APIC ID %#lx\n",
-		co_cpu_read(CO_CPU_REV), co_apic_read(CO_APIC_ID));
-
-	/* Enable Cobalt APIC being careful to NOT change the ID! */
-	co_apic_write(CO_APIC_ID, co_apic_read(CO_APIC_ID) | CO_APIC_ENABLE);
-
-	printk(KERN_INFO "Cobalt APIC enabled: ID reg %#lx\n",
-		co_apic_read(CO_APIC_ID));
-}
-
-void __init trap_init_hook(void)
-{
-	lithium_init();
-	cobalt_init();
-}
diff --git a/arch/x86/mach-visws/visws_apic.c b/arch/x86/mach-visws/visws_apic.c
deleted file mode 100644
index d8b2cfd..0000000
--- a/arch/x86/mach-visws/visws_apic.c
+++ /dev/null
@@ -1,296 +0,0 @@
-/*
- *	Copyright (C) 1999 Bent Hagemark, Ingo Molnar
- *
- *  SGI Visual Workstation interrupt controller
- *
- *  The Cobalt system ASIC in the Visual Workstation contains a "Cobalt" APIC
- *  which serves as the main interrupt controller in the system.  Non-legacy
- *  hardware in the system uses this controller directly.  Legacy devices
- *  are connected to the PIIX4 which in turn has its 8259(s) connected to
- *  a of the Cobalt APIC entry.
- *
- *  09/02/2000 - Updated for 2.4 by jbarnes@sgi.com
- *
- *  25/11/2002 - Updated for 2.5 by Andrey Panin <pazke@orbita1.ru>
- */
-
-#include <linux/kernel_stat.h>
-#include <linux/interrupt.h>
-#include <linux/init.h>
-
-#include <asm/io.h>
-#include <asm/apic.h>
-#include <asm/i8259.h>
-#include <asm/irq_vectors.h>
-
-#include "cobalt.h"
-
-static DEFINE_SPINLOCK(cobalt_lock);
-
-/*
- * Set the given Cobalt APIC Redirection Table entry to point
- * to the given IDT vector/index.
- */
-static inline void co_apic_set(int entry, int irq)
-{
-	co_apic_write(CO_APIC_LO(entry), CO_APIC_LEVEL | (irq + FIRST_EXTERNAL_VECTOR));
-	co_apic_write(CO_APIC_HI(entry), 0);
-}
-
-/*
- * Cobalt (IO)-APIC functions to handle PCI devices.
- */
-static inline int co_apic_ide0_hack(void)
-{
-	extern char visws_board_type;
-	extern char visws_board_rev;
-
-	if (visws_board_type == VISWS_320 && visws_board_rev == 5)
-		return 5;
-	return CO_APIC_IDE0;
-}
-
-static int is_co_apic(unsigned int irq)
-{
-	if (IS_CO_APIC(irq))
-		return CO_APIC(irq);
-
-	switch (irq) {
-		case 0: return CO_APIC_CPU;
-		case CO_IRQ_IDE0: return co_apic_ide0_hack();
-		case CO_IRQ_IDE1: return CO_APIC_IDE1;
-		default: return -1;
-	}
-}
-
-
-/*
- * This is the SGI Cobalt (IO-)APIC:
- */
-
-static void enable_cobalt_irq(unsigned int irq)
-{
-	co_apic_set(is_co_apic(irq), irq);
-}
-
-static void disable_cobalt_irq(unsigned int irq)
-{
-	int entry = is_co_apic(irq);
-
-	co_apic_write(CO_APIC_LO(entry), CO_APIC_MASK);
-	co_apic_read(CO_APIC_LO(entry));
-}
-
-/*
- * "irq" really just serves to identify the device.  Here is where we
- * map this to the Cobalt APIC entry where it's physically wired.
- * This is called via request_irq -> setup_irq -> irq_desc->startup()
- */
-static unsigned int startup_cobalt_irq(unsigned int irq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cobalt_lock, flags);
-	if ((irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING)))
-		irq_desc[irq].status &= ~(IRQ_DISABLED | IRQ_INPROGRESS | IRQ_WAITING);
-	enable_cobalt_irq(irq);
-	spin_unlock_irqrestore(&cobalt_lock, flags);
-	return 0;
-}
-
-static void ack_cobalt_irq(unsigned int irq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cobalt_lock, flags);
-	disable_cobalt_irq(irq);
-	apic_write(APIC_EOI, APIC_EIO_ACK);
-	spin_unlock_irqrestore(&cobalt_lock, flags);
-}
-
-static void end_cobalt_irq(unsigned int irq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cobalt_lock, flags);
-	if (!(irq_desc[irq].status & (IRQ_DISABLED | IRQ_INPROGRESS)))
-		enable_cobalt_irq(irq);
-	spin_unlock_irqrestore(&cobalt_lock, flags);
-}
-
-static struct irq_chip cobalt_irq_type = {
-	.typename =	"Cobalt-APIC",
-	.startup =	startup_cobalt_irq,
-	.shutdown =	disable_cobalt_irq,
-	.enable =	enable_cobalt_irq,
-	.disable =	disable_cobalt_irq,
-	.ack =		ack_cobalt_irq,
-	.end =		end_cobalt_irq,
-};
-
-
-/*
- * This is the PIIX4-based 8259 that is wired up indirectly to Cobalt
- * -- not the manner expected by the code in i8259.c.
- *
- * there is a 'master' physical interrupt source that gets sent to
- * the CPU. But in the chipset there are various 'virtual' interrupts
- * waiting to be handled. We represent this to Linux through a 'master'
- * interrupt controller type, and through a special virtual interrupt-
- * controller. Device drivers only see the virtual interrupt sources.
- */
-static unsigned int startup_piix4_master_irq(unsigned int irq)
-{
-	init_8259A(0);
-
-	return startup_cobalt_irq(irq);
-}
-
-static void end_piix4_master_irq(unsigned int irq)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&cobalt_lock, flags);
-	enable_cobalt_irq(irq);
-	spin_unlock_irqrestore(&cobalt_lock, flags);
-}
-
-static struct irq_chip piix4_master_irq_type = {
-	.typename =	"PIIX4-master",
-	.startup =	startup_piix4_master_irq,
-	.ack =		ack_cobalt_irq,
-	.end =		end_piix4_master_irq,
-};
-
-
-static struct irq_chip piix4_virtual_irq_type = {
-	.typename =	"PIIX4-virtual",
-	.shutdown =	disable_8259A_irq,
-	.enable =	enable_8259A_irq,
-	.disable =	disable_8259A_irq,
-};
-
-
-/*
- * PIIX4-8259 master/virtual functions to handle interrupt requests
- * from legacy devices: floppy, parallel, serial, rtc.
- *
- * None of these get Cobalt APIC entries, neither do they have IDT
- * entries. These interrupts are purely virtual and distributed from
- * the 'master' interrupt source: CO_IRQ_8259.
- *
- * When the 8259 interrupts its handler figures out which of these
- * devices is interrupting and dispatches to its handler.
- *
- * CAREFUL: devices see the 'virtual' interrupt only. Thus disable/
- * enable_irq gets the right irq. This 'master' irq is never directly
- * manipulated by any driver.
- */
-static irqreturn_t piix4_master_intr(int irq, void *dev_id)
-{
-	int realirq;
-	irq_desc_t *desc;
-	unsigned long flags;
-
-	spin_lock_irqsave(&i8259A_lock, flags);
-
-	/* Find out what's interrupting in the PIIX4 master 8259 */
-	outb(0x0c, 0x20);		/* OCW3 Poll command */
-	realirq = inb(0x20);
-
-	/*
-	 * Bit 7 == 0 means invalid/spurious
-	 */
-	if (unlikely(!(realirq & 0x80)))
-		goto out_unlock;
-
-	realirq &= 7;
-
-	if (unlikely(realirq == 2)) {
-		outb(0x0c, 0xa0);
-		realirq = inb(0xa0);
-
-		if (unlikely(!(realirq & 0x80)))
-			goto out_unlock;
-
-		realirq = (realirq & 7) + 8;
-	}
-
-	/* mask and ack interrupt */
-	cached_irq_mask |= 1 << realirq;
-	if (unlikely(realirq > 7)) {
-		inb(0xa1);
-		outb(cached_slave_mask, 0xa1);
-		outb(0x60 + (realirq & 7), 0xa0);
-		outb(0x60 + 2, 0x20);
-	} else {
-		inb(0x21);
-		outb(cached_master_mask, 0x21);
-		outb(0x60 + realirq, 0x20);
-	}
-
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-
-	desc = irq_desc + realirq;
-
-	/*
-	 * handle this 'virtual interrupt' as a Cobalt one now.
-	 */
-	kstat_cpu(smp_processor_id()).irqs[realirq]++;
-
-	if (likely(desc->action != NULL))
-		handle_IRQ_event(realirq, desc->action);
-
-	if (!(desc->status & IRQ_DISABLED))
-		enable_8259A_irq(realirq);
-
-	return IRQ_HANDLED;
-
-out_unlock:
-	spin_unlock_irqrestore(&i8259A_lock, flags);
-	return IRQ_NONE;
-}
-
-static struct irqaction master_action = {
-	.handler =	piix4_master_intr,
-	.name =		"PIIX4-8259",
-};
-
-static struct irqaction cascade_action = {
-	.handler = 	no_action,
-	.name =		"cascade",
-};
-
-
-void init_VISWS_APIC_irqs(void)
-{
-	int i;
-
-	for (i = 0; i < CO_IRQ_APIC0 + CO_APIC_LAST + 1; i++) {
-		irq_desc[i].status = IRQ_DISABLED;
-		irq_desc[i].action = 0;
-		irq_desc[i].depth = 1;
-
-		if (i == 0) {
-			irq_desc[i].chip = &cobalt_irq_type;
-		}
-		else if (i == CO_IRQ_IDE0) {
-			irq_desc[i].chip = &cobalt_irq_type;
-		}
-		else if (i == CO_IRQ_IDE1) {
-			irq_desc[i].chip = &cobalt_irq_type;
-		}
-		else if (i == CO_IRQ_8259) {
-			irq_desc[i].chip = &piix4_master_irq_type;
-		}
-		else if (i < CO_IRQ_APIC0) {
-			irq_desc[i].chip = &piix4_virtual_irq_type;
-		}
-		else if (IS_CO_APIC(i)) {
-			irq_desc[i].chip = &cobalt_irq_type;
-		}
-	}
-
-	setup_irq(CO_IRQ_8259, &master_action);
-	setup_irq(2, &cascade_action);
-}
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index 99d9f09..e515e8d 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -9,9 +9,7 @@ pci-y				:= fixup.o
 pci-$(CONFIG_ACPI)		+= acpi.o
 pci-y				+= legacy.o irq.o
 
-# Careful: VISWS overrule the pci-y above. The colons are
-# therefor correct. This needs a proper fix by distangling the code.
-pci-$(CONFIG_X86_VISWS)		:= visws.o fixup.o
+pci-$(CONFIG_X86_VISWS)		+= visws.o
 
 pci-$(CONFIG_X86_NUMAQ)		+= numa.o
 
diff --git a/arch/x86/pci/visws.c b/arch/x86/pci/visws.c
index 16e5206..1a7bed4 100644
--- a/arch/x86/pci/visws.c
+++ b/arch/x86/pci/visws.c
@@ -8,18 +8,19 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 
-#include "cobalt.h"
-#include "lithium.h"
+#include <asm/setup.h>
+#include <asm/visws/cobalt.h>
+#include <asm/visws/lithium.h>
 
 #include "pci.h"
 
 static int pci_visws_enable_irq(struct pci_dev *dev) { return 0; }
 static void pci_visws_disable_irq(struct pci_dev *dev) { }
 
-int (*pcibios_enable_irq)(struct pci_dev *dev) = &pci_visws_enable_irq;
-void (*pcibios_disable_irq)(struct pci_dev *dev) = &pci_visws_disable_irq;
+/* int (*pcibios_enable_irq)(struct pci_dev *dev) = &pci_visws_enable_irq; */
+/* void (*pcibios_disable_irq)(struct pci_dev *dev) = &pci_visws_disable_irq; */
 
-void __init pcibios_penalize_isa_irq(int irq, int active) {}
+/* void __init pcibios_penalize_isa_irq(int irq, int active) {} */
 
 
 unsigned int pci_bus0, pci_bus1;
@@ -107,7 +108,15 @@ static int __init pci_visws_init(void)
 
 static __init int pci_subsys_init(void)
 {
+	if (!is_visws_box())
+		return -1;
+
+	pcibios_enable_irq = &pci_visws_enable_irq;
+	pcibios_disable_irq = &pci_visws_disable_irq;
+
 	pci_visws_init();
 	pcibios_init();
+
+	return 0;
 }
 subsys_initcall(pci_subsys_init);
diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 860f15f..bba8673 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig ACPI
 	bool "ACPI (Advanced Configuration and Power Interface) Support"
-	depends on !X86_VISWS
 	depends on !IA64_HP_SIM
 	depends on IA64 || X86
 	depends on PCI
diff --git a/drivers/lguest/Kconfig b/drivers/lguest/Kconfig
index 6b8dbb9..76f2b36 100644
--- a/drivers/lguest/Kconfig
+++ b/drivers/lguest/Kconfig
@@ -1,6 +1,6 @@
 config LGUEST
 	tristate "Linux hypervisor example code"
-	depends on X86_32 && EXPERIMENTAL && !X86_PAE && FUTEX && !(X86_VISWS || X86_VOYAGER)
+	depends on X86_32 && EXPERIMENTAL && !X86_PAE && FUTEX && !X86_VOYAGER
 	select HVC_DRIVER
 	---help---
 	  This is a very simple module which allows you to run
diff --git a/drivers/video/sgivwfb.c b/drivers/video/sgivwfb.c
index 4fb1624..f5252c2 100644
--- a/drivers/video/sgivwfb.c
+++ b/drivers/video/sgivwfb.c
@@ -21,8 +21,7 @@
 
 #include <asm/io.h>
 #include <asm/mtrr.h>
-
-#include <setup_arch.h>
+#include <asm/visws/sgivw.h>
 
 #define INCLUDE_TIMING_TABLE_DATA
 #define DBE_REG_BASE par->regs
diff --git a/include/asm-x86/irq_vectors.h b/include/asm-x86/irq_vectors.h
index b58581e..0ac864e 100644
--- a/include/asm-x86/irq_vectors.h
+++ b/include/asm-x86/irq_vectors.h
@@ -107,9 +107,9 @@
 #define LAST_VM86_IRQ		15
 #define invalid_vm86_irq(irq)	((irq) < 3 || (irq) > 15)
 
-#if !defined(CONFIG_X86_VISWS) && !defined(CONFIG_X86_VOYAGER)
+#if !defined(CONFIG_X86_VOYAGER)
 
-# if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT)
+# if defined(CONFIG_X86_IO_APIC) || defined(CONFIG_PARAVIRT) || defined(CONFIG_X86_VISWS)
 
 #  define NR_IRQS		224
 
diff --git a/include/asm-x86/mach-default/smpboot_hooks.h b/include/asm-x86/mach-default/smpboot_hooks.h
index b63c521..56d001b 100644
--- a/include/asm-x86/mach-default/smpboot_hooks.h
+++ b/include/asm-x86/mach-default/smpboot_hooks.h
@@ -3,7 +3,9 @@
 
 static inline void smpboot_clear_io_apic_irqs(void)
 {
+#ifdef CONFIG_X86_IO_APIC
 	io_apic_irqs = 0;
+#endif
 }
 
 static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
@@ -35,6 +37,7 @@ static inline void smpboot_restore_warm_reset_vector(void)
 
 static inline void __init smpboot_setup_io_apic(void)
 {
+#ifdef CONFIG_X86_IO_APIC
 	/*
 	 * Here we can be sure that there is an IO-APIC in the system. Let's
 	 * go and set it up:
@@ -45,9 +48,12 @@ static inline void __init smpboot_setup_io_apic(void)
 		nr_ioapics = 0;
 		localise_nmi_watchdog();
 	}
+#endif
 }
 
 static inline void smpboot_clear_io_apic(void)
 {
+#ifdef CONFIG_X86_IO_APIC
 	nr_ioapics = 0;
+#endif
 }
diff --git a/include/asm-x86/mach-visws/mach_apic.h b/include/asm-x86/mach-visws/mach_apic.h
index a9ef33a..6943e7a 100644
--- a/include/asm-x86/mach-visws/mach_apic.h
+++ b/include/asm-x86/mach-visws/mach_apic.h
@@ -1,103 +1 @@
-#ifndef __ASM_MACH_APIC_H
-#define __ASM_MACH_APIC_H
-
-#include <mach_apicdef.h>
-#include <asm/smp.h>
-
-#define APIC_DFR_VALUE	(APIC_DFR_FLAT)
-
-#define no_balance_irq (0)
-#define esr_disable (0)
-
-#define INT_DELIVERY_MODE dest_LowestPrio
-#define INT_DEST_MODE 1     /* logical delivery broadcast to all procs */
-
-#ifdef CONFIG_SMP
- #define TARGET_CPUS cpu_online_map
-#else
- #define TARGET_CPUS cpumask_of_cpu(0)
-#endif
-
-#define check_apicid_used(bitmap, apicid)	physid_isset(apicid, bitmap)
-#define check_apicid_present(bit)		physid_isset(bit, phys_cpu_present_map)
-
-static inline int apic_id_registered(void)
-{
-	return physid_isset(GET_APIC_ID(read_apic_id()), phys_cpu_present_map);
-}
-
-/*
- * Set up the logical destination ID.
- *
- * Intel recommends to set DFR, LDR and TPR before enabling
- * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
- * document number 292116).  So here it goes...
- */
-static inline void init_apic_ldr(void)
-{
-	unsigned long val;
-
-	apic_write_around(APIC_DFR, APIC_DFR_VALUE);
-	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	val |= SET_APIC_LOGICAL_ID(1UL << smp_processor_id());
-	apic_write_around(APIC_LDR, val);
-}
-
-static inline void summit_check(char *oem, char *productid) 
-{
-}
-
-static inline void setup_apic_routing(void)
-{
-}
-
-static inline int apicid_to_node(int logical_apicid)
-{
-	return 0;
-}
-
-/* Mapping from cpu number to logical apicid */
-static inline int cpu_to_logical_apicid(int cpu)
-{
-	return 1 << cpu;
-}
-
-static inline int cpu_present_to_apicid(int mps_cpu)
-{
-	if (mps_cpu < get_physical_broadcast())
-		return mps_cpu;
-	else
-		return BAD_APICID;
-}
-
-static inline physid_mask_t apicid_to_cpu_present(int apicid)
-{
-	return physid_mask_of_physid(apicid);
-}
-
-#define WAKE_SECONDARY_VIA_INIT
-
-static inline void setup_portio_remap(void)
-{
-}
-
-static inline void enable_apic_mode(void)
-{
-}
-
-static inline int check_phys_apicid_present(int boot_cpu_physical_apicid)
-{
-	return physid_isset(boot_cpu_physical_apicid, phys_cpu_present_map);
-}
-
-static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
-{
-	return cpus_addr(cpumask)[0];
-}
-
-static inline u32 phys_pkg_id(u32 cpuid_apic, int index_msb)
-{
-	return cpuid_apic >> index_msb;
-}
-
-#endif /* __ASM_MACH_APIC_H */
+#include "../mach-default/mach_apic.h"
diff --git a/include/asm-x86/mach-visws/mach_apicdef.h b/include/asm-x86/mach-visws/mach_apicdef.h
index 826cfa9..42711d1 100644
--- a/include/asm-x86/mach-visws/mach_apicdef.h
+++ b/include/asm-x86/mach-visws/mach_apicdef.h
@@ -1,12 +1 @@
-#ifndef __ASM_MACH_APICDEF_H
-#define __ASM_MACH_APICDEF_H
-
-#define         APIC_ID_MASK            (0xF<<24)
-
-static inline unsigned get_apic_id(unsigned long x)
-{
-	        return (((x)>>24)&0xF);
-}
-#define         GET_APIC_ID(x)  get_apic_id(x)
-
-#endif
+#include "../mach-default/mach_apicdef.h"
diff --git a/include/asm-x86/mach-visws/setup_arch.h b/include/asm-x86/mach-visws/setup_arch.h
index b8f5dd8..fa4766c 100644
--- a/include/asm-x86/mach-visws/setup_arch.h
+++ b/include/asm-x86/mach-visws/setup_arch.h
@@ -1,6 +1 @@
-/* Hook to call BIOS initialisation function */
-
-extern unsigned long sgivwfb_mem_phys;
-extern unsigned long sgivwfb_mem_size;
-
-/* no action for visws */
+#include "../mach-default/setup_arch.h"
diff --git a/include/asm-x86/mach-visws/smpboot_hooks.h b/include/asm-x86/mach-visws/smpboot_hooks.h
index c9b83e3..e4433ca 100644
--- a/include/asm-x86/mach-visws/smpboot_hooks.h
+++ b/include/asm-x86/mach-visws/smpboot_hooks.h
@@ -1,28 +1 @@
-static inline void smpboot_setup_warm_reset_vector(unsigned long start_eip)
-{
-	CMOS_WRITE(0xa, 0xf);
-	local_flush_tlb();
-	Dprintk("1.\n");
-	*((volatile unsigned short *) TRAMPOLINE_HIGH) = start_eip >> 4;
-	Dprintk("2.\n");
-	*((volatile unsigned short *) TRAMPOLINE_LOW) = start_eip & 0xf;
-	Dprintk("3.\n");
-}
-
-/* for visws do nothing for any of these */
-
-static inline void smpboot_clear_io_apic_irqs(void)
-{
-}
-
-static inline void smpboot_restore_warm_reset_vector(void)
-{
-}
-
-static inline void smpboot_setup_io_apic(void)
-{
-}
-
-static inline void smpboot_clear_io_apic(void)
-{
-}
+#include "../mach-default/smpboot_hooks.h"
diff --git a/include/asm-x86/setup.h b/include/asm-x86/setup.h
index 1d121c6..90ab222 100644
--- a/include/asm-x86/setup.h
+++ b/include/asm-x86/setup.h
@@ -8,6 +8,25 @@
 /* Interrupt control for vSMPowered x86_64 systems */
 void vsmp_init(void);
 
+#ifdef CONFIG_X86_VISWS
+extern void visws_early_detect(void);
+extern int is_visws_box(void);
+#else
+static inline void visws_early_detect(void) { }
+static inline int is_visws_box(void) { return 0; }
+#endif
+
+/*
+ * Any setup quirks to be performed?
+ */
+extern int (*arch_time_init_quirk)(void);
+extern int (*arch_pre_intr_init_quirk)(void);
+extern int (*arch_intr_init_quirk)(void);
+extern int (*arch_trap_init_quirk)(void);
+extern char * (*arch_memory_setup_quirk)(void);
+extern int (*mach_get_smp_config_quirk)(unsigned int early);
+extern int (*mach_find_smp_config_quirk)(unsigned int reserve);
+
 #ifndef CONFIG_PARAVIRT
 #define paravirt_post_allocator_init()	do {} while (0)
 #endif
diff --git a/include/asm-x86/mach-visws/cobalt.h b/include/asm-x86/visws/cobalt.h
similarity index 100%
rename from include/asm-x86/mach-visws/cobalt.h
rename to include/asm-x86/visws/cobalt.h
diff --git a/include/asm-x86/mach-visws/lithium.h b/include/asm-x86/visws/lithium.h
similarity index 100%
rename from include/asm-x86/mach-visws/lithium.h
rename to include/asm-x86/visws/lithium.h
diff --git a/include/asm-x86/mach-visws/piix4.h b/include/asm-x86/visws/piix4.h
similarity index 100%
rename from include/asm-x86/mach-visws/piix4.h
rename to include/asm-x86/visws/piix4.h
diff --git a/include/asm-x86/visws/sgivw.h b/include/asm-x86/visws/sgivw.h
new file mode 100644
index 0000000..5fbf63e
--- /dev/null
+++ b/include/asm-x86/visws/sgivw.h
@@ -0,0 +1,5 @@
+/*
+ * Frame buffer position and size:
+ */
+extern unsigned long sgivwfb_mem_phys;
+extern unsigned long sgivwfb_mem_size;
