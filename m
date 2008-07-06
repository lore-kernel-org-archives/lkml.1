Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbYGFRow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbYGFRow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758190AbYGFRfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:48 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:49197 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758777AbYGFRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=W69IE35coDpbT4WkxHWiySNX5AfVOU8X/sJYMOip10ZGjLBBUYv4vaHzx2Tg7SZtTF
         snJOGtKrHlh9KxNhN7leWWqjsR/m3LsQJriL/+NsgRCd62PFd1yefS47ZOlF0q+nKP+H
         fKJ0FabInrVahkNDAPlsT8VcSC0kz9UZ3i4rE=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:46 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 36/50] pdc202xx_old: add ->remove method and module_exit()
Content-Disposition: inline; filename=pdc202xx_old-add-remove-method-and-module_exit.patch
Message-ID: <4871025c.1ade660a.3458.62c7@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/pdc202xx_old.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/pdc202xx_old.c
===================================================================
--- a/drivers/ide/pci/pdc202xx_old.c
+++ b/drivers/ide/pci/pdc202xx_old.c
@@ -429,6 +429,7 @@ static struct pci_driver driver = {
 	.name		= "Promise_Old_IDE",
 	.id_table	= pdc202xx_pci_tbl,
 	.probe		= pdc202xx_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init pdc202xx_ide_init(void)
@@ -436,7 +437,13 @@ static int __init pdc202xx_ide_init(void
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit pdc202xx_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(pdc202xx_ide_init);
+module_exit(pdc202xx_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick, Frank Tiernan");
 MODULE_DESCRIPTION("PCI driver module for older Promise IDE");

-- 

