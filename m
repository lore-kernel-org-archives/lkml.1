Return-Path: <linux-kernel-owner+w=401wt.eu-S932340AbZKRSY3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340AbZKRSY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:24:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932242AbZKRSY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:24:28 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:56421 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277AbZKRSY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:24:26 -0500
Date: Wed, 18 Nov 2009 19:24:30 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Francois Romieu <romieu@fr.zoreil.com>, netdev@vger.kernel.org,
       arnd@arndb.de, joe@perches.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 12/16] drivers/net/wan: remove exceptional & on function name
Message-ID: <Pine.LNX.4.64.0911181924140.20943@ask.diku.dk>
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
 drivers/net/wan/dscc4.c             |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wan/dscc4.c b/drivers/net/wan/dscc4.c
index 07d00b4..8a3513a 100644
--- a/drivers/net/wan/dscc4.c
+++ b/drivers/net/wan/dscc4.c
@@ -1128,7 +1128,7 @@ done:
         init_timer(&dpriv->timer);
         dpriv->timer.expires = jiffies + 10*HZ;
         dpriv->timer.data = (unsigned long)dev;
-        dpriv->timer.function = &dscc4_timer;
+	dpriv->timer.function = dscc4_timer;
         add_timer(&dpriv->timer);
 	netif_carrier_on(dev);
 
