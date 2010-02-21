Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab0BUOXF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:23:05 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62966 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0BUOXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:23:04 -0500
X-Greylist: delayed 86383 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Feb 2010 09:23:03 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CHYEbGfcXrbFlS22B+J9+pyyfpqPnHAtYhokuDiEunPZzYLN4VFjY7ZBJezrzisVhN
         6dl1YK/ajSLt6XCia5CIo+Dd5lA6SB25W+oUEcqhdFig5rIAM1nqKRe2/9WA6NsacTlk
         OewTw586ezSrnB34FLrR3xeEWv47pFYDcEzWc=
Date: Sun, 21 Feb 2010 22:22:51 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 02/17] sysctl extern cleanup - signal
Message-ID: <20100221142251.GA3002@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extern declarations in sysctl.c should be move to their own head file,
and then include them in relavant .c files.

Move print_fatal_signals extern declaration to linux/signal.h

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
 include/linux/signal.h |    2 ++
 kernel/sysctl.c        |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.32.orig/include/linux/signal.h	2010-02-21 09:35:58.913190280 +0800
+++ linux-2.6.32/include/linux/signal.h	2010-02-21 09:41:38.006491648 +0800
@@ -7,6 +7,8 @@
 #ifdef __KERNEL__
 #include <linux/list.h>
 
+/* for sysctl */
+extern int print_fatal_signals;
 /*
  * Real Time signals may be queued.
  */
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-21 09:38:12.793177219 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-21 09:40:41.683996252 +0800
@@ -54,6 +54,7 @@
 #include <linux/slow-work.h>
 #include <linux/perf_event.h>
 #include <linux/rcustring.h>
+#include <linux/signal.h>
 
 #include <asm/uaccess.h>
 #include <asm/processor.h>
@@ -68,7 +69,6 @@
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
-extern int print_fatal_signals;
 extern int max_threads;
 extern int core_uses_pid;
 extern int suid_dumpable;
