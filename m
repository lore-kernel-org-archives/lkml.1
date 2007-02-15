Return-Path: <linux-kernel-owner+w=401wt.eu-S1161202AbXBOUfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161202AbXBOUfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 15:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161200AbXBOUfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 15:35:18 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:37233 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161193AbXBOUfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 15:35:17 -0500
X-Greylist: delayed 1606 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Feb 2007 15:35:17 EST
From: John Keller <jpk@sgi.com>
To: linux-acpi@vger.kernel.org
Cc: ayoung@sgi.com, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Keller <jpk@sgi.com>
Date: Thu, 15 Feb 2007 14:08:30 -0600
Message-Id: <20070215200830.1822.98901.sendpatchset@attica.americas.sgi.com>
Subject: [PATCH 1/1] -  acpi_unload_table_id() always returns error
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

acpi_unload_table_id() is always returning an error status.
Also, once the matching table is found, don't bother looking
for another match.


Signed-off-by: John Keller <jpk@sgi.com>
---


Index: release/drivers/acpi/tables/tbxface.c
===================================================================
--- release.orig/drivers/acpi/tables/tbxface.c	2007-02-13 08:20:42.000000000 -0600
+++ release/drivers/acpi/tables/tbxface.c	2007-02-15 14:04:07.855248010 -0600
@@ -338,9 +338,9 @@ acpi_status acpi_unload_table_id(acpi_ow
 	int i;
 	acpi_status status = AE_NOT_EXIST;
 
-	ACPI_FUNCTION_TRACE(acpi_unload_table);
+	ACPI_FUNCTION_TRACE(acpi_unload_table_id);
 
-	/* Find table from the requested type list */
+	/* Find table in the global table list */
 	for (i = 0; i < acpi_gbl_root_table_list.count; ++i) {
 		if (id != acpi_gbl_root_table_list.tables[i].owner_id) {
 			continue;
@@ -352,8 +352,9 @@ acpi_status acpi_unload_table_id(acpi_ow
 		* simply a position within the hierarchy
 		*/
 		acpi_tb_delete_namespace_by_owner(i);
-		acpi_tb_release_owner_id(i);
+		status = acpi_tb_release_owner_id(i);
 		acpi_tb_set_table_loaded_flag(i, FALSE);
+		break;
 	}
 	return_ACPI_STATUS(status);
 }
