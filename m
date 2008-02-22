Return-Path: <linux-kernel-owner+w=401wt.eu-S935557AbYBVWLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935557AbYBVWLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 17:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935081AbYBVWJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 17:09:49 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:28753 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760796AbYBVWJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 17:09:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=r/Sbg+vnod7uIONB/ZdVrgluBAjqewZ9bvNC9B2mImAaEqgDwuu3SDYdjkfHERetzNtdITqGPkoGq/He+sUaZtc8nmAptbiuQuMBzXDge/bRC47+bMQx6MbewFTLbTOWseVM/RLfxBtGRKWYhcjm54s1Sgbx0TKR79+ts1WZhTk=
Date: Fri, 22 Feb 2008 23:09:42 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: hpa <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 03/20] x86: Coding Style fixes to
 arch/x86/kernel/cpu/intel.c
Message-ID: <20080222230942.4df26dd4@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.

Compile tested

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/intel.c |   83 ++++++++++++++++++++++--------------------
 1 files changed, 43 insertions(+), 40 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index b5562a3..4bbf0ab 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -45,7 +45,7 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
  *
  *	This is called before we do cpu ident work
  */
- 
+
 int __cpuinit ppro_with_ram_bug(void)
 {
 	/* Uses data from early_cpu_detect now */
@@ -58,7 +58,7 @@ int __cpuinit ppro_with_ram_bug(void)
 	}
 	return 0;
 }
