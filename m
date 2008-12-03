Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYLCUAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYLCUAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:00:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbYLCTwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:52:18 -0500
Received: from kroah.org ([198.145.64.141]:59747 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754070AbYLCTwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:52:16 -0500
Date: Wed, 3 Dec 2008 11:50:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, sfr@canb.auug.org.au,
       ath9k-devel@venema.h4ckr.net,
       "Luis R. Rodriguez" <lrodriguez@Atheros.com>,
       Bennyam Malavazi <Bennyam.Malavazi@Atheros.com>
Subject: [patch 026/104] ath9k: correct expected max RX buffer size
Message-ID: <20081203195037.GA8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ath9k-correct-expected-max-rx-buffer-size.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit b4b6cda2298b0c9a0af902312184b775b8867c65 upstream

We should only tell the hardware its capable of DMA'ing
to us only what we asked dev_alloc_skb(). Prior to this
it is possible a large RX'd frame could have corrupted
DMA data but for us but we were saved only because we
were previously also pci_map_single()'ing the same large
value. The issue prior to this though was we were unmapping
a smaller amount which the prior DMA patch fixed.

Signed-off-by: Bennyam Malavazi <Bennyam.Malavazi@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath9k/recv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath9k/recv.c
+++ b/drivers/net/wireless/ath9k/recv.c
@@ -52,7 +52,7 @@ static void ath_rx_buf_link(struct ath_s
 	/* setup rx descriptors */
 	ath9k_hw_setuprxdesc(ah,
 			     ds,
-			     skb_tailroom(skb),   /* buffer size */
+			     sc->sc_rxbufsize,
 			     0);
 
 	if (sc->sc_rxlink == NULL)

