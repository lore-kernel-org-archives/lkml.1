Return-Path: <linux-kernel-owner+w=401wt.eu-S1755567AbYICGxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755567AbYICGxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 02:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYICGxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 02:53:16 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:52651 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbYICGxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 02:53:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TfqLUrxd/ua2eewt2d/RKt9oIBJ6Wh2Yv74A1poEfoHCrB8NKVkfARynnmz8DDFFN7
         OrP97QCDeyXZw5vat7MA62EgWbNZDcmHiRYsFL9lkj1S8nZczAIPyHYwOWn1Kklo56Ow
         v4iR4tqATzxVyzAGdqrHBJMVW10m9XIfZTNxA=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 2/5] x86: remove cpu_vendor_dev
Date: Tue,  2 Sep 2008 23:52:58 -0700
Message-Id: <1220424781-17752-2-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1220424781-17752-1-git-send-email-yhlu.kernel@gmail.com>
References: <1220424781-17752-1-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. add c_x86_vendor into cpu_dev
2. change cpu_devs to static
3. check c_x86_vendor before put that cpu_dev into array
4. remove alignment for 64bit
5. order the sequence in cpu_devs according to link sequence...
   so could put intel at first, then amd...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/cpu/Makefile     |    4 +-
 arch/x86/kernel/cpu/amd.c        |    3 +
 arch/x86/kernel/cpu/amd_64.c     |    4 +-
 arch/x86/kernel/cpu/centaur.c    |    3 +
 arch/x86/kernel/cpu/centaur_64.c |    3 +
 arch/x86/kernel/cpu/common.c     |   71 +++++++++++++++++++--------------------
 arch/x86/kernel/cpu/common_64.c  |   71 +++++++++++++++++++--------------------
 arch/x86/kernel/cpu/cpu.h        |   18 +++------
 arch/x86/kernel/cpu/cyrix.c      |    6 ++-
 arch/x86/kernel/cpu/intel.c      |    3 +
 arch/x86/kernel/cpu/intel_64.c   |    3 +
 arch/x86/kernel/cpu/transmeta.c  |    3 +
 arch/x86/kernel/cpu/umc.c        |    3 +
 arch/x86/kernel/vmlinux_32.lds.S |    8 ++--
 arch/x86/kernel/vmlinux_64.lds.S |    9 ++--
 15 files changed, 106 insertions(+), 106 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/amd.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd.c
+++ linux-2.6/arch/x86/kernel/cpu/amd.c
@@ -298,6 +298,7 @@ static struct cpu_dev amd_cpu_dev __cpui
 	.c_early_init   = early_init_amd,
 	.c_init		= init_amd,
 	.c_size_cache	= amd_size_cache,
+	.c_x86_vendor	= X86_VENDOR_AMD,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_AMD, &amd_cpu_dev);
+cpu_dev_register(amd_cpu_dev);
Index: linux-2.6/arch/x86/kernel/cpu/amd_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/amd_64.c
+++ linux-2.6/arch/x86/kernel/cpu/amd_64.c
@@ -218,7 +218,7 @@ static struct cpu_dev amd_cpu_dev __cpui
 	.c_ident	= { "AuthenticAMD" },
 	.c_early_init   = early_init_amd,
 	.c_init		= init_amd,
+	.c_x86_vendor	= X86_VENDOR_AMD,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_AMD, &amd_cpu_dev);
-
+cpu_dev_register(amd_cpu_dev);
Index: linux-2.6/arch/x86/kernel/cpu/centaur.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/centaur.c
+++ linux-2.6/arch/x86/kernel/cpu/centaur.c
@@ -475,6 +475,7 @@ static struct cpu_dev centaur_cpu_dev __
 	.c_early_init	= early_init_centaur,
 	.c_init		= init_centaur,
 	.c_size_cache	= centaur_size_cache,
