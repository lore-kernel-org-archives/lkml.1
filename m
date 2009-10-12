Return-Path: <linux-kernel-owner+w=401wt.eu-S1753935AbZJLGLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbZJLGLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 02:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbZJLGLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 02:11:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:43017 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbZJLGLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 02:11:44 -0400
Date: Mon, 12 Oct 2009 06:10:40 GMT
From: tip-bot for Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       fweisbec@gmail.com, joe@perches.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       joe@perches.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <9b377eefae9e28c599dd4a17bdc81172965e9931.1254701151.git.joe@perches.com>
References: <9b377eefae9e28c599dd4a17bdc81172965e9931.1254701151.git.joe@perches.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:tracing/core] ftrace.c: Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Message-ID: <tip-3bb258bf430d29a24350fe4f44f8bf07b7b7a8f6@git.kernel.org>
Git-Commit-ID: 3bb258bf430d29a24350fe4f44f8bf07b7b7a8f6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 12 Oct 2009 06:10:41 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3bb258bf430d29a24350fe4f44f8bf07b7b7a8f6
Gitweb:     http://git.kernel.org/tip/3bb258bf430d29a24350fe4f44f8bf07b7b7a8f6
Author:     Joe Perches <joe@perches.com>
AuthorDate: Sun, 4 Oct 2009 17:53:29 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Oct 2009 08:05:40 +0200

ftrace.c: Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

- Remove prefixes from pr_<level>, use pr_fmt(fmt).

No change in output.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <9b377eefae9e28c599dd4a17bdc81172965e9931.1254701151.git.joe@perches.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/ftrace.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 9dbb527..25e6f5f 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -9,6 +9,8 @@
  * the dangers of modifying code on the run.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/spinlock.h>
 #include <linux/hardirq.h>
 #include <linux/uaccess.h>
@@ -336,15 +338,15 @@ int __init ftrace_dyn_arch_init(void *data)
 
 	switch (faulted) {
 	case 0:
-		pr_info("ftrace: converting mcount calls to 0f 1f 44 00 00\n");
+		pr_info("converting mcount calls to 0f 1f 44 00 00\n");
 		memcpy(ftrace_nop, ftrace_test_p6nop, MCOUNT_INSN_SIZE);
 		break;
 	case 1:
-		pr_info("ftrace: converting mcount calls to 66 66 66 66 90\n");
+		pr_info("converting mcount calls to 66 66 66 66 90\n");
 		memcpy(ftrace_nop, ftrace_test_nop5, MCOUNT_INSN_SIZE);
 		break;
 	case 2:
-		pr_info("ftrace: converting mcount calls to jmp . + 5\n");
+		pr_info("converting mcount calls to jmp . + 5\n");
 		memcpy(ftrace_nop, ftrace_test_jmp, MCOUNT_INSN_SIZE);
 		break;
 	}
