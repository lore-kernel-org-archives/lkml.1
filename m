Return-Path: <linux-kernel-owner+w=401wt.eu-S936732AbXG2VWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936732AbXG2VWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 17:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935983AbXG2VWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 17:22:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49392 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935451AbXG2VV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 17:21:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] Replace CONFIG_SOFTWARE_SUSPEND with CONFIG_HIBERNATION (updated)
Date: Sun, 29 Jul 2007 23:24:36 +0200
User-Agent: KMail/1.9.5
Cc: Len Brown <lenb@kernel.org>, david@lang.hm,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
       Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <200707251238.50218.lenb@kernel.org> <200707291220.14880.rjw@sisk.pl> <200707292323.29601.rjw@sisk.pl>
In-Reply-To: <200707292323.29601.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707292324.37553.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Replace CONFIG_SOFTWARE_SUSPEND with CONFIG_HIBERNATION to avoid confusion
(among other things, with CONFIG_SUSPEND introduced in the next patch).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 arch/i386/Kconfig.debug                 |    4 ++--
 arch/i386/kernel/e820.c                 |    2 +-
 arch/i386/mm/init.c                     |    2 +-
 arch/i386/power/Makefile                |    2 +-
 arch/powerpc/Kconfig.debug              |    2 +-
 arch/powerpc/configs/lite5200_defconfig |    2 +-
 arch/powerpc/configs/pmac32_defconfig   |    2 +-
 arch/powerpc/kernel/Makefile            |    6 +++---
 arch/ppc/configs/TQM8540_defconfig      |    2 +-
 arch/ppc/configs/TQM8541_defconfig      |    2 +-
 arch/ppc/configs/TQM8555_defconfig      |    2 +-
 arch/ppc/configs/TQM8560_defconfig      |    2 +-
 arch/ppc/configs/ev64360_defconfig      |    2 +-
 arch/ppc/configs/ml300_defconfig        |    2 +-
 arch/ppc/configs/ml403_defconfig        |    2 +-
 arch/ppc/configs/mpc834x_sys_defconfig  |    2 +-
 arch/ppc/configs/prep_defconfig         |    2 +-
 arch/sparc64/Kconfig.debug              |    2 +-
 arch/x86_64/defconfig                   |    2 +-
 arch/x86_64/kernel/Makefile             |    2 +-
 arch/x86_64/kernel/suspend.c            |    4 ++--
 drivers/acpi/sleep/main.c               |    6 +++---
 drivers/acpi/sleep/proc.c               |    2 +-
 drivers/i2c/chips/tps65010.c            |    2 +-
 include/asm-i386/e820.h                 |    2 +-
 include/linux/suspend.h                 |    8 ++++----
 kernel/power/Kconfig                    |    6 +++---
 kernel/power/Makefile                   |    2 +-
 kernel/power/main.c                     |    2 +-
 kernel/power/power.h                    |    2 +-
 kernel/sys.c                            |    2 +-
 mm/Kconfig                              |    4 ++--
 mm/swapfile.c                           |    6 +++---
 33 files changed, 47 insertions(+), 47 deletions(-)

Index: linux-2.6/arch/i386/Kconfig.debug
===================================================================
--- linux-2.6.orig/arch/i386/Kconfig.debug	2007-05-10 21:34:50.000000000 +0200
+++ linux-2.6/arch/i386/Kconfig.debug	2007-07-29 18:49:05.000000000 +0200
@@ -36,11 +36,11 @@ config DEBUG_STACK_USAGE
 	  This option will slow down process creation somewhat.
 
 comment "Page alloc debug is incompatible with Software Suspend on i386"
-	depends on DEBUG_KERNEL && SOFTWARE_SUSPEND
+	depends on DEBUG_KERNEL && HIBERNATION
 
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL && !SOFTWARE_SUSPEND && !HUGETLBFS
+	depends on DEBUG_KERNEL && !HIBERNATION && !HUGETLBFS
 	help
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
Index: linux-2.6/arch/i386/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/i386/kernel/e820.c	2007-07-27 21:34:36.000000000 +0200
+++ linux-2.6/arch/i386/kernel/e820.c	2007-07-29 18:49:05.000000000 +0200
@@ -321,7 +321,7 @@ static int __init request_standard_resou
 
 subsys_initcall(request_standard_resources);
 
