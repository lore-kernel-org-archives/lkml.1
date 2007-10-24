Return-Path: <linux-kernel-owner+w=401wt.eu-S1754385AbXJXHeO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385AbXJXHeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 03:34:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbXJXHd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 03:33:59 -0400
Received: from wx-out-0506.google.com ([66.249.82.228]:30434 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbXJXHd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 03:33:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nZX9SW7ktz8g3ZHmy99pG7z2Lg2qhxl8A1pJJaW/rkLKE6/FSzDZDPU+gGGOiBpxGPn1Lv4GF/X9rpHsoSiGoCxoF+jXXcNozZGxb0bI7lnpVXk46WtZzFqZu72gu/WuhBHsBamaNgb1lAaEzumidzfY+Va19O7CGFppyZIPpeU=
Message-ID: <a8e1da0710240033v2f55a296x3927c60ce5030100@mail.gmail.com>
Date: Wed, 24 Oct 2007 15:33:57 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Linux v2.6.24-rc1
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071024072322.GA2907@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.999.0710232057080.30120@woody.linux-foundation.org>
	 <a8e1da0710232222h537be0d7tba8e654150fdd57b@mail.gmail.com>
	 <20071024072322.GA2907@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Dave Young <hidave.darkstar@gmail.com> wrote:
>
> > Hi,
> > build failed on my pc:
> >
> > arch/x86/kernel/built-in.o(.text+0x1b192): In function
> > `smp_send_nmi_allbutself':
> > : undefined reference to `genapic'
>
> please send us the .config you are using. Chances are that the patch
> below will fix the build breakage for you.
>
Hi,
Yes, I have tried it, works fine.

Part of my .config:
#
# Automatically generated make config: don't edit
# Linux kernel version: 2.6.24-rc1
# Wed Oct 24 13:02:24 2007
#
CONFIG_X86_32=y
CONFIG_GENERIC_TIME=y
CONFIG_GENERIC_CMOS_UPDATE=y
CONFIG_CLOCKSOURCE_WATCHDOG=y
CONFIG_GENERIC_CLOCKEVENTS=y
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_STACKTRACE_SUPPORT=y
CONFIG_SEMAPHORE_SLEEPERS=y
CONFIG_X86=y
CONFIG_MMU=y
CONFIG_ZONE_DMA=y
CONFIG_QUICKLIST=y
CONFIG_GENERIC_ISA_DMA=y
CONFIG_GENERIC_IOMAP=y
CONFIG_GENERIC_BUG=y
CONFIG_GENERIC_HWEIGHT=y
CONFIG_ARCH_MAY_HAVE_PC_FDC=y
CONFIG_DMI=y
CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
----cut----
>         Ingo
>
> --------------------->
> Subject: x86: fix CONFIG_KEXEC build breakage
> From: Mike Galbraith <efault@gmx.de>
>
> X86_32 build fix to commit 62a31a03b3d2a9d20e7a073e2cd9b27bfb7d6a3f
>
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/kernel/crash.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> Index: linux/arch/x86/kernel/crash.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/crash.c
> +++ linux/arch/x86/kernel/crash.c
> @@ -25,7 +25,7 @@
>  #include <linux/kdebug.h>
>  #include <asm/smp.h>
>
> -#ifdef X86_32
> +#ifdef CONFIG_X86_32
>  #include <mach_ipi.h>
>  #else
>  #include <asm/mach_apic.h>
> @@ -41,7 +41,7 @@ static int crash_nmi_callback(struct not
>                         unsigned long val, void *data)
>  {
>         struct pt_regs *regs;
> -#ifdef X86_32
> +#ifdef CONFIG_X86_32
>         struct pt_regs fixed_regs;
>  #endif
>         int cpu;
> @@ -60,7 +60,7 @@ static int crash_nmi_callback(struct not
>                 return NOTIFY_STOP;
>         local_irq_disable();
>
> -#ifdef X86_32
> +#ifdef CONFIG_X86_32
>         if (!user_mode_vm(regs)) {
>                 crash_fixup_ss_esp(&fixed_regs, regs);
>                 regs = &fixed_regs;
>
