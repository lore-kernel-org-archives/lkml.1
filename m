Return-Path: <linux-kernel-owner+w=401wt.eu-S933141AbXAWWMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141AbXAWWMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 17:12:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933135AbXAWWMT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 17:12:19 -0500
Received: from www.osadl.org ([213.239.205.134]:35810 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933134AbXAWWAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 17:00:47 -0500
Message-Id: <20070123211203.579103000@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
Date: Tue, 23 Jan 2007 22:01:01 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       John Stultz <johnstul@us.ibm.com>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
Subject: [patch 06/46] Fix timeout overflow with jiffies
Content-Disposition: inline; filename=gtod-fix-timeout-overflow.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>

Prevent timeout overflow if timer ticks are behind jiffies (due to high
softirq load or due to dyntick), by limiting the valid timeout range to
MAX_LONG/2.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/jiffies.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.20-rc4-mm1-bo/include/linux/jiffies.h
===================================================================
--- linux-2.6.20-rc4-mm1-bo.orig/include/linux/jiffies.h
+++ linux-2.6.20-rc4-mm1-bo/include/linux/jiffies.h
@@ -142,13 +142,13 @@ static inline u64 get_jiffies_64(void)
  *
  * And some not so obvious.
  *
- * Note that we don't want to return MAX_LONG, because
+ * Note that we don't want to return LONG_MAX, because
  * for various timeout reasons we often end up having
  * to wait "jiffies+1" in order to guarantee that we wait
  * at _least_ "jiffies" - so "jiffies+1" had better still
  * be positive.
  */
-#define MAX_JIFFY_OFFSET ((~0UL >> 1)-1)
+#define MAX_JIFFY_OFFSET ((LONG_MAX >> 1)-1)
 
 /*
  * We want to do realistic conversions of time so we need to use the same

--

