Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbZC0X1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbZC0X1g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752733AbZC0X1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48372 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbZC0X1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:22 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <rpurdie@linux.intel.com>,
       =?utf-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>
Subject: [PATCH 08/58] move leds-clevo-mail's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:29 +0100
Message-Id: <1238196439-16535-8-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to clevo_mail_led_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Richard Purdie <rpurdie@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Márton Németh <nm127@freemail.hu>
---
 drivers/leds/leds-clevo-mail.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-clevo-mail.c b/drivers/leds/leds-clevo-mail.c
index 1813c84..8ee83ce 100644
--- a/drivers/leds/leds-clevo-mail.c
+++ b/drivers/leds/leds-clevo-mail.c
@@ -145,7 +145,7 @@ static struct led_classdev clevo_mail_led = {
 	.flags			= LED_CORE_SUSPENDRESUME,
 };
 
-static int __init clevo_mail_led_probe(struct platform_device *pdev)
+static int __devinit clevo_mail_led_probe(struct platform_device *pdev)
 {
 	return led_classdev_register(&pdev->dev, &clevo_mail_led);
 }
-- 
1.6.2

