Return-Path: <linux-kernel-owner+w=401wt.eu-S1752084Ab0AWUgI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab0AWUgI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:36:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039Ab0AWUf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:35:59 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50514 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab0AWUfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:35:53 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, "Stanley.Miao" <stanley.miao@windriver.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 16/29] move omap_hdq's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:24 +0100
Message-Id: <1264278937-19675-16-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to omap_hdq_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Stanley.Miao <stanley.miao@windriver.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Madhusudhan Chikkature <madhu.cr@ti.com>
Cc: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/w1/masters/omap_hdq.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/w1/masters/omap_hdq.c b/drivers/w1/masters/omap_hdq.c
index 0d92969..22977d3 100644
--- a/drivers/w1/masters/omap_hdq.c
+++ b/drivers/w1/masters/omap_hdq.c
@@ -72,7 +72,7 @@ struct hdq_data {
 	int			init_trans;
 };
 
-static int __init omap_hdq_probe(struct platform_device *pdev);
+static int __devinit omap_hdq_probe(struct platform_device *pdev);
 static int omap_hdq_remove(struct platform_device *pdev);
 
 static struct platform_driver omap_hdq_driver = {
@@ -558,7 +558,7 @@ static void omap_w1_write_byte(void *_hdq, u8 byte)
 	return;
 }
 
-static int __init omap_hdq_probe(struct platform_device *pdev)
+static int __devinit omap_hdq_probe(struct platform_device *pdev)
 {
 	struct hdq_data *hdq_data;
 	struct resource *res;
-- 
1.6.6

