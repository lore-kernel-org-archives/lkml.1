Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbXKET2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbXKET2U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:28:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbXKET2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:28:06 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:47841 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXKET2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:28:04 -0500
Date: Mon, 5 Nov 2007 14:27:48 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 5/6] UML - clone.c tidying
Message-ID: <20071105192748.GA8793@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

clone.c needed some style attention -
	updated copyright
	include trimming
	coding style

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/skas/clone.c |   32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

Index: linux-2.6/arch/um/kernel/skas/clone.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/skas/clone.c	2007-11-05 14:06:09.000000000 -0500
+++ linux-2.6/arch/um/kernel/skas/clone.c	2007-11-05 14:13:50.000000000 -0500
@@ -1,17 +1,20 @@
-#include <sched.h>
+/*
+ * Copyright (C) 2007 Jeff Dike (jdike@{addtoit,linux.intel}.com)
+ * Licensed under the GPL
+ */
+
 #include <signal.h>
-#include <sys/mman.h>
-#include <sys/time.h>
+#include <sched.h>
 #include <asm/unistd.h>
+#include <sys/time.h>
 #include "as-layout.h"
+#include "kern_constants.h"
 #include "ptrace_user.h"
-#include "skas.h"
 #include "stub-data.h"
-#include "uml-config.h"
 #include "sysdep/stub.h"
-#include "kern_constants.h"
 
-/* This is in a separate file because it needs to be compiled with any
+/*
+ * This is in a separate file because it needs to be compiled with any
  * extraneous gcc flags (-pg, -fprofile-arcs, -ftest-coverage) disabled
  *
  * Use UM_KERN_PAGE_SIZE instead of PAGE_SIZE because that calls getpagesize
@@ -26,25 +29,26 @@ stub_clone_handler(void)
 
 	err = stub_syscall2(__NR_clone, CLONE_PARENT | CLONE_FILES | SIGCHLD,
 			    STUB_DATA + UM_KERN_PAGE_SIZE / 2 - sizeof(void *));
-	if(err != 0)
+	if (err != 0)
 		goto out;
 
 	err = stub_syscall4(__NR_ptrace, PTRACE_TRACEME, 0, 0, 0);
-	if(err)
+	if (err)
 		goto out;
 
-	err = stub_syscall3(__NR_setitimer, ITIMER_VIRTUAL, 
+	err = stub_syscall3(__NR_setitimer, ITIMER_VIRTUAL,
 			    (long) &data->timer, 0);
-	if(err)
+	if (err)
 		goto out;
 
 	remap_stack(data->fd, data->offset);
 	goto done;
 
  out:
-	/* save current result. 
-	 * Parent: pid; 
-	 * child: retcode of mmap already saved and it jumps around this 
+	/*
+	 * save current result.
+	 * Parent: pid;
+	 * child: retcode of mmap already saved and it jumps around this
 	 * assignment
 	 */
 	data->err = err;
