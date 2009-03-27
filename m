Return-Path: <linux-kernel-owner+w=401wt.eu-S1763557AbZC0Xcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763557AbZC0Xcf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbZC0X1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48412 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759972AbZC0X1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:34 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Alessandro Zummo <a.zummo@towertech.it>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Paul Mundt <lethal@linux-sh.org>, Hannes Eder <hannes@hanneseder.net>,
       Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 51/58] move stk17ta8's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:12 +0100
Message-Id: <1238196439-16535-51-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to stk17ta8_rtc_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Hannes Eder <hannes@hanneseder.net>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/rtc/rtc-stk17ta8.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-stk17ta8.c b/drivers/rtc/rtc-stk17ta8.c
index 7d1547b..d491eb2 100644
--- a/drivers/rtc/rtc-stk17ta8.c
+++ b/drivers/rtc/rtc-stk17ta8.c
@@ -286,7 +286,7 @@ static struct bin_attribute stk17ta8_nvram_attr = {
 	.write = stk17ta8_nvram_write,
 };
 
-static int __init stk17ta8_rtc_probe(struct platform_device *pdev)
+static int __devinit stk17ta8_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 	struct resource *res;
-- 
1.6.2

