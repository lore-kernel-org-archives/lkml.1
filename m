Return-Path: <linux-kernel-owner+w=401wt.eu-S1758399AbZEVMWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758399AbZEVMWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbZEVMV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:21:59 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:59833
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758010AbZEVMV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:21:58 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KK1P00-04-A1T-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/12] amd-iommu: don't preallocate page tables with CONFIG_IOMMU_STRESS
Date: Fri, 22 May 2009 14:21:32 +0200
Message-ID: <1242994893-28902-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
References: <1242994893-28902-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:21:33.0111 (UTC) FILETIME=[D7DBF470:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: force testing of on-demand page table allocation code ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 543822b..33434c4 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -661,6 +661,10 @@ static int alloc_new_range(struct amd_iommu *iommu,
 	int index = dma_dom->aperture_size >> APERTURE_RANGE_SHIFT;
 	int i;
 
+#ifdef CONFIG_IOMMU_STRESS
+	populate = false;
+#endif
+
 	if (index >= APERTURE_MAX_RANGES)
 		return -ENOMEM;
 
-- 
1.6.3.1


