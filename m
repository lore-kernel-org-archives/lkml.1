Return-Path: <linux-kernel-owner+w=401wt.eu-S1752747AbZGZITZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747AbZGZITZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZGZITV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:19:21 -0400
Received: from www.tglx.de ([62.245.132.106]:57873 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZGZITS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:19:18 -0400
Message-Id: <20090726081554.298093050@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:17:50 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>
Subject: [Patch RFC 08/37] hamradio: 6pack: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=driver-nethamradio-6pack-sema-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
---
 drivers/net/hamradio/6pack.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/net/hamradio/6pack.c
===================================================================
--- linux-2.6-tip.orig/drivers/net/hamradio/6pack.c
+++ linux-2.6-tip/drivers/net/hamradio/6pack.c
@@ -606,7 +606,7 @@ static int sixpack_open(struct tty_struc
 
 	spin_lock_init(&sp->lock);
 	atomic_set(&sp->refcnt, 1);
-	init_MUTEX_LOCKED(&sp->dead_sem);
+	semaphore_init_locked(&sp->dead_sem);
 
 	/* !!! length of the buffers. MTU is IP MTU, not PACLEN!  */
 


