Return-Path: <linux-kernel-owner+w=401wt.eu-S1758094AbYKVBjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758094AbYKVBjS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbYKVBjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:39:00 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:55013 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755843AbYKVBi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:38:59 -0500
Message-ID: <492762B1.4020107@ct.jp.nec.com>
Date: Fri, 21 Nov 2008 17:38:57 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: signal: cosmetic unification of sys_rt_sigreturn()
References: <49276229.9060000@ct.jp.nec.com>
In-Reply-To: <49276229.9060000@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup

Add #ifdef directive for unification.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    7 +++++++
 arch/x86/kernel/signal_64.c |    9 +++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index d990988..f7dd6c4 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -299,12 +299,19 @@ badframe:
 	return 0;
 }
 
+#ifdef CONFIG_X86_32
 asmlinkage int sys_rt_sigreturn(unsigned long __unused)
 {
 	struct pt_regs *regs = (struct pt_regs *)&__unused;
 
 	return do_rt_sigreturn(regs);
 }
+#else /* !CONFIG_X86_32 */
+asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
+{
+	return do_rt_sigreturn(regs);
+}
+#endif /* CONFIG_X86_32 */
 
 /*
  * Set up a signal frame.
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index b6e4fe0..32718f5 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -169,10 +169,19 @@ badframe:
 	return 0;
 }
 
+#ifdef CONFIG_X86_32
+asmlinkage int sys_rt_sigreturn(unsigned long __unused)
+{
+	struct pt_regs *regs = (struct pt_regs *)&__unused;
+
+	return do_rt_sigreturn(regs);
+}
+#else /* !CONFIG_X86_32 */
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 {
 	return do_rt_sigreturn(regs);
 }
+#endif /* CONFIG_X86_32 */
 
 /*
  * Set up a signal frame.
-- 
1.5.6

