Return-Path: <linux-kernel-owner+w=401wt.eu-S1754221AbYIWV5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221AbYIWV5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbYIWV4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:56:52 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:38364 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbYIWV4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:56:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=PSgpYF9A5Q3GQGTjH/mFwtcJsoI+u+XXa/E9jfa2mIrfp8IIJ04aGIaQcXWEZNcnFI
         ottdk2EzyIE5VQ5BM/960GShCanz2cONArwFmqH2qTau2z3R4CZTmQD5SeIlySCK4rm0
         VIWqfD0k1J/S/BGfeCPxJVmuLUxDvKivZRtQg=
Subject: [PATCH] x86: ds.c ptrace.c integer as NULL pointer sparse fixes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Sep 2008 14:56:44 -0700
Message-Id: <1222207004.16003.20.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/ptrace.c:763:29: warning: Using plain integer as NULL pointer
arch/x86/kernel/ptrace.c:777:46: warning: Using plain integer as NULL pointer
arch/x86/kernel/ptrace.c:1115:45: warning: Using plain integer as NULL pointer
arch/x86/kernel/ds.c:482:26: warning: Using plain integer as NULL pointer
arch/x86/kernel/ds.c:487:25: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/ds.c     |    4 ++--
 arch/x86/kernel/ptrace.c |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
index ab21c27..2b69994 100644
--- a/arch/x86/kernel/ds.c
+++ b/arch/x86/kernel/ds.c
@@ -479,12 +479,12 @@ static int ds_release(struct task_struct *task, enum ds_qualifier qual)
 		goto out;
 
 	kfree(context->buffer[qual]);
-	context->buffer[qual] = 0;
+	context->buffer[qual] = NULL;
 
 	current->mm->total_vm  -= context->pages[qual];
 	current->mm->locked_vm -= context->pages[qual];
 	context->pages[qual] = 0;
-	context->owner[qual] = 0;
+	context->owner[qual] = NULL;
 
 	/*
 	 * we put the context twice:
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 42801a5..4e1ef66 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -760,7 +760,7 @@ static int ptrace_bts_config(struct task_struct *child,
 		goto errout;
 
 	if (cfg.flags & PTRACE_BTS_O_ALLOC) {
-		ds_ovfl_callback_t ovfl = 0;
+		ds_ovfl_callback_t ovfl = NULL;
 		unsigned int sig = 0;
 
 		/* we ignore the error in case we were not tracing child */
@@ -774,7 +774,7 @@ static int ptrace_bts_config(struct task_struct *child,
 			ovfl = ptrace_bts_ovfl;
 		}
 
-		error = ds_request_bts(child, /* base = */ 0, cfg.size, ovfl);
+		error = ds_request_bts(child, /* base = */ NULL, cfg.size, ovfl);
 		if (error < 0)
 			goto errout;
 
@@ -1112,7 +1112,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
 		break;
 
 	case PTRACE_BTS_SIZE:
-		ret = ds_get_bts_index(child, /* pos = */ 0);
+		ret = ds_get_bts_index(child, /* pos = */ NULL);
 		break;
 
 	case PTRACE_BTS_GET:
-- 
1.6.0.2.471.g47a76



