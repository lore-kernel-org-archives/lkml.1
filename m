Return-Path: <linux-kernel-owner+w=401wt.eu-S1764172AbZC0XjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764172AbZC0XjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758472AbZC0X17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48491 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873AbZC0X1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:42 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Eric Miao <eric.miao@marvell.com>
Subject: [PATCH 47/58] move sharpsl-pm's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:08 +0100
Message-Id: <1238196439-16535-47-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to sharpsl_pm_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/common/sharpsl_pm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/common/sharpsl_pm.c b/arch/arm/common/sharpsl_pm.c
index 780bbf7..e88c9ca 100644
--- a/arch/arm/common/sharpsl_pm.c
+++ b/arch/arm/common/sharpsl_pm.c
@@ -780,7 +780,7 @@ static struct platform_suspend_ops sharpsl_pm_ops = {
 };
 #endif
 
-static int __init sharpsl_pm_probe(struct platform_device *pdev)
+static int __devinit sharpsl_pm_probe(struct platform_device *pdev)
 {
 	int ret;
 
-- 
1.6.2

