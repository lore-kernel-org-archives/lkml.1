Return-Path: <linux-kernel-owner+w=401wt.eu-S1765269AbYBNBrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765269AbYBNBrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 20:47:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751018AbYBNBrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 20:47:11 -0500
Received: from deeprooted.net ([216.254.16.51]:60968 "EHLO paris.hilman.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750927AbYBNBrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 20:47:10 -0500
X-Greylist: delayed 682 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 20:47:10 EST
From: Kevin Hilman <khilman@mvista.com>
To: linux-rt-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Kevin Hilman <khilman@mvista.com>
Subject: [PATCH 2.6.24-rt1] SMC91x: Use special_lock when CONFIG_PREEMPT_[HARD|SOFT]IRQS
Date: Wed, 13 Feb 2008 17:35:46 -0800
Message-Id: <1202952946-10511-1-git-send-email-khilman@mvista.com>
X-Mailer: git-send-email 1.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The smc_special_locks should also be used when either softIRQs or hard
IRQs are preempted which may lead to the same problems as under SMP.

Signed-off-by: Kevin Hilman <khilman@mvista.com>

---
 drivers/net/smc91x.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
index f198c49..be62616 100644
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -530,7 +530,8 @@ static inline void  smc_rcv(struct net_device *dev)
 	}
 }
 
-#ifdef CONFIG_SMP
+#if defined(CONFIG_SMP) ||						\
+    defined(CONFIG_PREEMPT_SOFTIRQS) || defined(CONFIG_PREEMPT_HARDIRQS)
 /*
  * On SMP we have the following problem:
  *
-- 
1.5.4

