Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297Ab0AEAfK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab0AEAfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:35:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211Ab0AEAev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:34:51 -0500
Received: from kroah.org ([198.145.64.141]:34130 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab0AEAet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:34:49 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 15/97] ACPI: EC: Fix MSI DMI detection
Date: Mon,  4 Jan 2010 16:32:28 -0800
Message-Id: <1262651630-7354-15-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Starikovskiy <astarikovskiy@suse.de>

commit 55b313f249e11b815fd0be51869f166aaf368f44 upstream.

MSI strings should be ORed, not ANDed.

Reference: http://bugzilla.kernel.org/show_bug.cgi?id=14446

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/acpi/ec.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index baef28c..7511029 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -916,6 +916,7 @@ static int ec_validate_ecdt(const struct dmi_system_id *id)
 /* MSI EC needs special treatment, enable it */
 static int ec_flag_msi(const struct dmi_system_id *id)
 {
+	printk(KERN_DEBUG PREFIX "Detected MSI hardware, enabling workarounds.\n");
 	EC_FLAGS_MSI = 1;
 	EC_FLAGS_VALIDATE_ECDT = 1;
 	return 0;
@@ -928,8 +929,13 @@ static struct dmi_system_id __initdata ec_dmi_table[] = {
 	DMI_MATCH(DMI_BOARD_NAME, "JFL92") }, NULL},
 	{
 	ec_flag_msi, "MSI hardware", {
-	DMI_MATCH(DMI_BIOS_VENDOR, "Micro-Star"),
-	DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-Star") }, NULL},
+	DMI_MATCH(DMI_BIOS_VENDOR, "Micro-Star")}, NULL},
+	{
+	ec_flag_msi, "MSI hardware", {
+	DMI_MATCH(DMI_SYS_VENDOR, "Micro-Star")}, NULL},
+	{
+	ec_flag_msi, "MSI hardware", {
+	DMI_MATCH(DMI_CHASSIS_VENDOR, "MICRO-Star")}, NULL},
 	{
 	ec_validate_ecdt, "ASUS hardware", {
 	DMI_MATCH(DMI_BIOS_VENDOR, "ASUS") }, NULL},
-- 
1.6.6

