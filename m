Return-Path: <linux-kernel-owner+w=401wt.eu-S932588AbZDJRXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932588AbZDJRXV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759592AbZDJRXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:23:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:36947 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759579AbZDJRXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:23:02 -0400
Subject: Re: [git-pull -tip] x86: declaration patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <alpine.LFD.2.00.0904101849060.21577@localhost.localdomain>
References: <1239381184.23116.5.camel@ht.satnam>
	 <alpine.LFD.2.00.0904101849060.21577@localhost.localdomain>
Content-Type: text/plain
Date: Fri, 10 Apr 2009 22:51:51 +0530
Message-Id: <1239384111.3169.13.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-10 at 18:51 +0200, Thomas Gleixner wrote:
> On Fri, 10 Apr 2009, Jaswinder Singh Rajput wrote:
> >  #endif /* CONFIG_X86_32 */
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index 8499000..d1bac67 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -59,6 +59,7 @@
> >  #include <asm/setup.h>
> >  #include <asm/irq_remapping.h>
> >  #include <asm/hpet.h>
> > +#include <asm/hw_irq.h>		/* smp_irq_move_cleanup_interrupt */
> 
>   Can we please avoid these useless comments all over the place ?
> 

I kept these intentionally because few of these declarations I have
already fixed earlier.
For example during process.c unification work developers forget to
include and fix syscalls.h :

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commit;h=389d1fb11e5f2a16b5e34c547756f0c4dec641f7

Thats why I did:

diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 1d71442..4d397ce 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -15,6 +15,7 @@
 #include <asm/uaccess.h>
 #include <asm/i387.h>
 #include <asm/ds.h>
+#include <asm/syscalls.h>              /* sys_fork, sys_vfork */
 
 unsigned long idle_halt;
 EXPORT_SYMBOL(idle_halt);

Ingo, do you also think we need to remove these comments.

--
JSR


