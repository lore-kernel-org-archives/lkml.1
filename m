Return-Path: <linux-kernel-owner+w=401wt.eu-S1756205AbZJ0HnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205AbZJ0HnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:43:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbZJ0HnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:43:00 -0400
Received: from sh.osrg.net ([192.16.179.4]:51841 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376AbZJ0Hm7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:42:59 -0400
Date: Tue, 27 Oct 2009 16:43:01 +0900
To: tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20091027164235N.fujita.tomonori@lab.ntt.co.jp>
From: fujita <fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 27 Oct 2009 16:43:01 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] swiotlb: remove duplicated swiotlb_late_init_with_default_size
 declarations
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Dcc: fujita.tomonori@lab.ntt.co.jp
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

This adds swiotlb_late_init_with_default_size declaration to the
common header so that we can remove duplicated
swiotlb_late_init_with_default_size declarations in the IOMMU drivers.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 arch/ia64/hp/common/hwsw_iommu.c |    3 ---
 arch/ia64/hp/common/sba_iommu.c  |    3 +--
 include/linux/swiotlb.h          |    4 ++--
 3 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/ia64/hp/common/hwsw_iommu.c b/arch/ia64/hp/common/hwsw_iommu.c
index e4a80d8..d557779 100644
--- a/arch/ia64/hp/common/hwsw_iommu.c
+++ b/arch/ia64/hp/common/hwsw_iommu.c
@@ -19,9 +19,6 @@
 
 extern struct dma_map_ops sba_dma_ops, swiotlb_dma_ops;
 
-/* swiotlb declarations & definitions: */
-extern int swiotlb_late_init_with_default_size (size_t size);
-
 /*
  * Note: we need to make the determination of whether or not to use
  * the sw I/O TLB based purely on the device structure.  Anything else
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 674a837..96c769e 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -37,6 +37,7 @@
 #include <linux/crash_dump.h>
 #include <linux/iommu-helper.h>
 #include <linux/dma-mapping.h>
+#include <linux/swiotlb.h>
 
 #include <asm/delay.h>		/* ia64_get_itc() */
 #include <asm/io.h>
@@ -46,8 +47,6 @@
 
 #include <asm/acpi-ext.h>
 
-extern int swiotlb_late_init_with_default_size (size_t size);
-
 #define PFX "IOC: "
 
 /*
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 73b1f1c..2583af3 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -20,8 +20,8 @@ struct scatterlist;
  */
 #define IO_TLB_SHIFT 11
 
-extern void
-swiotlb_init(void);
+extern void swiotlb_init(void);
+extern int swiotlb_late_init_with_default_size(size_t size);
 
 extern void
 *swiotlb_alloc_coherent(struct device *hwdev, size_t size,
-- 
1.5.6.5

