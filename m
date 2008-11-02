Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbYKBOMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbYKBOMg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 09:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYKBOM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 09:12:26 -0500
Received: from havoc.gtf.org ([69.61.125.42]:57188 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921AbYKBOMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 09:12:25 -0500
Date: Sun, 2 Nov 2008 09:12:24 -0500
From: Jeff Garzik <jeff@garzik.org>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] net driver fix for 2.6.28-rc
Message-ID: <20081102141224.GA18236@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'davem-fixes' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6.git davem-fixes

to receive the following updates:

 drivers/net/smc911x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

Will Newton (1):
      drivers/net/smc911x.c: Fix lockdep warning on xmit.

diff --git a/drivers/net/smc911x.c b/drivers/net/smc911x.c
index f59c777..5051554 100644
--- a/drivers/net/smc911x.c
+++ b/drivers/net/smc911x.c
@@ -499,7 +499,7 @@ static void smc911x_hardware_send_pkt(struct net_device *dev)
 #else
 	SMC_PUSH_DATA(lp, buf, len);
 	dev->trans_start = jiffies;
-	dev_kfree_skb(skb);
+	dev_kfree_skb_irq(skb);
 #endif
 	if (!lp->tx_throttle) {
 		netif_wake_queue(dev);
