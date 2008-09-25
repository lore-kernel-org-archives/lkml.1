Return-Path: <linux-kernel-owner+w=401wt.eu-S1753943AbYIYCNH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbYIYCNH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:13:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYIYCMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:12:55 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:28327 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbYIYCMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:12:55 -0400
Message-ID: <48DAF3A6.5050109@ct.jp.nec.com>
Date: Wed, 24 Sep 2008 19:12:54 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86: signal_64.c: introduce helper function signr_convert()
References: <48DAF315.7070700@ct.jp.nec.com>
In-Reply-To: <48DAF315.7070700@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

This helper function is for unification of setup_rt_frame().
No affect in binary.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_64.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 963236f..c5d8002 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -281,18 +281,24 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 /*
  * OK, we're invoking a handler
  */
+static int signr_convert(int sig)
+{
+	return sig;
+}
+
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	       sigset_t *set, struct pt_regs *regs)
 {
+	int usig = signr_convert(sig);
 	int ret;
 
 #ifdef CONFIG_IA32_EMULATION
 	if (test_thread_flag(TIF_IA32)) {
 		if (ka->sa.sa_flags & SA_SIGINFO)
-			ret = ia32_setup_rt_frame(sig, ka, info, set, regs);
+			ret = ia32_setup_rt_frame(usig, ka, info, set, regs);
 		else
-			ret = ia32_setup_frame(sig, ka, set, regs);
+			ret = ia32_setup_frame(usig, ka, set, regs);
 	} else
 #endif
 	ret = __setup_rt_frame(sig, ka, info, set, regs);
-- 
1.5.6

