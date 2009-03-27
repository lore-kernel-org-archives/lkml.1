Return-Path: <linux-kernel-owner+w=401wt.eu-S1764269AbZC0Xkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764269AbZC0Xkq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbZC0X2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:02 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48495 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761555AbZC0X1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:42 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jeff Garzik <jgarzik@redhat.com>,
       Paulius Zaleckas <paulius.zaleckas@teltonika.lt>,
       Marc Pignat <marc.pignat@hevs.ch>, Andrew Victor <linux@maxim.org.za>,
       Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH 04/58] move at91_ether's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:25 +0100
Message-Id: <1238196439-16535-4-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to at91ether_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
Cc: Marc Pignat <marc.pignat@hevs.ch>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/net/arm/at91_ether.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/arm/at91_ether.c b/drivers/net/arm/at91_ether.c
index 442938d..52e09eb 100644
--- a/drivers/net/arm/at91_ether.c
+++ b/drivers/net/arm/at91_ether.c
@@ -1113,7 +1113,7 @@ static int __init at91ether_setup(unsigned long phy_type, unsigned short phy_add
 /*
  * Detect MAC and PHY and perform initialization
  */
-static int __init at91ether_probe(struct platform_device *pdev)
+static int __devinit at91ether_probe(struct platform_device *pdev)
 {
 	unsigned int phyid1, phyid2;
 	int detected = -1;
-- 
1.6.2

