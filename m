Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZJ2Qui@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZJ2Qui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:50:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbZJ2Qug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:50:36 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:41438
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755768AbZJ2Qud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:50:33 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KSAC3U-04-FJY-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ingo Molnar <mingo@redhat.com>
CC: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       Joerg Roedel <joerg.roedel@amd.com>, stable@kernel.org
Subject: [PATCH 2/4] x86/amd-iommu: Un__init function required on shutdown
Date: Thu, 29 Oct 2009 17:50:10 +0100
Message-ID: <1256835012-31410-3-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1256835012-31410-1-git-send-email-joerg.roedel@amd.com>
References: <1256835012-31410-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 29 Oct 2009 16:50:17.0668 (UTC) FILETIME=[E4F01840:01CA58B7]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function iommu_feature_disable is required on system
shutdown to disable the IOMMU but it is marked as __init.
This may result in a panic if the memory is reused. This
patch fixes this bug.

Cc: stable@kernel.org
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 498c8c7..1e423b2 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -240,7 +240,7 @@ static void iommu_feature_enable(struct amd_iommu *iommu, u8 bit)
 	writel(ctrl, iommu->mmio_base + MMIO_CONTROL_OFFSET);
 }
 
-static void __init iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
+static void iommu_feature_disable(struct amd_iommu *iommu, u8 bit)
 {
 	u32 ctrl;
 
-- 
1.6.5


