Return-Path: <linux-kernel-owner+w=401wt.eu-S1762062AbZBMUX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762062AbZBMUX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761708AbZBMUT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:19:56 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:33051 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759896AbZBMUTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:19:55 -0500
From: Alex Chiang <achiang@hp.com>
Subject: [RFC PATCH v2 12/12] PCI: more whitespace cleanups
To: jbarnes@virtuousgeek.org
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@hp.com>
Date: Fri, 13 Feb 2009 13:19:54 -0700
Message-ID: <20090213201954.19262.72350.stgit@bob.kio>
In-Reply-To: <20090213201135.19262.67924.stgit@bob.kio>
References: <20090213201135.19262.67924.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up some stray whitespace issues.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/pci-sysfs.c |   18 +++++++++---------
 drivers/pci/probe.c     |   16 +++++++++-------
 drivers/pci/remove.c    |    4 ++--
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 6e5f141..42121ec 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -10,7 +10,7 @@
  *
  * File attributes for PCI devices
  *
- * Modeled after usb's driverfs.c 
+ * Modeled after usb's driverfs.c
  *
  */
 
@@ -70,7 +70,7 @@ static ssize_t broken_parity_status_store(struct device *dev,
 
 static ssize_t local_cpus_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
-{		
+{
 	const struct cpumask *mask;
 	int len;
 
@@ -380,13 +380,13 @@ pci_write_config(struct kobject *kobj, struct bin_attribute *bin_attr,
 		size = dev->cfg_size - off;
 		count = size;
 	}
-	
+
 	if ((off & 1) && size) {
 		pci_user_write_config_byte(dev, off, data[off - init_off]);
 		off++;
 		size--;
 	}
-	
+
 	if ((off & 3) && size > 2) {
 		u16 val = data[off - init_off];
 		val |= (u16) data[off - init_off + 1] << 8;
@@ -404,7 +404,7 @@ pci_write_config(struct kobject *kobj, struct bin_attribute *bin_attr,
 		off += 4;
 		size -= 4;
 	}
-	
+
 	if (size >= 2) {
 		u16 val = data[off - init_off];
 		val |= (u16) data[off - init_off + 1] << 8;
@@ -818,21 +818,21 @@ pci_read_rom(struct kobject *kobj, struct bin_attribute *bin_attr,
 
 	if (!pdev->rom_attr_enabled)
 		return -EINVAL;
-	
+
 	rom = pci_map_rom(pdev, &size);	/* size starts out as PCI window size */
 	if (!rom)
 		return 0;
-		
+
 	if (off >= size)
 		count = 0;
 	else {
 		if (off + count > size)
 			count = size - off;
-		
+
 		memcpy_fromio(buf, rom + off, count);
 	}
 	pci_unmap_rom(pdev, rom);
-		
+
 	return count;
 }
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index d2bd1b0..d853abe 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -494,7 +494,7 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 	}
 
 	/* Disable MasterAbortMode during probing to avoid reporting
-	   of bus errors (in some architectures) */ 
+	   of bus errors (in some architectures) */
 	pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &bctl);
 	pci_write_config_word(dev, PCI_BRIDGE_CONTROL,
 			      bctl & ~PCI_BRIDGE_CTL_MASTER_ABORT);
@@ -570,7 +570,7 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 			buses &= ~0xff000000;
 			buses |= CARDBUS_LATENCY_TIMER << 24;
 		}
-			
+
 		/*
 		 * We need to blast all three values with a single write.
 		 */
@@ -680,7 +680,7 @@ static void pci_read_irq(struct pci_dev *dev)
  * pci_setup_device - fill in class and map information of a device
  * @dev: the device structure to fill
  *
- * Initialize the device structure with information about the device's 
+ * Initialize the device structure with information about the device's
  * vendor,class,memory and IO-space addresses,IRQ lines etc.
  * Called at initialisation of the PCI subsystem and by CardBus services.
  * Returns 0 on success and -1 if unknown type of device (not normal, bridge
@@ -720,8 +720,8 @@ static int pci_setup_device(struct pci_dev * dev)
 		pci_read_config_word(dev, PCI_SUBSYSTEM_ID, &dev->subsystem_device);
 
 		/*
-		 *	Do the ugly legacy mode stuff here rather than broken chip
-		 *	quirk code. Legacy mode ATA controllers have fixed
+		 *	Do the ugly legacy mode stuff here rather than broken
+		 *	chip quirk code. Legacy mode ATA controllers have fixed
 		 *	addresses. These are not always echoed in BAR0-3, and
 		 *	BAR0-3 in a few cases contain junk!
 		 */
@@ -752,7 +752,7 @@ static int pci_setup_device(struct pci_dev * dev)
 			goto bad;
 		/* The PCI-to-PCI bridge spec requires that subtractive
 		   decoding (i.e. transparent) bridge must have programming
-		   interface code of 0x01. */ 
+		   interface code of 0x01. */
 		pci_read_irq(dev);
 		dev->transparent = ((dev->class & 0xff) == 1);
 		pci_read_bases(dev, 2, PCI_ROM_ADDRESS1);
@@ -1126,7 +1126,9 @@ struct pci_bus * pci_create_bus(struct device *parent,
 	b->ops = ops;
 
 	if (pci_find_bus(pci_domain_nr(b), bus)) {
-		/* If we already got to this bus through a different bridge, ignore it */
+		/* If we already got to this bus through a different bridge,
+		 * ignore it
+		 */
 		pr_debug("PCI: Bus %04x:%02x already known\n", pci_domain_nr(b), bus);
 		goto err_out;
 	}
diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
index 042e089..ba58128 100644
--- a/drivers/pci/remove.c
+++ b/drivers/pci/remove.c
@@ -7,7 +7,7 @@ static void pci_free_resources(struct pci_dev *dev)
 {
 	int i;
 
- 	msi_remove_pci_irq_vectors(dev);
+	msi_remove_pci_irq_vectors(dev);
 
 	pci_cleanup_rom(dev);
 	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
@@ -49,7 +49,7 @@ static void pci_destroy_dev(struct pci_dev *dev)
  * pci_remove_device_safe - remove an unused hotplug device
  * @dev: the device to remove
  *
- * Delete the device structure from the device lists and 
+ * Delete the device structure from the device lists and
  * notify userspace (/sbin/hotplug), but only if the device
  * in question is not being used by a driver.
  * Returns 0 on success.

