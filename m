Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbYIXAWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbYIXAWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 20:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbYIXAWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 20:22:32 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:6803 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbYIXAWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 20:22:32 -0400
Message-ID: <48D98848.3060209@ct.jp.nec.com>
Date: Tue, 23 Sep 2008 17:22:32 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: signal: cosmetic unification of handle_signal()
References: <48D987A0.50508@ct.jp.nec.com>
In-Reply-To: <48D987A0.50508@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Make handle_signal() same.

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 arch/x86/kernel/signal_32.c |    9 +++++++++
 arch/x86/kernel/signal_64.c |    2 ++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index b94463f..bb05917 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -550,6 +550,15 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_X86_64
+	/*
+	 * This has nothing to do with segment registers,
+	 * despite the name.  This magic affects uaccess.h
+	 * macros' behavior.  Reset it to the normal setting.
+	 */
+	set_fs(USER_DS);
+#endif
+
 	/*
 	 * Clear the direction flag as per the ABI for function entry.
 	 */
diff --git a/arch/x86/kernel/signal_64.c b/arch/x86/kernel/signal_64.c
index 9087752..963236f 100644
--- a/arch/x86/kernel/signal_64.c
+++ b/arch/x86/kernel/signal_64.c
@@ -346,12 +346,14 @@ handle_signal(unsigned long sig, siginfo_t *info, struct k_sigaction *ka,
 	if (ret)
 		return ret;
 
+#ifdef CONFIG_X86_64
 	/*
 	 * This has nothing to do with segment registers,
 	 * despite the name.  This magic affects uaccess.h
 	 * macros' behavior.  Reset it to the normal setting.
 	 */
 	set_fs(USER_DS);
+#endif
 
 	/*
 	 * Clear the direction flag as per the ABI for function entry.
-- 
1.5.6

