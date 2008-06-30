Return-Path: <linux-kernel-owner+w=401wt.eu-S1758050AbYF3HvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758050AbYF3HvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 03:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYF3Hum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 03:50:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:22704 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbYF3Huk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 03:50:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,726,1204531200"; 
   d="scan'208";a="583361906"
From: Tomas Winkler <tomas.winkler@intel.com>
To: drzeus-list@drzeus.cx
Cc: linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 2/3] mmc: wbsd.c fix shadowing of 'dma' variable
Date: Mon, 30 Jun 2008 10:50:23 +0300
Message-Id: <1214812224-32267-2-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.5.4.1
In-Reply-To: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com>
References: <1214812224-32267-1-git-send-email-tomas.winkler@intel.com>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix warning :shadowing dma variable

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/mmc/host/wbsd.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 67e5a9b..2d7c847 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -75,9 +75,9 @@ static unsigned int nopnp = 0;
 #else
 static const unsigned int nopnp = 1;
 #endif
-static unsigned int io = 0x248;
-static unsigned int irq = 6;
-static int dma = 2;
+static unsigned int param_io = 0x248;
+static unsigned int param_irq = 6;
+static int param_dma = 2;
 
 /*
  * Basic functions
@@ -1765,7 +1765,7 @@ static void __devexit wbsd_shutdown(struct device *dev, int pnp)
 static int __devinit wbsd_probe(struct platform_device *dev)
 {
 	/* Use the module parameters for resources */
-	return wbsd_init(&dev->dev, io, irq, dma, 0);
+	return wbsd_init(&dev->dev, param_io, param_irq, param_dma, 0);
 }
 
 static int __devexit wbsd_remove(struct platform_device *dev)
@@ -2031,9 +2031,9 @@ module_exit(wbsd_drv_exit);
 #ifdef CONFIG_PNP
 module_param(nopnp, uint, 0444);
 #endif
-module_param(io, uint, 0444);
-module_param(irq, uint, 0444);
-module_param(dma, int, 0444);
+module_param(param_io, uint, 0444);
+module_param(param_irq, uint, 0444);
+module_param(param_dma, int, 0444);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Pierre Ossman <drzeus@drzeus.cx>");
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

