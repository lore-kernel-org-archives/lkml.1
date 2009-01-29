Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZA2Nyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZA2Nyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 08:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbZA2NyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 08:54:23 -0500
Received: from casper.infradead.org ([85.118.1.10]:45459 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbZA2NyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 08:54:22 -0500
Subject: [PATCH 22/21] lockdep: use stringify.h
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, npiggin@suse.de,
       Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <20090128135352.679025549@chello.nl>
References: <20090128135352.679025549@chello.nl>
Content-Type: text/plain
Date: Thu, 29 Jan 2009 14:54:09 +0100
Message-Id: <1233237249.4495.82.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: lockdep: use stringify.h
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu Jan 29 14:50:36 CET 2009

Arnd pointed out we have the stringify macro magic already in-kernel.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Arnd Bergmann <arnd@arndb.de>
---
 kernel/lockdep.c |   16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -41,6 +41,7 @@
 #include <linux/utsname.h>
 #include <linux/hash.h>
 #include <linux/ftrace.h>
+#include <linux/stringify.h>
 
 #include <asm/sections.h>
 
@@ -445,14 +446,11 @@ atomic_t nr_find_usage_backwards_recursi
  * Locking printouts:
  */
 
-#define __STR(foo)	#foo
-#define STR(foo)	__STR(foo)
-
 #define __USAGE(__STATE)						\
-	[LOCK_USED_IN_##__STATE] = "IN-"STR(__STATE)"-W",		\
-	[LOCK_ENABLED_##__STATE] = STR(__STATE)"-ON-W",			\
-	[LOCK_USED_IN_##__STATE##_READ] = "IN-"STR(__STATE)"-R",	\
-	[LOCK_ENABLED_##__STATE##_READ] = STR(__STATE)"-ON-R",
+	[LOCK_USED_IN_##__STATE] = "IN-"__stringify(__STATE)"-W",	\
+	[LOCK_ENABLED_##__STATE] = __stringify(__STATE)"-ON-W",		\
+	[LOCK_USED_IN_##__STATE##_READ] = "IN-"__stringify(__STATE)"-R",\
+	[LOCK_ENABLED_##__STATE##_READ] = __stringify(__STATE)"-ON-R",
 
 static const char *usage_str[] =
 {
@@ -1270,14 +1268,14 @@ check_usage(struct task_struct *curr, st
 
 static const char *state_names[] = {
 #define LOCKDEP_STATE(__STATE) \
-	STR(__STATE),
+	__stringify(__STATE),
 #include "lockdep_states.h"
 #undef LOCKDEP_STATE
 };
 
 static const char *state_rnames[] = {
 #define LOCKDEP_STATE(__STATE) \
-	STR(__STATE)"-READ",
+	__stringify(__STATE)"-READ",
 #include "lockdep_states.h"
 #undef LOCKDEP_STATE
 };


