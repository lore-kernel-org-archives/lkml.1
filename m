Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZCLMQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZCLMQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 08:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZCLMQJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 08:16:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:44501 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261AbZCLMQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 08:16:07 -0400
Date: Thu, 12 Mar 2009 12:15:38 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B90961.76E4.0078.0@novell.com>
References: <49B90961.76E4.0078.0@novell.com>
Subject: [tip:x86/debug] x86: move various CPU initialization objects into .cpuinit.rodata
Message-ID: <tip-02dde8b45c5460794b9052d7c12939fe3eb63c2c@git.kernel.org>
Git-Commit-ID: 02dde8b45c5460794b9052d7c12939fe3eb63c2c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 12 Mar 2009 12:15:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02dde8b45c5460794b9052d7c12939fe3eb63c2c
Gitweb:     http://git.kernel.org/tip/02dde8b45c5460794b9052d7c12939fe3eb63c2c
Author:     "Jan Beulich" <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 12:08:49 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 12 Mar 2009 13:13:07 +0100

x86: move various CPU initialization objects into .cpuinit.rodata

Impact: debuggability and micro-optimization

Putting whatever is possible into the (final) .rodata section increases
the likelihood of catching memory corruption bugs early, and reduces
false cache line sharing.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B90961.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/addon_cpuid_features.c |    2 +-
 arch/x86/kernel/cpu/amd.c                  |    2 +-
 arch/x86/kernel/cpu/centaur.c              |    2 +-
 arch/x86/kernel/cpu/centaur_64.c           |    2 +-
 arch/x86/kernel/cpu/common.c               |   20 ++++++++++----------
 arch/x86/kernel/cpu/cpu.h                  |   11 ++++++-----
 arch/x86/kernel/cpu/cyrix.c                |   16 ++++++++--------
 arch/x86/kernel/cpu/intel.c                |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c      |    8 ++++----
 arch/x86/kernel/cpu/transmeta.c            |    2 +-
 arch/x86/kernel/cpu/umc.c                  |    2 +-
 arch/x86/kernel/mmconf-fam10h_64.c         |    2 +-
 12 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index 6882a73..8220ae6 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -29,7 +29,7 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 	u32 regs[4];
 	const struct cpuid_bit *cb;
 
