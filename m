Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbZGDKJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbZGDKJB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbZGDKIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:08:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:47450 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755914AbZGDKId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:08:33 -0400
Date: Sat, 4 Jul 2009 10:07:52 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090703164225.GA21447@elte.hu>
References: <20090703164225.GA21447@elte.hu>
Subject: [tip:x86/cleanups] x86: Clean up mtrr/mtrr.h
Message-ID: <tip-3ec8dbcb09bb6df83993ca03e88cb85e3aaa8edb@git.kernel.org>
Git-Commit-ID: 3ec8dbcb09bb6df83993ca03e88cb85e3aaa8edb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 10:07:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3ec8dbcb09bb6df83993ca03e88cb85e3aaa8edb
Gitweb:     http://git.kernel.org/tip/3ec8dbcb09bb6df83993ca03e88cb85e3aaa8edb
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 4 Jul 2009 07:54:16 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 4 Jul 2009 11:19:52 +0200

x86: Clean up mtrr/mtrr.h

Fix:

  ERROR: do not use C99 // comments
  ERROR: "foo * bar" should be "foo *bar" X 2

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090703164225.GA21447@elte.hu>
[ More tidyups ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/mtrr.h |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 7538b76..a501dee 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -1,5 +1,5 @@
 /*
- * local mtrr defines.
+ * local MTRR defines.
  */
 
 #include <linux/types.h>
@@ -14,13 +14,12 @@ extern unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 struct mtrr_ops {
 	u32	vendor;
 	u32	use_intel_if;
-//	void	(*init)(void);
 	void	(*set)(unsigned int reg, unsigned long base,
 		       unsigned long size, mtrr_type type);
 	void	(*set_all)(void);
 
 	void	(*get)(unsigned int reg, unsigned long *base,
-		       unsigned long *size, mtrr_type * type);
+		       unsigned long *size, mtrr_type *type);
 	int	(*get_free_region)(unsigned long base, unsigned long size,
 				   int replace_reg);
 	int	(*validate_add_page)(unsigned long base, unsigned long size,
@@ -39,11 +38,11 @@ extern int positive_have_wrcomb(void);
 
 /* library functions for processor-specific routines */
 struct set_mtrr_context {
-	unsigned long flags;
-	unsigned long cr4val;
-	u32 deftype_lo;
-	u32 deftype_hi;
-	u32 ccr3;
+	unsigned long	flags;
+	unsigned long	cr4val;
+	u32		deftype_lo;
+	u32		deftype_hi;
+	u32		ccr3;
 };
 
 void set_mtrr_done(struct set_mtrr_context *ctxt);
@@ -54,10 +53,10 @@ void fill_mtrr_var_range(unsigned int index,
 		u32 base_lo, u32 base_hi, u32 mask_lo, u32 mask_hi);
 void get_mtrr_state(void);
 
-extern void set_mtrr_ops(struct mtrr_ops * ops);
+extern void set_mtrr_ops(struct mtrr_ops *ops);
 
 extern u64 size_or_mask, size_and_mask;
-extern struct mtrr_ops * mtrr_if;
+extern struct mtrr_ops *mtrr_if;
 
 #define is_cpu(vnd)	(mtrr_if && mtrr_if->vendor == X86_VENDOR_##vnd)
 #define use_intel()	(mtrr_if && mtrr_if->use_intel_if == 1)
