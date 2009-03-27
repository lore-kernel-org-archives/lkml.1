Return-Path: <linux-kernel-owner+w=401wt.eu-S1764754AbZC0Xrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764754AbZC0Xrv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762309AbZC0X2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48473 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758491AbZC0X1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:41 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Roel Kluin <12o3l@tiscali.nl>,
       Antonino Daplas <adaplas@pol.net>
Subject: [PATCH 56/58] move vga16fb's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:17 +0100
Message-Id: <1238196439-16535-56-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.2
In-Reply-To: <20090327232153.GA16348@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pointer to vga16fb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/vga16fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/vga16fb.c b/drivers/video/vga16fb.c
index 5b29389..76d8dae 100644
--- a/drivers/video/vga16fb.c
+++ b/drivers/video/vga16fb.c
@@ -1293,7 +1293,7 @@ static int vga16fb_setup(char *options)
 }
 #endif
 
-static int __init vga16fb_probe(struct platform_device *dev)
+static int __devinit vga16fb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	struct vga16fb_par *par;
-- 
1.6.2

