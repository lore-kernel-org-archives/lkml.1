Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337AbYIEX1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbYIEX1x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 19:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbYIEX1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 19:27:42 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:51085 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbYIEX1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 19:27:41 -0400
Message-ID: <48C1C06B.3040509@ct.jp.nec.com>
Date: Fri, 05 Sep 2008 16:27:39 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] x86: signal: make NR_restart_syscall
References: <48C1BF41.8040404@ct.jp.nec.com>
In-Reply-To: <48C1BF41.8040404@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

make NR_restart_syscall macro for cosmetic unification of handle_signal().

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    3 ++-
 arch/x86/kernel/signal_64.c |    6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 76d05d7..bd9b650 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -572,6 +572,7 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	return 0;
 }
 
+#define NR_restart_syscall	__NR_restart_syscall
 /*
  * Note that 'init' is a special process: it doesn't get signals it doesn't
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
@@ -635,7 +636,7 @@ static void do_signal(struct pt_regs *regs)
 			break;
 
 		case -ERESTART_RESTARTBLOCK:
-			regs->ax = __NR_restart_syscall;
+			regs->ax = NR_restart_syscall;
 			regs->ip -= 2;
 			break;
 		}
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 823a55b..19e2b91 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -362,6 +362,8 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	return ret;
 }
 
+#define NR_restart_syscall	\
+	test_thread_flag(TIF_IA32) ? __NR_ia32_restart_syscall : __NR_restart_syscall
 /*
  * Note that 'init' is a special process: it doesn't get signals it doesn't
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
@@ -423,9 +425,7 @@ static void do_signal(struct pt_regs *regs)
 			regs->ip -= 2;
 			break;
 		case -ERESTART_RESTARTBLOCK:
-			regs->ax = test_thread_flag(TIF_IA32) ?
-					__NR_ia32_restart_syscall :
-					__NR_restart_syscall;
+			regs->ax = NR_restart_syscall;
 			regs->ip -= 2;
 			break;
 		}
-- 
1.5.6

