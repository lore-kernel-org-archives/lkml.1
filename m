Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbZFTHog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbZFTHog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 03:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751585AbZFTHo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 03:44:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:39714 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbZFTHo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 03:44:29 -0400
Subject: [PATCH -tip RESEND] x86: ptrace ptrace_get_debugreg() should be
 static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1245322502.7189.2.camel@localhost.localdomain>
References: <1245322502.7189.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 20 Jun 2009 13:13:20 +0530
Message-Id: <1245483801.3102.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ptrace_get_debugreg() is used only by the same file, so it should be static.

Also fixed sparse warning :

  CHECK   arch/x86/kernel/ptrace.c
  arch/x86/kernel/ptrace.c:560:15: warning: symbol 'ptrace_get_debugreg' was not declared. Should it be static?

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



