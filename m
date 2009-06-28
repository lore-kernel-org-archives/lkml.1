Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbZF1VJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbZF1VJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZF1VIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:08:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:58326 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062AbZF1VIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:08:51 -0400
Message-ID: <4A47DBD5.6070307@kernel.org>
Date: Sun, 28 Jun 2009 14:08:37 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: [PATCH] pci/dmar: remove the noisy print out about unmapping
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it seems this one should be removed.
because map page does have this annonyed print out.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 drivers/pci/intel-iommu.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6/drivers/pci/intel-iommu.c
===================================================================
--- linux-2.6.orig/drivers/pci/intel-iommu.c
+++ linux-2.6/drivers/pci/intel-iommu.c
@@ -2633,9 +2633,6 @@ static void intel_unmap_page(struct devi
 	start_addr = iova->pfn_lo << PAGE_SHIFT;
 	size = aligned_size((u64)dev_addr, size);
 
-	pr_debug("Device %s unmapping: %zx@%llx\n",
-		pci_name(pdev), size, (unsigned long long)start_addr);
-
 	/*  clear the whole page */
 	dma_pte_clear_range(domain, start_addr, start_addr + size);
 	/* free page tables */
