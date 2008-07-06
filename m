Return-Path: <linux-kernel-owner+w=401wt.eu-S1760320AbYGFRlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760320AbYGFRlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758935AbYGFRf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:6749 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659AbYGFRfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=JvLWuMkc6zz5yXBuB/K+uttnBViihpQs/PSF1WzlYfz4fksdBHo89aUkKDrXIwBNGO
         ADaxq+pWXALgBzvSnwN3S2ih4z5OWY+ZfnhE6Hq6yeVTS3J1FzHN3fQM8KBwAFNila2B
         c/StSzY2Nr3F1iihRMQ+VBsybJSlpcl/GXTVY=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:34 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 24/50] cs5530: add ->remove method and module_exit()
Content-Disposition: inline; filename=cs5530-add-remove-method-and-module_exit.patch
Message-ID: <4871024a.1ade660a.3458.629e@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cs5530.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/cs5530.c
===================================================================
--- a/drivers/ide/pci/cs5530.c
+++ b/drivers/ide/pci/cs5530.c
@@ -269,6 +269,7 @@ static struct pci_driver driver = {
 	.name		= "CS5530 IDE",
 	.id_table	= cs5530_pci_tbl,
 	.probe		= cs5530_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init cs5530_ide_init(void)
@@ -276,7 +277,13 @@ static int __init cs5530_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit cs5530_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(cs5530_ide_init);
+module_exit(cs5530_ide_exit);
 
 MODULE_AUTHOR("Mark Lord");
 MODULE_DESCRIPTION("PCI driver module for Cyrix/NS 5530 IDE");

-- 

