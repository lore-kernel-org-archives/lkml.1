Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbYGFRpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbYGFRpl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbYGFRfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:54 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:9934 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758966AbYGFRfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=HNAbnpXXM+MfzTQk5TSnNuvnjlWckgA/epKPg248nxxEmZKrm93MXPH38pgQBAioMx
         RaFfNZux8jr3905syZ86/60ao4rOQ4q6iUXcQTrTz5SGypo8FzfdQAR2M1FDayuGuYde
         pl0LvjRnL4J0ipqMvSDhz5ps5i2f92dDl41Cc=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:47 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 37/50] piix: add ->remove method and module_exit()
Content-Disposition: inline; filename=piix-add-remove-method-and-module_exit.patch
Message-ID: <4871025d.1ade660a.3458.62ca@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/piix.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/piix.c
===================================================================
--- a/drivers/ide/pci/piix.c
+++ b/drivers/ide/pci/piix.c
@@ -462,6 +462,7 @@ static struct pci_driver driver = {
 	.name		= "PIIX_IDE",
 	.id_table	= piix_pci_tbl,
 	.probe		= piix_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init piix_ide_init(void)
@@ -470,7 +471,13 @@ static int __init piix_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit piix_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(piix_ide_init);
+module_exit(piix_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick, Andrzej Krzysztofowicz");
 MODULE_DESCRIPTION("PCI driver module for Intel PIIX IDE");

-- 

