Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbZGPG2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbZGPG2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756584AbZGPG2a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:28:30 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:63897 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbZGPG2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:28:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=t8CxWTaip/k6ZxMk5EBJgIxqGAsAX7o5r3d6WHE3vzrgo1zdQjhpq8nny8SrE/dVAi
         VO7XyXASSgXwo6jhJVNMT4z9OPptBVFQSa7CJqL7dRPWuwc+cg2N816AfHOP+klPsm8h
         pvGfSAcb2DVdKfqo3D4pD3T3Urnymn0nquvvU=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/7] sched: Remove the CONFIG_PREEMPT_BKL case definition of cond_resched()
Date: Thu, 16 Jul 2009 02:28:12 -0400
Message-Id: <1247725694-6082-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
References: <1247725694-6082-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_PREEMPT_BKL doesn't exist anymore. So remove this config-on
case definition of cond_resched().

Reported-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 include/linux/sched.h |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 9bada20..e2bdf18 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2285,17 +2285,12 @@ static inline int need_resched(void)
  * cond_resched_softirq() will enable bhs before scheduling.
  */
 extern int _cond_resched(void);
-#ifdef CONFIG_PREEMPT_BKL
-static inline int cond_resched(void)
-{
-	return 0;
-}
-#else
+
 static inline int cond_resched(void)
 {
 	return _cond_resched();
 }
-#endif
+
 extern int cond_resched_lock(spinlock_t * lock);
 extern int cond_resched_softirq(void);
 static inline int cond_resched_bkl(void)
-- 
1.6.2.3

