Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZKRSXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZKRSXA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:23:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932264AbZKRSW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:22:58 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:56292 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932257AbZKRSW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:22:56 -0500
Date: Wed, 18 Nov 2009 19:23:00 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Florian Fainelli <florian@openwrt.org>, netdev@vger.kernel.org,
       arnd@arndb.de, joe@perches.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 7/16] drivers/net/r6040.c: remove exceptional & on function
 name
Message-ID: <Pine.LNX.4.64.0911181922450.20943@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

In this file, function names are otherwise used as pointers without &.

A simplified version of the semantic patch that makes this change is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier f;
@@

f(...) { ... }

@@
identifier r.f;
@@

- &f
+ f
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/net/r6040.c                 |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/r6040.c b/drivers/net/r6040.c
index 7dfcb58..91ebef0 100644
--- a/drivers/net/r6040.c
+++ b/drivers/net/r6040.c
@@ -842,7 +842,7 @@ static int r6040_open(struct net_device *dev)
 	int ret;
 
 	/* Request IRQ and Register interrupt handler */
-	ret = request_irq(dev->irq, &r6040_interrupt,
+	ret = request_irq(dev->irq, r6040_interrupt,
 		IRQF_SHARED, dev->name, dev);
 	if (ret)
 		return ret;
