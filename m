Return-Path: <linux-kernel-owner+w=401wt.eu-S1760265AbZE0Pk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265AbZE0Pk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 11:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbZE0PkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 11:40:22 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:35357 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010AbZE0PkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 11:40:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j+/KtCCB1ud7ZqCSIXtoDkiLzS46vaLB/OW+5xe9G3f8bdq+C6BNGtYIiPfQxjKlX4
         1rDnw+kg9l0k8wyAZeD9cdVQDoh4esGWEmo+uyKgZNP6/vJQB8m4N/r3WFKldGwEB30y
         DR2lxZi7MYUoNfMHx+PB+zhoY8lr9GdBIJJgg=
Date: Wed, 27 May 2009 17:40:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch 01/12] Prepare the code for Hardware Breakpoint
	interfaces
Message-ID: <20090527154018.GE5982@nowhere>
References: <20090521095613.834622717@prasadkr_t60p.in.ibm.com> <20090521140033.GB13849@in.ibm.com> <20090527010113.GJ5969@nowhere> <20090527084917.GC6020@in.ibm.com> <20090527114828.GA5982@nowhere> <20090527142108.GC14090@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090527142108.GC14090@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 07:51:08PM +0530, K.Prasad wrote:
> On Wed, May 27, 2009 at 01:48:30PM +0200, Frederic Weisbecker wrote:
> > On Wed, May 27, 2009 at 02:19:17PM +0530, K.Prasad wrote:
> > > On Wed, May 27, 2009 at 03:01:15AM +0200, Frederic Weisbecker wrote:
> > > > On Thu, May 21, 2009 at 07:30:33PM +0530, K.Prasad wrote:
> > > > > This patch introduces header files containing constants, structure definitions
> > > > > and declaration of functions used by the hardware breakpoint interface code.
> > > > > 
> > > > > Original-patch-by: Alan Stern <stern@rowland.harvard.edu>
> > > > > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > > > > Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
> > > > > ---
> > > > > Index: linux-2.6-tip.hbkpt/arch/x86/include/asm/processor.h
> > > > > ===================================================================
> > > > > --- linux-2.6-tip.hbkpt.orig/arch/x86/include/asm/processor.h
> > > > > +++ linux-2.6-tip.hbkpt/arch/x86/include/asm/processor.h
> > > > > @@ -29,6 +29,7 @@ struct mm_struct;
> > > > >  #include <linux/threads.h>
> > > > >  #include <linux/init.h>
> > > > >  
> > > > > +#define HBP_NUM 4
> > > > >  /*
> > > > >   * Default implementation of macro that returns current
> > > > >   * instruction pointer ("program counter").
> > > > > @@ -433,12 +434,11 @@ struct thread_struct {
> > > > >  #endif
> > > > >  	unsigned long		gs;
> > > > >  	/* Hardware debugging registers: */
> > > > > -	unsigned long		debugreg0;
> > > > > -	unsigned long		debugreg1;
> > > > > -	unsigned long		debugreg2;
> > > > > -	unsigned long		debugreg3;
> > > > > +	unsigned long		debugreg[HBP_NUM];
> > > > 
> > > > 
> > > > 
> > > > Note that each patches must leave a buildable kernel, even
> > > > if these patches are contained in a set logic.
> > > > 
> > > > I haven't tried yet, but I suspect this patch, if applied
> > > > without the rest, will cause a build error.
> > > > 
> > > > There are still some sites that use the removed fields above.
> > > > 
> > > > A solution would be to temporarily fix these sites in this patch
> > > > by using the new debugreg array interface. Even if you remove
> > > > some of them in further patches in this series, for example
> > > > by using the new load_debug_registers() helper, it will follow
> > > > the logic step by step and leave a buildable kernel at each
> > > > middle step.
> > > > 
> > > > That implies to modify also some of the other patches of this
> > > > series, but all of these changes should be trivial.
> > > > 
> > > > Thanks,
> > > > 
> > > > Frederic.
> > > >
> > > 
> > > The debugreg<n> removal patches were correct, even as recent as
> > > http://lkml.org/lkml/2009/5/11/160 and I guess I messed-up meanwhile.
> > > Thanks for pointing it out - I've now moved them to Patch 8/12 along
> > > with the ptrace changes.
> > > 
> > > The rest of the patches allow the kernel tree to be compiled though.
> > > Would you prefer a new iteration with these changes, or can I send
> > > individual patches with the changes discussed above?
> > > 
> > > Thanks,
> > > K.Prasad
> > >  
> > 
> > 
> > Yeah you can resend those two individual patches. That's fine.
> > Just increase the version number and keep their place (1/12 and 8/12)
> > so that I won't run into confusion :)
> > 
> > Thanks!
> >
> 
> Hi Frederic,
> 	Please find the updated Patch 1/12 here:
> http://lkml.org/lkml/2009/5/27/345/ and Patch 8/12 here:
> http://lkml.org/lkml/2009/5/27/346/.
> 
> Without much foresight, I didnot track the changes in the patchset
> through version numbering (I'm doing it for the PPC64 patchset atleast),
> and wasn't very comfortable to call these new patches as ver II at this
> late a stage. Hope that would be acceptable to you!


Yeah, that's fine :-)
I'll test the whole patchset soon and if it passes basic testing,
I will send a pull request to Ingo.

Thanks!

 
> Thanks,
> K.Prasad
> 

