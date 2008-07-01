Return-Path: <linux-kernel-owner+w=401wt.eu-S1757369AbYGAJVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369AbYGAJVi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 05:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755306AbYGAJVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 05:21:15 -0400
Received: from mga10.intel.com ([192.55.52.92]:40691 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754043AbYGAJVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 05:21:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,730,1204531200"; 
   d="scan'208";a="583796238"
Date: Tue, 1 Jul 2008 05:13:54 -0400
From: Yong Wang <yong.y.wang@linux.intel.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Intel IOMMU: RMRRs do not necessarily have to be present
	on all VT-d capable platforms
Message-ID: <20080701091354.GA12969@ywang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RMRRs do not necessarily have to be present on all VT-d capable platforms.
The printk is just informational and does not need to be followed by an
error return.

Signed-off-by: Yong Y Wang <yong.y.wang@intel.com>
---
 dmar.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index f941f60..8bf86ae 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -317,10 +317,8 @@ int __init dmar_table_init(void)
 		return -ENODEV;
 	}
 
-	if (list_empty(&dmar_rmrr_units)) {
+	if (list_empty(&dmar_rmrr_units))
 		printk(KERN_INFO PREFIX "No RMRR found\n");
-		return -ENODEV;
-	}
 
 	return 0;
 }
