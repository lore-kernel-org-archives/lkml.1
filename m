Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbYKTPwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbYKTPwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYKTPvH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:51:07 -0500
Received: from mail26.svc.cra.dublin.eircom.net ([159.134.118.55]:35525 "HELO
	mail26.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754969AbYKTPvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:51:01 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       x86@kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 8/8] intel-iommu: move iommu_prepare_gfx_mapping() out of dma_remapping.h
Date: Thu, 20 Nov 2008 15:49:50 +0000
Message-Id: <1227196190-488-8-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227196190-488-7-git-send-email-markmc@redhat.com>
References: <1227191861.4901.24.camel@macbook.infradead.org>
 <1227196190-488-1-git-send-email-markmc@redhat.com>
 <1227196190-488-2-git-send-email-markmc@redhat.com>
 <1227196190-488-3-git-send-email-markmc@redhat.com>
 <1227196190-488-4-git-send-email-markmc@redhat.com>
 <1227196190-488-5-git-send-email-markmc@redhat.com>
 <1227196190-488-6-git-send-email-markmc@redhat.com>
 <1227196190-488-7-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/pci/intel-iommu.c     |    5 +++++
 include/linux/dma_remapping.h |    7 -------
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 080a860..aec60ad 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1686,6 +1686,11 @@ static void __init iommu_prepare_gfx_mapping(void)
 			printk(KERN_ERR "IOMMU: mapping reserved region failed\n");
 	}
 }
+#else /* !CONFIG_DMAR_GFX_WA */
+static inline void iommu_prepare_gfx_mapping(void)
+{
+	return;
+}
 #endif
 
 #ifdef CONFIG_DMAR_FLOPPY_WA
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 4ef5f6b..7799a85 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -20,11 +20,4 @@ extern void free_dmar_iommu(struct intel_iommu *iommu);
 
 extern int dmar_disabled;
 
-#ifndef CONFIG_DMAR_GFX_WA
-static inline void iommu_prepare_gfx_mapping(void)
-{
-	return;
-}
-#endif /* !CONFIG_DMAR_GFX_WA */
-
 #endif
-- 
1.5.4.3

