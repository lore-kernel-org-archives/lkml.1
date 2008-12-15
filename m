Return-Path: <linux-kernel-owner+w=401wt.eu-S1754893AbYLOOSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbYLOOSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbYLOOSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:18:20 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53642 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYLOOSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:18:18 -0500
X-BigFish: VPS3(zzzzzzz32i43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBX924-03-GLF-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 01/22] AMD IOMMU: add a domain flag for default domains
Date: Mon, 15 Dec 2008 15:17:44 +0100
Message-ID: <1229350685-3816-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:05.0822 (UTC) FILETIME=[F29279E0:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: adds a new protection domain flag

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 ++
 arch/x86/kernel/amd_iommu.c            |    1 +
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 1c769f4..6adc702 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -192,6 +192,8 @@
 
 /* Protection domain flags */
 #define PD_DMA_OPS_MASK		(1UL << 0) /* domain used for dma_ops */
+#define PD_DEFAULT_MASK		(1UL << 1) /* domain is a default dma_ops
+					      domain for an IOMMU */
 
 /*
  * This structure contains generic data for  IOMMU protection domains
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index cc78834..1694415 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -1573,6 +1573,7 @@ int __init amd_iommu_init_dma_ops(void)
 		iommu->default_dom = dma_ops_domain_alloc(iommu, order);
 		if (iommu->default_dom == NULL)
 			return -ENOMEM;
+		iommu->default_dom->domain.flags |= PD_DEFAULT_MASK;
 		ret = iommu_init_unity_mappings(iommu);
 		if (ret)
 			goto free_domains;
-- 
1.5.6.4


