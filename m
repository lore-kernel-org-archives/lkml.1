Return-Path: <linux-kernel-owner+w=401wt.eu-S932105AbXBNAkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbXBNAkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 19:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXBNAkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 19:40:42 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:40614 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105AbXBNAkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 19:40:41 -0500
Date: Wed, 14 Feb 2007 01:40:01 +0100 (MET)
From: Richard Knutsson <ricknu-0@student.ltu.se>
To: Ryan Jackson <rjackson@lnxi.com>, Dave Olsen <dolsen@lnxi.com>,
       David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       Richard Knutsson <ricknu-0@student.ltu.se>
Message-Id: <20070214004002.4391.40668.sendpatchset@thinktank.campus.ltu.se>
Subject: [PATCH] mtd/maps/ck804xrom.c: pci_module_init to pci_register_driver
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert pci_module_init() to pci_register_driver().

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Compile-tested with "allyes", "allmod" & "allno" on i386


diff --git a/drivers/mtd/maps/ck804xrom.c b/drivers/mtd/maps/ck804xrom.c
index 238d42e..1998172 100644
--- a/drivers/mtd/maps/ck804xrom.c
+++ b/drivers/mtd/maps/ck804xrom.c
@@ -310,15 +310,6 @@ static struct pci_device_id ck804xrom_pci_tbl[] = {
 
 MODULE_DEVICE_TABLE(pci, ck804xrom_pci_tbl);
 
-#if 0
-static struct pci_driver ck804xrom_driver = {
-	.name =		MOD_NAME,
-	.id_table =	ck804xrom_pci_tbl,
-	.probe =	ck804xrom_init_one,
-	.remove =	ck804xrom_remove_one,
-};
-#endif
-
 static int __init init_ck804xrom(void)
 {
 	struct pci_dev *pdev;
@@ -337,9 +328,6 @@ static int __init init_ck804xrom(void)
 		return retVal;
 	}
 	return -ENXIO;
-#if 0
-	return pci_module_init(&ck804xrom_driver);
-#endif
 }
 
 static void __exit cleanup_ck804xrom(void)
