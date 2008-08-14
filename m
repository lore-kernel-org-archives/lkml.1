Return-Path: <linux-kernel-owner+w=401wt.eu-S1755321AbYHNR4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321AbYHNR4u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759247AbYHNRzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:55:38 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31883 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759215AbYHNRzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:55:37 -0400
X-BigFish: VPS11(z1039ozzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K5LR47-04-DOZ-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/4] AMD IOMMU: replace LOW_U32 macro with generic lower_32_bits
Date: Thu, 14 Aug 2008 19:55:17 +0200
Message-ID: <1218736518-25301-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1218736518-25301-1-git-send-email-joerg.roedel@amd.com>
References: <1218736518-25301-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 14 Aug 2008 17:55:18.0645 (UTC) FILETIME=[E9EE3250:01C8FE36]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c       |    2 +-
 include/asm-x86/amd_iommu_types.h |    3 ---
 2 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 028e945..de39e1f 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -164,7 +164,7 @@ static int iommu_queue_inv_iommu_pages(struct amd_iommu *iommu,
 	address &= PAGE_MASK;
 	CMD_SET_TYPE(&cmd, CMD_INV_IOMMU_PAGES);
 	cmd.data[1] |= domid;
-	cmd.data[2] = LOW_U32(address);
+	cmd.data[2] = lower_32_bits(address);
 	cmd.data[3] = upper_32_bits(address);
 	if (s) /* size bit - we flush more than one 4kb page */
 		cmd.data[2] |= CMD_INV_IOMMU_PAGES_SIZE_MASK;
diff --git a/include/asm-x86/amd_iommu_types.h b/include/asm-x86/amd_iommu_types.h
index 01412f0..1ffa4e5 100644
--- a/include/asm-x86/amd_iommu_types.h
+++ b/include/asm-x86/amd_iommu_types.h
@@ -31,9 +31,6 @@
 #define ALIAS_TABLE_ENTRY_SIZE		2
 #define RLOOKUP_TABLE_ENTRY_SIZE	(sizeof(void *))
 
-/* helper macros */
-#define LOW_U32(x) ((x) & ((1ULL << 32)-1))
-
 /* Length of the MMIO region for the AMD IOMMU */
 #define MMIO_REGION_LENGTH       0x4000
 
-- 
1.5.3.7


