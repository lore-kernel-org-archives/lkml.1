Return-Path: <linux-kernel-owner+w=401wt.eu-S1757018AbYHXWkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018AbYHXWkS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 18:40:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753550AbYHXWkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 18:40:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:54933 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753236AbYHXWkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 18:40:04 -0400
Subject: Re: Random crashes with 2.6.27-rc3 on PPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Andreas Schwab <schwab@suse.de>
Cc: Michael Buesch <mb@bu3sch.de>, linuxppc-dev@ozlabs.org,
       Linus Torvalds <torvalds@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <je7ia6bhdd.fsf@sykes.suse.de>
References: <200808231610.46473.mb@bu3sch.de>
	 <1219531969.21386.205.camel@pasglop> <200808241544.12412.mb@bu3sch.de>
	 <je7ia6bhdd.fsf@sykes.suse.de>
Content-Type: text/plain
Date: Mon, 25 Aug 2008 08:39:46 +1000
Message-Id: <1219617586.21386.228.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-08-24 at 16:46 +0200, Andreas Schwab wrote:
> Michael Buesch <mb@bu3sch.de> writes:
> 
> > The following workaround seems to fix the crashes on powerpc.
> > However, this patch is clearly not what we want for other architectures,
> > as they might need -fno-omit-frame-pointer to function properly.
> 
> This has a better chance to be accepted. :-)

Unfortunately, that won't solve the FTRACE problem.

Ben.

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 8b5a7d3..f9a2e48 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -394,7 +394,7 @@ config LOCKDEP
>  	bool
>  	depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
>  	select STACKTRACE
> -	select FRAME_POINTER if !X86 && !MIPS
> +	select FRAME_POINTER if !X86 && !MIPS && !PPC
>  	select KALLSYMS
>  	select KALLSYMS_ALL
>  
> 
> > Index: linux-2.6/kernel/Makefile
> > ===================================================================
> > --- linux-2.6.orig/kernel/Makefile	2008-08-24 11:50:23.000000000 +0200
> > +++ linux-2.6/kernel/Makefile	2008-08-24 12:15:54.000000000 +0200
> > @@ -92,13 +92,13 @@ obj-$(CONFIG_SMP) += sched_cpupri.o
> >  ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
> >  # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
> >  # needed for x86 only.  Why this used to be enabled for all architectures is beyond
> >  # me.  I suspect most platforms don't need this, but until we know that for sure
> >  # I turn this off for IA-64 only.  Andreas Schwab says it's also needed on m68k
> >  # to get a correct value for the wait-channel (WCHAN in ps). --davidm
> > -CFLAGS_sched.o := $(PROFILING) -fno-omit-frame-pointer
> > +CFLAGS_sched.o := $(PROFILING)
> 
> CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER is already enabled on powerpc.
> 
> Andreas.
> 

