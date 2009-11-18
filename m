Return-Path: <linux-kernel-owner+w=401wt.eu-S932304AbZKRSXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbZKRSXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:23:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932260AbZKRSXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:23:31 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:56319 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932111AbZKRSX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:23:29 -0500
Date: Wed, 18 Nov 2009 19:23:34 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: David Dillow <dave@thedillows.org>, netdev@vger.kernel.org, arnd@arndb.de,
       joe@perches.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 9/16] drivers/net/typhoon.c: remove exceptional & on function
 name
Message-ID: <Pine.LNX.4.64.0911181923180.20943@ask.diku.dk>
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
 drivers/net/typhoon.c               |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
index 5921f5b..079a970 100644
--- a/drivers/net/typhoon.c
+++ b/drivers/net/typhoon.c
@@ -2151,7 +2151,7 @@ typhoon_open(struct net_device *dev)
 		goto out_sleep;
 	}
 
-	err = request_irq(dev->irq, &typhoon_interrupt, IRQF_SHARED,
+	err = request_irq(dev->irq, typhoon_interrupt, IRQF_SHARED,
 				dev->name, dev);
 	if(err < 0)
 		goto out_sleep;
