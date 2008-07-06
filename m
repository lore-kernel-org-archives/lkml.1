Return-Path: <linux-kernel-owner+w=401wt.eu-S1761900AbYGFRv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761900AbYGFRv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbYGFRg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:26 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:6749 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758421AbYGFRfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=cVRjcCxd1QGJx06MYgj6MdbXk6PUpbkAOByGElMiFoFCeVimWRsr+0x7OhxiIo+py8
         itx4PscMcYrCr/jLrCZ6GmxaRtAxF5bICV1Xx7EODKea1Y7CEmk4vJm8B0Pt0kJCxsoN
         fiQ5n2DeE9xexLQPBuAtlc5NCdE375v/1knJc=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:29 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/50] aec62xx: add ->remove method and module_exit()
Content-Disposition: inline; filename=aec62xx-add-remove-method-and-module_exit.patch
Message-ID: <48710244.1ade660a.3458.6295@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/aec62xx.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

Index: b/drivers/ide/pci/aec62xx.c
===================================================================
--- a/drivers/ide/pci/aec62xx.c
+++ b/drivers/ide/pci/aec62xx.c
@@ -280,6 +280,12 @@ static int __devinit aec62xx_init_one(st
 	return err;
 }
 
+static void __devexit aec62xx_remove(struct pci_dev *dev)
+{
+	ide_pci_remove(dev);
+	pci_disable_device(dev);
+}
+
 static const struct pci_device_id aec62xx_pci_tbl[] = {
 	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP850UF), 0 },
 	{ PCI_VDEVICE(ARTOP, PCI_DEVICE_ID_ARTOP_ATP860),   1 },
@@ -294,6 +300,7 @@ static struct pci_driver driver = {
 	.name		= "AEC62xx_IDE",
 	.id_table	= aec62xx_pci_tbl,
 	.probe		= aec62xx_init_one,
+	.remove		= aec62xx_remove,
 };
 
 static int __init aec62xx_ide_init(void)
@@ -301,7 +308,13 @@ static int __init aec62xx_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit aec62xx_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(aec62xx_ide_init);
+module_exit(aec62xx_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for ARTOP AEC62xx IDE");

-- 

