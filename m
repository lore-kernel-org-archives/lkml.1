Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbYIICUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbYIICUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 22:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYIICUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 22:20:06 -0400
Received: from bee.hiwaay.net ([216.180.54.11]:54152 "EHLO bee.hiwaay.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbYIICUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 22:20:05 -0400
Date: Mon, 8 Sep 2008 21:20:00 -0500
From: Chris Adams <cmadams@hiwaay.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ti_usb_3410_5052 obviously broken by firmware changes
Message-ID: <20080909021959.GD1243254@hiwaay.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Adams <cmadams@hiwaay.net>

While making some other changes to ti_usb_3410_5052, I noticed that the
changes made to move the firmware loading to a separate function are
broken (in ti_download_firmware(), status is set to -ENOMEM and never
changed).  This means the driver will never initialize the device
properly.  It looks like status was supposed to get the result of
ti_do_download().

Signed-off-by: Chris Adams <cmadams@hiwaay.net>
---
It doesn't look like there's a maintainer for this driver other than TI
(which has no email listed).  Should changes for this go to linux-usb,
here, or what?


diff -urpN linux-2.6.27-rc5-git9-vanilla/drivers/usb/serial/ti_usb_3410_5052.c linux-2.6.27-rc5-git9/drivers/usb/serial/ti_usb_3410_5052.c
--- linux-2.6.27-rc5-git9-vanilla/drivers/usb/serial/ti_usb_3410_5052.c	2008-09-08 20:57:56.000000000 -0500
+++ linux-2.6.27-rc5-git9/drivers/usb/serial/ti_usb_3410_5052.c	2008-09-08 21:02:13.000000000 -0500
@@ -1744,7 +1744,7 @@ static int ti_download_firmware(struct t
 	if (buffer) {
 		memcpy(buffer, fw_p->data, fw_p->size);
 		memset(buffer + fw_p->size, 0xff, buffer_size - fw_p->size);
-		ti_do_download(dev, pipe, buffer, fw_p->size);
+		status = ti_do_download(dev, pipe, buffer, fw_p->size);
 		kfree(buffer);
 	}
 	release_firmware(fw_p);

