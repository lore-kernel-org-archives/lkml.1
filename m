Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYGWLUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYGWLUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 07:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYGWLU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 07:20:28 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:45052 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYGWLU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 07:20:27 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 2/3] Ath5k: mask out unneeded interrupts
Date: Wed, 23 Jul 2008 13:17:34 +0200
Message-Id: <1216811855-9387-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1216811855-9387-1-git-send-email-jirislaby@gmail.com>
References: <1216811855-9387-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mask out previously demanded interrupt flags because we set
new ones. Don't allow mixing them after switch from sta to
ibss and vice versa.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 898a969..e636863 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2175,6 +2175,7 @@ ath5k_beacon_config(struct ath5k_softc *sc)
 
 	ath5k_hw_set_intr(ah, 0);
 	sc->bmisscount = 0;
+	sc->imask &= ~(AR5K_INT_BMISS | AR5K_INT_SWBA);
 
 	if (sc->opmode == IEEE80211_IF_TYPE_STA) {
 		sc->imask |= AR5K_INT_BMISS;
-- 
1.5.6.2

