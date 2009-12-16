Return-Path: <linux-kernel-owner+w=401wt.eu-S935854AbZLPW7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935854AbZLPW7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 17:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763365AbZLPW7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 17:59:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:52371 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763342AbZLPW7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 17:59:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,409,1257148800"; 
   d="scan'208";a="579660496"
From: <tony.luck@intel.com>
To: "David Woodhouse" <David.Woodhouse@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix section mismatch dmar_ir_support() uses dmar_tbl.
Date: Wed, 16 Dec 2009 14:59:29 -0800
Message-Id: <4b29665132095f6eb@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmar_tbl is declared as __initdata, but dmar_ir_support() is not declared
as an __init function.  Fix is simple since the only caller of dmar_ir_support
(intr_remapping_supported) is an __init function.

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 83aae47..ffe22bc 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1456,7 +1456,7 @@ int dmar_reenable_qi(struct intel_iommu *iommu)
 /*
  * Check interrupt remapping support in DMAR table description.
  */
-int dmar_ir_support(void)
+int __init dmar_ir_support(void)
 {
 	struct acpi_table_dmar *dmar;
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
