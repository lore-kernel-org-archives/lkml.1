Return-Path: <linux-kernel-owner+w=401wt.eu-S1755990AbYJ3BoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbYJ3BoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYJ3BoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:44:11 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:35284 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYJ3BoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:44:10 -0400
Message-ID: <49091168.1070609@ct.jp.nec.com>
Date: Wed, 29 Oct 2008 18:44:08 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: signal: cosmetic unification of signr_convert()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Make signr_convert() same.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    2 ++
 arch/x86/kernel/signal_64.c |    6 ++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 85a0d37..abf0df7 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -503,10 +503,12 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
  */
 static int signr_convert(int sig)
 {
+#ifdef CONFIG_X86_32
 	struct thread_info *info = current_thread_info();
 
 	if (info->exec_domain && info->exec_domain->signal_invmap && sig < 32)
 		return info->exec_domain->signal_invmap[sig];
+#endif /* CONFIG_X86_32 */
 	return sig;
 }
 
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 3d0deb3..a4b46e6 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -295,6 +295,12 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
  */
 static int signr_convert(int sig)
 {
+#ifdef CONFIG_X86_32
+	struct thread_info *info = current_thread_info();
+
+	if (info->exec_domain && info->exec_domain->signal_invmap && sig < 32)
+		return info->exec_domain->signal_invmap[sig];
+#endif /* CONFIG_X86_32 */
 	return sig;
 }
 
-- 
1.5.6

