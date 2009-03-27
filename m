Return-Path: <linux-kernel-owner+w=401wt.eu-S1763693AbZC0Xh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763693AbZC0Xh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762057AbZC0X1z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:55 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48479 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760122AbZC0X1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:41 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>,
       David Woodhouse <David.Woodhouse@intel.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 14/58] move sh_flctl's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:35 +0100
Message-Id: <1238196439-16535-14-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to flctl_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Yoshihiro Shimoda <shimoda.yoshihiro@renesas.com>
Cc: David Woodhouse <David.Woodhouse@intel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/mtd/nand/sh_flctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/sh_flctl.c b/drivers/mtd/nand/sh_flctl.c
index 821acb0..fdc0e4e 100644
--- a/drivers/mtd/nand/sh_flctl.c
+++ b/drivers/mtd/nand/sh_flctl.c
@@ -763,7 +763,7 @@ static int flctl_chip_init_tail(struct mtd_info *mtd)
 	return 0;
 }
 
-static int __init flctl_probe(struct platform_device *pdev)
+static int __devinit flctl_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct sh_flctl *flctl;
-- 
1.6.2

