Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbYBXK63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbYBXK63 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 05:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbYBXK6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 05:58:20 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:44024 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbYBXK6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 05:58:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version:content-type:content-transfer-encoding;
        b=YHjIK005pEloh32fFeTZeSIhyOmhZcz03PTb9TrS8r0Y7+z4rNtry34eQwODiUl34DWVdPzIZ+y4d6alZmKzlR/DldPil7IhbzL3Akr9uOBSi38m1fQ/CufbP5vXye/kp4d2iehWHXCOD8ef5wTvPK73IbPf9xDphKTOP8YYyXg=
Date: Sun, 24 Feb 2008 11:58:13 +0100
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, hpa <hpa@zytor.com>,
       tglx <tglx@linutronix.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86: Coding Style fixes to arch/x86/kernel/cpu/common.c
Message-ID: <20080224115813.11b78502@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File is now error free.
Compile tested.


Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/kernel/cpu/common.c |  105 ++++++++++++++++++++++-------------------
 1 files changed, 56 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 750456f..d0de972 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -62,9 +62,9 @@ __u32 cleared_cpu_caps[NCAPINTS] __cpuinitdata;
 static int cachesize_override __cpuinitdata = -1;
 static int disable_x86_serial_nr __cpuinitdata = 1;
 
-struct cpu_dev * cpu_devs[X86_VENDOR_NUM] = {};
+struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
 
-static void __cpuinit default_init(struct cpuinfo_x86 * c)
+static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
 	/* Not much we can do here... */
 	/* Check if at least it has cpuid */
@@ -81,11 +81,11 @@ static struct cpu_dev __cpuinitdata default_cpu = {
 	.c_init	= default_init,
 	.c_vendor = "Unknown",
 };
-static struct cpu_dev * this_cpu __cpuinitdata = &default_cpu;
+static struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;
 
 static int __init cachesize_setup(char *str)
 {
-	get_option (&str, &cachesize_override);
+	get_option(&str, &cachesize_override);
 	return 1;
 }
 __setup("cachesize=", cachesize_setup);
@@ -107,12 +107,12 @@ int __cpuinit get_model_name(struct cpuinfo_x86 *c)
 	/* Intel chips right-justify this string for some dumb reason;
 	   undo that brain damage */
 	p = q = &c->x86_model_id[0];
-	while ( *p == ' ' )
+	while (*p == ' ')
 	     p++;
-	if ( p != q ) {
-	     while ( *p )
+	if (p != q) {
+	     while (*p)
 		  *q++ = *p++;
-	     while ( q <= &c->x86_model_id[48] )
+	     while (q <= &c->x86_model_id[48])
 		  *q++ = '\0';	/* Zero-pad the rest */
 	}
 
@@ -130,7 +130,7 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 		cpuid(0x80000005, &dummy, &dummy, &ecx, &edx);
 		printk(KERN_INFO "CPU: L1 I Cache: %dK (%d bytes/line), D cache %dK (%d bytes/line)\n",
 			edx>>24, edx&0xFF, ecx>>24, ecx&0xFF);
-		c->x86_cache_size=(ecx>>24)+(edx>>24);	
+		c->x86_cache_size = (ecx>>24)+(edx>>24);
 	}
 
 	if (n < 0x80000006)	/* Some chips just has a large L1. */
@@ -138,16 +138,16 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 
 	ecx = cpuid_ecx(0x80000006);
 	l2size = ecx >> 16;
-	
+
 	/* do processor-specific cache resizing */
 	if (this_cpu->c_size_cache)
-		l2size = this_cpu->c_size_cache(c,l2size);
+		l2size = this_cpu->c_size_cache(c, l2size);
 
 	/* Allow user to override all this if necessary. */
 	if (cachesize_override != -1)
 		l2size = cachesize_override;
 
-	if ( l2size == 0 )
+	if (l2size == 0)
 		return;		/* Again, no L2 cache is possible */
 
 	c->x86_cache_size = l2size;
@@ -156,16 +156,19 @@ void __cpuinit display_cacheinfo(struct cpuinfo_x86 *c)
 	       l2size, ecx & 0xFF);
 }
 
