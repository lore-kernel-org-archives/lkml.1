Return-Path: <linux-kernel-owner+w=401wt.eu-S935607AbYBCBBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935607AbYBCBBy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 20:01:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765667AbYBCBBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 20:01:46 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:51534 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376AbYBCBBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 20:01:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=K+vCeWmHGWwVK9JWY58X5KpZY9jKyO5SCNKpjdUJcYwYkaUr84uYLm7FiFLi32dAJ+Vm46WwZ20bJj4RUqaY2uF3E03/8lXyl/LoFuIwPTOGF8hMbXd/NCeS2/Q9cCc4H0B3o4Kb1ZKsN6MSEgKASb2QxtpBzn3hBEYXMQuadi0=
Subject: Re: [PATCH] x86: Remove pt_regs arg from smp_thermal_interrupt
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell Leidich <rml@google.com>, Andi Kleen <andi@firstfloor.org>,
       Torsten Kaiser <just.for.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, valdis.kletnieks@vt.edu,
       Tim Hockin <thockin@google.com>
In-Reply-To: <1201999807.1844.34.camel@brick>
References: <3f1a065b0801021350x7fd065fbj9680ce1a4f3c6538@mail.gmail.com>
	 <20080104222637.GA19248@one.firstfloor.org>
	 <3f1a065b0801041653y77c27a8cvce703cb7d13e10a0@mail.gmail.com>
	 <20080105132402.GA705@one.firstfloor.org>
	 <3f1a065b0801051208y7e832e8ctda61f28e6328dec3@mail.gmail.com>
	 <3f1a065b0801081542p6cca6249g35e83f7e1f450fbd@mail.gmail.com>
	 <20080108235212.GE2117@one.firstfloor.org>
	 <3f1a065b0801081828y4b084a52g1db9bcb8821cb3da@mail.gmail.com>
	 <20080109023714.GK2117@one.firstfloor.org>
	 <3f1a065b0801101821k71ea7523l5024f12abb50357f@mail.gmail.com>
	 <3f1a065b0801171706o57ae5d6w8a986db508ddcee4@mail.gmail.com>
	 <20080202161057.b240f443.akpm@linux-foundation.org>
	 <1201998460.1844.32.camel@brick>
	 <20080202163947.c66f6d19.akpm@linux-foundation.org>
	 <1201999807.1844.34.camel@brick>
Content-Type: text/plain
Date: Sat, 02 Feb 2008 17:01:53 -0800
Message-Id: <1202000513.1844.36.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pt_regs arg is never used, make it agree with the other
definitions of smp_thermal_interrupt.

It doesn't look like smp_thermal_interrupt is even called on
32-bit...

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
How about I actually send the patch that worked this time?
Sorry about the last one.

 arch/x86/kernel/cpu/mcheck/p4.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/p4.c b/arch/x86/kernel/cpu/mcheck/p4.c
index cb03345..1f76b98 100644
--- a/arch/x86/kernel/cpu/mcheck/p4.c
+++ b/arch/x86/kernel/cpu/mcheck/p4.c
@@ -36,7 +36,7 @@ static int mce_num_extended_msrs = 0;
 
 
 #ifdef CONFIG_X86_MCE_P4THERMAL
-static void unexpected_thermal_interrupt(struct pt_regs *regs)
+static void unexpected_thermal_interrupt(void)
 {	
 	printk(KERN_ERR "CPU%d: Unexpected LVT TMR interrupt!\n",
 			smp_processor_id());
@@ -44,7 +44,7 @@ static void unexpected_thermal_interrupt(struct pt_regs *regs)
 }
 
 /* P4/Xeon Thermal transition interrupt handler */
-static void intel_thermal_interrupt(struct pt_regs *regs)
+static void intel_thermal_interrupt(void)
 {
 	__u64 msr_val;
 
@@ -55,12 +55,12 @@ static void intel_thermal_interrupt(struct pt_regs *regs)
 }
 
 /* Thermal interrupt handler for this CPU setup */
-static void (*vendor_thermal_interrupt)(struct pt_regs *regs) = unexpected_thermal_interrupt;
+static void (*vendor_thermal_interrupt)(void) = unexpected_thermal_interrupt;
 
-void smp_thermal_interrupt(struct pt_regs *regs)
+void smp_thermal_interrupt(void)
 {
 	irq_enter();
-	vendor_thermal_interrupt(regs);
+	vendor_thermal_interrupt();
 	__get_cpu_var(irq_stat).irq_thermal_count++;
 	irq_exit();
 }
-- 
1.5.4.rc4.1142.gf5a97



