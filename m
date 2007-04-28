Return-Path: <linux-kernel-owner+w=401wt.eu-S1161219AbXD1TVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161219AbXD1TVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161029AbXD1TVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:21:48 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37528 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031176AbXD1TVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:21:20 -0400
Date: Sat, 28 Apr 2007 21:21:31 +0200
From: Adrian Bunk <bunk@stusta.de>
To: perex@suse.cz, Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] sound/pcmcia/vx/vxpocket.c: fix an if() condition
Message-ID: <20070428192131.GY3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It seems noone ever tried to use this driver with more than one device.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc7-mm2/sound/pcmcia/vx/vxpocket.c.old	2007-04-28 18:17:55.000000000 +0200
+++ linux-2.6.21-rc7-mm2/sound/pcmcia/vx/vxpocket.c	2007-04-28 18:19:34.000000000 +0200
@@ -297,7 +297,7 @@ static int vxpocket_probe(struct pcmcia_
 
 	/* find an empty slot from the card list */
 	for (i = 0; i < SNDRV_CARDS; i++) {
-		if (! card_alloc & (1 << i))
+		if (!(card_alloc & (1 << i)))
 			break;
 	}
 	if (i >= SNDRV_CARDS) {

