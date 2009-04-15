Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbZDOLFw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbZDOLFw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:05:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZDOLFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:05:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:51136 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025AbZDOLFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:05:42 -0400
Subject: [git-pull -tip] Add -Werror to arch/x86/ files only and fix
 warnings
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 16:34:18 +0530
Message-Id: <1239793458.7653.12.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ingo,

As per your suggestion, I added -Werror for x86/files only and
fix all remaining warnings on 32-bit and 64-bit defconfig and
allnoconfig.

Here is pull request:
The following changes since commit 3965887240cb092f0d568b53165da6a215c7937a:
  Ingo Molnar (1):
        Merge branch 'linus'

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip.git master

Jaswinder Singh Rajput (2):
      x86: Adding -Werror to arch/x86/ files only
      x86: k8.h convert node_to_k8_nb_misc() from a macro to an inline function

 arch/x86/boot/Makefile                 |    3 +++
 arch/x86/boot/compressed/Makefile      |    3 +++
 arch/x86/crypto/Makefile               |    3 +++
 arch/x86/ia32/Makefile                 |    3 +++
 arch/x86/include/asm/k8.h              |   11 ++++++++---
 arch/x86/kernel/Makefile               |    3 +++
 arch/x86/kernel/acpi/Makefile          |    3 +++
 arch/x86/kernel/acpi/realmode/Makefile |    3 +++
 arch/x86/kernel/apic/Makefile          |    3 +++
 arch/x86/kernel/cpu/Makefile           |    3 +++
 arch/x86/kernel/cpu/cpufreq/Makefile   |    3 +++
 arch/x86/kernel/cpu/mcheck/Makefile    |    3 +++
 arch/x86/kernel/cpu/mtrr/Makefile      |    3 +++
 arch/x86/kvm/Makefile                  |    3 +++
 arch/x86/lguest/Makefile               |    3 +++
 arch/x86/lib/Makefile                  |    3 +++
 arch/x86/math-emu/Makefile             |    3 +++
 arch/x86/mm/Makefile                   |    3 +++
 arch/x86/mm/kmemcheck/Makefile         |    3 +++
 arch/x86/oprofile/Makefile             |    3 +++
 arch/x86/pci/Makefile                  |    3 +++
 arch/x86/power/Makefile                |    3 +++
 arch/x86/vdso/Makefile                 |    4 +++-
 arch/x86/video/Makefile                |    3 +++
 arch/x86/xen/Makefile                  |    5 ++++-
 25 files changed, 81 insertions(+), 5 deletions(-)

Complete diff:
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 658bc52..aca7d2f 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -22,6 +22,9 @@ ROOT_DEV	:= CURRENT
 
 SVGA_MODE	:= -DSVGA_MODE=NORMAL_VGA
 
+# Make all warnings into errors
+ccflags-y := -Werror
+
 targets		:= vmlinux.bin setup.bin setup.elf bzImage
 targets		+= fdimage fdimage144 fdimage288 image.iso mtools.conf
 subdir-		:= compressed
diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 65551c9..0f04a55 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -4,6 +4,9 @@
 # create a compressed vmlinux image from the original vmlinux
 #
 
+# Make all warnings into errors
+ccflags-y := -Werror
+
 targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma head_$(BITS).o misc.o piggy.o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index ebe7dee..1b5cbd1 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -2,6 +2,9 @@
 # Arch-specific CryptoAPI modules.
 #
 
+# Make all warnings into errors
+ccflags-y := -Werror
+
 obj-$(CONFIG_CRYPTO_AES_586) += aes-i586.o
 obj-$(CONFIG_CRYPTO_TWOFISH_586) += twofish-i586.o
 obj-$(CONFIG_CRYPTO_SALSA20_586) += salsa20-i586.o
