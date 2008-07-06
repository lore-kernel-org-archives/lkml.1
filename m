Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbYGFRld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbYGFRld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758899AbYGFRf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:26 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:41596 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758099AbYGFRfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=CMRqWZMc+8/rAqPB+XfY0KcsmUo9ZN3SAOyB3Md65IGXkd0e38k7NdclMu3YwUuiqR
         aNys4AXCPqRdNvve75Z4rus9wyOWOooisAcBSSE+RwAtO0EI1C8KW51Og+xYXeVNVJwL
         ftH89NPKvUi6UctIiBYC8SE3g99e9WmiaFgVg=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:33 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: [PATCH 23/50] cmd64x: add ->remove method and module_exit()
Content-Disposition: inline; filename=cmd64x-add-remove-method-and-module_exit.patch
Message-ID: <48710248.1ade660a.3458.629d@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd64x.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/cmd64x.c
===================================================================
--- a/drivers/ide/pci/cmd64x.c
+++ b/drivers/ide/pci/cmd64x.c
@@ -505,6 +505,7 @@ static struct pci_driver driver = {
 	.name		= "CMD64x_IDE",
 	.id_table	= cmd64x_pci_tbl,
 	.probe		= cmd64x_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init cmd64x_ide_init(void)
@@ -512,7 +513,13 @@ static int __init cmd64x_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit cmd64x_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(cmd64x_ide_init);
+module_exit(cmd64x_ide_exit);
 
 MODULE_AUTHOR("Eddie Dost, David Miller, Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for CMD64x IDE");

-- 

