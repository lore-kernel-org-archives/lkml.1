Return-Path: <linux-kernel-owner+w=401wt.eu-S1760269AbZIPWfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760269AbZIPWfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 18:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757619AbZIPWc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 18:32:58 -0400
Received: from kroah.org ([198.145.64.141]:40919 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757572AbZIPWc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 18:32:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Sep 16 15:29:01 2009
Message-Id: <20090916222901.250338017@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 15:28:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bob Copeland <me@bobcopeland.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 04/24] ath5k: write PCU registers on initial reset
References: <20090916222819.244332644@mini.kroah.org>
Content-Disposition: inline; filename=ath5k-write-pcu-registers-on-initial-reset.patch
In-Reply-To: <20090916222934.GA31846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Bob Copeland <me@bobcopeland.com>

commit 3355443ad7601991affa5992b0d53870335af765 upstream.

"Ath5k: unify resets"
introduced a regression into 2.6.28 where the PCU registers are never
initialized, due to ath5k_reset() always passing true for change_channel.
We subsequently program a lot of these registers but several may start
in an unknown state.

Reported-by: Forrest Zhang <forrest@hifulltech.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath5k/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2623,7 +2623,7 @@ ath5k_reset(struct ath5k_softc *sc, stru
 		sc->curchan = chan;
 		sc->curband = &sc->sbands[chan->band];
 	}
-	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
+	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan != NULL);
 	if (ret) {
 		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
 		goto err;


