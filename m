Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZCBVvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZCBVvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753383AbZCBVvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:51:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47002 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743AbZCBVvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:51:06 -0500
Date: Mon, 2 Mar 2009 16:51:01 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Subject: [GIT PULL] tracing: make CALLER_ADDRx overwriteable
Message-ID: <alpine.DEB.2.00.0903021638480.4771@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Uwe Kleine-Koenig (1):
      tracing: make CALLER_ADDRx overwriteable

----
 arch/alpha/include/asm/ftrace.h    |    1 +
 arch/avr32/include/asm/ftrace.h    |    1 +
 arch/blackfin/include/asm/ftrace.h |    1 +
 arch/cris/include/asm/ftrace.h     |    1 +
 arch/h8300/include/asm/ftrace.h    |    1 +
 arch/m68k/include/asm/ftrace.h     |    1 +
 arch/mips/include/asm/ftrace.h     |    1 +
 arch/parisc/include/asm/ftrace.h   |    1 +
 arch/um/include/asm/ftrace.h       |    1 +
 arch/xtensa/include/asm/ftrace.h   |    1 +
 include/asm-frv/ftrace.h           |    1 +
 include/asm-m32r/ftrace.h          |    1 +
 include/asm-mn10300/ftrace.h       |    1 +
 include/linux/ftrace.h             |   41 ++++++++++++++++++-----------------
 14 files changed, 34 insertions(+), 20 deletions(-)
---------------------------
commit c79a61f55773d2519fd0525bf58385f7d20752d3
Author: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
Date:   Fri Feb 27 21:30:03 2009 +0100

    tracing: make CALLER_ADDRx overwriteable
    
    The current definition of CALLER_ADDRx isn't suitable for all platforms.
    E.g. for ARM __builtin_return_address(N) doesn't work for N > 0 and
    AFAIK for powerpc there are no frame pointers needed to have a working
    __builtin_return_address.  This patch allows defining the CALLER_ADDRx
    macros in <asm/ftrace.h> and let these take precedence.
    
    Because now <asm/ftrace.h> is included unconditionally in
    <linux/ftrace.h> all archs that don't already had this include get an
    empty one for free.
    
    Signed-off-by: Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Cc: Ingo Molnar <mingo@elte.hu>
    Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/arch/alpha/include/asm/ftrace.h b/arch/alpha/include/asm/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/arch/alpha/include/asm/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/avr32/include/asm/ftrace.h b/arch/avr32/include/asm/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/arch/avr32/include/asm/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/blackfin/include/asm/ftrace.h b/arch/blackfin/include/asm/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/arch/blackfin/include/asm/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/cris/include/asm/ftrace.h b/arch/cris/include/asm/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/arch/cris/include/asm/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/h8300/include/asm/ftrace.h b/arch/h8300/include/asm/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/arch/h8300/include/asm/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/m68k/include/asm/ftrace.h b/arch/m68k/include/asm/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/arch/m68k/include/asm/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/mips/include/asm/ftrace.h b/arch/mips/include/asm/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/arch/mips/include/asm/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/parisc/include/asm/ftrace.h b/arch/parisc/include/asm/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/arch/parisc/include/asm/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/um/include/asm/ftrace.h b/arch/um/include/asm/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/arch/um/include/asm/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/arch/xtensa/include/asm/ftrace.h b/arch/xtensa/include/asm/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/arch/xtensa/include/asm/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/include/asm-frv/ftrace.h b/include/asm-frv/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/include/asm-frv/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/include/asm-m32r/ftrace.h b/include/asm-m32r/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/include/asm-m32r/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/include/asm-mn10300/ftrace.h b/include/asm-mn10300/ftrace.h
new file mode 100644
index 0000000..40a8c17
--- /dev/null
+++ b/include/asm-mn10300/ftrace.h
@@ -0,0 +1 @@
+/* empty */
diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index 847bb3c..1f69ac7 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -11,6 +11,8 @@
 #include <linux/bitops.h>
 #include <linux/sched.h>
 
+#include <asm/ftrace.h>
+
 #ifdef CONFIG_FUNCTION_TRACER
 
 extern int ftrace_enabled;
@@ -103,8 +105,6 @@ struct ftrace_func_command {
 };
 
 #ifdef CONFIG_DYNAMIC_FTRACE
-/* asm/ftrace.h must be defined for archs supporting dynamic ftrace */
-#include <asm/ftrace.h>
 
 int ftrace_arch_code_modify_prepare(void);
 int ftrace_arch_code_modify_post_process(void);
@@ -282,24 +282,25 @@ static inline void __ftrace_enabled_restore(int enabled)
 #endif
 }
 
-#ifdef CONFIG_FRAME_POINTER
-/* TODO: need to fix this for ARM */
-# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-# define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
-# define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
-# define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
-# define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
-# define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
-# define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
-#else
-# define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
-# define CALLER_ADDR1 0UL
-# define CALLER_ADDR2 0UL
-# define CALLER_ADDR3 0UL
-# define CALLER_ADDR4 0UL
-# define CALLER_ADDR5 0UL
-# define CALLER_ADDR6 0UL
-#endif
+#ifndef HAVE_ARCH_CALLER_ADDR
+# ifdef CONFIG_FRAME_POINTER
+#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#  define CALLER_ADDR1 ((unsigned long)__builtin_return_address(1))
+#  define CALLER_ADDR2 ((unsigned long)__builtin_return_address(2))
+#  define CALLER_ADDR3 ((unsigned long)__builtin_return_address(3))
+#  define CALLER_ADDR4 ((unsigned long)__builtin_return_address(4))
+#  define CALLER_ADDR5 ((unsigned long)__builtin_return_address(5))
+#  define CALLER_ADDR6 ((unsigned long)__builtin_return_address(6))
+# else
+#  define CALLER_ADDR0 ((unsigned long)__builtin_return_address(0))
+#  define CALLER_ADDR1 0UL
+#  define CALLER_ADDR2 0UL
+#  define CALLER_ADDR3 0UL
+#  define CALLER_ADDR4 0UL
+#  define CALLER_ADDR5 0UL
+#  define CALLER_ADDR6 0UL
+# endif
+#endif /* ifndef HAVE_ARCH_CALLER_ADDR */
 
 #ifdef CONFIG_IRQSOFF_TRACER
   extern void time_hardirqs_on(unsigned long a0, unsigned long a1);
