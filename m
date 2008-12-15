Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYLOOUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYLOOUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYLOOSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:30 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:54350 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbYLOOS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:28 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBX92E-04-RHI-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 13/22] AMD IOMMU: add stats counter for unmap_single requests
Date: Mon, 15 Dec 2008 15:17:56 +0100
Message-ID: <1229350685-3816-14-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0260 (UTC) FILETIME=[F2D54F40:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see number of unmap_single requests in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 4b23879..18f26eb 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -65,6 +65,7 @@ static struct dma_ops_domain *find_protection_domain(u16 devid);
 
 DECLARE_STATS_COUNTER(compl_wait);
 DECLARE_STATS_COUNTER(cnt_map_single);
+DECLARE_STATS_COUNTER(cnt_unmap_single);
 
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
@@ -93,6 +94,7 @@ static void amd_iommu_stats_init(void)
 
 	amd_iommu_stats_add(&compl_wait);
 	amd_iommu_stats_add(&cnt_map_single);
+	amd_iommu_stats_add(&cnt_unmap_single);
 }
 
 #endif
@@ -1320,6 +1322,8 @@ static void unmap_single(struct device *dev, dma_addr_t dma_addr,
 	struct protection_domain *domain;
 	u16 devid;
 
+	INC_STATS_COUNTER(cnt_unmap_single);
+
 	if (!check_device(dev) ||
 	    !get_device_resources(dev, &iommu, &domain, &devid))
 		/* device not handled by any AMD IOMMU */
-- 
1.5.6.4


