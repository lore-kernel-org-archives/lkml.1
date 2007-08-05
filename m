Return-Path: <linux-kernel-owner+w=401wt.eu-S1760537AbXHETGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760537AbXHETGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 15:06:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755396AbXHETGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 15:06:16 -0400
Received: from gepetto.dc.ltu.se ([130.240.42.40]:47397 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbXHETGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 15:06:15 -0400
Message-ID: <46B61F70.90005@student.ltu.se>
Date: Sun, 05 Aug 2007 21:05:20 +0200
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Ben Collins <bcollins@ubuntu.com>
CC: "Brown, Len" <len.brown@intel.com>, linux-acpi@vger.kernel.org,
       Stelian Pop <stelian@popies.net>, linux-kernel@vger.kernel.org
Subject: [PATCH] sonypi: Fix initialization warning
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Got this from the compiler (gcc (GCC) 4.1.2 20070626 (Red Hat 4.1.2-13)):
drivers/char/sonypi.c:1153: warning: initialization from incompatible pointer type


diff --git a/drivers/char/sonypi.c b/drivers/char/sonypi.c
index 73037a4..2dcd519 100644
--- a/drivers/char/sonypi.c
+++ b/drivers/char/sonypi.c
@@ -1147,10 +1147,15 @@ static int sonypi_acpi_remove(struct acpi_device *device, int type)
 	return 0;
 }
 
+static const struct acpi_device_id sonypi_acpi_driver_ids[] = {
+        {ACPI_PROCESSOR_HID, 0},
+        {"", 0},
+};
+
 static struct acpi_driver sonypi_acpi_driver = {
 	.name           = "sonypi",
 	.class          = "hkey",
-	.ids            = "SNY6001",
+	.ids            = sonypi_acpi_driver_ids,
 	.ops            = {
 		           .add = sonypi_acpi_add,
 			   .remove = sonypi_acpi_remove,


