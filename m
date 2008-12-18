Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753997AbYLRCwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbYLRCwA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 21:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYLRCvr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 21:51:47 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:46209 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYLRCvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 21:51:47 -0500
Message-ID: <4949BAC2.5090704@ct.jp.nec.com>
Date: Wed, 17 Dec 2008 18:51:46 -0800
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] x86: ia32_signal: rename struct sigframe and rt_sigframe
References: <4949B9B5.2050701@ct.jp.nec.com>
In-Reply-To: <4949B9B5.2050701@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Impact: prepare to include sigframe.h

Rename struct sigframe to struct sigframe_ia32 and struct rt_sigframe to
struct rt_sigframe_ia32.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index ee1ad4a..54e4d93 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -174,7 +174,7 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
  * Do a signal return; undo the signal stack.
  */
 
-struct sigframe
+struct sigframe_ia32
 {
 	u32 pretcode;
 	int sig;
@@ -185,7 +185,7 @@ struct sigframe
 	/* fp state follows here */
 };
 
-struct rt_sigframe
+struct rt_sigframe_ia32
 {
 	u32 pretcode;
 	int sig;
@@ -271,7 +271,7 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 
 asmlinkage long sys32_sigreturn(struct pt_regs *regs)
 {
-	struct sigframe __user *frame = (struct sigframe __user *)(regs->sp-8);
+	struct sigframe_ia32 __user *frame = (struct sigframe_ia32 __user *)(regs->sp-8);
 	sigset_t set;
 	unsigned int ax;
 
@@ -301,12 +301,12 @@ badframe:
 
 asmlinkage long sys32_rt_sigreturn(struct pt_regs *regs)
 {
-	struct rt_sigframe __user *frame;
+	struct rt_sigframe_ia32 __user *frame;
 	sigset_t set;
 	unsigned int ax;
 	struct pt_regs tregs;
 
-	frame = (struct rt_sigframe __user *)(regs->sp - 4);
+	frame = (struct rt_sigframe_ia32 __user *)(regs->sp - 4);
 
 	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
 		goto badframe;
@@ -418,7 +418,7 @@ static void __user *get_sigframe(struct k_sigaction *ka, struct pt_regs *regs,
 int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		     compat_sigset_t *set, struct pt_regs *regs)
 {
-	struct sigframe __user *frame;
+	struct sigframe_ia32 __user *frame;
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
@@ -497,7 +497,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			compat_sigset_t *set, struct pt_regs *regs)
 {
-	struct rt_sigframe __user *frame;
+	struct rt_sigframe_ia32 __user *frame;
 	void __user *restorer;
 	int err = 0;
 	void __user *fpstate = NULL;
-- 
1.6.0.4

