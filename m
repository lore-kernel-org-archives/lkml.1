Return-Path: <linux-kernel-owner+w=401wt.eu-S1759636AbXJXOdO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759636AbXJXOdO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:33:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758644AbXJXOcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:32:53 -0400
Received: from mx1.suse.de ([195.135.220.2]:48470 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758409AbXJXOcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:32:52 -0400
Subject: [PATCH 1/5] Small ACPICA extension to be able to store the name of
	operation regions in osl.c later
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-acpi <linux-acpi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 24 Oct 2007 16:32:51 +0200
Message-Id: <1193236371.4590.228.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/acpi/dispatcher/dsopcode.c |    4 +++-
 include/acpi/acpiosxf.h            |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

Index: lenb/drivers/acpi/dispatcher/dsopcode.c
===================================================================
--- lenb.orig/drivers/acpi/dispatcher/dsopcode.c
+++ lenb/drivers/acpi/dispatcher/dsopcode.c
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
Index: lenb/include/acpi/acpiosxf.h
===================================================================
--- lenb.orig/include/acpi/acpiosxf.h
+++ lenb/include/acpi/acpiosxf.h
@@ -239,8 +239,8 @@ acpi_status acpi_os_validate_interface(c
 acpi_status acpi_osi_invalidate(char* interface);
 
 acpi_status
-acpi_os_validate_address(u8 space_id,
-			 acpi_physical_address address, acpi_size length);
+acpi_os_validate_address(u8 space_id, acpi_physical_address address,
+			 acpi_size length, char *name);
 
 u64 acpi_os_get_timer(void);
 


