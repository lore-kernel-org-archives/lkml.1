Return-Path: <linux-kernel-owner+w=401wt.eu-S1757041AbYKTPwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757041AbYKTPwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:52:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755321AbYKTPvF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:51:05 -0500
Received: from mail13.svc.cra.dublin.eircom.net ([159.134.118.29]:41810 "HELO
	mail13.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754903AbYKTPvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:51:01 -0500
From: Mark McLoughlin <markmc@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       x86@kernel.org, Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 6/8] intel-iommu: move struct device_domain_info out of dma_remapping.h
Date: Thu, 20 Nov 2008 15:49:48 +0000
Message-Id: <1227196190-488-6-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227196190-488-5-git-send-email-markmc@redhat.com>
References: <1227191861.4901.24.camel@macbook.infradead.org>
 <1227196190-488-1-git-send-email-markmc@redhat.com>
 <1227196190-488-2-git-send-email-markmc@redhat.com>
 <1227196190-488-3-git-send-email-markmc@redhat.com>
 <1227196190-488-4-git-send-email-markmc@redhat.com>
 <1227196190-488-5-git-send-email-markmc@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/pci/intel-iommu.c     |   10 ++++++++++
 include/linux/dma_remapping.h |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 14066b1..080a860 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -168,6 +168,16 @@ struct dmar_domain {
 	int		flags;
 };
 
+/* PCI domain-device relationship */
+struct device_domain_info {
+	struct list_head link;	/* link to domain siblings */
+	struct list_head global; /* link to global list */
+	u8 bus;			/* PCI bus numer */
+	u8 devfn;		/* PCI devfn number */
+	struct pci_dev *dev; /* it's NULL for PCIE-to-PCI bridge */
+	struct dmar_domain *domain; /* pointer to domain */
+};
+
 static void flush_unmaps_timeout(unsigned long data);
 
 DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
diff --git a/include/linux/dma_remapping.h b/include/linux/dma_remapping.h
index 3330144..4ef5f6b 100644
--- a/include/linux/dma_remapping.h
+++ b/include/linux/dma_remapping.h
@@ -16,16 +16,6 @@ struct intel_iommu;
 struct dmar_domain;
 struct root_entry;
 
-/* PCI domain-device relationship */
-struct device_domain_info {
-	struct list_head link;	/* link to domain siblings */
-	struct list_head global; /* link to global list */
-	u8 bus;			/* PCI bus numer */
-	u8 devfn;		/* PCI devfn number */
-	struct pci_dev *dev; /* it's NULL for PCIE-to-PCI bridge */
-	struct dmar_domain *domain; /* pointer to domain */
-};
-
 extern void free_dmar_iommu(struct intel_iommu *iommu);
 
 extern int dmar_disabled;
-- 
1.5.4.3

