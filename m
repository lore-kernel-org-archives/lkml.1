Return-Path: <linux-kernel-owner+w=401wt.eu-S1763207AbZC0X3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763207AbZC0X3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 19:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbZC0X1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 19:27:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48390 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759069AbZC0X1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 19:27:32 -0400
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Zankel <chris@zankel.net>,
       "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 58/58] move xtsonic's probe function to .devinit.text
Date: Sat, 28 Mar 2009 00:27:19 +0100
Message-Id: <1238196439-16535-58-git-send-email-u.kleine-koenig@pengutronix.de>
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

A pointer to xtsonic_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/net/xtsonic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/xtsonic.c b/drivers/net/xtsonic.c
index a12a721..10f69f8 100644
--- a/drivers/net/xtsonic.c
+++ b/drivers/net/xtsonic.c
@@ -232,7 +232,7 @@ out:
  * Actually probing is superfluous but we're paranoid.
  */
 
-int __init xtsonic_probe(struct platform_device *pdev)
+int __devinit xtsonic_probe(struct platform_device *pdev)
 {
 	struct net_device *dev;
 	struct sonic_local *lp;
-- 
1.6.2

