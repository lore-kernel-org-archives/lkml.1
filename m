Return-Path: <linux-kernel-owner+w=401wt.eu-S932944AbZFMQj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944AbZFMQj0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 12:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932778AbZFMQir
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 12:38:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:34552 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745AbZFMQiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 12:38:46 -0400
Subject: [RFC][PATCH 4/10 -tip] x86: cpu_debug make room to support more
 categories
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@kernel.org>, x86 maintainers <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Dave Jones <davej@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>
In-Reply-To: <1244910618.11733.18.camel@ht.satnam>
References: <1244910436.11733.14.camel@ht.satnam>
	 <1244910511.11733.16.camel@ht.satnam> <1244910575.11733.17.camel@ht.satnam>
	 <1244910618.11733.18.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 13 Jun 2009 22:00:55 +0530
Message-Id: <1244910655.11733.19.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Earlier cpu_debug categories was stored in bitwise fashion and
we reached the limit of 0-31.

So now storing the categories based on count so that we can add more.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/cpu_debug.h |  102 +++++++++++++-------------------------
 arch/x86/kernel/cpu/cpu_debug.c  |   14 +++---
 2 files changed, 41 insertions(+), 75 deletions(-)

diff --git a/arch/x86/include/asm/cpu_debug.h b/arch/x86/include/asm/cpu_debug.h
index d96c1ee..da5c221 100644
--- a/arch/x86/include/asm/cpu_debug.h
+++ b/arch/x86/include/asm/cpu_debug.h
@@ -10,84 +10,50 @@
 /* Register flags */
 enum cpu_debug_bit {
 /* Model Specific Registers (MSRs)					*/
-	CPU_MC_BIT,				/* Machine Check	*/
-	CPU_MONITOR_BIT,			/* Monitor		*/
-	CPU_TIME_BIT,				/* Time			*/
-	CPU_PMC_BIT,				/* Performance Monitor	*/
-	CPU_PLATFORM_BIT,			/* Platform		*/
-	CPU_APIC_BIT,				/* APIC			*/
-	CPU_POWERON_BIT,			/* Power-on		*/
-	CPU_CONTROL_BIT,			/* Control		*/
-	CPU_FEATURES_BIT,			/* Features control	*/
-	CPU_LBRANCH_BIT,			/* Last Branch		*/
-	CPU_BIOS_BIT,				/* BIOS			*/
-	CPU_FREQ_BIT,				/* Frequency		*/
-	CPU_MTTR_BIT,				/* MTRR			*/
-	CPU_PERF_BIT,				/* Performance		*/
-	CPU_CACHE_BIT,				/* Cache		*/
-	CPU_SYSENTER_BIT,			/* Sysenter		*/
-	CPU_THERM_BIT,				/* Thermal		*/
-	CPU_MISC_BIT,				/* Miscellaneous	*/
-	CPU_DEBUG_BIT,				/* Debug		*/
-	CPU_PAT_BIT,				/* PAT			*/
-	CPU_VMX_BIT,				/* VMX			*/
-	CPU_CALL_BIT,				/* System Call		*/
-	CPU_BASE_BIT,				/* BASE Address		*/
-	CPU_VER_BIT,				/* Version ID		*/
-	CPU_CONF_BIT,				/* Configuration	*/
-	CPU_SMM_BIT,				/* System mgmt mode	*/
-	CPU_SVM_BIT,				/*Secure Virtual Machine*/
-	CPU_OSVM_BIT,				/* OS-Visible Workaround*/
+	CPU_MC,					/* Machine Check	*/
+	CPU_MONITOR,				/* Monitor		*/
+	CPU_TIME,				/* Time			*/
+	CPU_PMC,				/* Performance Monitor	*/
+	CPU_PLATFORM,				/* Platform		*/
+	CPU_APIC,				/* APIC			*/
+	CPU_POWERON,				/* Power-on		*/
+	CPU_CONTROL,				/* Control		*/
+	CPU_FEATURES,				/* Features control	*/
+	CPU_LBRANCH,				/* Last Branch		*/
+	CPU_BIOS,				/* BIOS			*/
+	CPU_FREQ,				/* Frequency		*/
+	CPU_MTRR,				/* MTRR			*/
+	CPU_PERF,				/* Performance		*/
+	CPU_CACHE,				/* Cache		*/
+	CPU_SYSENTER,				/* Sysenter		*/
+	CPU_THERM,				/* Thermal		*/
+	CPU_MISC,				/* Miscellaneous	*/
+	CPU_DEBUG,				/* Debug		*/
+	CPU_PAT,				/* PAT			*/
+	CPU_VMX,				/* VMX			*/
+	CPU_CALL,				/* System Call		*/
+	CPU_BASE,				/* BASE Address		*/
+	CPU_VER,				/* Version ID		*/
+	CPU_CONF,				/* Configuration	*/
+	CPU_SMM,				/* System mgmt mode	*/
+	CPU_SVM,				/*Secure Virtual Machine*/
+	CPU_OSVM,				/* OS-Visible Workaround*/
 /* Standard Registers							*/
-	CPU_TSS_BIT,				/* Task Stack Segment	*/
-	CPU_CR_BIT,				/* Control Registers	*/
-	CPU_DT_BIT,				/* Descriptor Table	*/
+	CPU_TSS,				/* Task Stack Segment	*/
+	CPU_CR,					/* Control Registers	*/
+	CPU_DT,					/* Descriptor Table	*/
 /* End of Registers flags						*/
-	CPU_REG_ALL_BIT,			/* Select all Registers	*/
+	CPU_REG_MAX,				/* Max Registers flags	*/
 };
 
 #define	CPU_REG_ALL		(~0)		/* Select all Registers	*/
 
