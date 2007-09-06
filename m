Return-Path: <linux-kernel-owner+w=401wt.eu-S932886AbXIFWEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932886AbXIFWEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 18:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932532AbXIFWD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 18:03:56 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:59217 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbXIFWDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 18:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:x-authentication-warning:to:subject:date:message-id:x-mailer:from;
        b=YGeSdoplOgAxN/R1wz0jRoTQZ9pRtpYRKB62B2eAYiQaGYKnMvRewEFl0nGjEWXdZIZLLB5LAxdIBbjEKgVdxy1nOUTyv0hXoDZsYRIqEgJyt0dzbUjVq0UgtOl9wsBlSHM6BbKIhWBoh/T5HFl8OWQPl9LKkpez8Jp4lMSGP94=
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [input] USB touchscreen
Date: Fri,  7 Sep 2007 02:01:12 +0400
Message-Id: <11891160724048-git-send-email-vshebordaev@mail.ru>
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

