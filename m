Return-Path: <linux-kernel-owner+w=401wt.eu-S1760006AbYJKHm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760006AbYJKHm1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758466AbYJKHhn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:37:43 -0400
Received: from vms172073pub.verizon.net ([206.46.172.73]:32846 "EHLO
	vms172073pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281AbYJKHhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:37:38 -0400
Date: Sat, 11 Oct 2008 02:36:37 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 77/85] ACPI scan: Debug interface used for error message cleanup
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <e46ba07096d1c71cca5ca1256e61064a2bb60287.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Renninger <trenn@suse.de>

Signed-off-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/scan.c |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index f6f52c1..0d46347 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -113,16 +113,16 @@ static int acpi_bus_hot_remove_device(void *context)
 
 
 	if (acpi_bus_trim(device, 1)) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR,
-				"Removing device failed\n"));
+		printk(KERN_ERR "Removing device [%s] failed\n",
+		       acpi_device_bid(device));
 		return -1;
 	}
 
 	/* power off device */
 	status = acpi_evaluate_object(handle, "_PS3", NULL, NULL);
 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND)
-		ACPI_DEBUG_PRINT((ACPI_DB_WARN,
-				"Power-off device failed\n"));
+		ACPI_EXCEPTION((AE_INFO, status,
+				"Power-off device failed"));
 
 	if (device->flags.lockable) {
 		arg_list.count = 1;
@@ -477,7 +477,8 @@ static int acpi_device_register(struct acpi_device *device,
 
 	result = acpi_device_setup_files(device);
 	if(result)
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Error creating sysfs interface for device %s\n", device->dev.bus_id));
+		printk(KERN_ERR "Error creating sysfs interface for device"
+		       " %s [%d]\n", device->dev.bus_id, result);
 
 	device->removal_type = ACPI_BUS_REMOVAL_NORMAL;
 	return 0;
-- 
1.5.5.1

