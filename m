Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbZGAOXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbZGAOXS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbZGAOXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:23:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:56260 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbZGAOXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:23:04 -0400
Subject: [PATCH -tip] x86: ptrace.c ptrace_get_debugreg() should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 19:52:30 +0530
Message-Id: <1246458150.6940.19.camel@hpdv5.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This sparse warning:

  arch/x86/kernel/ptrace.c:560:15: warning: symbol 'ptrace_get_debugreg' was not declared. Should it be static?

triggers because ptrace_get_debugreg() is global but is only used in a single .c file.
change ptrace_get_debugreg() to static to fix that - this also address the sparse warning.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
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
-- 
1.6.0.6



