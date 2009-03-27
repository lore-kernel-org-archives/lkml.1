Return-Path: <linux-kernel-owner+w=401wt.eu-S1758267AbZC0Xmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbZC0Xmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762276AbZC0X2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:06 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48507 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761383AbZC0X1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:43 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jean Pihet <jpihet@mvista.com>,
       Tony Lindgren <tony@atomide.com>, Pierre Ossman <drzeus@drzeus.cx>,
       Andy Lowe <alowe@mvista.com>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Madhusudhan Chikkature <madhu.cr@ti.com>
Subject: [PATCH 33/58] move mmci-omap-hs's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:54 +0100
Message-Id: <1238196439-16535-33-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to omap_mmc_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Jean Pihet <jpihet@mvista.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Pierre Ossman <drzeus@drzeus.cx>
Cc: Andy Lowe <alowe@mvista.com>
Cc: Adrian Hunter <ext-adrian.hunter@nokia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Madhusudhan Chikkature<madhu.cr@ti.com>
---
 drivers/mmc/host/omap_hsmmc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index a631c81..e2085a8 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -899,7 +899,7 @@ static struct mmc_host_ops mmc_omap_ops = {
 	/* NYET -- enable_sdio_irq */
 };
 
-static int __init omap_mmc_probe(struct platform_device *pdev)
+static int __devinit omap_mmc_probe(struct platform_device *pdev)
 {
 	struct omap_mmc_platform_data *pdata = pdev->dev.platform_data;
 	struct mmc_host *mmc;
-- 
1.6.2

