Return-Path: <linux-kernel-owner+w=401wt.eu-S1752863Ab0AWUiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0AWUiH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752239Ab0AWUh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:37:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50612 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab0AWUgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:36:06 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Roel Kluin <12o3l@tiscali.nl>,
       Russell King <rmk+kernel@arm.linux.org.uk>, netdev@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/29] move am79c961's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:10 +0100
Message-Id: <1264278937-19675-2-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to am79c961_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: netdev@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/net/arm/am79c961a.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/arm/am79c961a.c b/drivers/net/arm/am79c961a.c
index 164b37e..1c3c1f9 100644
--- a/drivers/net/arm/am79c961a.c
+++ b/drivers/net/arm/am79c961a.c
@@ -680,7 +680,7 @@ static const struct net_device_ops am79c961_netdev_ops = {
 #endif
 };
 
-static int __init am79c961_probe(struct platform_device *pdev)
+static int __devinit am79c961_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct net_device *dev;
-- 
1.6.6

