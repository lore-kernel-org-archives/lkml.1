Return-Path: <linux-kernel-owner+w=401wt.eu-S1761050AbYGFRqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761050AbYGFRqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758253AbYGFRf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:59 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:6801 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbYGFRfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=I6lLubE0+3LhTWdjGoXiwJLd0+RiqU/ihp6+yfy8QoP3bhMeFPfw8wxwy2dRCMNq9R
         4lbatKgYou+ytLRqEdOtqpC/tpfyEj678haz7kIwpJdviBS5XPPzHekDSkynIyHuw04D
         QqQ2MBuZ9BXN2aPLNxXvjroD6hJGvGuN3bRZM=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:50 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 40/50] serverworks: add ->remove method and module_exit()
Content-Disposition: inline; filename=serverworks-add-remove-method-and-module_exit.patch
Message-ID: <48710263.1ade660a.3458.62d6@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/serverworks.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/serverworks.c
===================================================================
--- a/drivers/ide/pci/serverworks.c
+++ b/drivers/ide/pci/serverworks.c
@@ -439,6 +439,7 @@ static struct pci_driver driver = {
 	.name		= "Serverworks_IDE",
 	.id_table	= svwks_pci_tbl,
 	.probe		= svwks_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init svwks_ide_init(void)
@@ -446,7 +447,13 @@ static int __init svwks_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit svwks_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(svwks_ide_init);
+module_exit(svwks_ide_exit);
 
 MODULE_AUTHOR("Michael Aubry. Andrzej Krzysztofowicz, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for Serverworks OSB4/CSB5/CSB6 IDE");

-- 

