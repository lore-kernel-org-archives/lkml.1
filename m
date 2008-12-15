Return-Path: <linux-kernel-owner+w=401wt.eu-S1757183AbYLOOY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183AbYLOOY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbYLOOTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:19:14 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:25941 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbYLOOTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:19:10 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBX938-03-001-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/22] AMD IOMMU: add stats counter for completion wait events
Date: Mon, 15 Dec 2008 15:17:54 +0100
Message-ID: <1229350685-3816-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0194 (UTC) FILETIME=[F2CB3D20:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see number of completion wait events in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index be1ddca..a494a98 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -63,6 +63,8 @@ static struct dma_ops_domain *find_protection_domain(u16 devid);
  * Initialization code for statistics collection
  */
 
+DECLARE_STATS_COUNTER(compl_wait);
+
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
 static struct dentry *de_fflush;
@@ -87,6 +89,8 @@ static void amd_iommu_stats_init(void)
 
 	de_fflush  = debugfs_create_bool("fullflush", 0444, stats_dir,
 					 (u32 *)&amd_iommu_unmap_flush);
+
+	amd_iommu_stats_add(&compl_wait);
 }
 
 #endif
@@ -248,6 +252,8 @@ static void __iommu_wait_for_completion(struct amd_iommu *iommu)
 	unsigned status = 0;
 	unsigned long i = 0;
 
+	INC_STATS_COUNTER(compl_wait);
+
 	while (!ready && (i < EXIT_LOOP_COUNT)) {
 		++i;
 		/* wait for the bit to become one */
-- 
1.5.6.4


