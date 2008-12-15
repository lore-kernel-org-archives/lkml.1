Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbYLOOVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbYLOOVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:21:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754383AbYLOOSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:35 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:54774 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335AbYLOOSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:34 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBX928-04-RHB-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/22] AMD IOMMU: add stats counter for map_single requests
Date: Mon, 15 Dec 2008 15:17:55 +0100
Message-ID: <1229350685-3816-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0225 (UTC) FILETIME=[F2CFF810:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see number of map_single requests in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index a494a98..4b23879 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -64,6 +64,7 @@ static struct dma_ops_domain *find_protection_domain(u16 devid);
  */
 
 DECLARE_STATS_COUNTER(compl_wait);
+DECLARE_STATS_COUNTER(cnt_map_single);
 
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
@@ -91,6 +92,7 @@ static void amd_iommu_stats_init(void)
 					 (u32 *)&amd_iommu_unmap_flush);
 
 	amd_iommu_stats_add(&compl_wait);
+	amd_iommu_stats_add(&cnt_map_single);
 }
 
 #endif
@@ -1277,6 +1279,8 @@ static dma_addr_t map_single(struct device *dev, phys_addr_t paddr,
 	dma_addr_t addr;
 	u64 dma_mask;
 
+	INC_STATS_COUNTER(cnt_map_single);
+
 	if (!check_device(dev))
 		return bad_dma_address;
 
-- 
1.5.6.4


