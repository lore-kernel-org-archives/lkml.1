Return-Path: <linux-kernel-owner+w=401wt.eu-S964898AbXLRBqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898AbXLRBqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 20:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763470AbXLRBic
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 20:38:32 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38987 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763298AbXLRBi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 20:38:29 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       rusty@rustcorp.com.au, ak@suse.de, chrisw@sous-sol.org,
       rostedt@goodmis.org, hpa@zytor.com, zach@vmware.com, roland@redhat.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 17/21] [PATCH] move definitions to processor.h
Date: Mon, 17 Dec 2007 20:52:40 -0200
Message-Id: <1197932050948-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11979320451308-git-send-email-gcosta@redhat.com>
References: <11979319641796-git-send-email-gcosta@redhat.com> <1197931971748-git-send-email-gcosta@redhat.com> <11979319763641-git-send-email-gcosta@redhat.com> <11979319811234-git-send-email-gcosta@redhat.com> <11979319853319-git-send-email-gcosta@redhat.com> <11979319903443-git-send-email-gcosta@redhat.com> <11979319953427-git-send-email-gcosta@redhat.com> <11979320011968-git-send-email-gcosta@redhat.com> <1197932006634-git-send-email-gcosta@redhat.com> <11979320114180-git-send-email-gcosta@redhat.com> <11979320163651-git-send-email-gcosta@redhat.com> <11979320211287-git-send-email-gcosta@redhat.com> <11979320252102-git-send-email-gcosta@redhat.com> <11979320302030-git-send-email-gcosta@redhat.com> <11979320354186-git-send-email-gcosta@redhat.com> <11979320401316-git-send-email-gcosta@redhat.com> <11979320451308-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves definitions that are present in only one of the files
(between processor_32.h and processor_64.h), to processor.h. They're mostly
structures and function definitions.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 arch/x86/kernel/cpu/common.c   |    2 +-
 arch/x86/kernel/setup_64.c     |    2 +-
 include/asm-x86/processor.h    |   41 ++++++++++++++++++++++++++++++++++++++++
 include/asm-x86/processor_32.h |   35 ----------------------------------
 include/asm-x86/processor_64.h |    6 -----
 5 files changed, 43 insertions(+), 43 deletions(-)

