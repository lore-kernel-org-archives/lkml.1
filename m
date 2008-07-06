Return-Path: <linux-kernel-owner+w=401wt.eu-S1760642AbYGFRkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642AbYGFRkz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758744AbYGFRfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:22 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:41596 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758445AbYGFRfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=sr3d651pRKUwLTW/IM8qFnE4rvkxmJpuQxV1NCoGsnygVBIQg8Y5gky7rDhPvKOtUy
         UVUBB1oCUQrVv3+lq45KgJxnhLBBmHlOj+p2awzkhUK9mlnZUP1NLh5g5escYltchHku
         HUxiBtoPFvRVzudjGeyStyl7o/tjFjYJWooYI=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:30 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/50] alim15x3: add ->remove method and module_exit()
Content-Disposition: inline; filename=alim15x3-add-remove-method-and-module_exit.patch
Message-ID: <48710245.1ade660a.3458.6299@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/alim15x3.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -580,6 +580,7 @@ static struct pci_driver driver = {
 	.name		= "ALI15x3_IDE",
 	.id_table	= alim15x3_pci_tbl,
 	.probe		= alim15x3_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init ali15x3_ide_init(void)
@@ -587,7 +588,13 @@ static int __init ali15x3_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit ali15x3_ide_exit(void)
+{
+	return pci_unregister_driver(&driver);
+}
+
 module_init(ali15x3_ide_init);
+module_exit(ali15x3_ide_exit);
 
 MODULE_AUTHOR("Michael Aubry, Andrzej Krzysztofowicz, CJ, Andre Hedrick, Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for ALi 15x3 IDE");

-- 

