Return-Path: <linux-kernel-owner+w=401wt.eu-S1763094AbZCaP3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763094AbZCaP3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762563AbZCaPYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:24:25 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:14595 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762456AbZCaPYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:24:24 -0400
Subject: [PATCH 15/15] PCI: remove deprecated pci_find_slot() interface
To: jbarnes@virtuousgeek.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 31 Mar 2009 09:24:22 -0600
Message-ID: <20090331152422.26622.85161.stgit@bob.kio>
In-Reply-To: <20090331150158.26622.45423.stgit@bob.kio>
References: <20090331150158.26622.45423.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last in-tree caller of pci_find_slot has been converted, so
let's get rid of this deprecated interface.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/pci/search.c |   30 ------------------------------
 include/linux/pci.h  |    8 --------
 2 files changed, 0 insertions(+), 38 deletions(-)

diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 5af8bd5..766d27a 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -115,36 +115,6 @@ pci_find_next_bus(const struct pci_bus *from)
 
 #ifdef CONFIG_PCI_LEGACY
 /**
- * pci_find_slot - locate PCI device from a given PCI slot
- * @bus: number of PCI bus on which desired PCI device resides
- * @devfn: encodes number of PCI slot in which the desired PCI
- * device resides and the logical device number within that slot
- * in case of multi-function devices.
- *
- * Given a PCI bus and slot/function number, the desired PCI device
- * is located in system global list of PCI devices.  If the device
- * is found, a pointer to its data structure is returned.  If no
- * device is found, %NULL is returned.
- *
- * NOTE: Do not use this function any more; use pci_get_slot() instead, as
- * the PCI device returned by this function can disappear at any moment in
- * time.
- */
-struct pci_dev *pci_find_slot(unsigned int bus, unsigned int devfn)
-{
-	struct pci_dev *dev = NULL;
-
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-		if (dev->bus->number == bus && dev->devfn == devfn) {
-			pci_dev_put(dev);
-			return dev;
-		}
-	}
-	return NULL;
-}
-EXPORT_SYMBOL(pci_find_slot);
-
-/**
  * pci_find_device - begin or continue searching for a PCI device by vendor/device id
  * @vendor: PCI vendor id to match, or %PCI_ANY_ID to match all vendor ids
  * @device: PCI device id to match, or %PCI_ANY_ID to match all device ids
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 7bd624b..cd42a55 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -574,8 +574,6 @@ extern void pci_sort_breadthfirst(void);
 struct pci_dev __deprecated *pci_find_device(unsigned int vendor,
 					     unsigned int device,
 					     struct pci_dev *from);
-struct pci_dev __deprecated *pci_find_slot(unsigned int bus,
-					   unsigned int devfn);
 #endif /* CONFIG_PCI_LEGACY */
 
 enum pci_lost_interrupt_reason {
@@ -895,12 +893,6 @@ static inline struct pci_dev *pci_find_device(unsigned int vendor,
 	return NULL;
 }
 
-static inline struct pci_dev *pci_find_slot(unsigned int bus,
-					    unsigned int devfn)
-{
-	return NULL;
-}
-
 static inline struct pci_dev *pci_get_device(unsigned int vendor,
 					     unsigned int device,
 					     struct pci_dev *from)

