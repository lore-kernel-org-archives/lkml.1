Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515Ab0AWUgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0AWUgd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:36:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752360Ab0AWUg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:36:27 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50659 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab0AWUgW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:36:22 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Avuton Olrich <avuton@gmail.com>, Antonino Daplas <adaplas@gmail.com>
Subject: [PATCH 04/29] move cfag12864bfb's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:12 +0100
Message-Id: <1264278937-19675-4-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pointer to cfag12864bfb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Avuton Olrich <avuton@gmail.com>
Cc: Antonino Daplas <adaplas@gmail.com>
---
 drivers/auxdisplay/cfag12864bfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/auxdisplay/cfag12864bfb.c b/drivers/auxdisplay/cfag12864bfb.c
index fe3a865..b0ca5a4 100644
--- a/drivers/auxdisplay/cfag12864bfb.c
+++ b/drivers/auxdisplay/cfag12864bfb.c
@@ -81,7 +81,7 @@ static struct fb_ops cfag12864bfb_ops = {
 	.fb_mmap = cfag12864bfb_mmap,
 };
 
-static int __init cfag12864bfb_probe(struct platform_device *device)
+static int __devinit cfag12864bfb_probe(struct platform_device *device)
 {
 	int ret = -EINVAL;
  	struct fb_info *info = framebuffer_alloc(0, &device->dev);
-- 
1.6.6

