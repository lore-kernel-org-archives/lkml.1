Return-Path: <linux-kernel-owner+w=401wt.eu-S1758064AbZEVMQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064AbZEVMQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:16:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758035AbZEVMQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:16:03 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:54159
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757947AbZEVMQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:16:01 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j66h)
X-Spam-TCS-SCL: 5:0
X-WSS-ID: 0KK1OQ6-03-946-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 3/9] amd-iommu: drop pointless iommu-loop in msi setup code
Date: Fri, 22 May 2009 14:15:34 +0200
Message-ID: <1242994540-28799-4-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
References: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:15:42.0157 (UTC) FILETIME=[06AC9FD0:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

It is not necessary to loop again over all IOMMUs in this code. So drop
the loop.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 74f4f1f..cc99f60 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -826,13 +826,6 @@ out_free:
 static int __init iommu_setup_msi(struct amd_iommu *iommu)
 {
 	int r;
-	struct amd_iommu *curr;
-
-	for_each_iommu(curr) {
-		if (curr->dev == iommu->dev)
-			curr->int_enabled = true;
-	}
-
 
 	if (pci_enable_msi(iommu->dev))
 		return 1;
@@ -847,6 +840,7 @@ static int __init iommu_setup_msi(struct amd_iommu *iommu)
 		return 1;
 	}
 
+	iommu->int_enabled = true;
 	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
 
 	return 0;
-- 
1.6.3.1


