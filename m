Return-Path: <linux-kernel-owner+w=401wt.eu-S1763992AbZC0Xfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763992AbZC0Xfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761968AbZC0X1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48414 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115AbZC0X1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:34 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Matthias Kaehlcke <matthias@kaehlcke.net>,
       Antonino Daplas <adaplas@gmail.com>, Pavel Machek <pavel@suse.cz>,
       Christoph Hellwig <hch@lst.de>
Subject: [PATCH 41/58] move sa11x0-fb's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:02 +0100
Message-Id: <1238196439-16535-41-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to sa1100fb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Matthias Kaehlcke <matthias@kaehlcke.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Pavel Machek <pavel@suse.cz>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/video/sa1100fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/sa1100fb.c b/drivers/video/sa1100fb.c
index 076f946..e677012 100644
--- a/drivers/video/sa1100fb.c
+++ b/drivers/video/sa1100fb.c
@@ -1451,7 +1451,7 @@ static struct sa1100fb_info * __init sa1100fb_init_fbinfo(struct device *dev)
 	return fbi;
 }
 
-static int __init sa1100fb_probe(struct platform_device *pdev)
+static int __devinit sa1100fb_probe(struct platform_device *pdev)
 {
 	struct sa1100fb_info *fbi;
 	int ret, irq;
-- 
1.6.2

