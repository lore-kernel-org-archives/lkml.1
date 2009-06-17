Return-Path: <linux-kernel-owner+w=401wt.eu-S1765215AbZFQIhM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765215AbZFQIhM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:37:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757427AbZFQIg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:36:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37279
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751068AbZFQIgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:36:55 -0400
Date: Wed, 17 Jun 2009 01:36:58 -0700 (PDT)
Message-Id: <20090617.013658.58706664.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net,
       geert@linux-m68k.org
Subject: Re: linux-next: net tree build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090617163112.e14e064d.sfr@canb.auug.org.au>
References: <20090617163112.e14e064d.sfr@canb.auug.org.au>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 17 Jun 2009 16:31:12 +1000

> Today's linux-next build (m68k defconfig) failed like this:
> 
> drivers/net/sonic.c: In function 'sonic_send_packet':
> drivers/net/sonic.c:227: error: expected ';' before '}' token
> 
> Caused by commit 5b548140225c6bbbbd560551dd1048b2c0ce58be ("net: use
> symbolic values for ndo_start_xmit() return codes") which lost a
> semicolon in drivers/net/sonic.c.

I just pushed the following fix, thanks!

sonic: Fix build after ndo_start_xmit() changes.

Noticed by Stephen Rothwell.

Signed-off-by: David S. Miller <davem@davemloft.net>
---
 drivers/net/sonic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/sonic.c b/drivers/net/sonic.c
index e4255d8..753a1fb 100644
--- a/drivers/net/sonic.c
+++ b/drivers/net/sonic.c
@@ -223,7 +223,7 @@ static int sonic_send_packet(struct sk_buff *skb, struct net_device *dev)
 	if (!laddr) {
 		printk(KERN_ERR "%s: failed to map tx DMA buffer.\n", dev->name);
 		dev_kfree_skb(skb);
-		return NETDEV_TX_BUSY
+		return NETDEV_TX_BUSY;
 	}
 
 	sonic_tda_put(dev, entry, SONIC_TD_STATUS, 0);       /* clear status */
-- 
1.6.3.2