-	
+
 
 /*
  * P4 Xeon errata 037 workaround.
@@ -69,7 +69,7 @@ static void __cpuinit Intel_errata_workarounds(struct cpuinfo_x86 *c)
 	unsigned long lo, hi;
 
 	if ((c->x86 == 15) && (c->x86_model == 1) && (c->x86_mask == 1)) {
-		rdmsr (MSR_IA32_MISC_ENABLE, lo, hi);
+		rdmsr(MSR_IA32_MISC_ENABLE, lo, hi);
 		if ((lo & (1<<9)) == 0) {
 			printk (KERN_INFO "CPU: C0 stepping P4 Xeon detected.\n");
 			printk (KERN_INFO "CPU: Disabling hardware prefetching (Errata 037)\n");
@@ -127,10 +127,10 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 	 */
 	c->f00f_bug = 0;
 	if (!paravirt_enabled() && c->x86 == 5) {
-		static int f00f_workaround_enabled = 0;
+		static int f00f_workaround_enabled;
 
 		c->f00f_bug = 1;
-		if ( !f00f_workaround_enabled ) {
+		if (!f00f_workaround_enabled) {
 			trap_init_f00f_bug();
 			printk(KERN_NOTICE "Intel Pentium with F0 0F bug - workaround enabled.\n");
 			f00f_workaround_enabled = 1;
@@ -139,7 +139,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 #endif
 
 	l2 = init_intel_cacheinfo(c);
-	if (c->cpuid_level > 9 ) {
+	if (c->cpuid_level > 9) {
 		unsigned eax = cpuid_eax(10);
 		/* Check for version and the number of counters */
 		if ((eax & 0xff) && (((eax>>8) & 0xff) > 1))
@@ -150,9 +150,11 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 	if ((c->x86<<8 | c->x86_model<<4 | c->x86_mask) < 0x633)
 		clear_bit(X86_FEATURE_SEP, c->x86_capability);
 
-	/* Names for the Pentium II/Celeron processors 
-	   detectable only by also checking the cache size.
-	   Dixon is NOT a Celeron. */
+	/*
+	 * Names for the Pentium II/Celeron processors
+	 * detectable only by also checking the cache size.
+	 * Dixon is NOT a Celeron.
+	 */
 	if (c->x86 == 6) {
 		switch (c->x86_model) {
 		case 5:
@@ -163,14 +165,14 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 					p = "Mobile Pentium II (Dixon)";
 			}
 			break;
-			
+
 		case 6:
 			if (l2 == 128)
 				p = "Celeron (Mendocino)";
 			else if (c->x86_mask == 0 || c->x86_mask == 5)
 				p = "Celeron-A";
 			break;
-			
+
 		case 8:
 			if (l2 == 128)
 				p = "Celeron (Coppermine)";
@@ -178,9 +180,9 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		}
 	}
 
-	if ( p )
+	if (p)
 		strcpy(c->x86_model_id, p);
-	
+
 	c->x86_max_cores = num_cpu_cores(c);
 
 	detect_ht(c);
@@ -211,7 +213,7 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 	if (c->x86 == 15) {
 		set_bit(X86_FEATURE_P4, c->x86_capability);
 	}
-	if (c->x86 == 6) 
+	if (c->x86 == 6)
 		set_bit(X86_FEATURE_P3, c->x86_capability);
 	if (cpu_has_ds) {
 		unsigned int l1;
@@ -227,9 +229,10 @@ static void __cpuinit init_intel(struct cpuinfo_x86 *c)
 		ptrace_bts_init_intel(c);
 }
 
-static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 * c, unsigned int size)
+static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 {
-	/* Intel PIII Tualatin. This comes in two flavours.
+	/*
+	 * Intel PIII Tualatin. This comes in two flavours.
 	 * One has 256kb of cache, the other 512. We have no way
 	 * to determine which, so we use a boottime override
 	 * for the 512kb model, and assume 256 otherwise.
@@ -241,42 +244,42 @@ static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 * c, unsigned
 
 static struct cpu_dev intel_cpu_dev __cpuinitdata = {
 	.c_vendor	= "Intel",
-	.c_ident 	= { "GenuineIntel" },
+	.c_ident	= { "GenuineIntel" },
 	.c_models = {
-		{ .vendor = X86_VENDOR_INTEL, .family = 4, .model_names = 
-		  { 
-			  [0] = "486 DX-25/33", 
-			  [1] = "486 DX-50", 
-			  [2] = "486 SX", 
-			  [3] = "486 DX/2", 
-			  [4] = "486 SL", 
-			  [5] = "486 SX/2", 
-			  [7] = "486 DX/2-WB", 
-			  [8] = "486 DX/4", 
+		{ .vendor = X86_VENDOR_INTEL, .family = 4, .model_names =
+		  {
+			  [0] = "486 DX-25/33",
+			  [1] = "486 DX-50",
+			  [2] = "486 SX",
+			  [3] = "486 DX/2",
+			  [4] = "486 SL",
+			  [5] = "486 SX/2",
+			  [7] = "486 DX/2-WB",
+			  [8] = "486 DX/4",
 			  [9] = "486 DX/4-WB"
 		  }
 		},
 		{ .vendor = X86_VENDOR_INTEL, .family = 5, .model_names =
-		  { 
-			  [0] = "Pentium 60/66 A-step", 
-			  [1] = "Pentium 60/66", 
+		  {
+			  [0] = "Pentium 60/66 A-step",
+			  [1] = "Pentium 60/66",
 			  [2] = "Pentium 75 - 200",
-			  [3] = "OverDrive PODP5V83", 
+			  [3] = "OverDrive PODP5V83",
 			  [4] = "Pentium MMX",
-			  [7] = "Mobile Pentium 75 - 200", 
+			  [7] = "Mobile Pentium 75 - 200",
 			  [8] = "Mobile Pentium MMX"
 		  }
 		},
 		{ .vendor = X86_VENDOR_INTEL, .family = 6, .model_names =
-		  { 
+		  {
 			  [0] = "Pentium Pro A-step",
-			  [1] = "Pentium Pro", 
-			  [3] = "Pentium II (Klamath)", 
-			  [4] = "Pentium II (Deschutes)", 
-			  [5] = "Pentium II (Deschutes)", 
+			  [1] = "Pentium Pro",
+			  [3] = "Pentium II (Klamath)",
+			  [4] = "Pentium II (Deschutes)",
+			  [5] = "Pentium II (Deschutes)",
 			  [6] = "Mobile Pentium II",
-			  [7] = "Pentium III (Katmai)", 
-			  [8] = "Pentium III (Coppermine)", 
+			  [7] = "Pentium III (Katmai)",
+			  [8] = "Pentium III (Coppermine)",
 			  [10] = "Pentium III (Cascades)",
 			  [11] = "Pentium III (Tualatin)",
 		  }
@@ -362,5 +365,5 @@ unsigned long long cmpxchg_486_u64(volatile void *ptr, u64 old, u64 new)
 EXPORT_SYMBOL(cmpxchg_486_u64);
 #endif
 
-// arch_initcall(intel_cpu_init);
+/* arch_initcall(intel_cpu_init); */
 
-- 
1.5.4.GIT

