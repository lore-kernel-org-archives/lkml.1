Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZJEAyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZJEAyn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758003AbZJEAym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:54:42 -0400
Received: from mail.perches.com ([173.55.12.10]:1659 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758107AbZJEAyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:54:36 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 02/21] ftrace.c: Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
Date: Sun,  4 Oct 2009 17:53:29 -0700
Message-Id: <9b377eefae9e28c599dd4a17bdc81172965e9931.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove prefixes from pr_<level>, use pr_fmt(fmt)
No change in output.

Signed-off-by: Joe Perches <joe@perches.com>
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
-- 
1.6.3.1.10.g659a0.dirty

