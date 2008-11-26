Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbYKZCLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbYKZCLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 21:11:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYKZCLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 21:11:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48977 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752067AbYKZCLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 21:11:12 -0500
Date: Wed, 26 Nov 2008 03:10:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: function graph tracer, fix
Message-ID: <20081126021058.GA17390@elte.hu>
References: <492C90E5.8070907@gmail.com> <20081126003936.GA26937@elte.hu> <20081126020459.GA16374@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081126020459.GA16374@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


small fixlet.

------------->
>From c2324b694fa8ffee382a124198c68754088e483c Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Wed, 26 Nov 2008 03:10:01 +0100
Subject: [PATCH] tracing: function graph tracer, fix

fix return-tracer => graph-tracer namespace rename fallout.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/entry_32.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 2b1f0f0..7def9fd 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1189,7 +1189,7 @@ ENTRY(mcount)
 	cmpl $ftrace_stub, ftrace_trace_function
 	jnz trace
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	cmpl $ftrace_stub, ftrace_graph_function
+	cmpl $ftrace_stub, ftrace_graph_return
 	jnz ftrace_graph_caller
 #endif
 .globl ftrace_stub
