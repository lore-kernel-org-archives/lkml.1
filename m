Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbYKTOWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbYKTOWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:22:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754760AbYKTOWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:22:37 -0500
Received: from mx2.redhat.com ([66.187.237.31]:39368 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759AbYKTOWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:22:36 -0500
Subject: [PATCH] intel-iommu: make init_dmars() static
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
Content-Type: text/plain
Date: Thu, 20 Nov 2008 14:21:13 +0000
Message-Id: <1227190873.3739.24.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

init_dmars() is not used outside of drivers/pci/intel-iommu.c

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/pci/intel-iommu.c     |    2 +-
 include/linux/dma_remapping.h |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 271f869..5721196 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1589,7 +1589,7 @@ static inline void iommu_prepare_isa(void)
 }
 #endif /* !CONFIG_DMAR_FLPY_WA */
 
-int __init init_dmars(void)
+static int __init init_dmars(void)
 {
 	struct dmar_drhd_unit *drhd;
 	struct dmar_rmrr_unit *rmrr;
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 952df39..cf92c49 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -141,7 +141,6 @@ struct device_domain_info {
 	struct dmar_domain *domain; /* pointer to domain */
 };
 
-extern int init_dmars(void);
 extern void free_dmar_iommu(struct intel_iommu *iommu);
 
 extern int dmar_disabled;
-- 
1.6.0.3

