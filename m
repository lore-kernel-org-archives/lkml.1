Return-Path: <linux-kernel-owner+w=401wt.eu-S1756196AbYKJWdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196AbYKJWdh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 17:33:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYKJWbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 17:31:14 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:39076 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbYKJWbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 17:31:11 -0500
From: Andrew Patterson <andrew.patterson@hp.com>
Subject: [PATCH 7/7] PCI,
	ACPI: remove obsolete _OSC capability support functions
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: andrew.patterson@hp.com, matthew@wil.cx, kaneshige.kenji@jp.fujitsu.com,
       bjorn.helgaas@hp.com
Date: Mon, 10 Nov 2008 15:31:10 -0700
Message-ID: <20081110223110.30539.19970.stgit@bob.kio>
In-Reply-To: <20081110223035.30539.88942.stgit@bob.kio>
References: <20081110223035.30539.88942.stgit@bob.kio>
User-Agent: StGIT/0.14.3.215.gff3d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI, ACPI: remove obsolete _OSC capability support functions

The acpi_query_osc, __pci_osc_support_set, pci_osc_support_set, and
pcie_osc_support_set functions have been obsoleted in favor of setting
these capabilities during root bridge discovery with pci_acpi_osc_support.
There are no longer any callers of these functions, so they are removed.

Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
---

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index f457387..128ce7d 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -171,31 +171,6 @@ out:
 	return rc;
 }
 
-static acpi_status acpi_query_osc(acpi_handle handle, u32 level,
-				  void *context, void **retval)
-{
-	pci_acpi_osc_support(handle, (unsigned long)context);
-	return AE_OK;
-}
-
-/**
- * __pci_osc_support_set - register OS support to Firmware
- * @flags: OS support bits
- * @hid: hardware ID
- *
- * Update OS support fields and doing a _OSC Query to obtain an update
- * from Firmware on supported control bits.
- **/
-acpi_status __pci_osc_support_set(u32 flags, const char *hid)
-{
-	if (!(flags & OSC_SUPPORT_MASKS))
-		return AE_TYPE;
-
-	acpi_get_devices(hid, acpi_query_osc,
-			 (void *)(unsigned long)flags, NULL);
-	return AE_OK;
-}
-
 /**
  * pci_osc_control_set - commit requested control to Firmware
  * @handle: acpi_handle for the target ACPI object
diff --git a/include/linux/pci-acpi.h b/include/linux/pci-acpi.h
index 424f06f..871e096 100644
--- a/include/linux/pci-acpi.h
+++ b/include/linux/pci-acpi.h
@@ -50,16 +50,7 @@
 
 #ifdef CONFIG_ACPI
 extern acpi_status pci_osc_control_set(acpi_handle handle, u32 flags);
-extern acpi_status __pci_osc_support_set(u32 flags, const char *hid);
 int pci_acpi_osc_support(acpi_handle handle, u32 flags);
-static inline acpi_status pci_osc_support_set(u32 flags)
-{
-	return __pci_osc_support_set(flags, PCI_ROOT_HID_STRING);
-}
-static inline acpi_status pcie_osc_support_set(u32 flags)
-{
-	return __pci_osc_support_set(flags, PCI_EXPRESS_ROOT_HID_STRING);
-}
 static inline acpi_handle acpi_find_root_bridge_handle(struct pci_dev *pdev)
 {
 	/* Find root host bridge */
@@ -76,8 +67,6 @@ typedef u32 		acpi_status;
 #endif    
 static inline acpi_status pci_osc_control_set(acpi_handle handle, u32 flags)
 {return AE_ERROR;}
-static inline acpi_status pci_osc_support_set(u32 flags) {return AE_ERROR;} 
-static inline acpi_status pcie_osc_support_set(u32 flags) {return AE_ERROR;}
 static inline acpi_handle acpi_find_root_bridge_handle(struct pci_dev *pdev)
 { return NULL; }
 #endif

