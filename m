Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbYLFBRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbYLFBRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 20:17:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYLFBRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 20:17:13 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:30344 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbYLFBRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 20:17:12 -0500
Message-ID: <4939D295.6090001@ct.jp.nec.com>
Date: Fri, 05 Dec 2008 17:17:09 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: signal: change type of paramter for sys_rt_sigreturn()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: cleanup on 32-bit

Peter pointed this parameter can be changed.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/include/asm/syscalls.h |    2 +-
 arch/x86/kernel/signal.c        |    6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/syscalls.h b/arch/x86/include/asm/syscalls.h
index 87803da..3a5252c 100644
--- a/arch/x86/include/asm/syscalls.h
+++ b/arch/x86/include/asm/syscalls.h
@@ -33,7 +33,7 @@ asmlinkage int sys_sigaction(int, const struct old_sigaction __user *,
 			     struct old_sigaction __user *);
 asmlinkage int sys_sigaltstack(unsigned long);
 asmlinkage unsigned long sys_sigreturn(unsigned long);
-asmlinkage int sys_rt_sigreturn(unsigned long);
+asmlinkage int sys_rt_sigreturn(struct pt_regs);
 
 /* kernel/ioport.c */
 asmlinkage long sys_iopl(unsigned long);
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index b1f4d34..b1cc6da 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -642,11 +642,9 @@ badframe:
 }
 
 #ifdef CONFIG_X86_32
-asmlinkage int sys_rt_sigreturn(unsigned long __unused)
+asmlinkage int sys_rt_sigreturn(struct pt_regs regs)
 {
-	struct pt_regs *regs = (struct pt_regs *)&__unused;
-
-	return do_rt_sigreturn(regs);
+	return do_rt_sigreturn(&regs);
 }
 #else /* !CONFIG_X86_32 */
 asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
-- 
1.6.0.4

