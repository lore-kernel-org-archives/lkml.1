Return-Path: <linux-kernel-owner+w=401wt.eu-S1764358AbZC0XnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764358AbZC0XnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762314AbZC0X2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48517 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761674AbZC0X1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:42 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Akinobu Mita <akinobu.mita@gmail.com>,
       Richard Purdie <rpurdie@linux.intel.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Kristoffer Ericson <Kristoffer.Ericson@gmail.com>,
       Andriy Skulysh <askulysh@gmail.com>, Antonino Daplas <adaplas@pol.net>
Subject: [PATCH 20/58] move hp680-bl's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:41 +0100
Message-Id: <1238196439-16535-20-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to hp680bl_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andriy Skulysh <askulysh@gmail.com>
Cc: Antonino Daplas <adaplas@pol.net>
---
 drivers/video/backlight/hp680_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/hp680_bl.c b/drivers/video/backlight/hp680_bl.c
index 5be55a2..7fb4eef 100644
--- a/drivers/video/backlight/hp680_bl.c
+++ b/drivers/video/backlight/hp680_bl.c
@@ -103,7 +103,7 @@ static struct backlight_ops hp680bl_ops = {
 	.update_status  = hp680bl_set_intensity,
 };
 
-static int __init hp680bl_probe(struct platform_device *pdev)
+static int __devinit hp680bl_probe(struct platform_device *pdev)
 {
 	struct backlight_device *bd;
 
-- 
1.6.2

