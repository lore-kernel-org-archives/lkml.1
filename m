Return-Path: <linux-kernel-owner+w=401wt.eu-S932626AbZJLPjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932626AbZJLPjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 11:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932277AbZJLPjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 11:39:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54490 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932367AbZJLPjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 11:39:42 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/2] ethoc: fix warning from 32bit build
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Oct 2009 16:27:55 +0100
Message-ID: <20091012152753.5694.18204.stgit@localhost.localdomain>
In-Reply-To: <20091012152247.5694.77290.stgit@localhost.localdomain>
References: <20091012152247.5694.77290.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/net/ethoc.c: In function ‘ethoc_open’:
drivers/net/ethoc.c:667: warning: comparison of distinct pointer types
lacks a cast

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/net/ethoc.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/net/ethoc.c b/drivers/net/ethoc.c
index 96f5b2a..402a507 100644
--- a/drivers/net/ethoc.c
+++ b/drivers/net/ethoc.c
@@ -664,7 +664,8 @@ static int ethoc_open(struct net_device *dev)
 		return ret;
 
 	/* calculate the number of TX/RX buffers, maximum 128 supported */
-	num_bd = min(128, (dev->mem_end - dev->mem_start + 1) / ETHOC_BUFSIZ);
+	num_bd = min_t(unsigned int, 
+		128, (dev->mem_end - dev->mem_start + 1) / ETHOC_BUFSIZ);
 	priv->num_tx = max(min_tx, num_bd / 4);
 	priv->num_rx = num_bd - priv->num_tx;
 	ethoc_write(priv, TX_BD_NUM, priv->num_tx);

