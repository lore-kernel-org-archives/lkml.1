Return-Path: <linux-kernel-owner+w=401wt.eu-S964978AbXB0JSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978AbXB0JSp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 04:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965010AbXB0JSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 04:18:45 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:40460 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964978AbXB0JSo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 04:18:44 -0500
Date: Tue, 27 Feb 2007 10:19:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <greg@kroah.com>
Cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] pcie: fix section mismatch warning
Message-ID: <20070227091917.GA21721@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following section mismatch warning (when compiled with CONFIG_HOTPLUG=n):
WARNING: drivers/pci/built-in.o - Section mismatch: reference to .init.text:pcie_portdrv_probe from .data between 'pcie_portdrv' (at offset 0xe40) and 'pcie_portdrv_err_handler'

This warning was fixed by renaming pcie_portdrv to pcie_portdriver so we pass
the whitelist.
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index f17e7ed..0be5a0b 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -276,7 +276,7 @@ static struct pci_error_handlers pcie_portdrv_err_handler = {
 		.resume = pcie_portdrv_err_resume,
 };
 
-static struct pci_driver pcie_portdrv = {
+static struct pci_driver pcie_portdriver = {
 	.name		= (char *)device_name,
 	.id_table	= &port_pci_ids[0],
 
@@ -298,7 +298,7 @@ static int __init pcie_portdrv_init(void)
 		printk(KERN_WARNING "PCIE: bus_register error: %d\n", retval);
 		goto out;
 	}
-	retval = pci_register_driver(&pcie_portdrv);
+	retval = pci_register_driver(&pcie_portdriver);
 	if (retval)
 		pcie_port_bus_unregister();
  out:
@@ -307,7 +307,7 @@ static int __init pcie_portdrv_init(void)
 
 static void __exit pcie_portdrv_exit(void) 
 {
-	pci_unregister_driver(&pcie_portdrv);
+	pci_unregister_driver(&pcie_portdriver);
 	pcie_port_bus_unregister();
 }
 