-/* Naming convention should be: <Name> [(<Codename>)] */
-/* This table only is used unless init_<vendor>() below doesn't set it; */
-/* in particular, if CPUID levels 0x80000002..4 are supported, this isn't used */
+/*
+ * Naming convention should be: <Name> [(<Codename>)]
+ * This table only is used unless init_<vendor>() below doesn't set it;
+ * in particular, if CPUID levels 0x80000002..4 are supported, this isn't used
+ *
+ */
 
 /* Look up CPU names by table lookup. */
 static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
 {
 	struct cpu_model_info *info;
 
-	if ( c->x86_model >= 16 )
+	if (c->x86_model >= 16)
 		return NULL;	/* Range check */
 
 	if (!this_cpu)
@@ -190,9 +193,9 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c, int early)
 
 	for (i = 0; i < X86_VENDOR_NUM; i++) {
 		if (cpu_devs[i]) {
-			if (!strcmp(v,cpu_devs[i]->c_ident[0]) ||
-			    (cpu_devs[i]->c_ident[1] && 
-			     !strcmp(v,cpu_devs[i]->c_ident[1]))) {
+			if (!strcmp(v, cpu_devs[i]->c_ident[0]) ||
+			    (cpu_devs[i]->c_ident[1] &&
+			     !strcmp(v, cpu_devs[i]->c_ident[1]))) {
 				c->x86_vendor = i;
 				if (!early)
 					this_cpu = cpu_devs[i];
@@ -210,7 +213,7 @@ static void __cpuinit get_cpu_vendor(struct cpuinfo_x86 *c, int early)
 }
 
 
-static int __init x86_fxsr_setup(char * s)
+static int __init x86_fxsr_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_FXSR);
 	setup_clear_cpu_cap(X86_FEATURE_XMM);
@@ -219,7 +222,7 @@ static int __init x86_fxsr_setup(char * s)
 __setup("nofxsr", x86_fxsr_setup);
 
 
-static int __init x86_sep_setup(char * s)
+static int __init x86_sep_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_SEP);
 	return 1;
@@ -308,12 +311,15 @@ static void __cpuinit early_get_cap(struct cpuinfo_x86 *c)
 
 }
 
-/* Do minimum CPU detection early.
-   Fields really needed: vendor, cpuid_level, family, model, mask, cache alignment.
-   The others are not touched to avoid unwanted side effects.
-
-   WARNING: this function is only called on the BP.  Don't add code here
-   that is supposed to run on all CPUs. */
+/*
+ * Do minimum CPU detection early.
+ * Fields really needed: vendor, cpuid_level, family, model, mask,
+ * cache alignment.
+ * The others are not touched to avoid unwanted side effects.
+ *
+ * WARNING: this function is only called on the BP.  Don't add code here
+ * that is supposed to run on all CPUs.
+ */
 static void __init early_cpu_detect(void)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
@@ -335,7 +341,7 @@ static void __init early_cpu_detect(void)
 	early_get_cap(c);
 }
 
-static void __cpuinit generic_identify(struct cpuinfo_x86 * c)
+static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
 {
 	u32 tfms, xlvl;
 	unsigned int ebx;
@@ -346,13 +352,12 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 * c)
 		      (unsigned int *)&c->x86_vendor_id[0],
 		      (unsigned int *)&c->x86_vendor_id[8],
 		      (unsigned int *)&c->x86_vendor_id[4]);
-		
+
 		get_cpu_vendor(c, 0);
 		/* Initialize the standard set of capabilities */
 		/* Note that the vendor-specific code below might override */
-	
 		/* Intel-defined flags: level 0x00000001 */
