Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZCENJM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZCENJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 08:09:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754004AbZCENIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 08:08:38 -0500
Received: from smtp-68.nebula.fi ([83.145.220.68]:39564 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827AbZCENIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 08:08:37 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 12/17] x86: ifdef 32-bit and 64-bit NR_RANGE_MR for save_mr() unification
Date: Thu,  5 Mar 2009 14:55:03 +0200
Message-Id: <1236257708-27269-12-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

As a trivial preparation for moving common code to arc/x86/mm/init.c, ifdef the
32-bit and 64-bit versions of NR_RANGE_MR.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init_32.c |    4 ++++
 arch/x86/mm/init_64.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 34760e4..f59e9b8 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -900,7 +900,11 @@ struct map_range {
 	unsigned page_size_mask;
 };
 
+#ifdef CONFIG_X86_32
 #define NR_RANGE_MR 3
+#else /* CONFIG_X86_64 */
+#define NR_RANGE_MR 5
+#endif
 
 static int save_mr(struct map_range *mr, int nr_range,
 		   unsigned long start_pfn, unsigned long end_pfn,
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d99bc6a..d101990 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -660,7 +660,11 @@ struct map_range {
 	unsigned page_size_mask;
 };
 
+#ifdef CONFIG_X86_32
+#define NR_RANGE_MR 3
+#else /* CONFIG_X86_64 */
 #define NR_RANGE_MR 5
+#endif
 
 static int save_mr(struct map_range *mr, int nr_range,
 		   unsigned long start_pfn, unsigned long end_pfn,
-- 
1.5.4.3

