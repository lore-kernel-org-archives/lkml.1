Return-Path: <linux-kernel-owner+w=401wt.eu-S1757406AbYLOOZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406AbYLOOZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:25:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbYLOOTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:19:35 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:27409 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbYLOOTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:19:34 -0500
X-BigFish: VPS3(zzzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBX93A-03-00R-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 19/22] AMD IOMMU: add stats counter for single iommu domain tlb flushes
Date: Mon, 15 Dec 2008 15:18:02 +0100
Message-ID: <1229350685-3816-20-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0475 (UTC) FILETIME=[F2F61DB0:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see number of single iommu domain tlb flushes in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 02e8c18..8490a06 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -71,6 +71,7 @@ DECLARE_STATS_COUNTER(cnt_unmap_sg);
 DECLARE_STATS_COUNTER(cnt_alloc_coherent);
 DECLARE_STATS_COUNTER(cnt_free_coherent);
 DECLARE_STATS_COUNTER(cross_page);
+DECLARE_STATS_COUNTER(domain_flush_single);
 
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
@@ -105,6 +106,7 @@ static void amd_iommu_stats_init(void)
 	amd_iommu_stats_add(&cnt_alloc_coherent);
 	amd_iommu_stats_add(&cnt_free_coherent);
 	amd_iommu_stats_add(&cross_page);
+	amd_iommu_stats_add(&domain_flush_single);
 }
 
 #endif
@@ -412,6 +414,8 @@ static void iommu_flush_tlb(struct amd_iommu *iommu, u16 domid)
 {
 	u64 address = CMD_INV_IOMMU_ALL_PAGES_ADDRESS;
 
+	INC_STATS_COUNTER(domain_flush_single);
+
 	iommu_queue_inv_iommu_pages(iommu, address, domid, 0, 1);
 }
 
-- 
1.5.6.4


