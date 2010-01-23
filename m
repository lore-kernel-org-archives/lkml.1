Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118Ab0AWUjB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0AWUjB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:39:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883Ab0AWUf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:35:58 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50482 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab0AWUfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:35:52 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@wp.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Antonino Daplas <adaplas@pol.net>
Subject: [PATCH 11/29] move hgafb's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:19 +0100
Message-Id: <1264278937-19675-11-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to hgafb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Antonino Daplas <adaplas@pol.net>
---
 drivers/video/hgafb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/hgafb.c b/drivers/video/hgafb.c
index 0129c04..db9b785 100644
--- a/drivers/video/hgafb.c
+++ b/drivers/video/hgafb.c
@@ -551,7 +551,7 @@ static struct fb_ops hgafb_ops = {
 	 *  Initialization
 	 */
 
-static int __init hgafb_probe(struct platform_device *pdev)
+static int __devinit hgafb_probe(struct platform_device *pdev)
 {
 	struct fb_info *info;
 
-- 
1.6.6