-#if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
+#if defined(CONFIG_PM) && defined(CONFIG_HIBERNATION)
 /**
  * e820_mark_nosave_regions - Find the ranges of physical addresses that do not
  * correspond to e820 RAM areas and mark the corresponding pages as nosave for
Index: linux-2.6/arch/i386/mm/init.c
===================================================================
--- linux-2.6.orig/arch/i386/mm/init.c	2007-07-27 21:34:36.000000000 +0200
+++ linux-2.6/arch/i386/mm/init.c	2007-07-29 18:49:05.000000000 +0200
@@ -432,7 +432,7 @@ static void __init pagetable_init (void)
 	paravirt_pagetable_setup_done(pgd_base);
 }
 
-#if defined(CONFIG_SOFTWARE_SUSPEND) || defined(CONFIG_ACPI)
+#if defined(CONFIG_HIBERNATION) || defined(CONFIG_ACPI)
 /*
  * Swap suspend & friends need this for resume because things like the intel-agp
  * driver might have split up a kernel 4MB mapping.
Index: linux-2.6/arch/i386/power/Makefile
===================================================================
--- linux-2.6.orig/arch/i386/power/Makefile	2007-05-10 21:34:50.000000000 +0200
+++ linux-2.6/arch/i386/power/Makefile	2007-07-29 18:49:05.000000000 +0200
@@ -1,2 +1,2 @@
 obj-$(CONFIG_PM)		+= cpu.o
-obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o suspend.o
+obj-$(CONFIG_HIBERNATION)	+= swsusp.o suspend.o
Index: linux-2.6/arch/powerpc/Kconfig.debug
===================================================================
--- linux-2.6.orig/arch/powerpc/Kconfig.debug	2007-07-27 21:34:36.000000000 +0200
+++ linux-2.6/arch/powerpc/Kconfig.debug	2007-07-29 18:49:05.000000000 +0200
@@ -20,7 +20,7 @@ config DEBUG_STACK_USAGE
 
 config DEBUG_PAGEALLOC
         bool "Debug page memory allocations"
-        depends on DEBUG_KERNEL && !SOFTWARE_SUSPEND
+        depends on DEBUG_KERNEL && !HIBERNATION
         help
           Unmap pages from the kernel linear mapping after free_pages().
           This results in a large slowdown, but helps to find certain types
Index: linux-2.6/arch/powerpc/configs/lite5200_defconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/configs/lite5200_defconfig	2007-06-27 23:17:46.000000000 +0200
+++ linux-2.6/arch/powerpc/configs/lite5200_defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -196,7 +196,7 @@ CONFIG_PM=y
 # CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
 # CONFIG_PM_SYSFS_DEPRECATED is not set
-# CONFIG_SOFTWARE_SUSPEND is not set
+# CONFIG_HIBERNATION is not set
 CONFIG_SECCOMP=y
 # CONFIG_WANT_DEVICE_TREE is not set
 CONFIG_ISA_DMA_API=y
Index: linux-2.6/arch/powerpc/configs/pmac32_defconfig
===================================================================
--- linux-2.6.orig/arch/powerpc/configs/pmac32_defconfig	2007-06-27 23:17:46.000000000 +0200
+++ linux-2.6/arch/powerpc/configs/pmac32_defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -218,7 +218,7 @@ CONFIG_PM=y
 CONFIG_PM_DEBUG=y
 # CONFIG_DISABLE_CONSOLE_SUSPEND is not set
 CONFIG_PM_SYSFS_DEPRECATED=y
-CONFIG_SOFTWARE_SUSPEND=y
+CONFIG_HIBERNATION=y
 CONFIG_PM_STD_PARTITION=""
 CONFIG_APM_EMULATION=y
 CONFIG_SECCOMP=y
Index: linux-2.6/arch/powerpc/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/Makefile	2007-07-18 22:37:31.000000000 +0200
+++ linux-2.6/arch/powerpc/kernel/Makefile	2007-07-29 18:49:05.000000000 +0200
@@ -37,9 +37,9 @@ obj-$(CONFIG_GENERIC_TBSYNC)	+= smp-tbsy
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_6xx)		+= idle_6xx.o l2cr_6xx.o cpu_setup_6xx.o
 obj-$(CONFIG_TAU)		+= tau_6xx.o
-obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o suspend.o
-obj32-$(CONFIG_SOFTWARE_SUSPEND) += swsusp_32.o
-obj64-$(CONFIG_SOFTWARE_SUSPEND) += swsusp_64.o swsusp_asm64.o
+obj-$(CONFIG_HIBERNATION)	+= swsusp.o suspend.o
+obj32-$(CONFIG_HIBERNATION) += swsusp_32.o
+obj64-$(CONFIG_HIBERNATION) += swsusp_64.o swsusp_asm64.o
 obj32-$(CONFIG_MODULES)		+= module_32.o
 
 ifeq ($(CONFIG_PPC_MERGE),y)
Index: linux-2.6/arch/ppc/configs/TQM8540_defconfig
===================================================================
--- linux-2.6.orig/arch/ppc/configs/TQM8540_defconfig	2007-05-10 21:34:51.000000000 +0200
+++ linux-2.6/arch/ppc/configs/TQM8540_defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -136,7 +136,7 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 # CONFIG_CMDLINE_BOOL is not set
 # CONFIG_PM is not set
-# CONFIG_SOFTWARE_SUSPEND is not set
+# CONFIG_HIBERNATION is not set
 CONFIG_SECCOMP=y
 CONFIG_ISA_DMA_API=y
 
Index: linux-2.6/arch/ppc/configs/TQM8541_defconfig
===================================================================
--- linux-2.6.orig/arch/ppc/configs/TQM8541_defconfig	2007-05-10 21:34:51.000000000 +0200
+++ linux-2.6/arch/ppc/configs/TQM8541_defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -138,7 +138,7 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 # CONFIG_CMDLINE_BOOL is not set
 # CONFIG_PM is not set
-# CONFIG_SOFTWARE_SUSPEND is not set
+# CONFIG_HIBERNATION is not set
 CONFIG_SECCOMP=y
 CONFIG_ISA_DMA_API=y
 
Index: linux-2.6/arch/ppc/configs/TQM8555_defconfig
===================================================================
--- linux-2.6.orig/arch/ppc/configs/TQM8555_defconfig	2007-05-10 21:34:51.000000000 +0200
+++ linux-2.6/arch/ppc/configs/TQM8555_defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -138,7 +138,7 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 # CONFIG_CMDLINE_BOOL is not set
 # CONFIG_PM is not set
-# CONFIG_SOFTWARE_SUSPEND is not set
+# CONFIG_HIBERNATION is not set
 CONFIG_SECCOMP=y
 CONFIG_ISA_DMA_API=y
 
Index: linux-2.6/arch/ppc/configs/TQM8560_defconfig
===================================================================
--- linux-2.6.orig/arch/ppc/configs/TQM8560_defconfig	2007-05-10 21:34:51.000000000 +0200
+++ linux-2.6/arch/ppc/configs/TQM8560_defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -137,7 +137,7 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 # CONFIG_CMDLINE_BOOL is not set
 # CONFIG_PM is not set
-# CONFIG_SOFTWARE_SUSPEND is not set
+# CONFIG_HIBERNATION is not set
 CONFIG_SECCOMP=y
 CONFIG_ISA_DMA_API=y
 
Index: linux-2.6/arch/ppc/configs/ev64360_defconfig
===================================================================
--- linux-2.6.orig/arch/ppc/configs/ev64360_defconfig	2007-05-10 21:34:51.000000000 +0200
+++ linux-2.6/arch/ppc/configs/ev64360_defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -142,7 +142,7 @@ CONFIG_BINFMT_MISC=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyMM0,115200 root=/dev/mtdblock1 rw rootfstype=jffs2"
 # CONFIG_PM is not set
-# CONFIG_SOFTWARE_SUSPEND is not set
+# CONFIG_HIBERNATION is not set
 CONFIG_SECCOMP=y
 CONFIG_ISA_DMA_API=y
 
Index: linux-2.6/arch/ppc/configs/ml300_defconfig
===================================================================
--- linux-2.6.orig/arch/ppc/configs/ml300_defconfig	2007-05-10 21:34:51.000000000 +0200
+++ linux-2.6/arch/ppc/configs/ml300_defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -148,7 +148,7 @@ CONFIG_BINFMT_ELF=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyS0,9600"
 # CONFIG_PM is not set
-# CONFIG_SOFTWARE_SUSPEND is not set
+# CONFIG_HIBERNATION is not set
 CONFIG_SECCOMP=y
 CONFIG_ISA_DMA_API=y
 
Index: linux-2.6/arch/ppc/configs/ml403_defconfig
===================================================================
--- linux-2.6.orig/arch/ppc/configs/ml403_defconfig	2007-05-10 21:34:51.000000000 +0200
+++ linux-2.6/arch/ppc/configs/ml403_defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -149,7 +149,7 @@ CONFIG_BINFMT_ELF=y
 CONFIG_CMDLINE_BOOL=y
 CONFIG_CMDLINE="console=ttyS0,9600"
 # CONFIG_PM is not set
-# CONFIG_SOFTWARE_SUSPEND is not set
+# CONFIG_HIBERNATION is not set
 CONFIG_SECCOMP=y
 CONFIG_ISA_DMA_API=y
 
Index: linux-2.6/arch/ppc/configs/mpc834x_sys_defconfig
===================================================================
--- linux-2.6.orig/arch/ppc/configs/mpc834x_sys_defconfig	2007-05-10 21:34:51.000000000 +0200
+++ linux-2.6/arch/ppc/configs/mpc834x_sys_defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -130,7 +130,7 @@ CONFIG_BINFMT_ELF=y
 # CONFIG_BINFMT_MISC is not set
 # CONFIG_CMDLINE_BOOL is not set
 # CONFIG_PM is not set
-# CONFIG_SOFTWARE_SUSPEND is not set
+# CONFIG_HIBERNATION is not set
 CONFIG_SECCOMP=y
 CONFIG_ISA_DMA_API=y
 
Index: linux-2.6/arch/ppc/configs/prep_defconfig
===================================================================
--- linux-2.6.orig/arch/ppc/configs/prep_defconfig	2007-05-10 21:34:51.000000000 +0200
+++ linux-2.6/arch/ppc/configs/prep_defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -166,7 +166,7 @@ CONFIG_PROC_PREPRESIDUAL=y
 CONFIG_PM=y
 # CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
-CONFIG_SOFTWARE_SUSPEND=y
+CONFIG_HIBERNATION=y
 CONFIG_PM_STD_PARTITION=""
 # CONFIG_SECCOMP is not set
 CONFIG_ISA_DMA_API=y
Index: linux-2.6/arch/sparc64/Kconfig.debug
===================================================================
--- linux-2.6.orig/arch/sparc64/Kconfig.debug	2007-05-10 21:34:52.000000000 +0200
+++ linux-2.6/arch/sparc64/Kconfig.debug	2007-07-29 18:49:05.000000000 +0200
@@ -29,7 +29,7 @@ config DEBUG_BOOTMEM
 
 config DEBUG_PAGEALLOC
 	bool "Debug page memory allocations"
-	depends on DEBUG_KERNEL && !SOFTWARE_SUSPEND
+	depends on DEBUG_KERNEL && !HIBERNATION
 	help
 	  Unmap pages from the kernel linear mapping after free_pages().
 	  This results in a large slowdown, but helps to find certain types
Index: linux-2.6/arch/x86_64/defconfig
===================================================================
--- linux-2.6.orig/arch/x86_64/defconfig	2007-07-27 21:34:37.000000000 +0200
+++ linux-2.6/arch/x86_64/defconfig	2007-07-29 18:49:05.000000000 +0200
@@ -199,7 +199,7 @@ CONFIG_GENERIC_PENDING_IRQ=y
 CONFIG_PM=y
 # CONFIG_PM_LEGACY is not set
 # CONFIG_PM_DEBUG is not set
-CONFIG_SOFTWARE_SUSPEND=y
+CONFIG_HIBERNATION=y
 CONFIG_PM_STD_PARTITION=""
 CONFIG_SUSPEND_SMP=y
 
Index: linux-2.6/arch/x86_64/kernel/Makefile
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/Makefile	2007-07-12 23:57:06.000000000 +0200
+++ linux-2.6/arch/x86_64/kernel/Makefile	2007-07-29 18:49:05.000000000 +0200
@@ -26,7 +26,7 @@ obj-y				+= io_apic.o mpparse.o genapic.
 obj-$(CONFIG_KEXEC)		+= machine_kexec.o relocate_kernel.o crash.o
 obj-$(CONFIG_CRASH_DUMP)	+= crash_dump.o
 obj-$(CONFIG_PM)		+= suspend.o
-obj-$(CONFIG_SOFTWARE_SUSPEND)	+= suspend_asm.o
+obj-$(CONFIG_HIBERNATION)	+= suspend_asm.o
 obj-$(CONFIG_CPU_FREQ)		+= cpufreq/
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_IOMMU)		+= pci-gart.o aperture.o
Index: linux-2.6/arch/x86_64/kernel/suspend.c
===================================================================
--- linux-2.6.orig/arch/x86_64/kernel/suspend.c	2007-07-27 21:34:37.000000000 +0200
+++ linux-2.6/arch/x86_64/kernel/suspend.c	2007-07-29 18:49:05.000000000 +0200
@@ -146,7 +146,7 @@ void fix_processor_context(void)
 
 }
 
-#ifdef CONFIG_SOFTWARE_SUSPEND
+#ifdef CONFIG_HIBERNATION
 /* Defined in arch/x86_64/kernel/suspend_asm.S */
 extern int restore_image(void);
 
