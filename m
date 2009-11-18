Return-Path: <linux-kernel-owner+w=401wt.eu-S1758250AbZKRSUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250AbZKRSUn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:20:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758220AbZKRSUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:20:42 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:45412 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218AbZKRSUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:20:40 -0500
Date: Wed, 18 Nov 2009 19:20:44 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Urs Thuermann <urs.thuermann@volkswagen.de>,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>, netdev@vger.kernel.org,
       arnd@arndb.de, joe@perches.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 2/16] drivers/net/can: remove exceptional & on function name
Message-ID: <Pine.LNX.4.64.0911181920250.20943@ask.diku.dk>
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
 drivers/net/can/sja1000/sja1000.c   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 782a47f..b4ba88a 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -516,7 +516,7 @@ static int sja1000_open(struct net_device *dev)
 
 	/* register interrupt handler, if not done by the device driver */
 	if (!(priv->flags & SJA1000_CUSTOM_IRQ_HANDLER)) {
-		err = request_irq(dev->irq, &sja1000_interrupt, priv->irq_flags,
+		err = request_irq(dev->irq, sja1000_interrupt, priv->irq_flags,
 				  dev->name, (void *)dev);
 		if (err) {
 			close_candev(dev);
