Return-Path: <linux-kernel-owner+w=401wt.eu-S1030366AbXBTS61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030366AbXBTS61 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 13:58:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030368AbXBTS61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 13:58:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030366AbXBTS61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 13:58:27 -0500
Date: Tue, 20 Feb 2007 13:58:23 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rgooch@atnf.csiro.au, rhkernel-list@redhat.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070220185823.24685.58172.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: __init to __cpuinit fixes in mtrr code
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

__init to __cpuinit in mtrr code.

Resolves warnings similar to:

WARNING: vmlinux - Section mismatch: reference to .init.text:mtrr_bp_init from .text between 'identify_cpu' (at offset 0xc040b38e) and 'detect_ht'

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/i386/kernel/cpu/mtrr/generic.c b/arch/i386/kernel/cpu/mtrr/generic.c
index f77fc53..fd97f84 100644
--- a/arch/i386/kernel/cpu/mtrr/generic.c
+++ b/arch/i386/kernel/cpu/mtrr/generic.c
@@ -30,14 +30,14 @@ static __initdata int mtrr_show;
 module_param_named(show, mtrr_show, bool, 0);
 
 /*  Get the MSR pair relating to a var range  */
-static void __init
+static void __cpuinit
 get_mtrr_var_range(unsigned int index, struct mtrr_var_range *vr)
 {
 	rdmsr(MTRRphysBase_MSR(index), vr->base_lo, vr->base_hi);
 	rdmsr(MTRRphysMask_MSR(index), vr->mask_lo, vr->mask_hi);
 }
 
-static void __init
+static void __cpuinit
 get_fixed_ranges(mtrr_type * frs)
 {
 	unsigned int *p = (unsigned int *) frs;
@@ -60,7 +60,7 @@ static void __init print_fixed(unsigned base, unsigned step, const mtrr_type*typ
 }
 
 /*  Grab all of the MTRR state for this CPU into *state  */
-void __init get_mtrr_state(void)
+void __cpuinit get_mtrr_state(void)
 {
 	unsigned int i;
 	struct mtrr_var_range *vrs;
diff --git a/arch/i386/kernel/cpu/mtrr/main.c b/arch/i386/kernel/cpu/mtrr/main.c
index 0acfb6a..cdbca55 100644
--- a/arch/i386/kernel/cpu/mtrr/main.c
+++ b/arch/i386/kernel/cpu/mtrr/main.c
@@ -103,7 +103,7 @@ static int have_wrcomb(void)
 }
 
 /*  This function returns the number of variable MTRRs  */
-static void __init set_num_var_ranges(void)
+static void __cpuinit set_num_var_ranges(void)
 {
 	unsigned long config = 0, dummy;
 
@@ -116,7 +116,7 @@ static void __init set_num_var_ranges(void)
 	num_var_ranges = config & 0xff;
 }
 
-static void __init init_table(void)
+static void __cpuinit init_table(void)
 {
 	int i, max;
 
@@ -571,7 +571,7 @@ extern void amd_init_mtrr(void);
 extern void cyrix_init_mtrr(void);
 extern void centaur_init_mtrr(void);
 
-static void __init init_ifs(void)
+static void __cpuinit init_ifs(void)
 {
 #ifndef CONFIG_X86_64
 	amd_init_mtrr();
@@ -639,7 +639,7 @@ static struct sysdev_driver mtrr_sysdev_driver = {
  * initialized (i.e. before smp_init()).
  * 
  */
-void __init mtrr_bp_init(void)
+void __cpuinit mtrr_bp_init(void)
 {
 	init_ifs();
 