@@ -236,4 +236,4 @@ int pfn_is_nosave(unsigned long pfn)
 	unsigned long nosave_end_pfn = PAGE_ALIGN(__pa_symbol(&__nosave_end)) >> PAGE_SHIFT;
 	return (pfn >= nosave_begin_pfn) && (pfn < nosave_end_pfn);
 }
-#endif /* CONFIG_SOFTWARE_SUSPEND */
+#endif /* CONFIG_HIBERNATION */
Index: linux-2.6/drivers/acpi/sleep/main.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/main.c	2007-07-27 21:34:37.000000000 +0200
+++ linux-2.6/drivers/acpi/sleep/main.c	2007-07-29 18:49:06.000000000 +0200
@@ -202,7 +202,7 @@ static struct pm_ops acpi_pm_ops = {
 	.finish = acpi_pm_finish,
 };
 
-#ifdef CONFIG_SOFTWARE_SUSPEND
+#ifdef CONFIG_HIBERNATION
 static int acpi_hibernation_prepare(void)
 {
 	return acpi_sleep_prepare(ACPI_STATE_S4);
@@ -254,7 +254,7 @@ static struct hibernation_ops acpi_hiber
 	.pre_restore = acpi_hibernation_pre_restore,
 	.restore_cleanup = acpi_hibernation_restore_cleanup,
 };
