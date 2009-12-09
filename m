Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbZLIHyM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbZLIHyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:54:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbZLIHyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:54:10 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:44279 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbZLIHyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:54:09 -0500
X-Greylist: delayed 548 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Dec 2009 02:54:08 EST
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org
Message-ID: <2-1000-25639-1260344705-9533@rere.qmqm.pl>
In-Reply-To: <1-1000-25639-1260344705-9533@rere.qmqm.pl>
Date: Wed, 9 Dec 2009 05:51:56 +0100
Subject: [PATCH 1/7] x86/mtrr: Remove mtrr_ops[]
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove mtrr_ops[] - it's contents are always the same and all this
registration thing only adds useless code.

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 arch/x86/kernel/cpu/mtrr/amd.c     |    7 +------
 arch/x86/kernel/cpu/mtrr/centaur.c |    7 +------
 arch/x86/kernel/cpu/mtrr/cyrix.c   |    7 +------
 arch/x86/kernel/cpu/mtrr/main.c    |   32 +++++---------------------------
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    7 +++++--
 5 files changed, 13 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
index 33af141..2655064 100644
--- a/arch/x86/kernel/cpu/mtrr/amd.c
+++ b/arch/x86/kernel/cpu/mtrr/amd.c
@@ -108,7 +108,7 @@ amd_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
 	return 0;
 }
 
-static struct mtrr_ops amd_mtrr_ops = {
+struct mtrr_ops amd_mtrr_ops = {
 	.vendor            = X86_VENDOR_AMD,
 	.set               = amd_set_mtrr,
 	.get               = amd_get_mtrr,
@@ -117,8 +117,3 @@ static struct mtrr_ops amd_mtrr_ops = {
 	.have_wrcomb       = positive_have_wrcomb,
 };
 
-int __init amd_init_mtrr(void)
-{
-	set_mtrr_ops(&amd_mtrr_ops);
-	return 0;
-}
diff --git a/arch/x86/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
index de89f14..02b5429 100644
--- a/arch/x86/kernel/cpu/mtrr/centaur.c
+++ b/arch/x86/kernel/cpu/mtrr/centaur.c
@@ -110,7 +110,7 @@ centaur_validate_add_page(unsigned long base, unsigned long size, unsigned int t
 	return 0;
 }
 
-static struct mtrr_ops centaur_mtrr_ops = {
+struct mtrr_ops centaur_mtrr_ops = {
 	.vendor            = X86_VENDOR_CENTAUR,
 	.set               = centaur_set_mcr,
 	.get               = centaur_get_mcr,
@@ -119,8 +119,3 @@ static struct mtrr_ops centaur_mtrr_ops = {
 	.have_wrcomb       = positive_have_wrcomb,
 };
 
-int __init centaur_init_mtrr(void)
-{
-	set_mtrr_ops(&centaur_mtrr_ops);
-	return 0;
-}
diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index 228d982..c964690 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -265,7 +265,7 @@ static void cyrix_set_all(void)
 	post_set();
 }
 
-static struct mtrr_ops cyrix_mtrr_ops = {
+struct mtrr_ops cyrix_mtrr_ops = {
 	.vendor            = X86_VENDOR_CYRIX,
 	.set_all	   = cyrix_set_all,
 	.set               = cyrix_set_arr,
@@ -275,8 +275,3 @@ static struct mtrr_ops cyrix_mtrr_ops = {
 	.have_wrcomb       = positive_have_wrcomb,
 };
 
-int __init cyrix_init_mtrr(void)
-{
-	set_mtrr_ops(&cyrix_mtrr_ops);
-	return 0;
-}
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 84e83de..a35e698 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -60,19 +60,11 @@ static DEFINE_MUTEX(mtrr_mutex);
 u64 size_or_mask, size_and_mask;
 static bool mtrr_aps_delayed_init;
 
-static struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM];
-
 struct mtrr_ops *mtrr_if;
 
 static void set_mtrr(unsigned int reg, unsigned long base,
 		     unsigned long size, mtrr_type type);
 
-void set_mtrr_ops(struct mtrr_ops *ops)
-{
-	if (ops->vendor && ops->vendor < X86_VENDOR_NUM)
-		mtrr_ops[ops->vendor] = ops;
-}
-
 /*  Returns non-zero if we have the write-combining memory type  */
 static int have_wrcomb(void)
 {
@@ -574,20 +566,6 @@ int mtrr_del(int reg, unsigned long base, unsigned long size)
 }
 EXPORT_SYMBOL(mtrr_del);
 
-/*
- * HACK ALERT!
- * These should be called implicitly, but we can't yet until all the initcall
- * stuff is done...
- */
-static void __init init_ifs(void)
-{
-#ifndef CONFIG_X86_64
-	amd_init_mtrr();
-	cyrix_init_mtrr();
-	centaur_init_mtrr();
-#endif
-}
-
 /* The suspend/resume methods are only for CPU without MTRR. CPU using generic
  * MTRR driver doesn't require this
  */
@@ -645,8 +623,6 @@ void __init mtrr_bp_init(void)
 {
 	u32 phys_addr;
 
-	init_ifs();
-
 	phys_addr = 32;
 
 	if (cpu_has_mtrr) {
@@ -683,25 +659,26 @@ void __init mtrr_bp_init(void)
 			phys_addr = 32;
 		}
 	} else {
+#ifdef CONFIG_X86_32
 		switch (boot_cpu_data.x86_vendor) {
 		case X86_VENDOR_AMD:
 			if (cpu_has_k6_mtrr) {
 				/* Pre-Athlon (K6) AMD CPU MTRRs */
-				mtrr_if = mtrr_ops[X86_VENDOR_AMD];
+				mtrr_if = &amd_mtrr_ops;
 				size_or_mask = 0xfff00000;	/* 32 bits */
 				size_and_mask = 0;
 			}
 			break;
 		case X86_VENDOR_CENTAUR:
 			if (cpu_has_centaur_mcr) {
-				mtrr_if = mtrr_ops[X86_VENDOR_CENTAUR];
+				mtrr_if = &centaur_mtrr_ops;
 				size_or_mask = 0xfff00000;	/* 32 bits */
 				size_and_mask = 0;
 			}
 			break;
 		case X86_VENDOR_CYRIX:
 			if (cpu_has_cyrix_arr) {
-				mtrr_if = mtrr_ops[X86_VENDOR_CYRIX];
+				mtrr_if = &cyrix_mtrr_ops;
 				size_or_mask = 0xfff00000;	/* 32 bits */
 				size_and_mask = 0;
 			}
@@ -709,6 +686,7 @@ void __init mtrr_bp_init(void)
 		default:
 			break;
 		}
+#endif
 	}
 
 	if (mtrr_if) {
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index a501dee..ff7af34 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -33,6 +33,11 @@ extern int generic_validate_add_page(unsigned long base, unsigned long size,
 				     unsigned int type);
 
 extern struct mtrr_ops generic_mtrr_ops;
+#ifdef CONFIG_X86_32
+extern struct mtrr_ops amd_mtrr_ops;
+extern struct mtrr_ops centaur_mtrr_ops;
+extern struct mtrr_ops cyrix_mtrr_ops;
+#endif
 
 extern int positive_have_wrcomb(void);
 
@@ -53,8 +58,6 @@ void fill_mtrr_var_range(unsigned int index,
 		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi);
 void get_mtrr_state(void);
 
-extern void set_mtrr_ops(struct mtrr_ops *ops);
-
 extern u64 size_or_mask, size_and_mask;
 extern struct mtrr_ops *mtrr_if;
 
-- 
1.6.4.4

