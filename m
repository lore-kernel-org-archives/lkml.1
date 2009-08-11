Return-Path: <linux-kernel-owner+w=401wt.eu-S932278AbZHKSud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932278AbZHKSud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbZHKSuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:50:00 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:48086 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207AbZHKStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:49:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=VfgToh9TAza44PzfBcn4yBp2aaDb3pxCcDRItME9LAKOtoskgeUaIrYKJfgACqzNJR
         Dtqz1KL2RNIqg9oFGM5yxzoWQXCtx+/qoS1zCWCdeKg7TTK7Wib1QgViUjtTcSDvLtuz
         NHsuksOPvm0ZnBguYU1CtJ4HZfgArIzew7708=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 13/16] tracing: Convert x86_64 mmap and uname to use DEFINE_SYSCALL
Date: Tue, 11 Aug 2009 20:49:02 +0200
Message-Id: <1250016545-6601-14-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
References: <1250016545-6601-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

A number of syscalls are not using 'DEFINE_SYSCALL'. I'm not sure why.
Convert x86_64 uname and mmap to use DEFINE_SYSCALL.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/sys_x86_64.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 6bc211a..45e00eb 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -18,9 +18,9 @@
 #include <asm/ia32.h>
 #include <asm/syscalls.h>
 
-asmlinkage long sys_mmap(unsigned long addr, unsigned long len,
-		unsigned long prot, unsigned long flags,
-		unsigned long fd, unsigned long off)
+SYSCALL_DEFINE6(mmap, unsigned long, addr, unsigned long, len,
+		unsigned long, prot, unsigned long, flags,
+		unsigned long, fd, unsigned long, off)
 {
 	long error;
 	struct file *file;
@@ -226,7 +226,7 @@ bottomup:
 }
 
 
-asmlinkage long sys_uname(struct new_utsname __user *name)
+SYSCALL_DEFINE1(uname, struct new_utsname __user *, name)
 {
 	int err;
 	down_read(&uts_sem);
-- 
1.6.2.3

