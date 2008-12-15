Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbYLOOX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbYLOOX3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 09:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbYLOOTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 09:19:09 -0500
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:27200 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992AbYLOOTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 09:19:06 -0500
X-BigFish: VPS3(zzzzzzz32i43j64h)
X-Spam-TCS-SCL: 3:0
X-FB-SS: 5,
X-WSS-ID: 0KBX93A-03-00T-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 04/22] AMD IOMMU: convert iommu->need_sync to bool
Date: Mon, 15 Dec 2008 15:17:47 +0100
Message-ID: <1229350685-3816-5-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
References: <1229350685-3816-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 15 Dec 2008 14:18:05.0916 (UTC) FILETIME=[F2A0D1C0:01C95EBF]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: use bool instead of int for iommu->need_sync

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/include/asm/amd_iommu_types.h |    2 +-
 arch/x86/kernel/amd_iommu.c            |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/amd_iommu_types.h b/arch/x86/include/asm/amd_iommu_types.h
index ee8cfa0..c4b144e 100644
--- a/arch/x86/include/asm/amd_iommu_types.h
+++ b/arch/x86/include/asm/amd_iommu_types.h
@@ -302,7 +302,7 @@ struct amd_iommu {
 	bool int_enabled;
 
 	/* if one, we need to send a completion wait command */
-	int need_sync;
+	bool need_sync;
 
 	/* default dma_ops domain for that IOMMU */
 	struct dma_ops_domain *default_dom;
diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index dc7cef3..8363731 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -197,7 +197,7 @@ static int iommu_queue_command(struct amd_iommu *iommu, struct iommu_cmd *cmd)
 	spin_lock_irqsave(&iommu->lock, flags);
 	ret = __iommu_queue_command(iommu, cmd);
 	if (!ret)
-		iommu->need_sync = 1;
+		iommu->need_sync = true;
 	spin_unlock_irqrestore(&iommu->lock, flags);
 
 	return ret;
@@ -260,7 +260,7 @@ static int iommu_completion_wait(struct amd_iommu *iommu)
 	if (!iommu->need_sync)
 		goto out;
 
-	iommu->need_sync = 0;
+	iommu->need_sync = false;
 
 	ret = __iommu_completion_wait(iommu);
 
-- 
1.5.6.4


