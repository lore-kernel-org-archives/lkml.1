Return-Path: <linux-kernel-owner+w=401wt.eu-S1751898Ab0AWUfz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab0AWUfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:35:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294Ab0AWUfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:35:51 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50451 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932161Ab0AWUft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:35:49 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Andriy Skulysh <askulysh@gmail.com>, Antonino Daplas <adaplas@pol.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 12/29] move hitfb's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:20 +0100
Message-Id: <1264278937-19675-12-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to hitfb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Andriy Skulysh <askulysh@gmail.com>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/hitfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/hitfb.c b/drivers/video/hitfb.c
index 73c83a8..bf78779 100644
--- a/drivers/video/hitfb.c
+++ b/drivers/video/hitfb.c
@@ -325,7 +325,7 @@ static struct fb_ops hitfb_ops = {
 	.fb_imageblit	= cfb_imageblit,
 };
 
-static int __init hitfb_probe(struct platform_device *dev)
+static int __devinit hitfb_probe(struct platform_device *dev)
 {
 	unsigned short lcdclor, ldr3, ldvndr;
 	struct fb_info *info;
-- 
1.6.6

