Return-Path: <linux-kernel-owner+w=401wt.eu-S1752911AbZH1M3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911AbZH1M3O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbZH1M3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:29:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:55482 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbZH1M3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:29:06 -0400
Date: Fri, 28 Aug 2009 12:28:30 GMT
From: tip-bot for Jason Baron <jbaron@redhat.com>
Cc: brueckner@linux.vnet.ibm.com, mathieu.desnoyers@polymtl.ca,
       mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jiayingz@google.com, lizf@cn.fujitsu.com,
       lethal@linux-sh.org, jistone@redhat.com, mingo@elte.hu,
       mbligh@google.com
Reply-To: mingo@redhat.com, mathieu.desnoyers@polymtl.ca,
       brueckner@linux.vnet.ibm.com, peterz@infradead.org, fweisbec@gmail.com,
       rostedt@goodmis.org, heiko.carstens@de.ibm.com, tglx@linutronix.de,
       jbaron@redhat.com, laijs@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       hpa@zytor.com, jiayingz@google.com, lizf@cn.fujitsu.com,
       lethal@linux-sh.org, jistone@redhat.com, mingo@elte.hu,
       mbligh@google.com
In-Reply-To: <20090826160910.GB2658@redhat.com>
References: <20090826160910.GB2658@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing: Define NR_syscalls for x86_64
Message-ID: <tip-a5a2f8e2acb991327952c45a13f5441fc09dffd6@git.kernel.org>
Git-Commit-ID: a5a2f8e2acb991327952c45a13f5441fc09dffd6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 28 Aug 2009 12:28:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5a2f8e2acb991327952c45a13f5441fc09dffd6
Gitweb:     http://git.kernel.org/tip/a5a2f8e2acb991327952c45a13f5441fc09dffd6
Author:     Jason Baron <jbaron@redhat.com>
AuthorDate: Wed, 26 Aug 2009 12:09:10 -0400
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 26 Aug 2009 21:29:58 +0200

tracing: Define NR_syscalls for x86_64

Express the available number of syscalls in a standard way by defining
NR_syscalls.

The common way to define it is to place its definition in asm/unistd.h
However, the number of syscalls is defined using __NR_syscall_max in
x86-64 after building a dynamic header file "asm-offsets.h"

The source file that generates this header, asm-offsets-64.c includes
unistd.h, then if we want to express NR_syscalls from __NR_syscall_max
in unistd.h only after generating the dynamic header file, we need a
watchguard.

If unistd.h is included from asm-offsets-64.c, then we are generating
asm-offset.h which defines __NR_syscall_max. At this time, we don't
want to (we can't) define NR_syscalls, then we do nothing.
Otherwise we define NR_syscalls because we know asm-offsets.h has
been generated.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Josh Stone <jistone@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anwin <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <20090826160910.GB2658@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>


---
 arch/x86/include/asm/unistd_64.h |    6 ++++++
 arch/x86/kernel/asm-offsets_64.c |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 900e161..b9f3c60 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -688,6 +688,12 @@ __SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
 #endif	/* __NO_STUBS */
 
 #ifdef __KERNEL__
+
+#ifndef COMPILE_OFFSETS
+#include <asm/asm-offsets.h>
+#define NR_syscalls (__NR_syscall_max + 1)
+#endif
+
 /*
  * "Conditional" syscalls
  *
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 898ecc4..4a6aeed 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -3,6 +3,7 @@
  * This code generates raw asm output which is post-processed to extract
  * and format the required data.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/crypto.h>
 #include <linux/sched.h> 
