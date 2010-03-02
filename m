Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab0CBXgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:36:47 -0500
Received: from kroah.org ([198.145.64.141]:38650 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754361Ab0CBX3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:29:35 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Roel Kluin <12o3l@tiscali.nl>,
       Russell King <rmk+kernel@arm.linux.org.uk>, <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 37/62] net: move am79c961's probe function to .devinit.text
Date: Tue,  2 Mar 2010 15:28:36 -0800
Message-Id: <1267572541-410-37-git-send-email-gregkh@suse.de>
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

A pointer to am79c961_probe is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Roel Kluin <12o3l@tiscali.nl>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: <netdev@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/arm/am79c961a.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/arm/am79c961a.c b/drivers/net/arm/am79c961a.c
index 164b37e..1c3c1f9 100644
--- a/drivers/net/arm/am79c961a.c
+++ b/drivers/net/arm/am79c961a.c
@@ -680,7 +680,7 @@ static const struct net_device_ops am79c961_netdev_ops = {
 #endif
 };
 
-static int __init am79c961_probe(struct platform_device *pdev)
+static int __devinit am79c961_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct net_device *dev;
-- 
1.7.0.1

