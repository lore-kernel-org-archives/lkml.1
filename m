Return-Path: <linux-kernel-owner+w=401wt.eu-S933263AbZGPUIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933263AbZGPUIv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933233AbZGPUIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:08:51 -0400
Received: from mail.tpi.com ([70.99.223.143]:2143 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933194AbZGPUIu (ORCPT <rfc822;linux-kernel@Vger.kernel.org>);
	Thu, 16 Jul 2009 16:08:50 -0400
To: dmitry.torokhov@gmail.com
Subject: [PATCH] atkbd - Fix Soltech TA12 volume hotkeys not sending key release
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20090716200844.89EC7F8A01@sepang.rtg.net>
Date: Thu, 16 Jul 2009 14:08:44 -0600 (MDT)
From: timg@tpi.com (Tim Gardner)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8b172a3c3f976f85ddea136ac0cffe32295cfd61 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Thu, 16 Jul 2009 13:06:12 -0600
Subject: [PATCH] atkbd - Fix Soltech TA12 volume hotkeys not sending key release

BugLink: https://bugs.launchpad.net//bugs/397499

Impact: Netbooks based on the Soltech TA12 do not send a key release
for volume keys causing Linux to think the key is constantly being
pressed forever.

Added quirk data for forced release keys.

OriginalAuthor: Jerone Young <jerone.young@canonical.com>

Signed-off-by: Jerone Young <jerone.young@canonical.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/input/keyboard/atkbd.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 777d01a..f5c40d7 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -909,6 +909,13 @@ static unsigned int atkbd_amilo_xi_2428_forced_release_keys[] = {
 };
 
 /*
+ * Soltech TA12 system with broken key release on volume keys and mute key
+ */
+static unsigned int atkdb_soltech_ta12_forced_release_keys[] = {
+	0xa0, 0xae, 0xb0, -1U
+};
+
+/*
  * atkbd_set_keycode_table() initializes keyboard's keycode table
  * according to the selected scancode set
  */
@@ -1611,6 +1618,15 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
 		.callback = atkbd_setup_forced_release,
 		.driver_data = atkbd_amilo_xi_2428_forced_release_keys,
 	},
+	{
+		.ident = "Soltech Corporation TA12",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Soltech Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "TA12"),
+		},
+		.callback = atkbd_setup_forced_release,
+		.driver_data = atkdb_soltech_ta12_forced_release_keys,
+	},
 	{ }
 };
 
-- 
1.6.2.4

