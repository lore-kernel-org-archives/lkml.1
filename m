Return-Path: <linux-kernel-owner+w=401wt.eu-S1761837AbYF0TVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761837AbYF0TVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 15:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756651AbYF0TVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 15:21:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46398 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbYF0TVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 15:21:08 -0400
Date: Fri, 27 Jun 2008 21:20:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH 1/2] stacktrace: add saved stack traces to
	backtrace self-test
Message-ID: <20080627192055.GA8435@elte.hu>
References: <20080627160448.GB8852@damson.getinternet.no> <20080627160821.GA30232@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627160821.GA30232@elte.hu>
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


FYI, it needed the fixlet below.

	Ingo

------------->
commit 7bcebd2e3ee8435e2ff0f674a409f46961fda3cc
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jun 27 21:20:17 2008 +0200

    stacktrace: export print_stack_trace and save_stack_trace
    
    fix:
    
    ERROR: "print_stack_trace" [kernel/backtracetest.ko] undefined!
    ERROR: "save_stack_trace" [kernel/backtracetest.ko] undefined!
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    
    Conflicts:
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index c28c342..b7b483b 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -74,10 +74,4 @@ void save_stack_trace(struct stack_trace *trace)
 	if (trace->nr_entries < trace->max_entries)
 		trace->entries[trace->nr_entries++] = ULONG_MAX;
 }
-
-void save_stack_trace_tsk(struct task_struct *tsk, struct stack_trace *trace)
-{
-	dump_trace(tsk, NULL, NULL, 0, &save_stack_ops_nosched, trace);
-	if (trace->nr_entries < trace->max_entries)
-		trace->entries[trace->nr_entries++] = ULONG_MAX;
-}
+EXPORT_SYMBOL_GPL(save_stack_trace);
diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 7eaea9d..eda2f4c 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -21,4 +21,5 @@ void print_stack_trace(struct stack_trace *trace, int spaces)
 		print_ip_sym(trace->entries[i]);
 	}
 }
+EXPORT_SYMBOL_GPL(print_stack_trace);
 
