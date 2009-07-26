Return-Path: <linux-kernel-owner+w=401wt.eu-S1752392AbZGZITI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbZGZITI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752454AbZGZITF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:19:05 -0400
Received: from www.tglx.de ([62.245.132.106]:57834 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbZGZITC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:19:02 -0400
Message-Id: <20090726081553.898284087@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sun, 26 Jul 2009 08:17:33 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Dmitry Torokhov <dtor@mail.ru>
Subject: [Patch RFC 05/37] input: serio/hil_mlc: semaphore cleanup
References: <20090726081459.455111897@linutronix.de>
Content-Disposition: inline;
	filename=driver-input-serio-hil-mlc-sema-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of this "mutex" is non obvious and probably a completion in
some places. Make it a semaphore.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/serio/hil_mlc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6-tip/drivers/input/serio/hil_mlc.c
===================================================================
--- linux-2.6-tip.orig/drivers/input/serio/hil_mlc.c
+++ linux-2.6-tip/drivers/input/serio/hil_mlc.c
@@ -914,15 +914,15 @@ int hil_mlc_register(hil_mlc *mlc)
 	mlc->ostarted = 0;
 
 	rwlock_init(&mlc->lock);
-	init_MUTEX(&mlc->osem);
+	semaphore_init(&mlc->osem);
 
-	init_MUTEX(&mlc->isem);
+	semaphore_init(&mlc->isem);
 	mlc->icount = -1;
 	mlc->imatch = 0;
 
 	mlc->opercnt = 0;
 
-	init_MUTEX_LOCKED(&(mlc->csem));
+	semaphore_init(&(mlc->csem));
 
 	hil_mlc_clear_di_scratch(mlc);
 	hil_mlc_clear_di_map(mlc, 0);


