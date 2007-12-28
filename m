Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415AbXL1IWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbXL1IWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 03:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXL1IWX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 03:22:23 -0500
Received: from mu-out-0910.google.com ([209.85.134.184]:51947 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbXL1IWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 03:22:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SLn0NNc5FxXSyejlrs8D+gwqxljXnw8pRwmzCfc84ekFyZgmOi4H4NtO32MYY+PSNzqCbke1+UcGE5MKg/MqzXr0HznjgBc/HrrczYEi+xE5pbvIBUY6Q2UL23ZHds4r1IuNX2WjF+2M6mev4JZoefJ53H6cSqeNwK0wHN7cDqk=
Message-ID: <e7bd23c30712280022k342d200fm2cd4ec92ac67c972@mail.gmail.com>
Date: Fri, 28 Dec 2007 00:22:19 -0800
From: "Corbin Simpson" <mostawesomedude@gmail.com>
To: dmitry.torokhov@gmail.com
Subject: [PATCH] joystick: add Guitar Hero 2 controllers
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corbin Simpson <MostAwesomeDude@gmail.com>

Add USB IDs for the drumkit from Rock Band and the guitar from Guitar
Hero 2 to the
joystick driver for Xbox 360 controllers (drivers/input/joystick/xpad.c).

Signed-off-by: Corbin Simpson <MostAwesomeDude@gmail.com>

---

These are both wired USB devices for the Xbox 360. Both work
adequately as joysticks, although the Rock Band
kit is somewhat slow; maybe it could be sped up? Should apply cleanly
to 2.6.23. This is my first patch; am I doin'
it right?
~ C.


--- drivers/input/joystick/xpad.c.old	2007-12-25 10:38:08.000000000 -0800
+++ drivers/input/joystick/xpad.c	2007-12-28 00:03:00.000000000 -0800
@@ -9,6 +9,7 @@
  *               2005 Dominic Cerquetti <binary1230@yahoo.com>
  *               2006 Adam Buchbinder <adam.buchbinder@gmail.com>
  *               2007 Jan Kratochvil <honza@jikos.cz>
+ *               2007 Corbin Simpson <MostAwesomeDude@gmail.com>
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License as
@@ -134,8 +135,10 @@ static const struct xpad_device {
 	{ 0x0f30, 0x8888, "BigBen XBMiniPad Controller", MAP_DPAD_TO_AXES,
XTYPE_XBOX },
 	{ 0x102c, 0xff0c, "Joytech Wireless Advanced Controller",
MAP_DPAD_TO_AXES, XTYPE_XBOX },
 	{ 0x12ab, 0x8809, "Xbox DDR dancepad", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
+	{ 0x1430, 0x4748, "RedOctane Guitar Hero X-plorer",
MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1430, 0x8888, "TX6500+ Dance Pad (first generation)",
MAP_DPAD_TO_BUTTONS, XTYPE_XBOX },
 	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", MAP_DPAD_TO_AXES,
XTYPE_XBOX360 },
+	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS,
XTYPE_XBOX360 },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", MAP_DPAD_TO_AXES,
XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", MAP_DPAD_UNKNOWN, XTYPE_XBOX }
 };
@@ -178,6 +181,8 @@ static const signed short xpad_abs_pad[]
 static struct usb_device_id xpad_table [] = {
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* X-Box USB-IF not approved class */
 	{ USB_DEVICE_INTERFACE_PROTOCOL(0x045e, 0x028e, 1) },	/* X-Box 360
controller */
+	{ USB_DEVICE_INTERFACE_PROTOCOL(0x1430, 0x4748, 1) },	/* Guitar Hero
X-plorer */
+	{ USB_DEVICE_INTERFACE_PROTOCOL(0x1bad, 0x0003, 1) },	/* Rock Band Drums */
 	{ }
 };

-- 
Only fools are easily impressed by what is only
barely beyond their reach. ~ Unknown

Corbin Simpson
<MostAwesomeDude@gmail.com>
