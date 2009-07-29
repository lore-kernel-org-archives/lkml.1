Return-Path: <linux-kernel-owner+w=401wt.eu-S1752728AbZG2I66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbZG2I66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 04:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZG2I65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 04:58:57 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48886 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbZG2I65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 04:58:57 -0400
Date: Wed, 29 Jul 2009 10:58:37 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: stack allocation fix
Message-ID: <20090729085837.GB4998@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only 24 bytes need to be allocated.

I believe this was missed in following commit:
x86, function-graph: only save return values on x86_64
commit e71e99c294058a61b7a8b9bb6da2f745ac51aa4f

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>

---
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
 
