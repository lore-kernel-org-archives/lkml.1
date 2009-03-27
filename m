Return-Path: <linux-kernel-owner+w=401wt.eu-S1763501AbZC0Xbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763501AbZC0Xbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761104AbZC0X1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48403 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473AbZC0X1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:33 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Philipp Zabel <philipp.zabel@gmail.com>, Ian Molton <spyro@f2s.com>,
       Richard Purdie <rpurdie@rpsys.net>, Antonino Daplas <adaplas@gmail.com>,
       Alberto Mardegan <mardy@users.sourceforge.net>
Subject: [PATCH 57/58] move w100fb's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:18 +0100
Message-Id: <1238196439-16535-57-git-send-email-u.kleine-koenig@pengutronix.de>
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
index d0674f1..c966b12 100644
--- a/drivers/video/w100fb.c
+++ b/drivers/video/w100fb.c
@@ -626,7 +626,7 @@ static int w100fb_resume(struct platform_device *dev)
 #endif
 
 
-int __init w100fb_probe(struct platform_device *pdev)
+int __devinit w100fb_probe(struct platform_device *pdev)
 {
 	int err = -EIO;
 	struct w100fb_mach_info *inf;
-- 
1.6.2

