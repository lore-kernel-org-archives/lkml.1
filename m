Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbYGOPqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbYGOPqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 11:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYGOPqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 11:46:36 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:59196 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbYGOPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 11:46:35 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 2/5] Ath5k: kill tasklets on shutdown
Date: Tue, 15 Jul 2008 17:44:19 +0200
Message-Id: <1216136661-10930-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't forget to kill tasklets on stop to not panic if they
fire after freeing some structures.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index e9ec284..4d9ff97 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2343,6 +2343,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	mutex_unlock(&sc->lock);
 
 	del_timer_sync(&sc->calib_tim);
+	tasklet_kill(&sc->rxtq);
+	tasklet_kill(&sc->txtq);
+	tasklet_kill(&sc->restq);
 
 	return ret;
 }
-- 
1.5.6.2

