Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab0BATzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 14:55:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:59194 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756014Ab0BATzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 14:55:01 -0500
Date: Mon, 1 Feb 2010 19:54:37 GMT
From: tip-bot for Emese Revfy <re.emese@gmail.com>
Cc: linux-kernel@vger.kernel.org, re.emese@gmail.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, re.emese@gmail.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <4B65D712.3080804@gmail.com>
References: <4B65D712.3080804@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mtrr] x86, mtrr: Constify struct mtrr_ops
Message-ID: <tip-3b9cfc0a99f88c0db7c72363620584a9b40b4543@git.kernel.org>
Git-Commit-ID: 3b9cfc0a99f88c0db7c72363620584a9b40b4543
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 01 Feb 2010 19:54:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3b9cfc0a99f88c0db7c72363620584a9b40b4543
Gitweb:     http://git.kernel.org/tip/3b9cfc0a99f88c0db7c72363620584a9b40b4543
Author:     Emese Revfy <re.emese@gmail.com>
AuthorDate: Sun, 31 Jan 2010 20:16:34 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 1 Feb 2010 11:20:43 -0800

x86, mtrr: Constify struct mtrr_ops

This is part of the ops structure constification
effort started by Arjan van de Ven et al.

Benefits of this constification:

 * prevents modification of data that is shared
   (referenced) by many other structure instances
   at runtime

 * detects/prevents accidental (but not intentional)
   modification attempts on archs that enforce
   read-only kernel data at runtime

 * potentially better optimized code as the compiler
   can assume that the const data cannot be changed

 * the compiler/linker move const data into .rodata
   and therefore exclude them from false sharing

Signed-off-by: Emese Revfy <re.emese@gmail.com>
LKML-Reference: <4B65D712.3080804@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/cpu/mtrr/amd.c     |    2 +-
 arch/x86/kernel/cpu/mtrr/centaur.c |    2 +-
 arch/x86/kernel/cpu/mtrr/cyrix.c   |    2 +-
 arch/x86/kernel/cpu/mtrr/generic.c |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c    |    6 +++---
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    6 +++---
 6 files changed, 10 insertions(+), 10 deletions(-)

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
index a501dee..df5e41f 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
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
