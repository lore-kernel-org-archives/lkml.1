Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0CBX3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:42 -0500
Received: from kroah.org ([198.145.64.141]:38626 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754324Ab0CBX3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:32 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Kalle Jokiniemi <ext-kalle.jokiniemi@nokia.com>,
       Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
       Richard Woodruff <r-woodruff2@ti.com>,
       chandra shekhar <x0044955@ti.com>,
       Jason P Marini <jason.marini@gmail.com>,
       Syed Mohammed Khasim <x0khasim@ti.com>,
       Jarkko Nikula <jarkko.nikula@nokia.com>,
       Juha Yrjola <juha.yrjola@solidboot.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/62] i2c: move i2c_omap's probe function to .devinit.text
Date: Tue,  2 Mar 2010 15:28:32 -0800
Message-Id: <1267572541-410-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230933.GA32287@kroah.com>
References: <20100302230933.GA32287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.0.1

