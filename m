Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbXGOVcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbXGOVcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 17:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbXGOVb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 17:31:57 -0400
Received: from omr5.networksolutionsemail.com ([205.178.146.55]:58246 "EHLO
	omr5.networksolutionsemail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbXGOVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 17:31:51 -0400
X-Greylist: delayed 1885 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Jul 2007 17:31:51 EDT
Message-ID: <469A8AED.7070207@nerdgrounds.com>
Date: Sun, 15 Jul 2007 14:00:29 -0700
From: Jonathan Campbell <jon@nerdgrounds.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@transmeta.com
Subject: Patches for REALLY TINY 386 kernels
Content-Type: multipart/mixed;
 boundary="------------030109090009080104010309"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030109090009080104010309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I wrote a set of patches out of concern that even if you compile a 386 
kernel a lot of code irrelevent to legacy machines still remains. Things 
like the Pentium TSC register, DMI information, ESCD parsing, and the 
use of CPUID do not apply to these machines, but looking at System.map 
you can see they're still there.

Already with these patches I can compile a zImage kernel that is 450kb 
large (890kb decompressed) with a small initramfs payload, floppy and 
kernel module support, FPU emulation, that can successfully boot on an 
ancient 386 laptop with only 1MB of extended memory. Eventually what I'd 
like to have is the ability to compile a pure 386 kernel with all 
non-386 functions removed (and perhaps the same for 486 machines).

These patches were written against the vanilla 2.6.21.1 kernel. They 
will have no effect UNLESS you make menuconfig and explicitly enable 
them there.


--------------030109090009080104010309
Content-Type: text/plain;
 name="linux-2.6.21.1-386-reduction.patches"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.21.1-386-reduction.patches"

Only in linux-2.6.21.1: .config
Only in linux-2.6.21.1: .config.old
Only in linux-2.6.21.1: .config.saved
Only in linux-2.6.21.1: .config~
Only in linux-2.6.21.1: .gitignore
Only in linux-2.6.21.1: .mailmap
Only in linux-2.6.21.1: .tmp_versions
Only in linux-2.6.21.1: .version
Only in linux-2.6.21.1: .vmlinux.cmd
Only in linux-2.6.21.1: Module.symvers
Only in linux-2.6.21.1: System.map
diff -r -u linux-2.6.21.1/arch/i386/Kconfig linux-2.6.21.1-386/arch/i386/Kconfig
--- linux-2.6.21.1/arch/i386/Kconfig	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/Kconfig	2007-07-03 13:15:12.000000000 +0000
@@ -362,6 +362,15 @@
 	  to disable it.  MCE support simply ignores non-MCE processors like
 	  the 386 and 486, so nearly everyone can say Y here.
 
+config X86_DONT_CPUID
+	bool "Disable CPUID support"
+	depends on M386 || M486
+	default n
+	---help---
+	  Enable this option if your kernel is strictly intended to run on legacy
+	  386/486 systems that don't have CPUID. This option disables all CPU detection
+	  code that is not relevant to pre-Pentium systems.
+
 config X86_MCE_NONFATAL
 	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
 	depends on X86_MCE
@@ -444,6 +453,16 @@
 	  enable this option even if you don't need it.
 	  Say N otherwise.
 
+config X86_TSC
+	bool "Enable X86 use TSC timesource"
+	depends on X86_PC
+	default y
+	---help---
+	  This enables your kernel to use the TSC register, present in all
+	  Pentium and newer CPUs, as a timesource as an alternative to the
+	  legacy PIT. This is highly recommended unless building a kernel
+	  for legacy 386/486 systems.
+
 config MICROCODE
 	tristate "/dev/cpu/microcode - Intel IA32 CPU microcode support"
 	select FW_LOADER
Only in linux-2.6.21.1/arch/i386/boot: .bootsect.cmd
Only in linux-2.6.21.1/arch/i386/boot: .bootsect.o.cmd
Only in linux-2.6.21.1/arch/i386/boot: .setup.cmd
Only in linux-2.6.21.1/arch/i386/boot: .setup.o.cmd
Only in linux-2.6.21.1/arch/i386/boot: .vmlinux.bin.cmd
Only in linux-2.6.21.1/arch/i386/boot: .zImage.cmd
Only in linux-2.6.21.1/arch/i386/boot: bootsect
Only in linux-2.6.21.1/arch/i386/boot: bootsect.o
Only in linux-2.6.21.1/arch/i386/boot/compressed: .head.o.cmd
Only in linux-2.6.21.1/arch/i386/boot/compressed: .misc.o.cmd
Only in linux-2.6.21.1/arch/i386/boot/compressed: .piggy.o.cmd
Only in linux-2.6.21.1/arch/i386/boot/compressed: .vmlinux.bin.cmd
Only in linux-2.6.21.1/arch/i386/boot/compressed: .vmlinux.bin.gz.cmd
Only in linux-2.6.21.1/arch/i386/boot/compressed: .vmlinux.cmd
Only in linux-2.6.21.1/arch/i386/boot/compressed: head.o
Only in linux-2.6.21.1/arch/i386/boot/compressed: misc.o
Only in linux-2.6.21.1/arch/i386/boot/compressed: piggy.o
Only in linux-2.6.21.1/arch/i386/boot/compressed: vmlinux
Only in linux-2.6.21.1/arch/i386/boot/compressed: vmlinux.bin
Only in linux-2.6.21.1/arch/i386/boot/compressed: vmlinux.bin.gz
Only in linux-2.6.21.1/arch/i386/boot: setup
Only in linux-2.6.21.1/arch/i386/boot: setup.o
Only in linux-2.6.21.1/arch/i386/boot/tools: .build.cmd
Only in linux-2.6.21.1/arch/i386/boot/tools: build
Only in linux-2.6.21.1/arch/i386/boot: vmlinux.bin
Only in linux-2.6.21.1/arch/i386/boot: zImage
Only in linux-2.6.21.1/arch/i386/crypto: .built-in.o.cmd
Only in linux-2.6.21.1/arch/i386/crypto: built-in.o
Only in linux-2.6.21.1/arch/i386/kernel: .alternative.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .asm-offsets.s.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .bootflag.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .built-in.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .e820.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .entry.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .head.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .i386_ksyms.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .i387.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .i8237.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .i8253.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .i8259.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .init_task.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .ioport.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .irq.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .ldt.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .module.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .pci-dma.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .pcspeaker.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .process.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .ptrace.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .quirks.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .reboot.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .setup.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .signal.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .sys_i386.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .sysenter.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .time.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .topology.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .traps.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .tsc.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .vmlinux.lds.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .vsyscall-int80.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .vsyscall-int80.so.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .vsyscall-note.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .vsyscall-syms.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .vsyscall-sysenter.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .vsyscall-sysenter.so.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .vsyscall.lds.cmd
Only in linux-2.6.21.1/arch/i386/kernel: .vsyscall.o.cmd
diff -r -u linux-2.6.21.1/arch/i386/kernel/Makefile linux-2.6.21.1-386/arch/i386/kernel/Makefile
--- linux-2.6.21.1/arch/i386/kernel/Makefile	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/kernel/Makefile	2007-07-03 12:27:34.000000000 +0000
@@ -7,7 +7,11 @@
 obj-y	:= process.o signal.o entry.o traps.o irq.o \
 		ptrace.o time.o ioport.o ldt.o setup.o i8259.o sys_i386.o \
 		pci-dma.o i386_ksyms.o i387.o bootflag.o e820.o\
-		quirks.o i8237.o topology.o alternative.o i8253.o tsc.o
+		quirks.o i8237.o topology.o alternative.o i8253.o
+
+ifdef CONFIG_X86_TSC
+obj-y	:= tsc.o
+endif
 
 obj-$(CONFIG_STACKTRACE)	+= stacktrace.o
 obj-y				+= cpu/
Only in linux-2.6.21.1/arch/i386/kernel/acpi: .built-in.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/acpi: built-in.o
Only in linux-2.6.21.1/arch/i386/kernel: alternative.o
Only in linux-2.6.21.1/arch/i386/kernel: asm-offsets.s
Only in linux-2.6.21.1/arch/i386/kernel: bootflag.o
Only in linux-2.6.21.1/arch/i386/kernel: built-in.o
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .amd.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .built-in.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .centaur.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .common.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .cyrix.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .intel.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .intel_cacheinfo.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .nexgen.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .proc.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .rise.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .transmeta.o.cmd
Only in linux-2.6.21.1/arch/i386/kernel/cpu: .umc.o.cmd
diff -r -u linux-2.6.21.1/arch/i386/kernel/cpu/Makefile linux-2.6.21.1-386/arch/i386/kernel/cpu/Makefile
--- linux-2.6.21.1/arch/i386/kernel/cpu/Makefile	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/kernel/cpu/Makefile	2007-07-03 13:17:57.000000000 +0000
@@ -4,14 +4,18 @@
 
 obj-y	:=	common.o proc.o
 
+ifndef CONFIG_X86_DONT_CPUID
 obj-y	+=	amd.o
 obj-y	+=	cyrix.o
 obj-y	+=	centaur.o
 obj-y	+=	transmeta.o
+endif
 obj-y	+=	intel.o intel_cacheinfo.o
+ifndef CONFIG_X86_DONT_CPUID
 obj-y	+=	rise.o
 obj-y	+=	nexgen.o
 obj-y	+=	umc.o
+endif
 
 obj-$(CONFIG_X86_MCE)	+=	mcheck/
 
Only in linux-2.6.21.1/arch/i386/kernel/cpu: amd.o
Only in linux-2.6.21.1/arch/i386/kernel/cpu: built-in.o
Only in linux-2.6.21.1/arch/i386/kernel/cpu: centaur.o
diff -r -u linux-2.6.21.1/arch/i386/kernel/cpu/common.c linux-2.6.21.1-386/arch/i386/kernel/cpu/common.c
--- linux-2.6.21.1/arch/i386/kernel/cpu/common.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/kernel/cpu/common.c	2007-07-03 14:05:41.000000000 +0000
@@ -20,6 +20,11 @@
 #endif
 #include <asm/pda.h>
 
+#ifdef CONFIG_X86_DONT_CPUID
+#  define cpuid		__EVIL__EVIL__EVIL__
+#  define cpuid_eax	__EVIL__EVIL__EVIL__
+#endif
+
 #include "cpu.h"
 
 DEFINE_PER_CPU(struct Xgt_desc_struct, cpu_gdt_descr);
@@ -29,9 +34,11 @@
 EXPORT_SYMBOL(_cpu_pda);
 
 static int cachesize_override __cpuinitdata = -1;
+#ifndef CONFIG_X86_DONT_CPUID
 static int disable_x86_fxsr __cpuinitdata;
 static int disable_x86_serial_nr __cpuinitdata = 1;
 static int disable_x86_sep __cpuinitdata;
+#endif
 
 struct cpu_dev * cpu_devs[X86_VENDOR_NUM] = {};
 
@@ -63,6 +70,7 @@
 }
 __setup("cachesize=", cachesize_setup);
 
+#ifndef CONFIG_X86_DONT_CPUID
 int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
 	unsigned int *v;
@@ -128,12 +136,14 @@
 	printk(KERN_INFO "CPU: L2 Cache: %dK (%d bytes/line)\n",
 	       l2size, ecx & 0xFF);
 }
+#endif
 
 /* Naming convention should be: <Name> [(<Codename>)] */
 /* This table only is used unless init_<vendor>() below doesn't set it; */
 /* in particular, if CPUID levels 0x80000002..4 are supported, this isn't used */
 
 /* Look up CPU names by table lookup. */
+#ifndef CONFIG_X86_DONT_CPUID
 static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
 {
 	struct cpu_model_info *info;
@@ -154,7 +164,6 @@
 	return NULL;		/* Not found */
 }
 
-
 static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c, int early)
 {
 	char *v = c->x86_vendor_id;
@@ -182,7 +191,6 @@
 	this_cpu = &default_cpu;
 }
 
-
 static int __init x86_fxsr_setup(char * s)
 {
 	/* Tell all the other CPU's to not use it... */
@@ -206,7 +214,7 @@
 	return 1;
 }
 __setup("nosep", x86_sep_setup);
-
+#endif
 
 /* Standard macro to see if a specific flag is changeable */
 static inline int flag_is_changeable_p(u32 flag)
@@ -231,6 +239,9 @@
 
 
 /* Probe for the CPUID instruction */
+#ifdef CONFIG_X86_DONT_CPUID
+#  define have_cpuid_p() ((int)0)
+#else
 static int __cpuinit have_cpuid_p(void)
 {
 	return flag_is_changeable_p(X86_EFLAGS_ID);
@@ -259,6 +270,7 @@
 			c->x86_cache_alignment = ((misc >> 8) & 0xff) * 8;
 	}
 }
+#endif
 
 /* Do minimum CPU detection early.
    Fields really needed: vendor, cpuid_level, family, model, mask, cache alignment.
@@ -272,14 +284,20 @@
 
 	c->x86_cache_alignment = 32;
 
+#ifndef CONFIG_X86_DONT_CPUID
 	if (!have_cpuid_p())
 		return;
 
 	cpu_detect(c);
 
 	get_cpu_vendor(c, 1);
+#else
+	c->x86_vendor = X86_VENDOR_UNKNOWN;
+	this_cpu = &default_cpu;
+#endif
 }
 
+#ifndef CONFIG_X86_DONT_CPUID
 static void __cpuinit generic_identify(struct cpuinfo_x86 * c)
 {
 	u32 tfms, xlvl;
@@ -339,7 +357,9 @@
 	c->phys_proc_id = (cpuid_ebx(1) >> 24) & 0xff;
 #endif
 }
+#endif
 
+#ifndef CONFIG_X86_DONT_CPUID
 static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 {
 	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr ) {
@@ -362,7 +382,7 @@
 	return 1;
 }
 __setup("serialnumber", x86_serial_nr_setup);
-
+#endif
 
 
 /*
@@ -382,7 +402,6 @@
 	c->x86_max_cores = 1;
 	c->x86_clflush_size = 32;
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
-
 	if (!have_cpuid_p()) {
 		/* First of all, decide if this is a 486 or higher */
 		/* It's a 486 if we can modify the AC flag */
@@ -391,8 +410,9 @@
 		else
 			c->x86 = 3;
 	}
-
+#ifndef CONFIG_X86_DONT_CPUID
 	generic_identify(c);
+#endif
 
 	printk(KERN_DEBUG "CPU: After generic identify, caps:");
 	for (i = 0; i < NCAPINTS; i++)
@@ -421,14 +441,17 @@
 	if (this_cpu->c_init)
 		this_cpu->c_init(c);
 
+#ifndef CONFIG_X86_DONT_CPUID
 	/* Disable the PN if appropriate */
 	squash_the_stupid_serial_number(c);
+#endif
 
 	/*
 	 * The vendor-specific functions might have changed features.  Now
 	 * we do "generic changes."
 	 */
 
+#ifdef CONFIG_X86_TSC
 	/* TSC disabled? */
 	if ( tsc_disable )
 		clear_bit(X86_FEATURE_TSC, c->x86_capability);
@@ -457,6 +480,11 @@
 			sprintf(c->x86_model_id, "%02x/%02x",
 				c->x86, c->x86_model);
 	}
+#else
+	if ( !c->x86_model_id[0] )
+		sprintf(c->x86_model_id, "%02x/%02x",
+			c->x86, c->x86_model);
+#endif
 
 	/* Now the feature flags better reflect actual CPU features! */
 
@@ -465,6 +493,7 @@
 		printk(" %08lx", c->x86_capability[i]);
 	printk("\n");
 
+#ifdef CONFIG_SMP
 	/*
 	 * On SMP, boot_cpu_data holds the common feature set between
 	 * all CPUs; so make sure that we indicate which features are
@@ -476,6 +505,7 @@
 		for ( i = 0 ; i < NCAPINTS ; i++ )
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
+#endif
 
 	/* Init Machine Check Exception if available. */
 	mcheck_init(c);
@@ -581,6 +611,7 @@
 
 void __init early_cpu_init(void)
 {
+#ifndef CONFIG_X86_DONT_CPUID
 	intel_cpu_init();
 	cyrix_init_cpu();
 	nsc_init_cpu();
@@ -590,6 +621,7 @@
 	rise_init_cpu();
 	nexgen_init_cpu();
 	umc_init_cpu();
+#endif
 	early_cpu_detect();
 
 #ifdef CONFIG_DEBUG_PAGEALLOC
@@ -736,12 +768,14 @@
 
 	if (cpu_has_vme || cpu_has_tsc || cpu_has_de)
 		clear_in_cr4(X86_CR4_VME|X86_CR4_PVI|X86_CR4_TSD|X86_CR4_DE);
+#ifdef CONFIG_X86_TSC
 	if (tsc_disable && cpu_has_tsc) {
 		printk(KERN_NOTICE "Disabling TSC...\n");
 		/**** FIX-HPA: DOES THIS REALLY BELONG HERE? ****/
 		clear_bit(X86_FEATURE_TSC, boot_cpu_data.x86_capability);
 		set_in_cr4(X86_CR4_TSD);
 	}
+#endif
 
 	load_idt(&idt_descr);
 
Only in linux-2.6.21.1/arch/i386/kernel/cpu: common.o
Only in linux-2.6.21.1/arch/i386/kernel/cpu: cyrix.o
diff -r -u linux-2.6.21.1/arch/i386/kernel/cpu/intel.c linux-2.6.21.1-386/arch/i386/kernel/cpu/intel.c
--- linux-2.6.21.1/arch/i386/kernel/cpu/intel.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/kernel/cpu/intel.c	2007-07-03 13:51:39.000000000 +0000
@@ -19,6 +19,12 @@
 #include <mach_apic.h>
 #endif
 
+#ifdef CONFIG_X86_DONT_CPUID
+#  define cpuid		__EVIL__EVIL__EVIL__
+#  define cpuid_eax	__EVIL__EVIL__EVIL__
+#  define cpuid_count	__EVIL__EVIL__EVIL__
+#endif
+
 extern int trap_init_f00f_bug(void);
 
 #ifdef CONFIG_X86_INTEL_USERCOPY
@@ -28,6 +34,7 @@
 struct movsl_mask movsl_mask __read_mostly;
 #endif
 
+#ifndef CONFIG_X86_DONT_CPUID
 void __cpuinit early_intel_workaround(struct cpuinfo_x86 *c)
 {
 	if (c->x86_vendor != X86_VENDOR_INTEL)
@@ -94,13 +101,14 @@
 	else
 		return 1;
 }
+#endif
 
 static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 {
 	unsigned int l2 = 0;
 	char *p = NULL;
 
-#ifdef CONFIG_X86_F00F_BUG
+#if defined(CONFIG_X86_F00F_BUG) && !defined(CONFIG_X86_DONT_CPUID)
 	/*
 	 * All current models of Pentium and Pentium with MMX technology CPUs
 	 * have the F0 0F bug, which lets nonprivileged users lock up the system.
@@ -120,6 +128,7 @@
 #endif
 
 	select_idle_routine(c);
+#ifndef CONFIG_X86_DONT_CPUID
 	l2 = init_intel_cacheinfo(c);
 	if (c->cpuid_level > 9 ) {
 		unsigned eax = cpuid_eax(10);
@@ -164,12 +173,15 @@
 		strcpy(c->x86_model_id, p);
 	
 	c->x86_max_cores = num_cpu_cores(c);
-
 	detect_ht(c);
 
 	/* Work around errata */
 	Intel_errata_workarounds(c);
+#else
+	c->x86_max_cores = 1;
+#endif
 
+#ifndef CONFIG_X86_DONT_CPUID
 #ifdef CONFIG_X86_INTEL_USERCOPY
 	/*
 	 * Set up the preferred alignment for movsl bulk memory moves
@@ -204,8 +216,10 @@
 		if (!(l1 & (1<<12)))
 			set_bit(X86_FEATURE_PEBS, c->x86_capability);
 	}
+#endif
 }
 
+#ifndef CONFIG_X86_DONT_CPUID
 static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 * c, unsigned int size)
 {
 	/* Intel PIII Tualatin. This comes in two flavours.
@@ -217,7 +231,9 @@
 		size = 256;
 	return size;
 }
+#endif
 
+#ifndef CONFIG_X86_DONT_CPUID
 static struct cpu_dev intel_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Intel",
 	.c_ident 	= { "GenuineIntel" },
@@ -279,6 +295,7 @@
 	cpu_devs[X86_VENDOR_INTEL] = &intel_cpu_dev;
 	return 0;
 }
+#endif
 
 #ifndef CONFIG_X86_CMPXCHG
 unsigned long cmpxchg_386_u8(volatile void *ptr, u8 old, u8 new)
Only in linux-2.6.21.1/arch/i386/kernel/cpu: intel.o
Only in linux-2.6.21.1/arch/i386/kernel/cpu: intel_cacheinfo.o
Only in linux-2.6.21.1/arch/i386/kernel/cpu: nexgen.o
Only in linux-2.6.21.1/arch/i386/kernel/cpu: proc.o
Only in linux-2.6.21.1/arch/i386/kernel/cpu: rise.o
Only in linux-2.6.21.1/arch/i386/kernel/cpu: transmeta.o
Only in linux-2.6.21.1/arch/i386/kernel/cpu: umc.o
Only in linux-2.6.21.1/arch/i386/kernel: e820.o
Only in linux-2.6.21.1/arch/i386/kernel: entry.o
Only in linux-2.6.21.1/arch/i386/kernel: head.o
Only in linux-2.6.21.1/arch/i386/kernel: i386_ksyms.o
Only in linux-2.6.21.1/arch/i386/kernel: i387.o
Only in linux-2.6.21.1/arch/i386/kernel: i8237.o
Only in linux-2.6.21.1/arch/i386/kernel: i8253.o
Only in linux-2.6.21.1/arch/i386/kernel: i8259.o
Only in linux-2.6.21.1/arch/i386/kernel: init_task.o
Only in linux-2.6.21.1/arch/i386/kernel: ioport.o
Only in linux-2.6.21.1/arch/i386/kernel: irq.o
Only in linux-2.6.21.1/arch/i386/kernel: ldt.o
Only in linux-2.6.21.1/arch/i386/kernel: module.o
Only in linux-2.6.21.1/arch/i386/kernel: pci-dma.o
Only in linux-2.6.21.1/arch/i386/kernel: pcspeaker.o
Only in linux-2.6.21.1/arch/i386/kernel: process.o
Only in linux-2.6.21.1/arch/i386/kernel: ptrace.o
Only in linux-2.6.21.1/arch/i386/kernel: quirks.o
diff -r -u linux-2.6.21.1/arch/i386/kernel/reboot.c linux-2.6.21.1-386/arch/i386/kernel/reboot.c
--- linux-2.6.21.1/arch/i386/kernel/reboot.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/kernel/reboot.c	2007-07-03 12:14:39.000000000 +0000
@@ -9,7 +9,9 @@
 #include <linux/interrupt.h>
 #include <linux/mc146818rtc.h>
 #include <linux/efi.h>
+#ifdef CONFIG_DMI_SCAN
 #include <linux/dmi.h>
+#endif
 #include <linux/ctype.h>
 #include <linux/pm.h>
 #include <linux/reboot.h>
@@ -75,6 +77,7 @@
  * Dell Inc. so their systems "just work". :-)
  */
 
+#ifdef CONFIG_DMI_SCAN
 /*
  * Some machines require the "reboot=b"  commandline option, this quirk makes that automatic.
  */
@@ -122,10 +125,13 @@
 	},
 	{ }
 };
+#endif
 
 static int __init reboot_init(void)
 {
+#ifdef CONFIG_DMI_SCAN
 	dmi_check_system(reboot_dmi_table);
+#endif
 	return 0;
 }
 
Only in linux-2.6.21.1/arch/i386/kernel: reboot.o
diff -r -u linux-2.6.21.1/arch/i386/kernel/setup.c linux-2.6.21.1-386/arch/i386/kernel/setup.c
--- linux-2.6.21.1/arch/i386/kernel/setup.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/kernel/setup.c	2007-07-03 12:18:46.000000000 +0000
@@ -44,7 +44,9 @@
 #include <linux/nodemask.h>
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
+#ifdef CONFIG_DMI_SCAN
 #include <linux/dmi.h>
+#endif
 #include <linux/pfn.h>
 
 #include <video/edid.h>
@@ -611,7 +613,9 @@
 	 * NOTE: at this point the bootmem allocator is fully available.
 	 */
 
+#ifdef CONFIG_DMI_SCAN
 	dmi_scan_machine();
+#endif
 
 #ifdef CONFIG_X86_GENERICARCH
 	generic_apic_probe();
Only in linux-2.6.21.1/arch/i386/kernel: setup.o
Only in linux-2.6.21.1/arch/i386/kernel: signal.o
Only in linux-2.6.21.1/arch/i386/kernel: sys_i386.o
Only in linux-2.6.21.1/arch/i386/kernel: sysenter.o
diff -r -u linux-2.6.21.1/arch/i386/kernel/time.c linux-2.6.21.1-386/arch/i386/kernel/time.c
--- linux-2.6.21.1/arch/i386/kernel/time.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/kernel/time.c	2007-07-03 12:29:36.000000000 +0000
@@ -279,6 +279,8 @@
  */
 void __init time_init(void)
 {
+#ifdef CONFIG_X86_TSC
 	tsc_init();
+#endif
 	late_time_init = choose_time_init();
 }
Only in linux-2.6.21.1/arch/i386/kernel: time.o
Only in linux-2.6.21.1/arch/i386/kernel: topology.o
diff -r -u linux-2.6.21.1/arch/i386/kernel/traps.c linux-2.6.21.1-386/arch/i386/kernel/traps.c
--- linux-2.6.21.1/arch/i386/kernel/traps.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/kernel/traps.c	2007-07-03 14:09:34.000000000 +0000
@@ -1156,6 +1156,7 @@
 #endif
 	set_trap_gate(19,&simd_coprocessor_error);
 
+#ifndef CONFIG_X86_DONT_CPUID
 	if (cpu_has_fxsr) {
 		/*
 		 * Verify that the FXSAVE/FXRSTOR data will be 16-byte aligned.
@@ -1177,6 +1178,7 @@
 		set_in_cr4(X86_CR4_OSXMMEXCPT);
 		printk("done.\n");
 	}
+#endif
 
 	set_system_gate(SYSCALL_VECTOR,&system_call);
 
Only in linux-2.6.21.1/arch/i386/kernel: traps.o
diff -r -u linux-2.6.21.1/arch/i386/kernel/tsc.c linux-2.6.21.1-386/arch/i386/kernel/tsc.c
--- linux-2.6.21.1/arch/i386/kernel/tsc.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/kernel/tsc.c	2007-07-03 12:20:09.000000000 +0000
@@ -9,7 +9,9 @@
 #include <linux/cpufreq.h>
 #include <linux/jiffies.h>
 #include <linux/init.h>
+#ifdef CONFIG_DMI_SCAN
 #include <linux/dmi.h>
+#endif
 
 #include <asm/delay.h>
 #include <asm/tsc.h>
@@ -295,6 +297,7 @@
 }
 EXPORT_SYMBOL_GPL(mark_tsc_unstable);
 
+#ifdef CONFIG_DMI_SCAN
 static int __init dmi_mark_tsc_unstable(struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE "%s detected: marking TSC unstable.\n",
@@ -315,6 +318,7 @@
 	 },
 	 {}
 };
+#endif
 
 /*
  * Make an educated guess if the TSC is trustworthy and synchronized
@@ -374,8 +378,10 @@
 	set_cyc2ns_scale(cpu_khz);
 	use_tsc_delay();
 
+#ifdef CONFIG_DMI_SCAN
 	/* Check and install the TSC clocksource */
 	dmi_check_system(bad_tsc_dmi_table);
+#endif
 
 	unsynchronized_tsc();
 	check_geode_tsc_reliable();
Only in linux-2.6.21.1/arch/i386/kernel: tsc.o
Only in linux-2.6.21.1/arch/i386/kernel: vmlinux.lds
Only in linux-2.6.21.1/arch/i386/kernel: vsyscall-int80.o
Only in linux-2.6.21.1/arch/i386/kernel: vsyscall-int80.so
Only in linux-2.6.21.1/arch/i386/kernel: vsyscall-note.o
Only in linux-2.6.21.1/arch/i386/kernel: vsyscall-syms.o
Only in linux-2.6.21.1/arch/i386/kernel: vsyscall-sysenter.o
Only in linux-2.6.21.1/arch/i386/kernel: vsyscall-sysenter.so
Only in linux-2.6.21.1/arch/i386/kernel: vsyscall.lds
Only in linux-2.6.21.1/arch/i386/kernel: vsyscall.o
Only in linux-2.6.21.1/arch/i386/lib: .bitops.o.cmd
Only in linux-2.6.21.1/arch/i386/lib: .built-in.o.cmd
Only in linux-2.6.21.1/arch/i386/lib: .checksum.o.cmd
Only in linux-2.6.21.1/arch/i386/lib: .delay.o.cmd
Only in linux-2.6.21.1/arch/i386/lib: .getuser.o.cmd
Only in linux-2.6.21.1/arch/i386/lib: .lib.a.cmd
Only in linux-2.6.21.1/arch/i386/lib: .memcpy.o.cmd
Only in linux-2.6.21.1/arch/i386/lib: .putuser.o.cmd
Only in linux-2.6.21.1/arch/i386/lib: .semaphore.o.cmd
Only in linux-2.6.21.1/arch/i386/lib: .strstr.o.cmd
Only in linux-2.6.21.1/arch/i386/lib: .usercopy.o.cmd
Only in linux-2.6.21.1/arch/i386/lib: bitops.o
Only in linux-2.6.21.1/arch/i386/lib: built-in.o
Only in linux-2.6.21.1/arch/i386/lib: checksum.o
diff -r -u linux-2.6.21.1/arch/i386/lib/delay.c linux-2.6.21.1-386/arch/i386/lib/delay.c
--- linux-2.6.21.1/arch/i386/lib/delay.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/lib/delay.c	2007-07-03 12:31:45.000000000 +0000
@@ -37,6 +37,7 @@
 		:"0" (loops));
 }
 
+#ifdef CONFIG_X86_TSC
 /* TSC based delay: */
 static void delay_tsc(unsigned long loops)
 {
@@ -48,6 +49,7 @@
 		rdtscl(now);
 	} while ((now-bclock) < loops);
 }
+#endif
 
 /*
  * Since we calibrate only once at boot, this
@@ -55,17 +57,21 @@
  */
 static void (*delay_fn)(unsigned long) = delay_loop;
 
+#ifdef CONFIG_X86_TSC
 void use_tsc_delay(void)
 {
 	delay_fn = delay_tsc;
 }
+#endif
 
 int read_current_timer(unsigned long *timer_val)
 {
+#ifdef CONFIG_X86_TSC
 	if (delay_fn == delay_tsc) {
 		rdtscl(*timer_val);
 		return 0;
 	}
+#endif
 	return -1;
 }
 
