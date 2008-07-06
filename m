Return-Path: <linux-kernel-owner+w=401wt.eu-S1761708AbYGFRr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761708AbYGFRr5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759247AbYGFRgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:36:11 -0400
Received: from gv-out-0910.google.com ([216.239.58.188]:41596 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759090AbYGFRfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:35:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=F+FmwOO5Pp7PkiOoKVRNXkmsmD31ED4JtSsyFAf6BZ27yqsXGgkhxdc62VHHHTCXUs
         RsNWve+2ShCsAUtcZWEXbrjDtVG/oOqM7mFGMsTa/KB79o0nMObungLKRdolMWUPNakF
         wHzSVP6DnjGhnimzGvw5HtfOCEMtxa7Ma8j74=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:56 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 46/50] triflex: add ->remove method and module_exit()
Content-Disposition: inline; filename=triflex-add-remove-method-and-module_exit.patch
Message-ID: <4871026a.1ade660a.3458.62e2@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/triflex.c |    7 +++++++
 1 file changed, 7 insertions(+)

Index: b/drivers/ide/pci/triflex.c
===================================================================
--- a/drivers/ide/pci/triflex.c
+++ b/drivers/ide/pci/triflex.c
@@ -117,6 +117,7 @@ static struct pci_driver driver = {
 	.name		= "TRIFLEX_IDE",
 	.id_table	= triflex_pci_tbl,
 	.probe		= triflex_init_one,
+	.remove		= ide_pci_remove,
 };
 
 static int __init triflex_ide_init(void)
@@ -124,7 +125,13 @@ static int __init triflex_ide_init(void)
 	return ide_pci_register_driver(&driver);
 }
 
+static void __exit triflex_ide_exit(void)
+{
+	pci_unregister_driver(&driver);
+}
+
 module_init(triflex_ide_init);
+module_exit(triflex_ide_exit);
 
 MODULE_AUTHOR("Torben Mathiasen");
 MODULE_DESCRIPTION("PCI driver module for Compaq Triflex IDE");

-- 

