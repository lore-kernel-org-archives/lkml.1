Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbZFBP0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbZFBP0a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 11:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757910AbZFBPZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 11:25:08 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47341 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757740AbZFBPZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 11:25:04 -0400
Subject: [PATCH 06/10] ACPI: kill acpi_get_pci_id
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Date: Tue, 02 Jun 2009 09:25:06 -0600
Message-ID: <20090602152506.7346.72695.stgit@bob.kio>
In-Reply-To: <20090602152351.7346.48697.stgit@bob.kio>
References: <20090602152351.7346.48697.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_get_pci_dev() is better, and all callers have been converted, so
eliminate acpi_get_pci_id().

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_bind.c     |   52 -------------------------------------------
 include/acpi/acpi_drivers.h |    1 -
 2 files changed, 0 insertions(+), 53 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index 584fa30..10e3ffc 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -139,58 +139,6 @@ out:
 }
 EXPORT_SYMBOL_GPL(acpi_get_pci_dev);
 
-/**
- * acpi_get_pci_id
- * ------------------
- * This function is used by the ACPI Interpreter (a.k.a. Core Subsystem)
- * to resolve PCI information for ACPI-PCI devices defined in the namespace.
- * This typically occurs when resolving PCI operation region information.
- */
-acpi_status acpi_get_pci_id(acpi_handle handle, struct acpi_pci_id *id)
-{
-	int result = 0;
-	acpi_status status = AE_OK;
-	struct acpi_device *device = NULL;
-	struct acpi_pci_data *data = NULL;
-
-
-	if (!id)
-		return AE_BAD_PARAMETER;
-
-	result = acpi_bus_get_device(handle, &device);
-	if (result) {
-		printk(KERN_ERR PREFIX
-			    "Invalid ACPI Bus context for device %s\n",
-			    acpi_device_bid(device));
-		return AE_NOT_EXIST;
-	}
-
-	status = acpi_get_data(handle, acpi_pci_data_handler, (void **)&data);
-	if (ACPI_FAILURE(status) || !data) {
-		ACPI_EXCEPTION((AE_INFO, status,
-				"Invalid ACPI-PCI context for device %s",
-				acpi_device_bid(device)));
-		return status;
-	}
-
-	*id = data->id;
-
-	/*
-	   id->segment = data->id.segment;
-	   id->bus = data->id.bus;
-	   id->device = data->id.device;
-	   id->function = data->id.function;
-	 */
-
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
-			  "Device %s has PCI address %04x:%02x:%02x.%d\n",
-			  acpi_device_bid(device), id->segment, id->bus,
-			  id->device, id->function));
-
-	return AE_OK;
-}
-
-EXPORT_SYMBOL(acpi_get_pci_id);
 
 static int acpi_pci_bind(struct acpi_device *device)
 {
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 1ef529b..310f5ff 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -98,7 +98,6 @@ void acpi_pci_irq_del_prt(int segment, int bus);
 struct pci_bus;
 
 struct pci_dev *acpi_get_pci_dev(acpi_handle);
-acpi_status acpi_get_pci_id(acpi_handle handle, struct acpi_pci_id *id);
 int acpi_pci_bind_root(struct acpi_device *device, struct acpi_pci_id *id,
 		       struct pci_bus *bus);
 

