Return-Path: <linux-kernel-owner+w=401wt.eu-S935731AbYBHUPw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935731AbYBHUPw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 15:15:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935423AbYBHUNs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 15:13:48 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:32476 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935264AbYBHUNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 15:13:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jreZPdpDGSIz8L2Z5xa1dXD/izRC0xLfqcARrhGnDaTGxHZrqwppAGMcgcYyXkoAnrJs2IW4CcaF+QgdpxoYTyKQEFPYvmQpzQawfKb4NK1i7Tqtbup+LznnwtyVbCbpcxexP1Bk8lAABilqNdbZ+Rdwi5J96+za9CQGhRVrnB0=
Subject: [PATCH 7/9] x86: move struct definitions to unifed sigframe.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 12:10:00 -0800
Message-Id: <1202501400.12966.26.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/x86/kernel/sigframe_32.h |    9 +++++++++
 arch/x86/kernel/signal_32.c   |    2 +-
 arch/x86/kernel/signal_64.c   |    9 +--------
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/sigframe_32.h b/arch/x86/kernel/sigframe_32.h
index 0b22217..1284e8b 100644
--- a/arch/x86/kernel/sigframe_32.h
+++ b/arch/x86/kernel/sigframe_32.h
@@ -1,3 +1,4 @@
+#ifdef CONFIG_X86_32
 struct sigframe
 {
 	char __user *pretcode;
@@ -19,3 +20,11 @@ struct rt_sigframe
 	struct _fpstate fpstate;
 	char retcode[8];
 };
+#else
+struct rt_sigframe
+{
+	char __user *pretcode;
+	struct ucontext uc;
+	struct siginfo info;
+};
+#endif
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index cf6bedf..858a71f 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -24,7 +24,7 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/vdso.h>
-#include "sigframe_32.h"
+#include "sigframe.h"
 
 #define DEBUG_SIG 0
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index fb27473..f006ea1 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -26,6 +26,7 @@
 #include <asm/proto.h>
 #include <asm/ia32_unistd.h>
 #include <asm/mce.h>
+#include "sigframe.h"
 
 /* #define DEBUG_SIG 1 */
 
@@ -59,14 +60,6 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 /*
  * Do a signal return; undo the signal stack.
  */
-
-struct rt_sigframe
-{
-	char __user *pretcode;
-	struct ucontext uc;
-	struct siginfo info;
-};
-
 static int
 restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc, unsigned long *prax)
 {
-- 
1.5.4.1219.g65b9


