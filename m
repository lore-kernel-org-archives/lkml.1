Return-Path: <linux-kernel-owner+w=401wt.eu-S1755487AbYKTOGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487AbYKTOGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbYKTOGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:06:15 -0500
Received: from mx2.redhat.com ([66.187.237.31]:33557 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696AbYKTOGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:06:14 -0500
Subject: [PATCH] intel-iommu: remove some unused struct intel_iommu fields
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
Content-Type: text/plain
Date: Thu, 20 Nov 2008 14:04:20 +0000
Message-Id: <1227189860.3739.21.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The seg, saved_msg and sysdev fields appear to be unused since
before the code was first merged.

linux/msi.h is not needed in linux/intel-iommu.h anymore since
there is no longer a reference to struct msi_msg. The MSI code
in drivers/pci/intel-iommu.c still has linux/msi.h included
via linux/dmar.h.

linux/sysdev.h isn't needed because there is no reference to
struct sys_device.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/pci/intel-iommu.c   |    1 -
 include/linux/intel-iommu.h |    5 -----
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index a269272..271f869 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -27,7 +27,6 @@
 #include <linux/slab.h>
 #include <linux/irq.h>
 #include <linux/interrupt.h>
-#include <linux/sysdev.h>
 #include <linux/spinlock.h>
 #include <linux/pci.h>
 #include <linux/dmar.h>
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 3d017cf..1bff7bf 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -23,8 +23,6 @@
 #define _INTEL_IOMMU_H_
 
 #include <linux/types.h>
-#include <linux/msi.h>
-#include <linux/sysdev.h>
 #include <linux/iova.h>
 #include <linux/io.h>
 #include <linux/dma_remapping.h>
@@ -289,7 +287,6 @@ struct intel_iommu {
 	void __iomem	*reg; /* Pointer to hardware regs, virtual addr */
 	u64		cap;
 	u64		ecap;
-	int		seg;
 	u32		gcmd; /* Holds TE, EAFL. Don't need SRTP, SFL, WBF */
 	spinlock_t	register_lock; /* protect register handling */
 	int		seq_id;	/* sequence id of the iommu */
@@ -302,8 +299,6 @@ struct intel_iommu {
 
 	unsigned int irq;
 	unsigned char name[7];    /* Device Name */
-	struct msi_msg saved_msg;
-	struct sys_device sysdev;
 	struct iommu_flush flush;
 #endif
 	struct q_inval  *qi;            /* Queued invalidation info */
-- 
1.6.0.3

