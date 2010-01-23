Return-Path: <linux-kernel-owner+w=401wt.eu-S1753297Ab0AWUl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab0AWUl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097Ab0AWUlN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:41:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50520 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab0AWUfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:35:54 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org,
       Kalle Jokiniemi <ext-kalle.jokiniemi@nokia.com>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
       Richard Woodruff <r-woodruff2@ti.com>,
       chandra shekhar <x0044955@ti.com>,
       Jason P Marini <jason.marini@gmail.com>,
       Syed Mohammed Khasim <x0khasim@ti.com>,
       Jarkko Nikula <jarkko.nikula@nokia.com>,
       Juha Yrjola <juha.yrjola@solidboot.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 17/29] move i2c_omap's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:25 +0100
Message-Id: <1264278937-19675-17-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to omap_i2c_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Kalle Jokiniemi <ext-kalle.jokiniemi@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Richard Woodruff <r-woodruff2@ti.com>
Cc: chandra shekhar <x0044955@ti.com>
Cc: Jason P Marini <jason.marini@gmail.com>
Cc: Syed Mohammed Khasim  <x0khasim@ti.com>
Cc: Jarkko Nikula <jarkko.nikula@nokia.com>
Cc: Juha Yrjola <juha.yrjola@solidboot.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/i2c/busses/i2c-omap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 0037e31..bd86a85 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -849,7 +849,7 @@ static const struct i2c_algorithm omap_i2c_algo = {
 	.functionality	= omap_i2c_func,
 };
 
-static int __init
+static int __devinit
 omap_i2c_probe(struct platform_device *pdev)
 {
 	struct omap_i2c_dev	*dev;
-- 
1.6.6

