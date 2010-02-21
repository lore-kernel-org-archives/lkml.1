Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab0BUOZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:25:45 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:58923 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0BUOZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:25:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=eKYWti/9emHgYFSzqey3whW5VLClCME6Y4BKnBEx/4FAOsUr5FaE+vgP7kdY+VtT9z
         VEfDHffDWvbchWUyD4wc35NNsgDbfOGUOVubyyEBP0nYGxVHBehUXHWzB+VvYXcTyluL
         EnCra3H4IQpEkFvsZlqUfQnSmJkjDEtpTD1XA=
Date: Sun, 21 Feb 2010 22:25:34 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 16/17] sysctl extern cleanup - poll
Message-ID: <20100221142534.GA3030@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move epoll_table extern declaration to linux/poll.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/poll.h |    2 ++
 kernel/sysctl.c      |    6 +++---
 2 files changed, 5 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/include/linux/poll.h	2010-02-21 11:12:11.850112707 +0800
+++ linux-2.6.32/include/linux/poll.h	2010-02-21 11:26:29.549195967 +0800
@@ -10,8 +10,10 @@
 #include <linux/wait.h>
 #include <linux/string.h>
 #include <linux/fs.h>
+#include <linux/sysctl.h>
 #include <asm/uaccess.h>
 
+extern struct ctl_table epoll_table[]; /* for sysctl */
 /* ~832 bytes of stack space used max in sys_select/sys_poll before allocating
    additional memory. */
 #define MAX_STACK_ALLOC 832
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 11:23:13.929215242 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 11:25:35.455865983 +0800
@@ -72,6 +72,9 @@
 #if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_LOCK_STAT)
 #include <linux/lockdep.h>
 #endif
+#ifdef CONFIG_EPOLL
+#include <linux/poll.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -174,9 +177,6 @@ extern struct ctl_table random_table[];
 #ifdef CONFIG_INOTIFY_USER
 extern struct ctl_table inotify_table[];
 #endif
-#ifdef CONFIG_EPOLL
-extern struct ctl_table epoll_table[];
-#endif
 
 /* The default sysctl tables: */
 
