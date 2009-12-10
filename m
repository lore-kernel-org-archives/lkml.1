Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbZLJAzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbZLJAzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 19:55:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759293AbZLJAy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 19:54:58 -0500
Received: from www.tglx.de ([62.245.132.106]:53891 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959AbZLJAyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 19:54:46 -0500
Message-Id: <20091210004703.348209762@linutronix.de>
User-Agent: quilt/0.47-1
Date: Thu, 10 Dec 2009 00:53:31 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-security-module@vger.kernel.org
Subject: [patch 9/9] security: Fix invalid rcu assumptions in comments
References: <20091210001308.247025548@linutronix.de>
Content-Disposition: inline; filename=security-fix-rcu-assumptions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) held spinlocks are not equivalent to rcu_read_lock

2) access to current_cred() is safe as only current can modify its
   own credentials.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org

---
 security/keys/permission.c |    3 +--
 security/keys/proc.c       |    2 --
 2 files changed, 1 insertion(+), 4 deletions(-)

Index: linux-2.6-tip/security/keys/permission.c
===================================================================
--- linux-2.6-tip.orig/security/keys/permission.c
+++ linux-2.6-tip/security/keys/permission.c
@@ -23,8 +23,7 @@
  * Check to see whether permission is granted to use a key in the desired way,
  * but permit the security modules to override.
  *
- * The caller must hold either a ref on cred or must hold the RCU readlock or a
- * spinlock.
+ * The caller must hold either a ref on cred or must hold the RCU readlock.
  */
 int key_task_permission(const key_ref_t key_ref, const struct cred *cred,
 			key_perm_t perm)
Index: linux-2.6-tip/security/keys/proc.c
===================================================================
--- linux-2.6-tip.orig/security/keys/proc.c
+++ linux-2.6-tip/security/keys/proc.c
@@ -194,8 +194,6 @@ static int proc_keys_show(struct seq_fil
 
 	/* check whether the current task is allowed to view the key (assuming
 	 * non-possession)
-	 * - the caller holds a spinlock, and thus the RCU read lock, making our
-	 *   access to __current_cred() safe
 	 */
 	rc = key_task_permission(make_key_ref(key, 0), current_cred(),
 				 KEY_VIEW);


