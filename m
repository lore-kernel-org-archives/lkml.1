Return-Path: <linux-kernel-owner+w=401wt.eu-S1761841AbYGFRsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841AbYGFRsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759280AbYGFRgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:14 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:49197 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758279AbYGFRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=k69IN9ss0nJ5uTIGkayCoZ4uaG54El14OZYgRsiBM0y+SYJQDMIC+S0wIlfBBVIXxX
         udnXmkZrPJe5RLXHzY7w+ni2QTibLpM4ptAFvtuspx0E2LiC4i5i5pdNKYwWasSrkUua
         TTJ0xRyzCFQo9MRzuDdoHLJPO5opS5QdxDXR8=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:54 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 44/50] slc90e66: add ->remove method and module_exit()
Content-Disposition: inline; filename=slc90e66-add-remove-method-and-module_exit.patch
Message-ID: <48710268.1ade660a.3458.62df@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/slc90e66.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/slc90e66.c
===================================================================
--- a/drivers/ide/pci/slc90e66.c
+++ b/drivers/ide/pci/slc90e66.c
@@ -157,6 +157,7 @@ static struct pci_driver driver = {
 	.name		= "SLC90e66_IDE",
 	.id_table	= slc90e66_pci_tbl,
 	.probe		= slc90e66_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init slc90e66_ide_init(void)
@@ -164,7 +165,13 @@ static int __init slc90e66_ide_init(void
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit slc90e66_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(slc90e66_ide_init);
+module_exit(slc90e66_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for SLC90E66 IDE");

-- 

