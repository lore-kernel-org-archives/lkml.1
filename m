Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980Ab0BTOPo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:15:44 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:64619 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab0BTOPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:15:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=pPCOzE6LVcj1oC4eKP0GUsacS6kELdYR39tjjdAFNEq+R9WOJr4tVIqAJbdv5LqRIG
         iHzYS/URzAZsLS2dQ3ljAk37RpbnfBukAUouufQx8rq89/D68r3QQmpXz0RX52ufbgeK
         OuJ3DcViIuvb9mtwvtg/7URE3pewAKv0FiiwM=
Date: Sat, 20 Feb 2010 22:15:34 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 09/18] sysctl extern cleanup - file nr
Message-ID: <20100220141534.GH3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move sysctl_nr_open_min, sysctl_nr_open_max extern declarations to linux/file.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/file.h |    3 +++
 kernel/sysctl.c      |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.32.orig/include/linux/file.h	2010-02-20 14:02:22.601592643 +0800
+++ linux-2.6.32/include/linux/file.h	2010-02-20 14:23:05.188136249 +0800
@@ -9,6 +9,9 @@
 #include <linux/types.h>
 #include <linux/posix_types.h>
 
+#ifdef CONFIG_SYSCTL
+extern int sysctl_nr_open_min, sysctl_nr_open_max;
+#endif
 struct file;
 
 extern void __fput(struct file *);
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:17:53.132332896 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:22:30.728971346 +0800
@@ -60,6 +60,7 @@
 #include <linux/pid.h>
 #include <linux/compat.h>
 #include <linux/latencytop.h>
+#include <linux/file.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -74,7 +75,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifdef CONFIG_RCU_TORTURE_TEST
 extern int rcutorture_runnable;
 #endif /* #ifdef CONFIG_RCU_TORTURE_TEST */