-#endif				/* CONFIG_SOFTWARE_SUSPEND */
+#endif				/* CONFIG_HIBERNATION */
 
 /**
  *	acpi_pm_device_sleep_state - return preferred power state of ACPI device
@@ -374,7 +374,7 @@ int __init acpi_sleep_init(void)
 
 	pm_set_ops(&acpi_pm_ops);
 
-#ifdef CONFIG_SOFTWARE_SUSPEND
+#ifdef CONFIG_HIBERNATION
 	if (sleep_states[ACPI_STATE_S4])
 		hibernation_set_ops(&acpi_hibernation_ops);
 #else
Index: linux-2.6/drivers/acpi/sleep/proc.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep/proc.c	2007-07-27 21:34:37.000000000 +0200
+++ linux-2.6/drivers/acpi/sleep/proc.c	2007-07-29 18:49:06.000000000 +0200
@@ -66,7 +66,7 @@ acpi_system_write_sleep(struct file *fil
 		goto Done;
 	}
 	state = simple_strtoul(str, NULL, 0);
-#ifdef CONFIG_SOFTWARE_SUSPEND
+#ifdef CONFIG_HIBERNATION
 	if (state == 4) {
 		error = hibernate();
 		goto Done;
Index: linux-2.6/drivers/i2c/chips/tps65010.c
===================================================================
--- linux-2.6.orig/drivers/i2c/chips/tps65010.c	2007-05-10 21:34:53.000000000 +0200
+++ linux-2.6/drivers/i2c/chips/tps65010.c	2007-07-29 18:49:06.000000000 +0200
@@ -352,7 +352,7 @@ static void tps65010_interrupt(struct tp
 			/* REVISIT:  this might need its own workqueue
 			 * plus tweaks including deadlock avoidance ...
 			 * also needs to get error handling and probably
-			 * an #ifdef CONFIG_SOFTWARE_SUSPEND
+			 * an #ifdef CONFIG_HIBERNATION
 			 */
 			hibernate();
 #endif
