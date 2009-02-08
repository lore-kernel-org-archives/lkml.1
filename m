Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbZBHOWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbZBHOWk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 09:22:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZBHOWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 09:22:32 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:56214 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbZBHOWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 09:22:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=TGW5ega398vsrEvIWb0xwBkt0984Ork6x6zagxtqjqlygnPF1noP1zKu1Ba9F0Zdcw
         YBJk7cYRJKdChd7tvvs9bPFniWhWASdf2Mt7FefjEwC0XEU7KF8G8MQNzY7zLdEZrX3s
         Svx/lwHe50zyvBfqJ2QghXVstn6aUT7cqkqOk=
Message-ID: <498EEAA1.6060105@gmail.com>
Date: Sun, 08 Feb 2009 15:22:25 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: khilman@mvista.com, rmk+kernel@arm.linux.org.uk
CC: Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: timeout will reach -1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a postfix decrement the timeout will reach -1 rather than 0,
so the warning will not be issued.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/sound/arm/aaci.c b/sound/arm/aaci.c
index 89096e8..772901e 100644
--- a/sound/arm/aaci.c
+++ b/sound/arm/aaci.c
@@ -90,7 +90,7 @@ static void aaci_ac97_write(struct snd_ac97 *ac97, unsigned short reg,
 	 */
 	do {
 		v = readl(aaci->base + AACI_SLFR);
-	} while ((v & (SLFR_1TXB|SLFR_2TXB)) && timeout--);
+	} while ((v & (SLFR_1TXB|SLFR_2TXB)) && --timeout);
 
 	if (!timeout)
 		dev_err(&aaci->dev->dev,
@@ -126,7 +126,7 @@ static unsigned short aaci_ac97_read(struct snd_ac97 *ac97, unsigned short reg)
 	 */
 	do {
 		v = readl(aaci->base + AACI_SLFR);
-	} while ((v & SLFR_1TXB) && timeout--);
+	} while ((v & SLFR_1TXB) && --timeout);
 
 	if (!timeout) {
 		dev_err(&aaci->dev->dev, "timeout on slot 1 TX busy\n");
@@ -147,7 +147,7 @@ static unsigned short aaci_ac97_read(struct snd_ac97 *ac97, unsigned short reg)
 	do {
 		cond_resched();
 		v = readl(aaci->base + AACI_SLFR) & (SLFR_1RXV|SLFR_2RXV);
-	} while ((v != (SLFR_1RXV|SLFR_2RXV)) && timeout--);
+	} while ((v != (SLFR_1RXV|SLFR_2RXV)) && --timeout);
 
 	if (!timeout) {
 		dev_err(&aaci->dev->dev, "timeout on RX valid\n");

