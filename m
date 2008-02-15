Return-Path: <linux-kernel-owner+w=401wt.eu-S1765076AbYBOVBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765076AbYBOVBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 16:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758836AbYBOVAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 16:00:20 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:56106 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764318AbYBOVAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 16:00:18 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: linville@tuxdriver.com
Cc: <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
       ath5k-devel@lists.ath5k.org, Jiri Slaby <jirislaby@gmail.com>,
       Nick Kossifidis <mickflemm@gmail.com>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: [PATCH 3/3] WDEV: ath5k, typecheck on nonDEBUG
Date: Fri, 15 Feb 2008 21:58:53 +0100
Message-Id: <1203109133-32217-3-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
References: <1203109133-32217-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At least type check the ATH5K_TRACE paramter on !ATH5K_DEBUG configs.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>
Cc: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/debug.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath5k/debug.h b/drivers/net/wireless/ath5k/debug.h
index c4fd8c4..44324c3 100644
--- a/drivers/net/wireless/ath5k/debug.h
+++ b/drivers/net/wireless/ath5k/debug.h
@@ -171,7 +171,9 @@ ath5k_debug_printtxbuf(struct ath5k_softc *sc,
 
 #else /* no debugging */
 
-#define ATH5K_TRACE(_sc) /* empty */
+#include <linux/compiler.h>
+
+#define ATH5K_TRACE(_sc) typecheck(struct ath5k_softc *, (_sc))
 
 static inline void __attribute__ ((format (printf, 3, 4)))
 ATH5K_DBG(struct ath5k_softc *sc, unsigned int m, const char *fmt, ...) {}
-- 
1.5.3.8

