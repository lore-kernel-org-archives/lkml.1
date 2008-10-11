Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbYJKHib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbYJKHib (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754429AbYJKHgz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 03:36:55 -0400
Received: from vms172073pub.verizon.net ([206.46.172.73]:32778 "EHLO
	vms172073pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130AbYJKHgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 03:36:54 -0400
Date: Sat, 11 Oct 2008 02:35:37 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 17/85] ACPICA: Return method arg count from acpi_get_object_info
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <08f0360588282c1b61dad602d465b2bc48a23ab4.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Also update the debugger so that the correct number of arguments is
passed to the method. Prevents a warning message from the debugger.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/namespace/nsxfname.c |    4 ++++
 include/acpi/actypes.h            |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/namespace/nsxfname.c b/drivers/acpi/namespace/nsxfname.c
index a287ed5..6d31a1f 100644
--- a/drivers/acpi/namespace/nsxfname.c
+++ b/drivers/acpi/namespace/nsxfname.c
@@ -264,6 +264,10 @@ acpi_get_object_info(acpi_handle handle, struct acpi_buffer * buffer)
 	info->name = node->name.integer;
 	info->valid = 0;
 
+	if (node->type == ACPI_TYPE_METHOD) {
+		info->param_count = node->object->method.param_count;
+	}
+
 	status = acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
 	if (ACPI_FAILURE(status)) {
 		goto cleanup;
diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
index 4ea4f40..298c636 100644
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -859,6 +859,7 @@ struct acpi_obj_info_header {
 struct acpi_device_info {
 	ACPI_COMMON_OBJ_INFO;
 
+	u32 param_count;	/* If a method, required parameter count */
 	u32 valid;		/* Indicates which fields below are valid */
 	u32 current_status;	/* _STA value */
 	acpi_integer address;	/* _ADR value if any */
-- 
1.5.5.1

