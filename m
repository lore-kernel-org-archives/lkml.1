Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab0BICoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 21:44:21 -0500
Received: from mail-yw0-f189.google.com ([209.85.211.189]:52479 "EHLO
	mail-yw0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab0BICoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 21:44:18 -0500
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Cc: isdn@linux-pingi.de, sfr@canb.auug.org.au
Subject: [PATCH] w6692: remove unused code
Date: Tue,  9 Feb 2010 00:44:08 -0200
Message-Id: <1265683448-25892-1-git-send-email-padovan@profusion.mobi>
X-Mailer: git-send-email 1.6.0.6
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/isdn/hardware/mISDN/w6692.c:533: warning: ‘setvolume’ defined but not used
drivers/isdn/hardware/mISDN/w6692.c:560: warning: ‘enable_pots’ defined but not used
---
 drivers/isdn/hardware/mISDN/w6692.c |   43 -----------------------------------
 1 files changed, 0 insertions(+), 43 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/w6692.c b/drivers/isdn/hardware/mISDN/w6692.c
index d3f1077..ae1c65e 100644
--- a/drivers/isdn/hardware/mISDN/w6692.c
+++ b/drivers/isdn/hardware/mISDN/w6692.c
@@ -530,49 +530,6 @@ W6692_fill_Bfifo(struct w6692_ch *wch)
 }
 
 static int
-setvolume(struct w6692_ch *wch, int mic, struct sk_buff *skb)
-{
-	struct w6692_hw *card = wch->bch.hw;
-	u16 *vol = (u16 *)skb->data;
-	u8 val;
-
-	if ((!(card->fmask & pots)) ||
-	    !test_bit(FLG_TRANSPARENT, &wch->bch.Flags))
-		return -ENODEV;
-	if (skb->len < 2)
-		return -EINVAL;
-	if (*vol > 7)
-		return -EINVAL;
-	val = *vol & 7;
-	val = 7 - val;
-	if (mic) {
-		val <<= 3;
-		card->xaddr &= 0xc7;
-	} else {
-		card->xaddr &= 0xf8;
-	}
-	card->xaddr |= val;
-	WriteW6692(card, W_XADDR, card->xaddr);
-	return 0;
-}
-
-static int
-enable_pots(struct w6692_ch *wch)
-{
-	struct w6692_hw *card = wch->bch.hw;
-
-	if ((!(card->fmask & pots)) ||
-	    !test_bit(FLG_TRANSPARENT, &wch->bch.Flags))
-		return -ENODEV;
-	wch->b_mode |= W_B_MODE_EPCM | W_B_MODE_BSW0;
-	WriteW6692B(wch, W_B_MODE, wch->b_mode);
-	WriteW6692B(wch, W_B_CMDR, W_B_CMDR_RRST | W_B_CMDR_XRST);
-	card->pctl |= ((wch->bch.nr & 2) ? W_PCTL_PCX : 0);
-	WriteW6692(card, W_PCTL, card->pctl);
-	return 0;
-}
-
-static int
 disable_pots(struct w6692_ch *wch)
 {
 	struct w6692_hw *card = wch->bch.hw;
-- 
1.6.4.4

