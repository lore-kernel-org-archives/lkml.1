Return-Path: <linux-kernel-owner+w=401wt.eu-S1759682AbYGQCV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682AbYGQCV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 22:21:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbYGQCVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 22:21:48 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:53709 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbYGQCVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 22:21:47 -0400
Message-ID: <487EACAB.2070805@ct.jp.nec.com>
Date: Wed, 16 Jul 2008 19:21:31 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64: ia32_signal.c: remove signal number conversion
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

This was old code that was needed for iBCS and x86-64 never supported that.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/ia32/ia32_signal.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index dc9b9b9..20af4c7 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -520,7 +520,6 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			compat_sigset_t *set, struct pt_regs *regs)
 {
 	struct rt_sigframe __user *frame;
-	struct exec_domain *ed = current_thread_info()->exec_domain;
 	void __user *restorer;
 	int err = 0;
 
@@ -543,8 +542,7 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		goto give_sigsegv;
 
-	err |= __put_user((ed && ed->signal_invmap && sig < 32
-			   ? ed->signal_invmap[sig] : sig), &frame->sig);
+	err |= __put_user(sig, &frame->sig);
 	err |= __put_user(ptr_to_compat(&frame->info), &frame->pinfo);
 	err |= __put_user(ptr_to_compat(&frame->uc), &frame->puc);
 	err |= copy_siginfo_to_user32(&frame->info, info);
-- 
1.5.4.1

