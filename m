Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbZGZITe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbZGZITe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752252AbZGZITb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:19:31 -0400
Received: from www.tglx.de ([62.245.132.106]:57907 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752614AbZGZIT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:19:29 -0400
Message-Id: <20090726081554.686871186@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:18:02 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [Patch RFC 11/37] parport: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline; filename=driver-parport-share-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/parport/share.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/parport/share.c
===================================================================
--- linux-2.6-tip.orig/drivers/parport/share.c
+++ linux-2.6-tip/drivers/parport/share.c
@@ -306,7 +306,7 @@ struct parport *parport_register_port(un
 	spin_lock_init(&tmp->pardevice_lock);
 	tmp->ieee1284.mode = IEEE1284_MODE_COMPAT;
 	tmp->ieee1284.phase = IEEE1284_PH_FWD_IDLE;
-	init_MUTEX_LOCKED (&tmp->ieee1284.irq); /* actually a semaphore at 0 */
+	semaphore_init_locked(&tmp->ieee1284.irq);
 	tmp->spintime = parport_default_spintime;
 	atomic_set (&tmp->ref_count, 1);
 	INIT_LIST_HEAD(&tmp->full_list);


