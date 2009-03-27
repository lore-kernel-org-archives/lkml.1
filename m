Return-Path: <linux-kernel-owner+w=401wt.eu-S1764091AbZC0Xhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764091AbZC0Xhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761353AbZC0X1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48477 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761338AbZC0X1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:41 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@gmail.com>, Adrian Bunk <bunk@stusta.de>,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH 45/58] move sgivwfb's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:06 +0100
Message-Id: <1238196439-16535-45-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to sgivwfb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/video/sgivwfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/sgivwfb.c b/drivers/video/sgivwfb.c
index f5252c2..ffe4273 100644
--- a/drivers/video/sgivwfb.c
+++ b/drivers/video/sgivwfb.c
@@ -745,7 +745,7 @@ int __init sgivwfb_setup(char *options)
 /*
  *  Initialisation
  */
-static int __init sgivwfb_probe(struct platform_device *dev)
+static int __devinit sgivwfb_probe(struct platform_device *dev)
 {
 	struct sgivw_par *par;
 	struct fb_info *info;
-- 
1.6.2

