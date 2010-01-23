Return-Path: <linux-kernel-owner+w=401wt.eu-S1752663Ab0AWUhI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab0AWUhI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 15:37:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752164Ab0AWUgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 15:36:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50643 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab0AWUgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 15:36:12 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.miao@marvell.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Sokolovsky <pmiscml@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 06/29] move corgi-ssp's probe function to .devinit.text
Date: Sat, 23 Jan 2010 21:35:14 +0100
Message-Id: <1264278937-19675-6-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to corgi_ssp_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (when having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Eric Miao <eric.miao@marvell.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Paul Sokolovsky <pmiscml@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 arch/arm/mach-pxa/corgi_ssp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
 
-- 
1.6.6

