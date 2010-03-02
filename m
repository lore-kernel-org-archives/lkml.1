Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0CBXxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:53:10 -0500
Received: from kroah.org ([198.145.64.141]:38644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab0CBX3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:34 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Avuton Olrich <avuton@gmail.com>, Antonino Daplas <adaplas@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/62] auxdisplay: move cfag12864bfb's probe function to .devinit.text
Date: Tue,  2 Mar 2010 15:28:35 -0800
Message-Id: <1267572541-410-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.0.1

