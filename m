Return-Path: <linux-kernel-owner+w=401wt.eu-S1763918AbYEYKaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763918AbYEYKaq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 06:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761878AbYEYKYV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 06:24:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43341 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762586AbYEYKYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 06:24:14 -0400
In-Reply-To: <1211708969@pmac.infradead.org>
References: <1211708969@pmac.infradead.org>
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: [PATCHv2 09/28] vx: treat firmware data as const
Message-Id: <E1K0DO6-0007DM-Ct@shinybook.infradead.org>
Date: Sun, 25 May 2008 11:23:38 +0100
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 sound/drivers/vx/vx_core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/drivers/vx/vx_core.c b/sound/drivers/vx/vx_core.c
index 9953886..585af2e 100644
--- a/sound/drivers/vx/vx_core.c
+++ b/sound/drivers/vx/vx_core.c
@@ -453,7 +453,7 @@ int snd_vx_load_boot_image(struct vx_core *chip, const struct firmware *boot)
 			vx_outb(chip, TXM, 0);
 			vx_outb(chip, TXL, 0);
 		} else {
-			unsigned char *image = boot->data + i;
+			const unsigned char *image = boot->data + i;
 			if (vx_wait_isr_bit(chip, ISR_TX_EMPTY) < 0) {
 				snd_printk(KERN_ERR "dsp boot failed at %d\n", i);
 				return -EIO;
@@ -671,7 +671,7 @@ int snd_vx_dsp_load(struct vx_core *chip, const struct firmware *dsp)
 	unsigned int i;
 	int err;
 	unsigned int csum = 0;
-	unsigned char *image, *cptr;
+	const unsigned char *image, *cptr;
 
 	snd_assert(dsp->size % 3 == 0, return -EINVAL);
 
-- 
1.5.4.5

