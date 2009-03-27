Return-Path: <linux-kernel-owner+w=401wt.eu-S1764280AbZC0Xlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764280AbZC0Xlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759674AbZC0X2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:04 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48493 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761471AbZC0X1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:42 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Magnus Damm <damm@igel.co.jp>,
       Paul Mundt <lethal@linux-sh.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>
Subject: [PATCH 48/58] move sh_mobile_lcdc_fb's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:09 +0100
Message-Id: <1238196439-16535-48-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to sh_mobile_lcdc_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Magnus Damm <damm@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/video/sh_mobile_lcdcfb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/sh_mobile_lcdcfb.c b/drivers/video/sh_mobile_lcdcfb.c
index 92ea0ab..ba795e2 100644
--- a/drivers/video/sh_mobile_lcdcfb.c
+++ b/drivers/video/sh_mobile_lcdcfb.c
@@ -704,7 +704,7 @@ static struct dev_pm_ops sh_mobile_lcdc_dev_pm_ops = {
 
 static int sh_mobile_lcdc_remove(struct platform_device *pdev);
 
-static int __init sh_mobile_lcdc_probe(struct platform_device *pdev)
+static int __devinit sh_mobile_lcdc_probe(struct platform_device *pdev)
 {
 	struct fb_info *info;
 	struct sh_mobile_lcdc_priv *priv;
-- 
1.6.2

