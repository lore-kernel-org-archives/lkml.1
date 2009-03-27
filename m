Return-Path: <linux-kernel-owner+w=401wt.eu-S1764574AbZC0Xoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764574AbZC0Xoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760015AbZC0X2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:11 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48502 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758915AbZC0X1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:42 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Antonino Daplas <adaplas@pol.net>,
       Vincent Sanders <vince@simtec.co.uk>
Subject: [PATCH 40/58] move s3c241xfb's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:01 +0100
Message-Id: <1238196439-16535-40-git-send-email-u.kleine-koenig@pengutronix.de>
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

Pointers to s3c2410fb_probe and s3c2412fb_probe are passed to the core
via platform_driver_register and so the functions must not disappear
when the .init sections are discarded.  Otherwise (if also having
HOTPLUG=y) unbinding and binding a device to one of the drivers via
sysfs will result in an oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Vincent Sanders <vince@simtec.co.uk>
---
 drivers/video/s3c2410fb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/s3c2410fb.c b/drivers/video/s3c2410fb.c
index 79cf0b1..0ccad2c 100644
--- a/drivers/video/s3c2410fb.c
+++ b/drivers/video/s3c2410fb.c
@@ -940,12 +940,12 @@ dealloc_fb:
 	return ret;
 }
 
-static int __init s3c2410fb_probe(struct platform_device *pdev)
+static int __devinit s3c2410fb_probe(struct platform_device *pdev)
 {
 	return s3c24xxfb_probe(pdev, DRV_S3C2410);
 }
 
-static int __init s3c2412fb_probe(struct platform_device *pdev)
+static int __devinit s3c2412fb_probe(struct platform_device *pdev)
 {
 	return s3c24xxfb_probe(pdev, DRV_S3C2412);
 }
-- 
1.6.2

