Return-Path: <linux-kernel-owner+w=401wt.eu-S1759955AbZAVRto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759955AbZAVRto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 12:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757876AbZAVRoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 12:44:01 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44505 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897AbZAVRnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 12:43:55 -0500
Message-Id: <20090122174052.914394431@chello.nl>
References: <20090122173701.674448070@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 22 Jan 2009 18:37:10 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 09/19] lockdep: generate usage strings
Content-Disposition: inline; filename=lockdep-generate9.patch
X-Bad-Reply: References but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

generate the usage strings

XXX capital invasion :-(

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/lockdep.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -445,21 +445,21 @@ atomic_t nr_find_usage_backwards_recursi
  * Locking printouts:
  */
 
+#define __STR(foo)	#foo
+#define STR(foo)	__STR(foo)
+
+#define __USAGE(__STATE)						\
+	[LOCK_USED_IN_##__STATE] = "IN-"STR(__STATE)"-W",		\
+	[LOCK_ENABLED_##__STATE] = STR(__STATE)"-ON-W",			\
+	[LOCK_USED_IN_##__STATE##_READ] = "IN-"STR(__STATE)"-R",	\
+	[LOCK_ENABLED_##__STATE##_READ] = STR(__STATE)"-ON-R",
+
 static const char *usage_str[] =
 {
-	[LOCK_USED] =			"initial-use ",
-	[LOCK_USED_IN_HARDIRQ] =	"in-hardirq-W",
-	[LOCK_USED_IN_SOFTIRQ] =	"in-softirq-W",
-	[LOCK_ENABLED_SOFTIRQ] =	"softirq-on-W",
-	[LOCK_ENABLED_HARDIRQ] =	"hardirq-on-W",
-	[LOCK_USED_IN_HARDIRQ_READ] =	"in-hardirq-R",
-	[LOCK_USED_IN_SOFTIRQ_READ] =	"in-softirq-R",
-	[LOCK_ENABLED_SOFTIRQ_READ] =	"softirq-on-R",
-	[LOCK_ENABLED_HARDIRQ_READ] =	"hardirq-on-R",
-	[LOCK_USED_IN_RECLAIM_FS] =	"in-reclaim-W",
-	[LOCK_USED_IN_RECLAIM_FS_READ] = "in-reclaim-R",
-	[LOCK_ENABLED_RECLAIM_FS] =	"ov-reclaim-W",
-	[LOCK_ENABLED_RECLAIM_FS_READ] = "ov-reclaim-R",
+#define LOCKDEP_STATE(__STATE) __USAGE(__STATE)
+#include "lockdep_states.h"
+#undef LOCKDEP_STATE
+	[LOCK_USED] = "INITIAL USE",
 };
 
 const char * __get_key_name(struct lockdep_subclass_key *key, char *str)

-- 

