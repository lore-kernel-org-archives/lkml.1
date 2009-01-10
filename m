Return-Path: <linux-kernel-owner+w=401wt.eu-S1754741AbZAJNoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741AbZAJNoo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 08:44:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZAJNod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 08:44:33 -0500
Received: from atum.ita.chalmers.se ([129.16.4.148]:42364 "EHLO
	atum.ita.chalmers.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbZAJNod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 08:44:33 -0500
X-Greylist: delayed 678 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Jan 2009 08:44:32 EST
Message-ID: <4968A391.2000400@student.chalmers.se>
Date: Sat, 10 Jan 2009 14:33:05 +0100
From: Rikard Ljungstrand <lrikard@student.chalmers.se>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com
CC: dtor@mail.ru, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       apw@canonical.com
Subject: [PATCH] Input: Add keyboard quirk for HP Pavilion ZV6100 laptop
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sending an updated version of a trivial patch from last November which got no feedback on the list.
Applies cleanly against the latest input.git tree (and probably other recent trees).

Cheers,
Rikard

----

Add quirk for misbehaving volume buttons on HP Pavilion ZV6100 laptop which
are not sending keyrelease events, as reported by Aaron Pickett.

Signed-off-by: Rikard Ljungstrand <lrikard@student.chalmers.se>
---
 drivers/input/keyboard/atkbd.c |   16 +++++++++++++---
 1 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/input/keyboard/atkbd.c b/drivers/input/keyboard/atkbd.c
index 379b7ff..99e73a1 100644
--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -868,9 +868,10 @@ static void atkbd_hp_keymap_fixup(struct atkbd *atkbd)
 }
 
 /*
- * Inventec system with broken key release on volume keys
+ * Perform fixup for Inventec system and HP Pavilion ZV6100 laptop that don't
+ * generate release for their volume buttons
  */
-static void atkbd_inventec_keymap_fixup(struct atkbd *atkbd)
+static void atkbd_inventec_and_hp_zv6100_keymap_fixup(struct atkbd *atkbd)
 {
 	const unsigned int forced_release_keys[] = {
 		0xae, 0xb0,
@@ -1491,7 +1492,16 @@ static struct dmi_system_id atkbd_dmi_quirk_table[] __initdata = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "SYMPHONY 6.0/7.0"),
 		},
 		.callback = atkbd_setup_fixup,
-		.driver_data = atkbd_inventec_keymap_fixup,
+		.driver_data = atkbd_inventec_and_hp_zv6100_keymap_fixup,
+	},
+	{
+		.ident = "HP Pavilion ZV6100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Pavilion ZV6100"),
+		},
+		.callback = atkbd_setup_fixup,
+		.driver_data = atkbd_inventec_and_hp_zv6100_keymap_fixup,
 	},
 	{ }
 };
-- 
1.5.6.3
