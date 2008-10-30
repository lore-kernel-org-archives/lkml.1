Return-Path: <linux-kernel-owner+w=401wt.eu-S1755488AbYJ3BqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488AbYJ3BqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753358AbYJ3BqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:46:09 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:35746 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294AbYJ3BqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:46:08 -0400
Message-ID: <490911DF.6090004@ct.jp.nec.com>
Date: Wed, 29 Oct 2008 18:46:07 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: signal: cosmetic unification of macros for setup_rt_frame()
References: <49091168.1070609@ct.jp.nec.com>
In-Reply-To: <49091168.1070609@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Add #ifdef directive for unification.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |   12 ++++++++++++
 arch/x86/kernel/signal_64.c |   14 ++++++++++++--
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index abf0df7..6f3b9a9 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -512,10 +512,22 @@ static int signr_convert(int sig)
 	return sig;
 }
 
+#ifdef CONFIG_X86_32
+
 #define is_ia32	1
 #define ia32_setup_frame	__setup_frame
 #define ia32_setup_rt_frame	__setup_rt_frame
 
+#else /* !CONFIG_X86_32 */
+
+#ifdef CONFIG_IA32_EMULATION
+#define is_ia32	test_thread_flag(TIF_IA32)
+#else /* !CONFIG_IA32_EMULATION */
+#define is_ia32	0
+#endif /* CONFIG_IA32_EMULATION */
+
+#endif /* CONFIG_X86_32 */
+
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	       sigset_t *set, struct pt_regs *regs)
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index a4b46e6..49df79e 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -304,11 +304,21 @@ static int signr_convert(int sig)
 	return sig;
 }
 
+#ifdef CONFIG_X86_32
+
+#define is_ia32	1
+#define ia32_setup_frame	__setup_frame
+#define ia32_setup_rt_frame	__setup_rt_frame
+
+#else /* !CONFIG_X86_32 */
+
 #ifdef CONFIG_IA32_EMULATION
 #define is_ia32	test_thread_flag(TIF_IA32)
-#else
+#else /* !CONFIG_IA32_EMULATION */
 #define is_ia32	0
-#endif
+#endif /* CONFIG_IA32_EMULATION */
+
+#endif /* CONFIG_X86_32 */
 
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
-- 
1.5.6

