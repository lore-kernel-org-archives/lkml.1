Return-Path: <linux-kernel-owner+w=401wt.eu-S1754990AbZIMDGo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbZIMDGo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 23:06:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754875AbZIMDGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 23:06:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59058 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbZIMDGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 23:06:14 -0400
Message-Id: <20090913030616.992539807@goodmis.org>
References: <20090913030543.204871396@goodmis.org>
User-Agent: quilt/0.46-1
Date: Sat, 12 Sep 2009 23:05:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/4] tracing/function-graph: x86_64 stack allocation cleanup
Content-Disposition: inline; filename=0002-tracing-function-graph-x86_64-stack-allocation-clean.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Only 24 bytes needs to be reserved on the stack for the function graph
tracer on x86_64.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <20090729085837.GB4998@jolsa.lab.eng.brq.redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/entry_64.S |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c251be7..d59fe32 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -146,7 +146,7 @@ ENTRY(ftrace_graph_caller)
 END(ftrace_graph_caller)
 
 GLOBAL(return_to_handler)
-	subq  $80, %rsp
+	subq  $24, %rsp
 
 	/* Save the return values */
 	movq %rax, (%rsp)
@@ -155,10 +155,10 @@ GLOBAL(return_to_handler)
 
 	call ftrace_return_to_handler
 
-	movq %rax, 72(%rsp)
+	movq %rax, 16(%rsp)
 	movq 8(%rsp), %rdx
 	movq (%rsp), %rax
-	addq $72, %rsp
+	addq $16, %rsp
 	retq
 #endif
 
-- 
1.6.3.3

-- 
