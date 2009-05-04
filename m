Return-Path: <linux-kernel-owner+w=401wt.eu-S1755042AbZEDKM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042AbZEDKM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 06:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZEDKML
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 06:12:11 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:31636 "EHLO
	SG2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbZEDKMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 06:12:09 -0400
X-BigFish: VPS3(zzzz1202hzzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KJ46ZO-03-6FG-01
From: Joerg Roedel <joerg.roedel@amd.com>
To: stable@kernel.org
CC: linux-kernel@vger.kernel.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH] amd-iommu: fix iommu flag masks
Date: Mon, 4 May 2009 12:11:47 +0200
Message-ID: <1241431907-30225-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.6.2.4
X-OriginalArrivalTime: 04 May 2009 10:11:48.0256 (UTC) FILETIME=[BC49DA00:01C9CCA0]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: fix initialization of iommu flags

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 arch/x86/kernel/amd_iommu_init.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu_init.c b/arch/x86/kernel/amd_iommu_init.c
index 42c33ce..8c0be09 100644
--- a/arch/x86/kernel/amd_iommu_init.c
+++ b/arch/x86/kernel/amd_iommu_init.c
@@ -49,10 +49,10 @@
 #define IVHD_DEV_EXT_SELECT             0x46
 #define IVHD_DEV_EXT_SELECT_RANGE       0x47
 
-#define IVHD_FLAG_HT_TUN_EN             0x00
-#define IVHD_FLAG_PASSPW_EN             0x01
-#define IVHD_FLAG_RESPASSPW_EN          0x02
-#define IVHD_FLAG_ISOC_EN               0x03
+#define IVHD_FLAG_HT_TUN_EN_MASK        0x01
+#define IVHD_FLAG_PASSPW_EN_MASK        0x02
+#define IVHD_FLAG_RESPASSPW_EN_MASK     0x04
+#define IVHD_FLAG_ISOC_EN_MASK          0x08
 
 #define IVMD_FLAG_EXCL_RANGE            0x08
 #define IVMD_FLAG_UNITY_MAP             0x01
@@ -569,19 +569,19 @@ static void __init init_iommu_from_acpi(struct amd_iommu *iommu,
 	 * First set the recommended feature enable bits from ACPI
 	 * into the IOMMU control registers
 	 */
-	h->flags & IVHD_FLAG_HT_TUN_EN ?
+	h->flags & IVHD_FLAG_HT_TUN_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_HT_TUN_EN) :
 		iommu_feature_disable(iommu, CONTROL_HT_TUN_EN);
 
-	h->flags & IVHD_FLAG_PASSPW_EN ?
+	h->flags & IVHD_FLAG_PASSPW_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_PASSPW_EN) :
 		iommu_feature_disable(iommu, CONTROL_PASSPW_EN);
 
-	h->flags & IVHD_FLAG_RESPASSPW_EN ?
+	h->flags & IVHD_FLAG_RESPASSPW_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_RESPASSPW_EN) :
 		iommu_feature_disable(iommu, CONTROL_RESPASSPW_EN);
 
-	h->flags & IVHD_FLAG_ISOC_EN ?
+	h->flags & IVHD_FLAG_ISOC_EN_MASK ?
 		iommu_feature_enable(iommu, CONTROL_ISOC_EN) :
 		iommu_feature_disable(iommu, CONTROL_ISOC_EN);
 
-- 
1.6.2.4