Index: linux-2.6/include/asm-i386/e820.h
===================================================================
--- linux-2.6.orig/include/asm-i386/e820.h	2007-07-27 21:34:41.000000000 +0200
+++ linux-2.6/include/asm-i386/e820.h	2007-07-29 18:49:06.000000000 +0200
@@ -47,7 +47,7 @@ extern void e820_register_memory(void);
 extern void limit_regions(unsigned long long size);
 extern void print_memory_map(char *who);
 
-#if defined(CONFIG_PM) && defined(CONFIG_SOFTWARE_SUSPEND)
+#if defined(CONFIG_PM) && defined(CONFIG_HIBERNATION)
 extern void e820_mark_nosave_regions(void);
 #else
 static inline void e820_mark_nosave_regions(void)
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h	2007-07-27 21:34:42.000000000 +0200
+++ linux-2.6/include/linux/suspend.h	2007-07-29 18:49:06.000000000 +0200
@@ -55,7 +55,7 @@ struct hibernation_ops {
 };
 
 #ifdef CONFIG_PM
-#ifdef CONFIG_SOFTWARE_SUSPEND
+#ifdef CONFIG_HIBERNATION
 /* kernel/power/snapshot.c */
 extern void __register_nosave_region(unsigned long b, unsigned long e, int km);
 static inline void register_nosave_region(unsigned long b, unsigned long e)
