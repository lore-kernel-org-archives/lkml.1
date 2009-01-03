Return-Path: <linux-kernel-owner+w=401wt.eu-S1760416AbZACX1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760416AbZACX1n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 18:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760084AbZACX1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 18:27:35 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:54021 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbZACX1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 18:27:34 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/1] x86_64: fix RIP printout in early_idt_handler
Date: Sun,  4 Jan 2009 00:27:09 +0100
Message-Id: <1231025229-26352-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since errorcode is popped out, RIP is on the top of the stack.
Use real RIP value instead of wrong CS.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/kernel/head_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 26cfdc1..0e275d4 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -305,7 +305,7 @@ ENTRY(early_idt_handler)
 	call dump_stack
 #ifdef CONFIG_KALLSYMS	
 	leaq early_idt_ripmsg(%rip),%rdi
-	movq 8(%rsp),%rsi	# get rip again
+	movq 0(%rsp),%rsi	# get rip again
 	call __print_symbol
 #endif
 #endif /* EARLY_PRINTK */
-- 
1.6.0.6

