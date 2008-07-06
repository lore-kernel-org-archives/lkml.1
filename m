Return-Path: <linux-kernel-owner+w=401wt.eu-S1761413AbYGFRs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761413AbYGFRs1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759261AbYGFRgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:12328 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759085AbYGFRfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=jrJxuHfOZgmHErbr66TY+geT249rsxBexLGWJoefNOedIA49qHmlBXswoAQeOCYRTP
         SQzbU+uIlN7ZQmptC2nB0MiIFbhiMxsHEUYv8frXPB7IGMgwcYPvTmZsuwcVaYKJvljB
         HcUpJaCdE5R3WIE2LoOXV99QmTWCAOk+F8MKY=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:55 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 45/50] tc86c001: add ->remove method and module_exit()
Content-Disposition: inline; filename=tc86c001-add-remove-method-and-module_exit.patch
Message-ID: <48710269.1ade660a.3458.62e0@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/tc86c001.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

Index: b/drivers/ide/pci/tc86c001.c
===================================================================
--- a/drivers/ide/pci/tc86c001.c
+++ b/drivers/ide/pci/tc86c001.c
@@ -232,6 +232,13 @@ out:
 	return rc;
 }
 
+static void __devexit tc86c001_remove(struct pci_dev *dev)
+{
+	ide_pci_remove(dev);
+	pci_release_region(dev, 5);
+	pci_disable_device(dev);
+}
+
 static const struct pci_device_id tc86c001_pci_tbl[] = {
 	{ PCI_VDEVICE(TOSHIBA_2, PCI_DEVICE_ID_TOSHIBA_TC86C001_IDE), 0 },
 	{ 0, }
@@ -241,14 +248,22 @@ MODULE_DEVICE_TABLE(pci, tc86c001_pci_tb
 static struct pci_driver driver = {
 	.name		= "TC86C001",
 	.id_table	= tc86c001_pci_tbl,
-	.probe		= tc86c001_init_one
+	.probe		= tc86c001_init_one,
+	.remove		= tc86c001_remove,
 };
 
 static int __init tc86c001_ide_init(void)
 {
 	return ide_pci_register_driver(&driver);
 }
+
+static void __exit tc86c001_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(tc86c001_ide_init);
+module_exit(tc86c001_ide_exit);
 
 MODULE_AUTHOR("MontaVista Software, Inc. <source@mvista.com>");
 MODULE_DESCRIPTION("PCI driver module for TC86C001 IDE");

-- 

