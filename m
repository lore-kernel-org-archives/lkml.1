Return-Path: <linux-kernel-owner+w=401wt.eu-S933543AbZIDJm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543AbZIDJm5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 05:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933374AbZIDJmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 05:42:21 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:37460
	"EHLO VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933466AbZIDJmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 05:42:06 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j63h)
X-Spam-TCS-SCL: 2:0
X-FB-SS: 5,
X-WSS-ID: 0KPFXLZ-04-HXA-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 12/14] x86/amd-iommu: Remove old page table handling macros
Date: Fri, 4 Sep 2009 11:40:50 +0200
Message-ID: <1252057252-32074-13-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
References: <1252057252-32074-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 04 Sep 2009 09:40:55.0580 (UTC) FILETIME=[CCD12DC0:01CA2D43]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These macros are not longer required. So remove them.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |   19 -------------------
 1 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index 1b4b3d6..d66430d 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -150,11 +150,6 @@
 #define PAGE_MODE_5_LEVEL 0x05
 #define PAGE_MODE_6_LEVEL 0x06
 
-#define IOMMU_PDE_NL_0   0x000ULL
-#define IOMMU_PDE_NL_1   0x200ULL
-#define IOMMU_PDE_NL_2   0x400ULL
-#define IOMMU_PDE_NL_3   0x600ULL
-
 #define PM_LEVEL_SHIFT(x)	(12 + ((x) * 9))
 #define PM_LEVEL_SIZE(x)	(((x) < 6) ? \
 				  ((1ULL << PM_LEVEL_SHIFT((x))) - 1): \
@@ -164,15 +159,6 @@
 #define PM_LEVEL_PDE(x, a)	((a) | PM_LEVEL_ENC((x)) | \
 				 IOMMU_PTE_P | IOMMU_PTE_IR | IOMMU_PTE_IW)
 
-
-#define IOMMU_PTE_L2_INDEX(address) (((address) >> 30) & 0x1ffULL)
-#define IOMMU_PTE_L1_INDEX(address) (((address) >> 21) & 0x1ffULL)
-#define IOMMU_PTE_L0_INDEX(address) (((address) >> 12) & 0x1ffULL)
-
-#define IOMMU_MAP_SIZE_L1 (1ULL << 21)
-#define IOMMU_MAP_SIZE_L2 (1ULL << 30)
-#define IOMMU_MAP_SIZE_L3 (1ULL << 39)
-
 #define IOMMU_PTE_P  (1ULL << 0)
 #define IOMMU_PTE_TV (1ULL << 1)
 #define IOMMU_PTE_U  (1ULL << 59)
@@ -180,11 +166,6 @@
 #define IOMMU_PTE_IR (1ULL << 61)
 #define IOMMU_PTE_IW (1ULL << 62)
 
-#define IOMMU_L1_PDE(address) \
-	((address) | IOMMU_PDE_NL_1 | IOMMU_PTE_P | IOMMU_PTE_IR | IOMMU_PTE_IW)
-#define IOMMU_L2_PDE(address) \
-	((address) | IOMMU_PDE_NL_2 | IOMMU_PTE_P | IOMMU_PTE_IR | IOMMU_PTE_IW)
-
 #define IOMMU_PAGE_MASK (((1ULL << 52) - 1) & ~0xfffULL)
 #define IOMMU_PTE_PRESENT(pte) ((pte) & IOMMU_PTE_P)
 #define IOMMU_PTE_PAGE(pte) (phys_to_virt((pte) & IOMMU_PAGE_MASK))
-- 
1.6.3.3


