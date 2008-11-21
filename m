Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbYKUCc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbYKUCc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 21:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbYKUCcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 21:32:20 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:17066 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYKUCcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 21:32:19 -0500
Message-ID: <49261DB1.7070009@ct.jp.nec.com>
Date: Thu, 20 Nov 2008 18:32:17 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: signal: rename COPY_SEG_STRICT to COPY_SEG_CPL3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Rename macro COPY_SEG_STRICT to COPY_SEG_CPL3.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    8 ++++----
 arch/x86/kernel/signal_64.c |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 514171a..c2aabeb 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -145,7 +145,7 @@ asmlinkage int sys_sigaltstack(unsigned long bx)
 		regs->seg = tmp;			\
 }
 
-#define COPY_SEG_STRICT(seg)	{			\
+#define COPY_SEG_CPL3(seg)	{			\
 		unsigned short tmp;			\
 		err |= __get_user(tmp, &sc->seg);	\
 		regs->seg = tmp | 3;			\
@@ -193,13 +193,13 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 #endif /* CONFIG_X86_64 */
 
 #ifdef CONFIG_X86_32
-	COPY_SEG_STRICT(cs);
-	COPY_SEG_STRICT(ss);
+	COPY_SEG_CPL3(cs);
+	COPY_SEG_CPL3(ss);
 #else /* !CONFIG_X86_32 */
 	/* Kernel saves and restores only the CS segment register on signals,
 	 * which is the bare minimum needed to allow mixed 32/64-bit code.
 	 * App's signal handler can save/restore other segments if needed. */
-	COPY_SEG_STRICT(cs);
+	COPY_SEG_CPL3(cs);
 #endif /* CONFIG_X86_32 */
 
 	err |= __get_user(tmpflags, &sc->flags);
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index d2307e4..3d54d36 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -56,7 +56,7 @@ sys_sigaltstack(const stack_t __user *uss, stack_t __user *uoss,
 	err |= __get_user(regs->x, &sc->x);	\
 }
 
-#define COPY_SEG_STRICT(seg)	{			\
+#define COPY_SEG_CPL3(seg)	{			\
 		unsigned short tmp;			\
 		err |= __get_user(tmp, &sc->seg);	\
 		regs->seg = tmp | 3;			\
@@ -98,13 +98,13 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 #endif /* CONFIG_X86_64 */
 
 #ifdef CONFIG_X86_32
-	COPY_SEG_STRICT(cs);
-	COPY_SEG_STRICT(ss);
+	COPY_SEG_CPL3(cs);
+	COPY_SEG_CPL3(ss);
 #else /* !CONFIG_X86_32 */
 	/* Kernel saves and restores only the CS segment register on signals,
 	 * which is the bare minimum needed to allow mixed 32/64-bit code.
 	 * App's signal handler can save/restore other segments if needed. */
-	COPY_SEG_STRICT(cs);
+	COPY_SEG_CPL3(cs);
 #endif /* CONFIG_X86_32 */
 
 	err |= __get_user(tmpflags, &sc->flags);
-- 
1.5.6

