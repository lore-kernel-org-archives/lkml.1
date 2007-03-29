Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbXC2MIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbXC2MIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 08:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbXC2MIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 08:08:45 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43310 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXC2MIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 08:08:44 -0400
Subject: Re: [v4l-dvb-maintainer] [2.6 patch]
	drivers/media/video/bt8xx/bttv-cards.c: fix off-by-one
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: v4l-dvb-maintainer@linuxtv.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070326040855.GA16477@stusta.de>
References: <20070326040855.GA16477@stusta.de>
Content-Type: multipart/mixed; boundary="=-VCNod2aXGxmOYv4/6+mx"
Date: Thu, 29 Mar 2007 09:08:21 -0300
Message-Id: <1175170101.4453.47.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0-1mdv2007.0 
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VCNod2aXGxmOYv4/6+mx
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Hi Adrian,

Em Seg, 2007-03-26 às 06:08 +0200, Adrian Bunk escreveu:
> This patch fixes an off-by-one error spotted by the Coverity checker.

Thanks for pointing us about this. Instead of your patch, however, it is
better to replace all magic numbers at for on all gpiomask stuff. This
will avoid future troubles if this array have any changes on its size.

I'm enclosing a patch doing this fix.
 
Cheers,
Mauro

--=-VCNod2aXGxmOYv4/6+mx
Content-Disposition: attachment; filename=5476.patch
Content-Type: text/x-patch; name=5476.patch; charset=utf-8
Content-Transfer-Encoding: 7bit

Changeset: 5476
From: Mauro Carvalho Chehab  <mchehab@infradead.org>
Commiter: Mauro Carvalho Chehab <mchehab@infradead.org>
Date: Wed Mar 28 22:37:20 2007 -0300
Subject: Fix gpiomux array size

there were several "magic" for loops, addressing gpiomux array size (4).
Adrian Bunk showed that one of the loops were wrong, going from 0 to 4.
This patch provides the right fix for this trouble, by using ARRAY_SIZE
on all places where we have a for loop using gpiomux.
Thanks to Adrian Bunk <bunk@stusta.de> for pointing me about this trouble.

Signed-off-by: Mauro Carvalho Chehab <mchehab@infradead.org>
---

diff -upNr oldtree/drivers/media/video/bt8xx/bttv-cards.c linux/drivers/media/video/bt8xx/bttv-cards.c
--- oldtree/drivers/media/video/bt8xx/bttv-cards.c	2007-03-29 09:00:15.000000000 -0300
+++ linux/drivers/media/video/bt8xx/bttv-cards.c	2007-03-29 09:00:12.000000000 -0300
@@ -2970,20 +2970,20 @@ void __devinit bttv_idcard(struct bttv *
 
 	if (UNSET != audiomux[0]) {
 		gpiobits = 0;
-		for (i = 0; i < 4; i++) {
+		for (i = 0; i < ARRAY_SIZE(bttv_tvcards->gpiomux); i++) {
 			bttv_tvcards[btv->c.type].gpiomux[i] = audiomux[i];
 			gpiobits |= audiomux[i];
 		}
 	} else {
 		gpiobits = audioall;
-		for (i = 0; i < 4; i++) {
+		for (i = 0; i < ARRAY_SIZE(bttv_tvcards->gpiomux); i++) {
 			bttv_tvcards[btv->c.type].gpiomux[i] = audioall;
 		}
 	}
 	bttv_tvcards[btv->c.type].gpiomask = (UNSET != gpiomask) ? gpiomask : gpiobits;
 	printk(KERN_INFO "bttv%d: gpio config override: mask=0x%x, mux=",
 	       btv->c.nr,bttv_tvcards[btv->c.type].gpiomask);
-	for (i = 0; i < 5; i++) {
+	for (i = 0; i < ARRAY_SIZE(bttv_tvcards->gpiomux); i++) {
 		printk("%s0x%x", i ? "," : "", bttv_tvcards[btv->c.type].gpiomux[i]);
 	}
 	printk("\n");

--=-VCNod2aXGxmOYv4/6+mx--

