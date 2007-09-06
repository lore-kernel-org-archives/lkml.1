Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbXIFWGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbXIFWGk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 18:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753859AbXIFWGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 18:06:33 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:20144 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807AbXIFWGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 18:06:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:x-authentication-warning:from:to:cc:subject:date:message-id:x-mailer;
        b=eaPHb/MbvTaLmTaaT9w9pD2/Ga2O0QZ1PbUsx6OI0JX9fB0vkFgDfFwb2lksHSq2xdFkt3Cpmu3xdFtQ5X/kMkTNHRoK2n+iRDAZkndPfUqryfkZLMsySr1lw6DKPuAdUy0goOAqaXdp/gCY7ZzmWTM5euuhewavDilACJl0FKo=
From: Vladimir Shebordaev <vladimir.shebordaev@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vladimir Shebordaev <vshebordaev@mail.ru>
Subject: [PATCH] [input] USB touchscreen
Date: Fri,  7 Sep 2007 02:03:47 +0400
Message-Id: <11891162271090-git-send-email-vladimir.shebordaev@gmail.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vladimir Shebordaev <vshebordaev@mail.ru>

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

