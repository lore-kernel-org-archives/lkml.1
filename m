Return-Path: <linux-kernel-owner+w=401wt.eu-S1754260Ab0AMBBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754260Ab0AMBBB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 20:01:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211Ab0AMBA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 20:00:57 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab0AMBAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 20:00:55 -0500
Message-Id: <20100113004938.881146778@suse.com>
User-Agent: quilt/0.48-4.4
Date: Tue, 12 Jan 2010 19:48:58 -0500
From: Jeff Mahoney <jeffm@suse.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Youquan Song <youquan.song@intel.com>,
       David Woodhouse <David.Woodhouse@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [patch 3/6] dmar: Fix section mismatch
References: <20100113004855.550486769@suse.com>
Content-Disposition: inline; filename=patches.rpmify/dmar-fix-section-mismatch

 dmar_ir_support uses dmar_tbl, which is __initdata. dmar_ir_support is
 only called by intr_remapping_supported, which is __init. So, we mark
 dmar_ir_support as __init as well.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 drivers/pci/dmar.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1456,7 +1456,7 @@ int dmar_reenable_qi(struct intel_iommu
 /*
  * Check interrupt remapping support in DMAR table description.
  */
-int dmar_ir_support(void)
+int __init dmar_ir_support(void)
 {
 	struct acpi_table_dmar *dmar;
 	dmar = (struct acpi_table_dmar *)dmar_tbl;


