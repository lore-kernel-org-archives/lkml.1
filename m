Return-Path: <linux-kernel-owner+w=401wt.eu-S1752790Ab0AWUiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab0AWUiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:38:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566Ab0AWUgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:36:05 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50517 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0AWUfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:35:54 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Roel Kluin <roel.kluin@gmail.com>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@pol.net>, Kaj-Michael Lang <milang@tal.org>,
       Martin Michlmayr <tbm@cyrius.com>, Joshua Kinard <kumba@gentoo.org>
Subject: [PATCH 09/29] move gbefb's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:17 +0100
Message-Id: <1264278937-19675-9-git-send-email-u.kleine-koenig@pengutronix.de>
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
index 695fa01..5643a35 100644
--- a/drivers/video/gbefb.c
+++ b/drivers/video/gbefb.c
@@ -1128,7 +1128,7 @@ static int __init gbefb_setup(char *options)
 	return 0;
 }
 
-static int __init gbefb_probe(struct platform_device *p_dev)
+static int __devinit gbefb_probe(struct platform_device *p_dev)
 {
 	int i, ret = 0;
 	struct fb_info *info;
-- 
1.6.6

