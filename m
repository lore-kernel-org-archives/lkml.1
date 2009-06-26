Return-Path: <linux-kernel-owner+w=401wt.eu-S1760668AbZFZOpm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760668AbZFZOpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:45:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757652AbZFZOpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:45:36 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:40213 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222AbZFZOpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:45:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=T8YSbYfdQGUWqkzC98wBf0LaVk0RGUAC+Cb9h19DAt8jF3pp0oE/4pTXrn3ztzMAHK
         MakE6HpmrBajvd7AJgtpcmnPcRQUQbfQdssxt4ulQ8BHMifO+b4y5eQSJIAq6/MB8vgR
         oCPLB4MKccSO3E3mLPvJJxrmxBNV9WmiBKvMg=
Date: Fri, 26 Jun 2009 16:44:20 +0200 (CEST)
From: "rubenatch@gmail.com" <rubenatch@gmail.com>
X-X-Sender: root@localhost
To: jkosina@suse.cz
cc: linux-kernel@vger.kernel.org
Subject: [PATCHv2] Adding rumble support to Thrustmaster Dual Trigger 3-in-1
 devices
Message-ID: <alpine.DEB.2.00.0906261639570.17888@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2063028922-1246027534=:17888"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2063028922-1246027534=:17888
Content-Type: TEXT/PLAIN; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT


From: Rubén Aós Garralda <rubenatch@gmail.com>

This patch enables rumble in Thrustmaster Dual 3-in-1 trigger gamepads (in
both PC and PS3 modes). It uses the same code as Thrustmaster FireStorm 
Dual Power 2/3, so it only modifies hid-core.c (to put the devices in the 
"forbidden list" and hid-tmff.c to add the new USB IDs.

---

Latest patch was BAAAAAD (it had a missing end of comment), please 
discard. New patch:

diff -uprN linux-source-2.6.30/drivers/hid/hid-core.c linux-source-test/drivers/hid/hid-core.c
--- linux-source-2.6.30/drivers/hid/hid-core.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-source-test/drivers/hid/hid-core.c	2009-06-26 15:33:48.000000000 +0200
@@ -1309,6 +1309,8 @@ static const struct hid_device_id hid_bl
  	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323) },
+       	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED, USB_DEVICE_ID_TOPSEED_CYBERLINK) },
diff -uprN linux-source-2.6.30/drivers/hid/hid-tmff.c linux-source-test/drivers/hid/hid-tmff.c
--- linux-source-2.6.30/drivers/hid/hid-tmff.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-source-test/drivers/hid/hid-tmff.c	2009-06-26 15:35:27.000000000 +0200
@@ -236,7 +236,11 @@ err:
  static const struct hid_device_id tm_devices[] = {
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300),
  		.driver_data = (unsigned long)ff_rumble },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304),
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304),	/* FireStorm Dual Power 2 (and 3) */
+		.driver_data = (unsigned long)ff_rumble },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323),	/* Dual Trigger 3-in-1 (PC Mode) */
+		.driver_data = (unsigned long)ff_rumble },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324),	/* Dual Trigger 3-in-1 (PS3 Mode) */
  		.driver_data = (unsigned long)ff_rumble },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651),	/* FGT Rumble Force Wheel */
  		.driver_data = (unsigned long)ff_rumble },
diff -uprN linux-source-2.6.30/drivers/hid/Kconfig linux-source-test/drivers/hid/Kconfig
--- linux-source-2.6.30/drivers/hid/Kconfig	2009-06-10 05:05:27.000000000 +0200
+++ linux-source-test/drivers/hid/Kconfig	2009-06-26 15:58:15.000000000 +0200
@@ -268,8 +268,9 @@ config THRUSTMASTER_FF
  	depends on USB_HID
  	select INPUT_FF_MEMLESS
  	help
-	  Say Y here if you have a THRUSTMASTER FireStore Dual Power 2 or
-	  a THRUSTMASTER Ferrari GT Rumble Force or Force Feedback Wheel.
+	  Say Y here if you have a THRUSTMASTER FireStore Dual Power 2 or 3,
+	  a THRUSTMASTER Dual Trigger 3-in-1 or a THRUSTMASTER Ferrari GT
+	  Rumble Force or Force Feedback Wheel.

  config ZEROPLUS_FF
  	tristate "Zeroplus based game controller support"
--8323328-2063028922-1246027534=:17888--
