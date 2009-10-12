Return-Path: <linux-kernel-owner+w=401wt.eu-S1751345AbZJLETJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345AbZJLETJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 00:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZJLETI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 00:19:08 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:40092 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZJLETH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 00:19:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=CZBcPEIt1A/sepqBNV7U925+EPMGRWZn/WQlTGW6CGsejPObYXD9AWkOYwgu1/gHjW
         Zmgrdco0Ky1ollmn7kwQ1R7gHf2/Rp0JjtGmfJEvpgUtr9n4PWctA3kMXD0I2t70KQmy
         /3J6mN2tHdO2htOrjRwEogLZGdt0pklTonq2g=
From: Stephen Boyd <bebarino@gmail.com>
To: linux-pci@vger.kernel.org
Cc: David Woodhouse <David.Woodhouse@intel.com>, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] pci/dmar: fix section mismatch in dmar_ir_support()
Date: Sun, 11 Oct 2009 21:20:49 -0700
Message-Id: <1255321249-25546-1-git-send-email-bebarino@gmail.com>
X-Mailer: git-send-email 1.6.5.195.geae96
In-Reply-To: <1254543340-4473-1-git-send-email-bebarino@gmail.com>
References: <1254543340-4473-1-git-send-email-bebarino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmar_ir_support() references dmar_tbl which is annotated with
__initdata. The only caller of dmar_ir_support() is
intr_remapping_supported() also annotated with __init. Therefore add the
__init annotation to dmar_ir_support().

WARNING: drivers/pci/built-in.o(.text+0xa110): Section mismatch in
reference from the function dmar_ir_support() to the variable
.init.data:dmar_tbl
The function dmar_ir_support() references
the variable __initdata dmar_tbl.
This is often because dmar_ir_support lacks a __initdata
annotation or the annotation of dmar_tbl is wrong.
---

I sent this a week back but it looks like it didn't stick. Hopefully it
does this time.

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
1.6.5.195.geae96

