Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbXJXKae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbXJXKae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 06:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbXJXKa0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 06:30:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42389 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbXJXKaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 06:30:25 -0400
Date: Wed, 24 Oct 2007 12:30:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Holvenstot <cholvenstot@comcast.net>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Build Failure with 2.6.24-rc1
Message-ID: <20071024103012.GA16917@elte.hu>
References: <1193221627.5685.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193221627.5685.2.camel@localhost>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Holvenstot <cholvenstot@comcast.net> wrote:

> When attempting to build the 2.6.24-rc1 kernel:
> 
> arch/x86/kernel/built-in.o: In function `smp_send_nmi_allbutself':
> /build/linux/arch/x86/kernel/crash.c:85: undefined reference to
> `genapic'
> make: *** [.tmp_vmlinux1] Error 1

the patch below should fix this.

	Ingo

------------------>
Subject: x86: fix CONFIG_KEXEC build breakage
From: Mike Galbraith <efault@gmx.de>

X86_32 build fix to commit 62a31a03b3d2a9d20e7a073e2cd9b27bfb7d6a3f

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/crash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-x86.q/arch/x86/kernel/crash.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/crash.c
+++ linux-x86.q/arch/x86/kernel/crash.c
@@ -25,7 +25,7 @@
 #include <linux/kdebug.h>
 #include <asm/smp.h>
 
-#ifdef X86_32
+#ifdef CONFIG_X86_32
 #include <mach_ipi.h>
 #else
 #include <asm/mach_apic.h>
@@ -41,7 +41,7 @@ static int crash_nmi_callback(struct not
 			unsigned long val, void *data)
 {
 	struct pt_regs *regs;
-#ifdef X86_32
+#ifdef CONFIG_X86_32
 	struct pt_regs fixed_regs;
 #endif
 	int cpu;
@@ -60,7 +60,7 @@ static int crash_nmi_callback(struct not
 		return NOTIFY_STOP;
 	local_irq_disable();
 
-#ifdef X86_32
+#ifdef CONFIG_X86_32
 	if (!user_mode_vm(regs)) {
 		crash_fixup_ss_esp(&fixed_regs, regs);
 		regs = &fixed_regs;
