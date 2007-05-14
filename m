Return-Path: <linux-kernel-owner+w=401wt.eu-S1759486AbXENDr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486AbXENDr7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 23:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbXENDrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 23:47:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56127 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbXENDrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 23:47:52 -0400
Date: Mon, 14 May 2007 13:47:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>,
       Linus <torvalds@linux-foundation.org>
Subject: [PATCH] Declare another couple of compat syscalls.
Message-Id: <20070514134747.1de2435d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.0 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

compat_sys_signalfd and compat_sys_timerfd need declarations before
PowerPC can wire them up.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/compat.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 636502c..0e69d2c 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -261,5 +261,11 @@ asmlinkage long compat_sys_epoll_pwait(int epfd,
 asmlinkage long compat_sys_utimensat(unsigned int dfd, char __user *filename,
 				struct compat_timespec __user *t, int flags);
 
+asmlinkage long compat_sys_signalfd(int ufd,
+				const compat_sigset_t __user *sigmask,
+                                compat_size_t sigsetsize);
+asmlinkage long compat_sys_timerfd(int ufd, int clockid, int flags,
+				const struct compat_itimerspec __user *utmr);
+
 #endif /* CONFIG_COMPAT */
 #endif /* _LINUX_COMPAT_H */
-- 
1.5.1.4

