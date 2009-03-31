Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbZCaX3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbZCaX3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762417AbZCaXUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:20:45 -0400
Received: from sous-sol.org ([216.99.217.87]:33190 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762446AbZCaXUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:20:44 -0400
Message-Id: <20090331231505.211392032@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:00 -0700
From: Chris Wright <chrisw@sous-sol.org>
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
       alan@lxorguk.ukuu.org.uk, "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       John W Linville <linville@tuxdriver.com>
Subject: [patch 15/45] ath9k: downgrade xmit queue full message to xmit debug
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=ath9k-downgrade-xmit-queue-full-message-to-xmit-debug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Luis R. Rodriguez <lrodriguez@atheros.com>

upstream commit: c117fa0bf5f5b3d362b590ed6e80499defe14505

This is not a fatal message, hitting it simply means we're
going to tell the upper layers to slow their horses down but
as we make more descriptors available we let the show continue
by waking up the queues in ath_wake_mac80211_queue().

We downgrade this as otherwise we fill up your kernel log with
messages which can be common under heavy traffic.

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/wireless/ath9k/xmit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -2035,7 +2035,7 @@ struct ath_txq *ath_test_get_txq(struct 
 
 	/* Try to avoid running out of descriptors */
 	if (txq->axq_depth >= (ATH_TXBUF - 20)) {
-		DPRINTF(sc, ATH_DBG_FATAL,
+		DPRINTF(sc, ATH_DBG_XMIT,
 			"TX queue: %d is full, depth: %d\n",
 			qnum, txq->axq_depth);
 		ieee80211_stop_queue(sc->hw, skb_get_queue_mapping(skb));

