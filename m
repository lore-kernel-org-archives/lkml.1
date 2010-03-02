Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145Ab0CBXyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:54:11 -0500
Received: from kroah.org ([198.145.64.141]:38570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754293Ab0CBX33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:29 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ben Dooks <ben-linux@fluff.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>,
       Eric Miao <eric.miao@marvell.com>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Paul Sokolovsky <pmiscml@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 29/62] platform-drivers: move probe to .devinit.text in arch/arm
Date: Tue,  2 Mar 2010 15:28:28 -0800
Message-Id: <1267572541-410-29-git-send-email-gregkh@suse.de>
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

A pointer to a probe callback is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben-linux@fluff.org>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Cc: Paul Sokolovsky <pmiscml@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Arnaud Patard <arnaud.patard@rtp-net.org>
Acked-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Acked-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/arm/mach-pxa/corgi_ssp.c           |    2 +-
 arch/arm/mach-pxa/sharpsl_pm.c          |    2 +-
 arch/arm/mach-s3c2410/h1940-bluetooth.c |    2 +-
 arch/arm/mach-sa1100/jornada720_ssp.c   |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-pxa/corgi_ssp.c b/arch/arm/mach-pxa/corgi_ssp.c
index a5ee707..1d9bc11 100644
--- a/arch/arm/mach-pxa/corgi_ssp.c
+++ b/arch/arm/mach-pxa/corgi_ssp.c
@@ -204,7 +204,7 @@ void __init corgi_ssp_set_machinfo(struct corgissp_machinfo *machinfo)
 	ssp_machinfo = machinfo;
 }
 
-static int __init corgi_ssp_probe(struct platform_device *dev)
+static int __devinit corgi_ssp_probe(struct platform_device *dev)
 {
 	int ret;
 
diff --git a/arch/arm/mach-pxa/sharpsl_pm.c b/arch/arm/mach-pxa/sharpsl_pm.c
index 67229a1..463d874 100644
--- a/arch/arm/mach-pxa/sharpsl_pm.c
+++ b/arch/arm/mach-pxa/sharpsl_pm.c
@@ -900,7 +900,7 @@ static struct platform_suspend_ops sharpsl_pm_ops = {
 };
 #endif
 
-static int __init sharpsl_pm_probe(struct platform_device *pdev)
+static int __devinit sharpsl_pm_probe(struct platform_device *pdev)
 {
 	int ret;
 
diff --git a/arch/arm/mach-s3c2410/h1940-bluetooth.c b/arch/arm/mach-s3c2410/h1940-bluetooth.c
index b7d1f8d..a3f3c7b 100644
--- a/arch/arm/mach-s3c2410/h1940-bluetooth.c
+++ b/arch/arm/mach-s3c2410/h1940-bluetooth.c
@@ -56,7 +56,7 @@ static const struct rfkill_ops h1940bt_rfkill_ops = {
 	.set_block = h1940bt_set_block,
 };
 
-static int __init h1940bt_probe(struct platform_device *pdev)
+static int __devinit h1940bt_probe(struct platform_device *pdev)
 {
 	struct rfkill *rfk;
 	int ret = 0;
diff --git a/arch/arm/mach-sa1100/jornada720_ssp.c b/arch/arm/mach-sa1100/jornada720_ssp.c
index 506a5e5..9b6dee5 100644
--- a/arch/arm/mach-sa1100/jornada720_ssp.c
+++ b/arch/arm/mach-sa1100/jornada720_ssp.c
@@ -130,7 +130,7 @@ void jornada_ssp_end(void)
 };
 EXPORT_SYMBOL(jornada_ssp_end);
 
-static int __init jornada_ssp_probe(struct platform_device *dev)
+static int __devinit jornada_ssp_probe(struct platform_device *dev)
 {
 	int ret;
 
-- 
1.7.0.1

