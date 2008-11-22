Return-Path: <linux-kernel-owner+w=401wt.eu-S1758009AbYKVBgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009AbYKVBgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbYKVBgn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:36:43 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:53956 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbYKVBgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:36:42 -0500
Message-ID: <49276229.9060000@ct.jp.nec.com>
Date: Fri, 21 Nov 2008 17:36:41 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: signal: cosmetic unification of including headers
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Make including headers same.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   27 +++++++++++++++------------
 arch/x86/kernel/signal_64.c |    7 ++++++-
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index c2aabeb..0ff8d87 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -4,29 +4,32 @@
  *  1997-11-28  Modified for POSIX.1b signals by Richard Henderson
  *  2000-06-20  Pentium III FXSR, SSE support by Gareth Hughes
  */
-#include <linux/list.h>
 
-#include <linux/personality.h>
-#include <linux/binfmts.h>
-#include <linux/suspend.h>
+#include <linux/sched.h>
+#include <linux/mm.h>
+#include <linux/smp.h>
 #include <linux/kernel.h>
-#include <linux/ptrace.h>
 #include <linux/signal.h>
-#include <linux/stddef.h>
-#include <linux/unistd.h>
 #include <linux/errno.h>
-#include <linux/sched.h>
 #include <linux/wait.h>
+#include <linux/ptrace.h>
 #include <linux/tracehook.h>
-#include <linux/elf.h>
-#include <linux/smp.h>
-#include <linux/mm.h>
+#include <linux/unistd.h>
+#include <linux/stddef.h>
+#include <linux/personality.h>
+#include <linux/uaccess.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
-#include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/vdso.h>
+
+#ifdef CONFIG_X86_64
+#include <asm/proto.h>
+#include <asm/ia32_unistd.h>
+#include <asm/mce.h>
+#endif /* CONFIG_X86_64 */
+
 #include <asm/syscall.h>
 #include <asm/syscalls.h>
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 3d54d36..c52244a 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -19,17 +19,22 @@
 #include <linux/unistd.h>
 #include <linux/stddef.h>
 #include <linux/personality.h>
-#include <linux/compiler.h>
 #include <linux/uaccess.h>
 
 #include <asm/processor.h>
 #include <asm/ucontext.h>
 #include <asm/i387.h>
+#include <asm/vdso.h>
+
+#ifdef CONFIG_X86_64
 #include <asm/proto.h>
 #include <asm/ia32_unistd.h>
 #include <asm/mce.h>
+#endif /* CONFIG_X86_64 */
+
 #include <asm/syscall.h>
 #include <asm/syscalls.h>
+
 #include "sigframe.h"
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
-- 
1.5.6

