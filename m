Return-Path: <linux-kernel-owner+w=401wt.eu-S1755309AbZHDUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbZHDUoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754300AbZHDUoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:44:19 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:30888 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbZHDUoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:44:18 -0400
Date: Tue, 4 Aug 2009 14:44:17 -0600
From: Alex Chiang <achiang@hp.com>
To: lenb@kernel.org
Cc: chad.smith@hp.com, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] ACPI: pci_slot.ko wants a 64-bit _SUN
Message-ID: <20090804204417.GA26918@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to commit b6adc195 (PCI hotplug: acpiphp wants a 64-bit
_SUN), pci_slot.ko reads and creates sysfs directories based on
the _SUN method.

Certain HP platforms return 64 bits in _SUN. This change to
pci_slot.ko allows us to see the correct sysfs directories.

Reported-by: Chad Smith <chad.smith@hp.com>
Cc: stable@kernel.org
Signed-off-by: Alex Chiang <achiang@hp.com>
---
Stable team, this should be backported to all kernels in the
stable series.

---
diff --git a/drivers/acpi/pci_slot.c b/drivers/acpi/pci_slot.c
index 12158e0..ab40e06 100644
--- a/drivers/acpi/pci_slot.c
+++ b/drivers/acpi/pci_slot.c
@@ -57,7 +57,7 @@ ACPI_MODULE_NAME("pci_slot");
 				MY_NAME , ## arg);		\
 	} while (0)
 
-#define SLOT_NAME_SIZE 20		/* Inspired by #define in acpiphp.h */
+#define SLOT_NAME_SIZE 21		/* Inspired by #define in acpiphp.h */
 
 struct acpi_pci_slot {
 	acpi_handle root_handle;	/* handle of the root bridge */
@@ -149,7 +149,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 		return AE_OK;
 	}
 
-	snprintf(name, sizeof(name), "%u", (u32)sun);
+	snprintf(name, sizeof(name), "%llu", sun);
 	pci_slot = pci_create_slot(pci_bus, device, name, NULL);
 	if (IS_ERR(pci_slot)) {
 		err("pci_create_slot returned %ld\n", PTR_ERR(pci_slot));
