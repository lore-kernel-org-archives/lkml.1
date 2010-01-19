Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171Ab0ASHHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171Ab0ASHHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:07:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229Ab0ASHHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:07:40 -0500
Received: from adelie.canonical.com ([91.189.90.139]:45086 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668Ab0ASHHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:07:40 -0500
From: Ike Panhc <ike.pan@canonical.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: Corentin Chary <corentincj@iksaif.net>, Len Brown <len.brown@intel.com>
Subject: [stable .32] [PATCH] asus-laptop: add Lenovo SL hotkey support
Date: Tue, 19 Jan 2010 15:07:31 +0800
Message-Id: <1263884851-7197-1-git-send-email-ike.pan@canonical.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 14f8af311e7d3e4198cbaade84a34f86505dcb37 upstream.

This patch is made against current checkout of 2.6.32.y stable tree with a
minor modification - BTN_TOUCH instead of KEY_F13, the same with
asus-laptop.c in 2.6.32.

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

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
---
 drivers/platform/x86/asus-laptop.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 849359a..22d742d 100644
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
@@ -312,6 +318,8 @@ static struct key_entry asus_keymap[] = {
 	{KE_KEY, 0x5F, KEY_WLAN},
 	{KE_KEY, 0x60, KEY_SWITCHVIDEOMODE},
 	{KE_KEY, 0x61, KEY_SWITCHVIDEOMODE},
+	{KE_KEY, 0x62, KEY_SWITCHVIDEOMODE},
+	{KE_KEY, 0x63, KEY_SWITCHVIDEOMODE},
 	{KE_KEY, 0x6B, BTN_TOUCH}, /* Lock Mouse */
 	{KE_KEY, 0x82, KEY_CAMERA},
 	{KE_KEY, 0x8A, KEY_PROG1},
-- 
1.6.3.3

