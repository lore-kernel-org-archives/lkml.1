Return-Path: <linux-kernel-owner+w=401wt.eu-S1756378AbYLOOV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbYLOOV6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754602AbYLOOSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:42 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:55357 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577AbYLOOSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:41 -0500
X-BigFish: VPS3(zzzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBX92H-04-RHO-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 16/22] AMD IOMMU: add stats counter for alloc_coherent requests
Date: Mon, 15 Dec 2008 15:17:59 +0100
Message-ID: <1229350685-3816-17-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0369 (UTC) FILETIME=[F2E5F110:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see number of alloc_coherent requests in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a2022de..e7180e9 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -68,6 +68,7 @@ DECLARE_STATS_COUNTER(cnt_map_single);
 DECLARE_STATS_COUNTER(cnt_unmap_single);
 DECLARE_STATS_COUNTER(cnt_map_sg);
 DECLARE_STATS_COUNTER(cnt_unmap_sg);
+DECLARE_STATS_COUNTER(cnt_alloc_coherent);
 
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
@@ -99,6 +100,7 @@ static void amd_iommu_stats_init(void)
 	amd_iommu_stats_add(&cnt_unmap_single);
 	amd_iommu_stats_add(&cnt_map_sg);
 	amd_iommu_stats_add(&cnt_unmap_sg);
+	amd_iommu_stats_add(&cnt_alloc_coherent);
 }
 
 #endif
@@ -1480,6 +1482,8 @@ static void *alloc_coherent(struct device *dev, size_t size,
 	phys_addr_t paddr;
 	u64 dma_mask = dev->coherent_dma_mask;
 
+	INC_STATS_COUNTER(cnt_alloc_coherent);
+
 	if (!check_device(dev))
 		return NULL;
 
-- 
1.5.6.4


