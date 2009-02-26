Return-Path: <linux-kernel-owner+w=401wt.eu-S1760009AbZBZWLr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760009AbZBZWLr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:11:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759133AbZBZWLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:11:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33262 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759428AbZBZWL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:11:29 -0500
From: =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH] make CALLER_ADDRx overwriteable
Date: Thu, 26 Feb 2009 23:11:25 +0100
Message-Id: <1235686285-8600-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <alpine.DEB.2.00.0902260857510.26792@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0902260857510.26792@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current definition of CALLER_ADDRx isn't suitable for all platforms.
E.g. for ARM __builtin_return_address(N) doesn't work for N > 0 and
AFAIK for powerpc there are no frame pointers needed to have a working
__builtin_return_address.  This patch allows defining the CALLER_ADDRx
macros in <asm/ftrace.h> and let these take precedence.

Because now <asm/ftrace.h> is included unconditionally in
<linux/ftrace.h> all archs that don't already had this include get an
empty one for free.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>
--
Hello,

as Steven suggested I added empty <asm/ftrace.h> files since the last
version of this patch.

@Ingo:  I assume this update doesn't invalidate your Acked-by:, but to
be on the save side I didn't add it here.

Best regards
Uwe

---
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
index 847bb3c..9d8d362 100644
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
+#ifndef CALLER_ADDR0
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
+#endif /* ifndef CALLER_ADDR0 */
 
 #ifdef CONFIG_IRQSOFF_TRACER
   extern void time_hardirqs_on(unsigned long a0, unsigned long a1);
-- 
tg: (db50eec..) t/ftrace/make_CALLER_ADDRx_overwriteable (depends on: tip/master)
