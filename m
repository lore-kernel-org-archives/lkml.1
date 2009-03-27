Return-Path: <linux-kernel-owner+w=401wt.eu-S1764804AbZC0Xtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764804AbZC0Xtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761979AbZC0X2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:28:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48634 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761765AbZC0X1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:50 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Weiwei Wang <weiwei.wang@windriver.com>,
       Jeff Garzik <jgarzik@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Stephen Hemminger <shemminger@vyatta.com>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: [PATCH 43/58] move sb1250-mac's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:04 +0100
Message-Id: <1238196439-16535-43-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to sbmac_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Weiwei Wang <weiwei.wang@windriver.com>
Cc: Jeff Garzik <jgarzik@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stephen Hemminger <shemminger@vyatta.com>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/net/sb1250-mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sb1250-mac.c b/drivers/net/sb1250-mac.c
index 88dd2e0..8c961b9 100644
--- a/drivers/net/sb1250-mac.c
+++ b/drivers/net/sb1250-mac.c
@@ -2683,7 +2683,7 @@ static int sbmac_poll(struct napi_struct *napi, int budget)
 }
 
 
-static int __init sbmac_probe(struct platform_device *pldev)
+static int __devinit sbmac_probe(struct platform_device *pldev)
 {
 	struct net_device *dev;
 	struct sbmac_softc *sc;
-- 
1.6.2

