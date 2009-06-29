Return-Path: <linux-kernel-owner+w=401wt.eu-S1756002AbZF2HeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002AbZF2HeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445AbZF2Hdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:33:54 -0400
Received: from ey-out-1920.google.com ([74.125.78.147]:32099 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbZF2Hdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:33:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=lJyJOuNf64zNXTfRzDL3WCQiJQ7Xw0fslHETQCLWjsheY3n0gF/odx6YyJg8vBcxDX
         IaG8ygTOgRAVtl5oWZzBvuF067q31OiSKrvw/dB01HGPplpoq/teTyoGq1/M8jIvuqNa
         EY5l/3YbVbZNOTpcPZlaPIncwPJSPII9iV7NM=
Date: Mon, 29 Jun 2009 09:33:40 +0200 (CEST)
From: "=?ISO-8859-15?Q?Rub=E9n_A=F3s_Garralda_=3Crubenatch=40gmail=2Ecom=3E?=" 
	<rubenatch@gmail.com>
X-X-Sender: root@localhost
To: jkosina@suse.cz
cc: linux-kernel@vger.kernel.org
Subject: [PATCHv3] Adding rumble support to Thrustmaster Dual Trigger
 3-in-1
Message-ID: <alpine.DEB.2.00.0906290926140.9132@localhost>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-368403849-1246260836=:9132"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-368403849-1246260836=:9132
Content-Type: TEXT/PLAIN; format=flowed; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

From: Rubén Aós Garralda <rubenatch@gmail.com>

This patch enables rumble in Thrustmaster Dual 3-in-1 trigger gamepads (in 
both PC and PS3 modes). It uses the same code as Thrustmaster FireStorm 
Dual Power 2, so it only adds new USB IDs to hid-core.c and hid-tmff.c

Signed-off-by: Rubén Aós Garralda <rubenatch@gmail.com>

---

Hope it is OK this time...

diff -uprN linux-source-2.6.30/drivers/hid/hid-core.c linux-source-test/drivers/hid/hid-core.c
--- linux-source-2.6.30/drivers/hid/hid-core.c	2009-06-10 05:05:27.000000000 +0200
+++ linux-source-test/drivers/hid/hid-core.c	2009-06-26 15:33:48.000000000 +0200
@@ -1309,6 +1309,8 @@ static const struct hid_device_id hid_bl
  	{ HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS, USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324) },
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
+	  Say Y here if you have a THRUSTMASTER FireStorm Dual Power 2 or 3,
+	  a THRUSTMASTER Dual Trigger 3-in-1 or a THRUSTMASTER Ferrari GT
+	  Rumble Force or Force Feedback Wheel.

  config ZEROPLUS_FF
  	tristate "Zeroplus based game controller support"
--8323328-368403849-1246260836=:9132--
