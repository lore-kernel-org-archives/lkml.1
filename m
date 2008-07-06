Return-Path: <linux-kernel-owner+w=401wt.eu-S1760681AbYGFRlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681AbYGFRlS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbYGFRfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:7197 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758501AbYGFRfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=RztkBPuICmwQN59hfOa7rrEHTnuCn9d81k6vgTg3YlZbLwPKUdhUYDiMu6kC/bmZq5
         iDxXeJnL+aMmlgoiOOTuazkE3VDxrvbZNoFaRI4MqnarF6++E0xxIbL8z0KIaa9L6Mrw
         mLx1z98BkedDEERUvJEVtl0wd6GPmdCjdJDlg=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:32 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 22/50] atiixp: add ->remove method and module_exit()
Content-Disposition: inline; filename=atiixp-add-remove-method-and-module_exit.patch
Message-ID: <48710247.1ade660a.3458.629b@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/atiixp.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/atiixp.c
===================================================================
--- a/drivers/ide/pci/atiixp.c
+++ b/drivers/ide/pci/atiixp.c
@@ -184,6 +184,7 @@ static struct pci_driver driver = {
 	.name		= "ATIIXP_IDE",
 	.id_table	= atiixp_pci_tbl,
 	.probe		= atiixp_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init atiixp_ide_init(void)
@@ -191,7 +192,13 @@ static int __init atiixp_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit atiixp_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(atiixp_ide_init);
+module_exit(atiixp_ide_exit);
 
 MODULE_AUTHOR("HUI YU");
 MODULE_DESCRIPTION("PCI driver module for ATI IXP IDE");

-- 

