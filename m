Return-Path: <linux-kernel-owner+w=401wt.eu-S1755271AbZEXHCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbZEXHCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbZEXHCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:02:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:35704 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309AbZEXHCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:02:20 -0400
Date: Sun, 24 May 2009 07:01:42 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, jkacur@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, jkacur@redhat.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20090523163012.739756497@chello.nl>
References: <20090523163012.739756497@chello.nl>
Subject: [tip:perfcounters/core] perf_counter: Fix userspace build
Message-ID: <tip-1a482f38c5aafeb3576079a38a5b21b46619f3d2@git.kernel.org>
Git-Commit-ID: 1a482f38c5aafeb3576079a38a5b21b46619f3d2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 24 May 2009 07:01:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a482f38c5aafeb3576079a38a5b21b46619f3d2
Gitweb:     http://git.kernel.org/tip/1a482f38c5aafeb3576079a38a5b21b46619f3d2
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Sat, 23 May 2009 18:28:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 23 May 2009 19:37:46 +0200

perf_counter: Fix userspace build

recent userspace (F11) seems to already include the
linux/unistd.h bits which means we cannot include the version
in the kernel sources due to the header guards being the same.

Ensure we include the kernel version first.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
LKML-Reference: <20090523163012.739756497@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 Documentation/perf_counter/builtin-record.c |    3 +-
 Documentation/perf_counter/builtin-stat.c   |    5 +---
 Documentation/perf_counter/builtin-top.c    |    5 +---
 Documentation/perf_counter/perf.h           |   31 ++++++++++++++++----------
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/Documentation/perf_counter/builtin-record.c b/Documentation/perf_counter/builtin-record.c
index efb8759..1b19f18 100644
--- a/Documentation/perf_counter/builtin-record.c
+++ b/Documentation/perf_counter/builtin-record.c
@@ -1,5 +1,6 @@
 
 
+#include "perf.h"
 #include "util/util.h"
 
 #include <sys/types.h>
@@ -30,9 +31,7 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-#include "../../include/linux/perf_counter.h"
 
-#include "perf.h"
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
diff --git a/Documentation/perf_counter/builtin-stat.c b/Documentation/perf_counter/builtin-stat.c
index 03518d7..8ae01d5 100644
--- a/Documentation/perf_counter/builtin-stat.c
+++ b/Documentation/perf_counter/builtin-stat.c
@@ -61,6 +61,7 @@
   * Released under the GPL v2. (and only v2, not any later version)
   */
 
+#include "perf.h"
 #include "util/util.h"
 
 #include <getopt.h>
@@ -83,10 +84,6 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-#include "../../include/linux/perf_counter.h"
-
-#include "perf.h"
-
 #define EVENT_MASK_KERNEL		1
 #define EVENT_MASK_USER			2
 
diff --git a/Documentation/perf_counter/builtin-top.c b/Documentation/perf_counter/builtin-top.c
index 814b2e4..a3216a6 100644
--- a/Documentation/perf_counter/builtin-top.c
+++ b/Documentation/perf_counter/builtin-top.c
@@ -42,6 +42,7 @@
   * Released under the GPL v2. (and only v2, not any later version)
   */
 
+#include "perf.h"
 #include "util/util.h"
 
 #include <getopt.h>
@@ -64,10 +65,6 @@
 #include <linux/unistd.h>
 #include <linux/types.h>
 
-#include "../../include/linux/perf_counter.h"
-
-#include "perf.h"
-
 static int			system_wide			=  0;
 
 static int			nr_counters			=  0;
diff --git a/Documentation/perf_counter/perf.h b/Documentation/perf_counter/perf.h
index 81a7374..a517683 100644
--- a/Documentation/perf_counter/perf.h
+++ b/Documentation/perf_counter/perf.h
@@ -1,6 +1,25 @@
 #ifndef _PERF_PERF_H
 #define _PERF_PERF_H
 
+#if defined(__x86_64__) || defined(__i386__)
+#include "../../arch/x86/include/asm/unistd.h"
+#define rmb()		asm volatile("lfence" ::: "memory")
+#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
+#endif
+
+#ifdef __powerpc__
+#include "../../arch/powerpc/include/asm/unistd.h"
+#define rmb()		asm volatile ("sync" ::: "memory")
+#define cpu_relax()	asm volatile ("" ::: "memory");
+#endif
+
+#include <time.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/syscall.h>
+
+#include "../../include/linux/perf_counter.h"
+
 /*
  * prctl(PR_TASK_PERF_COUNTERS_DISABLE) will (cheaply) disable all
  * counters in the current task.
@@ -26,18 +45,6 @@ static inline unsigned long long rdclock(void)
 #define __user
 #define asmlinkage
 
-#if defined(__x86_64__) || defined(__i386__)
-#include "../../arch/x86/include/asm/unistd.h"
-#define rmb()		asm volatile("lfence" ::: "memory")
-#define cpu_relax()	asm volatile("rep; nop" ::: "memory");
-#endif
-
-#ifdef __powerpc__
-#include "../../arch/powerpc/include/asm/unistd.h"
-#define rmb()		asm volatile ("sync" ::: "memory")
-#define cpu_relax()	asm volatile ("" ::: "memory");
-#endif
-
 #define unlikely(x)	__builtin_expect(!!(x), 0)
 #define min(x, y) ({				\
 	typeof(x) _min1 = (x);			\
