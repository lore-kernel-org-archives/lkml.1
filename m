Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZDMD4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZDMD4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 23:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329AbZDMDzz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 23:55:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64602 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbZDMDzz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 23:55:55 -0400
Message-ID: <49E2B7BF.6000601@cn.fujitsu.com>
Date: Mon, 13 Apr 2009 11:55:43 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tracing, syscalltrace: Move include/trace/syscall.h to
 include/linux/syscalltrace.h
References: <49E2B763.8060706@cn.fujitsu.com>
In-Reply-To: <49E2B763.8060706@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: refactor code, no functionality changed

Files in include/trace/ should be definition of tracepoints, and header
file for syscall trace should put to include/linux/.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 arch/x86/kernel/ftrace.c                          |    3 +--
 arch/x86/kernel/ptrace.c                          |    3 +--
 include/linux/syscalls.h                          |    2 +-
 include/{trace/syscall.h => linux/syscalltrace.h} |    0 
 kernel/trace/trace_syscalls.c                     |    2 +-
 5 files changed, 4 insertions(+), 6 deletions(-)
 rename include/{trace/syscall.h => linux/syscalltrace.h} (100%)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 18dfa30..63ab16e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -17,8 +17,7 @@
 #include <linux/sched.h>
 #include <linux/init.h>
 #include <linux/list.h>
-
-#include <trace/syscall.h>
+#include <linux/syscalltrace.h>
 
 #include <asm/cacheflush.h>
 #include <asm/ftrace.h>
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index d5252ae..25428a9 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -22,6 +22,7 @@
 #include <linux/seccomp.h>
 #include <linux/signal.h>
 #include <linux/workqueue.h>
+#include <linux/syscalltrace.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -35,8 +36,6 @@
 #include <asm/proto.h>
 #include <asm/ds.h>
 
-#include <trace/syscall.h>
-
 #include "tls.h"
 
 enum x86_regset {
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 35bbf67..3c207e9 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -66,7 +66,7 @@ struct perf_counter_hw_event;
 #include <asm/signal.h>
 #include <linux/quota.h>
 #include <linux/key.h>
-#include <trace/syscall.h>
+#include <linux/syscalltrace.h>
 
 #define __SC_DECL1(t1, a1)	t1 a1
 #define __SC_DECL2(t2, a2, ...) t2 a2, __SC_DECL1(__VA_ARGS__)
diff --git a/include/trace/syscall.h b/include/linux/syscalltrace.h
similarity index 100%
rename from include/trace/syscall.h
rename to include/linux/syscalltrace.h
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index 5e57964..ab00bc5 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -1,4 +1,4 @@
-#include <trace/syscall.h>
+#include <linux/syscalltrace.h>
 #include <linux/kernel.h>
 #include <asm/syscall.h>
 
-- 
1.5.5.3


