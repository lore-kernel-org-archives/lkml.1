Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZBOU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZBOU4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 15:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZBOU4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 15:56:07 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:56663 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbZBOU4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 15:56:06 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] ACPI: bus.c, fix error handling in acpi_bus_init
Date: Sun, 15 Feb 2009 21:55:54 +0100
Message-Id: <1234731354-7472-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a misplaced status test. Move it to correct place and
rollback appropriately.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/acpi/bus.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 765fd1c..79efef6 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -760,18 +760,17 @@ static int __init acpi_bus_init(void)
 
 
 	status = acpi_os_initialize1();
-
-	status =
-	    acpi_enable_subsystem(ACPI_NO_HARDWARE_INIT | ACPI_NO_ACPI_ENABLE);
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR PREFIX
-		       "Unable to start the ACPI Interpreter\n");
-		goto error1;
+		       "Unable to initialize ACPI OS objects\n");
+		goto error0;
 	}
 
+	status =
+	    acpi_enable_subsystem(ACPI_NO_HARDWARE_INIT | ACPI_NO_ACPI_ENABLE);
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR PREFIX
-		       "Unable to initialize ACPI OS objects\n");
+		       "Unable to start the ACPI Interpreter\n");
 		goto error1;
 	}
 
@@ -832,6 +831,7 @@ static int __init acpi_bus_init(void)
 	/* Mimic structured exception handling */
       error1:
 	acpi_terminate();
+error0:
 	return -ENODEV;
 }
 
-- 
1.6.1.3

