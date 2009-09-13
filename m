Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbZIMPCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbZIMPCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 11:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754560AbZIMPCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 11:02:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:32835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbZIMPCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 11:02:53 -0400
Date: Sun, 13 Sep 2009 15:02:35 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <20090729085837.GB4998@jolsa.lab.eng.brq.redhat.com>
References: <20090729085837.GB4998@jolsa.lab.eng.brq.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] tracing/function-graph: x86_64 stack allocation cleanup
Message-ID: <tip-4818d80942b7c0021d213b7c5f1a14a832820a01@git.kernel.org>
Git-Commit-ID: 4818d80942b7c0021d213b7c5f1a14a832820a01
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 13 Sep 2009 15:02:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4818d80942b7c0021d213b7c5f1a14a832820a01
Gitweb:     http://git.kernel.org/tip/4818d80942b7c0021d213b7c5f1a14a832820a01
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 29 Jul 2009 10:58:37 +0200
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Sat, 12 Sep 2009 22:13:43 -0400

tracing/function-graph: x86_64 stack allocation cleanup

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
 
