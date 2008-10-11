Return-Path: <linux-kernel-owner+w=401wt.eu-S1762973AbYJKGuw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762973AbYJKGuw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 02:50:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756755AbYJKGjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:39:00 -0400
Received: from vms172071pub.verizon.net ([206.46.172.71]:52181 "EHLO
	vms172071pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879AbYJKGhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:37:17 -0400
Date: Sat, 11 Oct 2008 02:36:35 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 75/85] ACPI processor: Debug interface used for error message
 cleanup
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
       Len Brown <len.brown@intel.com>
Message-id: <e127770259e4341df0f83c3531f0df57982815e2.1223706853.git.len.brown@intel.com>
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
 drivers/acpi/processor_perflib.c    |   17 ++++++-----------
 drivers/acpi/processor_throttling.c |   17 ++++++-----------
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/acpi/processor_perflib.c b/drivers/acpi/processor_perflib.c
index 80c251e..bf183e7 100644
--- a/drivers/acpi/processor_perflib.c
+++ b/drivers/acpi/processor_perflib.c
@@ -523,14 +523,9 @@ static int acpi_processor_get_psd(struct acpi_processor	*pr)
 	}
 
 	psd = buffer.pointer;
-	if (!psd || (psd->type != ACPI_TYPE_PACKAGE)) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Invalid _PSD data\n"));
-		result = -EFAULT;
-		goto end;
-	}
-
-	if (psd->package.count != 1) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Invalid _PSD data\n"));
+	if (!psd || (psd->type != ACPI_TYPE_PACKAGE)
+	    || psd->package.count != 1) {
+		printk(KERN_ERR "Invalid _PSD data\n");
 		result = -EFAULT;
 		goto end;
 	}
@@ -543,19 +538,19 @@ static int acpi_processor_get_psd(struct acpi_processor	*pr)
 	status = acpi_extract_package(&(psd->package.elements[0]),
 		&format, &state);
 	if (ACPI_FAILURE(status)) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Invalid _PSD data\n"));
+		ACPI_EXCEPTION((AE_INFO, status, "Invalid _PSD data"));
 		result = -EFAULT;
 		goto end;
 	}
 
 	if (pdomain->num_entries != ACPI_PSD_REV0_ENTRIES) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Unknown _PSD:num_entries\n"));
+		printk(KERN_ERR "Unknown _PSD:num_entries\n");
 		result = -EFAULT;
 		goto end;
 	}
 
 	if (pdomain->revision != ACPI_PSD_REV0_REVISION) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Unknown _PSD:revision\n"));
+		printk(KERN_ERR "Unknown _PSD:revision\n");
 		result = -EFAULT;
 		goto end;
 	}
diff --git a/drivers/acpi/processor_throttling.c b/drivers/acpi/processor_throttling.c
index a56fc6c..ce4540d 100644
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -527,14 +527,9 @@ static int acpi_processor_get_tsd(struct acpi_processor *pr)
 	}
 
 	tsd = buffer.pointer;
-	if (!tsd || (tsd->type != ACPI_TYPE_PACKAGE)) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Invalid _TSD data\n"));
-		result = -EFAULT;
-		goto end;
-	}
-
-	if (tsd->package.count != 1) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Invalid _TSD data\n"));
+	if (!tsd || (tsd->type != ACPI_TYPE_PACKAGE)
+	    || tsd->package.count != 1) {
+		printk(KERN_INFO "Invalid _TSD data\n");
 		result = -EFAULT;
 		goto end;
 	}
@@ -547,19 +542,19 @@ static int acpi_processor_get_tsd(struct acpi_processor *pr)
 	status = acpi_extract_package(&(tsd->package.elements[0]),
 				      &format, &state);
 	if (ACPI_FAILURE(status)) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Invalid _TSD data\n"));
+		ACPI_EXCEPTION((AE_INFO, status, "Invalid _TSD data"));
 		result = -EFAULT;
 		goto end;
 	}
 
 	if (pdomain->num_entries != ACPI_TSD_REV0_ENTRIES) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Unknown _TSD:num_entries\n"));
+		printk(KERN_ERR "Unknown _TSD:num_entries\n");
 		result = -EFAULT;
 		goto end;
 	}
 
 	if (pdomain->revision != ACPI_TSD_REV0_REVISION) {
-		ACPI_DEBUG_PRINT((ACPI_DB_ERROR, "Unknown _TSD:revision\n"));
+		printk(KERN_ERR "Unknown _TSD:revision\n");
 		result = -EFAULT;
 		goto end;
 	}
-- 
1.5.5.1

