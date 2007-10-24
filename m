Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbXJXHXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbXJXHXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:23:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbXJXHXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:23:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38531 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbXJXHXf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:23:35 -0400
Date: Wed, 24 Oct 2007 09:23:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux v2.6.24-rc1
Message-ID: <20071024072322.GA2907@elte.hu>
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org> <a8e1da0710232222h537be0d7tba8e654150fdd57b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0710232222h537be0d7tba8e654150fdd57b@mail.gmail.com>
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


* Dave Young <hidave.darkstar@gmail.com> wrote:

> Hi,
> build failed on my pc:
> 
> arch/x86/kernel/built-in.o(.text+0x1b192): In function
> `smp_send_nmi_allbutself':
> : undefined reference to `genapic'

please send us the .config you are using. Chances are that the patch 
below will fix the build breakage for you.

	Ingo

--------------------->
Subject: x86: fix CONFIG_KEXEC build breakage
From: Mike Galbraith <efault@gmx.de>

X86_32 build fix to commit 62a31a03b3d2a9d20e7a073e2cd9b27bfb7d6a3f

Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/crash.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/crash.c
===================================================================
--- linux.orig/arch/x86/kernel/crash.c
+++ linux/arch/x86/kernel/crash.c
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
