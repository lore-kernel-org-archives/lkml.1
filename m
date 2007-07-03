Return-Path: <linux-kernel-owner+w=401wt.eu-S1757802AbXGCD6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbXGCD6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 23:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbXGCD60
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 23:58:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:42291 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbXGCD6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 23:58:25 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH for 2.6.22] ACPI: fix acpi_osi=!Linux
Date: Mon, 2 Jul 2007 23:57:45 -0400
User-Agent: KMail/1.9.5
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       a.biardi@tiscali.it
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707022357.45836.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Need to check for special case "acpi_osi=!Linux"
before general case "acpi_osi=!*",
or it will have no effect.

Signed-off-by: Len Brown <len.brown@intel.com>
---
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 58ceb18..2e7ba61 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -999,11 +999,11 @@ static int __init acpi_osi_setup(char *str)
 	if (str == NULL || *str == '\0') {
 		printk(KERN_INFO PREFIX "_OSI method disabled\n");
 		acpi_gbl_create_osi_method = FALSE;
+	} else if (!strcmp("!Linux", str)) {
+		enable_osi_linux(0);
 	} else if (*str == '!') {
 		if (acpi_osi_invalidate(++str) == AE_OK)
 			printk(KERN_INFO PREFIX "Deleted _OSI(%s)\n", str);
-	} else if (!strcmp("!Linux", str)) {
-		enable_osi_linux(0);
 	} else if (!strcmp("Linux", str)) {
 		enable_osi_linux(1);
 	} else if (*osi_additional_string == '\0') {
