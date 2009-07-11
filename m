Return-Path: <linux-kernel-owner+w=401wt.eu-S1759284AbZGKVEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759284AbZGKVEI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 17:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbZGKUyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:54:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33126 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbZGKUyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:54:15 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Ben Dooks <ben-linux@fluff.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] move h1940-bt's probe function to .devinit.text
Date: Sat, 11 Jul 2009 22:52:41 +0200
Message-Id: <1247345591-22643-13-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247345591-22643-12-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090711170548.GC5205@suse.de>
 <1247345591-22643-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-7-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-8-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-9-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-10-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-11-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-12-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to h1940bt_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/mach-s3c2410/h1940-bluetooth.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-s3c2410/h1940-bluetooth.c b/arch/arm/mach-s3c2410/h1940-bluetooth.c
index 5aabf11..194c2eb 100644
--- a/arch/arm/mach-s3c2410/h1940-bluetooth.c
+++ b/arch/arm/mach-s3c2410/h1940-bluetooth.c
@@ -86,7 +86,7 @@ static DEVICE_ATTR(enable, 0644,
 		h1940bt_show,
 		h1940bt_store);
 
-static int __init h1940bt_probe(struct platform_device *pdev)
+static int __devinit h1940bt_probe(struct platform_device *pdev)
 {
 	/* Configures BT serial port GPIOs */
 	s3c2410_gpio_cfgpin(S3C2410_GPH(0), S3C2410_GPH0_nCTS0);
-- 
1.6.3.1

