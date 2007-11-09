Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbXKIGCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbXKIGCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbXKIGC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:02:28 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52839 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355AbXKIGC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:02:26 -0500
Date: Fri, 9 Nov 2007 07:02:02 +0100
From: Adrian Bunk <bunk@kernel.org>
To: gregkh@suse.de, dougthompson@xmission.com
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       bluesmoke-devel@lists.sourceforge.net
Subject: [2.6 patch] always export pci_scan_single_device
Message-ID: <20071109060202.GO26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following build error with CONFIG_HOTPLUG=n:

<--  snip  -->

...
  MODPOST 2137 modules
ERROR: "pci_scan_single_device" [drivers/edac/i82875p_edac.ko] undefined!
make[2]: *** [__modpost] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/pci/probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

f80ae6568224bd5e4d2387ec162d37c8e7fd545a 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 463a5a9..de33a02 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1012,6 +1012,7 @@ struct pci_dev *pci_scan_single_device(struct pci_bus *bus, int devfn)
 
 	return dev;
 }
+EXPORT_SYMBOL(pci_scan_single_device);
 
 /**
  * pci_scan_slot - scan a PCI slot on a bus for devices.
@@ -1200,7 +1201,6 @@ EXPORT_SYMBOL(pci_add_new_bus);
 EXPORT_SYMBOL(pci_do_scan_bus);
 EXPORT_SYMBOL(pci_scan_slot);
 EXPORT_SYMBOL(pci_scan_bridge);
-EXPORT_SYMBOL(pci_scan_single_device);
 EXPORT_SYMBOL_GPL(pci_scan_child_bus);
 #endif
 

