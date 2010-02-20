Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab0BTOJR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:09:17 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:35830 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0BTOJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:09:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JtuFoztfSchpoO4JENewHxId7CYPTJRu4Yy5qXzPGVQVmCHvIcsh3j9PtXMIJrRmG5
         I2os1+ERnpfhmo53rYJ4V9vUrkpouDPGn3i9Dq/TQUMlPcut4JScuS4zh6Y8uQP4czgQ
         A0aIsq6MlMWFrwxN6n+Xwoy+uLVlMIU7mnne8=
Date: Sat, 20 Feb 2010 22:09:05 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       James Morris <jmorris@namei.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 03/18] sysctl extern cleanup - threads
Message-ID: <20100220140905.GB3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move max_threads extern declaration to linux/threads.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/threads.h |    1 +
 kernel/fork.c           |    1 +
 kernel/kmod.c           |    3 +--
 kernel/sysctl.c         |    2 +-
 4 files changed, 4 insertions(+), 3 deletions(-)

--- linux-2.6.32.orig/include/linux/threads.h	2010-02-12 12:47:27.001982416 +0800
+++ linux-2.6.32/include/linux/threads.h	2010-02-12 12:48:49.593449580 +0800
@@ -6,6 +6,7 @@
  * The default limit for the nr of threads is now in
  * /proc/sys/kernel/threads-max.
  */
+extern int max_threads;
 
 /*
  * Maximum supported processors.  Setting this smaller saves quite a
--- linux-2.6.32.orig/kernel/fork.c	2010-02-12 12:46:48.602820586 +0800
+++ linux-2.6.32/kernel/fork.c	2010-02-12 12:50:36.868631765 +0800
@@ -65,6 +65,7 @@
 #include <linux/perf_event.h>
 #include <linux/posix-timers.h>
 #include <linux/user-return-notifier.h>
+#include <linux/threads.h>
 
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
--- linux-2.6.32.orig/kernel/kmod.c	2010-02-12 12:46:45.736154059 +0800
+++ linux-2.6.32/kernel/kmod.c	2010-02-12 12:49:29.128638259 +0800
@@ -36,12 +36,11 @@
 #include <linux/notifier.h>
 #include <linux/suspend.h>
 #include <linux/rcustring.h>
+#include <linux/threads.h>
 #include <asm/uaccess.h>
 
 #include <trace/events/module.h>
 
-extern int max_threads;
-
 static struct workqueue_struct *khelper_wq;
 
 #ifdef CONFIG_MODULES
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-12 12:46:42.202820096 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-12 12:50:08.065301362 +0800
@@ -55,6 +55,7 @@
 #include <linux/perf_event.h>
 #include <linux/rcustring.h>
 #include <linux/signal.h>
+#include <linux/threads.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -69,7 +70,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
 extern char *core_pattern;
