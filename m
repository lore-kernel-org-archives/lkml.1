Return-Path: <linux-kernel-owner+w=401wt.eu-S1753025Ab0AWUl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab0AWUl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551Ab0AWUfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:35:53 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50454 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932165Ab0AWUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:35:49 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
       Roel Kluin <12o3l@tiscali.nl>, Antonino Daplas <adaplas@pol.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 28/29] move vga16fb's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:36 +0100
Message-Id: <1264278937-19675-28-git-send-email-u.kleine-koenig@pengutronix.de>
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
1.6.6

