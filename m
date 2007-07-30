Return-Path: <linux-kernel-owner+w=401wt.eu-S1761385AbXG3Wpc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761385AbXG3Wpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:45:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753117AbXG3WpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:45:18 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34684 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbXG3WpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:45:16 -0400
Date: Tue, 31 Jul 2007 04:27:32 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Petko Manolov <petkan@users.sourceforge.net>
Subject: Re: [git patches] net driver fixes
In-Reply-To: <46AE6861.50004@garzik.org>
Message-ID: <alpine.LFD.0.999.0707310425360.17287@enigma.security.iitk.ac.in>
References: <20070730212333.GA8049@havoc.gtf.org>
 <alpine.LFD.0.999.0707310349460.17287@enigma.security.iitk.ac.in>
 <46AE6861.50004@garzik.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Jeff Garzik wrote:

> true, we should just remove the dev==NULL check

Patch below:

[PATCH] nmclan_cs: Remove bogus (dev==NULL) check in mace_interrupt()

The (dev == NULL) check in drivers/net/pcmcia/nmclan_cs.c:mace_interrupt()
handler is always false, so let's remove it.

Signed-off-by: Satyam Sharma <satyam@infradead.org>

---

 drivers/net/pcmcia/nmclan_cs.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/pcmcia/nmclan_cs.c b/drivers/net/pcmcia/nmclan_cs.c
index 73da611..3446be9 100644
--- a/drivers/net/pcmcia/nmclan_cs.c
+++ b/drivers/net/pcmcia/nmclan_cs.c
@@ -1000,12 +1000,6 @@ static irqreturn_t mace_interrupt(int irq, void *dev_id)
   int status;
   int IntrCnt = MACE_MAX_IR_ITERATIONS;
 
-  if (dev == NULL) {
-    DEBUG(2, "mace_interrupt(): irq 0x%X for unknown device.\n",
-	  irq);
-    return IRQ_NONE;
-  }
-
   if (lp->tx_irq_disabled) {
     printk(
       (lp->tx_irq_disabled?
