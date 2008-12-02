Return-Path: <linux-kernel-owner+w=401wt.eu-S1756613AbYLBTdo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756613AbYLBTdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:33:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755573AbYLBTbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:31:39 -0500
Received: from bungle.evilgeniuses.org.uk ([195.10.223.155]:1544 "EHLO
	bungle.evilgeniuses.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754484AbYLBTbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:31:34 -0500
Subject: [PATCH] [uvc] The button on the camera is KEY_CAMERA
From: Bastien Nocera <hadess@hadess.net>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-bPYNWSZjO6lToD5AODxx"
Date: Tue, 02 Dec 2008 19:11:40 +0000
Message-Id: <1228245100.8307.1463.camel@cookie.hadess.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bPYNWSZjO6lToD5AODxx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

2 small bug fixes for the input part of the UVC driver.

Please keep me CC:ed as I'm not subscribed to LKML.

Cheers

--=-bPYNWSZjO6lToD5AODxx
Content-Disposition: attachment; filename="0001--uvc-The-button-on-the-camera-is-KEY_CAMERA.patch"
Content-Type: text/x-patch; name="0001--uvc-The-button-on-the-camera-is-KEY_CAMERA.patch"; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

>From df4dfe7370c71647e89acd2db22c46c10ca8faea Mon Sep 17 00:00:00 2001
From: Bastien Nocera <hadess@hadess.net>
Date: Tue, 2 Dec 2008 19:08:59 +0000
Subject: [PATCH] [uvc] The button on the camera is KEY_CAMERA

Not BTN_0. Also call input_sync() on the device once the button
has been pressed.
---
 drivers/media/video/uvc/uvc_status.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/video/uvc/uvc_status.c b/drivers/media/video/uvc/uvc_status.c
index 5d60b26..ca93245 100644
--- a/drivers/media/video/uvc/uvc_status.c
+++ b/drivers/media/video/uvc/uvc_status.c
@@ -48,7 +48,7 @@ static int uvc_input_init(struct uvc_device *dev)
 	input->dev.parent = &dev->intf->dev;
 
 	set_bit(EV_KEY, input->evbit);
-	set_bit(BTN_0, input->keybit);
+	set_bit(KEY_CAMERA, input->keybit);
 
 	if ((ret = input_register_device(input)) < 0)
 		goto error;
@@ -71,8 +71,10 @@ static void uvc_input_cleanup(struct uvc_device *dev)
 static void uvc_input_report_key(struct uvc_device *dev, unsigned int code,
 	int value)
 {
-	if (dev->input)
+	if (dev->input) {
 		input_report_key(dev->input, code, value);
+		input_sync(dev->input);
+	}
 }
 
 #else
@@ -97,7 +99,7 @@ static void uvc_event_streaming(struct uvc_device *dev, __u8 *data, int len)
 			return;
 		uvc_trace(UVC_TRACE_STATUS, "Button (intf %u) %s len %d\n",
 			data[1], data[3] ? "pressed" : "released", len);
-		uvc_input_report_key(dev, BTN_0, data[3]);
+		uvc_input_report_key(dev, KEY_CAMERA, data[3]);
 	} else {
 		uvc_trace(UVC_TRACE_STATUS, "Stream %u error event %02x %02x "
 			"len %d.\n", data[1], data[2], data[3], len);
-- 
1.6.0.4


--=-bPYNWSZjO6lToD5AODxx--

