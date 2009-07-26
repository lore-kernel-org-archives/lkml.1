Return-Path: <linux-kernel-owner+w=401wt.eu-S1752693AbZGZITG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693AbZGZITG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752646AbZGZITE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:19:04 -0400
Received: from www.tglx.de ([62.245.132.106]:57833 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636AbZGZITC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:19:02 -0400
Message-Id: <20090726081554.028325896@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:17:38 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [Patch RFC 06/37] input: serio/hp_sdc: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=driver-input-serio-hp-sdc-sema-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/serio/hp_sdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6-tip/drivers/input/serio/hp_sdc.c
===================================================================
--- linux-2.6-tip.orig/drivers/input/serio/hp_sdc.c
+++ linux-2.6-tip/drivers/input/serio/hp_sdc.c
@@ -1039,7 +1039,7 @@ static int __init hp_sdc_register(void)
 		return hp_sdc.dev_err;
 	}
 
-	init_MUTEX_LOCKED(&tq_init_sem);
+	semaphore_init(&tq_init_sem);
 
 	tq_init.actidx		= 0;
 	tq_init.idx		= 1;


