Return-Path: <linux-kernel-owner+w=401wt.eu-S1753557Ab0AJQPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab0AJQPw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 11:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509Ab0AJQPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 11:15:50 -0500
Received: from mail01d.mail.t-online.hu ([84.2.42.6]:64488 "EHLO
	mail01d.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486Ab0AJQPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 11:15:47 -0500
Message-ID: <4B49FD28.6080800@freemail.hu>
Date: Sun, 10 Jan 2010 17:15:36 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Julia Lawall <julia@diku.dk>,
       cocci@diku.dk
Subject: [PATCH] acpi: make ACPI device id constant
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01d.mail.t-online.hu 32711; Body=5 Fuz1=5
	Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

The ids field of the struct acpi_driver is constant in <linux/acpi/acpi_bus.h>
so it is worth to make the initialization data also constant.

The semantic match that finds this kind of pattern is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
disable decl_init,const_decl_init;
identifier I1, I2, x;
@@
	struct I1 {
	  ...
	  const struct I2 *x;
	  ...
	};
@s@
identifier r.I1, y;
identifier r.x, E;
@@
	struct I1 y = {
	  .x = E,
	};
@c@
identifier r.I2;
identifier s.E;
@@
	const struct I2 E[] = ... ;
@depends on !c@
identifier r.I2;
identifier s.E;
@@
+	const
	struct I2 E[] = ...;
// </smpl>

Signed-off-by: Márton Németh <nm127@freemail.hu>
Cc: Julia Lawall <julia@diku.dk>
Cc: cocci@diku.dk
---
diff -u -p a/drivers/acpi/power.c b/drivers/acpi/power.c
--- a/drivers/acpi/power.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/acpi/power.c 2010-01-08 15:02:32.000000000 +0100
@@ -65,7 +65,7 @@ static int acpi_power_remove(struct acpi
 static int acpi_power_resume(struct acpi_device *device);
 static int acpi_power_open_fs(struct inode *inode, struct file *file);

-static struct acpi_device_id power_device_ids[] = {
+static const struct acpi_device_id power_device_ids[] = {
 	{ACPI_POWER_HID, 0},
 	{"", 0},
 };
diff -u -p a/drivers/acpi/power_meter.c b/drivers/acpi/power_meter.c
--- a/drivers/acpi/power_meter.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/acpi/power_meter.c 2010-01-08 15:03:09.000000000 +0100
@@ -64,7 +64,7 @@ static int can_cap_in_hardware(void)
 	return force_cap_on || cap_in_hardware;
 }

-static struct acpi_device_id power_meter_ids[] = {
+static const struct acpi_device_id power_meter_ids[] = {
 	{"ACPI000D", 0},
 	{"", 0},
 };
diff -u -p a/drivers/acpi/pci_link.c b/drivers/acpi/pci_link.c
--- a/drivers/acpi/pci_link.c 2009-12-03 04:51:21.000000000 +0100
+++ b/drivers/acpi/pci_link.c 2010-01-08 15:03:22.000000000 +0100
@@ -56,7 +56,7 @@ ACPI_MODULE_NAME("pci_link");
 static int acpi_pci_link_add(struct acpi_device *device);
 static int acpi_pci_link_remove(struct acpi_device *device, int type);

-static struct acpi_device_id link_device_ids[] = {
+static const struct acpi_device_id link_device_ids[] = {
 	{"PNP0C0F", 0},
 	{"", 0},
 };
diff -u -p a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
--- a/drivers/acpi/pci_root.c 2010-01-07 19:08:39.000000000 +0100
+++ b/drivers/acpi/pci_root.c 2010-01-08 15:06:03.000000000 +0100
@@ -46,7 +46,7 @@ static int acpi_pci_root_add(struct acpi
 static int acpi_pci_root_remove(struct acpi_device *device, int type);
 static int acpi_pci_root_start(struct acpi_device *device);

-static struct acpi_device_id root_device_ids[] = {
+static const struct acpi_device_id root_device_ids[] = {
 	{"PNP0A03", 0},
 	{"", 0},
 };