diff --git a/arch/x86/ia32/Makefile b/arch/x86/ia32/Makefile
index 52d0ccf..b9e4eff 100644
--- a/arch/x86/ia32/Makefile
+++ b/arch/x86/ia32/Makefile
@@ -2,6 +2,9 @@
 # Makefile for the ia32 kernel emulation subsystem.
 #
 
+# Make all warnings into errors
+ccflags-y := -Werror
+
 obj-$(CONFIG_IA32_EMULATION) := ia32entry.o sys_ia32.o ia32_signal.o
 
 sysv-$(CONFIG_SYSVIPC) := ipc32.o
diff --git a/arch/x86/include/asm/k8.h b/arch/x86/include/asm/k8.h
index c23b3d1..c2d1f3b 100644
--- a/arch/x86/include/asm/k8.h
+++ b/arch/x86/include/asm/k8.h
@@ -13,10 +13,15 @@ extern void k8_flush_garts(void);
 extern int k8_scan_nodes(unsigned long start, unsigned long end);
 
 #ifdef CONFIG_K8_NB
-#define node_to_k8_nb_misc(node) \
-	(node < num_k8_northbridges) ? k8_northbridges[node] : NULL
+static inline struct pci_dev *node_to_k8_nb_misc(int node)
+{
+	return (node < num_k8_northbridges) ? k8_northbridges[node] : NULL;
+}
 #else
-#define node_to_k8_nb_misc(node) NULL
+static inline struct pci_dev *node_to_k8_nb_misc(int node)
+{
+	return NULL;
+}
 #endif
 
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 68a4ff6..d0dfc61 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -2,6 +2,9 @@
 # Makefile for the linux kernel.
 #
 
+# Make all warnings into errors
+ccflags-y		:= -Werror
+
 extra-y                := head_$(BITS).o head$(BITS).o head.o init_task.o vmlinux.lds
 
 CPPFLAGS_vmlinux.lds += -U$(UTS_MACHINE)
diff --git a/arch/x86/kernel/acpi/Makefile b/arch/x86/kernel/acpi/Makefile
index fd5ca97..d6f1e61 100644
--- a/arch/x86/kernel/acpi/Makefile
+++ b/arch/x86/kernel/acpi/Makefile
@@ -1,3 +1,6 @@
+# Make all warnings into errors
+ccflags-y			:= -Werror
+
 subdir-				:= realmode
 
 obj-$(CONFIG_ACPI)		+= boot.o
diff --git a/arch/x86/kernel/acpi/realmode/Makefile b/arch/x86/kernel/acpi/realmode/Makefile
index 167bc16..9ac0e29 100644
--- a/arch/x86/kernel/acpi/realmode/Makefile
+++ b/arch/x86/kernel/acpi/realmode/Makefile
@@ -6,6 +6,9 @@
 # for more details.
 #
 
+# Make all warnings into errors
+ccflags-y	:= -Werror
+
 always		:= wakeup.bin
 targets		:= wakeup.elf wakeup.lds
 
diff --git a/arch/x86/kernel/apic/Makefile b/arch/x86/kernel/apic/Makefile
index da7b7b9..d6ee6b7 100644
--- a/arch/x86/kernel/apic/Makefile
+++ b/arch/x86/kernel/apic/Makefile
@@ -2,6 +2,9 @@
 # Makefile for local APIC drivers and for the IO-APIC code
 #
 
+# Make all warnings into errors
+ccflags-y			:= -Werror
+
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o probe_$(BITS).o ipi.o nmi.o
 obj-$(CONFIG_X86_IO_APIC)	+= io_apic.o
 obj-$(CONFIG_SMP)		+= ipi.o
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index 3efcb2b..8875b09 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -2,6 +2,9 @@
 # Makefile for x86-compatible CPU details, features and quirks
 #
 
+# Make all warnings into errors
+ccflags-y		:= -Werror
+
 # Don't trace early stages of a secondary CPU boot
 ifdef CONFIG_FUNCTION_TRACER
 CFLAGS_REMOVE_common.o = -pg
