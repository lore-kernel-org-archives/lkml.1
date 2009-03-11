Return-Path: <linux-kernel-owner+w=401wt.eu-S1754599AbZCKMqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbZCKMqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZCKMpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:45:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:45010 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbZCKMpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:45:55 -0400
Subject: Re: [git-pull -tip V2] x86: cpu architecture debug code
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1236772478.2836.12.camel@ht.satnam>
References: <1236684201.3301.11.camel@localhost.localdomain>
	 <20090310122806.GE5794@elte.hu>
	 <1236697752.3387.2.camel@localhost.localdomain>
	 <20090310152029.GN3850@elte.hu>
	 <1236701373.3387.4.camel@localhost.localdomain>
	 <20090310174535.GA2963@elte.hu>  <1236772478.2836.12.camel@ht.satnam>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Mar 2009 18:15:18 +0530
Message-Id: <1236775518.2836.14.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 17:24 +0530, Jaswinder Singh Rajput wrote:
> On Tue, 2009-03-10 at 18:45 +0100, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > On Tue, 2009-03-10 at 16:20 +0100, Ingo Molnar wrote:
> > > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > > 
> > > > > +#include <linux/interrupt.h>
> > > > > +#include <linux/compiler.h>
> > > > > +#include <linux/kprobes.h>
> > > > > +#include <linux/signal.h>
> > > > > +#include <linux/kernel.h>
> > > > > +#include <linux/module.h>
> > > > > +#include <linux/errno.h>
> > > > > +#include <linux/sched.h>
> > > > > +#include <linux/types.h>
> > > > > +#include <linux/init.h>
> > > > > +#include <linux/smp.h>
> > > > > +#include <linux/slab.h>
> > > > > +#include <linux/percpu.h>
> > > > > +#include <linux/debugfs.h>
> > > > > +#include <linux/seq_file.h>
> > > > 
> > > > If you look at arch/x86/mm/fault.c, they are sorted by length, 
> > > > and within the same length they are sorted alphabetically.
> > > 
> > > Ok fixed, new pull request:
> > > 
> > > The following changes since commit 23eeaab0397190b112591dab13d1fb196f099254:
> > >   Ingo Molnar (1):
> > >         Merge branch 'tracing/ftrace'
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
> > > 
> > > Jaswinder Singh Rajput (1):
> > >       x86: cpu architecture debug code
> > > 
> > >  arch/x86/Kconfig                 |    6 +
> > >  arch/x86/include/asm/cpu_debug.h |  193 ++++++++++
> > >  arch/x86/kernel/cpu/Makefile     |    2 +
> > >  arch/x86/kernel/cpu/cpu_debug.c  |  784 ++++++++++++++++++++++++++++++++++++++
> > >  4 files changed, 985 insertions(+), 0 deletions(-)
> > >  create mode 100755 arch/x86/include/asm/cpu_debug.h
> > >  create mode 100755 arch/x86/kernel/cpu/cpu_debug.c
> > 
> > Thanks - picked it up into tip:x86/debug. (Note that i 
> > rearranged the Makefile details a bit so that it does not 
> > conflict with tip:perfcounters)
> > 
> > Not yet in tip:master, because it triggers this build failure:
> > 
> > arch/x86/kernel/cpu/cpu_debug.c: In function ‘print_dt’:
> > arch/x86/kernel/cpu/cpu_debug.c:475: error: implicit declaration of function ‘store_ldt’
> 
> The following changes since commit 259ef6fcea4046fe24495b1e3631c1b905c531c1:
>   Jaswinder Singh Rajput (1):
>         x86: cpu architecture debug code
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master
> 
> Jaswinder Singh Rajput (1):
>       x86: cpu_debug.c remove some dependency
> 
>  arch/x86/kernel/cpu/cpu_debug.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> Complete diff:
> diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
> index 0bdf4da..c844262 100755
> --- a/arch/x86/kernel/cpu/cpu_debug.c
> +++ b/arch/x86/kernel/cpu/cpu_debug.c
> @@ -23,6 +23,7 @@
>  #include <linux/smp.h>
>  
>  #include <asm/cpu_debug.h>
> +#include <asm/paravirt.h>
>  #include <asm/system.h>
>  #include <asm/traps.h>
>  #include <asm/apic.h>
> @@ -427,7 +428,7 @@ static void print_tss(void *arg)
>  	seq_printf(seq, " CS\t:             %04x\n", seg);
>  	asm("movl %%ds,%0" : "=r" (seg));
>  	seq_printf(seq, " DS\t:             %04x\n", seg);
> -	seq_printf(seq, " SS\t:             %04lx\n", regs->ss);
> +	seq_printf(seq, " SS\t:             %04lx\n", regs->ss & 0xFF);

oops, typo, here is the correct one:

The following changes since commit 259ef6fcea4046fe24495b1e3631c1b905c531c1:
  Jaswinder Singh Rajput (1):
        x86: cpu architecture debug code

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaswinder/linux-2.6-tip-cpu.git master

Jaswinder Singh Rajput (1):
      x86: cpu_debug.c remove store_ldt

 arch/x86/kernel/cpu/cpu_debug.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

Complete diff:
diff --git a/arch/x86/kernel/cpu/cpu_debug.c b/arch/x86/kernel/cpu/cpu_debug.c
index 0bdf4da..08f55ce 100755
--- a/arch/x86/kernel/cpu/cpu_debug.c
+++ b/arch/x86/kernel/cpu/cpu_debug.c
@@ -23,6 +23,7 @@
 #include <linux/smp.h>
 
 #include <asm/cpu_debug.h>
+#include <asm/paravirt.h>
 #include <asm/system.h>
 #include <asm/traps.h>
 #include <asm/apic.h>
@@ -427,7 +428,7 @@ static void print_tss(void *arg)
 	seq_printf(seq, " CS\t:             %04x\n", seg);
 	asm("movl %%ds,%0" : "=r" (seg));
 	seq_printf(seq, " DS\t:             %04x\n", seg);
-	seq_printf(seq, " SS\t:             %04lx\n", regs->ss);
+	seq_printf(seq, " SS\t:             %04lx\n", regs->ss & 0xffff);
 	asm("movl %%es,%0" : "=r" (seg));
 	seq_printf(seq, " ES\t:             %04x\n", seg);
 	asm("movl %%fs,%0" : "=r" (seg));
@@ -472,7 +473,7 @@ static void print_dt(void *seq)
 	print_desc_ptr("GDT", seq, dt);
 
 	/* LDT */
-	store_ldt(ldt);
+	asm volatile("sldt %0" : "=m" (ldt));
 	seq_printf(seq, " LDT\t: %016lx\n", ldt);
 
 	/* TR */