-		if ( c->cpuid_level >= 0x00000001 ) {
+		if (c->cpuid_level >= 0x00000001) {
 			u32 capability, excap;
 			cpuid(0x00000001, &tfms, &ebx, &excap, &capability);
 			c->x86_capability[0] = capability;
@@ -378,12 +383,12 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 * c)
 
 		/* AMD-defined flags: level 0x80000001 */
 		xlvl = cpuid_eax(0x80000000);
-		if ( (xlvl & 0xffff0000) == 0x80000000 ) {
-			if ( xlvl >= 0x80000001 ) {
+		if ((xlvl & 0xffff0000) == 0x80000000) {
+			if (xlvl >= 0x80000001) {
 				c->x86_capability[1] = cpuid_edx(0x80000001);
 				c->x86_capability[6] = cpuid_ecx(0x80000001);
 			}
-			if ( xlvl >= 0x80000004 )
+			if (xlvl >= 0x80000004)
 				get_model_name(c); /* Default name */
 		}
 
@@ -397,12 +402,12 @@ static void __cpuinit generic_identify(struct cpuinfo_x86 * c)
 
 static void __cpuinit squash_the_stupid_serial_number(struct cpuinfo_x86 *c)
 {
-	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr ) {
+	if (cpu_has(c, X86_FEATURE_PN) && disable_x86_serial_nr) {
 		/* Disable processor serial number */
-		unsigned long lo,hi;
-		rdmsr(MSR_IA32_BBL_CR_CTL,lo,hi);
+		unsigned long lo, hi;
+		rdmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
 		lo |= 0x200000;
-		wrmsr(MSR_IA32_BBL_CR_CTL,lo,hi);
+		wrmsr(MSR_IA32_BBL_CR_CTL, lo, hi);
 		printk(KERN_NOTICE "CPU serial number disabled.\n");
 		clear_bit(X86_FEATURE_PN, c->x86_capability);
 
@@ -439,9 +444,11 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	memset(&c->x86_capability, 0, sizeof c->x86_capability);
 
 	if (!have_cpuid_p()) {
-		/* First of all, decide if this is a 486 or higher */
-		/* It's a 486 if we can modify the AC flag */
-		if ( flag_is_changeable_p(X86_EFLAGS_AC) )
+		/*
+		 * First of all, decide if this is a 486 or higher
+		 * It's a 486 if we can modify the AC flag
+		 */
+		if (flag_is_changeable_p(X86_EFLAGS_AC))
 			c->x86 = 4;
 		else
 			c->x86 = 3;
@@ -474,10 +481,10 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	 */
 
 	/* If the model name is still unset, do table lookup. */
-	if ( !c->x86_model_id[0] ) {
+	if (!c->x86_model_id[0]) {
 		char *p;
 		p = table_lookup_model(c);
-		if ( p )
+		if (p)
 			strcpy(c->x86_model_id, p);
 		else
 			/* Last resort... */
@@ -491,9 +498,9 @@ void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 	 * common between the CPUs.  The first time this routine gets
 	 * executed, c == &boot_cpu_data.
 	 */
-	if ( c != &boot_cpu_data ) {
+	if (c != &boot_cpu_data) {
 		/* AND the already accumulated flags with these */
-		for ( i = 0 ; i < NCAPINTS ; i++ )
+		for (i = 0 ; i < NCAPINTS ; i++)
 			boot_cpu_data.x86_capability[i] &= c->x86_capability[i];
 	}
 
@@ -537,7 +544,7 @@ void __cpuinit detect_ht(struct cpuinfo_x86 *c)
 
 	if (smp_num_siblings == 1) {
 		printk(KERN_INFO  "CPU: Hyper-Threading is disabled\n");
-	} else if (smp_num_siblings > 1 ) {
+	} else if (smp_num_siblings > 1) {
 
 		if (smp_num_siblings > NR_CPUS) {
 			printk(KERN_WARNING "CPU: Unsupported number of the "
@@ -592,7 +599,7 @@ void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 	else
 		printk("%s", c->x86_model_id);
 
-	if (c->x86_mask || c->cpuid_level >= 0) 
+	if (c->x86_mask || c->cpuid_level >= 0)
 		printk(" stepping %02x\n", c->x86_mask);
 	else
 		printk("\n");
@@ -660,7 +667,7 @@ void __cpuinit cpu_init(void)
 {
 	int cpu = smp_processor_id();
 	struct task_struct *curr = current;
-	struct tss_struct * t = &per_cpu(init_tss, cpu);
+	struct tss_struct *t = &per_cpu(init_tss, cpu);
 	struct thread_struct *thread = &curr->thread;
 
 	if (cpu_test_and_set(cpu, cpu_initialized)) {
@@ -686,7 +693,7 @@ void __cpuinit cpu_init(void)
 	enter_lazy_tlb(&init_mm, curr);
 
 	load_sp0(t, thread);
-	set_tss_desc(cpu,t);
+	set_tss_desc(cpu, t);
 	load_TR_desc();
 	load_LDT(&init_mm.context);
 
-- 
1.5.4.2.316.gf7a7

