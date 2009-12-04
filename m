Return-Path: <linux-kernel-owner+w=401wt.eu-S932529AbZLDWha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbZLDWha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 17:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754401AbZLDWh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 17:37:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55742 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZLDWh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 17:37:26 -0500
Message-ID: <4B198F61.7010304@gmail.com>
Date: Fri, 04 Dec 2009 23:38:25 +0100
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090812)
MIME-Version: 1.0
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 21/31] Constify struct mtrr_ops for 2.6.32 v1
References: <4B198670.2000406@gmail.com>
In-Reply-To: <4B198670.2000406@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>

Constify struct mtrr_ops.

Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/amd.c     |    2 +-
 arch/x86/kernel/cpu/mtrr/centaur.c |    2 +-
 arch/x86/kernel/cpu/mtrr/cyrix.c   |    2 +-
 arch/x86/kernel/cpu/mtrr/generic.c |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c    |    6 +++---
 arch/x86/kernel/cpu/mtrr/mtrr.h    |   22 +++++++++++-----------
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
index 33af141..92ba9cd 100644
--- a/arch/x86/kernel/cpu/mtrr/amd.c
+++ b/arch/x86/kernel/cpu/mtrr/amd.c
@@ -108,7 +108,7 @@ amd_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
 	return 0;
 }
 
-static struct mtrr_ops amd_mtrr_ops = {
+static const struct mtrr_ops amd_mtrr_ops = {
 	.vendor            = X86_VENDOR_AMD,
 	.set               = amd_set_mtrr,
 	.get               = amd_get_mtrr,
diff --git a/arch/x86/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
index de89f14..316fe3e 100644
--- a/arch/x86/kernel/cpu/mtrr/centaur.c
+++ b/arch/x86/kernel/cpu/mtrr/centaur.c
@@ -110,7 +110,7 @@ centaur_validate_add_page(unsigned long base, unsigned long size, unsigned int t
 	return 0;
 }
 
-static struct mtrr_ops centaur_mtrr_ops = {
+static const struct mtrr_ops centaur_mtrr_ops = {
 	.vendor            = X86_VENDOR_CENTAUR,
 	.set               = centaur_set_mcr,
 	.get               = centaur_get_mcr,
diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index 228d982..68a3343 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -265,7 +265,7 @@ static void cyrix_set_all(void)
 	post_set();
 }
 
-static struct mtrr_ops cyrix_mtrr_ops = {
+static const struct mtrr_ops cyrix_mtrr_ops = {
 	.vendor            = X86_VENDOR_CYRIX,
 	.set_all	   = cyrix_set_all,
 	.set               = cyrix_set_arr,
diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 55da0c5..4d75584 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -752,7 +752,7 @@ int positive_have_wrcomb(void)
 /*
  * Generic structure...
  */
-struct mtrr_ops generic_mtrr_ops = {
+const struct mtrr_ops generic_mtrr_ops = {
 	.use_intel_if		= 1,
 	.set_all		= generic_set_all,
 	.get			= generic_get_mtrr,
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 84e83de..fe4622e 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -60,14 +60,14 @@ static DEFINE_MUTEX(mtrr_mutex);
 u64 size_or_mask, size_and_mask;
 static bool mtrr_aps_delayed_init;
 
-static struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM];
+static const struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM];
 
-struct mtrr_ops *mtrr_if;
+const struct mtrr_ops *mtrr_if;
 
 static void set_mtrr(unsigned int reg, unsigned long base,
 		     unsigned long size, mtrr_type type);
 
-void set_mtrr_ops(struct mtrr_ops *ops)
+void set_mtrr_ops(const struct mtrr_ops *ops)
 {
 	if (ops->vendor && ops->vendor < X86_VENDOR_NUM)
 		mtrr_ops[ops->vendor] = ops;
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index a501dee..d94607c 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -12,19 +12,19 @@
 extern unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 
 struct mtrr_ops {
-	u32	vendor;
-	u32	use_intel_if;
-	void	(*set)(unsigned int reg, unsigned long base,
+	const u32	vendor;
+	const u32	use_intel_if;
+	void	(* const set)(unsigned int reg, unsigned long base,
 		       unsigned long size, mtrr_type type);
-	void	(*set_all)(void);
+	void	(* const set_all)(void);
 
-	void	(*get)(unsigned int reg, unsigned long *base,
+	void	(* const get)(unsigned int reg, unsigned long *base,
 		       unsigned long *size, mtrr_type *type);
-	int	(*get_free_region)(unsigned long base, unsigned long size,
+	int	(* const get_free_region)(unsigned long base, unsigned long size,
 				   int replace_reg);
-	int	(*validate_add_page)(unsigned long base, unsigned long size,
+	int	(* const validate_add_page)(unsigned long base, unsigned long size,
 				     unsigned int type);
-	int	(*have_wrcomb)(void);
+	int	(* const have_wrcomb)(void);
 };
 
 extern int generic_get_free_region(unsigned long base, unsigned long size,
@@ -32,7 +32,7 @@ extern int generic_get_free_region(unsigned long base, unsigned long size,
 extern int generic_validate_add_page(unsigned long base, unsigned long size,
 				     unsigned int type);
 
-extern struct mtrr_ops generic_mtrr_ops;
+extern const struct mtrr_ops generic_mtrr_ops;
 
 extern int positive_have_wrcomb(void);
 
@@ -53,10 +53,10 @@ void fill_mtrr_var_range(unsigned int index,
 		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi);
 void get_mtrr_state(void);
 
-extern void set_mtrr_ops(struct mtrr_ops *ops);
+extern void set_mtrr_ops(const struct mtrr_ops *ops);
 
 extern u64 size_or_mask, size_and_mask;
-extern struct mtrr_ops *mtrr_if;
+extern const struct mtrr_ops *mtrr_if;
 
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)
 #define use_intel()	(mtrr_if && mtrr_if->use_intel_if == 1)
