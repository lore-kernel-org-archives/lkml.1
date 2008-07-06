Return-Path: <linux-kernel-owner+w=401wt.eu-S1760589AbYGFRpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589AbYGFRpQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757942AbYGFRfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:51 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:50363 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969AbYGFRf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=Q+yboysp5rlTLIhIludGzVtfmVsNijh0Y2th2pZYKFFxUTDwzpAQTlkT482AxQN9lB
         qidr+/UKLZphafAwhILQLLFMC0PZ2Tq+2+ImrMfCFFZ0V29ARdh33emjoupsFltCtcOQ
         2YjfSoRZ0lbswY07Dn6sQ7JHm3C3lBisovQAU=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:48 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 38/50] rz1000: add ->remove method and module_exit()
Content-Disposition: inline; filename=rz1000-add-remove-method-and-module_exit.patch
Message-ID: <4871025f.1ade660a.3458.62cd@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/rz1000.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/rz1000.c
===================================================================
--- a/drivers/ide/pci/rz1000.c
+++ b/drivers/ide/pci/rz1000.c
@@ -62,6 +62,7 @@ static struct pci_driver driver = {
 	.name		= "RZ1000_IDE",
 	.id_table	= rz1000_pci_tbl,
 	.probe		= rz1000_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init rz1000_ide_init(void)
@@ -69,7 +70,13 @@ static int __init rz1000_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit rz1000_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(rz1000_ide_init);
+module_exit(rz1000_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for RZ1000 IDE");

-- 

