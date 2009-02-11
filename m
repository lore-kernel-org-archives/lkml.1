Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbZBKXBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbZBKXBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 18:01:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757498AbZBKXBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 18:01:18 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:37370 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273AbZBKXBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 18:01:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=CEDKd2bF3Pz7kjwnQ95zRzsezZ+rPbofVG9u5gHIAzOUZkQwk+UUD0gCpqpfw9UArw
         dYDsQ5vH9Q1KDJqnMaXXueVPv/zFEdJO1yvz2ZYQ/78RNwjwnZ6pWNKtNwnI3vU9I1XX
         TxMbSlqjJG51jbQk4RB0JzNorBLKi7YxfzLDU=
Message-ID: <499358C2.1040902@gmail.com>
Date: Thu, 12 Feb 2009 00:01:22 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: rmk+kernel@arm.linux.org.uk
CC: Linux-arm <linux-arm-kernel@lists.arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
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


