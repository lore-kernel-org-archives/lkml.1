Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbZJBSIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbZJBSIk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 14:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbZJBSIj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 14:08:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:55455 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbZJBSIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 14:08:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,495,1249282800"; 
   d="scan'208";a="556118110"
Message-Id: <20091002180257.787016872@sbs-t61.sc.intel.com>
User-Agent: quilt/0.47-1
Date: Fri, 02 Oct 2009 11:01:23 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: dwmw2@infradead.org
Cc: jbarnes@virtuousgeek.org, len.brown@intel.com,
       linux-kernel@vger.kernel.org, rdreier@cisco.com,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 3/4] intr_remap: Allocate intr-remapping table using numa locality info
References: <20091002180257.600389229@sbs-t61.sc.intel.com>
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

Index: iommu-2.6/drivers/pci/intr_remapping.c
===================================================================
--- iommu-2.6.orig/drivers/pci/intr_remapping.c
+++ iommu-2.6/drivers/pci/intr_remapping.c
@@ -548,7 +548,8 @@ static int setup_intr_remapping(struct i
 	if (!iommu->ir_table)
 		return -ENOMEM;
 
-	pages = alloc_pages(GFP_ATOMIC | __GFP_ZERO, INTR_REMAP_PAGE_ORDER);
+	pages = alloc_pages_node(iommu->node, GFP_ATOMIC | __GFP_ZERO,
+				 INTR_REMAP_PAGE_ORDER);
 
 	if (!pages) {
 		printk(KERN_ERR "failed to allocate pages of order %d\n",


