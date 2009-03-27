Return-Path: <linux-kernel-owner+w=401wt.eu-S1763893AbZC0Xev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763893AbZC0Xev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762086AbZC0X1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:48 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48418 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706AbZC0X1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:34 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Hamish Moffatt <hamish@cloud.net.au>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Li Zefan <lizf@cn.fujitsu.com>, Vitaly Wool <vitalywool@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 37/58] move gen_nand's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:58 +0100
Message-Id: <1238196439-16535-37-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to plat_nand_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Hamish Moffatt <hamish@cloud.net.au>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Vitaly Wool <vitalywool@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/mtd/nand/plat_nand.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/plat_nand.c b/drivers/mtd/nand/plat_nand.c
index 75f9f48..86e1d08 100644
--- a/drivers/mtd/nand/plat_nand.c
+++ b/drivers/mtd/nand/plat_nand.c
@@ -30,7 +30,7 @@ struct plat_nand_data {
 /*
  * Probe for the NAND device.
  */
-static int __init plat_nand_probe(struct platform_device *pdev)
+static int __devinit plat_nand_probe(struct platform_device *pdev)
 {
 	struct platform_nand_data *pdata = pdev->dev.platform_data;
 	struct plat_nand_data *data;
-- 
1.6.2

