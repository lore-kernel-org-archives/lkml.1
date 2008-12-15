Return-Path: <linux-kernel-owner+w=401wt.eu-S1756602AbYLOOWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbYLOOWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755115AbYLOOTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:19:05 -0500
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:12879 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755077AbYLOOTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:19:03 -0500
X-BigFish: VPS3(zzzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KBX938-03-009-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 15/22] AMD IOMMU: add stats counter for unmap_sg requests
Date: Mon, 15 Dec 2008 15:17:58 +0100
Message-ID: <1229350685-3816-16-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0350 (UTC) FILETIME=[F2E30AE0:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see number of unmap_sg requests in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index bb0e03e..a2022de 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -67,6 +67,7 @@ DECLARE_STATS_COUNTER(compl_wait);
 DECLARE_STATS_COUNTER(cnt_map_single);
 DECLARE_STATS_COUNTER(cnt_unmap_single);
 DECLARE_STATS_COUNTER(cnt_map_sg);
+DECLARE_STATS_COUNTER(cnt_unmap_sg);
 
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
@@ -97,6 +98,7 @@ static void amd_iommu_stats_init(void)
 	amd_iommu_stats_add(&cnt_map_single);
 	amd_iommu_stats_add(&cnt_unmap_single);
 	amd_iommu_stats_add(&cnt_map_sg);
+	amd_iommu_stats_add(&cnt_unmap_sg);
 }
 
 #endif
@@ -1442,6 +1444,8 @@ static void unmap_sg(struct device *dev, struct scatterlist *sglist,
 	u16 devid;
 	int i;
 
+	INC_STATS_COUNTER(cnt_unmap_sg);
+
 	if (!check_device(dev) ||
 	    !get_device_resources(dev, &iommu, &domain, &devid))
 		return;
-- 
1.5.6.4


