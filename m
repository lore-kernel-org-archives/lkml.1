Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbYK2SJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbYK2SJX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 13:09:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbYK2SJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 13:09:10 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:6927 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751393AbYK2SJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 13:09:08 -0500
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Len Brown <len.brown@intel.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Date: Sat, 29 Nov 2008 07:21:29 +0100
Subject: [PATCH] ACPI: EC: fix compilation warning
From: Hannes Eder <hannes@hanneseder.net>
Message-ID: <49318541.0aec660a.0efb.3436@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the warning introduced in commit c5279dee26c0e8d7c4200993bfc4b540d2469598,
and give the dummy variable a more verbose name.

  drivers/acpi/ec.c: In function 'acpi_ec_ecdt_probe':
  drivers/acpi/ec.c:1015: warning: ISO C90 forbids mixed declarations and code

Signed-off-by: Hannes Eder <hannes@hanneseder.net>
---
 drivers/acpi/ec.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index c16e09b..60db1b2 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -980,6 +980,7 @@ int __init acpi_ec_ecdt_probe(void)
 {
 	acpi_status status;
 	struct acpi_table_ecdt *ecdt_ptr;
+	acpi_handle dummy;
 
 	boot_ec = make_acpi_ec();
 	if (!boot_ec)
@@ -1012,7 +1013,6 @@ int __init acpi_ec_ecdt_probe(void)
 	}
 	/* This workaround is needed only on some broken machines,
 	 * which require early EC, but fail to provide ECDT */
-	acpi_handle x;
 	printk(KERN_DEBUG PREFIX "Look up EC in DSDT\n");
 	status = acpi_get_devices(ec_device_ids[0].id, ec_parse_device,
 					boot_ec, NULL);
@@ -1023,7 +1023,7 @@ int __init acpi_ec_ecdt_probe(void)
 	 * which needs it, has fake EC._INI method, so use it as flag.
 	 * Keep boot_ec struct as it will be needed soon.
 	 */
-	if (ACPI_FAILURE(acpi_get_handle(boot_ec->handle, "_INI", &x)))
+	if (ACPI_FAILURE(acpi_get_handle(boot_ec->handle, "_INI", &dummy)))
 		return -ENODEV;
 install:
 	if (!ec_install_handlers(boot_ec)) {
-- 
1.5.6.3

