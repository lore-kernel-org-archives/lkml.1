Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZIBDiE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZIBDiE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 23:38:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755598AbZIBDiE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 23:38:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52895 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752750AbZIBDiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 23:38:03 -0400
Date: Wed, 2 Sep 2009 13:37:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Roel Kluin <roel.kluin@gmail.com>
Subject: linux-next: manual merge of the net tree with Linus' tree
Message-Id: <20090902133758.f96cac22.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the net tree got a conflict in
drivers/net/yellowfin.c between commit
e7a5965a81a29a13cd4994fa23a6a7a1488bcdb6 ("yellowfin: Fix buffer underrun
after dev_alloc_skb() failure") from Linus' tree and commit
61357325f377889a1daffa14962d705dc814dd0e ("netdev: convert bulk of
drivers to netdev_tx_t") from the net tree.

Just context changes.  I fixed it up (see below) and will carry the fix
for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/yellowfin.c
index c2fd618,9509477..0000000
--- a/drivers/net/yellowfin.c
+++ b/drivers/net/yellowfin.c
@@@ -346,8 -346,9 +346,9 @@@ static int netdev_ioctl(struct net_devi
  static int yellowfin_open(struct net_device *dev);
  static void yellowfin_timer(unsigned long data);
  static void yellowfin_tx_timeout(struct net_device *dev);
 -static void yellowfin_init_ring(struct net_device *dev);
 +static int yellowfin_init_ring(struct net_device *dev);
- static int yellowfin_start_xmit(struct sk_buff *skb, struct net_device *dev);
+ static netdev_tx_t yellowfin_start_xmit(struct sk_buff *skb,
+ 					struct net_device *dev);
  static irqreturn_t yellowfin_interrupt(int irq, void *dev_instance);
  static int yellowfin_rx(struct net_device *dev);
  static void yellowfin_error(struct net_device *dev, int intr_status);
@@@ -813,10 -806,11 +814,11 @@@ static int yellowfin_init_ring(struct n
  }
  #endif
  	yp->tx_tail_desc = &yp->tx_status[0];
 -	return;
 +	return 0;
  }
  
- static int yellowfin_start_xmit(struct sk_buff *skb, struct net_device *dev)
+ static netdev_tx_t yellowfin_start_xmit(struct sk_buff *skb,
+ 					struct net_device *dev)
  {
  	struct yellowfin_private *yp = netdev_priv(dev);
  	unsigned entry;
