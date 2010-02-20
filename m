Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab0BTOKf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:10:35 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:57075 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0BTOKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:10:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CqWMUe8RKj79NGKgJWxJSXAB/sIE0T1XhGoQCrUcwZXXvZqbWQTykyrfJkkRi4pdc3
         xVZQCHm8hG7DMysbPbIQ9mCP5mbEcWMhWWLCcEv/DiqDWcQIBi7j7uBsR27jP3QnnJpH
         7SgZYwRIPTl4XrGxBXTKIvECaoxFqZldaUvaE=
Date: Sat, 20 Feb 2010 22:10:23 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 04/18] sysctl extern cleanup - binfmts
Message-ID: <20100220141023.GC3195@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move core_uses_pid/core_pattern/core_pipe_limit extern declarations
to linux/binfmts.h
suid_dumpable is declared in binfmts.h already.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/binfmts.h |    6 ++++++
 kernel/sysctl.c         |    5 +----
 2 files changed, 7 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:06:33.374900066 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:06:42.621567640 +0800
@@ -56,6 +56,7 @@
 #include <linux/rcustring.h>
 #include <linux/signal.h>
 #include <linux/threads.h>
+#include <linux/binfmts.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -70,10 +71,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int core_uses_pid;
-extern int suid_dumpable;
-extern char *core_pattern;
-extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
--- linux-2.6.32.orig/include/linux/binfmts.h	2010-02-20 14:02:26.958258402 +0800
+++ linux-2.6.32/include/linux/binfmts.h	2010-02-20 14:06:42.621567640 +0800
@@ -20,6 +20,12 @@ struct pt_regs;
 #ifdef __KERNEL__
 #include <linux/list.h>
 
+#ifdef CONFIG_SYSCTL
+extern int core_uses_pid;
+extern char *core_pattern;
+extern unsigned int core_pipe_limit;
+#endif
+
 #define CORENAME_MAX_SIZE 128
 
 /*
