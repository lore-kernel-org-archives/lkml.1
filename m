Return-Path: <linux-kernel-owner+w=401wt.eu-S1763208AbZC0XbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763208AbZC0XbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:31:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbZC0X1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48400 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909AbZC0X1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:33 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andrew Victor <linux@maxim.org.za>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       Wim Van Sebroeck <wim@iguana.be>
Subject: [PATCH 05/58] move at91_wdt's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:26 +0100
Message-Id: <1238196439-16535-5-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to at91wdt_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/watchdog/at91rm9200_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/at91rm9200_wdt.c b/drivers/watchdog/at91rm9200_wdt.c
index e35d545..ee82323 100644
--- a/drivers/watchdog/at91rm9200_wdt.c
+++ b/drivers/watchdog/at91rm9200_wdt.c
@@ -197,7 +197,7 @@ static struct miscdevice at91wdt_miscdev = {
 	.fops		= &at91wdt_fops,
 };
 
-static int __init at91wdt_probe(struct platform_device *pdev)
+static int __devinit at91wdt_probe(struct platform_device *pdev)
 {
 	int res;
 
-- 
1.6.2