Index: linux-2.6-x86/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6-x86/arch/x86/kernel/cpu/common.c
@@ -399,7 +399,7 @@ __setup("serialnumber", x86_serial_nr_se
 /*
  * This does the hard work of actually picking apart the CPU stuff...
  */
-static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
+void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 {
 	int i;
 
Index: linux-2.6-x86/arch/x86/kernel/setup_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/setup_64.c
+++ linux-2.6-x86/arch/x86/kernel/setup_64.c
@@ -768,7 +768,7 @@ static void __cpuinit init_amd(struct cp
 		disable_apic_timer = 1;
 }
 
-static void __cpuinit detect_ht(struct cpuinfo_x86 *c)
+void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 {
 #ifdef CONFIG_SMP
 	u32 eax, ebx, ecx, edx;
Index: linux-2.6-x86/include/asm-x86/processor.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor.h
+++ linux-2.6-x86/include/asm-x86/processor.h
@@ -92,7 +92,12 @@ struct cpuinfo_x86 {
 #define X86_VENDOR_NUM 9
 #define X86_VENDOR_UNKNOWN 0xff
 
+/*
+ * capabilities of CPUs
+ */
 extern struct cpuinfo_x86 boot_cpu_data;
+extern struct cpuinfo_x86 new_cpu_data;
+extern struct tss_struct doublefault_tss;
 
 #ifdef CONFIG_SMP
 DECLARE_PER_CPU(struct cpuinfo_x86, cpu_info);
@@ -103,11 +108,22 @@ DECLARE_PER_CPU(struct cpuinfo_x86, cpu_
 #define current_cpu_data	boot_cpu_data
 #endif
 
+void cpu_detect(struct cpuinfo_x86 *c);
+
+extern void identify_cpu(struct cpuinfo_x86 *);
+extern void identify_boot_cpu(void);
+extern void identify_secondary_cpu(struct cpuinfo_x86 *);
 extern void print_cpu_info(struct cpuinfo_x86 *);
 extern void init_scattered_cpuid_features(struct cpuinfo_x86 *c);
 extern unsigned int init_intel_cacheinfo(struct cpuinfo_x86 *c);
 extern unsigned short num_cache_leaves;
 
+#if defined(CONFIG_X86_HT) || defined(CONFIG_X86_64)
+extern void detect_ht(struct cpuinfo_x86 *c);
+#else
+static inline void detect_ht(struct cpuinfo_x86 *c) {}
+#endif
+
 static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
 					 unsigned int *ecx, unsigned int *edx)
 {
@@ -201,6 +217,11 @@ struct tss_struct {
 
 DECLARE_PER_CPU(struct tss_struct, init_tss);
 
+/* Save the original ist values for checking stack pointers during debugging */
+struct orig_ist {
+	unsigned long ist[7];
+};
+
 #ifdef CONFIG_X86_32
 # include "processor_32.h"
 #else
@@ -543,8 +564,28 @@ extern void select_idle_routine(const st
 
 extern unsigned long boot_option_idle_override;
 
+extern void enable_sep_cpu(void);
+extern int sysenter_setup(void);
+
+/* Defined in head.S */
+extern struct desc_ptr early_gdt_descr;
+
+extern void cpu_set_gdt(int);
+extern void switch_to_new_gdt(void);
+extern void cpu_init(void);
+extern void init_gdt(int cpu);
+
+/* from system description table in BIOS.  Mostly for MCA use, but
+ * others may find it useful. */
+extern unsigned int machine_id;
+extern unsigned int machine_submodel_id;
+extern unsigned int BIOS_revision;
+extern unsigned int mca_pentium_flag;
+
 /* Boot loader type from the setup header */
 extern int bootloader_type;
+
+extern char ignore_fpu_irq;
 #define cache_line_size() (boot_cpu_data.x86_cache_alignment)
 
 #define HAVE_ARCH_PICK_MMAP_LAYOUT 1
Index: linux-2.6-x86/include/asm-x86/processor_32.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_32.h
+++ linux-2.6-x86/include/asm-x86/processor_32.h
@@ -18,36 +18,12 @@
 #include <linux/init.h>
 #include <asm/desc_defs.h>
 
-/*
- * capabilities of CPUs
- */
-extern struct cpuinfo_x86 new_cpu_data;
-extern struct tss_struct doublefault_tss;
 
 /*
  * the following now lives in the per cpu area:
  * extern	int cpu_llc_id[NR_CPUS];
  */
 DECLARE_PER_CPU(u8, cpu_llc_id);
-extern char ignore_fpu_irq;
-
-void __init cpu_detect(struct cpuinfo_x86 *c);
-
-extern void identify_boot_cpu(void);
-extern void identify_secondary_cpu(struct cpuinfo_x86 *);
-
-#ifdef CONFIG_X86_HT
-extern void detect_ht(struct cpuinfo_x86 *c);
-#else
-static inline void detect_ht(struct cpuinfo_x86 *c) {}
-#endif
-
-/* from system description table in BIOS.  Mostly for MCA use, but
-others may find it useful. */
-extern unsigned int machine_id;
-extern unsigned int machine_submodel_id;
-extern unsigned int BIOS_revision;
-extern unsigned int mca_pentium_flag;
 
 /*
  * User space process size: 3GB (default).
@@ -277,15 +253,4 @@ static inline void prefetchw(const void 
 			  "r" (x));
 }
 
-extern void enable_sep_cpu(void);
-extern int sysenter_setup(void);
-
-/* Defined in head.S */
-extern struct desc_ptr early_gdt_descr;
-
-extern void cpu_set_gdt(int);
-extern void switch_to_new_gdt(void);
-extern void cpu_init(void);
-extern void init_gdt(int cpu);
-
 #endif /* __ASM_I386_PROCESSOR_H */
Index: linux-2.6-x86/include/asm-x86/processor_64.h
===================================================================
--- linux-2.6-x86.orig/include/asm-x86/processor_64.h
+++ linux-2.6-x86/include/asm-x86/processor_64.h
@@ -17,8 +17,6 @@
 #include <linux/personality.h>
 #include <asm/desc_defs.h>
 
-extern void identify_cpu(struct cpuinfo_x86 *);
-
 /*
  * User space process size. 47bits minus one guard page.
  */
@@ -51,10 +49,6 @@ union i387_union {
 	struct i387_fxsave_struct	fxsave;
 };
 
-/* Save the original ist values for checking stack pointers during debugging */
-struct orig_ist {
-	unsigned long ist[7];
-};
 DECLARE_PER_CPU(struct orig_ist, orig_ist);
 
 #define INIT_THREAD  { \
