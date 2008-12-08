Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbYLHLx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbYLHLx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753467AbYLHLid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:33 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48241 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284AbYLHLhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:04 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>
Subject: [PATCH 16/45] x86: Rename mtrr_state struct and macro names
Date: Mon,  8 Dec 2008 13:36:27 +0200
Message-Id: <1228736216-15787-17-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sheng Yang <sheng@linux.intel.com>

Prepare for exporting them.

Signed-off-by: Sheng Yang <sheng@linux.intel.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kernel/cpu/mtrr/generic.c |    8 ++++----
 arch/x86/kernel/cpu/mtrr/main.c    |    4 ++--
 arch/x86/kernel/cpu/mtrr/mtrr.h    |    7 ++++---
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 4e8d77f..90db91e 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -14,9 +14,9 @@
 #include <asm/pat.h>
 #include "mtrr.h"
 
-struct mtrr_state {
-	struct mtrr_var_range var_ranges[MAX_VAR_RANGES];
-	mtrr_type fixed_ranges[NUM_FIXED_RANGES];
+struct mtrr_state_type {
+	struct mtrr_var_range var_ranges[MTRR_MAX_VAR_RANGES];
+	mtrr_type fixed_ranges[MTRR_NUM_FIXED_RANGES];
 	unsigned char enabled;
 	unsigned char have_fixed;
 	mtrr_type def_type;
@@ -35,7 +35,7 @@ static struct fixed_range_block fixed_range_blocks[] = {
 };
 
 static unsigned long smp_changes_mask;
-static struct mtrr_state mtrr_state = {};
+static struct mtrr_state_type mtrr_state = {};
 static int mtrr_state_set;
 u64 mtrr_tom2;
 
diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index c78c048..c091d06 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -49,7 +49,7 @@
 
 u32 num_var_ranges = 0;
 
-unsigned int mtrr_usage_table[MAX_VAR_RANGES];
+unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
@@ -574,7 +574,7 @@ struct mtrr_value {
 	unsigned long	lsize;
 };
 
-static struct mtrr_value mtrr_state[MAX_VAR_RANGES];
+static struct mtrr_value mtrr_state[MTRR_MAX_VAR_RANGES];
 
 static int mtrr_save(struct sys_device * sysdev, pm_message_t state)
 {
diff --git a/arch/x86/kernel/cpu/mtrr/mtrr.h b/arch/x86/kernel/cpu/mtrr/mtrr.h
index 2dc4ec6..9885382 100644
--- a/arch/x86/kernel/cpu/mtrr/mtrr.h
+++ b/arch/x86/kernel/cpu/mtrr/mtrr.h
@@ -11,8 +11,9 @@
 #define MTRRphysBase_MSR(reg) (0x200 + 2 * (reg))
 #define MTRRphysMask_MSR(reg) (0x200 + 2 * (reg) + 1)
 
-#define NUM_FIXED_RANGES 88
-#define MAX_VAR_RANGES 256
+#define MTRR_NUM_FIXED_RANGES 88
+#define MTRR_MAX_VAR_RANGES 256
+
 #define MTRRfix64K_00000_MSR 0x250
 #define MTRRfix16K_80000_MSR 0x258
 #define MTRRfix16K_A0000_MSR 0x259
@@ -33,7 +34,7 @@
    an 8 bit field: */
 typedef u8 mtrr_type;
 
-extern unsigned int mtrr_usage_table[MAX_VAR_RANGES];
+extern unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 
 struct mtrr_ops {
 	u32	vendor;
-- 
1.6.0.3

