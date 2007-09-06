Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXIFWRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXIFWRW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 18:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbXIFWQ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 18:16:59 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:27036 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576AbXIFWQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 18:16:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=rkDKW54naC7YRYnqL8fkSkfeWCRD07URc0b0g/wprP3ux83Sa6wrB/ZG9P9mwdLjZzkqzfC0Cq1D70QdsQYJRxjljbLN6iMtdhfw++669uwgkUsq+6Aan+xBk+k+8H6/QyK+sj11gDmyvQPB0qF95nOU5or/cYW1m9KvgBTASSQ=
From: Vladimir Shebordaev <vladimir.shebordaev@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Vladimir Shebordaev <vshebordaev@mail.ru>
Subject: [PATCH] [input] USB touchscreen
Date: Fri,  7 Sep 2007 02:14:14 +0400
Message-Id: <1189116854924-git-send-email-vladimir.shebordaev@gmail.com>
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

Signed-off-by: Vladimir Shebordaev <vladimir.shebordaev@gmail.com>
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

