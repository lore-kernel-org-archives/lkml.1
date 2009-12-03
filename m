Return-Path: <linux-kernel-owner+w=401wt.eu-S1755587AbZLCRGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755587AbZLCRGp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:06:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755434AbZLCRGo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:06:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10398 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755011AbZLCRGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:06:43 -0500
Message-ID: <4B17EFA7.8040504@redhat.com>
Date: Thu, 03 Dec 2009 18:04:39 +0100
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Assmann <sassmann@redhat.com>
CC: linux-pci@vger.kernel.org, jeff@garzik.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, rjw@sisk.pl, ddutile@redhat.com,
       kaneshige.kenji@jp.fujitsu.com, khc@pm.waw.pl,
       Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH 1/2 v2] pci: change PCI nomenclature in drivers/pci/ (comment
 changes)
References: <20091203114914.24905.67372.sendpatchset@localhost.localdomain> <20091203114923.24905.48449.sendpatchset@localhost.localdomain>
In-Reply-To: <20091203114923.24905.48449.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

repost with typo "Debuging" fixed as in patch #2.


From: Stefan Assmann <sassmann@redhat.com>

Changing occurrences of variants of PCI-X and PCIe to the PCI-SIG
terms listed in the "Trademark and Logo Usage Guidelines".
http://www.pcisig.com/developers/procedures/logos/Trademark_and_Logo_Usage_Guidelines_updated_112206.pdf

Patch is limited to drivers/pci/ and changes concern comments only.

Signed-off-by: Stefan Assmann <sassmann@redhat.com>
---
 drivers/pci/hotplug/shpchp.h       |    2 +-
 drivers/pci/intel-iommu.c          |    6 +++---
 drivers/pci/intr_remapping.c       |    2 +-
 drivers/pci/pci.c                  |    6 +++---
 drivers/pci/pcie/aer/aer_inject.c  |    4 ++--
 drivers/pci/pcie/aer/aerdrv.c      |    2 +-
 drivers/pci/pcie/aer/aerdrv_acpi.c |    2 +-
 drivers/pci/pcie/aer/aerdrv_core.c |    6 +++---
 drivers/pci/pcie/aspm.c            |    4 ++--
 drivers/pci/search.c               |    6 +++---
 10 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/hotplug/shpchp.h b/drivers/pci/hotplug/shpchp.h
