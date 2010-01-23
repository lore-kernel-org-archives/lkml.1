Return-Path: <linux-kernel-owner+w=401wt.eu-S1750732Ab0AWUia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750732Ab0AWUia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513Ab0AWUh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:37:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50597 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab0AWUgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:36:05 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>,
       Ian Molton <spyro@f2s.com>, Richard Purdie <rpurdie@rpsys.net>,
       Antonino Daplas <adaplas@gmail.com>,
       Alberto Mardegan <mardy@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 29/29] move w100fb's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:37 +0100
Message-Id: <1264278937-19675-29-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to w100fb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Ian Molton <spyro@f2s.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Alberto Mardegan <mardy@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/w100fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/w100fb.c b/drivers/video/w100fb.c
index 2376f68..5d22395 100644
--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -628,7 +628,7 @@ static int w100fb_resume(struct platform_device *dev)
 #endif
 
 
-int __init w100fb_probe(struct platform_device *pdev)
+int __devinit w100fb_probe(struct platform_device *pdev)
 {
 	int err = -EIO;
 	struct w100fb_mach_info *inf;
-- 
1.6.6

