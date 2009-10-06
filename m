Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbZJFHRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbZJFHRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 03:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755024AbZJFHRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 03:17:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17048 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbZJFHRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 03:17:06 -0400
Date: Tue, 6 Oct 2009 03:16:06 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       Amerigo Wang <amwang@redhat.com>
Message-Id: <20091006071845.3956.8340.sendpatchset@localhost.localdomain>
Subject: [Patch] rwsem-spinlock: remove useless function exports
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


These functions need not to be exported, since no drivers should use them.

__init_rwsem() is an exception, because init_rwsem(), which is a macro,
is used.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: WANG Cong <amwang@redhat.com>

---
diff --git a/lib/rwsem-spinlock.c b/lib/rwsem-spinlock.c
index 9df3ca5..39a7411 100644
--- a/lib/rwsem-spinlock.c
+++ b/lib/rwsem-spinlock.c
@@ -34,6 +34,7 @@ void __init_rwsem(struct rw_semaphore *sem, const char *name,
 	spin_lock_init(&sem->wait_lock);
 	INIT_LIST_HEAD(&sem->wait_list);
 }
+EXPORT_SYMBOL(__init_rwsem);
 
 /*
  * handle the lock release when processes blocked on it that can now run
@@ -305,12 +306,3 @@ void __downgrade_write(struct rw_semaphore *sem)
 	spin_unlock_irqrestore(&sem->wait_lock, flags);
 }
 
-EXPORT_SYMBOL(__init_rwsem);
-EXPORT_SYMBOL(__down_read);
-EXPORT_SYMBOL(__down_read_trylock);
-EXPORT_SYMBOL(__down_write_nested);
-EXPORT_SYMBOL(__down_write);
-EXPORT_SYMBOL(__down_write_trylock);
-EXPORT_SYMBOL(__up_read);
-EXPORT_SYMBOL(__up_write);
-EXPORT_SYMBOL(__downgrade_write);
