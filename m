Return-Path: <linux-kernel-owner+w=401wt.eu-S1759271AbXGAUW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbXGAUW3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 16:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758689AbXGAUUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 16:20:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46830 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758674AbXGAUUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 16:20:43 -0400
Date: Sun, 1 Jul 2007 22:21:10 +0200
From: Adrian Bunk <bunk@stusta.de>
To: jgarzik@pobox.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] drivers/net/ns83820.c: fix a check-after-use
Message-ID: <20070701202110.GH10869@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a check-after-use spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/drivers/net/ns83820.c.old	2007-06-29 22:12:22.000000000 +0200
+++ linux-2.6.22-rc6-mm1/drivers/net/ns83820.c	2007-06-29 22:13:59.000000000 +0200
@@ -1985,11 +1985,13 @@ static int __devinit ns83820_init_one(st
 
 	ndev = alloc_etherdev(sizeof(struct ns83820));
 	dev = PRIV(ndev);
-	dev->ndev = ndev;
+
 	err = -ENOMEM;
 	if (!dev)
 		goto out;
 
+	dev->ndev = ndev;
+
 	spin_lock_init(&dev->rx_info.lock);
 	spin_lock_init(&dev->tx_lock);
 	spin_lock_init(&dev->misc_lock);

