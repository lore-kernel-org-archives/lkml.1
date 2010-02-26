Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936134Ab0BZMWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:22:22 -0500
Received: from legolas.restena.lu ([158.64.1.34]:60007 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936141Ab0BZMVm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:21:42 -0500
Date: Fri, 26 Feb 2010 13:02:04 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Richard Purdie <rpurdie@linux.intel.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] backlight, appledisplay: fix incomplete registration
 failure handling
Message-ID: <20100226130204.5727ba6b@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
References: <20100221002831.689bace8@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On error while registering backlight, return it to caller instead of
returning 0.
Mark struct backlight_ops as const.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/usb/misc/appledisplay.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
index 1eb9e41..ef79ca2 100644
--- a/drivers/usb/misc/appledisplay.c
+++ b/drivers/usb/misc/appledisplay.c
@@ -179,7 +179,7 @@ static int appledisplay_bl_get_brightness(struct backlight_device *bd)
 		return pdata->msgdata[1];
 }
 
-static struct backlight_ops appledisplay_bl_data = {
+static const struct backlight_ops appledisplay_bl_data = {
 	.get_brightness	= appledisplay_bl_get_brightness,
 	.update_status	= appledisplay_bl_update_status,
 };
@@ -283,6 +283,7 @@ static int appledisplay_probe(struct usb_interface *iface,
 						&appledisplay_bl_data);
 	if (IS_ERR(pdata->bd)) {
 		dev_err(&iface->dev, "Backlight registration failed\n");
+		retval = PTR_ERR(pdata->bd);
 		goto error;
 	}
 
-- 
1.6.4.4

