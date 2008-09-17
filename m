Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYIQRBL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYIQRBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 13:01:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755422AbYIQQxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 12:53:34 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:53836 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbYIQQxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 12:53:30 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0K7CMWA-04-US0-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: linux-kernel@vger.kernel.org
CC: iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 11/23] AMD IOMMU: enable event logging
Date: Wed, 17 Sep 2008 18:52:45 +0200
Message-ID: <1221670377-19295-12-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
References: <1221670377-19295-1-git-send-email-joerg.roedel@amd.com>
X-OriginalArrivalTime: 17 Sep 2008 16:52:58.0042 (UTC) FILETIME=[D666F9A0:01C918E5]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code to log IOMMU events is in place now. So enable event logging
with this patch.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 07709a9..5182132 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -254,6 +254,13 @@ void __init iommu_enable(struct amd_iommu *iommu)
 	iommu_feature_enable(iommu, CONTROL_IOMMU_EN);
 }
 
+/* Function to enable IOMMU event logging and event interrupts */
+void __init iommu_enable_event_logging(struct amd_iommu *iommu)
+{
+	iommu_feature_enable(iommu, CONTROL_EVT_LOG_EN);
+	iommu_feature_enable(iommu, CONTROL_EVT_INT_EN);
+}
+
 /*
  * mapping and unmapping functions for the IOMMU MMIO space. Each AMD IOMMU in
  * the system has one.
@@ -959,6 +966,7 @@ static void __init enable_iommus(void)
 	list_for_each_entry(iommu, &amd_iommu_list, list) {
 		iommu_set_exclusion_range(iommu);
 		iommu_init_msi(iommu);
+		iommu_enable_event_logging(iommu);
 		iommu_enable(iommu);
 	}
 }
-- 
1.5.6.4