-	static const struct cpuid_bit cpuid_bits[] = {
+	static const struct cpuid_bit __cpuinitconst cpuid_bits[] = {
 		{ X86_FEATURE_IDA, CR_EAX, 1, 0x00000006 },
 		{ 0, 0, 0, 0 }
 	};
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f47df59..7e4a459 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -502,7 +502,7 @@ static unsigned int __cpuinit amd_size_cache(struct cpuinfo_x86 *c, unsigned int
 }
 #endif
 
-static struct cpu_dev amd_cpu_dev __cpuinitdata = {
+static const struct cpu_dev __cpuinitconst amd_cpu_dev = {
 	.c_vendor	= "AMD",
 	.c_ident	= { "AuthenticAMD" },
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/centaur.c b/arch/x86/kernel/cpu/centaur.c
index 89bfdd9..983e083 100644
--- a/arch/x86/kernel/cpu/centaur.c
+++ b/arch/x86/kernel/cpu/centaur.c
@@ -468,7 +468,7 @@ centaur_size_cache(struct cpuinfo_x86 *c, unsigned int size)
 	return size;
 }
 
-static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
+static const struct cpu_dev __cpuinitconst centaur_cpu_dev = {
 	.c_vendor	= "Centaur",
 	.c_ident	= { "CentaurHauls" },
 	.c_early_init	= early_init_centaur,
diff --git a/arch/x86/kernel/cpu/centaur_64.c b/arch/x86/kernel/cpu/centaur_64.c
index a1625f5..51b09c4 100644
--- a/arch/x86/kernel/cpu/centaur_64.c
+++ b/arch/x86/kernel/cpu/centaur_64.c
@@ -25,7 +25,7 @@ static void __cpuinit init_centaur(struct cpuinfo_x86 *c)
 	set_cpu_cap(c, X86_FEATURE_LFENCE_RDTSC);
 }
 
-static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
+static const struct cpu_dev centaur_cpu_dev __cpuinitconst = {
 	.c_vendor	= "Centaur",
 	.c_ident	= { "CentaurHauls" },
 	.c_early_init	= early_init_centaur,
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index f886997..54cbe76 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -70,7 +70,7 @@ cpumask_t cpu_sibling_setup_map;
 #endif /* CONFIG_X86_32 */
 
 
-static struct cpu_dev *this_cpu __cpuinitdata;
+static const struct cpu_dev *this_cpu __cpuinitdata;
 
 DEFINE_PER_CPU_PAGE_ALIGNED(struct gdt_page, gdt_page) = { .gdt = {
 #ifdef CONFIG_X86_64
@@ -274,9 +274,9 @@ static void __cpuinit filter_cpuid_features(struct cpuinfo_x86 *c, bool warn)
  */
 
 /* Look up CPU names by table lookup. */
-static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
+static const char *__cpuinit table_lookup_model(struct cpuinfo_x86 *c)
 {
-	struct cpu_model_info *info;
+	const struct cpu_model_info *info;
 
 	if (c->x86_model >= 16)
 		return NULL;	/* Range check */
@@ -321,7 +321,7 @@ void switch_to_new_gdt(int cpu)
 	load_percpu_segment(cpu);
 }
 
-static struct cpu_dev *cpu_devs[X86_VENDOR_NUM] = {};
+static const struct cpu_dev *__cpuinitdata cpu_devs[X86_VENDOR_NUM] = {};
 
 static void __cpuinit default_init(struct cpuinfo_x86 *c)
 {
@@ -340,7 +340,7 @@ static void __cpuinit default_init(struct cpuinfo_x86 *c)
 #endif
 }
 
-static struct cpu_dev __cpuinitdata default_cpu = {
+static const struct cpu_dev __cpuinitconst default_cpu = {
 	.c_init	= default_init,
 	.c_vendor = "Unknown",
 	.c_x86_vendor = X86_VENDOR_UNKNOWN,
@@ -634,12 +634,12 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 
 void __init early_cpu_init(void)
 {
-	struct cpu_dev **cdev;
+	const struct cpu_dev *const *cdev;
 	int count = 0;
 
 	printk("KERNEL supported cpus:\n");
 	for (cdev = __x86_cpu_dev_start; cdev < __x86_cpu_dev_end; cdev++) {
-		struct cpu_dev *cpudev = *cdev;
+		const struct cpu_dev *cpudev = *cdev;
 		unsigned int j;
 
 		if (count >= X86_VENDOR_NUM)
@@ -768,7 +768,7 @@ static void __cpuinit identify_cpu(struct cpuinfo_x86 *c)
 
 	/* If the model name is still unset, do table lookup. */
 	if (!c->x86_model_id[0]) {
-		char *p;
+		const char *p;
 		p = table_lookup_model(c);
 		if (p)
 			strcpy(c->x86_model_id, p);
@@ -847,7 +847,7 @@ struct msr_range {
 	unsigned max;
 };
 
-static struct msr_range msr_range_array[] __cpuinitdata = {
+static const struct msr_range msr_range_array[] __cpuinitconst = {
 	{ 0x00000000, 0x00000418},
 	{ 0xc0000000, 0xc000040b},
 	{ 0xc0010000, 0xc0010142},
@@ -894,7 +894,7 @@ __setup("noclflush", setup_noclflush);
 
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
-	char *vendor = NULL;
+	const char *vendor = NULL;
 
 	if (c->x86_vendor < X86_VENDOR_NUM)
 		vendor = this_cpu->c_vendor;
diff --git a/arch/x86/kernel/cpu/cpu.h b/arch/x86/kernel/cpu/cpu.h
index de4094a..9469ecb 100644
--- a/arch/x86/kernel/cpu/cpu.h
+++ b/arch/x86/kernel/cpu/cpu.h
@@ -5,15 +5,15 @@
 struct cpu_model_info {
 	int vendor;
 	int family;
-	char *model_names[16];
+	const char *model_names[16];
 };
 
 /* attempt to consolidate cpu attributes */
 struct cpu_dev {
-	char	* c_vendor;
+	const char	* c_vendor;
 
 	/* some have two possibilities for cpuid string */
-	char	* c_ident[2];	
+	const char	* c_ident[2];
 
 	struct		cpu_model_info c_models[4];
 
@@ -25,11 +25,12 @@ struct cpu_dev {
 };
 
 #define cpu_dev_register(cpu_devX) \
-	static struct cpu_dev *__cpu_dev_##cpu_devX __used \
+	static const struct cpu_dev *const __cpu_dev_##cpu_devX __used \
 	__attribute__((__section__(".x86_cpu_dev.init"))) = \
 	&cpu_devX;
 
-extern struct cpu_dev *__x86_cpu_dev_start[], *__x86_cpu_dev_end[];
+extern const struct cpu_dev *const __x86_cpu_dev_start[],
+			    *const __x86_cpu_dev_end[];
 
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
 
diff --git a/arch/x86/kernel/cpu/cyrix.c b/arch/x86/kernel/cpu/cyrix.c
index ffd0f5e..593171e 100644
--- a/arch/x86/kernel/cpu/cyrix.c
+++ b/arch/x86/kernel/cpu/cyrix.c
@@ -61,23 +61,23 @@ static void __cpuinit do_cyrix_devid(unsigned char *dir0, unsigned char *dir1)
  */
 static unsigned char Cx86_dir0_msb __cpuinitdata = 0;
 
-static char Cx86_model[][9] __cpuinitdata = {
+static const char __cpuinitconst Cx86_model[][9] = {
 	"Cx486", "Cx486", "5x86 ", "6x86", "MediaGX ", "6x86MX ",
 	"M II ", "Unknown"
 };
-static char Cx486_name[][5] __cpuinitdata = {
+static const char __cpuinitconst Cx486_name[][5] = {
 	"SLC", "DLC", "SLC2", "DLC2", "SRx", "DRx",
 	"SRx2", "DRx2"
 };
-static char Cx486S_name[][4] __cpuinitdata = {
+static const char __cpuinitconst Cx486S_name[][4] = {
 	"S", "S2", "Se", "S2e"
 };
-static char Cx486D_name[][4] __cpuinitdata = {
+static const char __cpuinitconst Cx486D_name[][4] = {
 	"DX", "DX2", "?", "?", "?", "DX4"
 };
 static char Cx86_cb[] __cpuinitdata = "?.5x Core/Bus Clock";
-static char cyrix_model_mult1[] __cpuinitdata = "12??43";
-static char cyrix_model_mult2[] __cpuinitdata = "12233445";
+static const char __cpuinitconst cyrix_model_mult1[] = "12??43";
+static const char __cpuinitconst cyrix_model_mult2[] = "12233445";
 
 /*
  * Reset the slow-loop (SLOP) bit on the 686(L) which is set by some old
@@ -435,7 +435,7 @@ static void __cpuinit cyrix_identify(struct cpuinfo_x86 *c)
 	}
 }
 
-static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
+static const struct cpu_dev __cpuinitconst cyrix_cpu_dev = {
 	.c_vendor	= "Cyrix",
 	.c_ident	= { "CyrixInstead" },
 	.c_early_init	= early_init_cyrix,
@@ -446,7 +446,7 @@ static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
 
 cpu_dev_register(cyrix_cpu_dev);
 
-static struct cpu_dev nsc_cpu_dev __cpuinitdata = {
+static const struct cpu_dev __cpuinitconst nsc_cpu_dev = {
 	.c_vendor	= "NSC",
 	.c_ident	= { "Geode by NSC" },
 	.c_init		= init_nsc,
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 191117f..968f151 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -410,7 +410,7 @@ static unsigned int __cpuinit intel_size_cache(struct cpuinfo_x86 *c, unsigned i
 }
 #endif
 
-static struct cpu_dev intel_cpu_dev __cpuinitdata = {
+static const struct cpu_dev __cpuinitconst intel_cpu_dev = {
 	.c_vendor	= "Intel",
 	.c_ident	= { "GenuineIntel" },
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 7293508..c471eb1 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -32,7 +32,7 @@ struct _cache_table
 };
 
 /* all the cache descriptor types we care about (no TLB or trace cache entries) */
-static struct _cache_table cache_table[] __cpuinitdata =
+static const struct _cache_table __cpuinitconst cache_table[] =
 {
 	{ 0x06, LVL_1_INST, 8 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x08, LVL_1_INST, 16 },	/* 4-way set assoc, 32 byte line size */
@@ -206,15 +206,15 @@ union l3_cache {
 	unsigned val;
 };
 
-static unsigned short assocs[] __cpuinitdata = {
+static const unsigned short __cpuinitconst assocs[] = {
 	[1] = 1, [2] = 2, [4] = 4, [6] = 8,
 	[8] = 16, [0xa] = 32, [0xb] = 48,
 	[0xc] = 64,
 	[0xf] = 0xffff // ??
 };
 
-static unsigned char levels[] __cpuinitdata = { 1, 1, 2, 3 };
-static unsigned char types[] __cpuinitdata = { 1, 2, 3, 3 };
+static const unsigned char __cpuinitconst levels[] = { 1, 1, 2, 3 };
+static const unsigned char __cpuinitconst types[] = { 1, 2, 3, 3 };
 
 static void __cpuinit
 amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
diff --git a/arch/x86/kernel/cpu/transmeta.c b/arch/x86/kernel/cpu/transmeta.c
index 52b3fef..bb62b3e 100644
--- a/arch/x86/kernel/cpu/transmeta.c
+++ b/arch/x86/kernel/cpu/transmeta.c
@@ -98,7 +98,7 @@ static void __cpuinit init_transmeta(struct cpuinfo_x86 *c)
 #endif
 }
 
-static struct cpu_dev transmeta_cpu_dev __cpuinitdata = {
+static const struct cpu_dev __cpuinitconst transmeta_cpu_dev = {
 	.c_vendor	= "Transmeta",
 	.c_ident	= { "GenuineTMx86", "TransmetaCPU" },
 	.c_early_init	= early_init_transmeta,
diff --git a/arch/x86/kernel/cpu/umc.c b/arch/x86/kernel/cpu/umc.c
index e777f79..fd2c37b 100644
--- a/arch/x86/kernel/cpu/umc.c
+++ b/arch/x86/kernel/cpu/umc.c
@@ -8,7 +8,7 @@
  * so no special init takes place.
  */
 
-static struct cpu_dev umc_cpu_dev __cpuinitdata = {
+static const struct cpu_dev __cpuinitconst umc_cpu_dev = {
 	.c_vendor	= "UMC",
 	.c_ident	= { "UMC UMC UMC" },
 	.c_models = {
diff --git a/arch/x86/kernel/mmconf-fam10h_64.c b/arch/x86/kernel/mmconf-fam10h_64.c
index 666e43d..712d15f 100644
--- a/arch/x86/kernel/mmconf-fam10h_64.c
+++ b/arch/x86/kernel/mmconf-fam10h_64.c
@@ -226,7 +226,7 @@ static int __devinit set_check_enable_amd_mmconf(const struct dmi_system_id *d)
         return 0;
 }
 
-static struct dmi_system_id __devinitdata mmconf_dmi_table[] = {
+static const struct dmi_system_id __cpuinitconst mmconf_dmi_table[] = {
         {
                 .callback = set_check_enable_amd_mmconf,
                 .ident = "Sun Microsystems Machine",
