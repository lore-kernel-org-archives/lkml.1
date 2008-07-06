Return-Path: <linux-kernel-owner+w=401wt.eu-S1760040AbYGFRoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760040AbYGFRoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759175AbYGFRfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:43 -0400
Received: from gv-out-0910.google.com ([216.239.58.187]:49197 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449AbYGFRfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=ki/RDJWMe3pVvl3HzyPEHw0zhLjFJLyUiZSv0j8xqABVsRpGHZZya7f4ADLhepmaSC
         CHkibXyaT++TdDIp8aQGFePUcsgj4PWqsFj7J2OfRD7u9UVq/E/yN0hDRYdAsqQQhCuS
         yxqhjPibwzsht/8nv92CZbq1KJzg6Z2xUdRjk=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:40 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 30/50] it8213: add ->remove method and module_exit()
Content-Disposition: inline; filename=it8213-add-remove-method-and-module_exit.patch
Message-ID: <48710250.1ade660a.3458.62ae@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/it8213.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/it8213.c
===================================================================
--- a/drivers/ide/pci/it8213.c
+++ b/drivers/ide/pci/it8213.c
@@ -198,6 +198,7 @@ static struct pci_driver driver = {
 	.name		= "ITE8213_IDE",
 	.id_table	= it8213_pci_tbl,
 	.probe		= it8213_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init it8213_ide_init(void)
@@ -205,7 +206,13 @@ static int __init it8213_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit it8213_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(it8213_ide_init);
+module_exit(it8213_ide_exit);
 
 MODULE_AUTHOR("Jack Lee, Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for the ITE 8213");

-- 

