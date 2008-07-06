Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbYGFRqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbYGFRqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755943AbYGFRgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:05 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:6827 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758646AbYGFRfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=aEEiNQj2HFzVYq8GHpj+Ukbd4AkDzNXL+IbswOc8RmXY6IJM2I4x8DKI31Qf7RRngb
         a/GBIuXNxTEoFz0rBQ4QV89gA2STIYIFItKmij3iwazOesGnhGNOx0ywYkXktG1fqUuO
         T0NUHaBMnNLopx980PUvFZ0015a4kK0nK9yf0=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:43 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 33/50] ns87415: add ->remove method and module_exit()
Content-Disposition: inline; filename=ns87415-add-remove-method-and-module_exit.patch
Message-ID: <48710254.1ade660a.3458.62b7@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/ns87415.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/ns87415.c
===================================================================
--- a/drivers/ide/pci/ns87415.c
+++ b/drivers/ide/pci/ns87415.c
@@ -341,6 +341,7 @@ static struct pci_driver driver = {
 	.name		= "NS87415_IDE",
 	.id_table	= ns87415_pci_tbl,
 	.probe		= ns87415_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init ns87415_ide_init(void)
@@ -348,7 +349,13 @@ static int __init ns87415_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit ns87415_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(ns87415_ide_init);
+module_exit(ns87415_ide_exit);
 
 MODULE_AUTHOR("Mark Lord, Eddie Dost, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for NS87415 IDE");

-- 

