Return-Path: <linux-kernel-owner+w=401wt.eu-S965010AbXB0JVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965010AbXB0JVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:21:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965014AbXB0JVw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:21:52 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:48570 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965010AbXB0JVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:21:51 -0500
Date: Tue, 27 Feb 2007 10:22:00 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] aer: fix section mismatch warning
Message-ID: <20070227092200.GB21721@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following section mismatch warning (when compiled with CONFIG_HOTPLUG=n):
WARNING: drivers/pci/built-in.o - Section mismatch: reference to .init.text:aer_probe from .data between 'aerdrv' (at offset 0x1608) and 'aer_error_handlers'

Warning was fixed by renaming aerdrv to aerdriver so we pass the whitelist.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index b164de0..db6ad8e 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -66,7 +66,7 @@ static struct pci_error_handlers aer_error_handlers = {
 	.resume = aer_error_resume,
 };
 
-static struct pcie_port_service_driver aerdrv = {
+static struct pcie_port_service_driver aerdriver = {
 	.name		= "aer",
 	.id_table	= &aer_id[0],
 
@@ -328,7 +328,7 @@ static void aer_error_resume(struct pci_dev *dev)
  **/
 static int __init aer_service_init(void)
 {
-	return pcie_port_service_register(&aerdrv);
+	return pcie_port_service_register(&aerdriver);
 }
 
 /**
@@ -338,7 +338,7 @@ static int __init aer_service_init(void)
  **/
 static void __exit aer_service_exit(void)
 {
-	pcie_port_service_unregister(&aerdrv);
+	pcie_port_service_unregister(&aerdriver);
 }
 
 module_init(aer_service_init);
