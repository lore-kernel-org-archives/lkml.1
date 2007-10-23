Return-Path: <linux-kernel-owner+w=401wt.eu-S1756394AbXJWWky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394AbXJWWky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755796AbXJWWgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:54 -0400
Received: from havoc.gtf.org ([69.61.125.42]:32784 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755759AbXJWWgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:53 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org, perex@perex.cz
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 12/12] sound/isa: fix printk format
Message-Id: <20071023223647.5E49B1F81B8@havoc.gtf.org>
Date: Tue, 23 Oct 2007 18:36:47 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sound/isa/ad1848/ad1848_lib.c: In function ‘snd_ad1848_mce_down’:
sound/isa/ad1848/ad1848_lib.c:216: warning: format ‘%d’ expects type ‘int’, but argument 4 has type ‘long unsigned int’

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/sound/isa/ad1848/ad1848_lib.c b/sound/isa/ad1848/ad1848_lib.c
index a901cd1..9a64035 100644
--- a/sound/isa/ad1848/ad1848_lib.c
+++ b/sound/isa/ad1848/ad1848_lib.c
@@ -213,7 +213,7 @@ static void snd_ad1848_mce_down(struct snd_ad1848 *chip)
 	for (timeout = 12000; timeout > 0 && (inb(AD1848P(chip, REGSEL)) & AD1848_INIT); timeout--)
 		udelay(100);
 
-	snd_printdd("(1) timeout = %d\n", timeout);
+	snd_printdd("(1) timeout = %ld\n", timeout);
 
 #ifdef CONFIG_SND_DEBUG
 	if (inb(AD1848P(chip, REGSEL)) & AD1848_INIT)
