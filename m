Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223Ab0BTOUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:20:48 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:59725 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755952Ab0BTOUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:20:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=X69uHmMayNwHVN45/IThRxdttQxg7qeJlfQ9MGaJgkjbhozgZwtUqrd0JahNTfIrxO
         9X2V8ke439SXTQgmG+MWlzIJDr/CK5azxGMtLRcGlvXTwLcanFW6ZN5/176d1cFVyF9x
         BBqAyznEltl5x/OdHeVWTCj2Je+fRkMoceVk0=
Date: Sat, 20 Feb 2010 22:20:34 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 15/18] sysctl extern cleanup - rtmutex
Message-ID: <20100220142034.GN3195@darkstar>
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
 include/linux/rtmutex.h |    4 ++++
 kernel/sysctl.c         |    5 +----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/include/linux/rtmutex.h	2010-02-20 14:02:17.074926676 +0800
+++ linux-2.6.32/include/linux/rtmutex.h	2010-02-20 14:41:34.618025132 +0800
@@ -16,6 +16,10 @@
 #include <linux/plist.h>
 #include <linux/spinlock_types.h>
 
+#if defined(CONFIG_SYSCTL) && defined(CONFIG_RT_MUTEXES)
+extern int max_lock_depth;
+#endif
+
 /**
  * The rt_mutex structure
  *
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:40:22.392198031 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:40:24.232197892 +0800
@@ -63,6 +63,7 @@
 #include <linux/file.h>
 #include <linux/blk-iopoll.h>
 #include <linux/acct.h>
+#include <linux/rtmutex.h>
 #include <scsi/sg.h>
 
 #include <asm/uaccess.h>
@@ -130,10 +131,6 @@ extern int unaligned_dump_stack;
 
 extern struct ratelimit_state printk_ratelimit_state;
 
-#ifdef CONFIG_RT_MUTEXES
-extern int max_lock_depth;
-#endif
-
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
