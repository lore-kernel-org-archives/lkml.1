Return-Path: <linux-kernel-owner+w=401wt.eu-S1764004AbYBPBHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764004AbYBPBHr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 20:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758678AbYBPBHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 20:07:23 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:22150 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbYBPBHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 20:07:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SxPnfwy9c+eT9UDemKSGRfRU1kPtEb8y0Z4GMqg0dbcKTFiCsfsvSihQIcfX632SJQF75eYyKeZGi1J2f9k71kzzH5Ajb2wBK34ViwuLCsf1x4/MuZ4oZeqB7AOR3T1K8PbrUSlp/GfYXDTbx8GmChmmALW2o8NYFfY5/uyc3y0=
Subject: [PATCH] acpi: sparse fix, replace macro with static function
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 17:07:19 -0800
Message-Id: <1203124039.7442.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

replace acpi_util_eval_error macro with static function.

Avoid these sparse warnings due to using buffer within the macro.
drivers/acpi/utils.c:273:3: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:259:21: originally declared here
drivers/acpi/utils.c:279:3: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:259:21: originally declared here
drivers/acpi/utils.c:368:3: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:348:21: originally declared here
drivers/acpi/utils.c:375:3: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:348:21: originally declared here
drivers/acpi/utils.c:382:3: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:348:21: originally declared here
drivers/acpi/utils.c:402:4: warning: symbol 'buffer' shadows an earlier one
drivers/acpi/utils.c:348:21: originally declared here

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 drivers/acpi/utils.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
index 34f1575..eba55b7 100644
--- a/drivers/acpi/utils.c
+++ b/drivers/acpi/utils.c
@@ -36,16 +36,20 @@ ACPI_MODULE_NAME("utils");
 /* --------------------------------------------------------------------------
                             Object Evaluation Helpers
    -------------------------------------------------------------------------- */
+static void
+acpi_util_eval_error(acpi_handle h, acpi_string p, acpi_status s)
+{
 #ifdef ACPI_DEBUG_OUTPUT
-#define acpi_util_eval_error(h,p,s) {\
-	char prefix[80] = {'\0'};\
-	struct acpi_buffer buffer = {sizeof(prefix), prefix};\
-	acpi_get_name(h, ACPI_FULL_PATHNAME, &buffer);\
-	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Evaluate [%s.%s]: %s\n",\
-		(char *) prefix, p, acpi_format_exception(s))); }
+	char prefix[80] = {'\0'};
+	struct acpi_buffer buffer = {sizeof(prefix), prefix};
+	acpi_get_name(h, ACPI_FULL_PATHNAME, &buffer);
+	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Evaluate [%s.%s]: %s\n",
+		(char *) prefix, p, acpi_format_exception(s)));
 #else
-#define acpi_util_eval_error(h,p,s)
+	return;
 #endif
+}
+
 acpi_status
 acpi_extract_package(union acpi_object *package,
 		     struct acpi_buffer *format, struct acpi_buffer *buffer)
-- 
1.5.4.1.1278.gc75be



