Return-Path: <linux-kernel-owner+w=401wt.eu-S1760043AbYDWFib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760043AbYDWFib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 01:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYDWFiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 01:38:21 -0400
Received: from ozlabs.org ([203.10.76.45]:52147 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbYDWFiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 01:38:20 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH] mutex-debug: Check mutex magic before owner
Message-Id: <1208929092.367844.810203758306.1.gpush@pingu>
To: <linux-kernel@vger.kernel.org>
Cc: <mingo@redhat.com>
From: Jeremy Kerr <jk@ozlabs.org>
Date: Wed, 23 Apr 2008 15:38:12 +1000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the mutex debug code checks the lock->owner before
lock->magic, so a corrupt mutex will most likely result in
failing the owner check, rather than the magic check.

This change to debug_mutex_unlock does the magic check first, so
we have a better idea of what breaks.

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

---
 kernel/mutex-debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/mutex-debug.c b/kernel/mutex-debug.c
index 3aaa06c..1d94160 100644
--- a/kernel/mutex-debug.c
+++ b/kernel/mutex-debug.c
@@ -79,8 +79,8 @@ void debug_mutex_unlock(struct mutex *lock)
 	if (unlikely(!debug_locks))
 		return;
 
-	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 	DEBUG_LOCKS_WARN_ON(lock->magic != lock);
+	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 	DEBUG_LOCKS_WARN_ON(!lock->wait_list.prev && !lock->wait_list.next);
 	DEBUG_LOCKS_WARN_ON(lock->owner != current_thread_info());
 }
