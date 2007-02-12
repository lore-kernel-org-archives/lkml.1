Return-Path: <linux-kernel-owner+w=401wt.eu-S964993AbXBLQ5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964993AbXBLQ5J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964976AbXBLQ5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:57:08 -0500
Received: from mail.suse.de ([195.135.220.2]:47947 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964993AbXBLQvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:51:38 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212551.664370000@suse.de>
In-Reply-To: <20070212551.664370000@suse.de>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Andi Kleen <ak@suse.de>,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review III] [9/29] x86_64: Minor patch for compilation warning in x86_64 signal code
Message-Id: <20070212165129.3339913FC7@wotan.suse.de>
Date: Mon, 12 Feb 2007 17:51:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

If DEBUG_SIG is enbaled in source code, ia32_signal.c compiles with warning
due to wrong format string.  Attached patch fixes that.  It is quite minor
update, since by default DEBUG_SIG is not enabled and can not be turned on
without code modification.

Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/ia32/ia32_signal.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux/arch/x86_64/ia32/ia32_signal.c
===================================================================
--- linux.orig/arch/x86_64/ia32/ia32_signal.c
+++ linux/arch/x86_64/ia32/ia32_signal.c
@@ -495,7 +495,7 @@ int ia32_setup_frame(int sig, struct k_s
 		ptrace_notify(SIGTRAP);
 
 #if DEBUG_SIG
-	printk("SIG deliver (%s:%d): sp=%p pc=%p ra=%p\n",
+	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
 		current->comm, current->pid, frame, regs->rip, frame->pretcode);
 #endif
 
@@ -601,7 +601,7 @@ int ia32_setup_rt_frame(int sig, struct 
 		ptrace_notify(SIGTRAP);
 
 #if DEBUG_SIG
-	printk("SIG deliver (%s:%d): sp=%p pc=%p ra=%p\n",
+	printk("SIG deliver (%s:%d): sp=%p pc=%lx ra=%u\n",
 		current->comm, current->pid, frame, regs->rip, frame->pretcode);
 #endif
 
