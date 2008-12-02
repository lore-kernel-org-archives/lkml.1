Return-Path: <linux-kernel-owner+w=401wt.eu-S1753862AbYLBUev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862AbYLBUev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbYLBUe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:34:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63633 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbYLBUe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:34:27 -0500
Message-Id: <20081202203425.441603525@goodmis.org>
References: <20081202203404.496794864@goodmis.org>
User-Agent: quilt/0.46-1
Date: Tue, 02 Dec 2008 15:34:09 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH 5/5] ftrace: have function graph use mcount caller address
Content-Disposition: inline; filename=0005-ftrace-have-function-graph-use-mcount-caller-addres.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Impact: consistency change for function graph

This patch makes function graph record the mcount caller address
the same way the function tracer does.

Signed-off-by: Steven Rostedt <srostedt@redhat.com>
---
 arch/x86/kernel/entry_32.S |    1 +
 arch/x86/kernel/entry_64.S |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index f484e9a..3497321 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1027,6 +1027,7 @@ ENTRY(ftrace_graph_caller)
 	pushl %edx
 	movl 0xc(%esp), %edx
 	lea 0x4(%ebp), %eax
+	subl $MCOUNT_INSN_SIZE, %edx
 	call prepare_ftrace_return
 	popl %edx
 	popl %ecx
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index c433d86..47aa5f0 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -172,6 +172,7 @@ ENTRY(ftrace_graph_caller)
 
 	leaq 8(%rbp), %rdi
 	movq 0x38(%rsp), %rsi
+	subq $MCOUNT_INSN_SIZE, %rsi
 
 	call	prepare_ftrace_return
 
-- 
1.5.6.5

-- 
