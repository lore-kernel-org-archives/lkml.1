Return-Path: <linux-kernel-owner+w=401wt.eu-S1759913AbYGFRnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759913AbYGFRnh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759061AbYGFRfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:38 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:6801 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756246AbYGFRfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=rZImcuERXqCTVSxR4omvDIxbcYvyZLrERz4/Groyd4tixFyDtJb3fQHcmFhur2Me5A
         EJSbr4slddkj9o6w62Do/K5WXLpvmA7K2FMjzd21XufIKRlASlq3/99IYaTy+yYIL2+c
         cqSJ1RBkOX5Z3epDU4DzNVQlEsbT5m+va40LE=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:42 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 32/50] jmicron: add ->remove method and module_exit()
Content-Disposition: inline; filename=jmicron-add-remove-method-and-module_exit.patch
Message-ID: <48710253.1ade660a.3458.62b3@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/jmicron.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/jmicron.c
===================================================================
--- a/drivers/ide/pci/jmicron.c
+++ b/drivers/ide/pci/jmicron.c
@@ -152,6 +152,7 @@ static struct pci_driver driver = {
 	.name		= "JMicron IDE",
 	.id_table	= jmicron_pci_tbl,
 	.probe		= jmicron_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init jmicron_ide_init(void)
@@ -159,7 +160,13 @@ static int __init jmicron_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit jmicron_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(jmicron_ide_init);
+module_exit(jmicron_ide_exit);
 
 MODULE_AUTHOR("Alan Cox");
 MODULE_DESCRIPTION("PCI driver module for the JMicron in legacy modes");

-- 

