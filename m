Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYHDJmt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYHDJmt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 05:42:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750965AbYHDJml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 05:42:41 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:44825 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYHDJmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 05:42:40 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: stable@kernel.org
Cc: greg@kroah.com, chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/2] Ath5k: kill tasklets on shutdown
Date: Mon,  4 Aug 2008 11:37:08 +0200
Message-Id: <1217842628-22714-2-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.6.2
In-Reply-To: <1217842628-22714-1-git-send-email-jirislaby@gmail.com>
References: <1217842628-22714-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't forget to kill tasklets on stop to not panic if they
fire after freeing some structures.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath5k/base.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index ed51c4a..c5bf8a2 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2342,6 +2342,9 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	mutex_unlock(&sc->lock);
 
 	del_timer_sync(&sc->calib_tim);
+	tasklet_kill(&sc->rxtq);
+	tasklet_kill(&sc->txtq);
+	tasklet_kill(&sc->restq);
 
 	return ret;
 }
-- 
1.5.6.2

