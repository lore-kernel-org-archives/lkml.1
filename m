Return-Path: <linux-kernel-owner+w=401wt.eu-S1751090AbZJCENh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090AbZJCENh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 00:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbZJCENg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 00:13:36 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:47808 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZJCENf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 00:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i904vnzEsf7Bc2ufmWOIH/K8UUM1C2rT56PMOwHm18fGPAMVD/WE5h0i9b29ysbRX+
         0aHZyf6Jj+IGl8UzoMdjUcjB9tnF8Q2dY0uKFnQ5JqCgilFwNKYB+bqST1Ke+mr3+W2e
         uLhf7X7uLg3icpgoS32m7RG92NWzHaRCLd2aU=
From: Stephen Boyd <bebarino@gmail.com>
To: linux-pci@vger.kernel.org
Cc: Youquan Song <youquan.song@intel.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] pci/dmar: add __init annotation to dmar_ir_support()
Date: Fri,  2 Oct 2009 21:15:40 -0700
Message-Id: <1254543340-4473-1-git-send-email-bebarino@gmail.com>
X-Mailer: git-send-email 1.6.5.rc1.44.ga1675
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmar_ir_support() references dmar_tbl which is annotated with
__initdata. The only caller of dmar_ir_support() is
intr_remapping_supported() also annotated with __init.

WARNING: drivers/pci/built-in.o(.text+0xa110): Section mismatch in
reference from the function dmar_ir_support() to the variable
.init.data:dmar_tbl
The function dmar_ir_support() references
the variable __initdata dmar_tbl.
This is often because dmar_ir_support lacks a __initdata
annotation or the annotation of dmar_tbl is wrong.

Signed-off-by: Stephen Boyd <bebarino@gmail.com>
---
 drivers/pci/dmar.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 14bbaa1..fbca5e7 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -1327,7 +1327,7 @@ int dmar_reenable_qi(struct intel_iommu *iommu)
 /*
  * Check interrupt remapping support in DMAR table description.
  */
-int dmar_ir_support(void)
+int __init dmar_ir_support(void)
 {
 	struct acpi_table_dmar *dmar;
 	dmar = (struct acpi_table_dmar *)dmar_tbl;
-- 
1.6.5.rc1.44.ga1675

