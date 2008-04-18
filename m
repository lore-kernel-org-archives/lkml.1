Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbYDRXYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbYDRXYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 19:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYDRXW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 19:22:59 -0400
Received: from havoc.gtf.org ([69.61.125.42]:53854 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbYDRXWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 19:22:50 -0400
Message-Id: <633e3f1106fd888b93a0f18c73449fd86054cc05.1208559659.git.jgarzik@redhat.com>
In-Reply-To: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
References: <d7afbccda111e535bb14ad8082b208c7a2cd9833.1208559659.git.jgarzik@redhat.com>
To: vitb@kernel.crashing.org, linuxppc-dev@ozlabs.org
From: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 04/15] [PPC] minor irq handler cleanups
Date: Fri, 18 Apr 2008 19:22:49 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- whitespace cleanups

- remove pointless prototype (uses always follow func implementation)

- 'irq' argument is often used purely as a local variable.  rename
  argument to 'dummy' and define 'irq' as local to make this plain.

- remove pointless casts from void*

This change's main purpose is to prepare for the patchset in
jgarzik/misc-2.6.git#irq-remove, that explores removal of the
never-used 'irq' argument in each interrupt handler.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---
 arch/ppc/8xx_io/fec.c        |    3 +--
 arch/ppc/platforms/sbc82xx.c |    4 +++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/ppc/8xx_io/fec.c b/arch/ppc/8xx_io/fec.c
index 11b0aa6..d7b7ba9 100644
--- a/arch/ppc/8xx_io/fec.c
+++ b/arch/ppc/8xx_io/fec.c
@@ -199,7 +199,6 @@ static int fec_enet_start_xmit(struct sk_buff *skb, struct net_device *dev);
 #ifdef	CONFIG_USE_MDIO
 static void fec_enet_mii(struct net_device *dev);
 #endif	/* CONFIG_USE_MDIO */
-static irqreturn_t fec_enet_interrupt(int irq, void * dev_id);
 #ifdef CONFIG_FEC_PACKETHOOK
 static void  fec_enet_tx(struct net_device *dev, __u32 regval);
 static void  fec_enet_rx(struct net_device *dev, __u32 regval);
@@ -472,7 +471,7 @@ fec_timeout(struct net_device *dev)
  * This is called from the MPC core interrupt.
  */
 static	irqreturn_t
-fec_enet_interrupt(int irq, void * dev_id)
+fec_enet_interrupt(int irq, void *dev_id)
 {
 	struct	net_device *dev = dev_id;
 	volatile fec_t	*fecp;
diff --git a/arch/ppc/platforms/sbc82xx.c b/arch/ppc/platforms/sbc82xx.c
index cc0935c..0df6aac 100644
--- a/arch/ppc/platforms/sbc82xx.c
+++ b/arch/ppc/platforms/sbc82xx.c
@@ -121,8 +121,10 @@ struct hw_interrupt_type sbc82xx_i8259_ic = {
 	.end = sbc82xx_i8259_end_irq,
 };
 
-static irqreturn_t sbc82xx_i8259_demux(int irq, void *dev_id)
+static irqreturn_t sbc82xx_i8259_demux(int dummy, void *dev_id)
 {
+	int irq;
+
 	spin_lock(&sbc82xx_i8259_lock);
 
 	sbc82xx_i8259_map[0] = 0x0c;	/* OCW3: Read IR register on RD# pulse */
-- 
1.5.4.1

