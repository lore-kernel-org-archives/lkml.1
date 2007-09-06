Return-Path: <linux-kernel-owner+w=401wt.eu-S932768AbXIFVcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbXIFVcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 17:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbXIFVcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 17:32:11 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:32832 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932334AbXIFVcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 17:32:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:cc:subject:date:message-id:x-mailer:from;
        b=WTfSL2GY0VHBbs9ttYhoDcrZLwJHJ2dESTYGI3XB4xksuMlDJnKS36tUosK6HCT0zqI41k801R5zJFU0uO+POy42uI6NfrxjEkG65juyxHlkqRGIGeYt+sDNP/+MJVRabaEVLCngnowfz1vZXCpDYtsJvVTmxmc4NDvguuycnPk=
To: Dmitry Torokhov <dtor@mail.ru>
Cc: dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org,
       Vladimir Shebordaev <vshebordaev@mail.ru>
Subject: [PATCH] [input] USB touchscreen
Date: Fri,  7 Sep 2007 01:29:27 +0400
Message-Id: <1189114167987-git-send-email-vshebordaev@mail.ru>
X-Mailer: git-send-email 1.5.2.2
From: Vladimir Shebordaev <vladimir.shebordaev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a nasty typo in usbtouchscreen driver.

The typo is inherited from the original mtouchusb. It
used to make the input subsytem to incorrectly
report the physical device ids to userspace that in turn
is much confusing for, e.g. XInput hotplug facilities in
setups with multiple identical touchscreens.

Signed-off-by: Vladimir Shebordaev <vshebordaev@mail.ru>
---
 drivers/input/touchscreen/usbtouchscreen.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/usbtouchscreen.c b/drivers/input/touchscreen/usbtouchscreen.c
index e3f2285..c32f447 100644
--- a/drivers/input/touchscreen/usbtouchscreen.c
+++ b/drivers/input/touchscreen/usbtouchscreen.c
@@ -734,7 +734,7 @@ static int usbtouch_probe(struct usb_interface *intf,
 			 le16_to_cpu(udev->descriptor.idProduct));
 
 	usb_make_path(udev, usbtouch->phys, sizeof(usbtouch->phys));
-	strlcpy(usbtouch->phys, "/input0", sizeof(usbtouch->phys));
+	strlcat(usbtouch->phys, "/input0", sizeof(usbtouch->phys));
 
 	input_dev->name = usbtouch->name;
 	input_dev->phys = usbtouch->phys;
-- 
1.5.2.2

