Return-Path: <linux-kernel-owner+w=401wt.eu-S1760407AbZE0Iti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760407AbZE0Iti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 04:49:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756538AbZE0Ita
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 04:49:30 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:59796 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbZE0It3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 04:49:29 -0400
Date: Wed, 27 May 2009 14:19:17 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 01/12] Prepare the code for Hardware Breakpoint
	interfaces
Message-ID: <20090527084917.GC6020@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090521095613.834622717@prasadkr_t60p.in.ibm.com> <20090521140033.GB13849@in.ibm.com> <20090527010113.GJ5969@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527010113.GJ5969@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 03:01:15AM +0200, Frederic Weisbecker wrote:
> On Thu, May 21, 2009 at 07:30:33PM +0530, K.Prasad wrote:
> > This patch introduces header files containing constants, structure definitions
> > and declaration of functions used by the hardware breakpoint interface code.
> > 
> > Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> > ---
> > Index: linux-2.6-tip.hbkpt/arch/x86/include/asm/processor.h
> > ===================================================================
> > --- linux-2.6-tip.hbkpt.orig/arch/x86/include/asm/processor.h
> > +++ linux-2.6-tip.hbkpt/arch/x86/include/asm/processor.h
> > @@ -29,6 +29,7 @@ struct mm_struct;
> >  #include <linux/threads.h>
> >  #include <linux/init.h>
> >  
> > +#define HBP_NUM 4
> >  /*
> >   * Default implementation of macro that returns current
> >   * instruction pointer ("program counter").
> > @@ -433,12 +434,11 @@ struct thread_struct {
> >  #endif
> >  	unsigned long		gs;
> >  	/* Hardware debugging registers: */
> > -	unsigned long		debugreg0;
> > -	unsigned long		debugreg1;
> > -	unsigned long		debugreg2;
> > -	unsigned long		debugreg3;
> > +	unsigned long		debugreg[HBP_NUM];
> 
> 
> 
> Note that each patches must leave a buildable kernel, even
> if these patches are contained in a set logic.
> 
> I haven't tried yet, but I suspect this patch, if applied
> without the rest, will cause a build error.
> 
> There are still some sites that use the removed fields above.
> 
> A solution would be to temporarily fix these sites in this patch
> by using the new debugreg array interface. Even if you remove
> some of them in further patches in this series, for example
> by using the new load_debug_registers() helper, it will follow
> the logic step by step and leave a buildable kernel at each
> middle step.
> 
> That implies to modify also some of the other patches of this
> series, but all of these changes should be trivial.
> 
> Thanks,
> 
> Frederic.
>

The debugreg<n> removal patches were correct, even as recent as
http://lkml.org/lkml/2009/5/11/160 and I guess I messed-up meanwhile.
Thanks for pointing it out - I've now moved them to Patch 8/12 along
with the ptrace changes.

The rest of the patches allow the kernel tree to be compiled though.
Would you prefer a new iteration with these changes, or can I send
individual patches with the changes discussed above?

Thanks,
K.Prasad
 
