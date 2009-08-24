Return-Path: <linux-kernel-owner+w=401wt.eu-S1753767AbZHXVom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbZHXVom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 17:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbZHXVol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 17:44:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbZHXVnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 17:43:55 -0400
Date: Mon, 24 Aug 2009 17:40:18 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Cc: lethal@linux-sh.org, fweisbec@gmail.com, mingo@elte.hu,
       laijs@cn.fujitsu.com, rostedt@goodmis.org, peterz@infradead.org,
       mathieu.desnoyers@polymtl.ca, jiayingz@google.com, mbligh@google.com,
       lizf@cn.fujitsu.com, jistone@redhat.com, tglx@linutronix.de,
       hpa@zytor.com
Message-Id: <233dfaa6fadd5aa2fa7ac8511ed9ab98a5f2619c.1251146513.git.jbaron@redhat.com>
In-Reply-To: <cover.1251146512.git.jbaron@redhat.com>
References: <cover.1251146512.git.jbaron@redhat.com>
Subject: [PATCH 2/4] Add NR_syscalls for x86_64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a dynamic definition of NR_syscalls for x86_64. This is used in the 
syscall events tracing code.

Signed-off-by: Jason Baron <jbaron@redhat.com>

---
 include/linux/ftrace.h |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index dc3b132..3bd94ee 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -14,6 +14,11 @@
 
 #include <asm/ftrace.h>
 
+#ifdef CONFIG_X86_64
+#include <asm/asm-offsets.h>
+#define NR_syscalls (__NR_syscall_max + 1)
+#endif
+
 #ifdef CONFIG_FUNCTION_TRACER
 
 extern int ftrace_enabled;
-- 
1.6.2.5

