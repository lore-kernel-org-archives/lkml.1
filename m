Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab0BTOIG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 09:08:06 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:56996 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432Ab0BTOIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 09:08:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=UpnwFzjZcMm/Y3b47/OPz1dyr1qULQuO2IAqQLbcIAmxtnXNRWrs+cqMNrnYU48JS3
         b93Y65DIuU/wj0sqEDF7aD3Uf24B5ZJb1kHUxqRn2Nidpj8nDPcO+DdyMCp1jOCd/vTY
         vyoXRfLeFY7rc0h7yDBFyhw0dxIzWieO9dzRU=
Date: Sat, 20 Feb 2010 22:07:44 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Roland McGrath <roland@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 02/18] sysctl extern cleanup - signal
Message-ID: <20100220140744.GA3195@darkstar>
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
 include/linux/signal.h |    3 +++
 kernel/sysctl.c        |    2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- linux-2.6.32.orig/include/linux/signal.h	2010-02-20 14:02:28.674925069 +0800
+++ linux-2.6.32/include/linux/signal.h	2010-02-20 14:06:02.014905163 +0800
@@ -7,6 +7,9 @@
 #ifdef __KERNEL__
 #include <linux/list.h>
 
+#ifdef CONFIG_SYSCTL
+extern int print_fatal_signals;
+#endif
 /*
  * Real Time signals may be queued.
  */
--- linux-2.6.32.orig/kernel/sysctl.c	2010-02-20 14:03:41.452418032 +0800
+++ linux-2.6.32/kernel/sysctl.c	2010-02-20 14:05:17.149075410 +0800
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
