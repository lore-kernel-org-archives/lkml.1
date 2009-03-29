Return-Path: <linux-kernel-owner+w=401wt.eu-S1758695AbZC2UWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695AbZC2UWi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 16:22:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755520AbZC2UVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 16:21:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:47870 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755319AbZC2UVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 16:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=dEMo5HoNunLFJeXj9bV4OR1qGZphWbh7GtiAAw9v+PZa043Wincsa2m/4d5JwAePIx
         /k1T4ktkUR/xnVPQmOWaLstc19BrxwsrJg91xGUxIv46Ah1/UZSAk4zuucfddY9N7r9V
         pgSjQ4qb4nr75ZDUXZbtYLN3uMqYxgXlM5RLw=
Message-Id: <20090329202207.876257632@openvz.org>
User-Agent: quilt/0.47-1
Date: Mon, 30 Mar 2009 00:15:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, xemul@openvz.org, yhlu.kernel@gmail.com,
       Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/6] x86: irqinit - merge smp_intr_init
References: <20090329201545.470255691@openvz.org>
Content-Disposition: inline; filename=x86-irqinit-smp_intr_init
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All x86-64 CPUs has a local APIC.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/irqinit_32.c |    2 +-
 arch/x86/kernel/irqinit_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/irqinit_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_32.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_32.c
@@ -158,7 +158,7 @@ static void __init smp_intr_init(void)
 	/* IPI for generic function call */
 	alloc_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 
-	/* IPI for single call function */
+	/* IPI for generic single function call */
 	alloc_intr_gate(CALL_FUNCTION_SINGLE_VECTOR,
 				 call_function_single_interrupt);
 
Index: linux-2.6.git/arch/x86/kernel/irqinit_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/irqinit_64.c
+++ linux-2.6.git/arch/x86/kernel/irqinit_64.c
@@ -107,7 +107,7 @@ void init_IRQ(void) __attribute__((weak,
 
 static void __init smp_intr_init(void)
 {
-#ifdef CONFIG_SMP
+#if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_SMP)
 	/*
 	 * The reschedule interrupt is a CPU-to-CPU reschedule-helper
 	 * IPI, driven by wakeup.

