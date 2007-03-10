Return-Path: <linux-kernel-owner+w=401wt.eu-S1767780AbXCJEKa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767780AbXCJEKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:10:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767782AbXCJEKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:10:30 -0500
Received: from mx1.suse.de ([195.135.220.2]:36333 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767792AbXCJEK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:10:27 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/4] pcie: fix section mismatch warning
Date: Fri,  9 Mar 2007 20:08:32 -0800
Message-Id: <1173499718269-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11734997142797-git-send-email-gregkh@suse.de>
References: <20070310040356.GB30638@kroah.com> <11734997142797-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>

Fix following section mismatch warning (when compiled with CONFIG_HOTPLUG=n):
WARNING: drivers/pci/built-in.o - Section mismatch: reference to .init.text:pcie_portdrv_probe from .data between 'pcie_portdrv' (at offset 0xe40) and 'pcie_portdrv_err_handler'

This warning was fixed by renaming pcie_portdrv to pcie_portdriver so we pass
the whitelist.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/pcie/portdrv_pci.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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
 
-- 
1.5.0.2

