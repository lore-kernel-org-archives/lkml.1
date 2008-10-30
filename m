Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352AbYJ3Bqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352AbYJ3Bqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:46:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYJ3Bqn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:46:43 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:35893 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbYJ3Bqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:46:42 -0400
Message-ID: <49091200.1040204@ct.jp.nec.com>
Date: Wed, 29 Oct 2008 18:46:40 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: signal: cosmetic unification of NR_restart_syscall
References: <49091168.1070609@ct.jp.nec.com>
In-Reply-To: <49091168.1070609@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Add #ifdef directive to unify NR_restart_syscall.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    6 ++++++
 arch/x86/kernel/signal_64.c |    5 +++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 6f3b9a9..a0efc1b 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -628,7 +628,13 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	return 0;
 }
 
+#ifdef CONFIG_X86_32
 #define NR_restart_syscall	__NR_restart_syscall
+#else /* !CONFIG_X86_32 */
+#define NR_restart_syscall	\
+	test_thread_flag(TIF_IA32) ? __NR_ia32_restart_syscall : __NR_restart_syscall
+#endif /* CONFIG_X86_32 */
+
 /*
  * Note that 'init' is a special process: it doesn't get signals it doesn't
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 49df79e..83990db 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -420,8 +420,13 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	return 0;
 }
 
+#ifdef CONFIG_X86_32
+#define NR_restart_syscall	__NR_restart_syscall
+#else /* !CONFIG_X86_32 */
 #define NR_restart_syscall	\
 	test_thread_flag(TIF_IA32) ? __NR_ia32_restart_syscall : __NR_restart_syscall
+#endif /* CONFIG_X86_32 */
+
 /*
  * Note that 'init' is a special process: it doesn't get signals it doesn't
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
-- 
1.5.6

