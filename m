Return-Path: <linux-kernel-owner+w=401wt.eu-S1764675AbZC0Xq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764675AbZC0Xq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762662AbZC0X2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:15 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48619 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761804AbZC0X1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:49 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Bryan Wu <cooloney@kernel.org>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Antonino Daplas <adaplas@pol.net>
Subject: [PATCH 06/58] move bf54x-lq043's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:27 +0100
Message-Id: <1238196439-16535-6-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to bfin_bf54x_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Bryan Wu <cooloney@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Mike Frysinger <vapier.adi@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Antonino Daplas <adaplas@pol.net>
---
 drivers/video/bf54x-lq043fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/bf54x-lq043fb.c b/drivers/video/bf54x-lq043fb.c
index 37e60b1..0a848c0 100644
--- a/drivers/video/bf54x-lq043fb.c
+++ b/drivers/video/bf54x-lq043fb.c
@@ -530,7 +530,7 @@ static irqreturn_t bfin_bf54x_irq_error(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __init bfin_bf54x_probe(struct platform_device *pdev)
+static int __devinit bfin_bf54x_probe(struct platform_device *pdev)
 {
 	struct bfin_bf54xfb_info *info;
 	struct fb_info *fbinfo;
-- 
1.6.2

