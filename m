Return-Path: <linux-kernel-owner+w=401wt.eu-S1763562AbZGABGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763562AbZGABGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761533AbZGAAfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:19 -0400
Received: from kroah.org ([198.145.64.141]:60526 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760913AbZGAAfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:12 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:35 2009
Message-Id: <20090701002435.151808471@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:59 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sujith <Sujith.Manoharan@atheros.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 070/108] ath9k: Fix bug in checking HT flag
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=ath9k-fix-bug-in-checking-ht-flag.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sujith <Sujith.Manoharan@atheros.com>

commit db2f63f60a087ed29ae04310c1076c61f77a5d20 upstream.

The operating HT mode is stored in chanmode and
not channelFlags.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/calib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -883,7 +883,7 @@ bool ath9k_hw_calibrate(struct ath_hw *a
 static bool ar9285_clc(struct ath_hw *ah, struct ath9k_channel *chan)
 {
 	REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_CL_CAL_ENABLE);
-	if (chan->channelFlags & CHANNEL_HT20) {
+	if (IS_CHAN_HT20(chan)) {
 		REG_SET_BIT(ah, AR_PHY_CL_CAL_CTL, AR_PHY_PARALLEL_CAL_ENABLE);
 		REG_SET_BIT(ah, AR_PHY_TURBO, AR_PHY_FC_DYN2040_EN);
 		REG_CLR_BIT(ah, AR_PHY_AGC_CONTROL,


