Return-Path: <linux-kernel-owner+w=401wt.eu-S1763661AbZC0Xds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763661AbZC0Xds (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761887AbZC0X1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:45 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48422 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122AbZC0X1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:34 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, Jeff Garzik <jeff@garzik.org>,
       "David S. Miller" <davem@davemloft.net>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Finn Thain <fthain@telegraphics.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 22/58] move jazzsonic's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:26:43 +0100
Message-Id: <1238196439-16535-22-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to jazz_sonic_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/net/jazzsonic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/jazzsonic.c b/drivers/net/jazzsonic.c
index 14248cf..3695f2d 100644
--- a/drivers/net/jazzsonic.c
+++ b/drivers/net/jazzsonic.c
@@ -204,7 +204,7 @@ out:
  * Probe for a SONIC ethernet controller on a Mips Jazz board.
  * Actually probing is superfluous but we're paranoid.
  */
-static int __init jazz_sonic_probe(struct platform_device *pdev)
+static int __devinit jazz_sonic_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct sonic_local *lp;
-- 
1.6.2

