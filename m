Return-Path: <linux-kernel-owner+w=401wt.eu-S1759529AbZBZWpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759529AbZBZWpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbZBZWpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:45:23 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:55041 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891AbZBZWpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:45:21 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net,
       linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/1] ath5k: fix hw rate index condition
Date: Thu, 26 Feb 2009 23:44:31 +0100
Message-Id: <1235688271-22346-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we print out a warning when the index is out of bounds,
i.e. even on hw_rix == AR5K_MAX_RATES.

Also change to WARN and print text with the reported hw_rix.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <lrodriguez@atheros.com>
Cc: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath5k/base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index c06d1cc..08d691d 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1100,7 +1100,8 @@ ath5k_mode_setup(struct ath5k_softc *sc)
 static inline int
 ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
 {
-	WARN_ON(hw_rix < 0 || hw_rix > AR5K_MAX_RATES);
+	WARN(hw_rix < 0 || hw_rix >= AR5K_MAX_RATES,
+			"hw_rix out of bounds: %x\n", hw_rix);
 	return sc->rate_idx[sc->curband->band][hw_rix];
 }
 
-- 
1.6.1.3

