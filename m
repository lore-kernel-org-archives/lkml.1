Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbYGFRp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbYGFRp4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757967AbYGFRf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:56 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:6749 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbYGFRfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=CYB6vl7RW4unLJAF0mn+jXD6wBm4Kyov/ADjfru/dAFGutA8qRe1FLiICJTCRcm1Rn
         MRwrrq5HDUQlQIUBJtRHxk0vMrQlhjpZBFRQZX1A+12FzPo6Yz3TbI3VrjYcd0cM7Xtd
         21XmOdSHLw5rRmpgB7LGizQOf44yJAmCCtn04=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:49 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 39/50] sc1200: add ->remove method and module_exit()
Content-Disposition: inline; filename=sc1200-add-remove-method-and-module_exit.patch
Message-ID: <48710260.1ade660a.3458.62d0@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/sc1200.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/sc1200.c
===================================================================
--- a/drivers/ide/pci/sc1200.c
+++ b/drivers/ide/pci/sc1200.c
@@ -329,6 +329,7 @@ static struct pci_driver driver = {
 	.name		= "SC1200_IDE",
 	.id_table	= sc1200_pci_tbl,
 	.probe		= sc1200_init_one,
+	.remove		= ide_pci_remove,
 #ifdef CONFIG_PM
 	.suspend	= sc1200_suspend,
 	.resume		= sc1200_resume,
@@ -340,7 +341,13 @@ static int __init sc1200_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit sc1200_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(sc1200_ide_init);
+module_exit(sc1200_ide_exit);
 
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for NS SC1200 IDE");

-- 