Only in linux-2.6.21.1/arch/i386/lib: delay.o
Only in linux-2.6.21.1/arch/i386/lib: getuser.o
Only in linux-2.6.21.1/arch/i386/lib: lib.a
Only in linux-2.6.21.1/arch/i386/lib: memcpy.o
Only in linux-2.6.21.1/arch/i386/lib: putuser.o
Only in linux-2.6.21.1/arch/i386/lib: semaphore.o
Only in linux-2.6.21.1/arch/i386/lib: strstr.o
Only in linux-2.6.21.1/arch/i386/lib: usercopy.o
Only in linux-2.6.21.1/arch/i386/mach-default: .built-in.o.cmd
Only in linux-2.6.21.1/arch/i386/mach-default: .setup.o.cmd
Only in linux-2.6.21.1/arch/i386/mach-default: built-in.o
Only in linux-2.6.21.1/arch/i386/mach-default: setup.o
Only in linux-2.6.21.1/arch/i386/math-emu: .built-in.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .div_Xsig.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .div_small.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .errors.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .fpu_arith.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .fpu_aux.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .fpu_entry.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .fpu_etc.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .fpu_tags.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .fpu_trig.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .get_address.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .load_store.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .mul_Xsig.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .poly_2xm1.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .poly_atan.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .poly_l2.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .poly_sin.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .poly_tan.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .polynom_Xsig.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_add_sub.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_compare.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_constant.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_convert.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_divide.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_ld_str.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_mul.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_norm.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_round.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_u_add.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_u_div.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_u_mul.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .reg_u_sub.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .round_Xsig.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .shr_Xsig.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .wm_shrx.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: .wm_sqrt.o.cmd
Only in linux-2.6.21.1/arch/i386/math-emu: built-in.o
Only in linux-2.6.21.1/arch/i386/math-emu: div_Xsig.o
Only in linux-2.6.21.1/arch/i386/math-emu: div_small.o
Only in linux-2.6.21.1/arch/i386/math-emu: errors.o
Only in linux-2.6.21.1/arch/i386/math-emu: fpu_arith.o
Only in linux-2.6.21.1/arch/i386/math-emu: fpu_aux.o
Only in linux-2.6.21.1/arch/i386/math-emu: fpu_entry.o
Only in linux-2.6.21.1/arch/i386/math-emu: fpu_etc.o
Only in linux-2.6.21.1/arch/i386/math-emu: fpu_tags.o
Only in linux-2.6.21.1/arch/i386/math-emu: fpu_trig.o
Only in linux-2.6.21.1/arch/i386/math-emu: get_address.o
Only in linux-2.6.21.1/arch/i386/math-emu: load_store.o
Only in linux-2.6.21.1/arch/i386/math-emu: mul_Xsig.o
Only in linux-2.6.21.1/arch/i386/math-emu: poly_2xm1.o
Only in linux-2.6.21.1/arch/i386/math-emu: poly_atan.o
Only in linux-2.6.21.1/arch/i386/math-emu: poly_l2.o
Only in linux-2.6.21.1/arch/i386/math-emu: poly_sin.o
Only in linux-2.6.21.1/arch/i386/math-emu: poly_tan.o
Only in linux-2.6.21.1/arch/i386/math-emu: polynom_Xsig.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_add_sub.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_compare.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_constant.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_convert.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_divide.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_ld_str.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_mul.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_norm.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_round.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_u_add.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_u_div.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_u_mul.o
Only in linux-2.6.21.1/arch/i386/math-emu: reg_u_sub.o
Only in linux-2.6.21.1/arch/i386/math-emu: round_Xsig.o
Only in linux-2.6.21.1/arch/i386/math-emu: shr_Xsig.o
Only in linux-2.6.21.1/arch/i386/math-emu: wm_shrx.o
Only in linux-2.6.21.1/arch/i386/math-emu: wm_sqrt.o
Only in linux-2.6.21.1/arch/i386/mm: .built-in.o.cmd
Only in linux-2.6.21.1/arch/i386/mm: .extable.o.cmd
Only in linux-2.6.21.1/arch/i386/mm: .fault.o.cmd
Only in linux-2.6.21.1/arch/i386/mm: .init.o.cmd
Only in linux-2.6.21.1/arch/i386/mm: .ioremap.o.cmd
Only in linux-2.6.21.1/arch/i386/mm: .mmap.o.cmd
Only in linux-2.6.21.1/arch/i386/mm: .pageattr.o.cmd
Only in linux-2.6.21.1/arch/i386/mm: .pgtable.o.cmd
Only in linux-2.6.21.1/arch/i386/mm: built-in.o
Only in linux-2.6.21.1/arch/i386/mm: extable.o
Only in linux-2.6.21.1/arch/i386/mm: fault.o
diff -r -u linux-2.6.21.1/arch/i386/mm/init.c linux-2.6.21.1-386/arch/i386/mm/init.c
--- linux-2.6.21.1/arch/i386/mm/init.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/arch/i386/mm/init.c	2007-07-03 13:59:52.000000000 +0000
@@ -187,12 +187,14 @@
 	}
 }
 
+#ifndef CONFIG_X86_DONT_CPUID
 static inline int page_kills_ppro(unsigned long pagenr)
 {
 	if (pagenr >= 0x70000 && pagenr <= 0x7003F)
 		return 1;
 	return 0;
 }
