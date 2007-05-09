Return-Path: <linux-kernel-owner+w=401wt.eu-S935200AbXEIGZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935200AbXEIGZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 02:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934666AbXEIGZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 02:25:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39801 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934099AbXEIGZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 02:25:00 -0400
Date: Wed, 9 May 2007 16:23:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: paulus@samba.org
Cc: ppc-dev <linuxppc-dev@ozlabs.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: [PATCH 1/2] Declare {compat_}sys_utimensat
Message-Id: <20070509162357.65ab8868.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/compat.h   |    3 +++
 include/linux/syscalls.h |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

This is needed before Powerpc can wire up the syscall.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/include/linux/compat.h b/include/linux/compat.h
index ccd863d..70a157a 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -253,5 +253,8 @@ asmlinkage long compat_sys_epoll_pwait(int epfd,
 			const compat_sigset_t __user *sigmask,
 			compat_size_t sigsetsize);
 
+asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename,
+				struct compat_timespec __user *t, int flags);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 1912c6c..3139f44 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -576,6 +576,8 @@ asmlinkage long sys_fstatat64(int dfd, char __user *filename,
 			       struct stat64 __user *statbuf, int flag);
 asmlinkage long sys_readlinkat(int dfd, const char __user *path, char __user *buf,
 			       int bufsiz);
+asmlinkage long sys_utimensat(int dfd, char __user *filename,
+				struct timespec __user *utimes, int flags);
 asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename,
 				     struct compat_timeval __user *t);
 asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
-- 
1.5.1.3

