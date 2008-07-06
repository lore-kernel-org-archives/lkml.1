Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbYGFRmM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbYGFRmM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:42:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757991AbYGFRfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:30 -0400
Received: from gv-out-0910.google.com ([216.239.58.184]:50363 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758017AbYGFRfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=f0dD4u4o93GKYqQpTIO28vtV5e2/ujAQf3Jno+BT6wZR3YccRnC2cyZTw+Gy97Pu1W
         2AwXrZBEMFwxLDsXT0mF0ttWLxoILIriF0L5nOYFxRjpTjPz08hu/ijpVbkQpYkr1wFs
         YgQfCUXV5M4G5+vwCA7ImhvRk7VZLkLJvqIaY=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:31 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 21/50] amd74xx: add ->remove method and module_exit()
Content-Disposition: inline; filename=amd74xx-add-remove-method-and-module_exit.patch
Message-ID: <48710246.1ade660a.3458.629a@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/amd74xx.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/amd74xx.c
===================================================================
--- a/drivers/ide/pci/amd74xx.c
+++ b/drivers/ide/pci/amd74xx.c
@@ -341,6 +341,7 @@ static struct pci_driver driver = {
 	.name		= "AMD_IDE",
 	.id_table	= amd74xx_pci_tbl,
 	.probe		= amd74xx_probe,
+	.remove		= ide_pci_remove,
 };
 
 static int __init amd74xx_ide_init(void)
@@ -348,7 +349,13 @@ static int __init amd74xx_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit amd74xx_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(amd74xx_ide_init);
+module_exit(amd74xx_ide_exit);
 
 MODULE_AUTHOR("Vojtech Pavlik");
 MODULE_DESCRIPTION("AMD PCI IDE driver");

-- 

