Return-Path: <linux-kernel-owner+w=401wt.eu-S1758109AbYGFRmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109AbYGFRmh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758990AbYGFRfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:31 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:13310 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbYGFRfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=NHZ3rbUHjNf5iNv7eO+FMP4ktS/sNkZeFqmfaMOQo5ZcnIH6ga5YuQw8479zZwfErK
         9BUmgvOb+3HddQnnLT/itxY7epI7xxX9lmaG+dLi4VFNSqJe32ir0ccdHeZ6xSTdZmEj
         83e7SBdJgPsG9AKzjJGowMvc/YNewwkXaJAeA=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:35 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 25/50] cs5535: add ->remove method and module_exit()
Content-Disposition: inline; filename=cs5535-add-remove-method-and-module_exit.patch
Message-ID: <4871024b.1ade660a.3458.62a1@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cs5535.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/cs5535.c
===================================================================
--- a/drivers/ide/pci/cs5535.c
+++ b/drivers/ide/pci/cs5535.c
@@ -194,6 +194,7 @@ static struct pci_driver driver = {
 	.name       = "CS5535_IDE",
 	.id_table   = cs5535_pci_tbl,
 	.probe      = cs5535_init_one,
+	.remove     = ide_pci_remove,
 };
 
 static int __init cs5535_ide_init(void)
@@ -201,7 +202,13 @@ static int __init cs5535_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit cs5535_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(cs5535_ide_init);
+module_exit(cs5535_ide_exit);
 
 MODULE_AUTHOR("AMD");
 MODULE_DESCRIPTION("PCI driver module for AMD/NS CS5535 IDE");

-- 

