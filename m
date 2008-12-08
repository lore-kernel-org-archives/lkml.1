Return-Path: <linux-kernel-owner+w=401wt.eu-S1752883AbYLHVDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbYLHVDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 16:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbYLHVDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 16:03:15 -0500
Received: from vms173005pub.verizon.net ([206.46.173.5]:44354 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbYLHVDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 16:03:14 -0500
Date: Mon, 08 Dec 2008 16:03:07 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 2.6.23..2.6.27.stable] ACPI: delete OSI(Linux) DMI dmesg spam
X-X-Sender: lenb@localhost.localdomain
To: stable@kernel.org
Cc: linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0812081556060.4406@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per 2.6.28 commit a6e0887f21bbab337ee32d9c0a84d7c0b6e9141b,
stop soliciting DMI info for this BIOS issue.

Signed-off-by: Len Brown <len.brown@intel.com>
---
This patch applies cleanly to 2.6.26 and 2.6.27
It applies with various offsets to 2.6.23, 2.6.24, 2.6.25

thanks,
-Len Brown
Intel Open Source Technology Center

diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 235a138..b0d40aa 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -1261,34 +1261,6 @@ acpi_status acpi_os_release_object(acpi_cache_t * cache, void *object)
 	return (AE_OK);
 }
 
-/**
- *	acpi_dmi_dump - dump DMI slots needed for blacklist entry
- *
- *	Returns 0 on success
- */
-static int acpi_dmi_dump(void)
-{
-
-	if (!dmi_available)
-		return -1;
-
-	printk(KERN_NOTICE PREFIX "DMI System Vendor: %s\n",
-		dmi_get_system_info(DMI_SYS_VENDOR));
-	printk(KERN_NOTICE PREFIX "DMI Product Name: %s\n",
-		dmi_get_system_info(DMI_PRODUCT_NAME));
-	printk(KERN_NOTICE PREFIX "DMI Product Version: %s\n",
-		dmi_get_system_info(DMI_PRODUCT_VERSION));
-	printk(KERN_NOTICE PREFIX "DMI Board Name: %s\n",
-		dmi_get_system_info(DMI_BOARD_NAME));
-	printk(KERN_NOTICE PREFIX "DMI BIOS Vendor: %s\n",
-		dmi_get_system_info(DMI_BIOS_VENDOR));
-	printk(KERN_NOTICE PREFIX "DMI BIOS Date: %s\n",
-		dmi_get_system_info(DMI_BIOS_DATE));
-
-	return 0;
-}
-
-
 /******************************************************************************
  *
  * FUNCTION:    acpi_os_validate_interface
@@ -1315,14 +1287,6 @@ acpi_os_validate_interface (char *interface)
 			osi_linux.cmdline ? " via cmdline" :
 			osi_linux.dmi ? " via DMI" : "");
 
-		if (!osi_linux.dmi) {
-			if (acpi_dmi_dump())
-				printk(KERN_NOTICE PREFIX
-					"[please extract dmidecode output]\n");
-			printk(KERN_NOTICE PREFIX
-				"Please send DMI info above to "
-				"linux-acpi@vger.kernel.org\n");
-		}
 		if (!osi_linux.known && !osi_linux.cmdline) {
 			printk(KERN_NOTICE PREFIX
 				"If \"acpi_osi=%sLinux\" works better, "
