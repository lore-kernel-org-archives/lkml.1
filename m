Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753493AbYLRCr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbYLRCr2 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbYLRCrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:47:19 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:44606 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbYLRCrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:47:18 -0500
Message-ID: <4949B9B5.2050701@ct.jp.nec.com>
Date: Wed, 17 Dec 2008 18:47:17 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] x86: signal: move ia32 func declarations into arch/x86/kernel/signal.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Move declarations of ia32_setup_rt_frame() and ia32_setup_frame() into
arch/x86/kernel/signal.c.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
This is for future use of sigframe.h.

 arch/x86/kernel/sigframe.h |    5 -----
 arch/x86/kernel/signal.c   |    5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/sigframe.h b/arch/x86/kernel/sigframe.h
index cc673aa..6dd7e2b 100644
--- a/arch/x86/kernel/sigframe.h
+++ b/arch/x86/kernel/sigframe.h
@@ -34,9 +34,4 @@ struct rt_sigframe {
 	struct siginfo info;
 	/* fp state follows here */
 };
-
-int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-		sigset_t *set, struct pt_regs *regs);
-int ia32_setup_frame(int sig, struct k_sigaction *ka,
-		sigset_t *set, struct pt_regs *regs);
 #endif
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index 605592a..78202a1 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -671,6 +671,11 @@ static int signr_convert(int sig)
 #define is_ia32	0
 #endif /* CONFIG_IA32_EMULATION */
 
+int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
+		sigset_t *set, struct pt_regs *regs);
+int ia32_setup_frame(int sig, struct k_sigaction *ka,
+		sigset_t *set, struct pt_regs *regs);
+
 #endif /* CONFIG_X86_32 */
 
 static int
-- 
1.6.0.4

