Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbYKSEyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbYKSEyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 23:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbYKSEx4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 23:53:56 -0500
Received: from sh.osrg.net ([192.16.179.4]:33130 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668AbYKSEx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 23:53:56 -0500
Date: Wed, 19 Nov 2008 13:53:42 +0900
To: David.Woodhouse@intel.com, mingo@elte.hu, tony.luck@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] intel-iommu: fix compile warnings
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20081119135351M.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the following warnings on IA64:

linux-2.6/drivers/pci/intel-iommu.c: In function 'init_dmars':
linux-2.6/drivers/pci/intel-iommu.c:1658: warning: format '%Lx' expects type 'long long unsigned int', but argument 2 has type 'u64'
linux-2.6/drivers/pci/intel-iommu.c:1663: warning: format '%Lx' expects type 'long long unsigned int', but argument 2 has type 'u64'

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/pci/intel-iommu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a269272..5c8baa4 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1655,12 +1655,14 @@ int __init init_dmars(void)
 			iommu->flush.flush_context = __iommu_flush_context;
 			iommu->flush.flush_iotlb = __iommu_flush_iotlb;
 			printk(KERN_INFO "IOMMU 0x%Lx: using Register based "
-			       "invalidation\n", drhd->reg_base_addr);
+			       "invalidation\n",
+			       (unsigned long long)drhd->reg_base_addr);
 		} else {
 			iommu->flush.flush_context = qi_flush_context;
 			iommu->flush.flush_iotlb = qi_flush_iotlb;
 			printk(KERN_INFO "IOMMU 0x%Lx: using Queued "
-			       "invalidation\n", drhd->reg_base_addr);
+			       "invalidation\n",
+			       (unsigned long long)drhd->reg_base_addr);
 		}
 	}
 
-- 
1.5.5.GIT

