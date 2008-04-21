Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbYDUWwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbYDUWwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757541AbYDUWvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:51:08 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:52384 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbYDUWvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:51:06 -0400
Date: Tue, 22 Apr 2008 01:50:35 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] libata-acpi.c: remove unneeded #if's
Message-ID: <20080421225035.GK2633@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These #if's are unneeded since they:
- did anyway not handle the CONFIG_ACPI_DOCK_MODULE case correctly and
- this is already handled in include/acpi/acpi_drivers.h and
- it's now correctly handled in kconfig.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Tejun Heo <htejun@gmail.com>

---

This patch has been sent on:
- 14 Apr 2008
- 31 Mar 2008

 drivers/ata/libata-acpi.c |    4 ----
 1 file changed, 4 deletions(-)

2a7326b50cd80e6570803d4efb7bc15e029e61e3 diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index bf98a56..1db912e 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -227,11 +227,9 @@ void ata_acpi_associate(struct ata_host *host)
 			acpi_install_notify_handler(ap->acpi_handle,
 						    ACPI_SYSTEM_NOTIFY,
 						    ata_acpi_ap_notify, ap);
-#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
 			/* we might be on a docking station */
 			register_hotplug_dock_device(ap->acpi_handle,
 						     ata_acpi_ap_notify, ap);
-#endif
 		}
 
 		for (j = 0; j < ata_link_max_devices(&ap->link); j++) {
@@ -241,11 +239,9 @@ void ata_acpi_associate(struct ata_host *host)
 				acpi_install_notify_handler(dev->acpi_handle,
 						ACPI_SYSTEM_NOTIFY,
 						ata_acpi_dev_notify, dev);
-#if defined(CONFIG_ACPI_DOCK) || defined(CONFIG_ACPI_DOCK_MODULE)
 				/* we might be on a docking station */
 				register_hotplug_dock_device(dev->acpi_handle,
 						ata_acpi_dev_notify, dev);
-#endif
 			}
 		}
 	}

