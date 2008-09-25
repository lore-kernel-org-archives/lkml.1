Return-Path: <linux-kernel-owner+w=401wt.eu-S1754335AbYIYCNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754335AbYIYCNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYIYCNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:13:32 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:28567 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743AbYIYCNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:13:30 -0400
Message-ID: <48DAF3C9.6080007@ct.jp.nec.com>
Date: Wed, 24 Sep 2008 19:13:29 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] x86: signal_32.c: introduce macro ia32_setup_frame and
 ia32_setup_rt_frame
References: <48DAF315.7070700@ct.jp.nec.com>
In-Reply-To: <48DAF315.7070700@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Make 32-bit setup_rt_frame() look like 64-bit version for unification.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index cf62f70..4337cd5 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -492,6 +492,8 @@ static int signr_convert(int sig)
 }
 
 #define is_ia32	1
+#define ia32_setup_frame	__setup_frame
+#define ia32_setup_rt_frame	__setup_rt_frame
 
 static int
 setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
@@ -503,9 +505,9 @@ setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	/* Set up the stack frame */
 	if (is_ia32) {
 		if (ka->sa.sa_flags & SA_SIGINFO)
-			ret = __setup_rt_frame(usig, ka, info, set, regs);
+			ret = ia32_setup_rt_frame(usig, ka, info, set, regs);
 		else
-			ret = __setup_frame(usig, ka, set, regs);
+			ret = ia32_setup_frame(usig, ka, set, regs);
 	} else
 		ret = __setup_rt_frame(sig, ka, info, set, regs);
 
-- 
1.5.6

