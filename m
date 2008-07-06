Return-Path: <linux-kernel-owner+w=401wt.eu-S1758106AbYGFRog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106AbYGFRog (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757164AbYGFRfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:46 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:50363 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758746AbYGFRfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=kRGe+yRXxHGKe1AsT9HlCKhtofjB5u7XoK7w3NF5L3+qQzZ2QpjRtZHDqxoDaPp7Gu
         LBahsSc06QaqLXilJ+9lGg7yHfY91x16LPFnFSf16MqOvDY6q6PMVfq4aC+BzEPqOcAY
         attph+KMcy1P9cRrCF1vhHWu4nidiSSyoUtWY=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:44 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 34/50] opti621: add ->remove method and module_exit()
Content-Disposition: inline; filename=opti621-add-remove-method-and-module_exit.patch
Message-ID: <48710259.1ade660a.3458.62c0@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/opti621.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/opti621.c
===================================================================
--- a/drivers/ide/pci/opti621.c
+++ b/drivers/ide/pci/opti621.c
@@ -223,6 +223,7 @@ static struct pci_driver driver = {
 	.name		= "Opti621_IDE",
 	.id_table	= opti621_pci_tbl,
 	.probe		= opti621_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init opti621_ide_init(void)
@@ -230,7 +231,13 @@ static int __init opti621_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit opti621_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(opti621_ide_init);
+module_exit(opti621_ide_exit);
 
 MODULE_AUTHOR("Jaromir Koutek, Jan Harkes, Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for Opti621 IDE");

-- 

