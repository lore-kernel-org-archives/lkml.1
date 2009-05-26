Return-Path: <linux-kernel-owner+w=401wt.eu-S1760053AbZEZWs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053AbZEZWs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759401AbZEZWpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:45:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:19529 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759391AbZEZWpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:45:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,254,1241420400"; 
   d="scan'208";a="415865057"
From: "Luck, Tony" <tony.luck@intel.com>
To: David Woodhouse <dwmw2@infradead.org>, Fenghua Yu <fenghua.yu@intel.com>
Cc: <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>
Subject: [PATCH] Fix one last ia64 build problem in Intel IOMMU Pass Through Support
Date: Tue, 26 May 2009 15:45:12 -0700
Message-Id: <4a1c70f8189932f73c@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ia64 with CONFIG_DMAR=n and CONFIG_SWIOTLB=y (as used in
arch/ia64/configs/tiger_defconfig) there is still a link
error with iommu_pass_through listed as an undefined symbol:

arch/ia64/kernel/built-in.o: In function `pci_swiotlb_init':
(.init.text+0x7f70): undefined reference to `iommu_pass_through'

Fix it by #defining iommu_pass_through away in asm/iommu.h

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

This fix for the iommu tree/branch that feeds to linux-next

diff --git a/arch/ia64/include/asm/iommu.h b/arch/ia64/include/asm/iommu.h
index 37d41ca..745e095 100644
--- a/arch/ia64/include/asm/iommu.h
+++ b/arch/ia64/include/asm/iommu.h
@@ -9,7 +9,11 @@ extern void pci_iommu_shutdown(void);
 extern void no_iommu_init(void);
 extern int force_iommu, no_iommu;
 extern int iommu_detected;
+#ifdef	CONFIG_DMAR
 extern int iommu_pass_through;
+#else
+#define iommu_pass_through	(0)
+#endif
 extern void iommu_dma_init(void);
 extern void machvec_init(const char *name);
 
