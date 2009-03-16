Return-Path: <linux-kernel-owner+w=401wt.eu-S1757436AbZCPKCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbZCPKCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 06:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZCPKBz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 06:01:55 -0400
Received: from norkia.v3.sk ([92.240.234.41]:42079 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbZCPKBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 06:01:54 -0400
Subject: [PATCH] Fix NULL dereference when suspending snd_opl3sa2
From: Lubomir Rintel <lkundrak@v3.sk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-sound@vger.kernel.org
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>, stable@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 11:01:49 +0100
Message-Id: <1237197709.7210.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should fix the following OOPS:
http://www.kerneloops.org/raw.php?rawid=80591&msgid=

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 sound/isa/opl3sa2.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
index 58c972b..483c284 100644
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -553,7 +553,8 @@ static int snd_opl3sa2_suspend(struct snd_card
*card, pm_message_t state)
 	struct snd_opl3sa2 *chip = card->private_data;
 
 	snd_power_change_state(card, SNDRV_CTL_POWER_D3hot);
-	chip->wss->suspend(chip->wss);
+	if (chip->wss->suspend)
+		chip->wss->suspend(chip->wss);
 	/* power down */
 	snd_opl3sa2_write(chip, OPL3SA2_PM_CTRL, OPL3SA2_PM_D3);
 
-- 
1.5.5.6



