Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbYGFRrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbYGFRrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758445AbYGFRgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:09 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:12325 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759068AbYGFRfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=YRsto//JRlpaPoiqIyiZOls6CR5q9lJiH5jxg5IwKKdXI7wB1K5IYNJFkBfP1k2D3C
         lbbIO+9TD5D0VZvr/vOvBzAFlJsG2iCyCQ2OA3M833BxYU0h3qZFrH68xbf36wsDUfQV
         Xf16FCKJA2vlL39VSfxoXAmk/aV4uj/BMREoM=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:53 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 43/50] sl82c105: add ->remove method and module_exit()
Content-Disposition: inline; filename=sl82c105-add-remove-method-and-module_exit.patch
Message-ID: <48710266.1ade660a.3458.62dc@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/sl82c105.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/sl82c105.c
===================================================================
--- a/drivers/ide/pci/sl82c105.c
+++ b/drivers/ide/pci/sl82c105.c
@@ -348,6 +348,7 @@ static struct pci_driver driver = {
 	.name		= "W82C105_IDE",
 	.id_table	= sl82c105_pci_tbl,
 	.probe		= sl82c105_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init sl82c105_ide_init(void)
@@ -355,7 +356,13 @@ static int __init sl82c105_ide_init(void
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit sl82c105_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(sl82c105_ide_init);
+module_exit(sl82c105_ide_exit);
 
 MODULE_DESCRIPTION("PCI driver module for W82C105 IDE");
 MODULE_LICENSE("GPL");

-- 

