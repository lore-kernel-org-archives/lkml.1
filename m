Return-Path: <linux-kernel-owner+w=401wt.eu-S1759218AbZAVRr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759218AbZAVRr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756707AbZAVRnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:43:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44499 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048AbZAVRnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:51 -0500
Message-Id: <20090122174052.623128597@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:07 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 06/19] lockdep: simplify mark_lock()
Content-Disposition: inline; filename=lockdep-generate6.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove the state iteration

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2445,18 +2445,13 @@ static int mark_lock(struct task_struct 
 		return 0;
 
 	switch (new_bit) {
-	case LOCK_USED_IN_HARDIRQ:
-	case LOCK_USED_IN_SOFTIRQ:
-	case LOCK_USED_IN_HARDIRQ_READ:
-	case LOCK_USED_IN_SOFTIRQ_READ:
-	case LOCK_ENABLED_HARDIRQ:
-	case LOCK_ENABLED_SOFTIRQ:
-	case LOCK_ENABLED_HARDIRQ_READ:
-	case LOCK_ENABLED_SOFTIRQ_READ:
-	case LOCK_USED_IN_RECLAIM_FS:
-	case LOCK_USED_IN_RECLAIM_FS_READ:
-	case LOCK_ENABLED_RECLAIM_FS:
-	case LOCK_ENABLED_RECLAIM_FS_READ:
+#define LOCKDEP_STATE(__STATE)			\
+	case LOCK_USED_IN_##__STATE:		\
+	case LOCK_USED_IN_##__STATE##_READ:	\
+	case LOCK_ENABLED_##__STATE:		\
+	case LOCK_ENABLED_##__STATE##_READ:
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
 		ret = mark_lock_irq(curr, this, new_bit);
 		if (!ret)
 			return 0;

-- 

