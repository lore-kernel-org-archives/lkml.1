Return-Path: <linux-kernel-owner+w=401wt.eu-S1764573AbZCaXdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764573AbZCaXdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 19:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763753AbZCaXVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 19:21:13 -0400
Received: from sous-sol.org ([216.99.217.87]:33233 "EHLO x200.localdomain"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763629AbZCaXVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 19:21:08 -0400
Message-Id: <20090331231541.807363680@sous-sol.org>
User-Agent: quilt/0.47-1
Date: Tue, 31 Mar 2009 16:11:05 -0700
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
       alan@lxorguk.ukuu.org.uk, Bob Copeland <me@bobcopeland.com>,
       John W Linville <linville@tuxdriver.com>
Subject: [patch 20/45] ath5k: disable MIB interrupts
References: <20090331231045.719396245@sous-sol.org>
Content-Disposition: inline; filename=ath5k-disable-mib-interrupts.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Bob Copeland <me@bobcopeland.com>

upstream commit: 9ca9fb8aa8422595956af9681518cdb8b167055e

The MIB interrupt fires whenever counters overflow; however without
support for automatic noise immunity, we can sometimes get an interrupt
storm.  The get_stats() callback reads the counters anyway so we can
disable the interrupt for now until ANI is implemented.  This fixes
the issue reported in http://bugzilla.kernel.org/show_bug.cgi?id=12647.

Changes-licensed-under: 3-Clause-BSD

Cc: stable@kernel.org
Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/wireless/ath5k/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2259,7 +2259,7 @@ ath5k_init(struct ath5k_softc *sc, bool 
 	sc->curband = &sc->sbands[sc->curchan->band];
 	sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
 		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
-		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_MIB;
+		AR5K_INT_FATAL | AR5K_INT_GLOBAL;
 	ret = ath5k_reset(sc, false, false);
 	if (ret)
 		goto done;

