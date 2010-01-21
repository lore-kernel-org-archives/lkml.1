Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567Ab0AUE12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab0AUE12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754208Ab0AUE0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:26:45 -0500
Received: from kroah.org ([198.145.64.141]:60168 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab0AUEXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:23:02 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Jan 20 20:18:35 2010
Message-Id: <20100121041835.339511488@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Jan 2010 20:15:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ike Panhc <ike.pan@canonical.com>, Len Brown <len.brown@intel.com>
Subject: [22/30] asus-laptop: add Lenovo SL hotkey support
In-Reply-To: <20100121041852.GA9656@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ike Panhc <ike.pan@canonical.com>

commit 14f8af311e7d3e4198cbaade84a34f86505dcb37 upstream.

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
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/asus-laptop.c |    8 ++++++++
 1 file changed, 8 insertions(+)

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
@@ -312,6 +318,8 @@ static struct key_entry asus_keymap[] = 
 	{KE_KEY, 0x5F, KEY_WLAN},
 	{KE_KEY, 0x60, KEY_SWITCHVIDEOMODE},
 	{KE_KEY, 0x61, KEY_SWITCHVIDEOMODE},
+	{KE_KEY, 0x62, KEY_SWITCHVIDEOMODE},
+	{KE_KEY, 0x63, KEY_SWITCHVIDEOMODE},
 	{KE_KEY, 0x6B, BTN_TOUCH}, /* Lock Mouse */
 	{KE_KEY, 0x82, KEY_CAMERA},
 	{KE_KEY, 0x8A, KEY_PROG1},


