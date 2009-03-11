Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZCKMMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZCKMMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 08:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755457AbZCKMMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 08:12:41 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:53330 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbZCKMMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 08:12:40 -0400
Date: Wed, 11 Mar 2009 17:41:46 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Roland McGrath <roland@redhat.com>
Subject: Re: [patch 00/11] Hardware Breakpoint interfaces
Message-ID: <20090311121007.GC13835@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20090305043726.GA17747@in.ibm.com> <20090310134655.GA3850@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310134655.GA3850@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 10, 2009 at 02:46:55PM +0100, Ingo Molnar wrote:
> 
> * prasad@linux.vnet.ibm.com <prasad@linux.vnet.ibm.com> wrote:
> 
> > Hi Ingo,
> 
> > 	Please find the revised set of patches that implement 
> > Hardware Breakpoint (or watchpoint) registers and an 
> > arch-specific implementation for x86/x86_64.
> 
> General structure looks good, with a good deal of details 
> that need to be addressed.
>

Thanks to Alan Stern for answering most of the questions....I am
pitching in to fill  the gaps and do any re-write based on the
comments.

> Firstly, as far as i can see this should work on 32-bit too, 
> correct?
> 

Yes. It's been tested on 32-bit x86 all throughout.

> Secondly, what about other architectures - will they build just 
> fine without any arch level glue code? kernel/hw_breakpoint.o 
> get build unconditionally - without any benefit to non-x86 code. 
> Perhaps an ARCH_HAS_HW_BREAKPOINTS Kconfig method would be 
> useful to add.

The hardware breakpoint interfaces haven't been put under any CONFIG_
till now, but I think we should bring them under a new config, say
CONFIG_HW_BREAKPOINT. It would help create a dependancy for
CONFIG_KSYM_TRACER too.

> 
> There's also a number of (small) style issues. 
> kernel/hw_breakpoint.c and other new .c files dont comply to the 
> customary comment style of:
> 
>   /*
>    * Comment .....
>    * ...... goes here:
>    */
> 
> also, the #include files section style should match that of 
> arch/x86/mm/fault.c - it's a conflict-avoidance style.
> 
> also, things like this:
> 
> static struct notifier_block hw_breakpoint_exceptions_nb = {
>         .notifier_call = hw_breakpoint_exceptions_notify,
>         .priority = 0x7fffffff /* we need to be notified first */
> };
> 
> should be:
> 
> static struct notifier_block hw_breakpoint_exceptions_nb = {
>         .notifier_call		= hw_breakpoint_exceptions_notify,
> 	/* We need to be notified first: */
>         .priority		= 0x7fffffff,
> };
> 
> 	Ingo

Sure, will look at the comment styling before I re-send the patchset.

Thanks,
K.Prasad

