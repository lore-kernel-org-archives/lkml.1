Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbZD2MMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbZD2MMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 08:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbZD2MMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 08:12:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:44178 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757233AbZD2MMC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 08:12:02 -0400
Date: Wed, 29 Apr 2009 12:10:01 GMT
From: tip-bot for Heiko Carstens <heiko.carstens@de.ibm.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, sachinp@in.ibm.com, heiko.carstens@de.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090429135139.5fac79b8@osiris.boeblingen.de.ibm.com>
References: <20090429135139.5fac79b8@osiris.boeblingen.de.ibm.com>
Subject: [tip:tracing/core] tracing: fix build failure on s390
Message-ID: <tip-a0e39ed378fb6ba916522764cd508fa7d42ad495@git.kernel.org>
Git-Commit-ID: a0e39ed378fb6ba916522764cd508fa7d42ad495
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 12:10:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0e39ed378fb6ba916522764cd508fa7d42ad495
Gitweb:     http://git.kernel.org/tip/a0e39ed378fb6ba916522764cd508fa7d42ad495
Author:     Heiko Carstens <heiko.carstens@de.ibm.com>
AuthorDate: Wed, 29 Apr 2009 13:51:39 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 14:06:21 +0200

tracing: fix build failure on s390

"tracing: create automated trace defines" causes this compile error on s390,
as reported by Sachin Sant against linux-next:

 kernel/built-in.o: In function `__do_softirq':
 (.text+0x1c680): undefined reference to `__tracepoint_softirq_entry'

This happens because the definitions of the softirq tracepoints were moved
from kernel/softirq.c to kernel/irq/handle.c. Since s390 doesn't support
generic hardirqs handle.c doesn't get compiled and the definitions are
missing.

So move the tracepoints to softirq.c again.

[ Impact: fix build failure on s390 ]

Reported-by: Sachin Sant <sachinp@in.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: fweisbec@gmail.com
LKML-Reference: <20090429135139.5fac79b8@osiris.boeblingen.de.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/irq/handle.c |    2 --
 kernel/softirq.c    |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/irq/handle.c b/kernel/irq/handle.c
index 37c6363..e68bb5a 100644
--- a/kernel/irq/handle.c
+++ b/kernel/irq/handle.c
@@ -18,8 +18,6 @@
 #include <linux/rculist.h>
 #include <linux/hash.h>
 #include <linux/bootmem.h>
-
-#define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
 
 #include "internals.h"
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 7ab9dfd..d4ba347 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -24,6 +24,8 @@
 #include <linux/ftrace.h>
 #include <linux/smp.h>
 #include <linux/tick.h>
+
+#define CREATE_TRACE_POINTS
 #include <trace/events/irq.h>
 
 #include <asm/irq.h>
