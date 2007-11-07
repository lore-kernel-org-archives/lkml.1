Return-Path: <linux-kernel-owner+w=401wt.eu-S1758141AbXKGSei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141AbXKGSei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 13:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752151AbXKGSea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 13:34:30 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:42872 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357AbXKGSea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 13:34:30 -0500
Message-ID: <47320533.4020400@tiscali.nl>
Date: Wed, 07 Nov 2007 19:34:27 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix incorrect test in trident_ac97_set(); sound/oss/trident.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If count reaches zero, the loop ends, but the postfix decrement subtracts it.
so, testing for 'count == 0' will not work.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/sound/oss/trident.c b/sound/oss/trident.c
index 96adc47..94b5fb4 100644
--- a/sound/oss/trident.c
+++ b/sound/oss/trident.c
@@ -2939,7 +2939,7 @@ trident_ac97_set(struct ac97_codec *codec, u8 reg, u16 val)
 
 	data |= (mask | (reg & AC97_REG_ADDR));
 
-	if (count == 0) {
+	if (count == -1) {
 		printk(KERN_ERR "trident: AC97 CODEC write timed out.\n");
 		spin_unlock_irqrestore(&card->lock, flags);
 		return;
@@ -2999,7 +2999,7 @@ trident_ac97_get(struct ac97_codec *codec, u8 reg)
 	} while (count--);
 	spin_unlock_irqrestore(&card->lock, flags);
 
-	if (count == 0) {
+	if (count == -1) {
 		printk(KERN_ERR "trident: AC97 CODEC read timed out.\n");
 		data = 0;
 	}

