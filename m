Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbYHNDdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbYHNDdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 23:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbYHNDdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 23:33:00 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:53548 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbYHNDc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 23:32:59 -0400
Date: Thu, 14 Aug 2008 04:32:55 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Make Dell keyboard repeat quirk apply to a wider range of hardware
Message-ID: <20080814033255.GA21721@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dell laptops fail to send key up events for several of their special 
keys. There's an existing quirk in the kernel to handle this, but it's 
limited to the Latitude range. This patch extends it to cover all 
portable Dells.

Signed-off-by: Matthew Garrett <mjg@redhat.com>

---
diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index b1ce10f..e32c24d 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -834,10 +834,10 @@ static void atkbd_disconnect(struct serio *serio)
 }
 
 /*
- * Most special keys (Fn+F?) on Dell Latitudes do not generate release
+ * Most special keys (Fn+F?) on Dell laptops do not generate release
  * events so we have to do it ourselves.
  */
-static void atkbd_latitude_keymap_fixup(struct atkbd *atkbd)
+static void atkbd_dell_laptop_keymap_fixup(struct atkbd *atkbd)
 {
 	const unsigned int forced_release_keys[] = {
 		0x85, 0x86, 0x87, 0x88, 0x89, 0x8a, 0x8b, 0x8f, 0x93,
@@ -1461,13 +1461,13 @@ static int __init atkbd_setup_fixup(const struct dmi_system_id *id)
 
 static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
 	{
-		.ident = "Dell Latitude series",
+		.ident = "Dell Laptop",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
-			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude"),
+			DMI_MATCH(DMI_CHASSIS_TYPE, "8"), /* Portable */
 		},
 		.callback = atkbd_setup_fixup,
-		.driver_data = atkbd_latitude_keymap_fixup,
+		.driver_data = atkbd_dell_laptop_keymap_fixup,
 	},
 	{
 		.ident = "HP 2133",

-- 
Matthew Garrett | mjg59@srcf.ucam.org
