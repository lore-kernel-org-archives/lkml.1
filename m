Return-Path: <linux-kernel-owner+w=401wt.eu-S936220AbXHNWA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936220AbXHNWA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 18:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934732AbXHNVkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 17:40:51 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:42223 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934590AbXHNVkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 17:40:43 -0400
Date: Tue, 14 Aug 2007 17:40:17 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/14] UML - Remove sysdep/thread.h
Message-ID: <20070814214017.GA17285@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes thread.h, which turns out not to be needed any more.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/include/sysdep-i386/kernel-offsets.h |    1 -
 arch/um/include/sysdep-i386/sigcontext.h     |    3 ++-
 arch/um/include/sysdep-i386/thread.h         |    8 --------
 arch/um/include/sysdep-x86_64/thread.h       |    6 ------
 arch/um/sys-i386/ptrace_user.c               |    1 -
 5 files changed, 2 insertions(+), 17 deletions(-)

Index: linux-2.6.22/arch/um/include/sysdep-i386/sigcontext.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/sysdep-i386/sigcontext.h	2007-08-09 13:25:53.000000000 -0400
+++ linux-2.6.22/arch/um/include/sysdep-i386/sigcontext.h	2007-08-09 14:27:51.000000000 -0400
@@ -7,7 +7,8 @@
 #define __SYS_SIGCONTEXT_I386_H
 
 #include "uml-config.h"
-#include <sysdep/sc.h>
+#include "skas.h"
+#include "sysdep/sc.h"
 
 #define IP_RESTART_SYSCALL(ip) ((ip) -= 2)
 
Index: linux-2.6.22/arch/um/include/sysdep-i386/kernel-offsets.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/sysdep-i386/kernel-offsets.h	2007-07-08 19:32:17.000000000 -0400
+++ linux-2.6.22/arch/um/include/sysdep-i386/kernel-offsets.h	2007-08-09 14:43:15.000000000 -0400
@@ -17,6 +17,5 @@
 
 void foo(void)
 {
-	OFFSET(HOST_TASK_DEBUGREGS, task_struct, thread.arch.debugregs);
 #include <common-offsets.h>
 }
Index: linux-2.6.22/arch/um/include/sysdep-i386/thread.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/sysdep-i386/thread.h	2007-08-09 13:25:53.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,8 +0,0 @@
-#ifndef __UM_THREAD_H
-#define __UM_THREAD_H
-
-#include <kern_constants.h>
-
-#define TASK_DEBUGREGS(task) ((unsigned long *) &(((char *) (task))[HOST_TASK_DEBUGREGS]))
-
-#endif
Index: linux-2.6.22/arch/um/sys-i386/ptrace_user.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/ptrace_user.c	2007-08-09 13:25:53.000000000 -0400
+++ linux-2.6.22/arch/um/sys-i386/ptrace_user.c	2007-08-09 14:44:17.000000000 -0400
@@ -11,7 +11,6 @@
 /* Grr, asm/user.h includes asm/ptrace.h, so has to follow ptrace_user.h */
 #include <asm/user.h>
 #include "kern_util.h"
-#include "sysdep/thread.h"
 #include "user.h"
 #include "os.h"
 #include "uml-config.h"
Index: linux-2.6.22/arch/um/include/sysdep-x86_64/thread.h
===================================================================
--- linux-2.6.22.orig/arch/um/include/sysdep-x86_64/thread.h	2007-08-09 13:25:53.000000000 -0400
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,6 +0,0 @@
-#ifndef __UM_THREAD_H
-#define __UM_THREAD_H
-
-#include <kern_constants.h>
-
-#endif
