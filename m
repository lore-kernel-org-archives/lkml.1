Return-Path: <linux-kernel-owner+w=401wt.eu-S1752654Ab0AWUkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab0AWUkA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:40:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751305Ab0AWUf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:35:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50477 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab0AWUfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:35:51 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Ben Dooks <ben-linux@fluff.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 10/29] move h1940-bt's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:18 +0100
Message-Id: <1264278937-19675-10-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1264189758-7197-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b7d1f8d..a3f3c7b 100644
--- a/arch/arm/mach-s3c2410/h1940-bluetooth.c
+++ b/arch/arm/mach-s3c2410/h1940-bluetooth.c
@@ -56,7 +56,7 @@ static const struct rfkill_ops h1940bt_rfkill_ops = {
 	.set_block = h1940bt_set_block,
 };
 
-static int __init h1940bt_probe(struct platform_device *pdev)
+static int __devinit h1940bt_probe(struct platform_device *pdev)
 {
 	struct rfkill *rfk;
 	int ret = 0;
-- 
1.6.6

