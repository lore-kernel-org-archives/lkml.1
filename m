Return-Path: <linux-kernel-owner+w=401wt.eu-S1756614AbYLOOW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756614AbYLOOW5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:22:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbYLOOTH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:19:07 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:57186 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbYLOOTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:19:05 -0500
X-BigFish: VPS3(zzzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBX938-03-002-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 14/22] AMD IOMMU: add stats counter for map_sg requests
Date: Mon, 15 Dec 2008 15:17:57 +0100
Message-ID: <1229350685-3816-15-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0303 (UTC) FILETIME=[F2DBDEF0:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see number of map_sg requests in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 18f26eb..bb0e03e 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -66,6 +66,7 @@ static struct dma_ops_domain *find_protection_domain(u16 devid);
 DECLARE_STATS_COUNTER(compl_wait);
 DECLARE_STATS_COUNTER(cnt_map_single);
 DECLARE_STATS_COUNTER(cnt_unmap_single);
+DECLARE_STATS_COUNTER(cnt_map_sg);
 
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
@@ -95,6 +96,7 @@ static void amd_iommu_stats_init(void)
 	amd_iommu_stats_add(&compl_wait);
 	amd_iommu_stats_add(&cnt_map_single);
 	amd_iommu_stats_add(&cnt_unmap_single);
+	amd_iommu_stats_add(&cnt_map_sg);
 }
 
 #endif
@@ -1376,6 +1378,8 @@ static int map_sg(struct device *dev, struct scatterlist *sglist,
 	int mapped_elems = 0;
 	u64 dma_mask;
 
+	INC_STATS_COUNTER(cnt_map_sg);
+
 	if (!check_device(dev))
 		return 0;
 
-- 
1.5.6.4


