Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0CNKjQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 06:39:16 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:52876 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757212Ab0CNKiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 06:38:54 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>, Jason Baron <jbaron@redhat.com>
Subject: [PATCH RFC 07/11] Adopt the way of initializing semaphore to lock monitor
Date: Sun, 14 Mar 2010 19:38:44 +0900
Message-Id: <1268563128-6486-8-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now spinlock_t doesn't have struct lockdep_map,
this was replaced with struct lock_monitor.

So this patch fixes the way of initializing semaphore.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Jason Baron <jbaron@redhat.com>
---
 include/linux/semaphore.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 7415839..d5aa2ba 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -33,7 +33,7 @@ static inline void sema_init(struct semaphore *sem, int val)
 {
 	static struct lock_class_key __key;
 	*sem = (struct semaphore) __SEMAPHORE_INITIALIZER(*sem, val);
-	lockdep_init_map(&sem->lock.dep_map, "semaphore->lock", &__key, 0);
+	lockdep_init_map(&sem->lock.monitor.dep_map, "semaphore->lock", &__key, 0);
 }
 
 #define init_MUTEX(sem)		sema_init(sem, 1)
-- 
1.6.5.2

