Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbZJBAU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbZJBAU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 20:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754171AbZJBAU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 20:20:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:12861 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712AbZJBAU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 20:20:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,490,1249282800"; 
   d="scan'208";a="453854470"
Message-Id: <20091001230744.135836864@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Thu, 01 Oct 2009 16:06:18 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: dwmw2@infradead.org
Cc: jbarnes@virtuousgeek.org, len.brown@intel.com,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/4] intr_remap: Allocate intr-remapping table using numa locality info
References: <20091001230743.949931468@sbs-t61.sc.intel.com>
Content-Disposition: inline; filename=intr_remap_use_affinity_info.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocate intr-remapping table using numa locality info. On platforms
having remapping hardware units span different nodes, this enables
optimized intr-remapping table entry access by remapping hardware.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---
 drivers/pci/intr_remapping.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: tip/drivers/pci/intr_remapping.c
===================================================================
--- tip.orig/drivers/pci/intr_remapping.c
+++ tip/drivers/pci/intr_remapping.c
@@ -590,7 +590,8 @@ static int setup_intr_remapping(struct i
 	if (!iommu->ir_table)
 		return -ENOMEM;
 
-	pages = alloc_pages(GFP_ATOMIC | __GFP_ZERO, INTR_REMAP_PAGE_ORDER);
+	pages = alloc_pages_node(iommu->node, GFP_ATOMIC | __GFP_ZERO,
+				 INTR_REMAP_PAGE_ORDER);
 
 	if (!pages) {
 		printk(KERN_ERR "failed to allocate pages of order %d\n",