+#endif
 
 int page_is_ram(unsigned long pagenr)
 {
@@ -565,16 +567,24 @@
 
 void __init mem_init(void)
 {
+#ifndef CONFIG_X86_DONT_CPUID
 	extern int ppro_with_ram_bug(void);
+#endif
 	int codesize, reservedpages, datasize, initsize;
 	int tmp;
+#ifndef CONFIG_X86_DONT_CPUID
 	int bad_ppro;
+#else
+#  define bad_ppro 0
+#endif
 
 #ifdef CONFIG_FLATMEM
 	BUG_ON(!mem_map);
 #endif
 	
+#ifndef CONFIG_X86_DONT_CPUID
 	bad_ppro = ppro_with_ram_bug();
+#endif
 
 #ifdef CONFIG_HIGHMEM
 	/* check that fixmap and pkmap do not overlap */
Only in linux-2.6.21.1/arch/i386/mm: init.o
Only in linux-2.6.21.1/arch/i386/mm: ioremap.o
Only in linux-2.6.21.1/arch/i386/mm: mmap.o
Only in linux-2.6.21.1/arch/i386/mm: pageattr.o
Only in linux-2.6.21.1/arch/i386/mm: pgtable.o
Only in linux-2.6.21.1/block: .built-in.o.cmd
Only in linux-2.6.21.1/block: .elevator.o.cmd
Only in linux-2.6.21.1/block: .genhd.o.cmd
Only in linux-2.6.21.1/block: .ioctl.o.cmd
Only in linux-2.6.21.1/block: .ll_rw_blk.o.cmd
Only in linux-2.6.21.1/block: .noop-iosched.o.cmd
Only in linux-2.6.21.1/block: .scsi_ioctl.o.cmd
Only in linux-2.6.21.1/block: built-in.o
Only in linux-2.6.21.1/block: elevator.o
Only in linux-2.6.21.1/block: genhd.o
Only in linux-2.6.21.1/block: ioctl.o
Only in linux-2.6.21.1/block: ll_rw_blk.o
Only in linux-2.6.21.1/block: noop-iosched.o
Only in linux-2.6.21.1/block: scsi_ioctl.o
Only in linux-2.6.21.1/crypto: .built-in.o.cmd
Only in linux-2.6.21.1/crypto: built-in.o
Only in linux-2.6.21.1/drivers: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/auxdisplay: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/auxdisplay: built-in.o
Only in linux-2.6.21.1/drivers/base: .attribute_container.o.cmd
Only in linux-2.6.21.1/drivers/base: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/base: .bus.o.cmd
Only in linux-2.6.21.1/drivers/base: .class.o.cmd
Only in linux-2.6.21.1/drivers/base: .core.o.cmd
Only in linux-2.6.21.1/drivers/base: .cpu.o.cmd
Only in linux-2.6.21.1/drivers/base: .dd.o.cmd
Only in linux-2.6.21.1/drivers/base: .devres.o.cmd
Only in linux-2.6.21.1/drivers/base: .dma-mapping.o.cmd
Only in linux-2.6.21.1/drivers/base: .dmapool.o.cmd
Only in linux-2.6.21.1/drivers/base: .driver.o.cmd
Only in linux-2.6.21.1/drivers/base: .firmware.o.cmd
Only in linux-2.6.21.1/drivers/base: .firmware_class.ko.cmd
Only in linux-2.6.21.1/drivers/base: .firmware_class.mod.o.cmd
Only in linux-2.6.21.1/drivers/base: .firmware_class.o.cmd
Only in linux-2.6.21.1/drivers/base: .init.o.cmd
Only in linux-2.6.21.1/drivers/base: .isa.o.cmd
Only in linux-2.6.21.1/drivers/base: .map.o.cmd
Only in linux-2.6.21.1/drivers/base: .platform.o.cmd
Only in linux-2.6.21.1/drivers/base: .sys.o.cmd
Only in linux-2.6.21.1/drivers/base: .transport_class.o.cmd
Only in linux-2.6.21.1/drivers/base: attribute_container.o
Only in linux-2.6.21.1/drivers/base: built-in.o
Only in linux-2.6.21.1/drivers/base: bus.o
Only in linux-2.6.21.1/drivers/base: class.o
Only in linux-2.6.21.1/drivers/base: core.o
Only in linux-2.6.21.1/drivers/base: cpu.o
Only in linux-2.6.21.1/drivers/base: dd.o
Only in linux-2.6.21.1/drivers/base: devres.o
Only in linux-2.6.21.1/drivers/base: dma-mapping.o
Only in linux-2.6.21.1/drivers/base: dmapool.o
Only in linux-2.6.21.1/drivers/base: driver.o
Only in linux-2.6.21.1/drivers/base: firmware.o
Only in linux-2.6.21.1/drivers/base: firmware_class.ko
Only in linux-2.6.21.1/drivers/base: firmware_class.mod.c
Only in linux-2.6.21.1/drivers/base: firmware_class.mod.o
Only in linux-2.6.21.1/drivers/base: firmware_class.o
Only in linux-2.6.21.1/drivers/base: init.o
Only in linux-2.6.21.1/drivers/base: isa.o
Only in linux-2.6.21.1/drivers/base: map.o
Only in linux-2.6.21.1/drivers/base: platform.o
Only in linux-2.6.21.1/drivers/base/power: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/base/power: .shutdown.o.cmd
Only in linux-2.6.21.1/drivers/base/power: built-in.o
Only in linux-2.6.21.1/drivers/base/power: shutdown.o
Only in linux-2.6.21.1/drivers/base: sys.o
Only in linux-2.6.21.1/drivers/base: transport_class.o
Only in linux-2.6.21.1/drivers/block: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/block: .floppy.ko.cmd
Only in linux-2.6.21.1/drivers/block: .floppy.mod.o.cmd
Only in linux-2.6.21.1/drivers/block: .floppy.o.cmd
Only in linux-2.6.21.1/drivers/block: .loop.ko.cmd
Only in linux-2.6.21.1/drivers/block: .loop.mod.o.cmd
Only in linux-2.6.21.1/drivers/block: .loop.o.cmd
Only in linux-2.6.21.1/drivers/block: .rd.ko.cmd
Only in linux-2.6.21.1/drivers/block: .rd.mod.o.cmd
Only in linux-2.6.21.1/drivers/block: .rd.o.cmd
Only in linux-2.6.21.1/drivers/block: .xd.ko.cmd
Only in linux-2.6.21.1/drivers/block: .xd.mod.o.cmd
Only in linux-2.6.21.1/drivers/block: .xd.o.cmd
Only in linux-2.6.21.1/drivers/block: built-in.o
Only in linux-2.6.21.1/drivers/block: floppy.ko
Only in linux-2.6.21.1/drivers/block: floppy.mod.c
Only in linux-2.6.21.1/drivers/block: floppy.mod.o
Only in linux-2.6.21.1/drivers/block: floppy.o
Only in linux-2.6.21.1/drivers/block: loop.ko
Only in linux-2.6.21.1/drivers/block: loop.mod.c
Only in linux-2.6.21.1/drivers/block: loop.mod.o
Only in linux-2.6.21.1/drivers/block: loop.o
Only in linux-2.6.21.1/drivers/block: rd.ko
Only in linux-2.6.21.1/drivers/block: rd.mod.c
Only in linux-2.6.21.1/drivers/block: rd.mod.o
Only in linux-2.6.21.1/drivers/block: rd.o
Only in linux-2.6.21.1/drivers/block: xd.ko
Only in linux-2.6.21.1/drivers/block: xd.mod.c
Only in linux-2.6.21.1/drivers/block: xd.mod.o
Only in linux-2.6.21.1/drivers/block: xd.o
Only in linux-2.6.21.1/drivers: built-in.o
Only in linux-2.6.21.1/drivers/cdrom: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/cdrom: .cdrom.ko.cmd
Only in linux-2.6.21.1/drivers/cdrom: .cdrom.mod.o.cmd
Only in linux-2.6.21.1/drivers/cdrom: .cdrom.o.cmd
Only in linux-2.6.21.1/drivers/cdrom: built-in.o
Only in linux-2.6.21.1/drivers/cdrom: cdrom.ko
Only in linux-2.6.21.1/drivers/cdrom: cdrom.mod.c
Only in linux-2.6.21.1/drivers/cdrom: cdrom.mod.o
Only in linux-2.6.21.1/drivers/cdrom: cdrom.o
Only in linux-2.6.21.1/drivers/char: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/char: .consolemap.o.cmd
Only in linux-2.6.21.1/drivers/char: .consolemap_deftbl.o.cmd
Only in linux-2.6.21.1/drivers/char: .defkeymap.o.cmd
Only in linux-2.6.21.1/drivers/char: .genrtc.ko.cmd
Only in linux-2.6.21.1/drivers/char: .genrtc.mod.o.cmd
Only in linux-2.6.21.1/drivers/char: .genrtc.o.cmd
Only in linux-2.6.21.1/drivers/char: .keyboard.o.cmd
Only in linux-2.6.21.1/drivers/char: .lp.ko.cmd
Only in linux-2.6.21.1/drivers/char: .lp.mod.o.cmd
Only in linux-2.6.21.1/drivers/char: .lp.o.cmd
Only in linux-2.6.21.1/drivers/char: .mem.o.cmd
Only in linux-2.6.21.1/drivers/char: .misc.o.cmd
Only in linux-2.6.21.1/drivers/char: .n_tty.o.cmd
Only in linux-2.6.21.1/drivers/char: .nvram.ko.cmd
Only in linux-2.6.21.1/drivers/char: .nvram.mod.o.cmd
Only in linux-2.6.21.1/drivers/char: .nvram.o.cmd
Only in linux-2.6.21.1/drivers/char: .ppdev.ko.cmd
Only in linux-2.6.21.1/drivers/char: .ppdev.mod.o.cmd
Only in linux-2.6.21.1/drivers/char: .ppdev.o.cmd
Only in linux-2.6.21.1/drivers/char: .random.o.cmd
Only in linux-2.6.21.1/drivers/char: .rtc.ko.cmd
Only in linux-2.6.21.1/drivers/char: .rtc.mod.o.cmd
Only in linux-2.6.21.1/drivers/char: .rtc.o.cmd
Only in linux-2.6.21.1/drivers/char: .selection.o.cmd
Only in linux-2.6.21.1/drivers/char: .tipar.ko.cmd
Only in linux-2.6.21.1/drivers/char: .tipar.mod.o.cmd
Only in linux-2.6.21.1/drivers/char: .tipar.o.cmd
Only in linux-2.6.21.1/drivers/char: .tty_io.o.cmd
Only in linux-2.6.21.1/drivers/char: .tty_ioctl.o.cmd
Only in linux-2.6.21.1/drivers/char: .vc_screen.o.cmd
Only in linux-2.6.21.1/drivers/char: .vt.o.cmd
Only in linux-2.6.21.1/drivers/char: .vt_ioctl.o.cmd
Only in linux-2.6.21.1/drivers/char: built-in.o
Only in linux-2.6.21.1/drivers/char: consolemap.o
Only in linux-2.6.21.1/drivers/char: consolemap_deftbl.c
Only in linux-2.6.21.1/drivers/char: consolemap_deftbl.o
Only in linux-2.6.21.1/drivers/char: defkeymap.c
Only in linux-2.6.21.1/drivers/char: defkeymap.o
Only in linux-2.6.21.1/drivers/char: genrtc.ko
Only in linux-2.6.21.1/drivers/char: genrtc.mod.c
Only in linux-2.6.21.1/drivers/char: genrtc.mod.o
Only in linux-2.6.21.1/drivers/char: genrtc.o
Only in linux-2.6.21.1/drivers/char: keyboard.o
Only in linux-2.6.21.1/drivers/char: lp.ko
Only in linux-2.6.21.1/drivers/char: lp.mod.c
Only in linux-2.6.21.1/drivers/char: lp.mod.o
Only in linux-2.6.21.1/drivers/char: lp.o
Only in linux-2.6.21.1/drivers/char: mem.o
Only in linux-2.6.21.1/drivers/char: misc.o
Only in linux-2.6.21.1/drivers/char: n_tty.o
Only in linux-2.6.21.1/drivers/char: nvram.ko
Only in linux-2.6.21.1/drivers/char: nvram.mod.c
Only in linux-2.6.21.1/drivers/char: nvram.mod.o
Only in linux-2.6.21.1/drivers/char: nvram.o
Only in linux-2.6.21.1/drivers/char: ppdev.ko
Only in linux-2.6.21.1/drivers/char: ppdev.mod.c
Only in linux-2.6.21.1/drivers/char: ppdev.mod.o
Only in linux-2.6.21.1/drivers/char: ppdev.o
Only in linux-2.6.21.1/drivers/char: random.o
Only in linux-2.6.21.1/drivers/char: rtc.ko
Only in linux-2.6.21.1/drivers/char: rtc.mod.c
Only in linux-2.6.21.1/drivers/char: rtc.mod.o
Only in linux-2.6.21.1/drivers/char: rtc.o
Only in linux-2.6.21.1/drivers/char: selection.o
Only in linux-2.6.21.1/drivers/char: tipar.ko
Only in linux-2.6.21.1/drivers/char: tipar.mod.c
Only in linux-2.6.21.1/drivers/char: tipar.mod.o
Only in linux-2.6.21.1/drivers/char: tipar.o
Only in linux-2.6.21.1/drivers/char: tty_io.o
Only in linux-2.6.21.1/drivers/char: tty_ioctl.o
Only in linux-2.6.21.1/drivers/char: vc_screen.o
Only in linux-2.6.21.1/drivers/char: vt.o
Only in linux-2.6.21.1/drivers/char: vt_ioctl.o
Only in linux-2.6.21.1/drivers/clocksource: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/clocksource: built-in.o
Only in linux-2.6.21.1/drivers/firmware: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/firmware: .dmi_scan.o.cmd
diff -r -u linux-2.6.21.1/drivers/firmware/Kconfig linux-2.6.21.1-386/drivers/firmware/Kconfig
--- linux-2.6.21.1/drivers/firmware/Kconfig	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/drivers/firmware/Kconfig	2007-07-03 12:12:24.000000000 +0000
@@ -5,6 +5,15 @@
 
 menu "Firmware Drivers"
 
+config DMI_SCAN
+	bool "Scan BIOS DMI information"
+	default y
+	help
+	  Say Y here if you want the Linux kernel to read the DMI information
+	  that is present in most modern BIOSes. This is recommended unless you
+	  are compiling a kernel for legacy Pentium/486/386 systems that do not
+	  have this information.
+
 config EDD
 	tristate "BIOS Enhanced Disk Drive calls determine boot disk"
 	depends on !IA64
diff -r -u linux-2.6.21.1/drivers/firmware/Makefile linux-2.6.21.1-386/drivers/firmware/Makefile
--- linux-2.6.21.1/drivers/firmware/Makefile	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/drivers/firmware/Makefile	2007-07-03 12:10:40.000000000 +0000
@@ -1,7 +1,9 @@
 #
 # Makefile for the linux kernel.
 #
+ifdef CONFIG_DMI_SCAN
 obj-$(CONFIG_DMI)		+= dmi_scan.o
+endif
 obj-$(CONFIG_EDD)		+= edd.o
 obj-$(CONFIG_EFI_VARS)		+= efivars.o
 obj-$(CONFIG_EFI_PCDP)		+= pcdp.o
Only in linux-2.6.21.1/drivers/firmware: built-in.o
Only in linux-2.6.21.1/drivers/firmware: dmi_scan.o
Only in linux-2.6.21.1/drivers/ide: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-cd.ko.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-cd.mod.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-cd.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-core.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-disk.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-floppy.ko.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-floppy.mod.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-floppy.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-generic.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-io.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-iops.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-lib.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-probe.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-proc.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-tape.ko.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-tape.mod.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-tape.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide-taskfile.o.cmd
Only in linux-2.6.21.1/drivers/ide: .ide.o.cmd
diff -r -u linux-2.6.21.1/drivers/ide/Kconfig linux-2.6.21.1-386/drivers/ide/Kconfig
--- linux-2.6.21.1/drivers/ide/Kconfig	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/drivers/ide/Kconfig	2007-07-03 16:34:12.000000000 +0000
@@ -291,6 +291,21 @@
 
 	  If you are unsure, say N here.
 
+config IDE_DONT_PIO
+	bool "Disable IDE PIO modes"
+	default n
+	---help---
+	  If you are building a Linux kernel for really old 386/486 systems you
+	  can enable this option to cut out all support for PIO transfers.
+
+config IDE_DISABLE_LBA48
+	bool "Disable LBA48 support"
+	default n
+	---help---
+	  If you are building a Linux kernel for legacy 386/486 systems that
+	  will never talk to large hard drives, you can say Y here to cut out
+	  LBA48 support
+
 comment "IDE chipset support/bugfixes"
 
 config IDE_GENERIC
diff -r -u linux-2.6.21.1/drivers/ide/Makefile linux-2.6.21.1-386/drivers/ide/Makefile
--- linux-2.6.21.1/drivers/ide/Makefile	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/drivers/ide/Makefile	2007-07-03 15:37:25.000000000 +0000
@@ -13,7 +13,8 @@
 
 obj-$(CONFIG_BLK_DEV_IDE)		+= pci/
 
-ide-core-y += ide.o ide-io.o ide-iops.o ide-lib.o ide-probe.o ide-taskfile.o
+ide-core-y += ide.o ide-io.o ide-iops.o ide-lib.o ide-probe.o
+ide-core-y += ide-taskfile.o
 
 ide-core-$(CONFIG_BLK_DEV_CMD640)	+= pci/cmd640.o
 
Only in linux-2.6.21.1/drivers/ide/arm: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/ide/arm: built-in.o
Only in linux-2.6.21.1/drivers/ide: built-in.o
Only in linux-2.6.21.1/drivers/ide: ide-cd.ko
Only in linux-2.6.21.1/drivers/ide: ide-cd.mod.c
Only in linux-2.6.21.1/drivers/ide: ide-cd.mod.o
Only in linux-2.6.21.1/drivers/ide: ide-cd.o
Only in linux-2.6.21.1/drivers/ide: ide-core.o
diff -r -u linux-2.6.21.1/drivers/ide/ide-disk.c linux-2.6.21.1-386/drivers/ide/ide-disk.c
--- linux-2.6.21.1/drivers/ide/ide-disk.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/drivers/ide/ide-disk.c	2007-07-03 16:50:30.000000000 +0000
@@ -163,18 +163,24 @@
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	unsigned int dma	= drive->using_dma;
+#ifndef CONFIG_IDE_DISABLE_LBA48
 	u8 lba48		= (drive->addressing == 1) ? 1 : 0;
+#else
+#  define lba48 ((u8)0)
+#endif
 	task_ioreg_t command	= WIN_NOP;
 	ata_nsector_t		nsectors;
 
 	nsectors.all		= (u16) rq->nr_sectors;
 
+#ifndef CONFIG_IDE_DISABLE_LBA48
 	if (hwif->no_lba48_dma && lba48 && dma) {
 		if (block + rq->nr_sectors > 1ULL << 28)
 			dma = 0;
 		else
 			lba48 = 0;
 	}
+#endif
 
 	if (!dma) {
 		ide_init_sg_cmd(drive, rq);
@@ -484,7 +490,9 @@
 static void idedisk_check_hpa(ide_drive_t *drive)
 {
 	unsigned long long capacity, set_max;
+#ifndef CONFIG_IDE_DISABLE_LBA48
 	int lba48 = idedisk_supports_lba48(drive->id);
+#endif
 
 	capacity = drive->capacity64;
 	if (lba48)
@@ -777,7 +785,11 @@
 		 */
 		capacity = idedisk_capacity(drive);
 		barrier = ide_id_has_flush_cache(id) && !drive->noflush &&
+#ifndef CONFIG_IDE_DISABLE_LBA48
 			(drive->addressing == 0 || capacity <= (1ULL << 28) ||
+#else
+			(capacity <= (1ULL << 28) ||
+#endif
 			 ide_id_has_flush_cache_ext(id));
 
 		printk(KERN_INFO "%s: cache flushes %ssupported\n",
@@ -847,6 +859,7 @@
 	return 0;
 }
 
+#ifndef CONFIG_IDE_DISABLE_LBA48
 /*
  * drive->addressing:
  *	0: 28-bit
@@ -865,6 +878,7 @@
 	drive->addressing = arg;
 	return 0;
 }
+#endif
 
 static void idedisk_add_settings(ide_drive_t *drive)
 {
@@ -873,7 +887,9 @@
 	ide_add_setting(drive,	"bios_cyl",		SETTING_RW,					-1,			-1,			TYPE_INT,	0,	65535,				1,	1,	&drive->bios_cyl,		NULL);
 	ide_add_setting(drive,	"bios_head",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	255,				1,	1,	&drive->bios_head,		NULL);
 	ide_add_setting(drive,	"bios_sect",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	63,				1,	1,	&drive->bios_sect,		NULL);
+#ifndef CONFIG_IDE_DISABLE_LBA48
 	ide_add_setting(drive,	"address",		SETTING_RW,					HDIO_GET_ADDRESS,	HDIO_SET_ADDRESS,	TYPE_INTA,	0,	2,				1,	1,	&drive->addressing,	set_lba_addressing);
+#endif
 	ide_add_setting(drive,	"bswap",		SETTING_READ,					-1,			-1,			TYPE_BYTE,	0,	1,				1,	1,	&drive->bswap,			NULL);
 	ide_add_setting(drive,	"multcount",		id ? SETTING_RW : SETTING_READ,			HDIO_GET_MULTCOUNT,	HDIO_SET_MULTCOUNT,	TYPE_BYTE,	0,	id ? id->max_multsect : 0,	1,	1,	&drive->mult_count,		set_multcount);
 	ide_add_setting(drive,	"nowerr",		SETTING_RW,					HDIO_GET_NOWERR,	HDIO_SET_NOWERR,	TYPE_BYTE,	0,	1,				1,	1,	&drive->nowerr,			set_nowerr);
@@ -903,6 +919,7 @@
 		}
 	}
 
+#ifndef CONFIG_IDE_DISABLE_LBA48
 	(void)set_lba_addressing(drive, 1);
 
 	if (drive->addressing == 1) {
@@ -914,6 +931,7 @@
 
 		blk_queue_max_sectors(drive->queue, max_s);
 	}
+#endif
 
 	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name, drive->queue->max_sectors / 2);
 
@@ -921,6 +939,7 @@
 	init_idedisk_capacity (drive);
 
 	/* limit drive capacity to 137GB if LBA48 cannot be used */
+#ifndef CONFIG_IDE_DISABLE_LBA48
 	if (drive->addressing == 0 && drive->capacity64 > 1ULL << 28) {
 		printk(KERN_WARNING "%s: cannot use LBA48 - full capacity "
 		       "%llu sectors (%llu MB)\n",
@@ -937,6 +956,7 @@
 		} else
 			drive->addressing = 0;
 	}
+#endif
 
 	/*
 	 * if possible, give fdisk access to more of the drive,
Only in linux-2.6.21.1/drivers/ide: ide-disk.o
Only in linux-2.6.21.1/drivers/ide: ide-floppy.ko
Only in linux-2.6.21.1/drivers/ide: ide-floppy.mod.c
Only in linux-2.6.21.1/drivers/ide: ide-floppy.mod.o
Only in linux-2.6.21.1/drivers/ide: ide-floppy.o
Only in linux-2.6.21.1/drivers/ide: ide-generic.o
diff -r -u linux-2.6.21.1/drivers/ide/ide-io.c linux-2.6.21.1-386/drivers/ide/ide-io.c
--- linux-2.6.21.1/drivers/ide/ide-io.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/drivers/ide/ide-io.c	2007-07-03 16:36:28.000000000 +0000
@@ -422,7 +422,7 @@
 			args->tfRegister[IDE_HCYL_OFFSET]    = hwif->INB(IDE_HCYL_REG);
 			args->tfRegister[IDE_SELECT_OFFSET]  = hwif->INB(IDE_SELECT_REG);
 			args->tfRegister[IDE_STATUS_OFFSET]  = stat;
-
+#ifndef CONFIG_IDE_DISABLE_LBA48
 			if (drive->addressing == 1) {
 				hwif->OUTB(drive->ctl|0x80, IDE_CONTROL_REG);
 				args->hobRegister[IDE_FEATURE_OFFSET]	= hwif->INB(IDE_FEATURE_REG);
@@ -431,6 +431,7 @@
 				args->hobRegister[IDE_LCYL_OFFSET]	= hwif->INB(IDE_LCYL_REG);
 				args->hobRegister[IDE_HCYL_OFFSET]	= hwif->INB(IDE_HCYL_REG);
 			}
+#endif
 		}
 	} else if (blk_pm_request(rq)) {
 		struct request_pm_state *pm = rq->data;
Only in linux-2.6.21.1/drivers/ide: ide-io.o
Only in linux-2.6.21.1/drivers/ide: ide-iops.o
diff -r -u linux-2.6.21.1/drivers/ide/ide-lib.c linux-2.6.21.1-386/drivers/ide/ide-lib.c
--- linux-2.6.21.1/drivers/ide/ide-lib.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/drivers/ide/ide-lib.c	2007-07-03 16:36:58.000000000 +0000
@@ -31,6 +31,7 @@
  */
  
 
+#ifdef CONFIG_PCI
 /**
  *	ide_xfer_verbose	-	return IDE mode names
  *	@xfer_rate: rate to name
@@ -67,7 +68,9 @@
 }
 
 EXPORT_SYMBOL(ide_xfer_verbose);
+#endif
 
+#ifdef CONFIG_BLK_DEV_IDEDMA
 /**
  *	ide_dma_speed	-	compute DMA speed
  *	@drive: drive
@@ -162,7 +165,7 @@
 	return speed;
 }
 EXPORT_SYMBOL(ide_dma_speed);
-
+#endif
 
 /**
  *	ide_rate_filter		-	return best speed for mode
@@ -193,6 +196,7 @@
 
 EXPORT_SYMBOL(ide_rate_filter);
 
+#ifdef CONFIG_BLK_DEV_IDEDMA
 int ide_dma_enable (ide_drive_t *drive)
 {
 	ide_hwif_t *hwif	= HWIF(drive);
@@ -204,7 +208,9 @@
 }
 
 EXPORT_SYMBOL(ide_dma_enable);
+#endif
 
+#ifndef CONFIG_IDE_DONT_PIO
 int ide_use_fast_pio(ide_drive_t *drive)
 {
 	struct hd_driveid *id = drive->id;
@@ -445,6 +451,7 @@
 	if (drive->queue)
 		blk_queue_bounce_limit(drive->queue, addr);
 }
+#endif
 
 /**
  *	ide_set_xfer_rate	-	set transfer rate
@@ -537,6 +544,7 @@
 		printk("}");
 		if ((err & (BBD_ERR | ABRT_ERR)) == BBD_ERR ||
 		    (err & (ECC_ERR|ID_ERR|MARK_ERR))) {
+#ifndef CONFIG_IDE_DISABLE_LBA48
 			if (drive->addressing == 1) {
 				__u64 sectors = 0;
 				u32 low = 0, high = 0;
@@ -548,6 +556,9 @@
 				       (unsigned long long) sectors,
 				       high, low);
 			} else {
+#else
+			{
+#endif
 				u8 cur = hwif->INB(IDE_SELECT_REG);
 				if (cur & 0x40) {	/* using LBA? */
 					printk(", LBAsect=%ld", (unsigned long)
@@ -582,7 +593,7 @@
  *
  *	Error reporting, in human readable form (luxurious, but a memory hog).
  */
-
+#ifdef CONFIG_BLK_DEV_IDECD
 static u8 ide_dump_atapi_status(ide_drive_t *drive, const char *msg, u8 stat)
 {
 	unsigned long flags;
@@ -621,6 +632,7 @@
 	local_irq_restore(flags);
 	return error.all;
 }
+#endif
 
 /**
  *	ide_dump_status		-	translate ATA/ATAPI error
@@ -635,9 +647,13 @@
 
 u8 ide_dump_status(ide_drive_t *drive, const char *msg, u8 stat)
 {
+#ifdef CONFIG_BLK_DEV_IDECD
 	if (drive->media == ide_disk)
 		return ide_dump_ata_status(drive, msg, stat);
 	return ide_dump_atapi_status(drive, msg, stat);
+#else
+	return ide_dump_ata_status(drive, msg, stat);
+#endif
 }
 
 EXPORT_SYMBOL(ide_dump_status);
Only in linux-2.6.21.1/drivers/ide: ide-lib.o
diff -r -u linux-2.6.21.1/drivers/ide/ide-probe.c linux-2.6.21.1-386/drivers/ide/ide-probe.c
--- linux-2.6.21.1/drivers/ide/ide-probe.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/drivers/ide/ide-probe.c	2007-07-03 16:12:01.000000000 +0000
@@ -995,8 +995,10 @@
 	/* assign drive queue */
 	drive->queue = q;
 
+#ifndef CONFIG_IDE_DONT_PIO
 	/* needs drive->queue to be set */
 	ide_toggle_bounce(drive, 1);
+#endif
 
 	return 0;
 }
Only in linux-2.6.21.1/drivers/ide: ide-probe.o
Only in linux-2.6.21.1/drivers/ide: ide-proc.o
Only in linux-2.6.21.1/drivers/ide: ide-tape.ko
Only in linux-2.6.21.1/drivers/ide: ide-tape.mod.c
Only in linux-2.6.21.1/drivers/ide: ide-tape.mod.o
Only in linux-2.6.21.1/drivers/ide: ide-tape.o
diff -r -u linux-2.6.21.1/drivers/ide/ide-taskfile.c linux-2.6.21.1-386/drivers/ide/ide-taskfile.c
--- linux-2.6.21.1/drivers/ide/ide-taskfile.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/drivers/ide/ide-taskfile.c	2007-07-03 16:38:52.000000000 +0000
@@ -98,8 +98,12 @@
 {
 	ide_hwif_t *hwif	= HWIF(drive);
 	task_struct_t *taskfile	= (task_struct_t *) task->tfRegister;
+#ifndef CONFIG_IDE_DISABLE_LBA48
 	hob_struct_t *hobfile	= (hob_struct_t *) task->hobRegister;
 	u8 HIHI			= (drive->addressing == 1) ? 0xE0 : 0xEF;
+#else
+#  define HIHI ((u8)0)
+#endif
 
 	/* ALL Command Block Executions SHALL clear nIEN, unless otherwise */
 	if (IDE_CONTROL_REG) {
@@ -108,6 +112,7 @@
 	}
 	SELECT_MASK(drive, 0);
 
+#ifndef CONFIG_IDE_DISABLE_LBA48
 	if (drive->addressing == 1) {
 		hwif->OUTB(hobfile->feature, IDE_FEATURE_REG);
 		hwif->OUTB(hobfile->sector_count, IDE_NSECTOR_REG);
@@ -115,6 +120,7 @@
 		hwif->OUTB(hobfile->low_cylinder, IDE_LCYL_REG);
 		hwif->OUTB(hobfile->high_cylinder, IDE_HCYL_REG);
 	}
+#endif
 
 	hwif->OUTB(taskfile->feature, IDE_FEATURE_REG);
 	hwif->OUTB(taskfile->sector_count, IDE_NSECTOR_REG);
@@ -455,7 +461,11 @@
 		printk(KERN_ERR "%s: no DRQ after issuing %sWRITE%s\n",
 				drive->name,
 				drive->hwif->data_phase ? "MULT" : "",
+#ifndef CONFIG_IDE_DISABLE_LBA48
 				drive->addressing ? "_EXT" : "");
+#else
+				"");
+#endif
 		return startstop;
 	}
 
@@ -514,6 +524,7 @@
 
 EXPORT_SYMBOL(ide_raw_taskfile);
 
+#ifdef CONFIG_IDE_TASK_IOCTL
 int ide_taskfile_ioctl (ide_drive_t *drive, unsigned int cmd, unsigned long arg)
 {
 	ide_task_request_t	*req_task;
@@ -663,6 +674,7 @@
 
 	return err;
 }
+#endif
 
 int ide_wait_cmd (ide_drive_t *drive, u8 cmd, u8 nsect, u8 feature, u8 sectors, u8 *buf)
 {
@@ -794,8 +806,10 @@
 	 */
 	if (task->tf_in_flags.all == 0) {
 		task->tf_in_flags.all = IDE_TASKFILE_STD_IN_FLAGS;
+#ifndef CONFIG_IDE_DISABLE_LBA48
 		if (drive->addressing == 1)
 			task->tf_in_flags.all |= (IDE_HOB_STD_IN_FLAGS  << 8);
+#endif
         }
 
 	/* ALL Command Block Executions SHALL clear nIEN, unless otherwise */
@@ -866,3 +880,4 @@
 
 	return ide_started;
 }
+
Only in linux-2.6.21.1/drivers/ide: ide-taskfile.o
diff -r -u linux-2.6.21.1/drivers/ide/ide.c linux-2.6.21.1-386/drivers/ide/ide.c
--- linux-2.6.21.1/drivers/ide/ide.c	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/drivers/ide/ide.c	2007-07-03 16:10:27.000000000 +0000
@@ -1163,6 +1163,7 @@
 #endif
 }
 
+#ifndef CONFIG_IDE_DONT_PIO
 static int set_pio_mode (ide_drive_t *drive, int arg)
 {
 	struct request rq;
@@ -1177,6 +1178,7 @@
 	(void) ide_do_drive_cmd(drive, &rq, ide_wait);
 	return 0;
 }
+#endif
 
 static int set_xfer_rate (ide_drive_t *drive, int arg)
 {
@@ -1208,7 +1210,9 @@
 	__ide_add_setting(drive,	"io_32bit",		drive->no_io_32bit ? SETTING_READ : SETTING_RW,	HDIO_GET_32BIT,		HDIO_SET_32BIT,		TYPE_BYTE,	0,	1 + (SUPPORT_VLB_SYNC << 1),	1,		1,		&drive->io_32bit,		set_io_32bit,	0);
 	__ide_add_setting(drive,	"keepsettings",		SETTING_RW,					HDIO_GET_KEEPSETTINGS,	HDIO_SET_KEEPSETTINGS,	TYPE_BYTE,	0,	1,				1,		1,		&drive->keep_settings,		NULL,		0);
 	__ide_add_setting(drive,	"nice1",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	1,				1,		1,		&drive->nice1,			NULL,		0);
+#ifndef CONFIG_IDE_DONT_PIO
 	__ide_add_setting(drive,	"pio_mode",		SETTING_WRITE,					-1,			HDIO_SET_PIO_MODE,	TYPE_BYTE,	0,	255,				1,		1,		NULL,				set_pio_mode,	0);
+#endif
 	__ide_add_setting(drive,	"unmaskirq",		drive->no_unmask ? SETTING_READ : SETTING_RW,	HDIO_GET_UNMASKINTR,	HDIO_SET_UNMASKINTR,	TYPE_BYTE,	0,	1,				1,		1,		&drive->unmask,			NULL,		0);
 	__ide_add_setting(drive,	"using_dma",		SETTING_RW,					HDIO_GET_DMA,		HDIO_SET_DMA,		TYPE_BYTE,	0,	1,				1,		1,		&drive->using_dma,		set_using_dma,	0);
 	__ide_add_setting(drive,	"init_speed",		SETTING_RW,					-1,			-1,			TYPE_BYTE,	0,	70,				1,		1,		&drive->init_speed,		NULL,		0);
Only in linux-2.6.21.1/drivers/ide: ide.o
Only in linux-2.6.21.1/drivers/ide/legacy: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/ide/legacy: built-in.o
Only in linux-2.6.21.1/drivers/ide/mips: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/ide/mips: built-in.o
Only in linux-2.6.21.1/drivers/ide/pci: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/ide/pci: built-in.o
Only in linux-2.6.21.1/drivers/input: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/input: .evdev.ko.cmd
Only in linux-2.6.21.1/drivers/input: .evdev.mod.o.cmd
Only in linux-2.6.21.1/drivers/input: .evdev.o.cmd
Only in linux-2.6.21.1/drivers/input: .ff-core.o.cmd
Only in linux-2.6.21.1/drivers/input: .input-core.o.cmd
Only in linux-2.6.21.1/drivers/input: .input.o.cmd
Only in linux-2.6.21.1/drivers/input: built-in.o
Only in linux-2.6.21.1/drivers/input: evdev.ko
Only in linux-2.6.21.1/drivers/input: evdev.mod.c
Only in linux-2.6.21.1/drivers/input: evdev.mod.o
Only in linux-2.6.21.1/drivers/input: evdev.o
Only in linux-2.6.21.1/drivers/input: ff-core.o
Only in linux-2.6.21.1/drivers/input: input-core.o
Only in linux-2.6.21.1/drivers/input: input.o
Only in linux-2.6.21.1/drivers/input/keyboard: .atkbd.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .lkkbd.ko.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .lkkbd.mod.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .lkkbd.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .newtonkbd.ko.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .newtonkbd.mod.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .newtonkbd.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .stowaway.ko.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .stowaway.mod.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .stowaway.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .sunkbd.ko.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .sunkbd.mod.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .sunkbd.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .xtkbd.ko.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .xtkbd.mod.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: .xtkbd.o.cmd
Only in linux-2.6.21.1/drivers/input/keyboard: atkbd.o
Only in linux-2.6.21.1/drivers/input/keyboard: built-in.o
Only in linux-2.6.21.1/drivers/input/keyboard: lkkbd.ko
Only in linux-2.6.21.1/drivers/input/keyboard: lkkbd.mod.c
Only in linux-2.6.21.1/drivers/input/keyboard: lkkbd.mod.o
Only in linux-2.6.21.1/drivers/input/keyboard: lkkbd.o
Only in linux-2.6.21.1/drivers/input/keyboard: newtonkbd.ko
Only in linux-2.6.21.1/drivers/input/keyboard: newtonkbd.mod.c
Only in linux-2.6.21.1/drivers/input/keyboard: newtonkbd.mod.o
Only in linux-2.6.21.1/drivers/input/keyboard: newtonkbd.o
Only in linux-2.6.21.1/drivers/input/keyboard: stowaway.ko
Only in linux-2.6.21.1/drivers/input/keyboard: stowaway.mod.c
Only in linux-2.6.21.1/drivers/input/keyboard: stowaway.mod.o
Only in linux-2.6.21.1/drivers/input/keyboard: stowaway.o
Only in linux-2.6.21.1/drivers/input/keyboard: sunkbd.ko
Only in linux-2.6.21.1/drivers/input/keyboard: sunkbd.mod.c
Only in linux-2.6.21.1/drivers/input/keyboard: sunkbd.mod.o
Only in linux-2.6.21.1/drivers/input/keyboard: sunkbd.o
Only in linux-2.6.21.1/drivers/input/keyboard: xtkbd.ko
Only in linux-2.6.21.1/drivers/input/keyboard: xtkbd.mod.c
Only in linux-2.6.21.1/drivers/input/keyboard: xtkbd.mod.o
Only in linux-2.6.21.1/drivers/input/keyboard: xtkbd.o
Only in linux-2.6.21.1/drivers/input/misc: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/input/misc: .pcspkr.ko.cmd
Only in linux-2.6.21.1/drivers/input/misc: .pcspkr.mod.o.cmd
Only in linux-2.6.21.1/drivers/input/misc: .pcspkr.o.cmd
Only in linux-2.6.21.1/drivers/input/misc: built-in.o
Only in linux-2.6.21.1/drivers/input/misc: pcspkr.ko
Only in linux-2.6.21.1/drivers/input/misc: pcspkr.mod.c
Only in linux-2.6.21.1/drivers/input/misc: pcspkr.mod.o
Only in linux-2.6.21.1/drivers/input/misc: pcspkr.o
Only in linux-2.6.21.1/drivers/input/serio: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/input/serio: .i8042.o.cmd
Only in linux-2.6.21.1/drivers/input/serio: .libps2.o.cmd
Only in linux-2.6.21.1/drivers/input/serio: .serio.o.cmd
Only in linux-2.6.21.1/drivers/input/serio: built-in.o
diff -r -u linux-2.6.21.1/drivers/input/serio/i8042-x86ia64io.h linux-2.6.21.1-386/drivers/input/serio/i8042-x86ia64io.h
--- linux-2.6.21.1/drivers/input/serio/i8042-x86ia64io.h	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/drivers/input/serio/i8042-x86ia64io.h	2007-07-03 12:17:06.000000000 +0000
@@ -63,7 +63,7 @@
 	outb(val, I8042_COMMAND_REG);
 }
 
-#if defined(__i386__)
+#if defined(__i386__) && defined(CONFIG_DMI_SCAN)
 
 #include <linux/dmi.h>
 
@@ -419,7 +419,7 @@
         i8042_reset = 1;
 #endif
 
-#if defined(__i386__)
+#if defined(__i386__) && defined(CONFIG_DMI_SCAN)
 	if (dmi_check_system(i8042_dmi_noloop_table))
 		i8042_noloop = 1;
 
Only in linux-2.6.21.1/drivers/input/serio: i8042.o
Only in linux-2.6.21.1/drivers/input/serio: libps2.o
Only in linux-2.6.21.1/drivers/input/serio: serio.o
Only in linux-2.6.21.1/drivers/macintosh: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/macintosh: built-in.o
Only in linux-2.6.21.1/drivers/media: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/media: built-in.o
Only in linux-2.6.21.1/drivers/media/common: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/media/common: built-in.o
Only in linux-2.6.21.1/drivers/mfd: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/mfd: built-in.o
Only in linux-2.6.21.1/drivers/misc: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/misc: built-in.o
Only in linux-2.6.21.1/drivers/net: .3c501.ko.cmd
Only in linux-2.6.21.1/drivers/net: .3c501.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .3c501.o.cmd
Only in linux-2.6.21.1/drivers/net: .3c503.ko.cmd
Only in linux-2.6.21.1/drivers/net: .3c503.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .3c503.o.cmd
Only in linux-2.6.21.1/drivers/net: .3c505.ko.cmd
Only in linux-2.6.21.1/drivers/net: .3c505.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .3c505.o.cmd
Only in linux-2.6.21.1/drivers/net: .3c507.ko.cmd
Only in linux-2.6.21.1/drivers/net: .3c507.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .3c507.o.cmd
Only in linux-2.6.21.1/drivers/net: .3c509.ko.cmd
Only in linux-2.6.21.1/drivers/net: .3c509.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .3c509.o.cmd
Only in linux-2.6.21.1/drivers/net: .3c515.ko.cmd
Only in linux-2.6.21.1/drivers/net: .3c515.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .3c515.o.cmd
Only in linux-2.6.21.1/drivers/net: .82596.ko.cmd
Only in linux-2.6.21.1/drivers/net: .82596.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .82596.o.cmd
Only in linux-2.6.21.1/drivers/net: .8390.ko.cmd
Only in linux-2.6.21.1/drivers/net: .8390.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .8390.o.cmd
Only in linux-2.6.21.1/drivers/net: .Space.o.cmd
Only in linux-2.6.21.1/drivers/net: .ac3200.ko.cmd
Only in linux-2.6.21.1/drivers/net: .ac3200.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .ac3200.o.cmd
Only in linux-2.6.21.1/drivers/net: .at1700.ko.cmd
Only in linux-2.6.21.1/drivers/net: .at1700.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .at1700.o.cmd
Only in linux-2.6.21.1/drivers/net: .atp.ko.cmd
Only in linux-2.6.21.1/drivers/net: .atp.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .atp.o.cmd
Only in linux-2.6.21.1/drivers/net: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/net: .cs89x0.ko.cmd
Only in linux-2.6.21.1/drivers/net: .cs89x0.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .cs89x0.o.cmd
Only in linux-2.6.21.1/drivers/net: .de600.ko.cmd
Only in linux-2.6.21.1/drivers/net: .de600.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .de600.o.cmd
Only in linux-2.6.21.1/drivers/net: .de620.ko.cmd
Only in linux-2.6.21.1/drivers/net: .de620.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .de620.o.cmd
Only in linux-2.6.21.1/drivers/net: .depca.ko.cmd
Only in linux-2.6.21.1/drivers/net: .depca.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .depca.o.cmd
Only in linux-2.6.21.1/drivers/net: .e2100.ko.cmd
Only in linux-2.6.21.1/drivers/net: .e2100.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .e2100.o.cmd
Only in linux-2.6.21.1/drivers/net: .eepro.ko.cmd
Only in linux-2.6.21.1/drivers/net: .eepro.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .eepro.o.cmd
Only in linux-2.6.21.1/drivers/net: .eexpress.ko.cmd
Only in linux-2.6.21.1/drivers/net: .eexpress.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .eexpress.o.cmd
Only in linux-2.6.21.1/drivers/net: .eth16i.ko.cmd
Only in linux-2.6.21.1/drivers/net: .eth16i.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .eth16i.o.cmd
Only in linux-2.6.21.1/drivers/net: .ewrk3.ko.cmd
Only in linux-2.6.21.1/drivers/net: .ewrk3.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .ewrk3.o.cmd
Only in linux-2.6.21.1/drivers/net: .hp-plus.ko.cmd
Only in linux-2.6.21.1/drivers/net: .hp-plus.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .hp-plus.o.cmd
Only in linux-2.6.21.1/drivers/net: .hp.ko.cmd
Only in linux-2.6.21.1/drivers/net: .hp.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .hp.o.cmd
Only in linux-2.6.21.1/drivers/net: .hp100.ko.cmd
Only in linux-2.6.21.1/drivers/net: .hp100.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .hp100.o.cmd
Only in linux-2.6.21.1/drivers/net: .lance.ko.cmd
Only in linux-2.6.21.1/drivers/net: .lance.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .lance.o.cmd
Only in linux-2.6.21.1/drivers/net: .loopback.o.cmd
Only in linux-2.6.21.1/drivers/net: .lp486e.ko.cmd
Only in linux-2.6.21.1/drivers/net: .lp486e.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .lp486e.o.cmd
Only in linux-2.6.21.1/drivers/net: .mii.ko.cmd
Only in linux-2.6.21.1/drivers/net: .mii.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .mii.o.cmd
Only in linux-2.6.21.1/drivers/net: .ne.ko.cmd
Only in linux-2.6.21.1/drivers/net: .ne.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .ne.o.cmd
Only in linux-2.6.21.1/drivers/net: .ni5010.ko.cmd
Only in linux-2.6.21.1/drivers/net: .ni5010.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .ni5010.o.cmd
Only in linux-2.6.21.1/drivers/net: .ni52.ko.cmd
Only in linux-2.6.21.1/drivers/net: .ni52.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .ni52.o.cmd
Only in linux-2.6.21.1/drivers/net: .ni65.ko.cmd
Only in linux-2.6.21.1/drivers/net: .ni65.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .ni65.o.cmd
Only in linux-2.6.21.1/drivers/net: .seeq8005.ko.cmd
Only in linux-2.6.21.1/drivers/net: .seeq8005.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .seeq8005.o.cmd
Only in linux-2.6.21.1/drivers/net: .smc-ultra.ko.cmd
Only in linux-2.6.21.1/drivers/net: .smc-ultra.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .smc-ultra.o.cmd
Only in linux-2.6.21.1/drivers/net: .smc9194.ko.cmd
Only in linux-2.6.21.1/drivers/net: .smc9194.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .smc9194.o.cmd
Only in linux-2.6.21.1/drivers/net: .tun.ko.cmd
Only in linux-2.6.21.1/drivers/net: .tun.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .tun.o.cmd
Only in linux-2.6.21.1/drivers/net: .wd.ko.cmd
Only in linux-2.6.21.1/drivers/net: .wd.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .wd.o.cmd
Only in linux-2.6.21.1/drivers/net: .znet.ko.cmd
Only in linux-2.6.21.1/drivers/net: .znet.mod.o.cmd
Only in linux-2.6.21.1/drivers/net: .znet.o.cmd
Only in linux-2.6.21.1/drivers/net: 3c501.ko
Only in linux-2.6.21.1/drivers/net: 3c501.mod.c
Only in linux-2.6.21.1/drivers/net: 3c501.mod.o
Only in linux-2.6.21.1/drivers/net: 3c501.o
Only in linux-2.6.21.1/drivers/net: 3c503.ko
Only in linux-2.6.21.1/drivers/net: 3c503.mod.c
Only in linux-2.6.21.1/drivers/net: 3c503.mod.o
Only in linux-2.6.21.1/drivers/net: 3c503.o
Only in linux-2.6.21.1/drivers/net: 3c505.ko
Only in linux-2.6.21.1/drivers/net: 3c505.mod.c
Only in linux-2.6.21.1/drivers/net: 3c505.mod.o
Only in linux-2.6.21.1/drivers/net: 3c505.o
Only in linux-2.6.21.1/drivers/net: 3c507.ko
Only in linux-2.6.21.1/drivers/net: 3c507.mod.c
Only in linux-2.6.21.1/drivers/net: 3c507.mod.o
Only in linux-2.6.21.1/drivers/net: 3c507.o
Only in linux-2.6.21.1/drivers/net: 3c509.ko
Only in linux-2.6.21.1/drivers/net: 3c509.mod.c
Only in linux-2.6.21.1/drivers/net: 3c509.mod.o
Only in linux-2.6.21.1/drivers/net: 3c509.o
Only in linux-2.6.21.1/drivers/net: 3c515.ko
Only in linux-2.6.21.1/drivers/net: 3c515.mod.c
Only in linux-2.6.21.1/drivers/net: 3c515.mod.o
Only in linux-2.6.21.1/drivers/net: 3c515.o
Only in linux-2.6.21.1/drivers/net: 82596.ko
Only in linux-2.6.21.1/drivers/net: 82596.mod.c
Only in linux-2.6.21.1/drivers/net: 82596.mod.o
Only in linux-2.6.21.1/drivers/net: 82596.o
Only in linux-2.6.21.1/drivers/net: 8390.ko
Only in linux-2.6.21.1/drivers/net: 8390.mod.c
Only in linux-2.6.21.1/drivers/net: 8390.mod.o
Only in linux-2.6.21.1/drivers/net: 8390.o
Only in linux-2.6.21.1/drivers/net: Space.o
Only in linux-2.6.21.1/drivers/net: ac3200.ko
Only in linux-2.6.21.1/drivers/net: ac3200.mod.c
Only in linux-2.6.21.1/drivers/net: ac3200.mod.o
Only in linux-2.6.21.1/drivers/net: ac3200.o
Only in linux-2.6.21.1/drivers/net: at1700.ko
Only in linux-2.6.21.1/drivers/net: at1700.mod.c
Only in linux-2.6.21.1/drivers/net: at1700.mod.o
Only in linux-2.6.21.1/drivers/net: at1700.o
Only in linux-2.6.21.1/drivers/net: atp.ko
Only in linux-2.6.21.1/drivers/net: atp.mod.c
Only in linux-2.6.21.1/drivers/net: atp.mod.o
Only in linux-2.6.21.1/drivers/net: atp.o
Only in linux-2.6.21.1/drivers/net: built-in.o
Only in linux-2.6.21.1/drivers/net: cs89x0.ko
Only in linux-2.6.21.1/drivers/net: cs89x0.mod.c
Only in linux-2.6.21.1/drivers/net: cs89x0.mod.o
Only in linux-2.6.21.1/drivers/net: cs89x0.o
Only in linux-2.6.21.1/drivers/net: de600.ko
Only in linux-2.6.21.1/drivers/net: de600.mod.c
Only in linux-2.6.21.1/drivers/net: de600.mod.o
Only in linux-2.6.21.1/drivers/net: de600.o
Only in linux-2.6.21.1/drivers/net: de620.ko
Only in linux-2.6.21.1/drivers/net: de620.mod.c
Only in linux-2.6.21.1/drivers/net: de620.mod.o
Only in linux-2.6.21.1/drivers/net: de620.o
Only in linux-2.6.21.1/drivers/net: depca.ko
Only in linux-2.6.21.1/drivers/net: depca.mod.c
Only in linux-2.6.21.1/drivers/net: depca.mod.o
Only in linux-2.6.21.1/drivers/net: depca.o
Only in linux-2.6.21.1/drivers/net: e2100.ko
Only in linux-2.6.21.1/drivers/net: e2100.mod.c
Only in linux-2.6.21.1/drivers/net: e2100.mod.o
Only in linux-2.6.21.1/drivers/net: e2100.o
Only in linux-2.6.21.1/drivers/net: eepro.ko
Only in linux-2.6.21.1/drivers/net: eepro.mod.c
Only in linux-2.6.21.1/drivers/net: eepro.mod.o
Only in linux-2.6.21.1/drivers/net: eepro.o
Only in linux-2.6.21.1/drivers/net: eexpress.ko
Only in linux-2.6.21.1/drivers/net: eexpress.mod.c
Only in linux-2.6.21.1/drivers/net: eexpress.mod.o
Only in linux-2.6.21.1/drivers/net: eexpress.o
Only in linux-2.6.21.1/drivers/net: eth16i.ko
Only in linux-2.6.21.1/drivers/net: eth16i.mod.c
Only in linux-2.6.21.1/drivers/net: eth16i.mod.o
Only in linux-2.6.21.1/drivers/net: eth16i.o
Only in linux-2.6.21.1/drivers/net: ewrk3.ko
Only in linux-2.6.21.1/drivers/net: ewrk3.mod.c
Only in linux-2.6.21.1/drivers/net: ewrk3.mod.o
Only in linux-2.6.21.1/drivers/net: ewrk3.o
Only in linux-2.6.21.1/drivers/net: hp-plus.ko
Only in linux-2.6.21.1/drivers/net: hp-plus.mod.c
Only in linux-2.6.21.1/drivers/net: hp-plus.mod.o
Only in linux-2.6.21.1/drivers/net: hp-plus.o
Only in linux-2.6.21.1/drivers/net: hp.ko
Only in linux-2.6.21.1/drivers/net: hp.mod.c
Only in linux-2.6.21.1/drivers/net: hp.mod.o
Only in linux-2.6.21.1/drivers/net: hp.o
Only in linux-2.6.21.1/drivers/net: hp100.ko
Only in linux-2.6.21.1/drivers/net: hp100.mod.c
Only in linux-2.6.21.1/drivers/net: hp100.mod.o
Only in linux-2.6.21.1/drivers/net: hp100.o
Only in linux-2.6.21.1/drivers/net: lance.ko
Only in linux-2.6.21.1/drivers/net: lance.mod.c
Only in linux-2.6.21.1/drivers/net: lance.mod.o
Only in linux-2.6.21.1/drivers/net: lance.o
Only in linux-2.6.21.1/drivers/net: loopback.o
Only in linux-2.6.21.1/drivers/net: lp486e.ko
Only in linux-2.6.21.1/drivers/net: lp486e.mod.c
Only in linux-2.6.21.1/drivers/net: lp486e.mod.o
Only in linux-2.6.21.1/drivers/net: lp486e.o
Only in linux-2.6.21.1/drivers/net: mii.ko
Only in linux-2.6.21.1/drivers/net: mii.mod.c
Only in linux-2.6.21.1/drivers/net: mii.mod.o
Only in linux-2.6.21.1/drivers/net: mii.o
Only in linux-2.6.21.1/drivers/net: ne.ko
Only in linux-2.6.21.1/drivers/net: ne.mod.c
Only in linux-2.6.21.1/drivers/net: ne.mod.o
Only in linux-2.6.21.1/drivers/net: ne.o
Only in linux-2.6.21.1/drivers/net: ni5010.ko
Only in linux-2.6.21.1/drivers/net: ni5010.mod.c
Only in linux-2.6.21.1/drivers/net: ni5010.mod.o
Only in linux-2.6.21.1/drivers/net: ni5010.o
Only in linux-2.6.21.1/drivers/net: ni52.ko
Only in linux-2.6.21.1/drivers/net: ni52.mod.c
Only in linux-2.6.21.1/drivers/net: ni52.mod.o
Only in linux-2.6.21.1/drivers/net: ni52.o
Only in linux-2.6.21.1/drivers/net: ni65.ko
Only in linux-2.6.21.1/drivers/net: ni65.mod.c
Only in linux-2.6.21.1/drivers/net: ni65.mod.o
Only in linux-2.6.21.1/drivers/net: ni65.o
Only in linux-2.6.21.1/drivers/net/phy: .broadcom.ko.cmd
Only in linux-2.6.21.1/drivers/net/phy: .broadcom.mod.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .broadcom.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .cicada.ko.cmd
Only in linux-2.6.21.1/drivers/net/phy: .cicada.mod.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .cicada.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .davicom.ko.cmd
Only in linux-2.6.21.1/drivers/net/phy: .davicom.mod.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .davicom.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .fixed.ko.cmd
Only in linux-2.6.21.1/drivers/net/phy: .fixed.mod.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .fixed.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .libphy.ko.cmd
Only in linux-2.6.21.1/drivers/net/phy: .libphy.mod.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .libphy.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .lxt.ko.cmd
Only in linux-2.6.21.1/drivers/net/phy: .lxt.mod.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .lxt.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .marvell.ko.cmd
Only in linux-2.6.21.1/drivers/net/phy: .marvell.mod.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .marvell.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .mdio_bus.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .phy.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .phy_device.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .qsemi.ko.cmd
Only in linux-2.6.21.1/drivers/net/phy: .qsemi.mod.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .qsemi.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .smsc.ko.cmd
Only in linux-2.6.21.1/drivers/net/phy: .smsc.mod.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .smsc.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .vitesse.ko.cmd
Only in linux-2.6.21.1/drivers/net/phy: .vitesse.mod.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: .vitesse.o.cmd
Only in linux-2.6.21.1/drivers/net/phy: broadcom.ko
Only in linux-2.6.21.1/drivers/net/phy: broadcom.mod.c
Only in linux-2.6.21.1/drivers/net/phy: broadcom.mod.o
Only in linux-2.6.21.1/drivers/net/phy: broadcom.o
Only in linux-2.6.21.1/drivers/net/phy: built-in.o
Only in linux-2.6.21.1/drivers/net/phy: cicada.ko
Only in linux-2.6.21.1/drivers/net/phy: cicada.mod.c
Only in linux-2.6.21.1/drivers/net/phy: cicada.mod.o
Only in linux-2.6.21.1/drivers/net/phy: cicada.o
Only in linux-2.6.21.1/drivers/net/phy: davicom.ko
Only in linux-2.6.21.1/drivers/net/phy: davicom.mod.c
Only in linux-2.6.21.1/drivers/net/phy: davicom.mod.o
Only in linux-2.6.21.1/drivers/net/phy: davicom.o
Only in linux-2.6.21.1/drivers/net/phy: fixed.ko
Only in linux-2.6.21.1/drivers/net/phy: fixed.mod.c
Only in linux-2.6.21.1/drivers/net/phy: fixed.mod.o
Only in linux-2.6.21.1/drivers/net/phy: fixed.o
Only in linux-2.6.21.1/drivers/net/phy: libphy.ko
Only in linux-2.6.21.1/drivers/net/phy: libphy.mod.c
Only in linux-2.6.21.1/drivers/net/phy: libphy.mod.o
Only in linux-2.6.21.1/drivers/net/phy: libphy.o
Only in linux-2.6.21.1/drivers/net/phy: lxt.ko
Only in linux-2.6.21.1/drivers/net/phy: lxt.mod.c
Only in linux-2.6.21.1/drivers/net/phy: lxt.mod.o
Only in linux-2.6.21.1/drivers/net/phy: lxt.o
Only in linux-2.6.21.1/drivers/net/phy: marvell.ko
Only in linux-2.6.21.1/drivers/net/phy: marvell.mod.c
Only in linux-2.6.21.1/drivers/net/phy: marvell.mod.o
Only in linux-2.6.21.1/drivers/net/phy: marvell.o
Only in linux-2.6.21.1/drivers/net/phy: mdio_bus.o
Only in linux-2.6.21.1/drivers/net/phy: phy.o
Only in linux-2.6.21.1/drivers/net/phy: phy_device.o
Only in linux-2.6.21.1/drivers/net/phy: qsemi.ko
Only in linux-2.6.21.1/drivers/net/phy: qsemi.mod.c
Only in linux-2.6.21.1/drivers/net/phy: qsemi.mod.o
Only in linux-2.6.21.1/drivers/net/phy: qsemi.o
Only in linux-2.6.21.1/drivers/net/phy: smsc.ko
Only in linux-2.6.21.1/drivers/net/phy: smsc.mod.c
Only in linux-2.6.21.1/drivers/net/phy: smsc.mod.o
Only in linux-2.6.21.1/drivers/net/phy: smsc.o
Only in linux-2.6.21.1/drivers/net/phy: vitesse.ko
Only in linux-2.6.21.1/drivers/net/phy: vitesse.mod.c
Only in linux-2.6.21.1/drivers/net/phy: vitesse.mod.o
Only in linux-2.6.21.1/drivers/net/phy: vitesse.o
Only in linux-2.6.21.1/drivers/net: seeq8005.ko
Only in linux-2.6.21.1/drivers/net: seeq8005.mod.c
Only in linux-2.6.21.1/drivers/net: seeq8005.mod.o
Only in linux-2.6.21.1/drivers/net: seeq8005.o
Only in linux-2.6.21.1/drivers/net: smc-ultra.ko
Only in linux-2.6.21.1/drivers/net: smc-ultra.mod.c
Only in linux-2.6.21.1/drivers/net: smc-ultra.mod.o
Only in linux-2.6.21.1/drivers/net: smc-ultra.o
Only in linux-2.6.21.1/drivers/net: smc9194.ko
Only in linux-2.6.21.1/drivers/net: smc9194.mod.c
Only in linux-2.6.21.1/drivers/net: smc9194.mod.o
Only in linux-2.6.21.1/drivers/net: smc9194.o
Only in linux-2.6.21.1/drivers/net: tun.ko
Only in linux-2.6.21.1/drivers/net: tun.mod.c
Only in linux-2.6.21.1/drivers/net: tun.mod.o
Only in linux-2.6.21.1/drivers/net: tun.o
Only in linux-2.6.21.1/drivers/net: wd.ko
Only in linux-2.6.21.1/drivers/net: wd.mod.c
Only in linux-2.6.21.1/drivers/net: wd.mod.o
Only in linux-2.6.21.1/drivers/net: wd.o
Only in linux-2.6.21.1/drivers/net: znet.ko
Only in linux-2.6.21.1/drivers/net: znet.mod.c
Only in linux-2.6.21.1/drivers/net: znet.mod.o
Only in linux-2.6.21.1/drivers/net: znet.o
Only in linux-2.6.21.1/drivers/parport: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/parport: .ieee1284.o.cmd
Only in linux-2.6.21.1/drivers/parport: .ieee1284_ops.o.cmd
Only in linux-2.6.21.1/drivers/parport: .parport.ko.cmd
Only in linux-2.6.21.1/drivers/parport: .parport.mod.o.cmd
Only in linux-2.6.21.1/drivers/parport: .parport.o.cmd
Only in linux-2.6.21.1/drivers/parport: .parport_pc.ko.cmd
Only in linux-2.6.21.1/drivers/parport: .parport_pc.mod.o.cmd
Only in linux-2.6.21.1/drivers/parport: .parport_pc.o.cmd
Only in linux-2.6.21.1/drivers/parport: .procfs.o.cmd
Only in linux-2.6.21.1/drivers/parport: .share.o.cmd
Only in linux-2.6.21.1/drivers/parport: built-in.o
Only in linux-2.6.21.1/drivers/parport: ieee1284.o
Only in linux-2.6.21.1/drivers/parport: ieee1284_ops.o
Only in linux-2.6.21.1/drivers/parport: parport.ko
Only in linux-2.6.21.1/drivers/parport: parport.mod.c
Only in linux-2.6.21.1/drivers/parport: parport.mod.o
Only in linux-2.6.21.1/drivers/parport: parport.o
Only in linux-2.6.21.1/drivers/parport: parport_pc.ko
Only in linux-2.6.21.1/drivers/parport: parport_pc.mod.c
Only in linux-2.6.21.1/drivers/parport: parport_pc.mod.o
Only in linux-2.6.21.1/drivers/parport: parport_pc.o
Only in linux-2.6.21.1/drivers/parport: procfs.o
Only in linux-2.6.21.1/drivers/parport: share.o
Only in linux-2.6.21.1/drivers/serial: .8250.ko.cmd
Only in linux-2.6.21.1/drivers/serial: .8250.mod.o.cmd
Only in linux-2.6.21.1/drivers/serial: .8250.o.cmd
Only in linux-2.6.21.1/drivers/serial: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/serial: .serial_core.ko.cmd
Only in linux-2.6.21.1/drivers/serial: .serial_core.mod.o.cmd
Only in linux-2.6.21.1/drivers/serial: .serial_core.o.cmd
Only in linux-2.6.21.1/drivers/serial: 8250.ko
Only in linux-2.6.21.1/drivers/serial: 8250.mod.c
Only in linux-2.6.21.1/drivers/serial: 8250.mod.o
Only in linux-2.6.21.1/drivers/serial: 8250.o
Only in linux-2.6.21.1/drivers/serial: built-in.o
Only in linux-2.6.21.1/drivers/serial: serial_core.ko
Only in linux-2.6.21.1/drivers/serial: serial_core.mod.c
Only in linux-2.6.21.1/drivers/serial: serial_core.mod.o
Only in linux-2.6.21.1/drivers/serial: serial_core.o
Only in linux-2.6.21.1/drivers/video: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/video: .fb_notify.o.cmd
Only in linux-2.6.21.1/drivers/video/backlight: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/video/backlight: built-in.o
Only in linux-2.6.21.1/drivers/video: built-in.o
Only in linux-2.6.21.1/drivers/video/console: .built-in.o.cmd
Only in linux-2.6.21.1/drivers/video/console: .dummycon.o.cmd
Only in linux-2.6.21.1/drivers/video/console: .vgacon.o.cmd
Only in linux-2.6.21.1/drivers/video/console: built-in.o
Only in linux-2.6.21.1/drivers/video/console: dummycon.o
Only in linux-2.6.21.1/drivers/video/console: vgacon.o
Only in linux-2.6.21.1/drivers/video: fb_notify.o
Only in linux-2.6.21.1/fs: .aio.o.cmd
Only in linux-2.6.21.1/fs: .attr.o.cmd
Only in linux-2.6.21.1/fs: .bad_inode.o.cmd
Only in linux-2.6.21.1/fs: .binfmt_elf.o.cmd
Only in linux-2.6.21.1/fs: .binfmt_script.o.cmd
Only in linux-2.6.21.1/fs: .bio.o.cmd
Only in linux-2.6.21.1/fs: .block_dev.o.cmd
Only in linux-2.6.21.1/fs: .buffer.o.cmd
Only in linux-2.6.21.1/fs: .built-in.o.cmd
Only in linux-2.6.21.1/fs: .char_dev.o.cmd
Only in linux-2.6.21.1/fs: .dcache.o.cmd
Only in linux-2.6.21.1/fs: .direct-io.o.cmd
Only in linux-2.6.21.1/fs: .drop_caches.o.cmd
Only in linux-2.6.21.1/fs: .exec.o.cmd
Only in linux-2.6.21.1/fs: .fcntl.o.cmd
Only in linux-2.6.21.1/fs: .fifo.o.cmd
Only in linux-2.6.21.1/fs: .file.o.cmd
Only in linux-2.6.21.1/fs: .file_table.o.cmd
Only in linux-2.6.21.1/fs: .filesystems.o.cmd
Only in linux-2.6.21.1/fs: .fs-writeback.o.cmd
Only in linux-2.6.21.1/fs: .inode.o.cmd
Only in linux-2.6.21.1/fs: .ioctl.o.cmd
Only in linux-2.6.21.1/fs: .ioprio.o.cmd
Only in linux-2.6.21.1/fs: .libfs.o.cmd
Only in linux-2.6.21.1/fs: .locks.o.cmd
Only in linux-2.6.21.1/fs: .mpage.o.cmd
Only in linux-2.6.21.1/fs: .namei.o.cmd
Only in linux-2.6.21.1/fs: .namespace.o.cmd
Only in linux-2.6.21.1/fs: .no-block.o.cmd
Only in linux-2.6.21.1/fs: .open.o.cmd
Only in linux-2.6.21.1/fs: .pipe.o.cmd
Only in linux-2.6.21.1/fs: .pnode.o.cmd
Only in linux-2.6.21.1/fs: .read_write.o.cmd
Only in linux-2.6.21.1/fs: .readdir.o.cmd
Only in linux-2.6.21.1/fs: .select.o.cmd
Only in linux-2.6.21.1/fs: .seq_file.o.cmd
Only in linux-2.6.21.1/fs: .splice.o.cmd
Only in linux-2.6.21.1/fs: .stack.o.cmd
Only in linux-2.6.21.1/fs: .stat.o.cmd
Only in linux-2.6.21.1/fs: .super.o.cmd
Only in linux-2.6.21.1/fs: .sync.o.cmd
Only in linux-2.6.21.1/fs: .utimes.o.cmd
Only in linux-2.6.21.1/fs: .xattr.o.cmd
Only in linux-2.6.21.1/fs/adfs: .adfs.ko.cmd
Only in linux-2.6.21.1/fs/adfs: .adfs.mod.o.cmd
Only in linux-2.6.21.1/fs/adfs: .adfs.o.cmd
Only in linux-2.6.21.1/fs/adfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/adfs: .dir.o.cmd
Only in linux-2.6.21.1/fs/adfs: .dir_f.o.cmd
Only in linux-2.6.21.1/fs/adfs: .dir_fplus.o.cmd
Only in linux-2.6.21.1/fs/adfs: .file.o.cmd
Only in linux-2.6.21.1/fs/adfs: .inode.o.cmd
Only in linux-2.6.21.1/fs/adfs: .map.o.cmd
Only in linux-2.6.21.1/fs/adfs: .super.o.cmd
Only in linux-2.6.21.1/fs/adfs: adfs.ko
Only in linux-2.6.21.1/fs/adfs: adfs.mod.c
Only in linux-2.6.21.1/fs/adfs: adfs.mod.o
Only in linux-2.6.21.1/fs/adfs: adfs.o
Only in linux-2.6.21.1/fs/adfs: built-in.o
Only in linux-2.6.21.1/fs/adfs: dir.o
Only in linux-2.6.21.1/fs/adfs: dir_f.o
Only in linux-2.6.21.1/fs/adfs: dir_fplus.o
Only in linux-2.6.21.1/fs/adfs: file.o
Only in linux-2.6.21.1/fs/adfs: inode.o
Only in linux-2.6.21.1/fs/adfs: map.o
Only in linux-2.6.21.1/fs/adfs: super.o
Only in linux-2.6.21.1/fs/affs: .affs.ko.cmd
Only in linux-2.6.21.1/fs/affs: .affs.mod.o.cmd
Only in linux-2.6.21.1/fs/affs: .affs.o.cmd
Only in linux-2.6.21.1/fs/affs: .amigaffs.o.cmd
Only in linux-2.6.21.1/fs/affs: .bitmap.o.cmd
Only in linux-2.6.21.1/fs/affs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/affs: .dir.o.cmd
Only in linux-2.6.21.1/fs/affs: .file.o.cmd
Only in linux-2.6.21.1/fs/affs: .inode.o.cmd
Only in linux-2.6.21.1/fs/affs: .namei.o.cmd
Only in linux-2.6.21.1/fs/affs: .super.o.cmd
Only in linux-2.6.21.1/fs/affs: .symlink.o.cmd
Only in linux-2.6.21.1/fs/affs: affs.ko
Only in linux-2.6.21.1/fs/affs: affs.mod.c
Only in linux-2.6.21.1/fs/affs: affs.mod.o
Only in linux-2.6.21.1/fs/affs: affs.o
Only in linux-2.6.21.1/fs/affs: amigaffs.o
Only in linux-2.6.21.1/fs/affs: bitmap.o
Only in linux-2.6.21.1/fs/affs: built-in.o
Only in linux-2.6.21.1/fs/affs: dir.o
Only in linux-2.6.21.1/fs/affs: file.o
Only in linux-2.6.21.1/fs/affs: inode.o
Only in linux-2.6.21.1/fs/affs: namei.o
Only in linux-2.6.21.1/fs/affs: super.o
Only in linux-2.6.21.1/fs/affs: symlink.o
Only in linux-2.6.21.1/fs: aio.o
Only in linux-2.6.21.1/fs: attr.o
Only in linux-2.6.21.1/fs: bad_inode.o
Only in linux-2.6.21.1/fs/befs: .befs.ko.cmd
Only in linux-2.6.21.1/fs/befs: .befs.mod.o.cmd
Only in linux-2.6.21.1/fs/befs: .befs.o.cmd
Only in linux-2.6.21.1/fs/befs: .btree.o.cmd
Only in linux-2.6.21.1/fs/befs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/befs: .datastream.o.cmd
Only in linux-2.6.21.1/fs/befs: .debug.o.cmd
Only in linux-2.6.21.1/fs/befs: .inode.o.cmd
Only in linux-2.6.21.1/fs/befs: .io.o.cmd
Only in linux-2.6.21.1/fs/befs: .linuxvfs.o.cmd
Only in linux-2.6.21.1/fs/befs: .super.o.cmd
Only in linux-2.6.21.1/fs/befs: befs.ko
Only in linux-2.6.21.1/fs/befs: befs.mod.c
Only in linux-2.6.21.1/fs/befs: befs.mod.o
Only in linux-2.6.21.1/fs/befs: befs.o
Only in linux-2.6.21.1/fs/befs: btree.o
Only in linux-2.6.21.1/fs/befs: built-in.o
Only in linux-2.6.21.1/fs/befs: datastream.o
Only in linux-2.6.21.1/fs/befs: debug.o
Only in linux-2.6.21.1/fs/befs: inode.o
Only in linux-2.6.21.1/fs/befs: io.o
Only in linux-2.6.21.1/fs/befs: linuxvfs.o
Only in linux-2.6.21.1/fs/befs: super.o
Only in linux-2.6.21.1/fs/bfs: .bfs.ko.cmd
Only in linux-2.6.21.1/fs/bfs: .bfs.mod.o.cmd
Only in linux-2.6.21.1/fs/bfs: .bfs.o.cmd
Only in linux-2.6.21.1/fs/bfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/bfs: .dir.o.cmd
Only in linux-2.6.21.1/fs/bfs: .file.o.cmd
Only in linux-2.6.21.1/fs/bfs: .inode.o.cmd
Only in linux-2.6.21.1/fs/bfs: bfs.ko
Only in linux-2.6.21.1/fs/bfs: bfs.mod.c
Only in linux-2.6.21.1/fs/bfs: bfs.mod.o
Only in linux-2.6.21.1/fs/bfs: bfs.o
Only in linux-2.6.21.1/fs/bfs: built-in.o
Only in linux-2.6.21.1/fs/bfs: dir.o
Only in linux-2.6.21.1/fs/bfs: file.o
Only in linux-2.6.21.1/fs/bfs: inode.o
Only in linux-2.6.21.1/fs: binfmt_elf.o
Only in linux-2.6.21.1/fs: binfmt_script.o
Only in linux-2.6.21.1/fs: bio.o
Only in linux-2.6.21.1/fs: block_dev.o
Only in linux-2.6.21.1/fs: buffer.o
Only in linux-2.6.21.1/fs: built-in.o
Only in linux-2.6.21.1/fs: char_dev.o
Only in linux-2.6.21.1/fs/cramfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/cramfs: .cramfs.ko.cmd
Only in linux-2.6.21.1/fs/cramfs: .cramfs.mod.o.cmd
Only in linux-2.6.21.1/fs/cramfs: .cramfs.o.cmd
Only in linux-2.6.21.1/fs/cramfs: .inode.o.cmd
Only in linux-2.6.21.1/fs/cramfs: .uncompress.o.cmd
Only in linux-2.6.21.1/fs/cramfs: built-in.o
Only in linux-2.6.21.1/fs/cramfs: cramfs.ko
Only in linux-2.6.21.1/fs/cramfs: cramfs.mod.c
Only in linux-2.6.21.1/fs/cramfs: cramfs.mod.o
Only in linux-2.6.21.1/fs/cramfs: cramfs.o
Only in linux-2.6.21.1/fs/cramfs: inode.o
Only in linux-2.6.21.1/fs/cramfs: uncompress.o
Only in linux-2.6.21.1/fs: dcache.o
Only in linux-2.6.21.1/fs/devpts: .built-in.o.cmd
Only in linux-2.6.21.1/fs/devpts: built-in.o
Only in linux-2.6.21.1/fs: direct-io.o
Only in linux-2.6.21.1/fs: drop_caches.o
Only in linux-2.6.21.1/fs/efs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/efs: .dir.o.cmd
Only in linux-2.6.21.1/fs/efs: .efs.ko.cmd
Only in linux-2.6.21.1/fs/efs: .efs.mod.o.cmd
Only in linux-2.6.21.1/fs/efs: .efs.o.cmd
Only in linux-2.6.21.1/fs/efs: .file.o.cmd
Only in linux-2.6.21.1/fs/efs: .inode.o.cmd
Only in linux-2.6.21.1/fs/efs: .namei.o.cmd
Only in linux-2.6.21.1/fs/efs: .super.o.cmd
Only in linux-2.6.21.1/fs/efs: .symlink.o.cmd
Only in linux-2.6.21.1/fs/efs: built-in.o
Only in linux-2.6.21.1/fs/efs: dir.o
Only in linux-2.6.21.1/fs/efs: efs.ko
Only in linux-2.6.21.1/fs/efs: efs.mod.c
Only in linux-2.6.21.1/fs/efs: efs.mod.o
Only in linux-2.6.21.1/fs/efs: efs.o
Only in linux-2.6.21.1/fs/efs: file.o
Only in linux-2.6.21.1/fs/efs: inode.o
Only in linux-2.6.21.1/fs/efs: namei.o
Only in linux-2.6.21.1/fs/efs: super.o
Only in linux-2.6.21.1/fs/efs: symlink.o
Only in linux-2.6.21.1/fs: exec.o
Only in linux-2.6.21.1/fs/ext2: .balloc.o.cmd
Only in linux-2.6.21.1/fs/ext2: .built-in.o.cmd
Only in linux-2.6.21.1/fs/ext2: .dir.o.cmd
Only in linux-2.6.21.1/fs/ext2: .ext2.ko.cmd
Only in linux-2.6.21.1/fs/ext2: .ext2.mod.o.cmd
Only in linux-2.6.21.1/fs/ext2: .ext2.o.cmd
Only in linux-2.6.21.1/fs/ext2: .file.o.cmd
Only in linux-2.6.21.1/fs/ext2: .fsync.o.cmd
Only in linux-2.6.21.1/fs/ext2: .ialloc.o.cmd
Only in linux-2.6.21.1/fs/ext2: .inode.o.cmd
Only in linux-2.6.21.1/fs/ext2: .ioctl.o.cmd
Only in linux-2.6.21.1/fs/ext2: .namei.o.cmd
Only in linux-2.6.21.1/fs/ext2: .super.o.cmd
Only in linux-2.6.21.1/fs/ext2: .symlink.o.cmd
Only in linux-2.6.21.1/fs/ext2: balloc.o
Only in linux-2.6.21.1/fs/ext2: built-in.o
Only in linux-2.6.21.1/fs/ext2: dir.o
Only in linux-2.6.21.1/fs/ext2: ext2.ko
Only in linux-2.6.21.1/fs/ext2: ext2.mod.c
Only in linux-2.6.21.1/fs/ext2: ext2.mod.o
Only in linux-2.6.21.1/fs/ext2: ext2.o
Only in linux-2.6.21.1/fs/ext2: file.o
Only in linux-2.6.21.1/fs/ext2: fsync.o
Only in linux-2.6.21.1/fs/ext2: ialloc.o
Only in linux-2.6.21.1/fs/ext2: inode.o
Only in linux-2.6.21.1/fs/ext2: ioctl.o
Only in linux-2.6.21.1/fs/ext2: namei.o
Only in linux-2.6.21.1/fs/ext2: super.o
Only in linux-2.6.21.1/fs/ext2: symlink.o
Only in linux-2.6.21.1/fs/ext3: .balloc.o.cmd
Only in linux-2.6.21.1/fs/ext3: .bitmap.o.cmd
Only in linux-2.6.21.1/fs/ext3: .built-in.o.cmd
Only in linux-2.6.21.1/fs/ext3: .dir.o.cmd
Only in linux-2.6.21.1/fs/ext3: .ext3.o.cmd
Only in linux-2.6.21.1/fs/ext3: .ext3_jbd.o.cmd
Only in linux-2.6.21.1/fs/ext3: .file.o.cmd
Only in linux-2.6.21.1/fs/ext3: .fsync.o.cmd
Only in linux-2.6.21.1/fs/ext3: .hash.o.cmd
Only in linux-2.6.21.1/fs/ext3: .ialloc.o.cmd
Only in linux-2.6.21.1/fs/ext3: .inode.o.cmd
Only in linux-2.6.21.1/fs/ext3: .ioctl.o.cmd
Only in linux-2.6.21.1/fs/ext3: .namei.o.cmd
Only in linux-2.6.21.1/fs/ext3: .resize.o.cmd
Only in linux-2.6.21.1/fs/ext3: .super.o.cmd
Only in linux-2.6.21.1/fs/ext3: .symlink.o.cmd
Only in linux-2.6.21.1/fs/ext3: balloc.o
Only in linux-2.6.21.1/fs/ext3: bitmap.o
Only in linux-2.6.21.1/fs/ext3: built-in.o
Only in linux-2.6.21.1/fs/ext3: dir.o
Only in linux-2.6.21.1/fs/ext3: ext3.o
Only in linux-2.6.21.1/fs/ext3: ext3_jbd.o
Only in linux-2.6.21.1/fs/ext3: file.o
Only in linux-2.6.21.1/fs/ext3: fsync.o
Only in linux-2.6.21.1/fs/ext3: hash.o
Only in linux-2.6.21.1/fs/ext3: ialloc.o
Only in linux-2.6.21.1/fs/ext3: inode.o
Only in linux-2.6.21.1/fs/ext3: ioctl.o
Only in linux-2.6.21.1/fs/ext3: namei.o
Only in linux-2.6.21.1/fs/ext3: resize.o
Only in linux-2.6.21.1/fs/ext3: super.o
Only in linux-2.6.21.1/fs/ext3: symlink.o
Only in linux-2.6.21.1/fs/ext4: .balloc.o.cmd
Only in linux-2.6.21.1/fs/ext4: .bitmap.o.cmd
Only in linux-2.6.21.1/fs/ext4: .built-in.o.cmd
Only in linux-2.6.21.1/fs/ext4: .dir.o.cmd
Only in linux-2.6.21.1/fs/ext4: .ext4_jbd2.o.cmd
Only in linux-2.6.21.1/fs/ext4: .ext4dev.ko.cmd
Only in linux-2.6.21.1/fs/ext4: .ext4dev.mod.o.cmd
Only in linux-2.6.21.1/fs/ext4: .ext4dev.o.cmd
Only in linux-2.6.21.1/fs/ext4: .extents.o.cmd
Only in linux-2.6.21.1/fs/ext4: .file.o.cmd
Only in linux-2.6.21.1/fs/ext4: .fsync.o.cmd
Only in linux-2.6.21.1/fs/ext4: .hash.o.cmd
Only in linux-2.6.21.1/fs/ext4: .ialloc.o.cmd
Only in linux-2.6.21.1/fs/ext4: .inode.o.cmd
Only in linux-2.6.21.1/fs/ext4: .ioctl.o.cmd
Only in linux-2.6.21.1/fs/ext4: .namei.o.cmd
Only in linux-2.6.21.1/fs/ext4: .resize.o.cmd
Only in linux-2.6.21.1/fs/ext4: .super.o.cmd
Only in linux-2.6.21.1/fs/ext4: .symlink.o.cmd
Only in linux-2.6.21.1/fs/ext4: balloc.o
Only in linux-2.6.21.1/fs/ext4: bitmap.o
Only in linux-2.6.21.1/fs/ext4: built-in.o
Only in linux-2.6.21.1/fs/ext4: dir.o
Only in linux-2.6.21.1/fs/ext4: ext4_jbd2.o
Only in linux-2.6.21.1/fs/ext4: ext4dev.ko
Only in linux-2.6.21.1/fs/ext4: ext4dev.mod.c
Only in linux-2.6.21.1/fs/ext4: ext4dev.mod.o
Only in linux-2.6.21.1/fs/ext4: ext4dev.o
Only in linux-2.6.21.1/fs/ext4: extents.o
Only in linux-2.6.21.1/fs/ext4: file.o
Only in linux-2.6.21.1/fs/ext4: fsync.o
Only in linux-2.6.21.1/fs/ext4: hash.o
Only in linux-2.6.21.1/fs/ext4: ialloc.o
Only in linux-2.6.21.1/fs/ext4: inode.o
Only in linux-2.6.21.1/fs/ext4: ioctl.o
Only in linux-2.6.21.1/fs/ext4: namei.o
Only in linux-2.6.21.1/fs/ext4: resize.o
Only in linux-2.6.21.1/fs/ext4: super.o
Only in linux-2.6.21.1/fs/ext4: symlink.o
Only in linux-2.6.21.1/fs/fat: .built-in.o.cmd
Only in linux-2.6.21.1/fs/fat: .cache.o.cmd
Only in linux-2.6.21.1/fs/fat: .dir.o.cmd
Only in linux-2.6.21.1/fs/fat: .fat.ko.cmd
Only in linux-2.6.21.1/fs/fat: .fat.mod.o.cmd
Only in linux-2.6.21.1/fs/fat: .fat.o.cmd
Only in linux-2.6.21.1/fs/fat: .fatent.o.cmd
Only in linux-2.6.21.1/fs/fat: .file.o.cmd
Only in linux-2.6.21.1/fs/fat: .inode.o.cmd
Only in linux-2.6.21.1/fs/fat: .misc.o.cmd
Only in linux-2.6.21.1/fs/fat: built-in.o
Only in linux-2.6.21.1/fs/fat: cache.o
Only in linux-2.6.21.1/fs/fat: dir.o
Only in linux-2.6.21.1/fs/fat: fat.ko
Only in linux-2.6.21.1/fs/fat: fat.mod.c
Only in linux-2.6.21.1/fs/fat: fat.mod.o
Only in linux-2.6.21.1/fs/fat: fat.o
Only in linux-2.6.21.1/fs/fat: fatent.o
Only in linux-2.6.21.1/fs/fat: file.o
Only in linux-2.6.21.1/fs/fat: inode.o
Only in linux-2.6.21.1/fs/fat: misc.o
Only in linux-2.6.21.1/fs: fcntl.o
Only in linux-2.6.21.1/fs: fifo.o
Only in linux-2.6.21.1/fs: file.o
Only in linux-2.6.21.1/fs: file_table.o
Only in linux-2.6.21.1/fs: filesystems.o
Only in linux-2.6.21.1/fs/freevxfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/freevxfs: .freevxfs.ko.cmd
Only in linux-2.6.21.1/fs/freevxfs: .freevxfs.mod.o.cmd
Only in linux-2.6.21.1/fs/freevxfs: .freevxfs.o.cmd
Only in linux-2.6.21.1/fs/freevxfs: .vxfs_bmap.o.cmd
Only in linux-2.6.21.1/fs/freevxfs: .vxfs_fshead.o.cmd
Only in linux-2.6.21.1/fs/freevxfs: .vxfs_immed.o.cmd
Only in linux-2.6.21.1/fs/freevxfs: .vxfs_inode.o.cmd
Only in linux-2.6.21.1/fs/freevxfs: .vxfs_lookup.o.cmd
Only in linux-2.6.21.1/fs/freevxfs: .vxfs_olt.o.cmd
Only in linux-2.6.21.1/fs/freevxfs: .vxfs_subr.o.cmd
Only in linux-2.6.21.1/fs/freevxfs: .vxfs_super.o.cmd
Only in linux-2.6.21.1/fs/freevxfs: built-in.o
Only in linux-2.6.21.1/fs/freevxfs: freevxfs.ko
Only in linux-2.6.21.1/fs/freevxfs: freevxfs.mod.c
Only in linux-2.6.21.1/fs/freevxfs: freevxfs.mod.o
Only in linux-2.6.21.1/fs/freevxfs: freevxfs.o
Only in linux-2.6.21.1/fs/freevxfs: vxfs_bmap.o
Only in linux-2.6.21.1/fs/freevxfs: vxfs_fshead.o
Only in linux-2.6.21.1/fs/freevxfs: vxfs_immed.o
Only in linux-2.6.21.1/fs/freevxfs: vxfs_inode.o
Only in linux-2.6.21.1/fs/freevxfs: vxfs_lookup.o
Only in linux-2.6.21.1/fs/freevxfs: vxfs_olt.o
Only in linux-2.6.21.1/fs/freevxfs: vxfs_subr.o
Only in linux-2.6.21.1/fs/freevxfs: vxfs_super.o
Only in linux-2.6.21.1/fs: fs-writeback.o
Only in linux-2.6.21.1/fs/fuse: .built-in.o.cmd
Only in linux-2.6.21.1/fs/fuse: .control.o.cmd
Only in linux-2.6.21.1/fs/fuse: .dev.o.cmd
Only in linux-2.6.21.1/fs/fuse: .dir.o.cmd
Only in linux-2.6.21.1/fs/fuse: .file.o.cmd
Only in linux-2.6.21.1/fs/fuse: .fuse.ko.cmd
Only in linux-2.6.21.1/fs/fuse: .fuse.mod.o.cmd
Only in linux-2.6.21.1/fs/fuse: .fuse.o.cmd
Only in linux-2.6.21.1/fs/fuse: .inode.o.cmd
Only in linux-2.6.21.1/fs/fuse: built-in.o
Only in linux-2.6.21.1/fs/fuse: control.o
Only in linux-2.6.21.1/fs/fuse: dev.o
Only in linux-2.6.21.1/fs/fuse: dir.o
Only in linux-2.6.21.1/fs/fuse: file.o
Only in linux-2.6.21.1/fs/fuse: fuse.ko
Only in linux-2.6.21.1/fs/fuse: fuse.mod.c
Only in linux-2.6.21.1/fs/fuse: fuse.mod.o
Only in linux-2.6.21.1/fs/fuse: fuse.o
Only in linux-2.6.21.1/fs/fuse: inode.o
Only in linux-2.6.21.1/fs/hfs: .attr.o.cmd
Only in linux-2.6.21.1/fs/hfs: .bfind.o.cmd
Only in linux-2.6.21.1/fs/hfs: .bitmap.o.cmd
Only in linux-2.6.21.1/fs/hfs: .bnode.o.cmd
Only in linux-2.6.21.1/fs/hfs: .brec.o.cmd
Only in linux-2.6.21.1/fs/hfs: .btree.o.cmd
Only in linux-2.6.21.1/fs/hfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/hfs: .catalog.o.cmd
Only in linux-2.6.21.1/fs/hfs: .dir.o.cmd
Only in linux-2.6.21.1/fs/hfs: .extent.o.cmd
Only in linux-2.6.21.1/fs/hfs: .hfs.ko.cmd
Only in linux-2.6.21.1/fs/hfs: .hfs.mod.o.cmd
Only in linux-2.6.21.1/fs/hfs: .hfs.o.cmd
Only in linux-2.6.21.1/fs/hfs: .inode.o.cmd
Only in linux-2.6.21.1/fs/hfs: .mdb.o.cmd
Only in linux-2.6.21.1/fs/hfs: .part_tbl.o.cmd
Only in linux-2.6.21.1/fs/hfs: .string.o.cmd
Only in linux-2.6.21.1/fs/hfs: .super.o.cmd
Only in linux-2.6.21.1/fs/hfs: .sysdep.o.cmd
Only in linux-2.6.21.1/fs/hfs: .trans.o.cmd
Only in linux-2.6.21.1/fs/hfs: attr.o
Only in linux-2.6.21.1/fs/hfs: bfind.o
Only in linux-2.6.21.1/fs/hfs: bitmap.o
Only in linux-2.6.21.1/fs/hfs: bnode.o
Only in linux-2.6.21.1/fs/hfs: brec.o
Only in linux-2.6.21.1/fs/hfs: btree.o
Only in linux-2.6.21.1/fs/hfs: built-in.o
Only in linux-2.6.21.1/fs/hfs: catalog.o
Only in linux-2.6.21.1/fs/hfs: dir.o
Only in linux-2.6.21.1/fs/hfs: extent.o
Only in linux-2.6.21.1/fs/hfs: hfs.ko
Only in linux-2.6.21.1/fs/hfs: hfs.mod.c
Only in linux-2.6.21.1/fs/hfs: hfs.mod.o
Only in linux-2.6.21.1/fs/hfs: hfs.o
Only in linux-2.6.21.1/fs/hfs: inode.o
Only in linux-2.6.21.1/fs/hfs: mdb.o
Only in linux-2.6.21.1/fs/hfs: part_tbl.o
Only in linux-2.6.21.1/fs/hfs: string.o
Only in linux-2.6.21.1/fs/hfs: super.o
Only in linux-2.6.21.1/fs/hfs: sysdep.o
Only in linux-2.6.21.1/fs/hfs: trans.o
Only in linux-2.6.21.1/fs/hfsplus: .bfind.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .bitmap.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .bnode.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .brec.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .btree.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .built-in.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .catalog.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .dir.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .extents.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .hfsplus.ko.cmd
Only in linux-2.6.21.1/fs/hfsplus: .hfsplus.mod.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .hfsplus.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .inode.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .ioctl.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .options.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .part_tbl.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .super.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .tables.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .unicode.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: .wrapper.o.cmd
Only in linux-2.6.21.1/fs/hfsplus: bfind.o
Only in linux-2.6.21.1/fs/hfsplus: bitmap.o
Only in linux-2.6.21.1/fs/hfsplus: bnode.o
Only in linux-2.6.21.1/fs/hfsplus: brec.o
Only in linux-2.6.21.1/fs/hfsplus: btree.o
Only in linux-2.6.21.1/fs/hfsplus: built-in.o
Only in linux-2.6.21.1/fs/hfsplus: catalog.o
Only in linux-2.6.21.1/fs/hfsplus: dir.o
Only in linux-2.6.21.1/fs/hfsplus: extents.o
Only in linux-2.6.21.1/fs/hfsplus: hfsplus.ko
Only in linux-2.6.21.1/fs/hfsplus: hfsplus.mod.c
Only in linux-2.6.21.1/fs/hfsplus: hfsplus.mod.o
Only in linux-2.6.21.1/fs/hfsplus: hfsplus.o
Only in linux-2.6.21.1/fs/hfsplus: inode.o
Only in linux-2.6.21.1/fs/hfsplus: ioctl.o
Only in linux-2.6.21.1/fs/hfsplus: options.o
Only in linux-2.6.21.1/fs/hfsplus: part_tbl.o
Only in linux-2.6.21.1/fs/hfsplus: super.o
Only in linux-2.6.21.1/fs/hfsplus: tables.o
Only in linux-2.6.21.1/fs/hfsplus: unicode.o
Only in linux-2.6.21.1/fs/hfsplus: wrapper.o
Only in linux-2.6.21.1/fs/hpfs: .alloc.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .anode.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .buffer.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .dentry.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .dir.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .dnode.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .ea.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .file.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .hpfs.ko.cmd
Only in linux-2.6.21.1/fs/hpfs: .hpfs.mod.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .hpfs.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .inode.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .map.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .name.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .namei.o.cmd
Only in linux-2.6.21.1/fs/hpfs: .super.o.cmd
Only in linux-2.6.21.1/fs/hpfs: alloc.o
Only in linux-2.6.21.1/fs/hpfs: anode.o
Only in linux-2.6.21.1/fs/hpfs: buffer.o
Only in linux-2.6.21.1/fs/hpfs: built-in.o
Only in linux-2.6.21.1/fs/hpfs: dentry.o
Only in linux-2.6.21.1/fs/hpfs: dir.o
Only in linux-2.6.21.1/fs/hpfs: dnode.o
Only in linux-2.6.21.1/fs/hpfs: ea.o
Only in linux-2.6.21.1/fs/hpfs: file.o
Only in linux-2.6.21.1/fs/hpfs: hpfs.ko
Only in linux-2.6.21.1/fs/hpfs: hpfs.mod.c
Only in linux-2.6.21.1/fs/hpfs: hpfs.mod.o
Only in linux-2.6.21.1/fs/hpfs: hpfs.o
Only in linux-2.6.21.1/fs/hpfs: inode.o
Only in linux-2.6.21.1/fs/hpfs: map.o
Only in linux-2.6.21.1/fs/hpfs: name.o
Only in linux-2.6.21.1/fs/hpfs: namei.o
Only in linux-2.6.21.1/fs/hpfs: super.o
Only in linux-2.6.21.1/fs: inode.o
Only in linux-2.6.21.1/fs: ioctl.o
Only in linux-2.6.21.1/fs: ioprio.o
Only in linux-2.6.21.1/fs/isofs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/isofs: .dir.o.cmd
Only in linux-2.6.21.1/fs/isofs: .export.o.cmd
Only in linux-2.6.21.1/fs/isofs: .inode.o.cmd
Only in linux-2.6.21.1/fs/isofs: .isofs.ko.cmd
Only in linux-2.6.21.1/fs/isofs: .isofs.mod.o.cmd
Only in linux-2.6.21.1/fs/isofs: .isofs.o.cmd
Only in linux-2.6.21.1/fs/isofs: .joliet.o.cmd
Only in linux-2.6.21.1/fs/isofs: .namei.o.cmd
Only in linux-2.6.21.1/fs/isofs: .rock.o.cmd
Only in linux-2.6.21.1/fs/isofs: .util.o.cmd
Only in linux-2.6.21.1/fs/isofs: built-in.o
Only in linux-2.6.21.1/fs/isofs: dir.o
Only in linux-2.6.21.1/fs/isofs: export.o
Only in linux-2.6.21.1/fs/isofs: inode.o
Only in linux-2.6.21.1/fs/isofs: isofs.ko
Only in linux-2.6.21.1/fs/isofs: isofs.mod.c
Only in linux-2.6.21.1/fs/isofs: isofs.mod.o
Only in linux-2.6.21.1/fs/isofs: isofs.o
Only in linux-2.6.21.1/fs/isofs: joliet.o
Only in linux-2.6.21.1/fs/isofs: namei.o
Only in linux-2.6.21.1/fs/isofs: rock.o
Only in linux-2.6.21.1/fs/isofs: util.o
Only in linux-2.6.21.1/fs/jbd: .built-in.o.cmd
Only in linux-2.6.21.1/fs/jbd: .checkpoint.o.cmd
Only in linux-2.6.21.1/fs/jbd: .commit.o.cmd
Only in linux-2.6.21.1/fs/jbd: .jbd.o.cmd
Only in linux-2.6.21.1/fs/jbd: .journal.o.cmd
Only in linux-2.6.21.1/fs/jbd: .recovery.o.cmd
Only in linux-2.6.21.1/fs/jbd: .revoke.o.cmd
Only in linux-2.6.21.1/fs/jbd: .transaction.o.cmd
Only in linux-2.6.21.1/fs/jbd: built-in.o
Only in linux-2.6.21.1/fs/jbd: checkpoint.o
Only in linux-2.6.21.1/fs/jbd: commit.o
Only in linux-2.6.21.1/fs/jbd: jbd.o
Only in linux-2.6.21.1/fs/jbd: journal.o
Only in linux-2.6.21.1/fs/jbd: recovery.o
Only in linux-2.6.21.1/fs/jbd: revoke.o
Only in linux-2.6.21.1/fs/jbd: transaction.o
Only in linux-2.6.21.1/fs/jbd2: .built-in.o.cmd
Only in linux-2.6.21.1/fs/jbd2: .checkpoint.o.cmd
Only in linux-2.6.21.1/fs/jbd2: .commit.o.cmd
Only in linux-2.6.21.1/fs/jbd2: .jbd2.ko.cmd
Only in linux-2.6.21.1/fs/jbd2: .jbd2.mod.o.cmd
Only in linux-2.6.21.1/fs/jbd2: .jbd2.o.cmd
Only in linux-2.6.21.1/fs/jbd2: .journal.o.cmd
Only in linux-2.6.21.1/fs/jbd2: .recovery.o.cmd
Only in linux-2.6.21.1/fs/jbd2: .revoke.o.cmd
Only in linux-2.6.21.1/fs/jbd2: .transaction.o.cmd
Only in linux-2.6.21.1/fs/jbd2: built-in.o
Only in linux-2.6.21.1/fs/jbd2: checkpoint.o
Only in linux-2.6.21.1/fs/jbd2: commit.o
Only in linux-2.6.21.1/fs/jbd2: jbd2.ko
Only in linux-2.6.21.1/fs/jbd2: jbd2.mod.c
Only in linux-2.6.21.1/fs/jbd2: jbd2.mod.o
Only in linux-2.6.21.1/fs/jbd2: jbd2.o
Only in linux-2.6.21.1/fs/jbd2: journal.o
Only in linux-2.6.21.1/fs/jbd2: recovery.o
Only in linux-2.6.21.1/fs/jbd2: revoke.o
Only in linux-2.6.21.1/fs/jbd2: transaction.o
Only in linux-2.6.21.1/fs/jfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/jfs: .file.o.cmd
Only in linux-2.6.21.1/fs/jfs: .inode.o.cmd
Only in linux-2.6.21.1/fs/jfs: .ioctl.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs.ko.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs.mod.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_debug.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_dmap.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_dtree.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_extent.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_imap.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_inode.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_logmgr.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_metapage.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_mount.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_txnmgr.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_umount.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_unicode.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_uniupr.o.cmd
Only in linux-2.6.21.1/fs/jfs: .jfs_xtree.o.cmd
Only in linux-2.6.21.1/fs/jfs: .namei.o.cmd
Only in linux-2.6.21.1/fs/jfs: .resize.o.cmd
Only in linux-2.6.21.1/fs/jfs: .super.o.cmd
Only in linux-2.6.21.1/fs/jfs: .symlink.o.cmd
Only in linux-2.6.21.1/fs/jfs: .xattr.o.cmd
Only in linux-2.6.21.1/fs/jfs: built-in.o
Only in linux-2.6.21.1/fs/jfs: file.o
Only in linux-2.6.21.1/fs/jfs: inode.o
Only in linux-2.6.21.1/fs/jfs: ioctl.o
Only in linux-2.6.21.1/fs/jfs: jfs.ko
Only in linux-2.6.21.1/fs/jfs: jfs.mod.c
Only in linux-2.6.21.1/fs/jfs: jfs.mod.o
Only in linux-2.6.21.1/fs/jfs: jfs.o
Only in linux-2.6.21.1/fs/jfs: jfs_debug.o
Only in linux-2.6.21.1/fs/jfs: jfs_dmap.o
Only in linux-2.6.21.1/fs/jfs: jfs_dtree.o
Only in linux-2.6.21.1/fs/jfs: jfs_extent.o
Only in linux-2.6.21.1/fs/jfs: jfs_imap.o
Only in linux-2.6.21.1/fs/jfs: jfs_inode.o
Only in linux-2.6.21.1/fs/jfs: jfs_logmgr.o
Only in linux-2.6.21.1/fs/jfs: jfs_metapage.o
Only in linux-2.6.21.1/fs/jfs: jfs_mount.o
Only in linux-2.6.21.1/fs/jfs: jfs_txnmgr.o
Only in linux-2.6.21.1/fs/jfs: jfs_umount.o
Only in linux-2.6.21.1/fs/jfs: jfs_unicode.o
Only in linux-2.6.21.1/fs/jfs: jfs_uniupr.o
Only in linux-2.6.21.1/fs/jfs: jfs_xtree.o
Only in linux-2.6.21.1/fs/jfs: namei.o
Only in linux-2.6.21.1/fs/jfs: resize.o
Only in linux-2.6.21.1/fs/jfs: super.o
Only in linux-2.6.21.1/fs/jfs: symlink.o
Only in linux-2.6.21.1/fs/jfs: xattr.o
Only in linux-2.6.21.1/fs: libfs.o
Only in linux-2.6.21.1/fs: locks.o
Only in linux-2.6.21.1/fs/minix: .bitmap.o.cmd
Only in linux-2.6.21.1/fs/minix: .built-in.o.cmd
Only in linux-2.6.21.1/fs/minix: .dir.o.cmd
Only in linux-2.6.21.1/fs/minix: .file.o.cmd
Only in linux-2.6.21.1/fs/minix: .inode.o.cmd
Only in linux-2.6.21.1/fs/minix: .itree_v1.o.cmd
Only in linux-2.6.21.1/fs/minix: .itree_v2.o.cmd
Only in linux-2.6.21.1/fs/minix: .minix.ko.cmd
Only in linux-2.6.21.1/fs/minix: .minix.mod.o.cmd
Only in linux-2.6.21.1/fs/minix: .minix.o.cmd
Only in linux-2.6.21.1/fs/minix: .namei.o.cmd
Only in linux-2.6.21.1/fs/minix: bitmap.o
Only in linux-2.6.21.1/fs/minix: built-in.o
Only in linux-2.6.21.1/fs/minix: dir.o
Only in linux-2.6.21.1/fs/minix: file.o
Only in linux-2.6.21.1/fs/minix: inode.o
Only in linux-2.6.21.1/fs/minix: itree_v1.o
Only in linux-2.6.21.1/fs/minix: itree_v2.o
Only in linux-2.6.21.1/fs/minix: minix.ko
Only in linux-2.6.21.1/fs/minix: minix.mod.c
Only in linux-2.6.21.1/fs/minix: minix.mod.o
Only in linux-2.6.21.1/fs/minix: minix.o
Only in linux-2.6.21.1/fs/minix: namei.o
Only in linux-2.6.21.1/fs: mpage.o
Only in linux-2.6.21.1/fs/msdos: .built-in.o.cmd
Only in linux-2.6.21.1/fs/msdos: .msdos.ko.cmd
Only in linux-2.6.21.1/fs/msdos: .msdos.mod.o.cmd
Only in linux-2.6.21.1/fs/msdos: .msdos.o.cmd
Only in linux-2.6.21.1/fs/msdos: .namei.o.cmd
Only in linux-2.6.21.1/fs/msdos: built-in.o
Only in linux-2.6.21.1/fs/msdos: msdos.ko
Only in linux-2.6.21.1/fs/msdos: msdos.mod.c
Only in linux-2.6.21.1/fs/msdos: msdos.mod.o
Only in linux-2.6.21.1/fs/msdos: msdos.o
Only in linux-2.6.21.1/fs/msdos: namei.o
Only in linux-2.6.21.1/fs: namei.o
Only in linux-2.6.21.1/fs: namespace.o
Only in linux-2.6.21.1/fs/nls: .built-in.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_ascii.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_ascii.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_ascii.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_base.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_base.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_base.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp1250.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp1250.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp1250.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp1251.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp1251.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp1251.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp1255.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp1255.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp1255.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp437.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp437.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp437.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp737.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp737.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp737.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp775.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp775.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp775.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp850.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp850.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp850.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp852.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp852.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp852.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp855.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp855.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp855.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp857.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp857.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp857.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp860.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp860.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp860.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp861.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp861.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp861.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp862.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp862.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp862.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp863.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp863.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp863.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp864.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp864.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp864.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp865.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp865.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp865.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp866.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp866.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp866.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp869.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp869.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp869.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp874.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp874.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp874.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp932.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp932.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp932.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp936.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp936.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp936.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp949.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp949.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp949.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp950.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp950.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_cp950.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_euc-jp.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_euc-jp.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_euc-jp.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-1.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-1.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-1.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-13.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-13.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-13.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-14.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-14.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-14.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-15.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-15.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-15.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-2.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-2.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-2.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-3.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-3.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-3.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-4.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-4.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-4.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-5.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-5.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-5.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-6.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-6.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-6.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-7.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-7.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-7.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-9.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-9.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_iso8859-9.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_koi8-r.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_koi8-r.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_koi8-r.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_koi8-ru.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_koi8-ru.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_koi8-ru.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_koi8-u.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_koi8-u.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_koi8-u.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_utf8.ko.cmd
Only in linux-2.6.21.1/fs/nls: .nls_utf8.mod.o.cmd
Only in linux-2.6.21.1/fs/nls: .nls_utf8.o.cmd
Only in linux-2.6.21.1/fs/nls: built-in.o
Only in linux-2.6.21.1/fs/nls: nls_ascii.ko
Only in linux-2.6.21.1/fs/nls: nls_ascii.mod.c
Only in linux-2.6.21.1/fs/nls: nls_ascii.mod.o
Only in linux-2.6.21.1/fs/nls: nls_ascii.o
Only in linux-2.6.21.1/fs/nls: nls_base.ko
Only in linux-2.6.21.1/fs/nls: nls_base.mod.c
Only in linux-2.6.21.1/fs/nls: nls_base.mod.o
Only in linux-2.6.21.1/fs/nls: nls_base.o
Only in linux-2.6.21.1/fs/nls: nls_cp1250.ko
Only in linux-2.6.21.1/fs/nls: nls_cp1250.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp1250.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp1250.o
Only in linux-2.6.21.1/fs/nls: nls_cp1251.ko
Only in linux-2.6.21.1/fs/nls: nls_cp1251.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp1251.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp1251.o
Only in linux-2.6.21.1/fs/nls: nls_cp1255.ko
Only in linux-2.6.21.1/fs/nls: nls_cp1255.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp1255.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp1255.o
Only in linux-2.6.21.1/fs/nls: nls_cp437.ko
Only in linux-2.6.21.1/fs/nls: nls_cp437.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp437.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp437.o
Only in linux-2.6.21.1/fs/nls: nls_cp737.ko
Only in linux-2.6.21.1/fs/nls: nls_cp737.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp737.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp737.o
Only in linux-2.6.21.1/fs/nls: nls_cp775.ko
Only in linux-2.6.21.1/fs/nls: nls_cp775.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp775.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp775.o
Only in linux-2.6.21.1/fs/nls: nls_cp850.ko
Only in linux-2.6.21.1/fs/nls: nls_cp850.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp850.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp850.o
Only in linux-2.6.21.1/fs/nls: nls_cp852.ko
Only in linux-2.6.21.1/fs/nls: nls_cp852.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp852.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp852.o
Only in linux-2.6.21.1/fs/nls: nls_cp855.ko
Only in linux-2.6.21.1/fs/nls: nls_cp855.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp855.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp855.o
Only in linux-2.6.21.1/fs/nls: nls_cp857.ko
Only in linux-2.6.21.1/fs/nls: nls_cp857.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp857.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp857.o
Only in linux-2.6.21.1/fs/nls: nls_cp860.ko
Only in linux-2.6.21.1/fs/nls: nls_cp860.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp860.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp860.o
Only in linux-2.6.21.1/fs/nls: nls_cp861.ko
Only in linux-2.6.21.1/fs/nls: nls_cp861.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp861.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp861.o
Only in linux-2.6.21.1/fs/nls: nls_cp862.ko
Only in linux-2.6.21.1/fs/nls: nls_cp862.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp862.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp862.o
Only in linux-2.6.21.1/fs/nls: nls_cp863.ko
Only in linux-2.6.21.1/fs/nls: nls_cp863.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp863.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp863.o
Only in linux-2.6.21.1/fs/nls: nls_cp864.ko
Only in linux-2.6.21.1/fs/nls: nls_cp864.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp864.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp864.o
Only in linux-2.6.21.1/fs/nls: nls_cp865.ko
Only in linux-2.6.21.1/fs/nls: nls_cp865.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp865.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp865.o
Only in linux-2.6.21.1/fs/nls: nls_cp866.ko
Only in linux-2.6.21.1/fs/nls: nls_cp866.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp866.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp866.o
Only in linux-2.6.21.1/fs/nls: nls_cp869.ko
Only in linux-2.6.21.1/fs/nls: nls_cp869.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp869.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp869.o
Only in linux-2.6.21.1/fs/nls: nls_cp874.ko
Only in linux-2.6.21.1/fs/nls: nls_cp874.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp874.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp874.o
Only in linux-2.6.21.1/fs/nls: nls_cp932.ko
Only in linux-2.6.21.1/fs/nls: nls_cp932.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp932.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp932.o
Only in linux-2.6.21.1/fs/nls: nls_cp936.ko
Only in linux-2.6.21.1/fs/nls: nls_cp936.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp936.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp936.o
Only in linux-2.6.21.1/fs/nls: nls_cp949.ko
Only in linux-2.6.21.1/fs/nls: nls_cp949.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp949.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp949.o
Only in linux-2.6.21.1/fs/nls: nls_cp950.ko
Only in linux-2.6.21.1/fs/nls: nls_cp950.mod.c
Only in linux-2.6.21.1/fs/nls: nls_cp950.mod.o
Only in linux-2.6.21.1/fs/nls: nls_cp950.o
Only in linux-2.6.21.1/fs/nls: nls_euc-jp.ko
Only in linux-2.6.21.1/fs/nls: nls_euc-jp.mod.c
Only in linux-2.6.21.1/fs/nls: nls_euc-jp.mod.o
Only in linux-2.6.21.1/fs/nls: nls_euc-jp.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-1.ko
Only in linux-2.6.21.1/fs/nls: nls_iso8859-1.mod.c
Only in linux-2.6.21.1/fs/nls: nls_iso8859-1.mod.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-1.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-13.ko
Only in linux-2.6.21.1/fs/nls: nls_iso8859-13.mod.c
Only in linux-2.6.21.1/fs/nls: nls_iso8859-13.mod.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-13.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-14.ko
Only in linux-2.6.21.1/fs/nls: nls_iso8859-14.mod.c
Only in linux-2.6.21.1/fs/nls: nls_iso8859-14.mod.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-14.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-15.ko
Only in linux-2.6.21.1/fs/nls: nls_iso8859-15.mod.c
Only in linux-2.6.21.1/fs/nls: nls_iso8859-15.mod.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-15.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-2.ko
Only in linux-2.6.21.1/fs/nls: nls_iso8859-2.mod.c
Only in linux-2.6.21.1/fs/nls: nls_iso8859-2.mod.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-2.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-3.ko
Only in linux-2.6.21.1/fs/nls: nls_iso8859-3.mod.c
Only in linux-2.6.21.1/fs/nls: nls_iso8859-3.mod.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-3.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-4.ko
Only in linux-2.6.21.1/fs/nls: nls_iso8859-4.mod.c
Only in linux-2.6.21.1/fs/nls: nls_iso8859-4.mod.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-4.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-5.ko
Only in linux-2.6.21.1/fs/nls: nls_iso8859-5.mod.c
Only in linux-2.6.21.1/fs/nls: nls_iso8859-5.mod.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-5.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-6.ko
Only in linux-2.6.21.1/fs/nls: nls_iso8859-6.mod.c
Only in linux-2.6.21.1/fs/nls: nls_iso8859-6.mod.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-6.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-7.ko
Only in linux-2.6.21.1/fs/nls: nls_iso8859-7.mod.c
Only in linux-2.6.21.1/fs/nls: nls_iso8859-7.mod.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-7.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-9.ko
Only in linux-2.6.21.1/fs/nls: nls_iso8859-9.mod.c
Only in linux-2.6.21.1/fs/nls: nls_iso8859-9.mod.o
Only in linux-2.6.21.1/fs/nls: nls_iso8859-9.o
Only in linux-2.6.21.1/fs/nls: nls_koi8-r.ko
Only in linux-2.6.21.1/fs/nls: nls_koi8-r.mod.c
Only in linux-2.6.21.1/fs/nls: nls_koi8-r.mod.o
Only in linux-2.6.21.1/fs/nls: nls_koi8-r.o
Only in linux-2.6.21.1/fs/nls: nls_koi8-ru.ko
Only in linux-2.6.21.1/fs/nls: nls_koi8-ru.mod.c
Only in linux-2.6.21.1/fs/nls: nls_koi8-ru.mod.o
Only in linux-2.6.21.1/fs/nls: nls_koi8-ru.o
Only in linux-2.6.21.1/fs/nls: nls_koi8-u.ko
Only in linux-2.6.21.1/fs/nls: nls_koi8-u.mod.c
Only in linux-2.6.21.1/fs/nls: nls_koi8-u.mod.o
Only in linux-2.6.21.1/fs/nls: nls_koi8-u.o
Only in linux-2.6.21.1/fs/nls: nls_utf8.ko
Only in linux-2.6.21.1/fs/nls: nls_utf8.mod.c
Only in linux-2.6.21.1/fs/nls: nls_utf8.mod.o
Only in linux-2.6.21.1/fs/nls: nls_utf8.o
Only in linux-2.6.21.1/fs: no-block.o
Only in linux-2.6.21.1/fs/ntfs: .aops.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .attrib.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .collate.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .compress.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .debug.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .dir.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .file.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .index.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .inode.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .mft.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .mst.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .namei.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .ntfs.ko.cmd
Only in linux-2.6.21.1/fs/ntfs: .ntfs.mod.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .ntfs.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .runlist.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .super.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .sysctl.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .unistr.o.cmd
Only in linux-2.6.21.1/fs/ntfs: .upcase.o.cmd
Only in linux-2.6.21.1/fs/ntfs: aops.o
Only in linux-2.6.21.1/fs/ntfs: attrib.o
Only in linux-2.6.21.1/fs/ntfs: built-in.o
Only in linux-2.6.21.1/fs/ntfs: collate.o
Only in linux-2.6.21.1/fs/ntfs: compress.o
Only in linux-2.6.21.1/fs/ntfs: debug.o
Only in linux-2.6.21.1/fs/ntfs: dir.o
Only in linux-2.6.21.1/fs/ntfs: file.o
Only in linux-2.6.21.1/fs/ntfs: index.o
Only in linux-2.6.21.1/fs/ntfs: inode.o
Only in linux-2.6.21.1/fs/ntfs: mft.o
Only in linux-2.6.21.1/fs/ntfs: mst.o
Only in linux-2.6.21.1/fs/ntfs: namei.o
Only in linux-2.6.21.1/fs/ntfs: ntfs.ko
Only in linux-2.6.21.1/fs/ntfs: ntfs.mod.c
Only in linux-2.6.21.1/fs/ntfs: ntfs.mod.o
Only in linux-2.6.21.1/fs/ntfs: ntfs.o
Only in linux-2.6.21.1/fs/ntfs: runlist.o
Only in linux-2.6.21.1/fs/ntfs: super.o
Only in linux-2.6.21.1/fs/ntfs: sysctl.o
Only in linux-2.6.21.1/fs/ntfs: unistr.o
Only in linux-2.6.21.1/fs/ntfs: upcase.o
Only in linux-2.6.21.1/fs: open.o
Only in linux-2.6.21.1/fs/partitions: .acorn.o.cmd
Only in linux-2.6.21.1/fs/partitions: .amiga.o.cmd
Only in linux-2.6.21.1/fs/partitions: .atari.o.cmd
Only in linux-2.6.21.1/fs/partitions: .built-in.o.cmd
Only in linux-2.6.21.1/fs/partitions: .check.o.cmd
Only in linux-2.6.21.1/fs/partitions: .efi.o.cmd
Only in linux-2.6.21.1/fs/partitions: .karma.o.cmd
Only in linux-2.6.21.1/fs/partitions: .ldm.o.cmd
Only in linux-2.6.21.1/fs/partitions: .mac.o.cmd
Only in linux-2.6.21.1/fs/partitions: .msdos.o.cmd
Only in linux-2.6.21.1/fs/partitions: .osf.o.cmd
Only in linux-2.6.21.1/fs/partitions: .sgi.o.cmd
Only in linux-2.6.21.1/fs/partitions: .sun.o.cmd
Only in linux-2.6.21.1/fs/partitions: .ultrix.o.cmd
Only in linux-2.6.21.1/fs/partitions: acorn.o
Only in linux-2.6.21.1/fs/partitions: amiga.o
Only in linux-2.6.21.1/fs/partitions: atari.o
Only in linux-2.6.21.1/fs/partitions: built-in.o
Only in linux-2.6.21.1/fs/partitions: check.o
Only in linux-2.6.21.1/fs/partitions: efi.o
Only in linux-2.6.21.1/fs/partitions: karma.o
Only in linux-2.6.21.1/fs/partitions: ldm.o
Only in linux-2.6.21.1/fs/partitions: mac.o
Only in linux-2.6.21.1/fs/partitions: msdos.o
Only in linux-2.6.21.1/fs/partitions: osf.o
Only in linux-2.6.21.1/fs/partitions: sgi.o
Only in linux-2.6.21.1/fs/partitions: sun.o
Only in linux-2.6.21.1/fs/partitions: ultrix.o
Only in linux-2.6.21.1/fs: pipe.o
Only in linux-2.6.21.1/fs: pnode.o
Only in linux-2.6.21.1/fs/proc: .array.o.cmd
Only in linux-2.6.21.1/fs/proc: .base.o.cmd
Only in linux-2.6.21.1/fs/proc: .built-in.o.cmd
Only in linux-2.6.21.1/fs/proc: .generic.o.cmd
Only in linux-2.6.21.1/fs/proc: .inode.o.cmd
Only in linux-2.6.21.1/fs/proc: .mmu.o.cmd
Only in linux-2.6.21.1/fs/proc: .proc.o.cmd
Only in linux-2.6.21.1/fs/proc: .proc_misc.o.cmd
Only in linux-2.6.21.1/fs/proc: .proc_tty.o.cmd
Only in linux-2.6.21.1/fs/proc: .root.o.cmd
Only in linux-2.6.21.1/fs/proc: .task_mmu.o.cmd
Only in linux-2.6.21.1/fs/proc: array.o
Only in linux-2.6.21.1/fs/proc: base.o
Only in linux-2.6.21.1/fs/proc: built-in.o
Only in linux-2.6.21.1/fs/proc: generic.o
Only in linux-2.6.21.1/fs/proc: inode.o
Only in linux-2.6.21.1/fs/proc: mmu.o
Only in linux-2.6.21.1/fs/proc: proc.o
Only in linux-2.6.21.1/fs/proc: proc_misc.o
Only in linux-2.6.21.1/fs/proc: proc_tty.o
Only in linux-2.6.21.1/fs/proc: root.o
Only in linux-2.6.21.1/fs/proc: task_mmu.o
Only in linux-2.6.21.1/fs/qnx4: .bitmap.o.cmd
Only in linux-2.6.21.1/fs/qnx4: .built-in.o.cmd
Only in linux-2.6.21.1/fs/qnx4: .dir.o.cmd
Only in linux-2.6.21.1/fs/qnx4: .file.o.cmd
Only in linux-2.6.21.1/fs/qnx4: .fsync.o.cmd
Only in linux-2.6.21.1/fs/qnx4: .inode.o.cmd
Only in linux-2.6.21.1/fs/qnx4: .namei.o.cmd
Only in linux-2.6.21.1/fs/qnx4: .qnx4.ko.cmd
Only in linux-2.6.21.1/fs/qnx4: .qnx4.mod.o.cmd
Only in linux-2.6.21.1/fs/qnx4: .qnx4.o.cmd
Only in linux-2.6.21.1/fs/qnx4: .truncate.o.cmd
Only in linux-2.6.21.1/fs/qnx4: bitmap.o
Only in linux-2.6.21.1/fs/qnx4: built-in.o
Only in linux-2.6.21.1/fs/qnx4: dir.o
Only in linux-2.6.21.1/fs/qnx4: file.o
Only in linux-2.6.21.1/fs/qnx4: fsync.o
Only in linux-2.6.21.1/fs/qnx4: inode.o
Only in linux-2.6.21.1/fs/qnx4: namei.o
Only in linux-2.6.21.1/fs/qnx4: qnx4.ko
Only in linux-2.6.21.1/fs/qnx4: qnx4.mod.c
Only in linux-2.6.21.1/fs/qnx4: qnx4.mod.o
Only in linux-2.6.21.1/fs/qnx4: qnx4.o
Only in linux-2.6.21.1/fs/qnx4: truncate.o
Only in linux-2.6.21.1/fs/ramfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/ramfs: .file-mmu.o.cmd
Only in linux-2.6.21.1/fs/ramfs: .inode.o.cmd
Only in linux-2.6.21.1/fs/ramfs: .ramfs.o.cmd
Only in linux-2.6.21.1/fs/ramfs: built-in.o
Only in linux-2.6.21.1/fs/ramfs: file-mmu.o
Only in linux-2.6.21.1/fs/ramfs: inode.o
Only in linux-2.6.21.1/fs/ramfs: ramfs.o
Only in linux-2.6.21.1/fs: read_write.o
Only in linux-2.6.21.1/fs: readdir.o
Only in linux-2.6.21.1/fs/reiserfs: .bitmap.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .dir.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .do_balan.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .file.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .fix_node.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .hashes.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .ibalance.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .inode.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .ioctl.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .item_ops.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .journal.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .lbalance.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .namei.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .objectid.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .prints.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .procfs.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .reiserfs.ko.cmd
Only in linux-2.6.21.1/fs/reiserfs: .reiserfs.mod.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .reiserfs.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .resize.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .stree.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .super.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: .tail_conversion.o.cmd
Only in linux-2.6.21.1/fs/reiserfs: bitmap.o
Only in linux-2.6.21.1/fs/reiserfs: built-in.o
Only in linux-2.6.21.1/fs/reiserfs: dir.o
Only in linux-2.6.21.1/fs/reiserfs: do_balan.o
Only in linux-2.6.21.1/fs/reiserfs: file.o
Only in linux-2.6.21.1/fs/reiserfs: fix_node.o
Only in linux-2.6.21.1/fs/reiserfs: hashes.o
Only in linux-2.6.21.1/fs/reiserfs: ibalance.o
Only in linux-2.6.21.1/fs/reiserfs: inode.o
Only in linux-2.6.21.1/fs/reiserfs: ioctl.o
Only in linux-2.6.21.1/fs/reiserfs: item_ops.o
Only in linux-2.6.21.1/fs/reiserfs: journal.o
Only in linux-2.6.21.1/fs/reiserfs: lbalance.o
Only in linux-2.6.21.1/fs/reiserfs: namei.o
Only in linux-2.6.21.1/fs/reiserfs: objectid.o
Only in linux-2.6.21.1/fs/reiserfs: prints.o
Only in linux-2.6.21.1/fs/reiserfs: procfs.o
Only in linux-2.6.21.1/fs/reiserfs: reiserfs.ko
Only in linux-2.6.21.1/fs/reiserfs: reiserfs.mod.c
Only in linux-2.6.21.1/fs/reiserfs: reiserfs.mod.o
Only in linux-2.6.21.1/fs/reiserfs: reiserfs.o
Only in linux-2.6.21.1/fs/reiserfs: resize.o
Only in linux-2.6.21.1/fs/reiserfs: stree.o
Only in linux-2.6.21.1/fs/reiserfs: super.o
Only in linux-2.6.21.1/fs/reiserfs: tail_conversion.o
Only in linux-2.6.21.1/fs/romfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/romfs: .inode.o.cmd
Only in linux-2.6.21.1/fs/romfs: .romfs.ko.cmd
Only in linux-2.6.21.1/fs/romfs: .romfs.mod.o.cmd
Only in linux-2.6.21.1/fs/romfs: .romfs.o.cmd
Only in linux-2.6.21.1/fs/romfs: built-in.o
Only in linux-2.6.21.1/fs/romfs: inode.o
Only in linux-2.6.21.1/fs/romfs: romfs.ko
Only in linux-2.6.21.1/fs/romfs: romfs.mod.c
Only in linux-2.6.21.1/fs/romfs: romfs.mod.o
Only in linux-2.6.21.1/fs/romfs: romfs.o
Only in linux-2.6.21.1/fs: select.o
Only in linux-2.6.21.1/fs: seq_file.o
Only in linux-2.6.21.1/fs: splice.o
Only in linux-2.6.21.1/fs: stack.o
Only in linux-2.6.21.1/fs: stat.o
Only in linux-2.6.21.1/fs: super.o
Only in linux-2.6.21.1/fs: sync.o
Only in linux-2.6.21.1/fs/sysfs: .bin.o.cmd
Only in linux-2.6.21.1/fs/sysfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/sysfs: .dir.o.cmd
Only in linux-2.6.21.1/fs/sysfs: .file.o.cmd
Only in linux-2.6.21.1/fs/sysfs: .group.o.cmd
Only in linux-2.6.21.1/fs/sysfs: .inode.o.cmd
Only in linux-2.6.21.1/fs/sysfs: .mount.o.cmd
Only in linux-2.6.21.1/fs/sysfs: .symlink.o.cmd
Only in linux-2.6.21.1/fs/sysfs: bin.o
Only in linux-2.6.21.1/fs/sysfs: built-in.o
Only in linux-2.6.21.1/fs/sysfs: dir.o
Only in linux-2.6.21.1/fs/sysfs: file.o
Only in linux-2.6.21.1/fs/sysfs: group.o
Only in linux-2.6.21.1/fs/sysfs: inode.o
Only in linux-2.6.21.1/fs/sysfs: mount.o
Only in linux-2.6.21.1/fs/sysfs: symlink.o
Only in linux-2.6.21.1/fs/sysv: .balloc.o.cmd
Only in linux-2.6.21.1/fs/sysv: .built-in.o.cmd
Only in linux-2.6.21.1/fs/sysv: .dir.o.cmd
Only in linux-2.6.21.1/fs/sysv: .file.o.cmd
Only in linux-2.6.21.1/fs/sysv: .ialloc.o.cmd
Only in linux-2.6.21.1/fs/sysv: .inode.o.cmd
Only in linux-2.6.21.1/fs/sysv: .itree.o.cmd
Only in linux-2.6.21.1/fs/sysv: .namei.o.cmd
Only in linux-2.6.21.1/fs/sysv: .super.o.cmd
Only in linux-2.6.21.1/fs/sysv: .symlink.o.cmd
Only in linux-2.6.21.1/fs/sysv: .sysv.ko.cmd
Only in linux-2.6.21.1/fs/sysv: .sysv.mod.o.cmd
Only in linux-2.6.21.1/fs/sysv: .sysv.o.cmd
Only in linux-2.6.21.1/fs/sysv: balloc.o
Only in linux-2.6.21.1/fs/sysv: built-in.o
Only in linux-2.6.21.1/fs/sysv: dir.o
Only in linux-2.6.21.1/fs/sysv: file.o
Only in linux-2.6.21.1/fs/sysv: ialloc.o
Only in linux-2.6.21.1/fs/sysv: inode.o
Only in linux-2.6.21.1/fs/sysv: itree.o
Only in linux-2.6.21.1/fs/sysv: namei.o
Only in linux-2.6.21.1/fs/sysv: super.o
Only in linux-2.6.21.1/fs/sysv: symlink.o
Only in linux-2.6.21.1/fs/sysv: sysv.ko
Only in linux-2.6.21.1/fs/sysv: sysv.mod.c
Only in linux-2.6.21.1/fs/sysv: sysv.mod.o
Only in linux-2.6.21.1/fs/sysv: sysv.o
Only in linux-2.6.21.1/fs/udf: .balloc.o.cmd
Only in linux-2.6.21.1/fs/udf: .built-in.o.cmd
Only in linux-2.6.21.1/fs/udf: .crc.o.cmd
Only in linux-2.6.21.1/fs/udf: .dir.o.cmd
Only in linux-2.6.21.1/fs/udf: .directory.o.cmd
Only in linux-2.6.21.1/fs/udf: .file.o.cmd
Only in linux-2.6.21.1/fs/udf: .fsync.o.cmd
Only in linux-2.6.21.1/fs/udf: .ialloc.o.cmd
Only in linux-2.6.21.1/fs/udf: .inode.o.cmd
Only in linux-2.6.21.1/fs/udf: .lowlevel.o.cmd
Only in linux-2.6.21.1/fs/udf: .misc.o.cmd
Only in linux-2.6.21.1/fs/udf: .namei.o.cmd
Only in linux-2.6.21.1/fs/udf: .partition.o.cmd
Only in linux-2.6.21.1/fs/udf: .super.o.cmd
Only in linux-2.6.21.1/fs/udf: .symlink.o.cmd
Only in linux-2.6.21.1/fs/udf: .truncate.o.cmd
Only in linux-2.6.21.1/fs/udf: .udf.ko.cmd
Only in linux-2.6.21.1/fs/udf: .udf.mod.o.cmd
Only in linux-2.6.21.1/fs/udf: .udf.o.cmd
Only in linux-2.6.21.1/fs/udf: .udftime.o.cmd
Only in linux-2.6.21.1/fs/udf: .unicode.o.cmd
Only in linux-2.6.21.1/fs/udf: balloc.o
Only in linux-2.6.21.1/fs/udf: built-in.o
Only in linux-2.6.21.1/fs/udf: crc.o
Only in linux-2.6.21.1/fs/udf: dir.o
Only in linux-2.6.21.1/fs/udf: directory.o
Only in linux-2.6.21.1/fs/udf: file.o
Only in linux-2.6.21.1/fs/udf: fsync.o
Only in linux-2.6.21.1/fs/udf: ialloc.o
Only in linux-2.6.21.1/fs/udf: inode.o
Only in linux-2.6.21.1/fs/udf: lowlevel.o
Only in linux-2.6.21.1/fs/udf: misc.o
Only in linux-2.6.21.1/fs/udf: namei.o
Only in linux-2.6.21.1/fs/udf: partition.o
Only in linux-2.6.21.1/fs/udf: super.o
Only in linux-2.6.21.1/fs/udf: symlink.o
Only in linux-2.6.21.1/fs/udf: truncate.o
Only in linux-2.6.21.1/fs/udf: udf.ko
Only in linux-2.6.21.1/fs/udf: udf.mod.c
Only in linux-2.6.21.1/fs/udf: udf.mod.o
Only in linux-2.6.21.1/fs/udf: udf.o
Only in linux-2.6.21.1/fs/udf: udftime.o
Only in linux-2.6.21.1/fs/udf: unicode.o
Only in linux-2.6.21.1/fs/ufs: .balloc.o.cmd
Only in linux-2.6.21.1/fs/ufs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/ufs: .cylinder.o.cmd
Only in linux-2.6.21.1/fs/ufs: .dir.o.cmd
Only in linux-2.6.21.1/fs/ufs: .file.o.cmd
Only in linux-2.6.21.1/fs/ufs: .ialloc.o.cmd
Only in linux-2.6.21.1/fs/ufs: .inode.o.cmd
Only in linux-2.6.21.1/fs/ufs: .namei.o.cmd
Only in linux-2.6.21.1/fs/ufs: .super.o.cmd
Only in linux-2.6.21.1/fs/ufs: .symlink.o.cmd
Only in linux-2.6.21.1/fs/ufs: .truncate.o.cmd
Only in linux-2.6.21.1/fs/ufs: .ufs.ko.cmd
Only in linux-2.6.21.1/fs/ufs: .ufs.mod.o.cmd
Only in linux-2.6.21.1/fs/ufs: .ufs.o.cmd
Only in linux-2.6.21.1/fs/ufs: .util.o.cmd
Only in linux-2.6.21.1/fs/ufs: balloc.o
Only in linux-2.6.21.1/fs/ufs: built-in.o
Only in linux-2.6.21.1/fs/ufs: cylinder.o
Only in linux-2.6.21.1/fs/ufs: dir.o
Only in linux-2.6.21.1/fs/ufs: file.o
Only in linux-2.6.21.1/fs/ufs: ialloc.o
Only in linux-2.6.21.1/fs/ufs: inode.o
Only in linux-2.6.21.1/fs/ufs: namei.o
Only in linux-2.6.21.1/fs/ufs: super.o
Only in linux-2.6.21.1/fs/ufs: symlink.o
Only in linux-2.6.21.1/fs/ufs: truncate.o
Only in linux-2.6.21.1/fs/ufs: ufs.ko
Only in linux-2.6.21.1/fs/ufs: ufs.mod.c
Only in linux-2.6.21.1/fs/ufs: ufs.mod.o
Only in linux-2.6.21.1/fs/ufs: ufs.o
Only in linux-2.6.21.1/fs/ufs: util.o
Only in linux-2.6.21.1/fs: utimes.o
Only in linux-2.6.21.1/fs/vfat: .built-in.o.cmd
Only in linux-2.6.21.1/fs/vfat: .namei.o.cmd
Only in linux-2.6.21.1/fs/vfat: .vfat.ko.cmd
Only in linux-2.6.21.1/fs/vfat: .vfat.mod.o.cmd
Only in linux-2.6.21.1/fs/vfat: .vfat.o.cmd
Only in linux-2.6.21.1/fs/vfat: built-in.o
Only in linux-2.6.21.1/fs/vfat: namei.o
Only in linux-2.6.21.1/fs/vfat: vfat.ko
Only in linux-2.6.21.1/fs/vfat: vfat.mod.c
Only in linux-2.6.21.1/fs/vfat: vfat.mod.o
Only in linux-2.6.21.1/fs/vfat: vfat.o
Only in linux-2.6.21.1/fs: xattr.o
Only in linux-2.6.21.1/fs/xfs: .built-in.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs.ko.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs.mod.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_alloc.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_alloc_btree.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_attr.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_attr_leaf.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_behavior.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_bit.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_bmap.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_bmap_btree.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_btree.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_buf_item.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_da_btree.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_dfrag.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_dir2.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_dir2_block.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_dir2_data.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_dir2_leaf.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_dir2_node.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_dir2_sf.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_dmops.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_error.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_extfree_item.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_fsops.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_ialloc.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_ialloc_btree.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_iget.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_inode.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_inode_item.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_iocore.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_iomap.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_itable.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_log.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_log_recover.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_mount.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_qmops.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_rename.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_rw.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_trans.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_trans_ail.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_trans_buf.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_trans_extfree.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_trans_inode.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_trans_item.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_utils.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_vfsops.o.cmd
Only in linux-2.6.21.1/fs/xfs: .xfs_vnodeops.o.cmd
Only in linux-2.6.21.1/fs/xfs: built-in.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .kmem.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_aops.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_buf.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_export.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_file.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_fs_subr.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_globals.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_ioctl.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_iops.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_lrw.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_stats.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_super.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_vfs.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: .xfs_vnode.o.cmd
Only in linux-2.6.21.1/fs/xfs/linux-2.6: kmem.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_aops.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_buf.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_export.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_file.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_fs_subr.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_globals.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_ioctl.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_iops.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_lrw.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_stats.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_super.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_vfs.o
Only in linux-2.6.21.1/fs/xfs/linux-2.6: xfs_vnode.o
Only in linux-2.6.21.1/fs/xfs/support: .debug.o.cmd
Only in linux-2.6.21.1/fs/xfs/support: .move.o.cmd
Only in linux-2.6.21.1/fs/xfs/support: .uuid.o.cmd
Only in linux-2.6.21.1/fs/xfs/support: debug.o
Only in linux-2.6.21.1/fs/xfs/support: move.o
Only in linux-2.6.21.1/fs/xfs/support: uuid.o
Only in linux-2.6.21.1/fs/xfs: xfs.ko
Only in linux-2.6.21.1/fs/xfs: xfs.mod.c
Only in linux-2.6.21.1/fs/xfs: xfs.mod.o
Only in linux-2.6.21.1/fs/xfs: xfs.o
Only in linux-2.6.21.1/fs/xfs: xfs_alloc.o
Only in linux-2.6.21.1/fs/xfs: xfs_alloc_btree.o
Only in linux-2.6.21.1/fs/xfs: xfs_attr.o
Only in linux-2.6.21.1/fs/xfs: xfs_attr_leaf.o
Only in linux-2.6.21.1/fs/xfs: xfs_behavior.o
Only in linux-2.6.21.1/fs/xfs: xfs_bit.o
Only in linux-2.6.21.1/fs/xfs: xfs_bmap.o
Only in linux-2.6.21.1/fs/xfs: xfs_bmap_btree.o
Only in linux-2.6.21.1/fs/xfs: xfs_btree.o
Only in linux-2.6.21.1/fs/xfs: xfs_buf_item.o
Only in linux-2.6.21.1/fs/xfs: xfs_da_btree.o
Only in linux-2.6.21.1/fs/xfs: xfs_dfrag.o
Only in linux-2.6.21.1/fs/xfs: xfs_dir2.o
Only in linux-2.6.21.1/fs/xfs: xfs_dir2_block.o
Only in linux-2.6.21.1/fs/xfs: xfs_dir2_data.o
Only in linux-2.6.21.1/fs/xfs: xfs_dir2_leaf.o
Only in linux-2.6.21.1/fs/xfs: xfs_dir2_node.o
Only in linux-2.6.21.1/fs/xfs: xfs_dir2_sf.o
Only in linux-2.6.21.1/fs/xfs: xfs_dmops.o
Only in linux-2.6.21.1/fs/xfs: xfs_error.o
Only in linux-2.6.21.1/fs/xfs: xfs_extfree_item.o
Only in linux-2.6.21.1/fs/xfs: xfs_fsops.o
Only in linux-2.6.21.1/fs/xfs: xfs_ialloc.o
Only in linux-2.6.21.1/fs/xfs: xfs_ialloc_btree.o
Only in linux-2.6.21.1/fs/xfs: xfs_iget.o
Only in linux-2.6.21.1/fs/xfs: xfs_inode.o
Only in linux-2.6.21.1/fs/xfs: xfs_inode_item.o
Only in linux-2.6.21.1/fs/xfs: xfs_iocore.o
Only in linux-2.6.21.1/fs/xfs: xfs_iomap.o
Only in linux-2.6.21.1/fs/xfs: xfs_itable.o
Only in linux-2.6.21.1/fs/xfs: xfs_log.o
Only in linux-2.6.21.1/fs/xfs: xfs_log_recover.o
Only in linux-2.6.21.1/fs/xfs: xfs_mount.o
Only in linux-2.6.21.1/fs/xfs: xfs_qmops.o
Only in linux-2.6.21.1/fs/xfs: xfs_rename.o
Only in linux-2.6.21.1/fs/xfs: xfs_rw.o
Only in linux-2.6.21.1/fs/xfs: xfs_trans.o
Only in linux-2.6.21.1/fs/xfs: xfs_trans_ail.o
Only in linux-2.6.21.1/fs/xfs: xfs_trans_buf.o
Only in linux-2.6.21.1/fs/xfs: xfs_trans_extfree.o
Only in linux-2.6.21.1/fs/xfs: xfs_trans_inode.o
Only in linux-2.6.21.1/fs/xfs: xfs_trans_item.o
Only in linux-2.6.21.1/fs/xfs: xfs_utils.o
Only in linux-2.6.21.1/fs/xfs: xfs_vfsops.o
Only in linux-2.6.21.1/fs/xfs: xfs_vnodeops.o
Only in linux-2.6.21.1/include: asm
Only in linux-2.6.21.1/include/asm-i386: asm-offsets.h
Only in linux-2.6.21.1/include: config
Only in linux-2.6.21.1/include/linux: autoconf.h
Only in linux-2.6.21.1/include/linux: compile.h
diff -r -u linux-2.6.21.1/include/linux/ide.h linux-2.6.21.1-386/include/linux/ide.h
--- linux-2.6.21.1/include/linux/ide.h	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/include/linux/ide.h	2007-07-03 16:36:02.000000000 +0000
@@ -601,12 +601,14 @@
 	unsigned remap_0_to_1	: 1;	/* 0=noremap, 1=remap 0->1 (for EZDrive) */
 	unsigned blocked        : 1;	/* 1=powermanagment told us not to do anything, so sleep nicely */
 	unsigned vdma		: 1;	/* 1=doing PIO over DMA 0=doing normal DMA */
+#ifndef CONFIG_IDE_DISABLE_LBA48
 	unsigned addressing;		/*      : 3;
 					 *  0=28-bit
 					 *  1=48-bit
 					 *  2=48-bit doing 28-bit
 					 *  3=64-bit
 					 */
+#endif
 	unsigned scsi		: 1;	/* 0=default, 1=ide-scsi emulation */
 	unsigned sleeping	: 1;	/* 1=sleeping & sleep field valid */
 	unsigned post_reset	: 1;
Only in linux-2.6.21.1/include/linux: utsrelease.h
Only in linux-2.6.21.1/include/linux: version.h
Only in linux-2.6.21.1/init: .built-in.o.cmd
Only in linux-2.6.21.1/init: .calibrate.o.cmd
Only in linux-2.6.21.1/init: .do_mounts.o.cmd
Only in linux-2.6.21.1/init: .do_mounts_initrd.o.cmd
Only in linux-2.6.21.1/init: .initramfs.o.cmd
Only in linux-2.6.21.1/init: .main.o.cmd
Only in linux-2.6.21.1/init: .mounts.o.cmd
Only in linux-2.6.21.1/init: .noinitramfs.o.cmd
Only in linux-2.6.21.1/init: .version.o.cmd
diff -r -u linux-2.6.21.1/init/Kconfig linux-2.6.21.1-386/init/Kconfig
--- linux-2.6.21.1/init/Kconfig	2007-04-27 21:49:26.000000000 +0000
+++ linux-2.6.21.1-386/init/Kconfig	2007-07-03 13:02:00.000000000 +0000
@@ -131,6 +131,18 @@
 	depends on SYSCTL
 	default y
 
+config INITRAMFS_ONLY
+	bool "Initramfs-only boot"
+	depends on BLK_DEV_INITRD
+	default n
+	---help---
+	  Enable this option if you are building a minimal system in initramfs
+	  that will never boot from the hard drive. This option disables the
+	  normal sysvinit boot code and makes the kernel entirely dependent on
+	  your initramfs.
+	  
+	  If unsure, say N
+
 config POSIX_MQUEUE
 	bool "POSIX Message Queues"
 	depends on NET && EXPERIMENTAL
Only in linux-2.6.21.1/init: built-in.o
Only in linux-2.6.21.1/init: calibrate.o
Only in linux-2.6.21.1/init: do_mounts.o
Only in linux-2.6.21.1/init: do_mounts_initrd.o
Only in linux-2.6.21.1/init: initramfs.o
diff -r -u linux-2.6.21.1/init/main.c linux-2.6.21.1-386/init/main.c
--- linux-2.6.21.1/init/main.c	2007-04-29 03:24:37.000000000 +0000
+++ linux-2.6.21.1-386/init/main.c	2007-07-03 13:00:21.000000000 +0000
@@ -129,7 +129,9 @@
 /* Command line for parameter parsing */
 static char *static_command_line;
 
+#ifndef CONFIG_INITRAMFS_ONLY
 static char *execute_command;
+#endif
 static char *ramdisk_execute_command;
 
 /* Setup configured maximum number of CPUs to activate */
@@ -321,6 +323,7 @@
 	return 0;
 }
 
+#ifndef CONFIG_INITRAMFS_ONLY
 static int __init init_setup(char *str)
 {
 	unsigned int i;
@@ -337,6 +340,7 @@
 	return 1;
 }
 __setup("init=", init_setup);
+#endif
 
 static int __init rdinit_setup(char *str)
 {
@@ -762,6 +766,9 @@
 				ramdisk_execute_command);
 	}
 
+#ifdef CONFIG_INITRAMFS_ONLY
+	panic("No init found.  Try passing rdinit= or fixing your initramfs image.");
+#else
 	/*
 	 * We try each of these until one succeeds.
 	 *
@@ -779,6 +786,7 @@
 	run_init_process("/bin/sh");
 
 	panic("No init found.  Try passing init= option to kernel.");
+#endif
 }
 
 static int __init init(void * unused)
Only in linux-2.6.21.1/init: main.c~
Only in linux-2.6.21.1/init: main.o
Only in linux-2.6.21.1/init: mounts.o
Only in linux-2.6.21.1/init: noinitramfs.o
Only in linux-2.6.21.1/init: version.o
Only in linux-2.6.21.1/ipc: .built-in.o.cmd
Only in linux-2.6.21.1/ipc: built-in.o
Only in linux-2.6.21.1/kernel: .built-in.o.cmd
Only in linux-2.6.21.1/kernel: .capability.o.cmd
Only in linux-2.6.21.1/kernel: .dma.o.cmd
Only in linux-2.6.21.1/kernel: .exec_domain.o.cmd
Only in linux-2.6.21.1/kernel: .exit.o.cmd
Only in linux-2.6.21.1/kernel: .extable.o.cmd
Only in linux-2.6.21.1/kernel: .fork.o.cmd
Only in linux-2.6.21.1/kernel: .hrtimer.o.cmd
Only in linux-2.6.21.1/kernel: .itimer.o.cmd
Only in linux-2.6.21.1/kernel: .kfifo.o.cmd
Only in linux-2.6.21.1/kernel: .kmod.o.cmd
Only in linux-2.6.21.1/kernel: .ksysfs.o.cmd
Only in linux-2.6.21.1/kernel: .kthread.o.cmd
Only in linux-2.6.21.1/kernel: .latency.o.cmd
Only in linux-2.6.21.1/kernel: .module.o.cmd
Only in linux-2.6.21.1/kernel: .mutex.o.cmd
Only in linux-2.6.21.1/kernel: .nsproxy.o.cmd
Only in linux-2.6.21.1/kernel: .panic.o.cmd
Only in linux-2.6.21.1/kernel: .params.o.cmd
Only in linux-2.6.21.1/kernel: .pid.o.cmd
Only in linux-2.6.21.1/kernel: .posix-cpu-timers.o.cmd
Only in linux-2.6.21.1/kernel: .posix-timers.o.cmd
Only in linux-2.6.21.1/kernel: .printk.o.cmd
Only in linux-2.6.21.1/kernel: .profile.o.cmd
Only in linux-2.6.21.1/kernel: .ptrace.o.cmd
Only in linux-2.6.21.1/kernel: .rcupdate.o.cmd
Only in linux-2.6.21.1/kernel: .resource.o.cmd
Only in linux-2.6.21.1/kernel: .rwsem.o.cmd
Only in linux-2.6.21.1/kernel: .sched.o.cmd
Only in linux-2.6.21.1/kernel: .signal.o.cmd
Only in linux-2.6.21.1/kernel: .softirq.o.cmd
Only in linux-2.6.21.1/kernel: .srcu.o.cmd
Only in linux-2.6.21.1/kernel: .sys.o.cmd
Only in linux-2.6.21.1/kernel: .sys_ni.o.cmd
Only in linux-2.6.21.1/kernel: .sysctl.o.cmd
Only in linux-2.6.21.1/kernel: .time.o.cmd
Only in linux-2.6.21.1/kernel: .timer.o.cmd
Only in linux-2.6.21.1/kernel: .uid16.o.cmd
Only in linux-2.6.21.1/kernel: .user.o.cmd
Only in linux-2.6.21.1/kernel: .wait.o.cmd
Only in linux-2.6.21.1/kernel: .workqueue.o.cmd
Only in linux-2.6.21.1/kernel: built-in.o
Only in linux-2.6.21.1/kernel: capability.o
Only in linux-2.6.21.1/kernel: dma.o
Only in linux-2.6.21.1/kernel: exec_domain.o
Only in linux-2.6.21.1/kernel: exit.o
Only in linux-2.6.21.1/kernel: extable.o
Only in linux-2.6.21.1/kernel: fork.o
Only in linux-2.6.21.1/kernel: hrtimer.o
Only in linux-2.6.21.1/kernel/irq: .autoprobe.o.cmd
Only in linux-2.6.21.1/kernel/irq: .built-in.o.cmd
Only in linux-2.6.21.1/kernel/irq: .chip.o.cmd
Only in linux-2.6.21.1/kernel/irq: .devres.o.cmd
Only in linux-2.6.21.1/kernel/irq: .handle.o.cmd
Only in linux-2.6.21.1/kernel/irq: .manage.o.cmd
Only in linux-2.6.21.1/kernel/irq: .proc.o.cmd
Only in linux-2.6.21.1/kernel/irq: .resend.o.cmd
Only in linux-2.6.21.1/kernel/irq: .spurious.o.cmd
Only in linux-2.6.21.1/kernel/irq: autoprobe.o
Only in linux-2.6.21.1/kernel/irq: built-in.o
Only in linux-2.6.21.1/kernel/irq: chip.o
Only in linux-2.6.21.1/kernel/irq: devres.o
Only in linux-2.6.21.1/kernel/irq: handle.o
Only in linux-2.6.21.1/kernel/irq: manage.o
Only in linux-2.6.21.1/kernel/irq: proc.o
Only in linux-2.6.21.1/kernel/irq: resend.o
Only in linux-2.6.21.1/kernel/irq: spurious.o
Only in linux-2.6.21.1/kernel: itimer.o
Only in linux-2.6.21.1/kernel: kfifo.o
Only in linux-2.6.21.1/kernel: kmod.o
Only in linux-2.6.21.1/kernel: ksysfs.o
Only in linux-2.6.21.1/kernel: kthread.o
Only in linux-2.6.21.1/kernel: latency.o
Only in linux-2.6.21.1/kernel: module.o
Only in linux-2.6.21.1/kernel: mutex.o
Only in linux-2.6.21.1/kernel: nsproxy.o
Only in linux-2.6.21.1/kernel: panic.o
Only in linux-2.6.21.1/kernel: params.o
Only in linux-2.6.21.1/kernel: pid.o
Only in linux-2.6.21.1/kernel: posix-cpu-timers.o
Only in linux-2.6.21.1/kernel: posix-timers.o
Only in linux-2.6.21.1/kernel: printk.o
Only in linux-2.6.21.1/kernel: profile.o
Only in linux-2.6.21.1/kernel: ptrace.o
Only in linux-2.6.21.1/kernel: rcupdate.o
Only in linux-2.6.21.1/kernel: resource.o
Only in linux-2.6.21.1/kernel: rwsem.o
Only in linux-2.6.21.1/kernel: sched.o
Only in linux-2.6.21.1/kernel: signal.o
Only in linux-2.6.21.1/kernel: softirq.o
Only in linux-2.6.21.1/kernel: srcu.o
Only in linux-2.6.21.1/kernel: sys.o
Only in linux-2.6.21.1/kernel: sys_ni.o
Only in linux-2.6.21.1/kernel: sysctl.o
Only in linux-2.6.21.1/kernel/time: .built-in.o.cmd
Only in linux-2.6.21.1/kernel/time: .clockevents.o.cmd
Only in linux-2.6.21.1/kernel/time: .clocksource.o.cmd
Only in linux-2.6.21.1/kernel/time: .jiffies.o.cmd
Only in linux-2.6.21.1/kernel/time: .ntp.o.cmd
Only in linux-2.6.21.1/kernel/time: .tick-common.o.cmd
Only in linux-2.6.21.1/kernel/time: .tick-oneshot.o.cmd
Only in linux-2.6.21.1/kernel/time: .tick-sched.o.cmd
Only in linux-2.6.21.1/kernel/time: .timer_list.o.cmd
Only in linux-2.6.21.1/kernel/time: built-in.o
Only in linux-2.6.21.1/kernel/time: clockevents.o
Only in linux-2.6.21.1/kernel/time: clocksource.o
Only in linux-2.6.21.1/kernel/time: jiffies.o
Only in linux-2.6.21.1/kernel/time: ntp.o
Only in linux-2.6.21.1/kernel/time: tick-common.o
Only in linux-2.6.21.1/kernel/time: tick-oneshot.o
Only in linux-2.6.21.1/kernel/time: tick-sched.o
Only in linux-2.6.21.1/kernel/time: timer_list.o
Only in linux-2.6.21.1/kernel: time.o
Only in linux-2.6.21.1/kernel: timer.o
Only in linux-2.6.21.1/kernel: uid16.o
Only in linux-2.6.21.1/kernel: user.o
Only in linux-2.6.21.1/kernel: wait.o
Only in linux-2.6.21.1/kernel: workqueue.o
Only in linux-2.6.21.1/lib: .bitmap.o.cmd
Only in linux-2.6.21.1/lib: .bitrev.o.cmd
Only in linux-2.6.21.1/lib: .built-in.o.cmd
Only in linux-2.6.21.1/lib: .bust_spinlocks.o.cmd
Only in linux-2.6.21.1/lib: .cmdline.o.cmd
Only in linux-2.6.21.1/lib: .crc32.o.cmd
Only in linux-2.6.21.1/lib: .ctype.o.cmd
Only in linux-2.6.21.1/lib: .debug_locks.o.cmd
Only in linux-2.6.21.1/lib: .dec_and_lock.o.cmd
Only in linux-2.6.21.1/lib: .devres.o.cmd
Only in linux-2.6.21.1/lib: .div64.o.cmd
Only in linux-2.6.21.1/lib: .dump_stack.o.cmd
Only in linux-2.6.21.1/lib: .extable.o.cmd
Only in linux-2.6.21.1/lib: .gen_crc32table.cmd
Only in linux-2.6.21.1/lib: .halfmd4.o.cmd
Only in linux-2.6.21.1/lib: .hweight.o.cmd
Only in linux-2.6.21.1/lib: .idr.o.cmd
Only in linux-2.6.21.1/lib: .int_sqrt.o.cmd
Only in linux-2.6.21.1/lib: .iomap.o.cmd
Only in linux-2.6.21.1/lib: .iomap_copy.o.cmd
Only in linux-2.6.21.1/lib: .ioremap.o.cmd
Only in linux-2.6.21.1/lib: .irq_regs.o.cmd
Only in linux-2.6.21.1/lib: .klist.o.cmd
Only in linux-2.6.21.1/lib: .kobject.o.cmd
Only in linux-2.6.21.1/lib: .kobject_uevent.o.cmd
Only in linux-2.6.21.1/lib: .kref.o.cmd
Only in linux-2.6.21.1/lib: .lib.a.cmd
Only in linux-2.6.21.1/lib: .parser.o.cmd
Only in linux-2.6.21.1/lib: .prio_tree.o.cmd
Only in linux-2.6.21.1/lib: .radix-tree.o.cmd
Only in linux-2.6.21.1/lib: .random32.o.cmd
Only in linux-2.6.21.1/lib: .rbtree.o.cmd
Only in linux-2.6.21.1/lib: .reciprocal_div.o.cmd
Only in linux-2.6.21.1/lib: .rwsem-spinlock.o.cmd
Only in linux-2.6.21.1/lib: .semaphore-sleepers.o.cmd
Only in linux-2.6.21.1/lib: .sha1.o.cmd
Only in linux-2.6.21.1/lib: .sort.o.cmd
Only in linux-2.6.21.1/lib: .string.o.cmd
Only in linux-2.6.21.1/lib: .vsprintf.o.cmd
Only in linux-2.6.21.1/lib: bitmap.o
Only in linux-2.6.21.1/lib: bitrev.o
Only in linux-2.6.21.1/lib: built-in.o
Only in linux-2.6.21.1/lib: bust_spinlocks.o
Only in linux-2.6.21.1/lib: cmdline.o
Only in linux-2.6.21.1/lib: crc32.o
Only in linux-2.6.21.1/lib: crc32table.h
Only in linux-2.6.21.1/lib: ctype.o
Only in linux-2.6.21.1/lib: debug_locks.o
Only in linux-2.6.21.1/lib: dec_and_lock.o
Only in linux-2.6.21.1/lib: devres.o
Only in linux-2.6.21.1/lib: div64.o
Only in linux-2.6.21.1/lib: dump_stack.o
Only in linux-2.6.21.1/lib: extable.o
Only in linux-2.6.21.1/lib: gen_crc32table
Only in linux-2.6.21.1/lib: halfmd4.o
Only in linux-2.6.21.1/lib: hweight.o
Only in linux-2.6.21.1/lib: idr.o
Only in linux-2.6.21.1/lib: int_sqrt.o
Only in linux-2.6.21.1/lib: iomap.o
Only in linux-2.6.21.1/lib: iomap_copy.o
Only in linux-2.6.21.1/lib: ioremap.o
Only in linux-2.6.21.1/lib: irq_regs.o
Only in linux-2.6.21.1/lib: klist.o
Only in linux-2.6.21.1/lib: kobject.o
Only in linux-2.6.21.1/lib: kobject_uevent.o
Only in linux-2.6.21.1/lib: kref.o
Only in linux-2.6.21.1/lib: lib.a
Only in linux-2.6.21.1/lib: parser.o
Only in linux-2.6.21.1/lib: prio_tree.o
Only in linux-2.6.21.1/lib: radix-tree.o
Only in linux-2.6.21.1/lib: random32.o
Only in linux-2.6.21.1/lib: rbtree.o
Only in linux-2.6.21.1/lib: reciprocal_div.o
Only in linux-2.6.21.1/lib: rwsem-spinlock.o
Only in linux-2.6.21.1/lib: semaphore-sleepers.o
Only in linux-2.6.21.1/lib: sha1.o
Only in linux-2.6.21.1/lib: sort.o
Only in linux-2.6.21.1/lib: string.o
Only in linux-2.6.21.1/lib: vsprintf.o
Only in linux-2.6.21.1/lib/zlib_inflate: .built-in.o.cmd
Only in linux-2.6.21.1/lib/zlib_inflate: .inffast.o.cmd
Only in linux-2.6.21.1/lib/zlib_inflate: .inflate.o.cmd
Only in linux-2.6.21.1/lib/zlib_inflate: .inflate_syms.o.cmd
Only in linux-2.6.21.1/lib/zlib_inflate: .inftrees.o.cmd
Only in linux-2.6.21.1/lib/zlib_inflate: .zlib_inflate.ko.cmd
Only in linux-2.6.21.1/lib/zlib_inflate: .zlib_inflate.mod.o.cmd
Only in linux-2.6.21.1/lib/zlib_inflate: .zlib_inflate.o.cmd
Only in linux-2.6.21.1/lib/zlib_inflate: built-in.o
Only in linux-2.6.21.1/lib/zlib_inflate: inffast.o
Only in linux-2.6.21.1/lib/zlib_inflate: inflate.o
Only in linux-2.6.21.1/lib/zlib_inflate: inflate_syms.o
Only in linux-2.6.21.1/lib/zlib_inflate: inftrees.o
Only in linux-2.6.21.1/lib/zlib_inflate: zlib_inflate.ko
Only in linux-2.6.21.1/lib/zlib_inflate: zlib_inflate.mod.c
Only in linux-2.6.21.1/lib/zlib_inflate: zlib_inflate.mod.o
Only in linux-2.6.21.1/lib/zlib_inflate: zlib_inflate.o
Only in linux-2.6.21.1/mm: .backing-dev.o.cmd
Only in linux-2.6.21.1/mm: .bootmem.o.cmd
Only in linux-2.6.21.1/mm: .bounce.o.cmd
Only in linux-2.6.21.1/mm: .built-in.o.cmd
Only in linux-2.6.21.1/mm: .fadvise.o.cmd
Only in linux-2.6.21.1/mm: .filemap.o.cmd
Only in linux-2.6.21.1/mm: .fremap.o.cmd
Only in linux-2.6.21.1/mm: .highmem.o.cmd
Only in linux-2.6.21.1/mm: .madvise.o.cmd
Only in linux-2.6.21.1/mm: .memory.o.cmd
Only in linux-2.6.21.1/mm: .mempool.o.cmd
Only in linux-2.6.21.1/mm: .mincore.o.cmd
Only in linux-2.6.21.1/mm: .mlock.o.cmd
Only in linux-2.6.21.1/mm: .mmap.o.cmd
Only in linux-2.6.21.1/mm: .mmzone.o.cmd
Only in linux-2.6.21.1/mm: .mprotect.o.cmd
Only in linux-2.6.21.1/mm: .mremap.o.cmd
Only in linux-2.6.21.1/mm: .msync.o.cmd
Only in linux-2.6.21.1/mm: .oom_kill.o.cmd
Only in linux-2.6.21.1/mm: .page-writeback.o.cmd
Only in linux-2.6.21.1/mm: .page_alloc.o.cmd
Only in linux-2.6.21.1/mm: .page_io.o.cmd
Only in linux-2.6.21.1/mm: .pdflush.o.cmd
Only in linux-2.6.21.1/mm: .prio_tree.o.cmd
Only in linux-2.6.21.1/mm: .readahead.o.cmd
Only in linux-2.6.21.1/mm: .rmap.o.cmd
Only in linux-2.6.21.1/mm: .slob.o.cmd
Only in linux-2.6.21.1/mm: .swap.o.cmd
Only in linux-2.6.21.1/mm: .swap_state.o.cmd
Only in linux-2.6.21.1/mm: .swapfile.o.cmd
Only in linux-2.6.21.1/mm: .thrash.o.cmd
Only in linux-2.6.21.1/mm: .tiny-shmem.o.cmd
Only in linux-2.6.21.1/mm: .truncate.o.cmd
Only in linux-2.6.21.1/mm: .util.o.cmd
Only in linux-2.6.21.1/mm: .vmalloc.o.cmd
Only in linux-2.6.21.1/mm: .vmscan.o.cmd
Only in linux-2.6.21.1/mm: .vmstat.o.cmd
Only in linux-2.6.21.1/mm: backing-dev.o
Only in linux-2.6.21.1/mm: bootmem.o
Only in linux-2.6.21.1/mm: bounce.o
Only in linux-2.6.21.1/mm: built-in.o
Only in linux-2.6.21.1/mm: fadvise.o
Only in linux-2.6.21.1/mm: filemap.o
Only in linux-2.6.21.1/mm: fremap.o
Only in linux-2.6.21.1/mm: highmem.o
Only in linux-2.6.21.1/mm: madvise.o
Only in linux-2.6.21.1/mm: memory.o
Only in linux-2.6.21.1/mm: mempool.o
Only in linux-2.6.21.1/mm: mincore.o
Only in linux-2.6.21.1/mm: mlock.o
Only in linux-2.6.21.1/mm: mmap.o
Only in linux-2.6.21.1/mm: mmzone.o
Only in linux-2.6.21.1/mm: mprotect.o
Only in linux-2.6.21.1/mm: mremap.o
Only in linux-2.6.21.1/mm: msync.o
Only in linux-2.6.21.1/mm: oom_kill.o
Only in linux-2.6.21.1/mm: page-writeback.o
Only in linux-2.6.21.1/mm: page_alloc.o
Only in linux-2.6.21.1/mm: page_io.o
Only in linux-2.6.21.1/mm: pdflush.o
Only in linux-2.6.21.1/mm: prio_tree.o
Only in linux-2.6.21.1/mm: readahead.o
Only in linux-2.6.21.1/mm: rmap.o
Only in linux-2.6.21.1/mm: slob.o
Only in linux-2.6.21.1/mm: swap.o
Only in linux-2.6.21.1/mm: swap_state.o
Only in linux-2.6.21.1/mm: swapfile.o
Only in linux-2.6.21.1/mm: thrash.o
Only in linux-2.6.21.1/mm: tiny-shmem.o
Only in linux-2.6.21.1/mm: truncate.o
Only in linux-2.6.21.1/mm: util.o
Only in linux-2.6.21.1/mm: vmalloc.o
Only in linux-2.6.21.1/mm: vmscan.o
Only in linux-2.6.21.1/mm: vmstat.o
Only in linux-2.6.21.1/net: .built-in.o.cmd
Only in linux-2.6.21.1/net: .nonet.o.cmd
Only in linux-2.6.21.1/net: .socket.o.cmd
Only in linux-2.6.21.1/net/802: .built-in.o.cmd
Only in linux-2.6.21.1/net/802: built-in.o
Only in linux-2.6.21.1/net: built-in.o
Only in linux-2.6.21.1/net/core: .built-in.o.cmd
Only in linux-2.6.21.1/net/core: .datagram.o.cmd
Only in linux-2.6.21.1/net/core: .dev.o.cmd
Only in linux-2.6.21.1/net/core: .dev_mcast.o.cmd
Only in linux-2.6.21.1/net/core: .dst.o.cmd
Only in linux-2.6.21.1/net/core: .ethtool.o.cmd
Only in linux-2.6.21.1/net/core: .filter.o.cmd
Only in linux-2.6.21.1/net/core: .gen_estimator.o.cmd
Only in linux-2.6.21.1/net/core: .gen_stats.o.cmd
Only in linux-2.6.21.1/net/core: .iovec.o.cmd
Only in linux-2.6.21.1/net/core: .link_watch.o.cmd
Only in linux-2.6.21.1/net/core: .neighbour.o.cmd
Only in linux-2.6.21.1/net/core: .net-sysfs.o.cmd
Only in linux-2.6.21.1/net/core: .netevent.o.cmd
Only in linux-2.6.21.1/net/core: .request_sock.o.cmd
Only in linux-2.6.21.1/net/core: .rtnetlink.o.cmd
Only in linux-2.6.21.1/net/core: .scm.o.cmd
Only in linux-2.6.21.1/net/core: .skbuff.o.cmd
Only in linux-2.6.21.1/net/core: .sock.o.cmd
Only in linux-2.6.21.1/net/core: .stream.o.cmd
Only in linux-2.6.21.1/net/core: .utils.o.cmd
Only in linux-2.6.21.1/net/core: built-in.o
Only in linux-2.6.21.1/net/core: datagram.o
Only in linux-2.6.21.1/net/core: dev.o
Only in linux-2.6.21.1/net/core: dev_mcast.o
Only in linux-2.6.21.1/net/core: dst.o
Only in linux-2.6.21.1/net/core: ethtool.o
Only in linux-2.6.21.1/net/core: filter.o
Only in linux-2.6.21.1/net/core: gen_estimator.o
Only in linux-2.6.21.1/net/core: gen_stats.o
Only in linux-2.6.21.1/net/core: iovec.o
Only in linux-2.6.21.1/net/core: link_watch.o
Only in linux-2.6.21.1/net/core: neighbour.o
Only in linux-2.6.21.1/net/core: net-sysfs.o
Only in linux-2.6.21.1/net/core: netevent.o
Only in linux-2.6.21.1/net/core: request_sock.o
Only in linux-2.6.21.1/net/core: rtnetlink.o
Only in linux-2.6.21.1/net/core: scm.o
Only in linux-2.6.21.1/net/core: skbuff.o
Only in linux-2.6.21.1/net/core: sock.o
Only in linux-2.6.21.1/net/core: stream.o
Only in linux-2.6.21.1/net/core: utils.o
Only in linux-2.6.21.1/net/ethernet: .built-in.o.cmd
Only in linux-2.6.21.1/net/ethernet: .eth.o.cmd
Only in linux-2.6.21.1/net/ethernet: built-in.o
Only in linux-2.6.21.1/net/ethernet: eth.o
Only in linux-2.6.21.1/net/netlink: .af_netlink.o.cmd
Only in linux-2.6.21.1/net/netlink: .attr.o.cmd
Only in linux-2.6.21.1/net/netlink: .built-in.o.cmd
Only in linux-2.6.21.1/net/netlink: .genetlink.o.cmd
Only in linux-2.6.21.1/net/netlink: af_netlink.o
Only in linux-2.6.21.1/net/netlink: attr.o
Only in linux-2.6.21.1/net/netlink: built-in.o
Only in linux-2.6.21.1/net/netlink: genetlink.o
Only in linux-2.6.21.1/net: nonet.o
Only in linux-2.6.21.1/net/packet: .af_packet.ko.cmd
Only in linux-2.6.21.1/net/packet: .af_packet.mod.o.cmd
Only in linux-2.6.21.1/net/packet: .af_packet.o.cmd
Only in linux-2.6.21.1/net/packet: .built-in.o.cmd
Only in linux-2.6.21.1/net/packet: af_packet.ko
Only in linux-2.6.21.1/net/packet: af_packet.mod.c
Only in linux-2.6.21.1/net/packet: af_packet.mod.o
Only in linux-2.6.21.1/net/packet: af_packet.o
Only in linux-2.6.21.1/net/packet: built-in.o
Only in linux-2.6.21.1/net/sched: .built-in.o.cmd
Only in linux-2.6.21.1/net/sched: .sch_generic.o.cmd
Only in linux-2.6.21.1/net/sched: built-in.o
Only in linux-2.6.21.1/net/sched: sch_generic.o
Only in linux-2.6.21.1/net: socket.o
Only in linux-2.6.21.1/net/unix: .af_unix.o.cmd
Only in linux-2.6.21.1/net/unix: .built-in.o.cmd
Only in linux-2.6.21.1/net/unix: .garbage.o.cmd
Only in linux-2.6.21.1/net/unix: .unix.ko.cmd
Only in linux-2.6.21.1/net/unix: .unix.mod.o.cmd
Only in linux-2.6.21.1/net/unix: .unix.o.cmd
Only in linux-2.6.21.1/net/unix: af_unix.o
Only in linux-2.6.21.1/net/unix: built-in.o
Only in linux-2.6.21.1/net/unix: garbage.o
Only in linux-2.6.21.1/net/unix: unix.ko
Only in linux-2.6.21.1/net/unix: unix.mod.c
Only in linux-2.6.21.1/net/unix: unix.mod.o
Only in linux-2.6.21.1/net/unix: unix.o
Only in linux-2.6.21.1/scripts: .conmakehash.cmd
Only in linux-2.6.21.1/scripts/basic: .docproc.cmd
Only in linux-2.6.21.1/scripts/basic: .fixdep.cmd
Only in linux-2.6.21.1/scripts/basic: docproc
Only in linux-2.6.21.1/scripts/basic: fixdep
Only in linux-2.6.21.1/scripts: bin2c
Only in linux-2.6.21.1/scripts: conmakehash
Only in linux-2.6.21.1/scripts: kallsyms
Only in linux-2.6.21.1/scripts/kconfig: .conf.cmd
Only in linux-2.6.21.1/scripts/kconfig: .conf.o.cmd
Only in linux-2.6.21.1/scripts/kconfig: .kxgettext.o.cmd
Only in linux-2.6.21.1/scripts/kconfig: .mconf.cmd
Only in linux-2.6.21.1/scripts/kconfig: .mconf.o.cmd
Only in linux-2.6.21.1/scripts/kconfig: .zconf.tab.o.cmd
Only in linux-2.6.21.1/scripts/kconfig: conf
Only in linux-2.6.21.1/scripts/kconfig: conf.o
Only in linux-2.6.21.1/scripts/kconfig: kxgettext.o
Only in linux-2.6.21.1/scripts/kconfig: lex.zconf.c
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: .checklist.o.cmd
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: .inputbox.o.cmd
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: .menubox.o.cmd
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: .textbox.o.cmd
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: .util.o.cmd
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: .yesno.o.cmd
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: checklist.o
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: inputbox.o
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: menubox.o
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: textbox.o
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: util.o
Only in linux-2.6.21.1/scripts/kconfig/lxdialog: yesno.o
Only in linux-2.6.21.1/scripts/kconfig: mconf.o
Only in linux-2.6.21.1/scripts/kconfig: zconf.hash.c
Only in linux-2.6.21.1/scripts/kconfig: zconf.tab.c
Only in linux-2.6.21.1/scripts/kconfig: zconf.tab.o
Only in linux-2.6.21.1/scripts/mod: .elfconfig.h.cmd
Only in linux-2.6.21.1/scripts/mod: .empty.o.cmd
Only in linux-2.6.21.1/scripts/mod: .file2alias.o.cmd
Only in linux-2.6.21.1/scripts/mod: .mk_elfconfig.cmd
Only in linux-2.6.21.1/scripts/mod: .modpost.cmd
Only in linux-2.6.21.1/scripts/mod: .modpost.o.cmd
Only in linux-2.6.21.1/scripts/mod: .sumversion.o.cmd
Only in linux-2.6.21.1/scripts/mod: elfconfig.h
Only in linux-2.6.21.1/scripts/mod: empty.o
Only in linux-2.6.21.1/scripts/mod: file2alias.o
Only in linux-2.6.21.1/scripts/mod: mk_elfconfig
Only in linux-2.6.21.1/scripts/mod: modpost
Only in linux-2.6.21.1/scripts/mod: modpost.o
Only in linux-2.6.21.1/scripts/mod: sumversion.o
Only in linux-2.6.21.1/security: .built-in.o.cmd
Only in linux-2.6.21.1/security: .commoncap.o.cmd
Only in linux-2.6.21.1/security: built-in.o
Only in linux-2.6.21.1/security: commoncap.o
Only in linux-2.6.21.1/sound: .built-in.o.cmd
Only in linux-2.6.21.1/sound: .sound_core.o.cmd
Only in linux-2.6.21.1/sound: .sound_firmware.ko.cmd
Only in linux-2.6.21.1/sound: .sound_firmware.mod.o.cmd
Only in linux-2.6.21.1/sound: .sound_firmware.o.cmd
Only in linux-2.6.21.1/sound: .soundcore.ko.cmd
Only in linux-2.6.21.1/sound: .soundcore.mod.o.cmd
Only in linux-2.6.21.1/sound: .soundcore.o.cmd
Only in linux-2.6.21.1/sound/arm: .built-in.o.cmd
Only in linux-2.6.21.1/sound/arm: built-in.o
Only in linux-2.6.21.1/sound: built-in.o
Only in linux-2.6.21.1/sound/core: .built-in.o.cmd
Only in linux-2.6.21.1/sound/core: .control.o.cmd
Only in linux-2.6.21.1/sound/core: .device.o.cmd
Only in linux-2.6.21.1/sound/core: .hwdep.o.cmd
Only in linux-2.6.21.1/sound/core: .info.o.cmd
Only in linux-2.6.21.1/sound/core: .info_oss.o.cmd
Only in linux-2.6.21.1/sound/core: .init.o.cmd
Only in linux-2.6.21.1/sound/core: .isadma.o.cmd
Only in linux-2.6.21.1/sound/core: .memalloc.o.cmd
Only in linux-2.6.21.1/sound/core: .memory.o.cmd
Only in linux-2.6.21.1/sound/core: .misc.o.cmd
Only in linux-2.6.21.1/sound/core: .pcm.o.cmd
Only in linux-2.6.21.1/sound/core: .pcm_lib.o.cmd
Only in linux-2.6.21.1/sound/core: .pcm_memory.o.cmd
Only in linux-2.6.21.1/sound/core: .pcm_misc.o.cmd
Only in linux-2.6.21.1/sound/core: .pcm_native.o.cmd
Only in linux-2.6.21.1/sound/core: .pcm_timer.o.cmd
Only in linux-2.6.21.1/sound/core: .rawmidi.o.cmd
Only in linux-2.6.21.1/sound/core: .sgbuf.o.cmd
Only in linux-2.6.21.1/sound/core: .snd-hwdep.ko.cmd
Only in linux-2.6.21.1/sound/core: .snd-hwdep.mod.o.cmd
Only in linux-2.6.21.1/sound/core: .snd-hwdep.o.cmd
Only in linux-2.6.21.1/sound/core: .snd-page-alloc.ko.cmd
Only in linux-2.6.21.1/sound/core: .snd-page-alloc.mod.o.cmd
Only in linux-2.6.21.1/sound/core: .snd-page-alloc.o.cmd
Only in linux-2.6.21.1/sound/core: .snd-pcm.ko.cmd
Only in linux-2.6.21.1/sound/core: .snd-pcm.mod.o.cmd
Only in linux-2.6.21.1/sound/core: .snd-pcm.o.cmd
Only in linux-2.6.21.1/sound/core: .snd-rawmidi.ko.cmd
Only in linux-2.6.21.1/sound/core: .snd-rawmidi.mod.o.cmd
Only in linux-2.6.21.1/sound/core: .snd-rawmidi.o.cmd
Only in linux-2.6.21.1/sound/core: .snd-timer.ko.cmd
Only in linux-2.6.21.1/sound/core: .snd-timer.mod.o.cmd
Only in linux-2.6.21.1/sound/core: .snd-timer.o.cmd
Only in linux-2.6.21.1/sound/core: .snd.ko.cmd
Only in linux-2.6.21.1/sound/core: .snd.mod.o.cmd
Only in linux-2.6.21.1/sound/core: .snd.o.cmd
Only in linux-2.6.21.1/sound/core: .sound.o.cmd
Only in linux-2.6.21.1/sound/core: .sound_oss.o.cmd
Only in linux-2.6.21.1/sound/core: .timer.o.cmd
Only in linux-2.6.21.1/sound/core: built-in.o
Only in linux-2.6.21.1/sound/core: control.o
Only in linux-2.6.21.1/sound/core: device.o
Only in linux-2.6.21.1/sound/core: hwdep.o
Only in linux-2.6.21.1/sound/core: info.o
Only in linux-2.6.21.1/sound/core: info_oss.o
Only in linux-2.6.21.1/sound/core: init.o
Only in linux-2.6.21.1/sound/core: isadma.o
Only in linux-2.6.21.1/sound/core: memalloc.o
Only in linux-2.6.21.1/sound/core: memory.o
Only in linux-2.6.21.1/sound/core: misc.o
Only in linux-2.6.21.1/sound/core/oss: .built-in.o.cmd
Only in linux-2.6.21.1/sound/core/oss: .copy.o.cmd
Only in linux-2.6.21.1/sound/core/oss: .io.o.cmd
Only in linux-2.6.21.1/sound/core/oss: .linear.o.cmd
Only in linux-2.6.21.1/sound/core/oss: .mulaw.o.cmd
Only in linux-2.6.21.1/sound/core/oss: .pcm_oss.o.cmd
Only in linux-2.6.21.1/sound/core/oss: .pcm_plugin.o.cmd
Only in linux-2.6.21.1/sound/core/oss: .rate.o.cmd
Only in linux-2.6.21.1/sound/core/oss: .route.o.cmd
Only in linux-2.6.21.1/sound/core/oss: .snd-pcm-oss.ko.cmd
Only in linux-2.6.21.1/sound/core/oss: .snd-pcm-oss.mod.o.cmd
Only in linux-2.6.21.1/sound/core/oss: .snd-pcm-oss.o.cmd
Only in linux-2.6.21.1/sound/core/oss: built-in.o
Only in linux-2.6.21.1/sound/core/oss: copy.o
Only in linux-2.6.21.1/sound/core/oss: io.o
Only in linux-2.6.21.1/sound/core/oss: linear.o
Only in linux-2.6.21.1/sound/core/oss: mulaw.o
Only in linux-2.6.21.1/sound/core/oss: pcm_oss.o
Only in linux-2.6.21.1/sound/core/oss: pcm_plugin.o
Only in linux-2.6.21.1/sound/core/oss: rate.o
Only in linux-2.6.21.1/sound/core/oss: route.o
Only in linux-2.6.21.1/sound/core/oss: snd-pcm-oss.ko
Only in linux-2.6.21.1/sound/core/oss: snd-pcm-oss.mod.c
Only in linux-2.6.21.1/sound/core/oss: snd-pcm-oss.mod.o
Only in linux-2.6.21.1/sound/core/oss: snd-pcm-oss.o
Only in linux-2.6.21.1/sound/core: pcm.o
Only in linux-2.6.21.1/sound/core: pcm_lib.o
Only in linux-2.6.21.1/sound/core: pcm_memory.o
Only in linux-2.6.21.1/sound/core: pcm_misc.o
Only in linux-2.6.21.1/sound/core: pcm_native.o
Only in linux-2.6.21.1/sound/core: pcm_timer.o
Only in linux-2.6.21.1/sound/core: rawmidi.o
Only in linux-2.6.21.1/sound/core: sgbuf.o
Only in linux-2.6.21.1/sound/core: snd-hwdep.ko
Only in linux-2.6.21.1/sound/core: snd-hwdep.mod.c
Only in linux-2.6.21.1/sound/core: snd-hwdep.mod.o
Only in linux-2.6.21.1/sound/core: snd-hwdep.o
Only in linux-2.6.21.1/sound/core: snd-page-alloc.ko
Only in linux-2.6.21.1/sound/core: snd-page-alloc.mod.c
Only in linux-2.6.21.1/sound/core: snd-page-alloc.mod.o
Only in linux-2.6.21.1/sound/core: snd-page-alloc.o
Only in linux-2.6.21.1/sound/core: snd-pcm.ko
Only in linux-2.6.21.1/sound/core: snd-pcm.mod.c
Only in linux-2.6.21.1/sound/core: snd-pcm.mod.o
Only in linux-2.6.21.1/sound/core: snd-pcm.o
Only in linux-2.6.21.1/sound/core: snd-rawmidi.ko
Only in linux-2.6.21.1/sound/core: snd-rawmidi.mod.c
Only in linux-2.6.21.1/sound/core: snd-rawmidi.mod.o
Only in linux-2.6.21.1/sound/core: snd-rawmidi.o
Only in linux-2.6.21.1/sound/core: snd-timer.ko
Only in linux-2.6.21.1/sound/core: snd-timer.mod.c
Only in linux-2.6.21.1/sound/core: snd-timer.mod.o
Only in linux-2.6.21.1/sound/core: snd-timer.o
Only in linux-2.6.21.1/sound/core: snd.ko
Only in linux-2.6.21.1/sound/core: snd.mod.c
Only in linux-2.6.21.1/sound/core: snd.mod.o
Only in linux-2.6.21.1/sound/core: snd.o
Only in linux-2.6.21.1/sound/core: sound.o
Only in linux-2.6.21.1/sound/core: sound_oss.o
Only in linux-2.6.21.1/sound/core: timer.o
Only in linux-2.6.21.1/sound/drivers: .built-in.o.cmd
Only in linux-2.6.21.1/sound/drivers: built-in.o
Only in linux-2.6.21.1/sound/drivers/mpu401: .built-in.o.cmd
Only in linux-2.6.21.1/sound/drivers/mpu401: .mpu401.o.cmd
Only in linux-2.6.21.1/sound/drivers/mpu401: .mpu401_uart.o.cmd
Only in linux-2.6.21.1/sound/drivers/mpu401: .snd-mpu401-uart.ko.cmd
Only in linux-2.6.21.1/sound/drivers/mpu401: .snd-mpu401-uart.mod.o.cmd
Only in linux-2.6.21.1/sound/drivers/mpu401: .snd-mpu401-uart.o.cmd
Only in linux-2.6.21.1/sound/drivers/mpu401: .snd-mpu401.ko.cmd
Only in linux-2.6.21.1/sound/drivers/mpu401: .snd-mpu401.mod.o.cmd
Only in linux-2.6.21.1/sound/drivers/mpu401: .snd-mpu401.o.cmd
Only in linux-2.6.21.1/sound/drivers/mpu401: built-in.o
Only in linux-2.6.21.1/sound/drivers/mpu401: mpu401.o
Only in linux-2.6.21.1/sound/drivers/mpu401: mpu401_uart.o
Only in linux-2.6.21.1/sound/drivers/mpu401: snd-mpu401-uart.ko
Only in linux-2.6.21.1/sound/drivers/mpu401: snd-mpu401-uart.mod.c
Only in linux-2.6.21.1/sound/drivers/mpu401: snd-mpu401-uart.mod.o
Only in linux-2.6.21.1/sound/drivers/mpu401: snd-mpu401-uart.o
Only in linux-2.6.21.1/sound/drivers/mpu401: snd-mpu401.ko
Only in linux-2.6.21.1/sound/drivers/mpu401: snd-mpu401.mod.c
Only in linux-2.6.21.1/sound/drivers/mpu401: snd-mpu401.mod.o
Only in linux-2.6.21.1/sound/drivers/mpu401: snd-mpu401.o
Only in linux-2.6.21.1/sound/drivers/opl3: .built-in.o.cmd
Only in linux-2.6.21.1/sound/drivers/opl3: .opl3_lib.o.cmd
Only in linux-2.6.21.1/sound/drivers/opl3: .opl3_synth.o.cmd
Only in linux-2.6.21.1/sound/drivers/opl3: .snd-opl3-lib.ko.cmd
Only in linux-2.6.21.1/sound/drivers/opl3: .snd-opl3-lib.mod.o.cmd
Only in linux-2.6.21.1/sound/drivers/opl3: .snd-opl3-lib.o.cmd
Only in linux-2.6.21.1/sound/drivers/opl3: built-in.o
Only in linux-2.6.21.1/sound/drivers/opl3: opl3_lib.o
Only in linux-2.6.21.1/sound/drivers/opl3: opl3_synth.o
Only in linux-2.6.21.1/sound/drivers/opl3: snd-opl3-lib.ko
Only in linux-2.6.21.1/sound/drivers/opl3: snd-opl3-lib.mod.c
Only in linux-2.6.21.1/sound/drivers/opl3: snd-opl3-lib.mod.o
Only in linux-2.6.21.1/sound/drivers/opl3: snd-opl3-lib.o
Only in linux-2.6.21.1/sound/drivers/opl4: .built-in.o.cmd
Only in linux-2.6.21.1/sound/drivers/opl4: .opl4_lib.o.cmd
Only in linux-2.6.21.1/sound/drivers/opl4: .opl4_mixer.o.cmd
Only in linux-2.6.21.1/sound/drivers/opl4: .opl4_proc.o.cmd
Only in linux-2.6.21.1/sound/drivers/opl4: .snd-opl4-lib.ko.cmd
Only in linux-2.6.21.1/sound/drivers/opl4: .snd-opl4-lib.mod.o.cmd
Only in linux-2.6.21.1/sound/drivers/opl4: .snd-opl4-lib.o.cmd
Only in linux-2.6.21.1/sound/drivers/opl4: built-in.o
Only in linux-2.6.21.1/sound/drivers/opl4: opl4_lib.o
Only in linux-2.6.21.1/sound/drivers/opl4: opl4_mixer.o
Only in linux-2.6.21.1/sound/drivers/opl4: opl4_proc.o
Only in linux-2.6.21.1/sound/drivers/opl4: snd-opl4-lib.ko
Only in linux-2.6.21.1/sound/drivers/opl4: snd-opl4-lib.mod.c
Only in linux-2.6.21.1/sound/drivers/opl4: snd-opl4-lib.mod.o
Only in linux-2.6.21.1/sound/drivers/opl4: snd-opl4-lib.o
Only in linux-2.6.21.1/sound/drivers/vx: .built-in.o.cmd
Only in linux-2.6.21.1/sound/drivers/vx: built-in.o
Only in linux-2.6.21.1/sound/i2c: .built-in.o.cmd
Only in linux-2.6.21.1/sound/i2c: built-in.o
Only in linux-2.6.21.1/sound/i2c/other: .built-in.o.cmd
Only in linux-2.6.21.1/sound/i2c/other: built-in.o
Only in linux-2.6.21.1/sound/isa: .adlib.o.cmd
Only in linux-2.6.21.1/sound/isa: .built-in.o.cmd
Only in linux-2.6.21.1/sound/isa: .cmi8330.o.cmd
Only in linux-2.6.21.1/sound/isa: .es18xx.o.cmd
Only in linux-2.6.21.1/sound/isa: .sgalaxy.o.cmd
Only in linux-2.6.21.1/sound/isa: .snd-adlib.ko.cmd
Only in linux-2.6.21.1/sound/isa: .snd-adlib.mod.o.cmd
Only in linux-2.6.21.1/sound/isa: .snd-adlib.o.cmd
Only in linux-2.6.21.1/sound/isa: .snd-cmi8330.ko.cmd
Only in linux-2.6.21.1/sound/isa: .snd-cmi8330.mod.o.cmd
Only in linux-2.6.21.1/sound/isa: .snd-cmi8330.o.cmd
Only in linux-2.6.21.1/sound/isa: .snd-es18xx.ko.cmd
Only in linux-2.6.21.1/sound/isa: .snd-es18xx.mod.o.cmd
Only in linux-2.6.21.1/sound/isa: .snd-es18xx.o.cmd
Only in linux-2.6.21.1/sound/isa: .snd-sgalaxy.ko.cmd
Only in linux-2.6.21.1/sound/isa: .snd-sgalaxy.mod.o.cmd
Only in linux-2.6.21.1/sound/isa: .snd-sgalaxy.o.cmd
Only in linux-2.6.21.1/sound/isa: .snd-sscape.ko.cmd
Only in linux-2.6.21.1/sound/isa: .snd-sscape.mod.o.cmd
Only in linux-2.6.21.1/sound/isa: .snd-sscape.o.cmd
Only in linux-2.6.21.1/sound/isa: .sscape.o.cmd
Only in linux-2.6.21.1/sound/isa/ad1816a: .built-in.o.cmd
Only in linux-2.6.21.1/sound/isa/ad1816a: built-in.o
Only in linux-2.6.21.1/sound/isa/ad1848: .ad1848.o.cmd
Only in linux-2.6.21.1/sound/isa/ad1848: .ad1848_lib.o.cmd
Only in linux-2.6.21.1/sound/isa/ad1848: .built-in.o.cmd
Only in linux-2.6.21.1/sound/isa/ad1848: .snd-ad1848-lib.ko.cmd
Only in linux-2.6.21.1/sound/isa/ad1848: .snd-ad1848-lib.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/ad1848: .snd-ad1848-lib.o.cmd
Only in linux-2.6.21.1/sound/isa/ad1848: .snd-ad1848.ko.cmd
Only in linux-2.6.21.1/sound/isa/ad1848: .snd-ad1848.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/ad1848: .snd-ad1848.o.cmd
Only in linux-2.6.21.1/sound/isa/ad1848: ad1848.o
Only in linux-2.6.21.1/sound/isa/ad1848: ad1848_lib.o
Only in linux-2.6.21.1/sound/isa/ad1848: built-in.o
Only in linux-2.6.21.1/sound/isa/ad1848: snd-ad1848-lib.ko
Only in linux-2.6.21.1/sound/isa/ad1848: snd-ad1848-lib.mod.c
Only in linux-2.6.21.1/sound/isa/ad1848: snd-ad1848-lib.mod.o
Only in linux-2.6.21.1/sound/isa/ad1848: snd-ad1848-lib.o
Only in linux-2.6.21.1/sound/isa/ad1848: snd-ad1848.ko
Only in linux-2.6.21.1/sound/isa/ad1848: snd-ad1848.mod.c
Only in linux-2.6.21.1/sound/isa/ad1848: snd-ad1848.mod.o
Only in linux-2.6.21.1/sound/isa/ad1848: snd-ad1848.o
Only in linux-2.6.21.1/sound/isa: adlib.o
Only in linux-2.6.21.1/sound/isa: built-in.o
Only in linux-2.6.21.1/sound/isa: cmi8330.o
Only in linux-2.6.21.1/sound/isa/cs423x: .built-in.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .cs4231.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .cs4231_lib.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .cs4232.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .cs4236.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .cs4236_lib.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4231-lib.ko.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4231-lib.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4231-lib.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4231.ko.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4231.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4231.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4232.ko.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4232.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4232.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4236-lib.ko.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4236-lib.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4236-lib.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4236.ko.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4236.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: .snd-cs4236.o.cmd
Only in linux-2.6.21.1/sound/isa/cs423x: built-in.o
Only in linux-2.6.21.1/sound/isa/cs423x: cs4231.o
Only in linux-2.6.21.1/sound/isa/cs423x: cs4231_lib.o
Only in linux-2.6.21.1/sound/isa/cs423x: cs4232.o
Only in linux-2.6.21.1/sound/isa/cs423x: cs4236.o
Only in linux-2.6.21.1/sound/isa/cs423x: cs4236_lib.o
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4231-lib.ko
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4231-lib.mod.c
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4231-lib.mod.o
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4231-lib.o
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4231.ko
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4231.mod.c
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4231.mod.o
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4231.o
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4232.ko
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4232.mod.c
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4232.mod.o
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4232.o
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4236-lib.ko
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4236-lib.mod.c
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4236-lib.mod.o
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4236-lib.o
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4236.ko
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4236.mod.c
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4236.mod.o
Only in linux-2.6.21.1/sound/isa/cs423x: snd-cs4236.o
Only in linux-2.6.21.1/sound/isa/es1688: .built-in.o.cmd
Only in linux-2.6.21.1/sound/isa/es1688: .es1688.o.cmd
Only in linux-2.6.21.1/sound/isa/es1688: .es1688_lib.o.cmd
Only in linux-2.6.21.1/sound/isa/es1688: .snd-es1688-lib.ko.cmd
Only in linux-2.6.21.1/sound/isa/es1688: .snd-es1688-lib.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/es1688: .snd-es1688-lib.o.cmd
Only in linux-2.6.21.1/sound/isa/es1688: .snd-es1688.ko.cmd
Only in linux-2.6.21.1/sound/isa/es1688: .snd-es1688.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/es1688: .snd-es1688.o.cmd
Only in linux-2.6.21.1/sound/isa/es1688: built-in.o
Only in linux-2.6.21.1/sound/isa/es1688: es1688.o
Only in linux-2.6.21.1/sound/isa/es1688: es1688_lib.o
Only in linux-2.6.21.1/sound/isa/es1688: snd-es1688-lib.ko
Only in linux-2.6.21.1/sound/isa/es1688: snd-es1688-lib.mod.c
Only in linux-2.6.21.1/sound/isa/es1688: snd-es1688-lib.mod.o
Only in linux-2.6.21.1/sound/isa/es1688: snd-es1688-lib.o
Only in linux-2.6.21.1/sound/isa/es1688: snd-es1688.ko
Only in linux-2.6.21.1/sound/isa/es1688: snd-es1688.mod.c
Only in linux-2.6.21.1/sound/isa/es1688: snd-es1688.mod.o
Only in linux-2.6.21.1/sound/isa/es1688: snd-es1688.o
Only in linux-2.6.21.1/sound/isa: es18xx.o
Only in linux-2.6.21.1/sound/isa/gus: .built-in.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_dma.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_dram.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_io.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_irq.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_main.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_mem.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_mem_proc.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_mixer.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_pcm.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_reset.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_timer.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_uart.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gus_volume.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gusclassic.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gusextreme.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .gusmax.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gus-lib.ko.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gus-lib.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gus-lib.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gusclassic.ko.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gusclassic.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gusclassic.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gusextreme.ko.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gusextreme.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gusextreme.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gusmax.ko.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gusmax.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: .snd-gusmax.o.cmd
Only in linux-2.6.21.1/sound/isa/gus: built-in.o
Only in linux-2.6.21.1/sound/isa/gus: gus_dma.o
Only in linux-2.6.21.1/sound/isa/gus: gus_dram.o
Only in linux-2.6.21.1/sound/isa/gus: gus_io.o
Only in linux-2.6.21.1/sound/isa/gus: gus_irq.o
Only in linux-2.6.21.1/sound/isa/gus: gus_main.o
Only in linux-2.6.21.1/sound/isa/gus: gus_mem.o
Only in linux-2.6.21.1/sound/isa/gus: gus_mem_proc.o
Only in linux-2.6.21.1/sound/isa/gus: gus_mixer.o
Only in linux-2.6.21.1/sound/isa/gus: gus_pcm.o
Only in linux-2.6.21.1/sound/isa/gus: gus_reset.o
Only in linux-2.6.21.1/sound/isa/gus: gus_timer.o
Only in linux-2.6.21.1/sound/isa/gus: gus_uart.o
Only in linux-2.6.21.1/sound/isa/gus: gus_volume.o
Only in linux-2.6.21.1/sound/isa/gus: gusclassic.o
Only in linux-2.6.21.1/sound/isa/gus: gusextreme.o
Only in linux-2.6.21.1/sound/isa/gus: gusmax.o
Only in linux-2.6.21.1/sound/isa/gus: snd-gus-lib.ko
Only in linux-2.6.21.1/sound/isa/gus: snd-gus-lib.mod.c
Only in linux-2.6.21.1/sound/isa/gus: snd-gus-lib.mod.o
Only in linux-2.6.21.1/sound/isa/gus: snd-gus-lib.o
Only in linux-2.6.21.1/sound/isa/gus: snd-gusclassic.ko
Only in linux-2.6.21.1/sound/isa/gus: snd-gusclassic.mod.c
Only in linux-2.6.21.1/sound/isa/gus: snd-gusclassic.mod.o
Only in linux-2.6.21.1/sound/isa/gus: snd-gusclassic.o
Only in linux-2.6.21.1/sound/isa/gus: snd-gusextreme.ko
Only in linux-2.6.21.1/sound/isa/gus: snd-gusextreme.mod.c
Only in linux-2.6.21.1/sound/isa/gus: snd-gusextreme.mod.o
Only in linux-2.6.21.1/sound/isa/gus: snd-gusextreme.o
Only in linux-2.6.21.1/sound/isa/gus: snd-gusmax.ko
Only in linux-2.6.21.1/sound/isa/gus: snd-gusmax.mod.c
Only in linux-2.6.21.1/sound/isa/gus: snd-gusmax.mod.o
Only in linux-2.6.21.1/sound/isa/gus: snd-gusmax.o
Only in linux-2.6.21.1/sound/isa/opti9xx: .built-in.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .miro.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .opti92x-ad1848.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .opti92x-cs4231.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .opti93x.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-miro.ko.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-miro.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-miro.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-opti92x-ad1848.ko.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-opti92x-ad1848.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-opti92x-ad1848.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-opti92x-cs4231.ko.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-opti92x-cs4231.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-opti92x-cs4231.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-opti93x.ko.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-opti93x.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: .snd-opti93x.o.cmd
Only in linux-2.6.21.1/sound/isa/opti9xx: built-in.o
Only in linux-2.6.21.1/sound/isa/opti9xx: miro.o
Only in linux-2.6.21.1/sound/isa/opti9xx: opti92x-ad1848.o
Only in linux-2.6.21.1/sound/isa/opti9xx: opti92x-cs4231.o
Only in linux-2.6.21.1/sound/isa/opti9xx: opti93x.o
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-miro.ko
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-miro.mod.c
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-miro.mod.o
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-miro.o
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti92x-ad1848.ko
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti92x-ad1848.mod.c
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti92x-ad1848.mod.o
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti92x-ad1848.o
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti92x-cs4231.ko
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti92x-cs4231.mod.c
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti92x-cs4231.mod.o
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti92x-cs4231.o
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti93x.ko
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti93x.mod.c
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti93x.mod.o
Only in linux-2.6.21.1/sound/isa/opti9xx: snd-opti93x.o
Only in linux-2.6.21.1/sound/isa/sb: .built-in.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .emu8000.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .sb16.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .sb16_csp.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .sb16_main.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .sb8.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .sb8_main.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .sb8_midi.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .sb_common.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .sb_mixer.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .sbawe.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb-common.ko.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb-common.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb-common.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb16-csp.ko.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb16-csp.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb16-csp.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb16-dsp.ko.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb16-dsp.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb16-dsp.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb16.ko.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb16.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb16.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb8-dsp.ko.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb8-dsp.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb8-dsp.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb8.ko.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb8.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sb8.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sbawe.ko.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sbawe.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: .snd-sbawe.o.cmd
Only in linux-2.6.21.1/sound/isa/sb: built-in.o
Only in linux-2.6.21.1/sound/isa/sb: emu8000.o
Only in linux-2.6.21.1/sound/isa/sb: sb16.o
Only in linux-2.6.21.1/sound/isa/sb: sb16_csp.o
Only in linux-2.6.21.1/sound/isa/sb: sb16_main.o
Only in linux-2.6.21.1/sound/isa/sb: sb8.o
Only in linux-2.6.21.1/sound/isa/sb: sb8_main.o
Only in linux-2.6.21.1/sound/isa/sb: sb8_midi.o
Only in linux-2.6.21.1/sound/isa/sb: sb_common.o
Only in linux-2.6.21.1/sound/isa/sb: sb_mixer.o
Only in linux-2.6.21.1/sound/isa/sb: sbawe.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb-common.ko
Only in linux-2.6.21.1/sound/isa/sb: snd-sb-common.mod.c
Only in linux-2.6.21.1/sound/isa/sb: snd-sb-common.mod.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb-common.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16-csp.ko
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16-csp.mod.c
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16-csp.mod.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16-csp.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16-dsp.ko
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16-dsp.mod.c
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16-dsp.mod.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16-dsp.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16.ko
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16.mod.c
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16.mod.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb16.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb8-dsp.ko
Only in linux-2.6.21.1/sound/isa/sb: snd-sb8-dsp.mod.c
Only in linux-2.6.21.1/sound/isa/sb: snd-sb8-dsp.mod.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb8-dsp.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb8.ko
Only in linux-2.6.21.1/sound/isa/sb: snd-sb8.mod.c
Only in linux-2.6.21.1/sound/isa/sb: snd-sb8.mod.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sb8.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sbawe.ko
Only in linux-2.6.21.1/sound/isa/sb: snd-sbawe.mod.c
Only in linux-2.6.21.1/sound/isa/sb: snd-sbawe.mod.o
Only in linux-2.6.21.1/sound/isa/sb: snd-sbawe.o
Only in linux-2.6.21.1/sound/isa: sgalaxy.o
Only in linux-2.6.21.1/sound/isa: snd-adlib.ko
Only in linux-2.6.21.1/sound/isa: snd-adlib.mod.c
Only in linux-2.6.21.1/sound/isa: snd-adlib.mod.o
Only in linux-2.6.21.1/sound/isa: snd-adlib.o
Only in linux-2.6.21.1/sound/isa: snd-cmi8330.ko
Only in linux-2.6.21.1/sound/isa: snd-cmi8330.mod.c
Only in linux-2.6.21.1/sound/isa: snd-cmi8330.mod.o
Only in linux-2.6.21.1/sound/isa: snd-cmi8330.o
Only in linux-2.6.21.1/sound/isa: snd-es18xx.ko
Only in linux-2.6.21.1/sound/isa: snd-es18xx.mod.c
Only in linux-2.6.21.1/sound/isa: snd-es18xx.mod.o
Only in linux-2.6.21.1/sound/isa: snd-es18xx.o
Only in linux-2.6.21.1/sound/isa: snd-sgalaxy.ko
Only in linux-2.6.21.1/sound/isa: snd-sgalaxy.mod.c
Only in linux-2.6.21.1/sound/isa: snd-sgalaxy.mod.o
Only in linux-2.6.21.1/sound/isa: snd-sgalaxy.o
Only in linux-2.6.21.1/sound/isa: snd-sscape.ko
Only in linux-2.6.21.1/sound/isa: snd-sscape.mod.c
Only in linux-2.6.21.1/sound/isa: snd-sscape.mod.o
Only in linux-2.6.21.1/sound/isa: snd-sscape.o
Only in linux-2.6.21.1/sound/isa: sscape.o
Only in linux-2.6.21.1/sound/isa/wavefront: .built-in.o.cmd
Only in linux-2.6.21.1/sound/isa/wavefront: .snd-wavefront.ko.cmd
Only in linux-2.6.21.1/sound/isa/wavefront: .snd-wavefront.mod.o.cmd
Only in linux-2.6.21.1/sound/isa/wavefront: .snd-wavefront.o.cmd
Only in linux-2.6.21.1/sound/isa/wavefront: .wavefront.o.cmd
Only in linux-2.6.21.1/sound/isa/wavefront: .wavefront_fx.o.cmd
Only in linux-2.6.21.1/sound/isa/wavefront: .wavefront_midi.o.cmd
Only in linux-2.6.21.1/sound/isa/wavefront: .wavefront_synth.o.cmd
Only in linux-2.6.21.1/sound/isa/wavefront: built-in.o
Only in linux-2.6.21.1/sound/isa/wavefront: snd-wavefront.ko
Only in linux-2.6.21.1/sound/isa/wavefront: snd-wavefront.mod.c
Only in linux-2.6.21.1/sound/isa/wavefront: snd-wavefront.mod.o
Only in linux-2.6.21.1/sound/isa/wavefront: snd-wavefront.o
Only in linux-2.6.21.1/sound/isa/wavefront: wavefront.o
Only in linux-2.6.21.1/sound/isa/wavefront: wavefront_fx.o
Only in linux-2.6.21.1/sound/isa/wavefront: wavefront_midi.o
Only in linux-2.6.21.1/sound/isa/wavefront: wavefront_synth.o
Only in linux-2.6.21.1/sound/mips: .built-in.o.cmd
Only in linux-2.6.21.1/sound/mips: built-in.o
Only in linux-2.6.21.1/sound/oss: .ad1848.ko.cmd
Only in linux-2.6.21.1/sound/oss: .ad1848.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .ad1848.o.cmd
Only in linux-2.6.21.1/sound/oss: .aedsp16.ko.cmd
Only in linux-2.6.21.1/sound/oss: .aedsp16.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .aedsp16.o.cmd
Only in linux-2.6.21.1/sound/oss: .audio.o.cmd
Only in linux-2.6.21.1/sound/oss: .built-in.o.cmd
Only in linux-2.6.21.1/sound/oss: .cs4232.ko.cmd
Only in linux-2.6.21.1/sound/oss: .cs4232.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .cs4232.o.cmd
Only in linux-2.6.21.1/sound/oss: .dev_table.o.cmd
Only in linux-2.6.21.1/sound/oss: .dmabuf.o.cmd
Only in linux-2.6.21.1/sound/oss: .midi_synth.o.cmd
Only in linux-2.6.21.1/sound/oss: .midibuf.o.cmd
Only in linux-2.6.21.1/sound/oss: .mpu401.ko.cmd
Only in linux-2.6.21.1/sound/oss: .mpu401.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .mpu401.o.cmd
Only in linux-2.6.21.1/sound/oss: .msnd.ko.cmd
Only in linux-2.6.21.1/sound/oss: .msnd.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .msnd.o.cmd
Only in linux-2.6.21.1/sound/oss: .msnd_classic.ko.cmd
Only in linux-2.6.21.1/sound/oss: .msnd_classic.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .msnd_classic.o.cmd
Only in linux-2.6.21.1/sound/oss: .msnd_pinnacle.ko.cmd
Only in linux-2.6.21.1/sound/oss: .msnd_pinnacle.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .msnd_pinnacle.o.cmd
Only in linux-2.6.21.1/sound/oss: .opl3.ko.cmd
Only in linux-2.6.21.1/sound/oss: .opl3.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .opl3.o.cmd
Only in linux-2.6.21.1/sound/oss: .pas2.ko.cmd
Only in linux-2.6.21.1/sound/oss: .pas2.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .pas2.o.cmd
Only in linux-2.6.21.1/sound/oss: .pas2_card.o.cmd
Only in linux-2.6.21.1/sound/oss: .pas2_midi.o.cmd
Only in linux-2.6.21.1/sound/oss: .pas2_mixer.o.cmd
Only in linux-2.6.21.1/sound/oss: .pas2_pcm.o.cmd
Only in linux-2.6.21.1/sound/oss: .pss.ko.cmd
Only in linux-2.6.21.1/sound/oss: .pss.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .pss.o.cmd
Only in linux-2.6.21.1/sound/oss: .sb.ko.cmd
Only in linux-2.6.21.1/sound/oss: .sb.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .sb.o.cmd
Only in linux-2.6.21.1/sound/oss: .sb_audio.o.cmd
Only in linux-2.6.21.1/sound/oss: .sb_card.o.cmd
Only in linux-2.6.21.1/sound/oss: .sb_common.o.cmd
Only in linux-2.6.21.1/sound/oss: .sb_ess.o.cmd
Only in linux-2.6.21.1/sound/oss: .sb_lib.ko.cmd
Only in linux-2.6.21.1/sound/oss: .sb_lib.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .sb_lib.o.cmd
Only in linux-2.6.21.1/sound/oss: .sb_midi.o.cmd
Only in linux-2.6.21.1/sound/oss: .sb_mixer.o.cmd
Only in linux-2.6.21.1/sound/oss: .sequencer.o.cmd
Only in linux-2.6.21.1/sound/oss: .sound.ko.cmd
Only in linux-2.6.21.1/sound/oss: .sound.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .sound.o.cmd
Only in linux-2.6.21.1/sound/oss: .sound_timer.o.cmd
Only in linux-2.6.21.1/sound/oss: .soundcard.o.cmd
Only in linux-2.6.21.1/sound/oss: .sscape.ko.cmd
Only in linux-2.6.21.1/sound/oss: .sscape.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .sscape.o.cmd
Only in linux-2.6.21.1/sound/oss: .sys_timer.o.cmd
Only in linux-2.6.21.1/sound/oss: .trix.ko.cmd
Only in linux-2.6.21.1/sound/oss: .trix.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .trix.o.cmd
Only in linux-2.6.21.1/sound/oss: .uart401.ko.cmd
Only in linux-2.6.21.1/sound/oss: .uart401.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .uart401.o.cmd
Only in linux-2.6.21.1/sound/oss: .uart6850.ko.cmd
Only in linux-2.6.21.1/sound/oss: .uart6850.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .uart6850.o.cmd
Only in linux-2.6.21.1/sound/oss: .v_midi.ko.cmd
Only in linux-2.6.21.1/sound/oss: .v_midi.mod.o.cmd
Only in linux-2.6.21.1/sound/oss: .v_midi.o.cmd
Only in linux-2.6.21.1/sound/oss: ad1848.ko
Only in linux-2.6.21.1/sound/oss: ad1848.mod.c
Only in linux-2.6.21.1/sound/oss: ad1848.mod.o
Only in linux-2.6.21.1/sound/oss: ad1848.o
Only in linux-2.6.21.1/sound/oss: aedsp16.ko
Only in linux-2.6.21.1/sound/oss: aedsp16.mod.c
Only in linux-2.6.21.1/sound/oss: aedsp16.mod.o
Only in linux-2.6.21.1/sound/oss: aedsp16.o
Only in linux-2.6.21.1/sound/oss: audio.o
Only in linux-2.6.21.1/sound/oss: built-in.o
Only in linux-2.6.21.1/sound/oss: cs4232.ko
Only in linux-2.6.21.1/sound/oss: cs4232.mod.c
Only in linux-2.6.21.1/sound/oss: cs4232.mod.o
Only in linux-2.6.21.1/sound/oss: cs4232.o
Only in linux-2.6.21.1/sound/oss: dev_table.o
Only in linux-2.6.21.1/sound/oss: dmabuf.o
Only in linux-2.6.21.1/sound/oss: midi_synth.o
Only in linux-2.6.21.1/sound/oss: midibuf.o
Only in linux-2.6.21.1/sound/oss: mpu401.ko
Only in linux-2.6.21.1/sound/oss: mpu401.mod.c
Only in linux-2.6.21.1/sound/oss: mpu401.mod.o
Only in linux-2.6.21.1/sound/oss: mpu401.o
Only in linux-2.6.21.1/sound/oss: msnd.ko
Only in linux-2.6.21.1/sound/oss: msnd.mod.c
Only in linux-2.6.21.1/sound/oss: msnd.mod.o
Only in linux-2.6.21.1/sound/oss: msnd.o
Only in linux-2.6.21.1/sound/oss: msnd_classic.ko
Only in linux-2.6.21.1/sound/oss: msnd_classic.mod.c
Only in linux-2.6.21.1/sound/oss: msnd_classic.mod.o
Only in linux-2.6.21.1/sound/oss: msnd_classic.o
Only in linux-2.6.21.1/sound/oss: msnd_pinnacle.ko
Only in linux-2.6.21.1/sound/oss: msnd_pinnacle.mod.c
Only in linux-2.6.21.1/sound/oss: msnd_pinnacle.mod.o
Only in linux-2.6.21.1/sound/oss: msnd_pinnacle.o
Only in linux-2.6.21.1/sound/oss: opl3.ko
Only in linux-2.6.21.1/sound/oss: opl3.mod.c
Only in linux-2.6.21.1/sound/oss: opl3.mod.o
Only in linux-2.6.21.1/sound/oss: opl3.o
Only in linux-2.6.21.1/sound/oss: pas2.ko
Only in linux-2.6.21.1/sound/oss: pas2.mod.c
Only in linux-2.6.21.1/sound/oss: pas2.mod.o
Only in linux-2.6.21.1/sound/oss: pas2.o
Only in linux-2.6.21.1/sound/oss: pas2_card.o
Only in linux-2.6.21.1/sound/oss: pas2_midi.o
Only in linux-2.6.21.1/sound/oss: pas2_mixer.o
Only in linux-2.6.21.1/sound/oss: pas2_pcm.o
Only in linux-2.6.21.1/sound/oss: pss.ko
Only in linux-2.6.21.1/sound/oss: pss.mod.c
Only in linux-2.6.21.1/sound/oss: pss.mod.o
Only in linux-2.6.21.1/sound/oss: pss.o
Only in linux-2.6.21.1/sound/oss: pss_boot.h
Only in linux-2.6.21.1/sound/oss: sb.ko
Only in linux-2.6.21.1/sound/oss: sb.mod.c
Only in linux-2.6.21.1/sound/oss: sb.mod.o
Only in linux-2.6.21.1/sound/oss: sb.o
Only in linux-2.6.21.1/sound/oss: sb_audio.o
Only in linux-2.6.21.1/sound/oss: sb_card.o
Only in linux-2.6.21.1/sound/oss: sb_common.o
Only in linux-2.6.21.1/sound/oss: sb_ess.o
Only in linux-2.6.21.1/sound/oss: sb_lib.ko
Only in linux-2.6.21.1/sound/oss: sb_lib.mod.c
Only in linux-2.6.21.1/sound/oss: sb_lib.mod.o
Only in linux-2.6.21.1/sound/oss: sb_lib.o
Only in linux-2.6.21.1/sound/oss: sb_midi.o
Only in linux-2.6.21.1/sound/oss: sb_mixer.o
Only in linux-2.6.21.1/sound/oss: sequencer.o
Only in linux-2.6.21.1/sound/oss: sound.ko
Only in linux-2.6.21.1/sound/oss: sound.mod.c
Only in linux-2.6.21.1/sound/oss: sound.mod.o
Only in linux-2.6.21.1/sound/oss: sound.o
Only in linux-2.6.21.1/sound/oss: sound_timer.o
Only in linux-2.6.21.1/sound/oss: soundcard.o
Only in linux-2.6.21.1/sound/oss: sscape.ko
Only in linux-2.6.21.1/sound/oss: sscape.mod.c
Only in linux-2.6.21.1/sound/oss: sscape.mod.o
Only in linux-2.6.21.1/sound/oss: sscape.o
Only in linux-2.6.21.1/sound/oss: sys_timer.o
Only in linux-2.6.21.1/sound/oss: trix.ko
Only in linux-2.6.21.1/sound/oss: trix.mod.c
Only in linux-2.6.21.1/sound/oss: trix.mod.o
Only in linux-2.6.21.1/sound/oss: trix.o
Only in linux-2.6.21.1/sound/oss: trix_boot.h
Only in linux-2.6.21.1/sound/oss: uart401.ko
Only in linux-2.6.21.1/sound/oss: uart401.mod.c
Only in linux-2.6.21.1/sound/oss: uart401.mod.o
Only in linux-2.6.21.1/sound/oss: uart401.o
Only in linux-2.6.21.1/sound/oss: uart6850.ko
Only in linux-2.6.21.1/sound/oss: uart6850.mod.c
Only in linux-2.6.21.1/sound/oss: uart6850.mod.o
Only in linux-2.6.21.1/sound/oss: uart6850.o
Only in linux-2.6.21.1/sound/oss: v_midi.ko
Only in linux-2.6.21.1/sound/oss: v_midi.mod.c
Only in linux-2.6.21.1/sound/oss: v_midi.mod.o
Only in linux-2.6.21.1/sound/oss: v_midi.o
Only in linux-2.6.21.1/sound/parisc: .built-in.o.cmd
Only in linux-2.6.21.1/sound/parisc: built-in.o
Only in linux-2.6.21.1/sound/pci: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/ac97: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/ac97: built-in.o
Only in linux-2.6.21.1/sound/pci/ali5451: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/ali5451: built-in.o
Only in linux-2.6.21.1/sound/pci/au88x0: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/au88x0: built-in.o
Only in linux-2.6.21.1/sound/pci: built-in.o
Only in linux-2.6.21.1/sound/pci/ca0106: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/ca0106: built-in.o
Only in linux-2.6.21.1/sound/pci/cs46xx: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/cs46xx: built-in.o
Only in linux-2.6.21.1/sound/pci/cs5535audio: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/cs5535audio: built-in.o
Only in linux-2.6.21.1/sound/pci/echoaudio: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/echoaudio: built-in.o
Only in linux-2.6.21.1/sound/pci/emu10k1: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/emu10k1: built-in.o
Only in linux-2.6.21.1/sound/pci/hda: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/hda: built-in.o
Only in linux-2.6.21.1/sound/pci/ice1712: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/ice1712: built-in.o
Only in linux-2.6.21.1/sound/pci/korg1212: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/korg1212: built-in.o
Only in linux-2.6.21.1/sound/pci/mixart: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/mixart: built-in.o
Only in linux-2.6.21.1/sound/pci/nm256: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/nm256: built-in.o
Only in linux-2.6.21.1/sound/pci/pcxhr: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/pcxhr: built-in.o
Only in linux-2.6.21.1/sound/pci/riptide: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/riptide: built-in.o
Only in linux-2.6.21.1/sound/pci/rme9652: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/rme9652: built-in.o
Only in linux-2.6.21.1/sound/pci/trident: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/trident: built-in.o
Only in linux-2.6.21.1/sound/pci/vx222: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/vx222: built-in.o
Only in linux-2.6.21.1/sound/pci/ymfpci: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pci/ymfpci: built-in.o
Only in linux-2.6.21.1/sound/pcmcia/pdaudiocf: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pcmcia/pdaudiocf: built-in.o
Only in linux-2.6.21.1/sound/pcmcia/vx: .built-in.o.cmd
Only in linux-2.6.21.1/sound/pcmcia/vx: built-in.o
Only in linux-2.6.21.1/sound/ppc: .built-in.o.cmd
Only in linux-2.6.21.1/sound/ppc: built-in.o
Only in linux-2.6.21.1/sound/soc: .built-in.o.cmd
Only in linux-2.6.21.1/sound/soc: built-in.o
Only in linux-2.6.21.1/sound: sound_core.o
Only in linux-2.6.21.1/sound: sound_firmware.ko
Only in linux-2.6.21.1/sound: sound_firmware.mod.c
Only in linux-2.6.21.1/sound: sound_firmware.mod.o
Only in linux-2.6.21.1/sound: sound_firmware.o
Only in linux-2.6.21.1/sound: soundcore.ko
Only in linux-2.6.21.1/sound: soundcore.mod.c
Only in linux-2.6.21.1/sound: soundcore.mod.o
Only in linux-2.6.21.1/sound: soundcore.o
Only in linux-2.6.21.1/sound/sparc: .built-in.o.cmd
Only in linux-2.6.21.1/sound/sparc: built-in.o
Only in linux-2.6.21.1/sound/synth: .built-in.o.cmd
Only in linux-2.6.21.1/sound/synth: built-in.o
Only in linux-2.6.21.1/sound/usb: .built-in.o.cmd
Only in linux-2.6.21.1/sound/usb: built-in.o
Only in linux-2.6.21.1/sound/usb/usx2y: .built-in.o.cmd
Only in linux-2.6.21.1/sound/usb/usx2y: built-in.o
Only in linux-2.6.21.1/usr: .built-in.o.cmd
Only in linux-2.6.21.1/usr: .gen_init_cpio.cmd
Only in linux-2.6.21.1/usr: .initramfs_data.cpio.gz.cmd
Only in linux-2.6.21.1/usr: .initramfs_data.cpio.gz.d
Only in linux-2.6.21.1/usr: .initramfs_data.o.cmd
Only in linux-2.6.21.1/usr: built-in.o
Only in linux-2.6.21.1/usr: gen_init_cpio
Only in linux-2.6.21.1/usr: initramfs_data.cpio.gz
Only in linux-2.6.21.1/usr: initramfs_data.o
Only in linux-2.6.21.1: vmlinux

--------------030109090009080104010309--
