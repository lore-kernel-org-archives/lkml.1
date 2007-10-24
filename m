Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbXJXEcu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbXJXEcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:32:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbXJXEcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:32:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:46320 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750716AbXJXEcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:32:42 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+W64Z5MkGWHzuyEzffm4Fxupvjj+HfY87nYSBTIz
	41TV4lbTwcPpy5
Subject: [patchlet] Re: [Git pull] x86 updates
From: Mike Galbraith <efault@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <alpine.LFD.0.9999.0710232258190.5181@localhost.localdomain>
References: <alpine.LFD.0.9999.0710232258190.5181@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 24 Oct 2007 06:32:35 +0200
Message-Id: <1193200355.7166.7.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-10-23 at 23:02 +0200, Thomas Gleixner wrote:
> Linus, 
> 
> please pull from:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-x86.git
> 
> This contains a couple of bug fixes and a large cleanup and
> unification section from various authors.

X86_32 build fix to commit 62a31a03b3d2a9d20e7a073e2cd9b27bfb7d6a3f

Signed-off-by: Mike Galbraith <efault@gmx.de>

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index af0253f..8bb482f 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -25,7 +25,7 @@
 #include <linux/kdebug.h>
 #include <asm/smp.h>
 
-#ifdef X86_32
+#ifdef CONFIG_X86_32
 #include <mach_ipi.h>
 #else
 #include <asm/mach_apic.h>
@@ -41,7 +41,7 @@ static int crash_nmi_callback(struct notifier_block *self,
 			unsigned long val, void *data)
 {
 	struct pt_regs *regs;
-#ifdef X86_32
+#ifdef CONFIG_X86_32
 	struct pt_regs fixed_regs;
 #endif
 	int cpu;
@@ -60,7 +60,7 @@ static int crash_nmi_callback(struct notifier_block *self,
 		return NOTIFY_STOP;
 	local_irq_disable();
 
-#ifdef X86_32
+#ifdef CONFIG_X86_32
 	if (!user_mode_vm(regs)) {
 		crash_fixup_ss_esp(&fixed_regs, regs);
 		regs = &fixed_regs;


