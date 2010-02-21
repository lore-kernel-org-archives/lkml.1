Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab0BUObn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:31:43 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:60021 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab0BUObm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:31:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=o3uKbr+kY2l0YBA+L3k2T2Am4jmJyInOjvSLZIvWLyzTCI8pg9bWS3RwAVRSjpq7S2
         sRAhHRMdikLpBqMqusaAbz8NXKTPeU7bNhHBQrHsuNUHvIXQn8hiDlgrgMFo1H9lVzzU
         xAlmQEoDCp/5ocLhRHTiP5WqJkEgwO2otKo10=
Date: Sun, 21 Feb 2010 22:25:23 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joel Becker <joel.becker@oracle.com>, James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 15/17] sysctl extern cleanup - lockdep
Message-ID: <20100221142523.GA3028@darkstar>
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
 include/linux/lockdep.h |    4 ++++
 kernel/sysctl.c         |    6 +++---
 2 files changed, 7 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/include/linux/lockdep.h	2010-02-21 11:12:12.463446879 +0800
+++ linux-2.6.32/include/linux/lockdep.h	2010-02-21 11:22:50.809216778 +0800
@@ -12,6 +12,10 @@
 struct task_struct;
 struct lockdep_map;
 
+/* for sysctl */
+extern int prove_locking;
+extern int lock_stat;
+
 #ifdef CONFIG_LOCKDEP
 
 #include <linux/linkage.h>
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 11:22:37.322552208 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 11:23:13.929215242 +0800
@@ -69,6 +69,9 @@
 #ifdef CONFIG_RT_MUTEXES
 #include <linux/rtmutex.h>
 #endif
+#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_LOCK_STAT)
+#include <linux/lockdep.h>
+#endif
 #ifdef CONFIG_CHR_DEV_SG
 #include <scsi/sg.h>
 #endif
@@ -175,9 +178,6 @@ extern struct ctl_table inotify_table[];
 extern struct ctl_table epoll_table[];
 #endif
 
-extern int prove_locking;
-extern int lock_stat;
-
 /* The default sysctl tables: */
 
 static struct ctl_table root_table[] = {
