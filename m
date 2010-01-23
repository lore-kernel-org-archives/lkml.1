Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438Ab0AWUmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab0AWUmU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:42:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433Ab0AWUfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:35:52 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50455 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab0AWUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:35:49 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Frans Pop <elendil@planet.nl>,
       Antonino Daplas <adaplas@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 27/29] move vfb's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:35 +0100
Message-Id: <1264278937-19675-27-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to vfb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Frans Pop <elendil@planet.nl>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/vfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/vfb.c b/drivers/video/vfb.c
index 050d432..b8ab995 100644
--- a/drivers/video/vfb.c
+++ b/drivers/video/vfb.c
@@ -479,7 +479,7 @@ static int __init vfb_setup(char *options)
      *  Initialisation
      */
 
-static int __init vfb_probe(struct platform_device *dev)
+static int __devinit vfb_probe(struct platform_device *dev)
 {
 	struct fb_info *info;
 	int retval = -ENOMEM;
-- 
1.6.6

