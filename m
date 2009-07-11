Return-Path: <linux-kernel-owner+w=401wt.eu-S1758677AbZGKVB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758677AbZGKVB1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 17:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbZGKUyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:54:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32978 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756115AbZGKUx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:53:59 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Philipp Zabel <philipp.zabel@gmail.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tony Lindgren <tony@atomide.com>, Russell King <rmk@arm.linux.org.uk>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: [PATCH] move omap_udc's probe function to .devinit.text
Date: Sat, 11 Jul 2009 22:53:06 +0200
Message-Id: <1247345591-22643-38-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090711170548.GC5205@suse.de>
 <1247345591-22643-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-3-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-4-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-5-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-6-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-7-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-8-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-9-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-10-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-11-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-12-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-13-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-14-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-15-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-16-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-17-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-18-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-19-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-20-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-21-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-22-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-23-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-24-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-25-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-26-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-27-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-28-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-29-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-30-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-31-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-32-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-33-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-34-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-35-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-36-git-send-email-u.kleine-koenig@pengutronix.de>
 <1247345591-22643-37-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to omap_udc_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 drivers/usb/gadget/omap_udc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/omap_udc.c b/drivers/usb/gadget/omap_udc.c
index a2db0e1..351cb24 100644
--- a/drivers/usb/gadget/omap_udc.c
+++ b/drivers/usb/gadget/omap_udc.c
@@ -2800,7 +2800,7 @@ omap_udc_setup(struct platform_device *odev, struct otg_transceiver *xceiv)
 	return 0;
 }
 
-static int __init omap_udc_probe(struct platform_device *pdev)
+static int __devinit omap_udc_probe(struct platform_device *pdev)
 {
 	int			status = -ENODEV;
 	int			hmc;
-- 
1.6.3.1

