Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbZGKUyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbZGKUyc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 16:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbZGKUxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 16:53:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32825 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755920AbZGKUxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 16:53:43 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
       Krzysztof Helt <krzysztof.h1@wp.pl>,
       Antonino Daplas <adaplas@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mundt <lethal@linux-sh.org>, Roland Stigge <stigge@antcom.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] move epson1355fb's probe function to .devinit.text
Date: Sat, 11 Jul 2009 22:52:38 +0200
Message-Id: <1247345591-22643-10-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1247345591-22643-9-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to epson1355fb_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Roland Stigge <stigge@antcom.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/video/epson1355fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/epson1355fb.c b/drivers/video/epson1355fb.c
index 2735b79..6d755bb 100644
--- a/drivers/video/epson1355fb.c
+++ b/drivers/video/epson1355fb.c
@@ -602,7 +602,7 @@ static int epson1355fb_remove(struct platform_device *dev)
 	return 0;
 }
 
-int __init epson1355fb_probe(struct platform_device *dev)
+int __devinit epson1355fb_probe(struct platform_device *dev)
 {
 	struct epson1355_par *default_par;
 	struct fb_info *info;
-- 
1.6.3.1

