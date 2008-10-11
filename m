Return-Path: <linux-kernel-owner+w=401wt.eu-S1762443AbYJKHB2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762443AbYJKHB2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 03:01:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756342AbYJKGk6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 02:40:58 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:39140 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYJKGgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 02:36:54 -0400
Date: Sat, 11 Oct 2008 02:35:39 -0400
From: Len Brown <lenb@kernel.org>
Subject: [PATCH 19/85] ACPICA: Add function to decode reference obj types to
 strings
In-reply-to: <1223707005-26864-1-git-send-email-lenb@kernel.org>
In-reply-to: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Bob Moore <robert.moore@intel.com>, Lin Ming <ming.m.lin@intel.com>,
       Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>
Message-id: <1fc875c1fe03440534b67f5fb9a91ba5d66220df.1223706853.git.len.brown@intel.com>
Organization: Intel Open Source Technology Center
X-Mailer: git-send-email 1.6.0.2.307.gc427
References: <1223707005-26864-1-git-send-email-lenb@kernel.org>
References: <1d80ebdb81444701024ad9b9f026516561496a43.1223706853.git.len.brown@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

Created for improved error messages.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/utilities/utglobal.c |   36 ++++++++++++++++++++++++++++++++++++
 include/acpi/acutils.h            |    2 ++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/utilities/utglobal.c b/drivers/acpi/utilities/utglobal.c
index a6e71b8..5e57ed9 100644
--- a/drivers/acpi/utilities/utglobal.c
+++ b/drivers/acpi/utilities/utglobal.c
@@ -45,6 +45,7 @@
 
 #include <acpi/acpi.h>
 #include <acpi/acnamesp.h>
+#include <acpi/amlcode.h>
 
 ACPI_EXPORT_SYMBOL(acpi_gbl_FADT)
 #define _COMPONENT          ACPI_UTILITIES
@@ -575,6 +576,41 @@ char *acpi_ut_get_descriptor_name(void *object)
 
 }
 
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_ut_get_reference_name
+ *
+ * PARAMETERS:  Object               - An ACPI reference object
+ *
+ * RETURN:      Pointer to a string
+ *
+ * DESCRIPTION: Decode a reference object sub-type to a string.
+ *
+ ******************************************************************************/
+
+/* Printable names of reference object sub-types */
+
+const char *acpi_ut_get_reference_name(union acpi_operand_object *object)
+{
+
+	switch (object->reference.opcode) {
+	case AML_INT_NAMEPATH_OP:
+		return "Name";
+
+	case AML_LOAD_OP:
+		return "DDB-Handle";
+
+	case AML_REF_OF_OP:
+		return "RefOf";
+
+	case AML_INDEX_OP:
+		return "Index";
+
+	default:
+		return "Unknown";
+	}
+}
+
 #if defined(ACPI_DEBUG_OUTPUT) || defined(ACPI_DEBUGGER)
 /*
  * Strings and procedures used for debug only
diff --git a/include/acpi/acutils.h b/include/acpi/acutils.h
index 69f8888..f827822 100644
--- a/include/acpi/acutils.h
+++ b/include/acpi/acutils.h
@@ -126,6 +126,8 @@ char *acpi_ut_get_node_name(void *object);
 
 char *acpi_ut_get_descriptor_name(void *object);
 
+const char *acpi_ut_get_reference_name(union acpi_operand_object *object);
+
 char *acpi_ut_get_object_type_name(union acpi_operand_object *obj_desc);
 
 char *acpi_ut_get_region_name(u8 space_id);
-- 
1.5.5.1

