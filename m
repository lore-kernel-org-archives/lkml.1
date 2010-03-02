Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0CBX3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:29:46 -0500
Received: from kroah.org ([198.145.64.141]:38633 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0CBX3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:33 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       "Stanley.Miao" <stanley.miao@windriver.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 34/62] w1: move omap_hdq's probe function to .devinit.text
Date: Tue,  2 Mar 2010 15:28:33 -0800
Message-Id: <1267572541-410-34-git-send-email-gregkh@suse.de>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.0.1

