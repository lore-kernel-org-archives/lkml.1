Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758340Ab0BDRZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:25:47 -0500
Received: from kroah.org ([198.145.64.141]:34952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933369Ab0BDRW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:22:29 -0500
X-Mailbox-Line: From linux@linux.site Thu Feb  4 09:15:25 2010
Message-Id: <20100204171525.493312894@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 04 Feb 2010 09:12:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       =?ISO-8859-15?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [66/74] imxfb: correct location of callbacks in suspend and resume
In-Reply-To: <20100204171850.GA16539@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Uwe Kleine-König  <u.kleine-koenig@pengutronix.de>

commit 1ec562035ba64e724652cb12b8a770b3906e9bf5 upstream.

The probe function passes a pointer to a struct fb_info to
platform_set_drvdata(), so don't interpret the return value of
platform_get_drvdata() as a pointer to struct imxfb_info.

The original imxfb_info *fbi backlight_power was NULL but in imxfb_suspend
it was 4 resulting in an oops as imxfb_suspend calls
imxfb_disable_controller(fbi) which in turn has

	if (fbi->backlight_power)
			fbi->backlight_power(0);

Signed-off-by: Uwe Kleine-König  <u.kleine-koenig@pengutronix.de>
Acked-by: Sascha Hauer <kernel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/video/imxfb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/video/imxfb.c
+++ b/drivers/video/imxfb.c
@@ -593,7 +593,8 @@ static int imxfb_activate_var(struct fb_
  */
 static int imxfb_suspend(struct platform_device *dev, pm_message_t state)
 {
-	struct imxfb_info *fbi = platform_get_drvdata(dev);
+	struct fb_info *info = platform_get_drvdata(dev);
+	struct imxfb_info *fbi = info->par;
 
 	pr_debug("%s\n", __func__);
 
@@ -603,7 +604,8 @@ static int imxfb_suspend(struct platform
 
 static int imxfb_resume(struct platform_device *dev)
 {
-	struct imxfb_info *fbi = platform_get_drvdata(dev);
+	struct fb_info *info = platform_get_drvdata(dev);
+	struct imxfb_info *fbi = info->par;
 
 	pr_debug("%s\n", __func__);
 


