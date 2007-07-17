Return-Path: <linux-kernel-owner+w=401wt.eu-S1755661AbXGQE1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661AbXGQE1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 00:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbXGQE1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 00:27:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:57582 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbXGQE1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 00:27:32 -0400
Date: Mon, 16 Jul 2007 23:27:10 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Greg KH <greg@kroah.com>
cc: linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: [PATCH] PCI: Move prototypes for pci_bus_find_capability to
 include/linux/pci.h
In-Reply-To: <20070713062756.GG24317@kroah.com>
Message-ID: <Pine.LNX.4.64.0707162325560.5295@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0707130015550.1975@blarg.am.freescale.net>
 <20070713053303.GB17039@kroah.com> <9A567C91-1DE7-46CC-91A0-58D498B8248B@kernel.crashing.org>
 <20070713060511.GA23618@kroah.com> <Pine.LNX.4.64.0707130108490.25195@gate.crashing.org>
 <20070713062756.GG24317@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We need pci_bus_find_capability() in some arch/powerpc code so move
the prototype into a header accessible to it.

Also kill the duplicate prototype for pci_bus_alloc_resource().

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---

Here's a version that just moves the prototype I need for arch/powerpc and
kills the duplicate.

 drivers/pci/pci.h   |    8 +-------
 include/linux/pci.h |    3 +++
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 3fec13d..835875d 100644
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
@@ -36,7 +31,6 @@ static inline int pci_proc_detach_bus(struct pci_bus *bus) { return 0; }

 /* Functions for PCI Hotplug drivers to use */
 extern unsigned int pci_do_scan_bus(struct pci_bus *bus);
-extern int pci_bus_find_capability (struct pci_bus *bus, unsigned int devfn, int cap);

 extern void pci_remove_legacy_files(struct pci_bus *bus);

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 5e84f2e..8a689ef 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -577,6 +577,9 @@ int pci_set_power_state(struct pci_dev *dev, pci_power_t state);
 pci_power_t pci_choose_state(struct pci_dev *dev, pm_message_t state);
 int pci_enable_wake(struct pci_dev *dev, pci_power_t state, int enable);

+/* Functions for PCI Hotplug drivers to use */
+int pci_bus_find_capability (struct pci_bus *bus, unsigned int devfn, int cap);
+
 /* Helper functions for low-level code (drivers/pci/setup-[bus,res].c) */
 void pci_bus_assign_resources(struct pci_bus *bus);
 void pci_bus_size_bridges(struct pci_bus *bus);
-- 
1.5.2.2

