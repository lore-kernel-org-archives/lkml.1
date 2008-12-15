Return-Path: <linux-kernel-owner+w=401wt.eu-S1757250AbYLOOYo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250AbYLOOYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:24:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbYLOOTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:19:18 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:58206 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755233AbYLOOTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:19:16 -0500
X-BigFish: VPS3(zzzzzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBX938-03-00K-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 20/22] AMD IOMMU: add stats counter for domain tlb flushes
Date: Mon, 15 Dec 2008 15:18:03 +0100
Message-ID: <1229350685-3816-21-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:06.0507 (UTC) FILETIME=[F2FAFFB0:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: see number of domain tlb flushes in debugfs

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 8490a06..be6d107 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -72,6 +72,7 @@ DECLARE_STATS_COUNTER(cnt_alloc_coherent);
 DECLARE_STATS_COUNTER(cnt_free_coherent);
 DECLARE_STATS_COUNTER(cross_page);
 DECLARE_STATS_COUNTER(domain_flush_single);
+DECLARE_STATS_COUNTER(domain_flush_all);
 
 static struct dentry *stats_dir;
 static struct dentry *de_isolate;
@@ -107,6 +108,7 @@ static void amd_iommu_stats_init(void)
 	amd_iommu_stats_add(&cnt_free_coherent);
 	amd_iommu_stats_add(&cross_page);
 	amd_iommu_stats_add(&domain_flush_single);
+	amd_iommu_stats_add(&domain_flush_all);
 }
 
 #endif
@@ -430,6 +432,8 @@ static void iommu_flush_domain(u16 domid)
 	struct amd_iommu *iommu;
 	struct iommu_cmd cmd;
 
+	INC_STATS_COUNTER(domain_flush_all);
+
 	__iommu_build_inv_iommu_pages(&cmd, CMD_INV_IOMMU_ALL_PAGES_ADDRESS,
 				      domid, 1, 1);
 
-- 
1.5.6.4


