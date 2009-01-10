Return-Path: <linux-kernel-owner+w=401wt.eu-S1755818AbZAJLCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbZAJLCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 06:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752324AbZAJLCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 06:02:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58188 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbZAJLCI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 06:02:08 -0500
Date: Sat, 10 Jan 2009 12:01:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: parag.lkml@gmail.com, shemminger@vyatta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix net/irda build breakage
Message-ID: <20090110110157.GA13322@elte.hu>
References: <alpine.LFD.2.00.0901091829270.21215@localhost.localdomain> <20090109.170258.169849917.davem@davemloft.net> <20090110105827.GA9460@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090110105827.GA9460@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.3
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4982]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> > Already fixed in the net-2.6 GIT tree, but thanks.
> 
> mind sending the patch here to lkml too so that people can pick it up? 
> Current -git is broken with x86 allyesconfig and Parag's patch above is 
> whitespace damaged.

below is the undamaged one - in case someone here on lkml needs the fix.

	Ingo

-------------->
>From a5532d29c1ade8b4576f449d4e40678490b96594 Mon Sep 17 00:00:00 2001
From: Parag Warudkar <parag.lkml@gmail.com>
Date: Fri, 9 Jan 2009 18:30:58 -0500
Subject: [PATCH] Fix net/irda build breakage

commit af0490810cfa159b4894ddecfc5eb2e4432fb976 breaks build for net/irda -

drivers/net/irda/donauboe.c: In function 'toshoboe_interrupt':
drivers/net/irda/donauboe.c:1197: error: 'struct toshoboe_cb' has no member named 'stats'
drivers/net/irda/donauboe.c:1201: error: 'struct toshoboe_cb' has no member named 'stats'
drivers/net/irda/donauboe.c:1283: error: 'struct toshoboe_cb' has no member named 'stats'
make[3]: *** [drivers/net/irda/donauboe.o] Error 1
make[2]: *** [drivers/net/irda] Error 2

Fix this.

Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
Cc: davem@davemloft.net
Cc: shemminger@vyatta.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 drivers/net/irda/donauboe.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/irda/donauboe.c b/drivers/net/irda/donauboe.c
index 687c2d5..6f3e7f7 100644
--- a/drivers/net/irda/donauboe.c
+++ b/drivers/net/irda/donauboe.c
@@ -1194,13 +1194,13 @@ toshoboe_interrupt (int irq, void *dev_id)
               txp = txpc;
               txpc++;
               txpc %= TX_SLOTS;
-              self->stats.tx_packets++;
+              self->netdev->stats.tx_packets++;
               if (self->ring->tx[txpc].control & OBOE_CTL_TX_HW_OWNS)
                   self->ring->tx[txp].control &= ~OBOE_CTL_TX_RTCENTX;
             }
-          self->stats.tx_packets--;
+          self->netdev->stats.tx_packets--;
 #else
-          self->stats.tx_packets++;
+          self->netdev->stats.tx_packets++;
 #endif
           toshoboe_start_DMA(self, OBOE_CONFIG0H_ENTX);
         }
@@ -1280,7 +1280,7 @@ dumpbufs(self->rx_bufs[self->rxs],len,'<');
                       skb_put (skb, len);
                       skb_copy_to_linear_data(skb, self->rx_bufs[self->rxs],
 					      len);
-                      self->stats.rx_packets++;
+                      self->netdev->stats.rx_packets++;
                       skb->dev = self->netdev;
                       skb_reset_mac_header(skb);
                       skb->protocol = htons (ETH_P_IRDA);
