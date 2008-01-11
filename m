Return-Path: <linux-kernel-owner+w=401wt.eu-S1760672AbYAKI4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760672AbYAKI4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 03:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbYAKI40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 03:56:26 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:31346
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755433AbYAKI4Y convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 03:56:24 -0500
Message-Id: <47873D5C.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 11 Jan 2008 08:56:44 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>
Subject: [PATCH 2/4] use __cpuinitconst for x86
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch probably doesn't change all instances where 'const' could
have been added as a result of the base structure changes, only where
the change has a real effect (the module loader doesn't enforce
read-only section attributes at present, so only built-in files make a
real difference).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/cpu/amd.c             |    2 +-
 arch/x86/kernel/cpu/centaur.c         |    2 +-
 arch/x86/kernel/cpu/common.c          |   14 +++++++-------
 arch/x86/kernel/cpu/cpu.h             |    8 ++++----
 arch/x86/kernel/cpu/cyrix.c           |   16 ++++++++--------
 arch/x86/kernel/cpu/intel.c           |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c |    8 ++++----
 arch/x86/kernel/cpu/nexgen.c          |    2 +-
 arch/x86/kernel/cpu/transmeta.c       |    2 +-
 arch/x86/kernel/cpu/umc.c             |    2 +-
 10 files changed, 29 insertions(+), 29 deletions(-)

--- 2.6.24-rc7-initconst.orig/arch/x86/kernel/cpu/amd.c
+++ 2.6.24-rc7-initconst/arch/x86/kernel/cpu/amd.c
@@ -316,7 +316,7 @@ static unsigned int __cpuinit amd_size_c
 	return size;
 }
 
