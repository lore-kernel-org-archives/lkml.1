Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640AbZAaLRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbZAaLRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 06:17:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbZAaLRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 06:17:31 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:34033 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbZAaLRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 06:17:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=bGuMgnv1wMiB7jU0j67xRn/0If+3nR0KzPNjKY5KFl/WEH+50c29GkMfyK9BN4iwbv
         KS6IjdAEbCATHTfjsLMXRuxTQBAqlFCAoU2IVc8EOKjZupJuuEhqHGcsuC/In6dgbrlb
         raZA8KF9FH4reSvV8wexOUKXLe53cxwMGq27A=
Message-ID: <49843348.4080109@gmail.com>
Date: Sat, 31 Jan 2009 12:17:28 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: perex@perex.cz, tiwai@suse.de
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] alsa: time reaches -1, tested 0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a postfix decrement time will reach -1 rather than 0,
so the warning will not be issued.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/sound/pci/intel8x0.c b/sound/pci/intel8x0.c
index 19d3391..e900cdc 100644
--- a/sound/pci/intel8x0.c
+++ b/sound/pci/intel8x0.c
@@ -617,7 +617,7 @@ static int snd_intel8x0_ali_codec_semaphore(struct intel8x0 *chip)
 	int time = 100;
 	if (chip->buggy_semaphore)
 		return 0; /* just ignore ... */
-	while (time-- && (igetdword(chip, ICHREG(ALI_CAS)) & ALI_CAS_SEM_BUSY))
+	while (--time && (igetdword(chip, ICHREG(ALI_CAS)) & ALI_CAS_SEM_BUSY))
 		udelay(1);
 	if (! time && ! chip->in_ac97_init)
 		snd_printk(KERN_WARNING "ali_codec_semaphore timeout\n");
