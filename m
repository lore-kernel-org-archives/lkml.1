Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZFDF6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZFDF6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756314AbZFDF6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:58:21 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:31284 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbZFDF6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:58:19 -0400
Subject: [PATCH v2 01/11] ACPI: make acpi_pci_bind() static
To: lenb@kernel.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Date: Wed, 03 Jun 2009 23:58:21 -0600
Message-ID: <20090604055821.18802.88142.stgit@bob.kio>
In-Reply-To: <20090604054504.18802.21690.stgit@bob.kio>
References: <20090604054504.18802.21690.stgit@bob.kio>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_pci_root_add() explicitly assigns device->ops.bind, and later
calls acpi_pci_bind_root(), which also does the same thing.

We don't need to repeat ourselves; removing the explicit assignment
allows us to make acpi_pci_bind() static.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/acpi/pci_bind.c     |    3 ++-
 drivers/acpi/pci_root.c     |    2 --
 include/acpi/acpi_drivers.h |    1 -
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/pci_bind.c b/drivers/acpi/pci_bind.c
index bc46de3..236765c 100644
--- a/drivers/acpi/pci_bind.c
+++ b/drivers/acpi/pci_bind.c
@@ -44,6 +44,7 @@ struct acpi_pci_data {
 	struct pci_dev *dev;
 };
 
+static int acpi_pci_bind(struct acpi_device *device);
 static int acpi_pci_unbind(struct acpi_device *device);
 
 static void acpi_pci_data_handler(acpi_handle handle, u32 function,
@@ -108,7 +109,7 @@ acpi_status acpi_get_pci_id(acpi_handle handle, struct acpi_pci_id *id)
 
 EXPORT_SYMBOL(acpi_get_pci_id);
 
-int acpi_pci_bind(struct acpi_device *device)
+static int acpi_pci_bind(struct acpi_device *device)
 {
 	int result = 0;
 	acpi_status status;
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 196f97d..ca8dba3 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -386,8 +386,6 @@ static int __devinit acpi_pci_root_add(struct acpi_device *device)
 	strcpy(acpi_device_class(device), ACPI_PCI_ROOT_CLASS);
 	device->driver_data = root;
 
-	device->ops.bind = acpi_pci_bind;
-
 	/*
 	 * All supported architectures that use ACPI have support for
 	 * PCI domains, so we indicate this in _OSC support capabilities.
diff --git a/include/acpi/acpi_drivers.h b/include/acpi/acpi_drivers.h
index 5e8ed3a..bbe9207 100644
--- a/include/acpi/acpi_drivers.h
+++ b/include/acpi/acpi_drivers.h
@@ -98,7 +98,6 @@ void acpi_pci_irq_del_prt(int segment, int bus);
 struct pci_bus;
 
 acpi_status acpi_get_pci_id(acpi_handle handle, struct acpi_pci_id *id);
-int acpi_pci_bind(struct acpi_device *device);
 int acpi_pci_bind_root(struct acpi_device *device, struct acpi_pci_id *id,
 		       struct pci_bus *bus);
 