+	.c_x86_vendor	= X86_VENDOR_CENTAUR,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_CENTAUR, &centaur_cpu_dev);
+cpu_dev_register(centaur_cpu_dev);
Index: linux-2.6/arch/x86/kernel/cpu/centaur_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/centaur_64.c
+++ linux-2.6/arch/x86/kernel/cpu/centaur_64.c
@@ -29,7 +29,8 @@ static struct cpu_dev centaur_cpu_dev __
 	.c_ident	= { "CentaurHauls" },
 	.c_early_init	= early_init_centaur,
 	.c_init		= init_centaur,
+	.c_x86_vendor	= X86_VENDOR_CENTAUR,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_CENTAUR, &centaur_cpu_dev);
+cpu_dev_register(centaur_cpu_dev);
 
Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -75,7 +75,7 @@ void switch_to_new_gdt(void)
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;
 
-struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
+static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
 
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
@@ -93,8 +93,9 @@ static void __cpuinit default_init(struc
 static struct cpu_dev __cpuinitdata default_cpu = {
 	.c_init	= default_init,
 	.c_vendor = "Unknown",
+	.c_x86_vendor = X86_VENDOR_UNKNOWN,
 };
-static struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
+static struct cpu_dev *this_cpu __cpuinitdata;
 
 static int __init cachesize_setup(char *str)
 {
@@ -250,21 +251,24 @@ static void __cpuinit get_cpu_vendor(str
 	static int printed;
 
 	for (i = 0; i < X86_VENDOR_NUM; i++) {
-		if (cpu_devs[i]) {
-			if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
-			    (cpu_devs[i]->c_ident[1] &&
-			     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
-				c->x86_vendor = i;
-				this_cpu = cpu_devs[i];
-				return;
-			}
+		if (!cpu_devs[i])
+			break;
+
+		if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
+		    (cpu_devs[i]->c_ident[1] &&
+		     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
+			this_cpu = cpu_devs[i];
+			c->x86_vendor = this_cpu->c_x86_vendor;
+			return;
 		}
 	}
+
 	if (!printed) {
 		printed++;
 		printk(KERN_ERR "CPU: Vendor unknown, using generic init.\n");
 		printk(KERN_ERR "CPU: Your system may be unstable.\n");
 	}
+
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	this_cpu = &default_cpu;
 }
@@ -315,25 +319,6 @@ static int __cpuinit have_cpuid_p(void)
 	return flag_is_changeable_p(X86_EFLAGS_ID);
 }
 
-static void __init early_cpu_support_print(void)
-{
-	int i,j;
-	struct cpu_dev *cpu_devx;
-
-	printk("KERNEL supported cpus:\n");
-	for (i = 0; i < X86_VENDOR_NUM; i++) {
-		cpu_devx = cpu_devs[i];
-		if (!cpu_devx)
-			continue;
-		for (j = 0; j < 2; j++) {
-			if (!cpu_devx->c_ident[j])
-				continue;
-			printk("  %s %s\n", cpu_devx->c_vendor,
-				cpu_devx->c_ident[j]);
-		}
-	}
-}
-
 void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
@@ -411,21 +396,35 @@ static void __init early_identify_cpu(st
 
 	get_cpu_cap(c);
 
-	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
-	    cpu_devs[c->x86_vendor]->c_early_init)
-		cpu_devs[c->x86_vendor]->c_early_init(c);
+	if (this_cpu->c_early_init)
+		this_cpu->c_early_init(c);
 
 	validate_pat_support(c);
 }
 
 void __init early_cpu_init(void)
 {
-	struct cpu_vendor_dev *cvdev;
+	struct cpu_dev **cdev;
+	int count = 0;
+
+	printk("KERNEL supported cpus:\n");
+	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
+		struct cpu_dev *cpudev = *cdev;
+		unsigned int j;
+
+		if (count >= X86_VENDOR_NUM)
+			break;
+		cpu_devs[count] = cpudev;
+		count++;
 
-	for (cvdev = __x86cpuvendor_start; cvdev < __x86cpuvendor_end; cvdev++)
-		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
+		for (j = 0; j < 2; j++) {
+			if (!cpudev->c_ident[j])
+				continue;
+			printk("  %s %s\n", cpudev->c_vendor,
+				cpudev->c_ident[j]);
+		}
+	}
 
-	early_cpu_support_print();
 	early_identify_cpu(&boot_cpu_data);
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/common_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common_64.c
+++ linux-2.6/arch/x86/kernel/cpu/common_64.c
@@ -66,7 +66,7 @@ void switch_to_new_gdt(void)
 	load_gdt(&gdt_descr);
 }
 
-struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
+static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
 
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
@@ -76,8 +76,9 @@ static void __cpuinit default_init(struc
 static struct cpu_dev __cpuinitdata default_cpu = {
 	.c_init	= default_init,
 	.c_vendor = "Unknown",
+	.c_x86_vendor = X86_VENDOR_UNKNOWN,
 };
-static struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
+static struct cpu_dev *this_cpu __cpuinitdata;
 
 int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 {
@@ -181,44 +182,28 @@ static void __cpuinit get_cpu_vendor(str
 	static int printed;
 
 	for (i = 0; i < X86_VENDOR_NUM; i++) {
-		if (cpu_devs[i]) {
-			if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
-			    (cpu_devs[i]->c_ident[1] &&
-			     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
-				c->x86_vendor = i;
-				this_cpu = cpu_devs[i];
-				return;
-			}
+		if (!cpu_devs[i])
+			break;
+
+		if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
+		    (cpu_devs[i]->c_ident[1] &&
+		     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
+			this_cpu = cpu_devs[i];
+			c->x86_vendor = this_cpu->c_x86_vendor;
+			return;
 		}
 	}
+
 	if (!printed) {
 		printed++;
 		printk(KERN_ERR "CPU: Vendor unknown, using generic init.\n");
 		printk(KERN_ERR "CPU: Your system may be unstable.\n");
 	}
+
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	this_cpu = &default_cpu;
 }
 
-static void __init early_cpu_support_print(void)
-{
-	int i,j;
-	struct cpu_dev *cpu_devx;
-
-	printk("KERNEL supported cpus:\n");
-	for (i = 0; i < X86_VENDOR_NUM; i++) {
-		cpu_devx = cpu_devs[i];
-		if (!cpu_devx)
-			continue;
-		for (j = 0; j < 2; j++) {
-			if (!cpu_devx->c_ident[j])
-				continue;
-			printk("  %s %s\n", cpu_devx->c_vendor,
-				cpu_devx->c_ident[j]);
-		}
-	}
-}
-
 void __cpuinit cpu_detect(struct cpuinfo_x86 *c)
 {
 	/* Get vendor name */
@@ -309,21 +294,35 @@ static void __init early_identify_cpu(st
 
 	get_cpu_cap(c);
 
-	if (c->x86_vendor != X86_VENDOR_UNKNOWN &&
-	    cpu_devs[c->x86_vendor]->c_early_init)
-		cpu_devs[c->x86_vendor]->c_early_init(c);
+	if (this_cpu->c_early_init)
+		this_cpu->c_early_init(c);
 
 	validate_pat_support(c);
 }
 
 void __init early_cpu_init(void)
 {
-	struct cpu_vendor_dev *cvdev;
+	struct cpu_dev **cdev;
+	int count = 0;
+
+	printk("KERNEL supported cpus:\n");
+	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
+		struct cpu_dev *cpudev = *cdev;
+		unsigned int j;
+
+		if (count >= X86_VENDOR_NUM)
+			break;
+		cpu_devs[count] = cpudev;
+		count++;
 
-	for (cvdev = __x86cpuvendor_start; cvdev < __x86cpuvendor_end; cvdev++)
-		cpu_devs[cvdev->vendor] = cvdev->cpu_dev;
+		for (j = 0; j < 2; j++) {
+			if (!cpudev->c_ident[j])
+				continue;
+			printk("  %s %s\n", cpudev->c_vendor,
+				cpudev->c_ident[j]);
+		}
+	}
 
-	early_cpu_support_print();
 	early_identify_cpu(&boot_cpu_data);
 }
 
Index: linux-2.6/arch/x86/kernel/cpu/cpu.h
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cpu.h
+++ linux-2.6/arch/x86/kernel/cpu/cpu.h
@@ -21,21 +21,15 @@ struct cpu_dev {
 	void		(*c_init)(struct cpuinfo_x86 * c);
 	void		(*c_identify)(struct cpuinfo_x86 * c);
 	unsigned int	(*c_size_cache)(struct cpuinfo_x86 * c, unsigned int size);
+	int	c_x86_vendor;
 };
 
-extern struct cpu_dev * cpu_devs [X86_VENDOR_NUM];
+#define cpu_dev_register(cpu_devX) \
+	static struct cpu_dev *__cpu_dev_##cpu_devX __used \
+	__attribute__((__section__(".x86_cpu_dev.init"))) = \
+	&cpu_devX;
 
-struct cpu_vendor_dev {
-	int vendor;
-	struct cpu_dev *cpu_dev;
-};
-
-#define cpu_vendor_dev_register(cpu_vendor_id, cpu_dev) \
-	static struct cpu_vendor_dev __cpu_vendor_dev_##cpu_vendor_id __used \
-	__attribute__((__section__(".x86cpuvendor.init"))) = \
-	{ cpu_vendor_id, cpu_dev }
-
-extern struct cpu_vendor_dev __x86cpuvendor_start[], __x86cpuvendor_end[];
+extern struct cpu_dev *__x86_cpu_dev_start[], *__x86_cpu_dev_end[];
 
 extern int get_model_name(struct cpuinfo_x86 *c);
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
Index: linux-2.6/arch/x86/kernel/cpu/cyrix.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/cyrix.c
+++ linux-2.6/arch/x86/kernel/cpu/cyrix.c
@@ -442,14 +442,16 @@ static struct cpu_dev cyrix_cpu_dev __cp
 	.c_early_init	= early_init_cyrix,
 	.c_init		= init_cyrix,
 	.c_identify	= cyrix_identify,
+	.c_x86_vendor	= X86_VENDOR_CYRIX,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_CYRIX, &cyrix_cpu_dev);
+cpu_dev_register(cyrix_cpu_dev);
 
 static struct cpu_dev nsc_cpu_dev __cpuinitdata = {
 	.c_vendor	= "NSC",
 	.c_ident	= { "Geode by NSC" },
 	.c_init		= init_nsc,
+	.c_x86_vendor	= X86_VENDOR_NSC,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_NSC, &nsc_cpu_dev);
+cpu_dev_register(nsc_cpu_dev);
Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6/arch/x86/kernel/cpu/intel.c
@@ -311,9 +311,10 @@ static struct cpu_dev intel_cpu_dev __cp
 	.c_early_init   = early_init_intel,
 	.c_init		= init_intel,
 	.c_size_cache	= intel_size_cache,
+	.c_x86_vendor	= X86_VENDOR_INTEL,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_INTEL, &intel_cpu_dev);
+cpu_dev_register(intel_cpu_dev);
 
 /* arch_initcall(intel_cpu_init); */
 
Index: linux-2.6/arch/x86/kernel/cpu/intel_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel_64.c
+++ linux-2.6/arch/x86/kernel/cpu/intel_64.c
@@ -93,6 +93,7 @@ static struct cpu_dev intel_cpu_dev __cp
 	.c_ident	= { "GenuineIntel" },
 	.c_early_init   = early_init_intel,
 	.c_init		= init_intel,
+	.c_x86_vendor	= X86_VENDOR_INTEL,
 };
