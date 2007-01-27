Return-Path: <linux-kernel-owner+w=401wt.eu-S1752155AbXA0AkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752155AbXA0AkX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 19:40:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751688AbXA0AkX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 19:40:23 -0500
Received: from bohr.gbar.dtu.dk ([192.38.95.24]:48606 "HELO bohr.gbar.dtu.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752155AbXA0AkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 19:40:22 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Jan 2007 19:40:21 EST
From: "Peter Eriksen" <s022018@student.dtu.dk>
Date: Sat, 27 Jan 2007 01:33:38 +0100
To: linux-kernel@vger.kernel.org
Cc: Jaroslav Kysela <perex@suse.cz>
Subject: [PATCH] sound/isa/gus/gus_main.c: Use abs() instead of x < 0 ? -x : x.
Message-ID: <20070127003338.GA236@bohr.gbar.dtu.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Eriksen <s022018@student.dtu.dk>
---
There are only a few places using the conditional operator in the
meaning of the absolute value, and this is is one such place.

Compile tested only.

 sound/isa/gus/gus_main.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/isa/gus/gus_main.c b/sound/isa/gus/gus_main.c
index b680fdd..8ced5e8 100644
--- a/sound/isa/gus/gus_main.c
+++ b/sound/isa/gus/gus_main.c
@@ -294,10 +294,10 @@ static int snd_gus_init_dma_irq(struct snd_gus_card * gus, int latches)
 		gus->mix_cntrl_reg |= 4;	/* enable MIC */
 	}
 	dma1 = gus->gf1.dma1;
-	dma1 = dma1 < 0 ? -dma1 : dma1;
+	dma1 = abs(dma1);
 	dma1 = dmas[dma1 & 7];
 	dma2 = gus->gf1.dma2;
-	dma2 = dma2 < 0 ? -dma2 : dma2;
+	dma2 = abs(dma2);
 	dma2 = dmas[dma2 & 7];
 	dma1 |= gus->equal_dma ? 0x40 : (dma2 << 3);
 
@@ -306,7 +306,7 @@ static int snd_gus_init_dma_irq(struct snd_gus_card * gus, int latches)
 		return -EINVAL;
 	}
 	irq = gus->gf1.irq;
-	irq = irq < 0 ? -irq : irq;
+	irq = abs(irq);
 	irq = irqs[irq & 0x0f];
 	if (irq == 0) {
 		snd_printk(KERN_ERR "Error! IRQ isn't defined.\n");
-- 
1.5.0.rc2.g19605-dirty

