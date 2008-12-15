Return-Path: <linux-kernel-owner+w=401wt.eu-S1756488AbYLOOWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488AbYLOOWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754605AbYLOOTB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:19:01 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:26121 "EHLO
	VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbYLOOS7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:59 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KBX938-03-00H-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 22/22] AMD IOMMU: add statistics about total number of map requests
Date: Mon, 15 Dec 2008 15:18:05 +0100
Message-ID: <1229350685-3816-23-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0569 (UTC) FILETIME=[F3047590:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see total number of map requests in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 9c34902..c8d4301 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -74,6 +74,7 @@ DECLARE_STATS_COUNTER(cross_page);
 DECLARE_STATS_COUNTER(domain_flush_single);
 DECLARE_STATS_COUNTER(domain_flush_all);
 DECLARE_STATS_COUNTER(alloced_io_mem);
+DECLARE_STATS_COUNTER(total_map_requests);
 
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
@@ -111,6 +112,7 @@ static void amd_iommu_stats_init(void)
 	amd_iommu_stats_add(&domain_flush_single);
 	amd_iommu_stats_add(&domain_flush_all);
 	amd_iommu_stats_add(&alloced_io_mem);
+	amd_iommu_stats_add(&total_map_requests);
 }
 
 #endif
@@ -1228,6 +1230,8 @@ static dma_addr_t __map_single(struct device *dev,
 	pages = iommu_num_pages(paddr, size, PAGE_SIZE);
 	paddr &= PAGE_MASK;
 
+	INC_STATS_COUNTER(total_map_requests);
+
 	if (pages > 1)
 		INC_STATS_COUNTER(cross_page);
 
-- 
1.5.6.4


