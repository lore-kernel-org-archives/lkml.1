Return-Path: <linux-kernel-owner+w=401wt.eu-S1753163AbZGZI0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbZGZI0F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZGZITY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:19:24 -0400
Received: from www.tglx.de ([62.245.132.106]:57884 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702AbZGZITW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:19:22 -0400
Message-Id: <20090726081554.427869354@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:17:54 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       David Miller <davem@davemloft.net>
Subject: [Patch RFC 09/37] hamradio: mkiss: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=driver-nethamradio-mkiss-sema-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Miller <davem@davemloft.net>
---
 drivers/net/hamradio/mkiss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/net/hamradio/mkiss.c
===================================================================
--- linux-2.6-tip.orig/drivers/net/hamradio/mkiss.c
+++ linux-2.6-tip/drivers/net/hamradio/mkiss.c
@@ -745,7 +745,7 @@ static int mkiss_open(struct tty_struct 
 
 	spin_lock_init(&ax->buflock);
 	atomic_set(&ax->refcnt, 1);
-	init_MUTEX_LOCKED(&ax->dead_sem);
+	semaphore_init_locked(&ax->dead_sem);
 
 	ax->tty = tty;
 	tty->disc_data = ax;


