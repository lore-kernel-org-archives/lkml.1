Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZGMJMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZGMJMt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 05:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZGMJMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 05:12:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55952 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754877AbZGMJMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 05:12:47 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: =?utf-8?q?M=C3=A1rton=20N=C3=A9meth?= <nm127@freemail.hu>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] don't add clevo_mail_led_driver's probe function to the driver struct
Date: Mon, 13 Jul 2009 11:12:37 +0200
Message-Id: <1247476357-24920-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <20090712204803.GA27454@pengutronix.de>
References: <20090712204803.GA27454@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clevo_mail_led_driver is registered using platform_driver_probe which
takes care for the probe function itself.  So don't pass it in the
driver struct, too.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Márton Németh <nm127@freemail.hu>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
Hello,

I'm a bit uncertain if this patch is really useful.  There is no
difference in runtime behaviour because platform_driver_probe just
overwrites the .probe member.  Nevertheless it's a section violation
that hurts my eye and triggers a false positive for my script that finds
drivers using probe functions in .init.text and
platform_driver_register.

Care?  Don't care?

Best regards
Uwe

 drivers/leds/leds-clevo-mail.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-clevo-mail.c b/drivers/leds/leds-clevo-mail.c
index 1813c84..5b36ae2 100644
--- a/drivers/leds/leds-clevo-mail.c
+++ b/drivers/leds/leds-clevo-mail.c
@@ -157,7 +157,6 @@ static int clevo_mail_led_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver clevo_mail_led_driver = {
-	.probe		= clevo_mail_led_probe,
 	.remove		= clevo_mail_led_remove,
 	.driver		= {
 		.name		= KBUILD_MODNAME,
-- 
tg: (7638d53..) t/noprobecbforplatformdriverprobe/clevo_mail_led_driver (depends on: linus/master)
