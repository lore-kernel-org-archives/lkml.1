Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbZGZIXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbZGZIXb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbZGZIX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:23:29 -0400
Received: from www.tglx.de ([62.245.132.106]:34066 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753117AbZGZIX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:23:28 -0400
Message-Id: <20090726081554.558555577@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:17:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>
Subject: [Patch RFC 10/37] net: ppp_async: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=driver-net-ppp-async-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
---
 drivers/net/ppp_async.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/net/ppp_async.c
===================================================================
--- linux-2.6-tip.orig/drivers/net/ppp_async.c
+++ linux-2.6-tip/drivers/net/ppp_async.c
@@ -183,7 +183,7 @@ ppp_asynctty_open(struct tty_struct *tty
 	tasklet_init(&ap->tsk, ppp_async_process, (unsigned long) ap);
 
 	atomic_set(&ap->refcnt, 1);
-	init_MUTEX_LOCKED(&ap->dead_sem);
+	semaphore_init_locked(&ap->dead_sem);
 
 	ap->chan.private = ap;
 	ap->chan.ops = &async_ops;


