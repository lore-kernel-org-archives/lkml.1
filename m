Return-Path: <linux-kernel-owner+w=401wt.eu-S1764861AbZC0Xua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764861AbZC0Xua (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761847AbZC0X2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48632 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761911AbZC0X1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:50 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
       Alan Cox <alan@redhat.com>
Subject: [PATCH 24/58] move ks8695_wdt's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:45 +0100
Message-Id: <1238196439-16535-24-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to ks8695wdt_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Alan Cox <alan@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/watchdog/ks8695_wdt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/watchdog/ks8695_wdt.c b/drivers/watchdog/ks8695_wdt.c
index 74c92d3..cdbb36a 100644
--- a/drivers/watchdog/ks8695_wdt.c
+++ b/drivers/watchdog/ks8695_wdt.c
@@ -221,7 +221,7 @@ static struct miscdevice ks8695wdt_miscdev = {
 	.fops		= &ks8695wdt_fops,
 };
 
-static int __init ks8695wdt_probe(struct platform_device *pdev)
+static int __devinit ks8695wdt_probe(struct platform_device *pdev)
 {
 	int res;
 
-- 
1.6.2

