Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbZGZIZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbZGZIZv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753054AbZGZIZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:25:50 -0400
Received: from www.tglx.de ([62.245.132.106]:41562 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044AbZGZIZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:25:48 -0400
Message-Id: <20090726081557.768169909@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:20:27 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [Patch RFC 34/37] printk: Make console_sem a semaphore not a pseudo
	mutex
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=printk-sema-no-mutex.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It needs to be investigated whether it can be replaced by a real
mutex, but that needs more thought and investigation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/printk.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/kernel/printk.c
===================================================================
--- linux-2.6-tip.orig/kernel/printk.c
+++ linux-2.6-tip/kernel/printk.c
@@ -73,7 +73,7 @@ EXPORT_SYMBOL(oops_in_progress);
  * provides serialisation for access to the entire console
  * driver system.
  */
-static DECLARE_MUTEX(console_sem);
+static DEFINE_SEMAPHORE(console_sem);
 struct console *console_drivers;
 EXPORT_SYMBOL_GPL(console_drivers);
 
@@ -529,7 +529,7 @@ static void zap_locks(void)
 	/* If a crash is occurring, make sure we can't deadlock */
 	spin_lock_init(&logbuf_lock);
 	/* And make sure that we print immediately */
-	init_MUTEX(&console_sem);
+	semaphore_init(&console_sem);
 }
 
 #if defined(CONFIG_PRINTK_TIME)


