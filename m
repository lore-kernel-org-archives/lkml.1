Return-Path: <linux-kernel-owner+w=401wt.eu-S932215AbXGMM7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbXGMM7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 08:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759323AbXGMM7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 08:59:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:53469 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759236AbXGMM7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 08:59:10 -0400
Subject: [PATCH - 1/2] Identify native drivers and ACPI subsystem accessing
	the same resources -  ACPICA stuff
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Bernhard Walle <bwalle@suse.de>,
       "Starikovskiy, Alexey Y" <aystarik@gmail.com>,
       linux-acpi <linux-acpi@vger.kernel.org>, lm-sensors@lm-sensors.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Jean Delvare <khali@linux-fr.org>,
       akpm <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 13 Jul 2007 14:59:09 +0200
Message-Id: <1184331549.3960.105.camel@d88.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Also pass the OperationRegion name to the OS validate func


Signed-off-by: Thomas Renninger <trenn@suse.de>

---
 drivers/acpi/dispatcher/dsopcode.c |    4 +++-
 include/acpi/acpiosxf.h            |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc5/include/acpi/acpiosxf.h
===================================================================
--- linux-2.6.22-rc5.orig/include/acpi/acpiosxf.h
+++ linux-2.6.22-rc5/include/acpi/acpiosxf.h
@@ -239,8 +239,8 @@ acpi_status acpi_os_validate_interface(c
 acpi_status acpi_osi_invalidate(char* interface);
 
 acpi_status
-acpi_os_validate_address(u8 space_id,
-			 acpi_physical_address address, acpi_size length);
+acpi_os_validate_address(u8 space_id, acpi_physical_address address,
+			 acpi_size length, char *name);
 
 u64 acpi_os_get_timer(void);
 
Index: linux-2.6.22-rc5/drivers/acpi/dispatcher/dsopcode.c
===================================================================
--- linux-2.6.22-rc5.orig/drivers/acpi/dispatcher/dsopcode.c
+++ linux-2.6.22-rc5/drivers/acpi/dispatcher/dsopcode.c
@@ -359,7 +359,9 @@ acpi_status acpi_ds_get_region_arguments
 
 	status = acpi_os_validate_address(obj_desc->region.space_id,
 					  obj_desc->region.address,
-					  (acpi_size) obj_desc->region.length);
+					  (acpi_size) obj_desc->region.length,
+					  acpi_ut_get_node_name(node));
+
 	if (ACPI_FAILURE(status)) {
 		/*
 		 * Invalid address/length. We will emit an error message and mark


