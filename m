Return-Path: <linux-kernel-owner+w=401wt.eu-S932386AbZKRSZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbZKRSZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932368AbZKRSZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:25:41 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:59938 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330AbZKRSZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:25:39 -0500
Date: Wed, 18 Nov 2009 19:25:43 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: Michael Wu <flamingice@sourmilk.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org, arnd@arndb.de,
       joe@perches.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 15/16] drivers/net/wireless/p54: remove exceptional & on
 function name
Message-ID: <Pine.LNX.4.64.0911181925260.20943@ask.diku.dk>
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
 drivers/net/wireless/p54/p54pci.c   |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index d348c26..a15962a 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -411,7 +411,7 @@ static int p54p_open(struct ieee80211_hw *dev)
 	int err;
 
 	init_completion(&priv->boot_comp);
-	err = request_irq(priv->pdev->irq, &p54p_interrupt,
+	err = request_irq(priv->pdev->irq, p54p_interrupt,
 			  IRQF_SHARED, "p54pci", dev);
 	if (err) {
 		dev_err(&priv->pdev->dev, "failed to register IRQ handler\n");
