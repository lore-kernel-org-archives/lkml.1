Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZKUNeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZKUNeO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 08:34:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754458AbZKUNeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 08:34:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:41538 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754456AbZKUNeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 08:34:12 -0500
Date: Sat, 21 Nov 2009 13:33:42 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246458150.6940.19.camel@hpdv5.satnam>
References: <1246458150.6940.19.camel@hpdv5.satnam>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] x86: Mark ptrace_get_debugreg() as static
Message-ID: <tip-9d22b536609abf0d64648f99518676ea58245e3b@git.kernel.org>
Git-Commit-ID: 9d22b536609abf0d64648f99518676ea58245e3b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d22b536609abf0d64648f99518676ea58245e3b
Gitweb:     http://git.kernel.org/tip/9d22b536609abf0d64648f99518676ea58245e3b
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Wed, 1 Jul 2009 19:52:30 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 1 Jul 2009 16:53:27 +0200

x86: Mark ptrace_get_debugreg() as static

This sparse warning:

  arch/x86/kernel/ptrace.c:560:15: warning: symbol 'ptrace_get_debugreg' was not declared. Should it be static?

triggers because ptrace_get_debugreg() is global but is only
used in a single .c file. change ptrace_get_debugreg() to
static to fix that - this also addresses the sparse warning.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <1246458150.6940.19.camel@hpdv5.satnam>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index b457f78..cabdabc 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -557,7 +557,7 @@ restore:
 /*
  * Handle PTRACE_PEEKUSR calls for the debug register area.
  */
-unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
+static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 {
 	struct thread_struct *thread = &(tsk->thread);
 	unsigned long val = 0;
