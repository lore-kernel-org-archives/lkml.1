Return-Path: <linux-kernel-owner+w=401wt.eu-S1762155AbZCQA2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762155AbZCQA2r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758637AbZCQA2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:28:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:9269 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754915AbZCQA2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:28:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,375,1233561600"; 
   d="scan'208";a="439438111"
Message-Id: <20090317001320.564973000@linux-os.sc.intel.com>
References: <20090317000452.805772000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 16 Mar 2009 17:04:58 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, dwmw2@infradead.org,
       yinghai@kernel.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 06/13] intr-remapping: fix free_irte() to clear all the IRTE entries
Content-Disposition: inline; filename=fix_free_irte.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the typo which was not clearing all the interrupt remapping table
entries corresponding to an irq.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/drivers/pci/intr_remapping.c
===================================================================
--- tip.orig/drivers/pci/intr_remapping.c
+++ tip/drivers/pci/intr_remapping.c
@@ -386,7 +386,7 @@ int free_irte(int irq)
 
 	if (!irq_iommu->sub_handle) {
 		for (i = 0; i < (1 << irq_iommu->irte_mask); i++)
-			set_64bit((unsigned long *)irte, 0);
+			set_64bit((unsigned long *)(irte + i), 0);
 		rc = qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 	}
 

-- 

