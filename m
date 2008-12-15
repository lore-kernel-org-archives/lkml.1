Return-Path: <linux-kernel-owner+w=401wt.eu-S1756103AbYLOOVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103AbYLOOVY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:21:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339AbYLOOSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:34 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:22062 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbYLOOSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:33 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KBX92A-04-RHF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 17/22] AMD IOMMU: add stats counter for free_coherent requests
Date: Mon, 15 Dec 2008 15:18:00 +0100
Message-ID: <1229350685-3816-18-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0413 (UTC) FILETIME=[F2ECA7D0:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see number of free_coherent requests in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index e7180e9..a00d20c 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -69,6 +69,7 @@ DECLARE_STATS_COUNTER(cnt_unmap_single);
 DECLARE_STATS_COUNTER(cnt_map_sg);
 DECLARE_STATS_COUNTER(cnt_unmap_sg);
 DECLARE_STATS_COUNTER(cnt_alloc_coherent);
+DECLARE_STATS_COUNTER(cnt_free_coherent);
 
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
@@ -101,6 +102,7 @@ static void amd_iommu_stats_init(void)
 	amd_iommu_stats_add(&cnt_map_sg);
 	amd_iommu_stats_add(&cnt_unmap_sg);
 	amd_iommu_stats_add(&cnt_alloc_coherent);
+	amd_iommu_stats_add(&cnt_free_coherent);
 }
 
 #endif
@@ -1540,6 +1542,8 @@ static void free_coherent(struct device *dev, size_t size,
 	struct protection_domain *domain;
 	u16 devid;
 
+	INC_STATS_COUNTER(cnt_free_coherent);
+
 	if (!check_device(dev))
 		return;
 
-- 
1.5.6.4


