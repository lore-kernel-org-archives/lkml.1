Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbZC0XlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbZC0XlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761338AbZC0X2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:03 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48499 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761584AbZC0X1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:42 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roel Kluin <roel.kluin@gmail.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Antonino Daplas <adaplas@pol.net>, Kaj-Michael Lang <milang@tal.org>,
       Martin Michlmayr <tbm@cyrius.com>, Joshua Kinard <kumba@gentoo.org>
Subject: [PATCH 15/58] move gbefb's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:36 +0100
Message-Id: <1238196439-16535-15-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to gbefb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Roel Kluin <roel.kluin@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Antonino Daplas <adaplas@pol.net>
Cc: Kaj-Michael Lang <milang@tal.org>
Cc: Martin Michlmayr <tbm@cyrius.com>
Cc: Joshua Kinard <kumba@gentoo.org>
---
 drivers/video/gbefb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/gbefb.c b/drivers/video/gbefb.c
index fe5b519..4c7f3a0 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -1128,7 +1128,7 @@ int __init gbefb_setup(char *options)
 	return 0;
 }
 
-static int __init gbefb_probe(struct platform_device *p_dev)
+static int __devinit gbefb_probe(struct platform_device *p_dev)
 {
 	int i, ret = 0;
 	struct fb_info *info;
-- 
1.6.2

