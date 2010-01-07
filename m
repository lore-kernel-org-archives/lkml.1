Return-Path: <linux-kernel-owner+w=401wt.eu-S1752079Ab0AGKkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab0AGKkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 05:40:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012Ab0AGKkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 05:40:07 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52179 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0AGKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 05:40:04 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org,
       Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3/5] lockdep:  Add file and line to initialize sequence of rwsem
Date: Thu,  7 Jan 2010 19:39:53 +0900
Message-Id: <1262860795-5745-4-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
References: <4B45B9C1.2040900@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds __FILE__ and __LINE__ to lockdep_map of rw_semaphore.
This patch only affects to x86 architecture dependent rwsem.

If this patch is accepted, I'll prepare and send the patch
adds __FILE__ and __LINE__ to rw_semaphore of other architectures
which provides architecture dependent rwsem.h .

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/rwsem.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/rwsem.h b/arch/x86/include/asm/rwsem.h
index ca7517d..24cbe3a 100644
--- a/arch/x86/include/asm/rwsem.h
+++ b/arch/x86/include/asm/rwsem.h
@@ -74,7 +74,12 @@ struct rw_semaphore {
 };
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
-# define __RWSEM_DEP_MAP_INIT(lockname) , .dep_map = { .name = #lockname }
+# define __RWSEM_DEP_MAP_INIT(lockname)			\
+	, .dep_map = {					\
+		.file = __FILE__,			\
+		.line = __LINE__,			\
+		.name = #lockname,			\
+	}
 #else
 # define __RWSEM_DEP_MAP_INIT(lockname)
 #endif
@@ -96,7 +101,7 @@ extern void __init_rwsem(struct rw_semaphore *sem, const char *name,
 do {								\
 	static struct lock_class_key __key;			\
 								\
-	__init_rwsem((sem), #sem, &__key);			\
+	__init_rwsem((sem), #sem, &__key, __FILE__, __LINE__);	\
 } while (0)
 
 /*
-- 
1.6.5.2

