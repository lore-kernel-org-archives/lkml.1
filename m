Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0BUOZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:25:24 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:58923 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265Ab0BUOZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:25:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=OvflAsHkh7lMHEFZO4up6q2cgIhKa0Zl+dGGmmsTmgipthKXTd8RR/rH39AG4c2ljA
         TTk8hrLltFOWOJvHVqs83I4mxcd2VH3r2w3BRki0At2PNuyKwIU9GTHJHZOmaGefb+Hd
         eiJ6S8iRinY/wdndUxPjGNI/R0QLgQeNgWb6w=
Date: Sun, 21 Feb 2010 22:25:12 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 14/17] sysctl extern cleanup - rtmutex
Message-ID: <20100221142512.GA3027@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move max_lock_depth extern declaration to linux/rtmutex.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/rtmutex.h |    2 ++
 kernel/sysctl.c         |    7 +++----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/include/linux/rtmutex.h	2010-02-21 11:12:13.050112777 +0800
+++ linux-2.6.32/include/linux/rtmutex.h	2010-02-21 11:22:18.069219013 +0800
@@ -16,6 +16,8 @@
 #include <linux/plist.h>
 #include <linux/spinlock_types.h>
 
+extern int max_lock_depth; /* for sysctl */
+
 /**
  * The rt_mutex structure
  *
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 11:22:08.955888265 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 11:22:37.322552208 +0800
@@ -66,6 +66,9 @@
 #ifdef CONFIG_BSD_PROCESS_ACCT
 #include <linux/acct.h>
 #endif
+#ifdef CONFIG_RT_MUTEXES
+#include <linux/rtmutex.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -138,10 +141,6 @@ extern int unaligned_dump_stack;
 
 extern struct ratelimit_state printk_ratelimit_state;
 
-#ifdef CONFIG_RT_MUTEXES
-extern int max_lock_depth;
-#endif
-
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
