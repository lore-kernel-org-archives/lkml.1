Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZIVFa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZIVFa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754803AbZIVFa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:30:27 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:45886 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796AbZIVFaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:30:22 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 3/5] futex: make function kernel-doc commentary consistent
To: linux-kernel@vger.kernel.org
Cc: Darren Hart <dvhltc@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@us.ibm.com>
Date: Mon, 21 Sep 2009 22:30:22 -0700
Message-ID: <20090922053022.8717.13339.stgit@Aeon>
In-Reply-To: <20090922052452.8717.39673.stgit@Aeon>
References: <20090922052452.8717.39673.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the existing function kernel-doc consistent throughout futex.c, following
Documentation/kernel-doc-nano-howto.txt as closely as possible.  When unsure,
at least be consistent within futex.c.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>
---

 kernel/futex.c |   41 +++++++++++++++++++++--------------------
 1 files changed, 21 insertions(+), 20 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index cedcd60..720fa3d 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -198,11 +198,12 @@ static void drop_futex_key_refs(union futex_key *key)
 }
 
 /**
- * get_futex_key - Get parameters which are the keys for a futex.
- * @uaddr: virtual address of the futex
- * @fshared: 0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
- * @key: address where result is stored.
- * @rw: mapping needs to be read/write (values: VERIFY_READ, VERIFY_WRITE)
+ * get_futex_key() - Get parameters which are the keys for a futex
+ * @uaddr:	virtual address of the futex
+ * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
+ * @key:	address where result is stored.
+ * @rw:		mapping needs to be read/write (values: VERIFY_READ,
+ * 		VERIFY_WRITE)
  *
  * Returns a negative error code or 0
  * The key words are stored in *key on success.
@@ -288,8 +289,8 @@ void put_futex_key(int fshared, union futex_key *key)
 	drop_futex_key_refs(key);
 }
 
-/*
- * fault_in_user_writeable - fault in user address and verify RW access
+/**
+ * fault_in_user_writeable() - Fault in user address and verify RW access
  * @uaddr:	pointer to faulting user space address
  *
  * Slow path to fixup the fault we just took in the atomic write
@@ -309,8 +310,8 @@ static int fault_in_user_writeable(u32 __user *uaddr)
 
 /**
  * futex_top_waiter() - Return the highest priority waiter on a futex
- * @hb:     the hash bucket the futex_q's reside in
- * @key:    the futex key (to distinguish it from other futex futex_q's)
+ * @hb:		the hash bucket the futex_q's reside in
+ * @key:	the futex key (to distinguish it from other futex futex_q's)
  *
  * Must be called with the hb lock held.
  */
@@ -588,7 +589,7 @@ lookup_pi_state(u32 uval, struct futex_hash_bucket *hb,
 }
 
 /**
- * futex_lock_pi_atomic() - atomic work required to acquire a pi aware futex
+ * futex_lock_pi_atomic() - Atomic work required to acquire a pi aware futex
  * @uaddr:		the pi futex user address
  * @hb:			the pi futex hash bucket
  * @key:		the futex key associated with uaddr and hb
@@ -1011,9 +1012,9 @@ void requeue_futex(struct futex_q *q, struct futex_hash_bucket *hb1,
 
 /**
  * requeue_pi_wake_futex() - Wake a task that acquired the lock during requeue
- * q:	the futex_q
- * key:	the key of the requeue target futex
- * hb:  the hash_bucket of the requeue target futex
+ * @q:		the futex_q
+ * @key:	the key of the requeue target futex
+ * @hb:		the hash_bucket of the requeue target futex
  *
  * During futex_requeue, with requeue_pi=1, it is possible to acquire the
  * target futex if it is uncontended or via a lock steal.  Set the futex_q key
@@ -2319,9 +2320,9 @@ out:
  */
 
 /**
- * sys_set_robust_list - set the robust-futex list head of a task
- * @head: pointer to the list-head
- * @len: length of the list-head, as userspace expects
+ * sys_set_robust_list() - Set the robust-futex list head of a task
+ * @head:	pointer to the list-head
+ * @len:	length of the list-head, as userspace expects
  */
 SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
 		size_t, len)
@@ -2340,10 +2341,10 @@ SYSCALL_DEFINE2(set_robust_list, struct robust_list_head __user *, head,
 }
 
 /**
- * sys_get_robust_list - get the robust-futex list head of a task
- * @pid: pid of the process [zero for current task]
- * @head_ptr: pointer to a list-head pointer, the kernel fills it in
- * @len_ptr: pointer to a length field, the kernel fills in the header size
+ * sys_get_robust_list() - Get the robust-futex list head of a task
+ * @pid:	pid of the process [zero for current task]
+ * @head_ptr:	pointer to a list-head pointer, the kernel fills it in
+ * @len_ptr:	pointer to a length field, the kernel fills in the header size
  */
 SYSCALL_DEFINE3(get_robust_list, int, pid,
 		struct robust_list_head __user * __user *, head_ptr,

