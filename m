Return-Path: <linux-kernel-owner+w=401wt.eu-S1761410AbYGFRs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761410AbYGFRs6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYGFRgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:7197 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759126AbYGFRfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=FLfbelWTVNkFH3i0L7KJ9DJmdGz4KvhHuXboZKjBQTtQbfNgfbuFHNYYUmA8pl2A0S
         qG8oDxFjnfiwTMZvKX1rQEcXiI+dDNw8vUddWixkAnqFuzI7QBaXq6nB0bzyMrBCd1fl
         axJEHzGcQcsJiDprJ1ihZbvJrd8FPRUlHqI7c=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:57 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 47/50] trm290: add ->remove method and module_exit()
Content-Disposition: inline; filename=trm290-add-remove-method-and-module_exit.patch
Message-ID: <4871026b.1ade660a.3458.62e5@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/trm290.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/trm290.c
===================================================================
--- a/drivers/ide/pci/trm290.c
+++ b/drivers/ide/pci/trm290.c
@@ -353,6 +353,7 @@ static struct pci_driver driver = {
 	.name		= "TRM290_IDE",
 	.id_table	= trm290_pci_tbl,
 	.probe		= trm290_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init trm290_ide_init(void)
@@ -360,7 +361,13 @@ static int __init trm290_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit trm290_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(trm290_ide_init);
+module_exit(trm290_ide_exit);
 
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for Tekram TRM290 IDE");

-- 