index bd588eb..8e210cd 100644
--- a/drivers/pci/hotplug/shpchp.h
+++ b/drivers/pci/hotplug/shpchp.h
@@ -121,7 +121,7 @@ struct controller {
 #define PCI_DEVICE_ID_AMD_GOLAM_7450	0x7450
 #define PCI_DEVICE_ID_AMD_POGO_7458	0x7458

-/* AMD PCIX bridge registers */
+/* AMD PCI-X bridge registers */
 #define PCIX_MEM_BASE_LIMIT_OFFSET	0x1C
 #define PCIX_MISCII_OFFSET		0x48
 #define PCIX_MISC_BRIDGE_ERRORS_OFFSET	0x80
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 1840a05..306a2eb 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -304,7 +304,7 @@ struct device_domain_info {
 	int segment;		/* PCI domain */
 	u8 bus;			/* PCI bus number */
 	u8 devfn;		/* PCI devfn number */
-	struct pci_dev *dev; /* it's NULL for PCIE-to-PCI bridge */
+	struct pci_dev *dev; /* it's NULL for PCIe-to-PCI bridge */
 	struct intel_iommu *iommu; /* IOMMU used by this device */
 	struct dmar_domain *domain; /* pointer to domain */
 };
@@ -1611,7 +1611,7 @@ domain_context_mapping(struct dmar_domain *domain, struct pci_dev *pdev,
 			return ret;
 		parent = parent->bus->self;
 	}
-	if (tmp->is_pcie) /* this is a PCIE-to-PCI bridge */
+	if (tmp->is_pcie) /* this is a PCIe-to-PCI bridge */
 		return domain_context_mapping_one(domain,
 					pci_domain_nr(tmp->subordinate),
 					tmp->subordinate->number, 0,
@@ -3317,7 +3317,7 @@ static void iommu_detach_dependent_devices(struct intel_iommu *iommu,
 					 parent->devfn);
 			parent = parent->bus->self;
 		}
-		if (tmp->is_pcie) /* this is a PCIE-to-PCI bridge */
+		if (tmp->is_pcie) /* this is a PCIe-to-PCI bridge */
 			iommu_detach_dev(iommu,
 				tmp->subordinate->number, 0);
 		else /* this is a legacy PCI bridge */
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 0ed78a7..cd9712d 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -486,7 +486,7 @@ int set_msi_sid(struct irte *irte, struct pci_dev *dev)

 	bridge = pci_find_upstream_pcie_bridge(dev);
 	if (bridge) {
-		if (bridge->is_pcie) /* this is a PCIE-to-PCI/PCIX bridge */
+		if (bridge->is_pcie) /* this is a PCIe-to-PCI/PCI-X bridge */
 			set_irte_sid(irte, SVT_VERIFY_BUS, SQ_ALL_16,
 				(bridge->bus->number << 8) | dev->bus->number);
 		else /* this is a legacy PCI bridge */
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 4e4c295..4d2c096 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1140,11 +1140,11 @@ pci_disable_device(struct pci_dev *dev)

 /**
  * pcibios_set_pcie_reset_state - set reset state for device dev
- * @dev: the PCI-E device reset
+ * @dev: the PCIe device reset
  * @state: Reset state to enter into
  *
  *
- * Sets the PCI-E reset state for the device. This is the default
+ * Sets the PCIe reset state for the device. This is the default
  * implementation. Architecture implementations can override this.
  */
 int __attribute__ ((weak)) pcibios_set_pcie_reset_state(struct pci_dev *dev,
@@ -1155,7 +1155,7 @@ int __attribute__ ((weak)) pcibios_set_pcie_reset_state(struct pci_dev *dev,

 /**
  * pci_set_pcie_reset_state - set reset state for device dev
- * @dev: the PCI-E device reset
+ * @dev: the PCIe device reset
  * @state: Reset state to enter into
  *
  *
diff --git a/drivers/pci/pcie/aer/aer_inject.c b/drivers/pci/pcie/aer/aer_inject.c
index 62d15f6..a21dee3 100644
--- a/drivers/pci/pcie/aer/aer_inject.c
+++ b/drivers/pci/pcie/aer/aer_inject.c
@@ -1,7 +1,7 @@
 /*
- * PCIE AER software error injection support.
+ * PCIe AER software error injection support.
  *
- * Debuging PCIE AER code is quite difficult because it is hard to
+ * Debugging PCIe AER code is quite difficult because it is hard to
  * trigger various real hardware errors. Software based error
  * injection can fake almost all kinds of errors with the help of a
  * user space helper tool aer-inject, which can be gotten from:
diff --git a/drivers/pci/pcie/aer/aerdrv.c b/drivers/pci/pcie/aer/aerdrv.c
index 40c3cc5..499aacd 100644
--- a/drivers/pci/pcie/aer/aerdrv.c
+++ b/drivers/pci/pcie/aer/aerdrv.c
@@ -155,7 +155,7 @@ static struct aer_rpc *aer_alloc_rpc(struct pcie_device *dev)
 	mutex_init(&rpc->rpc_mutex);
 	init_waitqueue_head(&rpc->wait_release);

-	/* Use PCIE bus function to store rpc into PCIE device */
+	/* Use PCIe bus function to store rpc into PCIe device */
 	set_service_data(dev, rpc);

 	return rpc;
diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 8edb2f3..0481408 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -24,7 +24,7 @@
  *
  * @return: Zero on success. Nonzero otherwise.
  *
- * Invoked when PCIE bus loads AER service driver. To avoid conflict with
+ * Invoked when PCIe bus loads AER service driver. To avoid conflict with
  * BIOS AER support requires BIOS to yield AER control to OS native driver.
  **/
 int aer_osc_setup(struct pcie_device *pciedev)
diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
index 9f5ccbe..9ab97a8 100644
--- a/drivers/pci/pcie/aer/aerdrv_core.c
+++ b/drivers/pci/pcie/aer/aerdrv_core.c
@@ -603,7 +603,7 @@ static void handle_error_source(struct pcie_device *aerdev,
  * aer_enable_rootport - enable Root Port's interrupts when receiving messages
  * @rpc: pointer to a Root Port data structure
  *
- * Invoked when PCIE bus loads AER service driver.
+ * Invoked when PCIe bus loads AER service driver.
  */
 void aer_enable_rootport(struct aer_rpc *rpc)
 {
@@ -613,7 +613,7 @@ void aer_enable_rootport(struct aer_rpc *rpc)
 	u32 reg32;

 	pos = pci_find_capability(pdev, PCI_CAP_ID_EXP);
-	/* Clear PCIE Capability's Device Status */
+	/* Clear PCIe Capability's Device Status */
 	pci_read_config_word(pdev, pos+PCI_EXP_DEVSTA, &reg16);
 	pci_write_config_word(pdev, pos+PCI_EXP_DEVSTA, reg16);

@@ -647,7 +647,7 @@ void aer_enable_rootport(struct aer_rpc *rpc)
  * disable_root_aer - disable Root Port's interrupts when receiving messages
  * @rpc: pointer to a Root Port data structure
  *
- * Invoked when PCIE bus unloads AER service driver.
+ * Invoked when PCIe bus unloads AER service driver.
  */
 static void disable_root_aer(struct aer_rpc *rpc)
 {
diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 5b7056c..1dd123e 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -1,6 +1,6 @@
 /*
  * File:	drivers/pci/pcie/aspm.c
- * Enabling PCIE link L0s/L1 state and Clock Power Management
+ * Enabling PCIe link L0s/L1 state and Clock Power Management
  *
  * Copyright (C) 2007 Intel
  * Copyright (C) Zhang Yanmin (yanmin.zhang@intel.com)
@@ -499,7 +499,7 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 	int pos;
 	u32 reg32;
 	/*
-	 * Some functions in a slot might not all be PCIE functions,
+	 * Some functions in a slot might not all be PCIe functions,
 	 * very strange. Disable ASPM for the whole slot
 	 */
 	list_for_each_entry(child, &pdev->subordinate->devices, bus_list) {
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index ec41535..1873188 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -15,9 +15,9 @@

 DECLARE_RWSEM(pci_bus_sem);
 /*
- * find the upstream PCIE-to-PCI bridge of a PCI device
+ * find the upstream PCIe-to-PCI bridge of a PCI device
  * if the device is PCIE, return NULL
- * if the device isn't connected to a PCIE bridge (that is its parent is a
+ * if the device isn't connected to a PCIe bridge (that is its parent is a
  * legacy PCI bridge and the bridge is directly connected to bus 0), return its
  * parent
  */
@@ -37,7 +37,7 @@ pci_find_upstream_pcie_bridge(struct pci_dev *pdev)
 			tmp = pdev;
 			continue;
 		}
-		/* PCI device should connect to a PCIE bridge */
+		/* PCI device should connect to a PCIe bridge */
 		if (pdev->pcie_type != PCI_EXP_TYPE_PCI_BRIDGE) {
 			/* Busted hardware? */
 			WARN_ON_ONCE(1);
-- 
1.6.5.2

