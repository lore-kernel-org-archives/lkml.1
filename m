Return-Path: <linux-kernel-owner+w=401wt.eu-S1758728AbXKBPo3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758728AbXKBPo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:44:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759551AbXKBPnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:43:46 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49694 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759538AbXKBPnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:43:45 -0400
Date: Fri, 2 Nov 2007 16:43:22 +0100
From: Adrian Bunk <bunk@kernel.org>
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/futex.c: make 3 functions static
Message-ID: <20071102154322.GJ30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following functions can now become static again:
- get_futex_key()
- get_futex_key_refs()
- drop_futex_key_refs()

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/linux/futex.h |    4 ----
 kernel/futex.c        |   11 ++++-------
 2 files changed, 4 insertions(+), 11 deletions(-)

48faaee030e6f0ef92ec418552cce6b3b2c14c56 
diff --git a/include/linux/futex.h b/include/linux/futex.h
index 9965035..92d420f 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -149,10 +149,6 @@ union futex_key {
 		int offset;
 	} both;
 };
-int get_futex_key(u32 __user *uaddr, struct rw_semaphore *shared,
-		  union futex_key *key);
-void get_futex_key_refs(union futex_key *key);
-void drop_futex_key_refs(union futex_key *key);
 
 #ifdef CONFIG_FUTEX
 extern void exit_robust_list(struct task_struct *curr);
diff --git a/kernel/futex.c b/kernel/futex.c
index 3271045..9dc591a 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -181,8 +181,8 @@ static inline int match_futex(union futex_key *key1, union futex_key *key2)
  * For other futexes, it points to &current->mm->mmap_sem and
  * caller must have taken the reader lock. but NOT any spinlocks.
  */
-int get_futex_key(u32 __user *uaddr, struct rw_semaphore *fshared,
-		  union futex_key *key)
+static int get_futex_key(u32 __user *uaddr, struct rw_semaphore *fshared,
+			 union futex_key *key)
 {
 	unsigned long address = (unsigned long)uaddr;
 	struct mm_struct *mm = current->mm;
@@ -268,14 +268,13 @@ int get_futex_key(u32 __user *uaddr, struct rw_semaphore *fshared,
 	}
 	return err;
 }
-EXPORT_SYMBOL_GPL(get_futex_key);
 
 /*
  * Take a reference to the resource addressed by a key.
  * Can be called while holding spinlocks.
  *
  */
-inline void get_futex_key_refs(union futex_key *key)
+static void get_futex_key_refs(union futex_key *key)
 {
 	if (key->both.ptr == 0)
 		return;
@@ -288,13 +287,12 @@ inline void get_futex_key_refs(union futex_key *key)
 			break;
 	}
 }
-EXPORT_SYMBOL_GPL(get_futex_key_refs);
 
 /*
  * Drop a reference to the resource addressed by a key.
  * The hash bucket spinlock must not be held.
  */
-void drop_futex_key_refs(union futex_key *key)
+static void drop_futex_key_refs(union futex_key *key)
 {
 	if (!key->both.ptr)
 		return;
@@ -307,7 +305,6 @@ void drop_futex_key_refs(union futex_key *key)
 			break;
 	}
 }
-EXPORT_SYMBOL_GPL(drop_futex_key_refs);
 
 static u32 cmpxchg_futex_value_locked(u32 __user *uaddr, u32 uval, u32 newval)
 {

