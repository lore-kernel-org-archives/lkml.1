Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZC0Xr1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZC0Xr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:47:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762693AbZC0X2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:17 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48481 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761409AbZC0X1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:41 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wang Chen <wangchen@cn.fujitsu.com>,
       "David S. Miller" <davem@davemloft.net>,
       Jeff Garzik <jgarzik@redhat.com>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 44/58] move sgiseeq's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:05 +0100
Message-Id: <1238196439-16535-44-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to sgiseeq_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Wang Chen <wangchen@cn.fujitsu.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
 drivers/net/sgiseeq.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sgiseeq.c b/drivers/net/sgiseeq.c
index 97d6856..c95da7a 100644
--- a/drivers/net/sgiseeq.c
+++ b/drivers/net/sgiseeq.c
@@ -709,7 +709,7 @@ static inline void setup_rx_ring(struct net_device *dev,
 	dma_sync_desc_dev(dev, &buf[i]);
 }
 
-static int __init sgiseeq_probe(struct platform_device *pdev)
+static int __devinit sgiseeq_probe(struct platform_device *pdev)
 {
 	struct sgiseeq_platform_data *pd = pdev->dev.platform_data;
 	struct hpc3_regs *hpcregs = pd->hpc;
-- 
1.6.2

