Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0BTOVe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:21:34 -0500
Received: from mail-gx0-f217.google.com ([209.85.217.217]:33091 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab0BTOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:21:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=H09c+WOfHUjaEMp5nHGJHr8mlAeKs/KSvuAVwnI45duusTPrkrWcQBjGwqbX8PYMmc
         6RzKWv8wTI7O1MCLrkd2Rr6B/8Xugy43jhsp74aOtJ+6W0u/dZE5fHl3snQHv+E1Q2o9
         3kRgiq9dqX+nKn0qK/BQ9IFiN29ymhBjbVOZk=
Date: Sat, 20 Feb 2010 22:21:23 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joel Becker <joel.becker@oracle.com>, James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 16/18] sysctl extern cleanup - lockdep
Message-ID: <20100220142123.GO3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move lockdep extern declarations to linux/lockdep.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/lockdep.h |    5 +++++
 kernel/sysctl.c         |    4 +---
 2 files changed, 6 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/include/linux/lockdep.h	2010-02-20 14:02:16.481592295 +0800
+++ linux-2.6.32/include/linux/lockdep.h	2010-02-20 14:42:48.091351691 +0800
@@ -11,6 +11,11 @@
 
 struct task_struct;
 struct lockdep_map;
+#ifdef CONFIG_SYSCTL
+extern int prove_locking;
+extern int lock_stat;
+#endif
+
 
 #ifdef CONFIG_LOCKDEP
 
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:40:24.232197892 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:41:41.625522844 +0800
@@ -64,6 +64,7 @@
 #include <linux/blk-iopoll.h>
 #include <linux/acct.h>
 #include <linux/rtmutex.h>
+#include <linux/lockdep.h>
 #include <scsi/sg.h>
 
 #include <asm/uaccess.h>
@@ -165,9 +166,6 @@ extern struct ctl_table inotify_table[];
 extern struct ctl_table epoll_table[];
 #endif
 
-extern int prove_locking;
-extern int lock_stat;
-
 /* The default sysctl tables: */
 
 static struct ctl_table root_table[] = {
