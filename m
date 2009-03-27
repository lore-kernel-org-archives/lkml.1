Return-Path: <linux-kernel-owner+w=401wt.eu-S1764926AbZC0XvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764926AbZC0XvW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762611AbZC0X2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48716 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762142AbZC0X16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:58 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hiroshi DOYU <Hiroshi.DOYU@nokia.com>, Tony Lindgren <tony@atomide.com>,
       Juha Yrjola <juha.yrjola@solidboot.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 30/58] move mailbox's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:51 +0100
Message-Id: <1238196439-16535-30-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to omap2_mbox_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Juha Yrjola <juha.yrjola@solidboot.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/mach-omap2/mailbox.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/mailbox.c b/arch/arm/mach-omap2/mailbox.c
index 32b7af3..726876c 100644
--- a/arch/arm/mach-omap2/mailbox.c
+++ b/arch/arm/mach-omap2/mailbox.c
@@ -251,7 +251,7 @@ static struct omap_mbox mbox_iva_info = {
 	.priv	= &omap2_mbox_iva_priv,
 };
 
-static int __init omap2_mbox_probe(struct platform_device *pdev)
+static int __devinit omap2_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	int ret = 0;
-- 
1.6.2

