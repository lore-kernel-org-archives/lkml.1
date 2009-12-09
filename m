Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbZLINkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbZLINkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 08:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755902AbZLINkB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 08:40:01 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:33778 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894AbZLINkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 08:40:00 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Nicolas Pitre <nico@fluxnic.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] smc91x: fix unused flags warnings on UP systems
Date: Wed,  9 Dec 2009 08:40:04 -0500
Message-Id: <1260366004-27366-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Local flags variables will be declared whenever these functions get used,
but obviously on UP systems the flags parameter won't be touched.  So add
some dummy ops that get optimized away anyways to satisfy gcc's warnings.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/net/smc91x.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
index ae4983a..b0c92b6 100644
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -534,9 +534,9 @@ static inline void  smc_rcv(struct net_device *dev)
 #define smc_special_lock(lock, flags)		spin_lock_irqsave(lock, flags)
 #define smc_special_unlock(lock, flags) 	spin_unlock_irqrestore(lock, flags)
 #else
-#define smc_special_trylock(lock, flags)	(1)
-#define smc_special_lock(lock, flags)   	do { } while (0)
-#define smc_special_unlock(lock, flags)	do { } while (0)
+#define smc_special_trylock(lock, flags)	(flags == flags)
+#define smc_special_lock(lock, flags)   	do { flags = 0; } while (0)
+#define smc_special_unlock(lock, flags)	do { flags = 0; } while (0)
 #endif
 
 /*
-- 
1.6.5.5

