Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbYGFRm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbYGFRm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758998AbYGFRfd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:35:33 -0400
Received: from gv-out-0910.google.com ([216.239.58.185]:55163 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139AbYGFRfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=KJF69BZ9CqsmBsinUYKguipehHrEPt9T15REmh7AbX8bEJAB6YukAjIfz/EQ8I/o+U
         oaACcl5SIZpt0RFYhkpEcDLyetddZOg3fGPTVvfzNKWjW3OTx8lLYAzNq3eOywNvHbSF
         /v23uPyYF4/BgKk8R5QPBPw0qqPG8OCKTB15M=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:38 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 28/50] hpt34x: add ->remove method and module_exit()
Content-Disposition: inline; filename=hpt34x-add-remove-method-and-module_exit.patch
Message-ID: <4871024e.1ade660a.3458.62a9@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/hpt34x.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/hpt34x.c
===================================================================
--- a/drivers/ide/pci/hpt34x.c
+++ b/drivers/ide/pci/hpt34x.c
@@ -169,6 +169,7 @@ static struct pci_driver driver = {
 	.name		= "HPT34x_IDE",
 	.id_table	= hpt34x_pci_tbl,
 	.probe		= hpt34x_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init hpt34x_ide_init(void)
@@ -176,7 +177,13 @@ static int __init hpt34x_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit hpt34x_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(hpt34x_ide_init);
+module_exit(hpt34x_ide_exit);
 
 MODULE_AUTHOR("Andre Hedrick");
 MODULE_DESCRIPTION("PCI driver module for Highpoint 34x IDE");

-- 

