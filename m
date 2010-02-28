Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968744Ab0B1QTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 11:19:19 -0500
Received: from www.tglx.de ([62.245.132.106]:37669 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964812Ab0B1QTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 11:19:18 -0500
Date: Sun, 28 Feb 2010 17:19:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] futexes for 2.6.34
Message-ID: <alpine.LFD.2.00.1002281718300.4245@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest futexes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git futexes-for-linus

Thanks,

	tglx

------------------>
Thomas Gleixner (1):
      futex: Protect pid lookup in compat code with RCU


 kernel/futex_compat.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index 2357165..d49afb2 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -146,7 +146,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 		struct task_struct *p;
 
 		ret = -ESRCH;
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		p = find_task_by_vpid(pid);
 		if (!p)
 			goto err_unlock;
@@ -157,7 +157,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 		    !capable(CAP_SYS_PTRACE))
 			goto err_unlock;
 		head = p->compat_robust_list;
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 	}
 
 	if (put_user(sizeof(*head), len_ptr))
@@ -165,7 +165,7 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
 	return put_user(ptr_to_compat(head), head_ptr);
 
 err_unlock:
-	read_unlock(&tasklist_lock);
+	rcu_read_unlock();
 
 	return ret;
 }