-cpu_vendor_dev_register(X86_VENDOR_INTEL, &intel_cpu_dev);
 
+cpu_dev_register(intel_cpu_dev);
Index: linux-2.6/arch/x86/kernel/cpu/transmeta.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/transmeta.c
+++ linux-2.6/arch/x86/kernel/cpu/transmeta.c
@@ -102,6 +102,7 @@ static struct cpu_dev transmeta_cpu_dev
 	.c_ident	= { "GenuineTMx86", "TransmetaCPU" },
 	.c_init		= init_transmeta,
 	.c_identify	= transmeta_identify,
+	.c_x86_vendor	= X86_VENDOR_TRANSMETA,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_TRANSMETA, &transmeta_cpu_dev);
+cpu_dev_register(transmeta_cpu_dev);
Index: linux-2.6/arch/x86/kernel/cpu/umc.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/umc.c
+++ linux-2.6/arch/x86/kernel/cpu/umc.c
@@ -19,7 +19,8 @@ static struct cpu_dev umc_cpu_dev __cpui
 		  }
 		},
 	},
+	.c_x86_vendor	= X86_VENDOR_UMC,
 };
 
-cpu_vendor_dev_register(X86_VENDOR_UMC, &umc_cpu_dev);
+cpu_dev_register(umc_cpu_dev);
 