diff --git a/arch/x86/kernel/cpu/cpufreq/Makefile b/arch/x86/kernel/cpu/cpufreq/Makefile
index 509296d..04f2acf 100644
--- a/arch/x86/kernel/cpu/cpufreq/Makefile
+++ b/arch/x86/kernel/cpu/cpufreq/Makefile
@@ -2,6 +2,9 @@
 # K8 systems. ACPI is preferred to all other hardware-specific drivers.
 # speedstep-* is preferred over p4-clockmod.
 
+# Make all warnings into errors
+ccflags-y				:= -Werror
+
 obj-$(CONFIG_X86_POWERNOW_K8)		+= powernow-k8.o
 obj-$(CONFIG_X86_ACPI_CPUFREQ)		+= acpi-cpufreq.o
 obj-$(CONFIG_X86_POWERNOW_K6)		+= powernow-k6.o
diff --git a/arch/x86/kernel/cpu/mcheck/Makefile b/arch/x86/kernel/cpu/mcheck/Makefile
index b2f8982..1c6cd76 100644
--- a/arch/x86/kernel/cpu/mcheck/Makefile
+++ b/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,3 +1,6 @@
+# Make all warnings into errors
+ccflags-y			:= -Werror
+
 obj-y				=  mce_$(BITS).o therm_throt.o
 
 obj-$(CONFIG_X86_32)		+= k7.o p4.o p5.o p6.o winchip.o
diff --git a/arch/x86/kernel/cpu/mtrr/Makefile b/arch/x86/kernel/cpu/mtrr/Makefile
index f4361b5..e832c5d 100644
--- a/arch/x86/kernel/cpu/mtrr/Makefile
+++ b/arch/x86/kernel/cpu/mtrr/Makefile
@@ -1,3 +1,6 @@
+# Make all warnings into errors
+ccflags-y	:= -Werror
+
 obj-y		:= main.o if.o generic.o state.o cleanup.o
 obj-$(CONFIG_X86_32) += amd.o cyrix.o centaur.o
 
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index d3ec292..4034848 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -2,6 +2,9 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
+# Make all warnings into errors
+ccflags-y := -Werror
+
 common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
                 coalesced_mmio.o irq_comm.o)
 ifeq ($(CONFIG_KVM_TRACE),y)
diff --git a/arch/x86/lguest/Makefile b/arch/x86/lguest/Makefile
index 27f0c9e..91e0f58 100644
--- a/arch/x86/lguest/Makefile
+++ b/arch/x86/lguest/Makefile
@@ -1 +1,4 @@
+# Make all warnings into errors
+ccflags-y	:= -Werror
+
 obj-y		:= i386_head.o boot.o
diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
index 55e11aa..adb8618 100644
--- a/arch/x86/lib/Makefile
+++ b/arch/x86/lib/Makefile
@@ -2,6 +2,9 @@
 # Makefile for x86 specific library files.
 #
 
+# Make all warnings into errors
+ccflags-y := -Werror
+
 obj-$(CONFIG_SMP) := msr-on-cpu.o
 
 lib-y := delay.o
diff --git a/arch/x86/math-emu/Makefile b/arch/x86/math-emu/Makefile
index 9b0c63b..13de9a7 100644
--- a/arch/x86/math-emu/Makefile
+++ b/arch/x86/math-emu/Makefile
@@ -8,6 +8,9 @@ PARANOID = -DPARANOID
 EXTRA_CFLAGS	:= $(PARANOID) $(DEBUG) -fno-builtin $(MATH_EMULATION)
 EXTRA_AFLAGS	:= $(PARANOID)
 
+# Make all warnings into errors
+ccflags-y	:= -Werror
+
 # From 'C' language sources:
 C_OBJS =fpu_entry.o errors.o \
 	fpu_arith.o fpu_aux.o fpu_etc.o fpu_tags.o fpu_trig.o \
