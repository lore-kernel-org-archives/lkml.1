Return-Path: <linux-kernel-owner+w=401wt.eu-S1759293AbYGFRnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293AbYGFRnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759039AbYGFRff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:35 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:6801 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696AbYGFRfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=jQ5Xr2bbQItJHnT8+Q1ZJI9n+RZYDFNwZ7qgbiaCfEMO++K4U+441PplpT4JnerBOc
         t01xDRP4BwiNFCw9+52SuQKmQPZnFmKmRV9unRqwdptAhOi9Egwl1HEAtNgENhcDmhEg
         BF7dZRo6hZp00QYNoD21+dYVteoBVefQS67TE=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:37 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/50] ide/pci/generic: add ->remove method and module_exit()
Content-Disposition: inline; filename=generic-add-remove-method-and-module_exit.patch
Message-ID: <4871024d.1ade660a.3458.62a7@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/generic.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/generic.c
===================================================================
--- a/drivers/ide/pci/generic.c
+++ b/drivers/ide/pci/generic.c
@@ -174,6 +174,7 @@ static struct pci_driver driver = {
 	.name		= "PCI_IDE",
 	.id_table	= generic_pci_tbl,
 	.probe		= generic_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init generic_ide_init(void)
@@ -181,7 +182,13 @@ static int __init generic_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit generic_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(generic_ide_init);
+module_exit(generic_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for generic PCI IDE");

-- 

