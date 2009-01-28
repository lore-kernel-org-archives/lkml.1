Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbZA1OAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbZA1OAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 09:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbZA1N5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 08:57:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:60378 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbZA1N53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 08:57:29 -0500
Message-Id: <20090128135457.885605001@chello.nl>
References: <20090128135352.679025549@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 28 Jan 2009 14:53:58 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 06/21] lockdep: simplify mark_lock()
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
@@ -2626,18 +2626,13 @@ static int mark_lock(struct task_struct 
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

