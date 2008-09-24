Return-Path: <linux-kernel-owner+w=401wt.eu-S1753302AbYIXXSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302AbYIXXSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 19:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYIXXSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 19:18:09 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40142 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbYIXXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 19:18:07 -0400
Date: Wed, 24 Sep 2008 19:17:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: pull request: wireless-2.6 2008-09-24
Message-ID: <20080924231720.GD3639@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

One more for 2.6.27 -- a fix for a possible interrupt storm.  There is
even a link in the commit log to a youtube video of the storm in
progress. :-)

Let me know if there are problems!

John

---

Individual patch is available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/

---

The following changes since commit 4c07ab0fe4b4eaa0fc31f640ca65da7c173f5043:
  David S. Miller (1):
        Merge branch 'master' of git://git.kernel.org/.../linville/wireless-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git master

Luis R. Rodriguez (1):
      ath9k: disable MIB interrupts to fix interrupt storm

 drivers/net/wireless/ath9k/core.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.c b/drivers/net/wireless/ath9k/core.c
index c049593..87e37bc 100644
--- a/drivers/net/wireless/ath9k/core.c
+++ b/drivers/net/wireless/ath9k/core.c
@@ -795,6 +795,12 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	if (ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
 		sc->sc_imask |= ATH9K_INT_CST;
 
+	/* Note: We disable MIB interrupts for now as we don't yet
+	 * handle processing ANI, otherwise you will get an interrupt
+	 * storm after about 7 hours of usage making the system unusable
+	 * with huge latency. Once we do have ANI processing included
+	 * we can re-enable this interrupt. */
+#if 0
 	/*
 	 * Enable MIB interrupts when there are hardware phy counters.
 	 * Note we only do this (at the moment) for station mode.
@@ -802,6 +808,7 @@ int ath_open(struct ath_softc *sc, struct ath9k_channel *initial_chan)
 	if (ath9k_hw_phycounters(ah) &&
 	    ((sc->sc_opmode == ATH9K_M_STA) || (sc->sc_opmode == ATH9K_M_IBSS)))
 		sc->sc_imask |= ATH9K_INT_MIB;
+#endif
 	/*
 	 * Some hardware processes the TIM IE and fires an
 	 * interrupt when the TIM bit is set.  For hardware
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
