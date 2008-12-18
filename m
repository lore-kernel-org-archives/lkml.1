Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753893AbYLRCw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYLRCw4 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbYLRCwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:52:46 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:46427 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYLRCwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:52:45 -0500
Message-ID: <4949BAFD.1050608@ct.jp.nec.com>
Date: Wed, 17 Dec 2008 18:52:45 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] x86: ia32_signal: use sigframe.h
References: <4949B9B5.2050701@ct.jp.nec.com>
In-Reply-To: <4949B9B5.2050701@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Use arch/x86/include/asm/sigframe.h instead of making redundant structure.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |   26 ++------------------------
 1 files changed, 2 insertions(+), 24 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 54e4d93..32c549f 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -32,6 +32,8 @@
 #include <asm/proto.h>
 #include <asm/vdso.h>
 
+#include <asm/sigframe.h>
+
 #define DEBUG_SIG 0
 
 #define _BLOCKABLE (~(sigmask(SIGKILL) | sigmask(SIGSTOP)))
@@ -173,30 +175,6 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 /*
  * Do a signal return; undo the signal stack.
  */
-
-struct sigframe_ia32
-{
-	u32 pretcode;
-	int sig;
-	struct sigcontext_ia32 sc;
-	struct _fpstate_ia32 fpstate_unused; /* look at kernel/sigframe.h */
-	unsigned int extramask[_COMPAT_NSIG_WORDS-1];
-	char retcode[8];
-	/* fp state follows here */
-};
-
-struct rt_sigframe_ia32
-{
-	u32 pretcode;
-	int sig;
-	u32 pinfo;
-	u32 puc;
-	compat_siginfo_t info;
-	struct ucontext_ia32 uc;
-	char retcode[8];
-	/* fp state follows here */
-};
-
 #define COPY(x)			{		\
 	err |= __get_user(regs->x, &sc->x);	\
 }
-- 
1.6.0.4

