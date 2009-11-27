Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZK0XJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZK0XJj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 18:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZK0XJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 18:09:28 -0500
Received: from server1.wserver.cz ([82.113.45.157]:60467 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbZK0XGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 18:06:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: mingo@elte.hu, nhorman@tuxdriver.com, sfr@canb.auug.org.au,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       marcin.slusarz@gmail.com, tglx@linutronix.de, mingo@redhat.com,
       hpa@zytor.com, torvalds@linux-foundation.org, oleg@redhat.com,
       James Morris <jmorris@namei.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH v3 11/27] core: rename setrlimit to do_setrlimit
Date: Sat, 28 Nov 2009 00:05:51 +0100
Message-Id: <1259363167-9347-11-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
References: <1259363167-9347-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename it so that it makes more sense in the field of syscalls
(i.e. do_* is used for functions called by syscall wrappers but
also when called from other paths).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
Cc: James Morris <jmorris@namei.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
---
 fs/proc/base.c           |    2 +-
 include/linux/resource.h |    2 +-
 kernel/sys.c             |    4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 78c0367..9fdb990 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -589,7 +589,7 @@ static ssize_t limits_write(struct file *file, const char __user *buf,
 		goto put_task;
 	}
 
-	ret = setrlimit(task, i, &new_rlimit);
+	ret = do_setrlimit(task, i, &new_rlimit);
 	if (ret)
 		count = ret;
 
diff --git a/include/linux/resource.h b/include/linux/resource.h
index 4301d67..08beb1a 100644
--- a/include/linux/resource.h
+++ b/include/linux/resource.h
@@ -71,7 +71,7 @@ struct rlimit {
 #include <asm/resource.h>
 
 int getrusage(struct task_struct *p, int who, struct rusage __user *ru);
-int setrlimit(struct task_struct *tsk, unsigned int resource,
+int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim);
 
 #endif
diff --git a/kernel/sys.c b/kernel/sys.c
index 0f86199..fad6010 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1239,7 +1239,7 @@ SYSCALL_DEFINE2(old_getrlimit, unsigned int, resource,
 #endif
 
 /* make sure you are allowed to change @tsk limits before calling this */
-int setrlimit(struct task_struct *tsk, unsigned int resource,
+int do_setrlimit(struct task_struct *tsk, unsigned int resource,
 		struct rlimit *new_rlim)
 {
 	struct rlimit *old_rlim;
@@ -1308,7 +1308,7 @@ SYSCALL_DEFINE2(setrlimit, unsigned int, resource, struct rlimit __user *, rlim)
 		return -EINVAL;
 	if (copy_from_user(&new_rlim, rlim, sizeof(*rlim)))
 		return -EFAULT;
-	return setrlimit(current, resource, &new_rlim);
+	return do_setrlimit(current, resource, &new_rlim);
 }
 
 /*
-- 
1.6.5.3

