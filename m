Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZKILO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZKILO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbZKILO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:14:28 -0500
Received: from adelie.canonical.com ([91.189.90.139]:38712 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZKILO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:14:28 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: linux-acpi@vger.kernel.org
Cc: Corentin Chary <corentin.chary@gmail.com>, linux-kernel@vger.kernel.org,
       acpi4asus-user@lists.sourceforge.net
Subject: [PATCH] Add Lenovo SL hotkey support on asus-laptop
Date: Mon,  9 Nov 2009 19:14:26 +0800
Message-Id: <1257765266-6669-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lenovo SL series laptop has a very similar DSDT with Asus laptops. We can
easily have the extra ACPI function support with little modification in
asus-laptop.c

Here is the hotkey enablement for Lenovo SL series laptop.

This patch will enable the following hotkey:
 - Volumn Up
 - Volumn Down
 - Mute
 - Screen Lock (Fn+F2)
 - Battery Status (Fn+F3)
 - WLAN switch (Fn+F5)
 - Video output switch (Fn+F7)
 - Touchpad switch (Fn+F8)
 - Screen Magnifier (Fn+Space)

The following function of Lenovo SL laptop is still need to be enabled:
 - Hotkey: KEY_SUSPEND (Fn+F4), KEY_SLEEP (Fn+F12), Dock Eject (Fn+F9)
 - Rfkill for bluetooth and wlan
 - LenovoCare LED
 - Hwmon for fan speed
 - Fingerprint scanner
 - Active Protection System

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/asus-laptop.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index b39d2bb..a365636 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -221,6 +221,7 @@ static struct asus_hotk *hotk;
  */
 static const struct acpi_device_id asus_device_ids[] = {
 	{"ATK0100", 0},
+	{"ATK0101", 0},
 	{"", 0},
 };
 MODULE_DEVICE_TABLE(acpi, asus_device_ids);
@@ -293,6 +294,11 @@ struct key_entry {
 enum { KE_KEY, KE_END };
 
 static struct key_entry asus_keymap[] = {
+	{KE_KEY, 0x02, KEY_SCREENLOCK},
+	{KE_KEY, 0x05, KEY_WLAN},
+	{KE_KEY, 0x08, BTN_TOUCH},
+	{KE_KEY, 0x17, KEY_ZOOM},
+	{KE_KEY, 0x1f, KEY_BATTERY},
 	{KE_KEY, 0x30, KEY_VOLUMEUP},
 	{KE_KEY, 0x31, KEY_VOLUMEDOWN},
 	{KE_KEY, 0x32, KEY_MUTE},
@@ -312,7 +318,9 @@ static struct key_entry asus_keymap[] = {
 	{KE_KEY, 0x5F, KEY_WLAN},
 	{KE_KEY, 0x60, KEY_SWITCHVIDEOMODE},
 	{KE_KEY, 0x61, KEY_SWITCHVIDEOMODE},
+	{KE_KEY, 0x62, KEY_SWITCHVIDEOMODE},
+	{KE_KEY, 0x63, KEY_SWITCHVIDEOMODE},
 	{KE_KEY, 0x6B, BTN_TOUCH}, /* Lock Mouse */
 	{KE_KEY, 0x82, KEY_CAMERA},
 	{KE_KEY, 0x8A, KEY_PROG1},
 	{KE_KEY, 0x95, KEY_MEDIA},
-- 
1.6.3.3

