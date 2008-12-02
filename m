Return-Path: <linux-kernel-owner+w=401wt.eu-S1754551AbYLBUwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551AbYLBUwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYLBUvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:51:41 -0500
Received: from mail.atheros.com ([12.36.123.2]:24771 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082AbYLBUvg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:51:36 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <stable@kernel.org>
CC: <ath9k-devel@venema.h4ckr.net>, <linux-wireless@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <sfr@canb.auug.org.au>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bennyam Malavazi <Bennyam.Malavazi@atheros.com>
Subject: [PATCH] ath9k: correct expected max RX buffer size
Date: Tue, 2 Dec 2008 12:51:21 -0800
Message-ID: <1228251082-11677-3-git-send-email-lrodriguez@atheros.com>
X-Mailer: git-send-email 1.5.6.rc2.15.g457bb.dirty
In-Reply-To: <1228251082-11677-2-git-send-email-lrodriguez@atheros.com>
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
 <1228251082-11677-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should only tell the hardware its capable of DMA'ing
to us only what we asked dev_alloc_skb(). Prior to this
it is possible a large RX'd frame could have corrupted
DMA data but for us but we were saved only because we
were previously also pci_map_single()'ing the same large
value. The issue prior to this though was we were unmapping
a smaller amount which the prior DMA patch fixed.

Signed-off-by: Bennyam Malavazi <Bennyam.Malavazi@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/recv.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/recv.c b/drivers/net/wireless/ath9k/recv.c
index 4d23827..0941589 100644
--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -52,7 +52,7 @@ static void ath_rx_buf_link(struct ath_softc *sc, struct ath_buf *bf)
 	/* setup rx descriptors */
 	ath9k_hw_setuprxdesc(ah,
 			     ds,
-			     skb_tailroom(skb),   /* buffer size */
+			     sc->sc_rxbufsize,
 			     0);
 
 	if (sc->sc_rxlink == NULL)
-- 
1.5.6.rc2.15.g457bb.dirty

