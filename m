Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbYFXXW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbYFXXW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 19:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbYFXXVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 19:21:44 -0400
Received: from homer.mvista.com ([63.81.120.158]:38005 "EHLO
	dwalker1.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755080AbYFXXVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 19:21:42 -0400
Message-Id: <20080624232018.817822790@mvista.com>
User-Agent: quilt/0.46-1
Date: Tue, 24 Jun 2008 16:20:19 -0700
Subject: [PATCH 1/6] futex: checkpatch cleanup
From: Daniel Walker <dwalker@mvista.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Disposition: inline; filename=futex-checkpatch-cleanup.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Walker <dwalker@mvista.com>

---
 kernel/futex.c |   52 +++++++++++++++++++++++++++-------------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

Index: linux-2.6.25/kernel/futex.c
===================================================================
--- linux-2.6.25.orig/kernel/futex.c
+++ linux-2.6.25/kernel/futex.c
@@ -145,7 +145,7 @@ static inline void futex_unlock_mm(struc
  */
 static struct futex_hash_bucket *hash_futex(union futex_key *key)
 {
-	u32 hash = jhash2((u32*)&key->both.word,
+	u32 hash = jhash2((u32 *)&key->both.word,
 			  (sizeof(key->both.word)+sizeof(key->both.ptr))/4,
 			  key->both.offset);
 	return &futex_queues[hash & ((1 << FUTEX_HASHBITS)-1)];
@@ -234,7 +234,8 @@ static int get_futex_key(u32 __user *uad
 	 * mappings of _writable_ handles.
 	 */
 	if (likely(!(vma->vm_flags & VM_MAYSHARE))) {
-		key->both.offset |= FUT_OFF_MMSHARED; /* reference taken on mm */
+		/* reference taken on mm */
+		key->both.offset |= FUT_OFF_MMSHARED;
 		key->private.mm = mm;
 		key->private.address = address;
 		return 0;
@@ -277,12 +278,12 @@ static void get_futex_key_refs(union fut
 	if (key->both.ptr == NULL)
 		return;
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
-		case FUT_OFF_INODE:
-			atomic_inc(&key->shared.inode->i_count);
-			break;
-		case FUT_OFF_MMSHARED:
-			atomic_inc(&key->private.mm->mm_count);
-			break;
+	case FUT_OFF_INODE:
+		atomic_inc(&key->shared.inode->i_count);
+		break;
+	case FUT_OFF_MMSHARED:
+		atomic_inc(&key->private.mm->mm_count);
+		break;
 	}
 }
 
@@ -295,12 +296,12 @@ static void drop_futex_key_refs(union fu
 	if (!key->both.ptr)
 		return;
 	switch (key->both.offset & (FUT_OFF_INODE|FUT_OFF_MMSHARED)) {
-		case FUT_OFF_INODE:
-			iput(key->shared.inode);
-			break;
-		case FUT_OFF_MMSHARED:
-			mmdrop(key->private.mm);
-			break;
+	case FUT_OFF_INODE:
+		iput(key->shared.inode);
+		break;
+	case FUT_OFF_MMSHARED:
+		mmdrop(key->private.mm);
+		break;
 	}
 }
 
@@ -333,7 +334,7 @@ static int get_futex_value_locked(u32 *d
 static int futex_handle_fault(unsigned long address,
 			      struct rw_semaphore *fshared, int attempt)
 {
-	struct vm_area_struct * vma;
+	struct vm_area_struct *vma;
 	struct mm_struct *mm = current->mm;
 	int ret = -EFAULT;
 
@@ -391,7 +392,7 @@ static int refill_pi_state_cache(void)
 	return 0;
 }
 
-static struct futex_pi_state * alloc_pi_state(void)
+static struct futex_pi_state *alloc_pi_state(void)
 {
 	struct futex_pi_state *pi_state = current->pi_state_cache;
 
@@ -436,7 +437,7 @@ static void free_pi_state(struct futex_p
  * Look up the task based on what TID userspace gave us.
  * We dont trust it.
  */
-static struct task_struct * futex_find_get_task(pid_t pid)
+static struct task_struct *futex_find_get_task(pid_t pid)
 {
 	struct task_struct *p;
 
@@ -742,7 +743,7 @@ static int futex_wake(u32 __user *uaddr,
 	head = &hb->chain;
 
 	plist_for_each_entry_safe(this, next, head, list) {
-		if (match_futex (&this->key, &key)) {
+		if (match_futex(&this->key, &key)) {
 			if (this->pi_state) {
 				ret = -EINVAL;
 				break;
@@ -848,7 +849,7 @@ retry:
 	head = &hb1->chain;
 
 	plist_for_each_entry_safe(this, next, head, list) {
-		if (match_futex (&this->key, &key1)) {
+		if (match_futex(&this->key, &key1)) {
 			wake_futex(this);
 			if (++ret >= nr_wake)
 				break;
@@ -860,7 +861,7 @@ retry:
 
 		op_ret = 0;
 		plist_for_each_entry_safe(this, next, head, list) {
-			if (match_futex (&this->key, &key2)) {
+			if (match_futex(&this->key, &key2)) {
 				wake_futex(this);
 				if (++op_ret >= nr_wake2)
 					break;
@@ -938,7 +939,7 @@ static int futex_requeue(u32 __user *uad
 
 	head1 = &hb1->chain;
 	plist_for_each_entry_safe(this, next, head1, list) {
-		if (!match_futex (&this->key, &key1))
+		if (!match_futex(&this->key, &key1))
 			continue;
 		if (++ret <= nr_wake) {
 			wake_futex(this);
@@ -1648,7 +1649,8 @@ retry_unlocked:
 	 * anyone else up:
 	 */
 	if (!(uval & FUTEX_OWNER_DIED))
-		uval = cmpxchg_futex_value_locked(uaddr, task_pid_vnr(current), 0);
+		uval = cmpxchg_futex_value_locked(uaddr,
+						  task_pid_vnr(current), 0);
 
 
 	if (unlikely(uval == -EFAULT))
@@ -1667,7 +1669,7 @@ retry_unlocked:
 	head = &hb->chain;
 
 	plist_for_each_entry_safe(this, next, head, list) {
-		if (!match_futex (&this->key, &key))
+		if (!match_futex(&this->key, &key))
 			continue;
 		ret = wake_futex_pi(uaddr, uval, this);
 		/*
@@ -1913,8 +1915,8 @@ void exit_robust_list(struct task_struct
 		 * don't process it twice:
 		 */
 		if (entry != pending)
-			if (handle_futex_death((void __user *)entry + futex_offset,
-						curr, pi))
+			if (handle_futex_death((void __user *)entry +
+						futex_offset, curr, pi))
 				return;
 		if (rc)
 			return;

-- 