@@ -73,14 +73,14 @@ extern unsigned long get_safe_page(gfp_t
 
 extern void hibernation_set_ops(struct hibernation_ops *ops);
 extern int hibernate(void);
-#else /* CONFIG_SOFTWARE_SUSPEND */
+#else /* CONFIG_HIBERNATION */
 static inline int swsusp_page_is_forbidden(struct page *p) { return 0; }
 static inline void swsusp_set_page_free(struct page *p) {}
 static inline void swsusp_unset_page_free(struct page *p) {}
 
 static inline void hibernation_set_ops(struct hibernation_ops *ops) {}
 static inline int hibernate(void) { return -ENOSYS; }
-#endif /* CONFIG_SOFTWARE_SUSPEND */
+#endif /* CONFIG_HIBERNATION */
 
 void save_processor_state(void);
 void restore_processor_state(void);
@@ -121,7 +121,7 @@ static inline int unregister_pm_notifier
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 #endif /* CONFIG_PM */
 
-#if !defined CONFIG_SOFTWARE_SUSPEND || !defined(CONFIG_PM)
+#if !defined CONFIG_HIBERNATION || !defined(CONFIG_PM)
 static inline void register_nosave_region(unsigned long b, unsigned long e)
 {
 }
Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig	2007-07-27 21:34:42.000000000 +0200
+++ linux-2.6/kernel/power/Kconfig	2007-07-29 18:53:40.000000000 +0200
@@ -72,8 +72,8 @@ config PM_TRACE
 	CAUTION: this option will cause your machine's real-time clock to be
 	set to an invalid time after a resume.
 
-config SOFTWARE_SUSPEND
-	bool "Software Suspend (Hibernation)"
+config HIBERNATION
+	bool "Hibernation"
 	depends on PM && SWAP && (((X86 || PPC64_SWSUSP) && (!SMP || SUSPEND_SMP)) || ((FRV || PPC32) && !SMP))
 	---help---
 	  Enable the suspend to disk (STD) functionality, which is usually
@@ -112,7 +112,7 @@ config SOFTWARE_SUSPEND
 
 config PM_STD_PARTITION
 	string "Default resume partition"
-	depends on SOFTWARE_SUSPEND
+	depends on HIBERNATION
 	default ""
 	---help---
 	  The default resume partition is the partition that the suspend-
Index: linux-2.6/kernel/power/Makefile
===================================================================
--- linux-2.6.orig/kernel/power/Makefile	2007-05-13 14:43:17.000000000 +0200
+++ linux-2.6/kernel/power/Makefile	2007-07-29 18:49:06.000000000 +0200
@@ -5,6 +5,6 @@ endif
 
 obj-y				:= main.o process.o console.o
 obj-$(CONFIG_PM_LEGACY)		+= pm.o
-obj-$(CONFIG_SOFTWARE_SUSPEND)	+= swsusp.o disk.o snapshot.o swap.o user.o
+obj-$(CONFIG_HIBERNATION)	+= swsusp.o disk.o snapshot.o swap.o user.o
 
 obj-$(CONFIG_MAGIC_SYSRQ)	+= poweroff.o
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c	2007-07-20 21:51:36.000000000 +0200
+++ linux-2.6/kernel/power/main.c	2007-07-29 18:49:06.000000000 +0200
@@ -292,7 +292,7 @@ static ssize_t state_show(struct kset *k
 		if (pm_states[i] && valid_state(i))
 			s += sprintf(s,"%s ", pm_states[i]);
 	}
-#ifdef CONFIG_SOFTWARE_SUSPEND
+#ifdef CONFIG_HIBERNATION
 	s += sprintf(s, "%s\n", "disk");
 #else
 	if (s != buf)
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h	2007-07-20 21:51:36.000000000 +0200
+++ linux-2.6/kernel/power/power.h	2007-07-29 18:49:06.000000000 +0200
@@ -13,7 +13,7 @@ struct swsusp_info {
 
 
 
-#ifdef CONFIG_SOFTWARE_SUSPEND
+#ifdef CONFIG_HIBERNATION
 /*
  * Keep some memory free so that I/O operations can succeed without paging
  * [Might this be more than 4 MB?]
Index: linux-2.6/kernel/sys.c
===================================================================
--- linux-2.6.orig/kernel/sys.c	2007-07-27 21:34:42.000000000 +0200
+++ linux-2.6/kernel/sys.c	2007-07-29 18:49:06.000000000 +0200
@@ -954,7 +954,7 @@ asmlinkage long sys_reboot(int magic1, i
 		unlock_kernel();
 		return -EINVAL;
 
-#ifdef CONFIG_SOFTWARE_SUSPEND
+#ifdef CONFIG_HIBERNATION
 	case LINUX_REBOOT_CMD_SW_SUSPEND:
 		{
 			int ret = hibernate();
Index: linux-2.6/mm/Kconfig
===================================================================
--- linux-2.6.orig/mm/Kconfig	2007-07-18 22:37:43.000000000 +0200
+++ linux-2.6/mm/Kconfig	2007-07-29 18:49:06.000000000 +0200
@@ -116,11 +116,11 @@ config SPARSEMEM_EXTREME
 config MEMORY_HOTPLUG
 	bool "Allow for memory hot-add"
 	depends on SPARSEMEM || X86_64_ACPI_NUMA
-	depends on HOTPLUG && !SOFTWARE_SUSPEND && ARCH_ENABLE_MEMORY_HOTPLUG
+	depends on HOTPLUG && !HIBERNATION && ARCH_ENABLE_MEMORY_HOTPLUG
 	depends on (IA64 || X86 || PPC64 || SUPERH)
 
 comment "Memory hotplug is currently incompatible with Software Suspend"
-	depends on SPARSEMEM && HOTPLUG && SOFTWARE_SUSPEND
+	depends on SPARSEMEM && HOTPLUG && HIBERNATION
 
 config MEMORY_HOTPLUG_SPARSE
 	def_bool y
Index: linux-2.6/mm/swapfile.c
===================================================================
--- linux-2.6.orig/mm/swapfile.c	2007-07-18 22:37:43.000000000 +0200
+++ linux-2.6/mm/swapfile.c	2007-07-29 18:49:06.000000000 +0200
@@ -425,7 +425,7 @@ void free_swap_and_cache(swp_entry_t ent
 	}
 }
 
-#ifdef CONFIG_SOFTWARE_SUSPEND
+#ifdef CONFIG_HIBERNATION
 /*
  * Find the swap type that corresponds to given device (if any).
  *
@@ -951,7 +951,7 @@ sector_t map_swap_page(struct swap_info_
 	}
 }
 
-#ifdef CONFIG_SOFTWARE_SUSPEND
+#ifdef CONFIG_HIBERNATION
 /*
  * Get the (PAGE_SIZE) block corresponding to given offset on the swapdev
  * corresponding to given index in swap_info (swap type).
@@ -966,7 +966,7 @@ sector_t swapdev_block(int swap_type, pg
 	sis = swap_info + swap_type;
 	return (sis->flags & SWP_WRITEOK) ? map_swap_page(sis, offset) : 0;
 }
-#endif /* CONFIG_SOFTWARE_SUSPEND */
+#endif /* CONFIG_HIBERNATION */
 
 /*
  * Free all of a swapdev's extent information

