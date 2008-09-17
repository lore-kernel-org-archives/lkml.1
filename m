Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYIQQz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYIQQz0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 12:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755111AbYIQQxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:16 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:4277 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754309AbYIQQxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:14 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K7CMWE-03-U9I-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <jroedel@lemmy.amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 20/23] AMD IOMMU: remove unnecessary cast to u64 in the init code
Date: Wed, 17 Sep 2008 18:52:54 +0200
Message-ID: <1221670377-19295-21-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0204 (UTC) FILETIME=[D67FB1C0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@lemmy.amd.com>

The ctrl variable is only u32 and readl also returns a 32 bit value. So
the cast to u64 is pointless. Remove it with this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index a307cf6..b876499 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -236,7 +236,7 @@ static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 {
 	u32 ctrl;
 
-	ctrl = (u64)readl(iommu->mmio_base + MMIO_CONTROL_OFFSET);
+	ctrl = readl(iommu->mmio_base + MMIO_CONTROL_OFFSET);
 	ctrl &= ~(1 << bit);
 	writel(ctrl, iommu->mmio_base + MMIO_CONTROL_OFFSET);
 }
-- 
1.5.6.4


