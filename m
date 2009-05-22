Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZEVMQp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZEVMQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 08:16:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758039AbZEVMQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 08:16:00 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:5782 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758021AbZEVMP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 08:15:59 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KK1OQC-04-9XS-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/9] amd-iommu: add function to disable all iommus
Date: Fri, 22 May 2009 14:15:36 +0200
Message-ID: <1242994540-28799-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
References: <1242994540-28799-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 22 May 2009 12:15:42.0407 (UTC) FILETIME=[06D2C570:01C9DAD7]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ impact: add disable_iommus function needed for suspend/resume ]

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index feee475..ed10c0f 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -252,6 +252,11 @@ static void __init iommu_enable(struct amd_iommu *iommu)
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
 
+static void iommu_disable(struct amd_iommu *iommu)
+{
+	iommu_feature_disable(iommu, CONTROL_IOMMU_EN);
+}
+
 /*
  * mapping and unmapping functions for the IOMMU MMIO space. Each AMD IOMMU in
  * the system has one.
@@ -945,6 +950,14 @@ static void __init enable_iommus(void)
 	}
 }
 
+static void disable_iommus(void)
+{
+	struct amd_iommu *iommu;
+
+	for_each_iommu(iommu)
+		iommu_disable(iommu);
+}
+
 /*
  * Suspend/Resume support
  * disable suspend until real resume implemented
-- 
1.6.3.1


