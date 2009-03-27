Return-Path: <linux-kernel-owner+w=401wt.eu-S1763439AbZC0Xau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763439AbZC0Xau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760150AbZC0X1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48396 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759578AbZC0X1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:33 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>, Richard Purdie <rpurdie@rpsys.net>,
       =?utf-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>,
       Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: [PATCH 17/58] move h1940-leds's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:38 +0100
Message-Id: <1238196439-16535-17-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to h1940leds_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Márton Németh <nm127@freemail.hu>
Cc: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/leds/leds-h1940.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-h1940.c b/drivers/leds/leds-h1940.c
index 11b77a7..1aa46a3 100644
--- a/drivers/leds/leds-h1940.c
+++ b/drivers/leds/leds-h1940.c
@@ -104,7 +104,7 @@ static struct led_classdev h1940_blueled = {
 	.default_trigger	= "h1940-bluetooth",
 };
 
-static int __init h1940leds_probe(struct platform_device *pdev)
+static int __devinit h1940leds_probe(struct platform_device *pdev)
 {
 	int ret;
 
-- 
1.6.2

