Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab0BUOX2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:23:28 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62966 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752178Ab0BUOXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:23:11 -0500
X-Greylist: delayed 86383 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 09:23:03 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=KywY/5lxzymxexCFbaAa48zP6EI5k/l5Mzv8qj4HCw1bU/481yaAqVtPv/ML6xjTkK
         Pf3X17G6uXZvD5+Z2SBqxYr+LM89iId6e2SXf4sZkmjckFPS1LbWTIi0dWuLOT6ozssY
         SEhNtn3UZ075rGlpqqvpkWSVkYEXjAF+SuLLA=
Date: Sun, 21 Feb 2010 22:23:03 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 03/17] sysctl extern cleanup - binfmts
Message-ID: <20100221142303.GA3004@darkstar>
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
 include/linux/binfmts.h |    5 +++++
 kernel/sysctl.c         |    5 +----
 2 files changed, 6 insertions(+), 4 deletions(-)

--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 09:43:05.206481916 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 09:44:39.479806692 +0800
@@ -55,6 +55,7 @@
 #include <linux/perf_event.h>
 #include <linux/rcustring.h>
 #include <linux/signal.h>
+#include <linux/binfmts.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -70,10 +71,6 @@
 
 /* External variables not in a header file. */
 extern int max_threads;
-extern int core_uses_pid;
-extern int suid_dumpable;
-extern char *core_pattern;
-extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int min_free_kbytes;
 extern int pid_max_min, pid_max_max;
--- linux-2.6.32.orig/include/linux/binfmts.h	2010-02-21 09:35:58.627357104 +0800
+++ linux-2.6.32/include/linux/binfmts.h	2010-02-21 09:45:32.279801314 +0800
@@ -20,6 +20,11 @@ struct pt_regs;
 #ifdef __KERNEL__
 #include <linux/list.h>
 
+/* for sysctl */
+extern int core_uses_pid;
+extern char *core_pattern;
+extern unsigned int core_pipe_limit;
+
 #define CORENAME_MAX_SIZE 128
 
 /*
