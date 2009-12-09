Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZLIHyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZLIHyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 02:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757448AbZLIHyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 02:54:16 -0500
Received: from rere.qmqm.pl ([89.167.52.164]:44280 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757335AbZLIHyJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 02:54:09 -0500
From: =?UTF-8?Q?Micha=C5=82=20Miros=C5=82aw=20?= 
	<mirq-linux@rere.qmqm.pl>
To: linux-kernel@vger.kernel.org
Message-ID: <3-1000-25639-1260344705-9533@rere.qmqm.pl>
In-Reply-To: <1-1000-25639-1260344705-9533@rere.qmqm.pl>
Date: Wed, 9 Dec 2009 05:57:29 +0100
Subject: [PATCH 2/7] mtrr: constify struct mtrr_ops
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
---
 arch/x86/kernel/cpu/mtrr/amd.c     |    2 +-
 arch/x86/kernel/cpu/mtrr/centaur.c |    2 +-
 arch/x86/kernel/cpu/mtrr/cyrix.c   |    2 +-
 arch/x86/kernel/cpu/mtrr/generic.c |    2 +-
 arch/x86/kernel/cpu/mtrr/main.c    |    2 +-
 arch/x86/kernel/cpu/mtrr/mtrr.h    |   10 +++++-----
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/amd.c b/arch/x86/kernel/cpu/mtrr/amd.c
index 2655064..a265df6 100644
--- a/arch/x86/kernel/cpu/mtrr/amd.c
+++ b/arch/x86/kernel/cpu/mtrr/amd.c
@@ -108,7 +108,7 @@ amd_validate_add_page(unsigned long base, unsigned long size, unsigned int type)
 	return 0;
 }
 
-struct mtrr_ops amd_mtrr_ops = {
+const struct mtrr_ops amd_mtrr_ops = {
 	.vendor            = X86_VENDOR_AMD,
 	.set               = amd_set_mtrr,
 	.get               = amd_get_mtrr,
diff --git a/arch/x86/kernel/cpu/mtrr/centaur.c b/arch/x86/kernel/cpu/mtrr/centaur.c
index 02b5429..6cb1a83 100644
--- a/arch/x86/kernel/cpu/mtrr/centaur.c
+++ b/arch/x86/kernel/cpu/mtrr/centaur.c
@@ -110,7 +110,7 @@ centaur_validate_add_page(unsigned long base, unsigned long size, unsigned int t
 	return 0;
 }
 
-struct mtrr_ops centaur_mtrr_ops = {
+const struct mtrr_ops centaur_mtrr_ops = {
 	.vendor            = X86_VENDOR_CENTAUR,
 	.set               = centaur_set_mcr,
 	.get               = centaur_get_mcr,
diff --git a/arch/x86/kernel/cpu/mtrr/cyrix.c b/arch/x86/kernel/cpu/mtrr/cyrix.c
index c964690..f00dcdc 100644
--- a/arch/x86/kernel/cpu/mtrr/cyrix.c
+++ b/arch/x86/kernel/cpu/mtrr/cyrix.c
@@ -265,7 +265,7 @@ static void cyrix_set_all(void)
 	post_set();
 }
 
-struct mtrr_ops cyrix_mtrr_ops = {
+const struct mtrr_ops cyrix_mtrr_ops = {
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
index a35e698..628f3dd 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -60,7 +60,7 @@ static DEFINE_MUTEX(mtrr_mutex);
 u64 size_or_mask, size_and_mask;
 static bool mtrr_aps_delayed_init;
 
-struct mtrr_ops *mtrr_if;
+const struct mtrr_ops *mtrr_if;
 
 static void set_mtrr(unsigned int reg, unsigned long base,
 		     unsigned long size, mtrr_type type);
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index ff7af34..be2867c 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -32,11 +32,11 @@ extern int generic_get_free_region(unsigned long base, unsigned long size,
 extern int generic_validate_add_page(unsigned long base, unsigned long size,
 				     unsigned int type);
 
-extern struct mtrr_ops generic_mtrr_ops;
+extern const struct mtrr_ops generic_mtrr_ops;
 #ifdef CONFIG_X86_32
-extern struct mtrr_ops amd_mtrr_ops;
-extern struct mtrr_ops centaur_mtrr_ops;
-extern struct mtrr_ops cyrix_mtrr_ops;
+extern const struct mtrr_ops amd_mtrr_ops;
+extern const struct mtrr_ops centaur_mtrr_ops;
+extern const struct mtrr_ops cyrix_mtrr_ops;
 #endif
 
 extern int positive_have_wrcomb(void);
@@ -59,7 +59,7 @@ void fill_mtrr_var_range(unsigned int index,
 void get_mtrr_state(void);
 
 extern u64 size_or_mask, size_and_mask;
-extern struct mtrr_ops *mtrr_if;
+extern const struct mtrr_ops *mtrr_if;
 
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)
 #define use_intel()	(mtrr_if && mtrr_if->use_intel_if == 1)
-- 
1.6.4.4

