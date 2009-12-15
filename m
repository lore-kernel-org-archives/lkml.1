Return-Path: <linux-kernel-owner+w=401wt.eu-S1755701AbZLOCiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701AbZLOCiZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 21:38:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZLOCiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 21:38:22 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56534 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbZLOCiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 21:38:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B26F68C.4050201@jp.fujitsu.com>
Date: Tue, 15 Dec 2009 11:38:04 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: linux-pci@vger.kernel.org
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] pcie, portdrv: style cleanup
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No change in logic.

Before:
  drivers/pci/pcie/portdrv_core.c:
    total: 7 errors, 2 warnings, 508 lines checked
  drivers/pci/pcie/portdrv_pci.c:
    total: 4 errors, 2 warnings, 300 lines checked

After:
  drivers/pci/pcie/portdrv_core.c:
    total: 0 errors, 0 warnings, 506 lines checked
  drivers/pci/pcie/portdrv_pci.c:
    total: 0 errors, 0 warnings, 299 lines checked

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 drivers/pci/pcie/portdrv_core.c |   16 +++++++---------
 drivers/pci/pcie/portdrv_pci.c  |   17 ++++++++---------
 2 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 413262e..b174188 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -27,7 +27,7 @@
  */
 static void release_pcie_device(struct device *dev)
 {
-	kfree(to_pcie_device(dev));			
+	kfree(to_pcie_device(dev));
 }
 
 /**
@@ -346,12 +346,11 @@ static int suspend_iter(struct device *dev, void *data)
 {
 	struct pcie_port_service_driver *service_driver;
 
- 	if ((dev->bus == &pcie_port_bus_type) &&
- 	    (dev->driver)) {
- 		service_driver = to_service_driver(dev->driver);
- 		if (service_driver->suspend)
- 			service_driver->suspend(to_pcie_device(dev));
-  	}
+	if ((dev->bus == &pcie_port_bus_type) && dev->driver) {
+		service_driver = to_service_driver(dev->driver);
+		if (service_driver->suspend)
+			service_driver->suspend(to_pcie_device(dev));
+	}
 	return 0;
 }
 
@@ -494,6 +493,7 @@ int pcie_port_service_register(struct pcie_port_service_driver *new)
 
 	return driver_register(&new->driver);
 }
+EXPORT_SYMBOL(pcie_port_service_register);
 
 /**
  * pcie_port_service_unregister - unregister PCI Express port service driver
@@ -503,6 +503,4 @@ void pcie_port_service_unregister(struct pcie_port_service_driver *drv)
 {
 	driver_unregister(&drv->driver);
 }
-
-EXPORT_SYMBOL(pcie_port_service_register);
 EXPORT_SYMBOL(pcie_port_service_unregister);
diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
index ce52ea3..dd9fcc6 100644
--- a/drivers/pci/pcie/portdrv_pci.c
+++ b/drivers/pci/pcie/portdrv_pci.c
@@ -63,7 +63,7 @@ static struct dev_pm_ops pcie_portdrv_pm_ops = {
  * pcie_portdrv_probe - Probe PCI-Express port devices
  * @dev: PCI-Express port device being probed
  *
- * If detected invokes the pcie_port_device_register() method for 
+ * If detected invokes the pcie_port_device_register() method for
  * this port device.
  *
  */
@@ -78,7 +78,7 @@ static int __devinit pcie_portdrv_probe(struct pci_dev *dev,
 	     (dev->pcie_type != PCI_EXP_TYPE_DOWNSTREAM)))
 		return -ENODEV;
 
-        if (!dev->irq && dev->pin) {
+	if (!dev->irq && dev->pin) {
 		dev_warn(&dev->dev, "device [%04x:%04x] has invalid IRQ; "
 			 "check vendor BIOS\n", dev->vendor, dev->device);
 	}
@@ -91,7 +91,7 @@ static int __devinit pcie_portdrv_probe(struct pci_dev *dev,
 	return 0;
 }
 
-static void pcie_portdrv_remove (struct pci_dev *dev)
+static void pcie_portdrv_remove(struct pci_dev *dev)
 {
 	pcie_port_device_remove(dev);
 	pci_disable_device(dev);
@@ -129,14 +129,13 @@ static int error_detected_iter(struct device *device, void *data)
 static pci_ers_result_t pcie_portdrv_error_detected(struct pci_dev *dev,
 					enum pci_channel_state error)
 {
-	struct aer_broadcast_data result_data =
-			{error, PCI_ERS_RESULT_CAN_RECOVER};
-	int retval;
+	struct aer_broadcast_data data = {error, PCI_ERS_RESULT_CAN_RECOVER};
+	int ret;
 
 	/* can not fail */
-	retval = device_for_each_child(&dev->dev, &result_data, error_detected_iter);
+	ret = device_for_each_child(&dev->dev, &data, error_detected_iter);
 
-	return result_data.result;
+	return data.result;
 }
 
 static int mmio_enabled_iter(struct device *device, void *data)
@@ -290,7 +289,7 @@ static int __init pcie_portdrv_init(void)
 	return retval;
 }
 
-static void __exit pcie_portdrv_exit(void) 
+static void __exit pcie_portdrv_exit(void)
 {
 	pci_unregister_driver(&pcie_portdriver);
 	pcie_port_bus_unregister();
-- 
1.6.5.6


