Return-Path: <linux-kernel-owner+w=401wt.eu-S933845AbXCNFOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbXCNFOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 01:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933868AbXCNFMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 01:12:45 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:54265 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933840AbXCNFMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 01:12:06 -0400
Message-Id: <20070314051049.270076171@goodmis.org>
References: <20070314050819.536207642@goodmis.org>
User-Agent: quilt/0.45-1
Date: Wed, 14 Mar 2007 01:08:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Andi Kleen <ak@muc.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH 10/18] make the kernel Makefile
Content-Disposition: inline; filename=kernel-makefile.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Create the arch/x86/kernel/Makefile and change the i386 and x86_64
Makefiles accordingly.


Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Glauber de Oliveira Costa <glommer@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Andi Kleen <ak@muc.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>

diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
new file mode 100644
index 0000000..e2300ad
--- /dev/null
+++ b/arch/x86/kernel/Makefile
@@ -0,0 +1,18 @@
+
+obj-y			+= bootflag.o topology.o quirks.o i8237.o alternative.o \
+			   pcspeaker.o
+
+obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
+
+obj-y			+=	cpu/
+obj-$(CONFIG_X86_MSR)		+= msr.o
+obj-$(CONFIG_MICROCODE)		+= microcode.o
+obj-$(CONFIG_X86_CPUID)		+= cpuid.o
+obj-$(CONFIG_ACPI)		+= acpi/
+obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
+
+ifeq ($(CONFIG_X86_VOYAGER), )
+obj-$(CONFIG_SMP)		+= tsc_sync.o
+endif
+
+obj-$(CONFIG_K8_NB)		+= k8.o
diff --git a/arch/i386/kernel/Makefile b/arch/i386/kernel/Makefile
index 4ae3dcf..bea2137 100644
--- a/arch/i386/kernel/Makefile
+++ b/arch/i386/kernel/Makefile
@@ -6,19 +6,15 @@ extra-y := head.o init_task.o vmlinux.lds
 
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_i386.o \
-		pci-dma.o i386_ksyms.o i387.o bootflag.o e820.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o tsc.o
+		pci-dma.o i386_ksyms.o i387.o  e820.o\
+		i8253.o tsc.o
 
-obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
 obj-y				+= acpi/
 obj-$(CONFIG_X86_BIOS_REBOOT)	+= reboot.o
 obj-$(CONFIG_MCA)		+= mca.o
-obj-$(CONFIG_X86_MSR)		+= msr.o
-obj-$(CONFIG_X86_CPUID)		+= cpuid.o
-obj-$(CONFIG_MICROCODE)		+= microcode.o
 obj-$(CONFIG_APM)		+= apm.o
-obj-$(CONFIG_X86_SMP)		+= smp.o smpboot.o tsc_sync.o
+obj-$(CONFIG_X86_SMP)		+= smp.o smpboot.o
 obj-$(CONFIG_X86_TRAMPOLINE)	+= trampoline.o
 obj-$(CONFIG_X86_MPPARSE)	+= mpparse.o
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o nmi.o
@@ -35,13 +31,10 @@ obj-$(CONFIG_ACPI_SRAT) 	+= srat.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_stub.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
 obj-$(CONFIG_VM86)		+= vm86.o
-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
-obj-$(CONFIG_K8_NB)		+= k8.o
 
 obj-$(CONFIG_VMI)		+= vmi.o vmitime.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt.o
-obj-y				+= pcspeaker.o
 
 EXTRA_AFLAGS   := -traditional
 
@@ -82,7 +75,3 @@ SYSCFLAGS_vsyscall-syms.o = -r
 $(obj)/vsyscall-syms.o: $(src)/vsyscall.lds \
 			$(obj)/vsyscall-sysenter.o $(obj)/vsyscall-note.o FORCE
 	$(call if_changed,syscall)
-
-k8-y                      += ../../x86_64/kernel/k8.o
-stacktrace-y		  += ../../x86_64/kernel/stacktrace.o
-
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index bb47e86..3f10fe0 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -7,19 +7,14 @@ EXTRA_AFLAGS	:= -traditional
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_x86_64.o \
 		x8664_ksyms.o i387.o syscall.o vsyscall.o \
-		setup64.o bootflag.o e820.o reboot.o quirks.o i8237.o \
-		pci-dma.o pci-nommu.o alternative.o hpet.o tsc.o
+		setup64.o e820.o reboot.o \
+		pci-dma.o pci-nommu.o hpet.o tsc.o
 
-obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
-obj-$(CONFIG_X86_MCE)		+= mce.o therm_throt.o
+obj-$(CONFIG_X86_MCE)		+= mce.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd.o
-obj-$(CONFIG_MTRR)		+= ../../i386/kernel/cpu/mtrr/
 obj-$(CONFIG_ACPI)		+= acpi/
-obj-$(CONFIG_X86_MSR)		+= msr.o
-obj-$(CONFIG_MICROCODE)		+= microcode.o
-obj-$(CONFIG_X86_CPUID)		+= cpuid.o
-obj-$(CONFIG_SMP)		+= smp.o smpboot.o trampoline.o tsc_sync.o
+obj-$(CONFIG_SMP)		+= smp.o smpboot.o trampoline.o
 obj-y				+= apic.o  nmi.o
 obj-y				+= io_apic.o mpparse.o \
 		genapic.o genapic_cluster.o genapic_flat.o
@@ -27,34 +22,15 @@ obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_PM)		+= suspend.o
 obj-$(CONFIG_SOFTWARE_SUSPEND)	+= suspend_asm.o
-obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
-obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_IOMMU)		+= pci-gart.o aperture.o
 obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary.o tce.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer.o
 obj-$(CONFIG_X86_VSMP)		+= vsmp.o
-obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_AUDIT)		+= audit.o
 
 obj-$(CONFIG_MODULES)		+= module.o
 obj-$(CONFIG_PCI)		+= early-quirks.o
 
-obj-y				+= topology.o
-obj-y				+= intel_cacheinfo.o
-obj-y				+= pcspeaker.o
-
 CFLAGS_vsyscall.o		:= $(PROFILING) -g0
-
-therm_throt-y                   += ../../i386/kernel/cpu/mcheck/therm_throt.o
-bootflag-y			+= ../../i386/kernel/bootflag.o
-cpuid-$(subst m,y,$(CONFIG_X86_CPUID))  += ../../i386/kernel/cpuid.o
-topology-y                     += ../../i386/kernel/topology.o
-microcode-$(subst m,y,$(CONFIG_MICROCODE))  += ../../i386/kernel/microcode.o
-intel_cacheinfo-y		+= ../../i386/kernel/cpu/intel_cacheinfo.o
-quirks-y			+= ../../i386/kernel/quirks.o
-i8237-y				+= ../../i386/kernel/i8237.o
-msr-$(subst m,y,$(CONFIG_X86_MSR))  += ../../i386/kernel/msr.o
-alternative-y			+= ../../i386/kernel/alternative.o
-pcspeaker-y			+= ../../i386/kernel/pcspeaker.o

--
