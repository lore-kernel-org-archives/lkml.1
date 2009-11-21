Return-Path: <linux-kernel-owner+w=401wt.eu-S1751336AbZKUIEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbZKUIEy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 03:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751126AbZKUIEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 03:04:53 -0500
Received: from mail01a.mail.t-online.hu ([84.2.40.6]:61952 "EHLO
	mail01a.mail.t-online.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZKUIEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 03:04:53 -0500
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Nov 2009 03:04:53 EST
Message-ID: <4B079CE0.60604@freemail.hu>
Date: Sat, 21 Nov 2009 08:55:12 +0100
From: =?UTF-8?B?TsOpbWV0aCBNw6FydG9u?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] do not overwrite the first part of phys string
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-DCC-mail.t-online.hu-Metrics: mail01a.mail.t-online.hu 32721; Body=3 Fuz1=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Márton Németh <nm127@freemail.hu>

Use strlcat() to append a string to the previously created first part.

Signed-off-by: Márton Németh <nm127@freemail.hu>
---
diff -upr linux-2.6.32-rc7.orig/drivers/hid/usbhid/usbkbd.c linux-2.6.32-rc7/drivers/hid/usbhid/usbkbd.c
--- linux-2.6.32-rc7.orig/drivers/hid/usbhid/usbkbd.c	2009-09-10 00:13:59.000000000 +0200
+++ linux-2.6.32-rc7/drivers/hid/usbhid/usbkbd.c	2009-11-21 08:48:32.000000000 +0100
@@ -266,7 +266,7 @@ static int usb_kbd_probe(struct usb_inte
 			 le16_to_cpu(dev->descriptor.idProduct));

 	usb_make_path(dev, kbd->phys, sizeof(kbd->phys));
-	strlcpy(kbd->phys, "/input0", sizeof(kbd->phys));
+	strlcat(kbd->phys, "/input0", sizeof(kbd->phys));

 	input_dev->name = kbd->name;
 	input_dev->phys = kbd->phys;
diff -upr linux-2.6.32-rc7.orig/drivers/input/misc/ati_remote.c linux-2.6.32-rc7/drivers/input/misc/ati_remote.c
--- linux-2.6.32-rc7.orig/drivers/input/misc/ati_remote.c	2009-09-10 00:13:59.000000000 +0200
+++ linux-2.6.32-rc7/drivers/input/misc/ati_remote.c	2009-11-21 08:48:50.000000000 +0100
@@ -766,7 +766,7 @@ static int ati_remote_probe(struct usb_i
 	ati_remote->interface = interface;

 	usb_make_path(udev, ati_remote->phys, sizeof(ati_remote->phys));
-	strlcpy(ati_remote->phys, "/input0", sizeof(ati_remote->phys));
+	strlcat(ati_remote->phys, "/input0", sizeof(ati_remote->phys));

 	if (udev->manufacturer)
 		strlcpy(ati_remote->name, udev->manufacturer, sizeof(ati_remote->name));
diff -upr linux-2.6.32-rc7.orig/drivers/input/misc/powermate.c linux-2.6.32-rc7/drivers/input/misc/powermate.c
--- linux-2.6.32-rc7.orig/drivers/input/misc/powermate.c	2009-09-10 00:13:59.000000000 +0200
+++ linux-2.6.32-rc7/drivers/input/misc/powermate.c	2009-11-21 08:48:44.000000000 +0100
@@ -338,7 +338,7 @@ static int powermate_probe(struct usb_in
 	pm->input = input_dev;

 	usb_make_path(udev, pm->phys, sizeof(pm->phys));
-	strlcpy(pm->phys, "/input0", sizeof(pm->phys));
+	strlcat(pm->phys, "/input0", sizeof(pm->phys));

 	spin_lock_init(&pm->lock);