-static struct cpu_dev amd_cpu_dev __cpuinitdata = {
+static struct cpu_dev __cpuinitconst amd_cpu_dev = {
 	.c_vendor	= "AMD",
 	.c_ident 	= { "AuthenticAMD" },
 	.c_models = {
--- 2.6.24-rc7-initconst.orig/arch/x86/kernel/cpu/centaur.c
+++ 2.6.24-rc7-initconst/arch/x86/kernel/cpu/centaur.c
@@ -457,7 +457,7 @@ static unsigned int __cpuinit centaur_si
 	return size;
 }
 
-static struct cpu_dev centaur_cpu_dev __cpuinitdata = {
+static struct cpu_dev __cpuinitconst centaur_cpu_dev = {
 	.c_vendor	= "Centaur",
 	.c_ident	= { "CentaurHauls" },
 	.c_init		= init_centaur,
--- 2.6.24-rc7-initconst.orig/arch/x86/kernel/cpu/common.c
+++ 2.6.24-rc7-initconst/arch/x86/kernel/cpu/common.c
@@ -55,7 +55,7 @@ static int disable_x86_fxsr __cpuinitdat
 static int disable_x86_serial_nr __cpuinitdata = 1;
 static int disable_x86_sep __cpuinitdata;
 
-struct cpu_dev * cpu_devs[X86_VENDOR_NUM] = {};
+const struct cpu_dev * __cpuinitdata cpu_devs[X86_VENDOR_NUM] = {};
 
 extern int disable_pse;
 
@@ -72,11 +72,11 @@ static void __cpuinit default_init(struc
 	}
 }
 
-static struct cpu_dev __cpuinitdata default_cpu = {
+static struct cpu_dev __cpuinitconst default_cpu = {
 	.c_init	= default_init,
 	.c_vendor = "Unknown",
 };
-static struct cpu_dev * this_cpu __cpuinitdata = &default_cpu;
+static const struct cpu_dev * this_cpu __cpuinitdata = &default_cpu;
 
 static int __init cachesize_setup(char *str)
 {
@@ -156,9 +156,9 @@ void __cpuinit display_cacheinfo(struct 
 /* in particular, if CPUID levels 0x80000002..4 are supported, this isn't used */
 
 /* Look up CPU names by table lookup. */
-static char __cpuinit *table_lookup_model(struct cpuinfo_x86 *c)
+static const char *__cpuinit table_lookup_model(struct cpuinfo_x86 *c)
 {
-	struct cpu_model_info *info;
+	const struct cpu_model_info *info;
 
 	if ( c->x86_model >= 16 )
 		return NULL;	/* Range check */
@@ -472,7 +472,7 @@ static void __cpuinit identify_cpu(struc
 
 	/* If the model name is still unset, do table lookup. */
 	if ( !c->x86_model_id[0] ) {
-		char *p;
+		const char *p;
 		p = table_lookup_model(c);
 		if ( p )
 			strcpy(c->x86_model_id, p);
@@ -569,7 +569,7 @@ void __cpuinit detect_ht(struct cpuinfo_
 
 void __cpuinit print_cpu_info(struct cpuinfo_x86 *c)
 {
-	char *vendor = NULL;
+	const char *vendor = NULL;
 
 	if (c->x86_vendor < X86_VENDOR_NUM)
 		vendor = this_cpu->c_vendor;
--- 2.6.24-rc7-initconst.orig/arch/x86/kernel/cpu/cpu.h
+++ 2.6.24-rc7-initconst/arch/x86/kernel/cpu/cpu.h
@@ -2,15 +2,15 @@
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
 
@@ -19,7 +19,7 @@ struct cpu_dev {
 	unsigned int	(*c_size_cache)(struct cpuinfo_x86 * c, unsigned int size);
 };
 
-extern struct cpu_dev * cpu_devs [X86_VENDOR_NUM];
+extern const struct cpu_dev * cpu_devs [X86_VENDOR_NUM];
 
 extern int get_model_name(struct cpuinfo_x86 *c);
 extern void display_cacheinfo(struct cpuinfo_x86 *c);
--- 2.6.24-rc7-initconst.orig/arch/x86/kernel/cpu/cyrix.c
+++ 2.6.24-rc7-initconst/arch/x86/kernel/cpu/cyrix.c
@@ -56,23 +56,23 @@ static void __cpuinit do_cyrix_devid(uns
  */
 static unsigned char Cx86_dir0_msb __cpuinitdata = 0;
 
-static char Cx86_model[][9] __cpuinitdata = {
+static char __cpuinitconst Cx86_model[][9] = {
 	"Cx486", "Cx486", "5x86 ", "6x86", "MediaGX ", "6x86MX ",
 	"M II ", "Unknown"
 };
-static char Cx486_name[][5] __cpuinitdata = {
+static char __cpuinitconst Cx486_name[][5] = {
 	"SLC", "DLC", "SLC2", "DLC2", "SRx", "DRx",
 	"SRx2", "DRx2"
 };
-static char Cx486S_name[][4] __cpuinitdata = {
+static char __cpuinitconst Cx486S_name[][4] = {
 	"S", "S2", "Se", "S2e"
 };
-static char Cx486D_name[][4] __cpuinitdata = {
+static char __cpuinitconst Cx486D_name[][4] = {
 	"DX", "DX2", "?", "?", "?", "DX4"
 };
 static char Cx86_cb[] __cpuinitdata = "?.5x Core/Bus Clock";
-static char cyrix_model_mult1[] __cpuinitdata = "12??43";
-static char cyrix_model_mult2[] __cpuinitdata = "12233445";
+static char __cpuinitconst cyrix_model_mult1[] = "12??43";
+static char __cpuinitconst cyrix_model_mult2[] = "12233445";
 
 /*
  * Reset the slow-loop (SLOP) bit on the 686(L) which is set by some old
@@ -436,7 +436,7 @@ static void __cpuinit cyrix_identify(str
 	}
 }
 
-static struct cpu_dev cyrix_cpu_dev __cpuinitdata = {
+static struct cpu_dev __cpuinitconst cyrix_cpu_dev = {
 	.c_vendor	= "Cyrix",
 	.c_ident 	= { "CyrixInstead" },
 	.c_init		= init_cyrix,
@@ -449,7 +449,7 @@ int __init cyrix_init_cpu(void)
 	return 0;
 }
 
-static struct cpu_dev nsc_cpu_dev __cpuinitdata = {
+static struct cpu_dev __cpuinitconst nsc_cpu_dev = {
 	.c_vendor	= "NSC",
 	.c_ident 	= { "Geode by NSC" },
 	.c_init		= init_nsc,
--- 2.6.24-rc7-initconst.orig/arch/x86/kernel/cpu/intel.c
+++ 2.6.24-rc7-initconst/arch/x86/kernel/cpu/intel.c
@@ -233,7 +233,7 @@ static unsigned int __cpuinit intel_size
 	return size;
 }
 
-static struct cpu_dev intel_cpu_dev __cpuinitdata = {
+static struct cpu_dev __cpuinitconst intel_cpu_dev = {
 	.c_vendor	= "Intel",
 	.c_ident 	= { "GenuineIntel" },
 	.c_models = {
--- 2.6.24-rc7-initconst.orig/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ 2.6.24-rc7-initconst/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -31,7 +31,7 @@ struct _cache_table
 };
 
 /* all the cache descriptor types we care about (no TLB or trace cache entries) */
-static struct _cache_table cache_table[] __cpuinitdata =
+static struct _cache_table __cpuinitconst cache_table[] =
 {
 	{ 0x06, LVL_1_INST, 8 },	/* 4-way set assoc, 32 byte line size */
 	{ 0x08, LVL_1_INST, 16 },	/* 4-way set assoc, 32 byte line size */
@@ -171,15 +171,15 @@ union l3_cache {
 	unsigned val;
 };
 
-static unsigned short assocs[] __cpuinitdata = {
+static unsigned short __cpuinitconst assocs[] = {
 	[1] = 1, [2] = 2, [4] = 4, [6] = 8,
 	[8] = 16, [0xa] = 32, [0xb] = 48,
 	[0xc] = 64,
 	[0xf] = 0xffff // ??
 };
 
-static unsigned char levels[] __cpuinitdata = { 1, 1, 2, 3 };
-static unsigned char types[] __cpuinitdata = { 1, 2, 3, 3 };
+static unsigned char __cpuinitconst levels[] = { 1, 1, 2, 3 };
+static unsigned char __cpuinitconst types[] = { 1, 2, 3, 3 };
 
 static void __cpuinit amd_cpuid4(int leaf, union _cpuid4_leaf_eax *eax,
 		       union _cpuid4_leaf_ebx *ebx,
--- 2.6.24-rc7-initconst.orig/arch/x86/kernel/cpu/nexgen.c
+++ 2.6.24-rc7-initconst/arch/x86/kernel/cpu/nexgen.c
@@ -40,7 +40,7 @@ static void __cpuinit nexgen_identify(st
 	}
 }
 
-static struct cpu_dev nexgen_cpu_dev __cpuinitdata = {
+static struct cpu_dev __cpuinitconst nexgen_cpu_dev = {
 	.c_vendor	= "Nexgen",
 	.c_ident	= { "NexGenDriven" },
 	.c_models = {
--- 2.6.24-rc7-initconst.orig/arch/x86/kernel/cpu/transmeta.c
+++ 2.6.24-rc7-initconst/arch/x86/kernel/cpu/transmeta.c
@@ -102,7 +102,7 @@ static void __cpuinit transmeta_identify
 	}
 }
 
-static struct cpu_dev transmeta_cpu_dev __cpuinitdata = {
+static struct cpu_dev __cpuinitconst transmeta_cpu_dev = {
 	.c_vendor	= "Transmeta",
 	.c_ident	= { "GenuineTMx86", "TransmetaCPU" },
 	.c_init		= init_transmeta,
--- 2.6.24-rc7-initconst.orig/arch/x86/kernel/cpu/umc.c
+++ 2.6.24-rc7-initconst/arch/x86/kernel/cpu/umc.c
@@ -6,7 +6,7 @@
 /* UMC chips appear to be only either 386 or 486, so no special init takes place.
  */
 
-static struct cpu_dev umc_cpu_dev __cpuinitdata = {
+static struct cpu_dev __cpuinitconst umc_cpu_dev = {
 	.c_vendor	= "UMC",
 	.c_ident 	= { "UMC UMC UMC" },
 	.c_models = {


