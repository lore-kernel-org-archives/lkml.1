Return-Path: <linux-kernel-owner+w=401wt.eu-S933003AbXGMFQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbXGMFQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 01:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbXGMFQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 01:16:51 -0400
Received: from gate.crashing.org ([63.228.1.57]:38719 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbXGMFQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 01:16:50 -0400
Date: Fri, 13 Jul 2007 00:16:29 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Greg KH <greg@kroah.com>
cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: Move prototypes for EXPORT_SYMBOL functions to
 include/linux/pci.h
Message-ID: <Pine.LNX.4.64.0707130015550.1975@blarg.am.freescale.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

pci_do_scan_bus() and pci_bus_find_capability() are marked EXPORT_SYMBOL
and thus usable outside of the PCI drive core itself.  Make the prototypes
for these functions accessible to everyone.

Also kill the duplicate prototype for pci_bus_alloc_resource().

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>

---
commit 2b8427b1a458361c1a5eaea0f8542cceb8df9572
tree 1bd6dae0542d31556b473c7ababecad6416e3a15
parent 773208946a132fb733ba273ee8562814f828cc28
author Kumar Gala <galak@kernel.crashing.org> Fri, 13 Jul 2007 00:15:20 -0500
committer Kumar Gala <galak@kernel.crashing.org> Fri, 13 Jul 2007 00:15:20 -0500

 drivers/pci/pci.h   |   11 +----------
 include/linux/pci.h |    4 ++++
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 3fec13d..c16d180 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -6,12 +6,7 @@ extern int pci_uevent(struct device *dev, char **envp, int num_envp,
 extern int pci_create_sysfs_dev_files(struct pci_dev *pdev);
 extern void pci_remove_sysfs_dev_files(struct pci_dev *pdev);
 extern void pci_cleanup_rom(struct pci_dev *dev);
-extern int pci_bus_alloc_resource(struct pci_bus *bus, struct resource *res,
-				  resource_size_t size, resource_size_t align,
-				  resource_size_t min, unsigned int type_mask,
-				  void (*alignf)(void *, struct resource *,
-					      resource_size_t, resource_size_t),
-				  void *alignf_data);
+
 /* Firmware callbacks */
 extern int (*platform_pci_choose_state)(struct pci_dev *dev, pm_message_t state);
 extern int (*platform_pci_set_power_state)(struct pci_dev *dev, pci_power_t state);
@@ -34,10 +29,6 @@ static inline int pci_proc_detach_device(struct pci_dev *dev) { return 0; }
 static inline int pci_proc_detach_bus(struct pci_bus *bus) { return 0; }
 #endif

-/* Functions for PCI Hotplug drivers to use */
-extern unsigned int pci_do_scan_bus(struct pci_bus *bus);
-extern int pci_bus_find_capability (struct pci_bus *bus, unsigned int devfn, int cap);
-
 extern void pci_remove_legacy_files(struct pci_bus *bus);

 /* Lock for read/write access to pci device and bus lists */
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 37a7158..006ec05 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -575,6 +575,10 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state);
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);
 int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable);

+/* Functions for PCI Hotplug drivers to use */
+unsigned int pci_do_scan_bus(struct pci_bus *bus);
+int pci_bus_find_capability (struct pci_bus *bus, unsigned int devfn, int cap);
+
 /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
 void pci_bus_assign_resources(struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
