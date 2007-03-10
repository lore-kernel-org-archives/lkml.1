Return-Path: <linux-kernel-owner+w=401wt.eu-S1767778AbXCJELG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767778AbXCJELG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 23:11:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767768AbXCJEKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 23:10:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36995 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767791AbXCJEKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 23:10:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-pci@atrey.karlin.mff.cuni.cz
Cc: linux-kernel@vger.kernel.org, pcihpd-discuss@lists.sourceforge.net,
       Sam Ravnborg <sam@ravnborg.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 3/4] PCI: aer: fix section mismatch warning
Date: Fri,  9 Mar 2007 20:08:33 -0800
Message-Id: <1173499721772-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <1173499718269-git-send-email-gregkh@suse.de>
References: <20070310040356.GB30638@kroah.com> <11734997142797-git-send-email-gregkh@suse.de> <1173499718269-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>

Fix following section mismatch warning (when compiled with CONFIG_HOTPLUG=n):
WARNING: drivers/pci/built-in.o - Section mismatch: reference to .init.text:aer_probe from .data between 'aerdrv' (at offset 0x1608) and 'aer_error_handlers'

Warning was fixed by renaming aerdrv to aerdriver so we pass the whitelist.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/pci/pcie/aer/aerdrv.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

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
-- 
1.5.0.2

