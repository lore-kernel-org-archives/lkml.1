Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbYLOOUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbYLOOUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:20:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754196AbYLOOS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:29 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:6763 "EHLO
	WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbYLOOS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:28 -0500
X-BigFish: VPS3(zzzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KBX92J-04-RHQ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 18/22] AMD IOMMU: add stats counter for cross-page request
Date: Mon, 15 Dec 2008 15:18:01 +0100
Message-ID: <1229350685-3816-19-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0432 (UTC) FILETIME=[F2EF8E00:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see number of requests for more than one page in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a00d20c..02e8c18 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -70,6 +70,7 @@ DECLARE_STATS_COUNTER(cnt_map_sg);
 DECLARE_STATS_COUNTER(cnt_unmap_sg);
 DECLARE_STATS_COUNTER(cnt_alloc_coherent);
 DECLARE_STATS_COUNTER(cnt_free_coherent);
+DECLARE_STATS_COUNTER(cross_page);
 
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
@@ -103,6 +104,7 @@ static void amd_iommu_stats_init(void)
 	amd_iommu_stats_add(&cnt_unmap_sg);
 	amd_iommu_stats_add(&cnt_alloc_coherent);
 	amd_iommu_stats_add(&cnt_free_coherent);
+	amd_iommu_stats_add(&cross_page);
 }
 
 #endif
@@ -1216,6 +1218,9 @@ static dma_addr_t __map_single(struct device *dev,
 	pages = iommu_num_pages(paddr, size, PAGE_SIZE);
 	paddr &= PAGE_MASK;
 
+	if (pages > 1)
+		INC_STATS_COUNTER(cross_page);
+
 	if (align)
 		align_mask = (1UL << get_order(size)) - 1;
 
-- 
1.5.6.4