-#define	CPU_MC			(1 << CPU_MC_BIT)
-#define	CPU_MONITOR		(1 << CPU_MONITOR_BIT)
-#define	CPU_TIME		(1 << CPU_TIME_BIT)
-#define	CPU_PMC			(1 << CPU_PMC_BIT)
-#define	CPU_PLATFORM		(1 << CPU_PLATFORM_BIT)
-#define	CPU_APIC		(1 << CPU_APIC_BIT)
-#define	CPU_POWERON		(1 << CPU_POWERON_BIT)
-#define	CPU_CONTROL		(1 << CPU_CONTROL_BIT)
-#define	CPU_FEATURES		(1 << CPU_FEATURES_BIT)
-#define	CPU_LBRANCH		(1 << CPU_LBRANCH_BIT)
-#define	CPU_BIOS		(1 << CPU_BIOS_BIT)
-#define	CPU_FREQ		(1 << CPU_FREQ_BIT)
-#define	CPU_MTRR		(1 << CPU_MTTR_BIT)
-#define	CPU_PERF		(1 << CPU_PERF_BIT)
-#define	CPU_CACHE		(1 << CPU_CACHE_BIT)
-#define	CPU_SYSENTER		(1 << CPU_SYSENTER_BIT)
-#define	CPU_THERM		(1 << CPU_THERM_BIT)
-#define	CPU_MISC		(1 << CPU_MISC_BIT)
-#define	CPU_DEBUG		(1 << CPU_DEBUG_BIT)
-#define	CPU_PAT			(1 << CPU_PAT_BIT)
-#define	CPU_VMX			(1 << CPU_VMX_BIT)
-#define	CPU_CALL		(1 << CPU_CALL_BIT)
-#define	CPU_BASE		(1 << CPU_BASE_BIT)
-#define	CPU_VER			(1 << CPU_VER_BIT)
-#define	CPU_CONF		(1 << CPU_CONF_BIT)
-#define	CPU_SMM			(1 << CPU_SMM_BIT)
-#define	CPU_SVM			(1 << CPU_SVM_BIT)
-#define	CPU_OSVM		(1 << CPU_OSVM_BIT)
-#define	CPU_TSS			(1 << CPU_TSS_BIT)
-#define	CPU_CR			(1 << CPU_CR_BIT)
-#define	CPU_DT			(1 << CPU_DT_BIT)
-
 /* Register file flags */
 enum cpu_file_bit {
-	CPU_INDEX_BIT,				/* index		*/
-	CPU_VALUE_BIT,				/* value		*/
+	CPU_INDEX,				/* index		*/
+	CPU_VALUE,				/* value		*/
 };
 
-#define	CPU_FILE_VALUE		(1 << CPU_VALUE_BIT)
-
 #define MAX_CPU_FILES		512
 
 struct cpu_private {
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 3aa3596..5c45c52 100644
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -25,7 +25,7 @@
 #include <asm/apic.h>
 #include <asm/desc.h>
 
-static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_ALL_BIT]);
+static DEFINE_PER_CPU(struct cpu_cpuX_base, cpu_arr[CPU_REG_MAX]);
 static DEFINE_PER_CPU(struct cpu_private *, priv_arr[MAX_CPU_FILES]);
 static DEFINE_PER_CPU(int, cpu_priv_count);
 
@@ -399,12 +399,12 @@ static int cpu_seq_show(struct seq_file *seq, void *v)
 		smp_call_function_single(priv->cpu, print_dt, seq, 1);
 		break;
 	case CPU_DEBUG:
-		if (priv->file == CPU_INDEX_BIT)
+		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_dr, seq, 1);
 		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
 		break;
 	case CPU_APIC:
-		if (priv->file == CPU_INDEX_BIT)
+		if (priv->file == CPU_INDEX)
 			smp_call_function_single(priv->cpu, print_apic, seq, 1);
 		print_msr(seq, priv->cpu, cpu_base[priv->type].flag);
 		break;
@@ -482,7 +482,7 @@ static int write_cpu_register(struct cpu_private *priv, const char *buf)
 		return ret;
 
 	/* Supporting only MSRs */
-	if (priv->type < CPU_TSS_BIT)
+	if (priv->type < CPU_TSS)
 		return write_msr(priv, val);
 
 	return ret;
@@ -525,7 +525,7 @@ static int cpu_create_file(unsigned cpu, unsigned type, unsigned reg,
 	struct cpu_private *priv = NULL;
 
 	/* Already intialized */
-	if (file == CPU_INDEX_BIT)
+	if (file == CPU_INDEX)
 		if (per_cpu(cpu_arr[type].init, cpu))
 			return 0;
 
@@ -612,10 +612,10 @@ static int cpu_init_allreg(unsigned cpu, struct dentry *dentry)
 		cpu_dentry = debugfs_create_dir(cpu_base[type].name, dentry);
 		per_cpu(cpu_arr[type].dentry, cpu) = cpu_dentry;
 
-		if (type < CPU_TSS_BIT)
+		if (type < CPU_TSS)
 			err = cpu_init_msr(cpu, type, cpu_dentry);
 		else
-			err = cpu_create_file(cpu, type, 0, CPU_INDEX_BIT,
+			err = cpu_create_file(cpu, type, 0, CPU_INDEX,
 					      cpu_dentry);
 		if (err)
 			return err;
-- 
1.6.0.6



