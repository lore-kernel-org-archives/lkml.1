Return-Path: <linux-kernel-owner+w=401wt.eu-S1759069AbZC0X2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069AbZC0X2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755787AbZC0X1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:31 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48385 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758352AbZC0X1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:31 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Ben Dooks <ben-linux@fluff.org>
Subject: [PATCH 16/58] move h1940-bt's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:37 +0100
Message-Id: <1238196439-16535-16-git-send-email-u.kleine-koenig@pengutronix.de>
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
index 5a6bc56..6810f9c 100644
--- a/arch/arm/mach-s3c2410/h1940-bluetooth.c
+++ b/arch/arm/mach-s3c2410/h1940-bluetooth.c
@@ -84,7 +84,7 @@ static DEVICE_ATTR(enable, 0644,
 		h1940bt_show,
 		h1940bt_store);
 
-static int __init h1940bt_probe(struct platform_device *pdev)
+static int __devinit h1940bt_probe(struct platform_device *pdev)
 {
 	/* Configures BT serial port GPIOs */
 	s3c2410_gpio_cfgpin(S3C2410_GPH0, S3C2410_GPH0_nCTS0);
-- 
1.6.2

