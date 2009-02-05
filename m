Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbZBER0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbZBER0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZBER0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:26:05 -0500
Received: from mx1.suse.de ([195.135.220.2]:47065 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240AbZBER0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:26:04 -0500
Message-ID: <498B2116.6010707@suse.de>
Date: Thu, 05 Feb 2009 18:25:42 +0100
From: Frank Seidel <fseidel@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: linux kernel <linux-kernel@vger.kernel.org>
Cc: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org, greg@kroah.com,
       kristen.c.accardi@intel.com, ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com, fenghua.yu@intel.com,
       akpm@linux-foundation.org, frank@f-seidel.de, fseidel@suse.de,
       Frans Pop <elendil@planet.nl>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] PCI: add missing KERN_* constants to printks
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Seidel <frank@f-seidel.de>

According to kerneljanitors todo list all printk calls (beginning
a new line) should have an according KERN_* constant.
Those are the missing pieces here for the pci subsystem.

Signed-off-by: Frank Seidel <frank@f-seidel.de>
---
 drivers/pci/hotplug/pciehp_core.c |    6 +++---
 drivers/pci/hotplug/shpchp_core.c |    4 ++--
 drivers/pci/intel-iommu.c         |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/pci/hotplug/pciehp_core.c
+++ b/drivers/pci/hotplug/pciehp_core.c
@@ -526,16 +526,16 @@ static int __init pcied_init(void)
 
 	pciehp_firmware_init();
 	retval = pcie_port_service_register(&hpdriver_portdrv);
- 	dbg("pcie_port_service_register = %d\n", retval);
+	dbg(KERN_DEBUG "pcie_port_service_register = %d\n", retval);
   	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
  	if (retval)
-		dbg("Failure to register service\n");
+		dbg(KERN_DEBUG "Failure to register service\n");
 	return retval;
 }
 
 static void __exit pcied_cleanup(void)
 {
-	dbg("unload_pciehpd()\n");
+	dbg(KERN_DEBUG "unload_pciehpd()\n");
 	pcie_port_service_unregister(&hpdriver_portdrv);
 	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
--- a/drivers/pci/hotplug/shpchp_core.c
+++ b/drivers/pci/hotplug/shpchp_core.c
@@ -396,14 +396,14 @@ static int __init shpcd_init(void)
 	int retval = 0;
 
 	retval = pci_register_driver(&shpc_driver);
-	dbg("%s: pci_register_driver = %d\n", __func__, retval);
+	dbg(KERN_DEBUG "%s: pci_register_driver = %d\n", __func__, retval);
 	info(DRIVER_DESC " version: " DRIVER_VERSION "\n");
 	return retval;
 }
 
 static void __exit shpcd_cleanup(void)
 {
-	dbg("unload_shpchpd()\n");
+	dbg(KERN_DEBUG "unload_shpchpd()\n");
 	pci_unregister_driver(&shpc_driver);
 	info(DRIVER_DESC " version: " DRIVER_VERSION " unloaded\n");
 }
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1960,7 +1960,7 @@ static inline void iommu_prepare_isa(voi
 	ret = iommu_prepare_identity_map(pdev, 0, 16*1024*1024);
 
 	if (ret)
-		printk("IOMMU: Failed to create 0-64M identity map, "
+		printk(KERN_ERR "IOMMU: Failed to create 0-64M identity map, "
 			"floppy might not work\n");
 
 }