diff --git a/arch/x86/mm/Makefile b/arch/x86/mm/Makefile
index eefdeee..f7e4e34 100644
--- a/arch/x86/mm/Makefile
+++ b/arch/x86/mm/Makefile
@@ -1,3 +1,6 @@
+# Make all warnings into errors
+ccflags-y			:= -Werror
+
 obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
 	    pat.o pgtable.o gup.o
 
diff --git a/arch/x86/mm/kmemcheck/Makefile b/arch/x86/mm/kmemcheck/Makefile
index 520b3bc..08cfc37 100644
--- a/arch/x86/mm/kmemcheck/Makefile
+++ b/arch/x86/mm/kmemcheck/Makefile
@@ -1 +1,4 @@
+# Make all warnings into errors
+ccflags-y := -Werror
+
 obj-y := error.o kmemcheck.o opcode.o pte.o selftest.o shadow.o
diff --git a/arch/x86/oprofile/Makefile b/arch/x86/oprofile/Makefile
index 446902b..30dbda7 100644
--- a/arch/x86/oprofile/Makefile
+++ b/arch/x86/oprofile/Makefile
@@ -1,3 +1,6 @@
+# Make all warnings into errors
+ccflags-y := -Werror
+
 obj-$(CONFIG_OPROFILE) += oprofile.o
 
 DRIVER_OBJS = $(addprefix ../../../drivers/oprofile/, \
diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
index d49202e..29a1518 100644
--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -1,3 +1,6 @@
+# Make all warnings into errors
+ccflags-y			:= -Werror
+
 obj-y				:= i386.o init.o
 
 obj-$(CONFIG_PCI_BIOS)		+= pcbios.o
diff --git a/arch/x86/power/Makefile b/arch/x86/power/Makefile
index 58b32db..581554f 100644
--- a/arch/x86/power/Makefile
+++ b/arch/x86/power/Makefile
@@ -1,3 +1,6 @@
+# Make all warnings into errors
+ccflags-y		:= -Werror
+
 # __restore_processor_state() restores %gs after S3 resume and so should not
 # itself be stack-protected
 nostackp := $(call cc-option, -fno-stack-protector)
diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index 16a9020..7e9f426 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -2,6 +2,9 @@
 # Building vDSO images for x86.
 #
 
+# Make all warnings into errors
+ccflags-y			:= -Werror
+
 VDSO64-$(CONFIG_X86_64)		:= y
 VDSO32-$(CONFIG_X86_32)		:= y
 VDSO32-$(CONFIG_COMPAT)		:= y
@@ -9,7 +12,6 @@ VDSO32-$(CONFIG_COMPAT)		:= y
 vdso-install-$(VDSO64-y)	+= vdso.so
 vdso-install-$(VDSO32-y)	+= $(vdso32-images)
 
-
 # files to link into the vdso
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o vvar.o
 
diff --git a/arch/x86/video/Makefile b/arch/x86/video/Makefile
index 2c447c9..8f703bf 100644
--- a/arch/x86/video/Makefile
+++ b/arch/x86/video/Makefile
@@ -1 +1,4 @@
+# Make all warnings into errors
+ccflags-y := -Werror
+
 obj-$(CONFIG_FB)               += fbdev.o
diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3b767d0..266a731 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,3 +1,6 @@
+# Make all warnings into errors
+ccflags-y := -Werror
+
 ifdef CONFIG_FUNCTION_TRACER
 # Do not profile debug and lowlevel utilities
 CFLAGS_REMOVE_spinlock.o = -pg
@@ -10,4 +13,4 @@ obj-y		:= enlighten.o setup.o multicalls.o mmu.o irq.o \
 			grant-table.o suspend.o
 
 obj-$(CONFIG_SMP)		+= smp.o spinlock.o
-obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o
\ No newline at end of file
+obj-$(CONFIG_XEN_DEBUG_FS)	+= debugfs.o