Index: linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_32.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_32.lds.S
@@ -140,10 +140,10 @@ SECTIONS
 	*(.con_initcall.init)
   	__con_initcall_end = .;
   }
-  .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
-	__x86cpuvendor_start = .;
-	*(.x86cpuvendor.init)
-	__x86cpuvendor_end = .;
+  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
+	__x86_cpu_dev_start = .;
+	*(.x86_cpu_dev.init)
+	__x86_cpu_dev_end = .;
   }
   DYN_ARRAY_INIT(8)
   SECURITY_INIT
Index: linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
===================================================================
--- linux-2.6.orig/arch/x86/kernel/vmlinux_64.lds.S
+++ linux-2.6/arch/x86/kernel/vmlinux_64.lds.S
@@ -168,12 +168,11 @@ SECTIONS
 	*(.con_initcall.init)
   }
   __con_initcall_end = .;
-  . = ALIGN(16);
-  __x86cpuvendor_start = .;
-  .x86cpuvendor.init : AT(ADDR(.x86cpuvendor.init) - LOAD_OFFSET) {
-	*(.x86cpuvendor.init)
+  __x86_cpu_dev_start = .;
+  .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
+	*(.x86_cpu_dev.init)
   }
-  __x86cpuvendor_end = .;
+  __x86_cpu_dev_end = .;
 
   DYN_ARRAY_INIT(8)
 
Index: linux-2.6/arch/x86/kernel/cpu/Makefile
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/Makefile
+++ linux-2.6/arch/x86/kernel/cpu/Makefile
@@ -8,14 +8,14 @@ obj-y			+= proc.o capflags.o powerflags.
 obj-$(CONFIG_X86_32)	+= common.o bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= common_64.o bugs_64.o
 
+obj-$(CONFIG_CPU_SUP_INTEL_32)		+= intel.o
+obj-$(CONFIG_CPU_SUP_INTEL_64)		+= intel_64.o
 obj-$(CONFIG_CPU_SUP_AMD_32)		+= amd.o
 obj-$(CONFIG_CPU_SUP_AMD_64)		+= amd_64.o
 obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
 obj-$(CONFIG_CPU_SUP_CENTAUR_32)	+= centaur.o
 obj-$(CONFIG_CPU_SUP_CENTAUR_64)	+= centaur_64.o
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
-obj-$(CONFIG_CPU_SUP_INTEL_32)		+= intel.o
-obj-$(CONFIG_CPU_SUP_INTEL_64)		+= intel_64.o
 obj-$(CONFIG_CPU_SUP_UMC_32)		+= umc.o
 
 obj-$(CONFIG_X86_MCE)	+= mcheck/
