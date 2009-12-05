Return-Path: <linux-kernel-owner+w=401wt.eu-S932769AbZLEBcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769AbZLEBcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 20:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932730AbZLEBcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 20:32:17 -0500
Received: from alerce.vps.bitfolk.com ([212.13.194.134]:2738 "EHLO
	alerce.vps.bitfolk.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932727AbZLEBcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 20:32:17 -0500
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Youquan Song <youquan.song@intel.com>,
       Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH] Fix dmar_ir_support() section mismatch
Date: Fri,  4 Dec 2009 22:31:32 -0300
Message-Id: <1259976692-389-1-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.5.2.372.gc0502
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmar_ir_support() uses the static dmar_tbl variable, which is annotated as
__initdata. This causes a section mismatch because the function is not
annotated as __init.

Since it is only used by (__init) intr_remapping_supported(), fix the
mismatch by annotating it with __init.

The code was introduced by commit 074835f0, Sep 9 2009.

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 drivers/pci/dmar.c          |    2 +-
 include/linux/intel-iommu.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index b952ebc..e6aa94e 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1370,7 +1370,7 @@ int dmar_reenable_qi(struct intel_iommu *iommu)
 /*
  * Check interrupt remapping support in DMAR table description.
  */
-int dmar_ir_support(void)
+int __init dmar_ir_support(void)
 {
 	struct acpi_table_dmar *dmar;
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 4f0a72a..46d2c21 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -360,6 +360,6 @@ extern void qi_flush_dev_iotlb(struct intel_iommu *iommu, u16 sid, u16 qdep,
 
 extern int qi_submit_sync(struct qi_desc *desc, struct intel_iommu *iommu);
 
-extern int dmar_ir_support(void);
+extern int __init dmar_ir_support(void);
 
 #endif
-- 
1.6.5.2.372.gc0502

