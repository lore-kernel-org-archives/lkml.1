Return-Path: <linux-kernel-owner+w=401wt.eu-S1763715AbXEWJWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763715AbXEWJWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbXEWJWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:22:44 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4491 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbXEWJWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:22:43 -0400
Date: Wed, 23 May 2007 10:22:32 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Kevin Hilman <khilman@mvista.com>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] ARM TLB flush fix: don't forget to re-enable preemption
Message-ID: <20070523092232.GA9482@flint.arm.linux.org.uk>
Mail-Followup-To: Kevin Hilman <khilman@mvista.com>,
	Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <20070522230128.891568116@mvista.com> <1179876320.15427.214.camel@imap.mvista.com> <1179877296.6122.74.camel@vence.hilman.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179877296.6122.74.camel@vence.hilman.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 04:41:36PM -0700, Kevin Hilman wrote:
> On Tue, 2007-05-22 at 16:25 -0700, Daniel Walker wrote:
> > On Tue, 2007-05-22 at 16:01 -0700, Kevin Hilman wrote:
> > > Add a preempt_enable() to flush_tlb_kernel_page() since -rt4 patch
> > > adds a preempt_disable but no preempt_enable().
> > > 
> > > Signed-off-by: Kevin Hilman <khilman@mvista.com>
> > > 
> > > 
> > > ---
> > >  include/asm-arm/tlbflush.h |    1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > Index: linux-2.6.21/include/asm-arm/tlbflush.h
> > > ===================================================================
> > > --- linux-2.6.21.orig/include/asm-arm/tlbflush.h
> > > +++ linux-2.6.21/include/asm-arm/tlbflush.h
> > > @@ -378,6 +378,7 @@ static inline void local_flush_tlb_kerne
> > >  		asm("mcr p15, 0, %0, c8, c6, 1" : : "r" (kaddr) : "cc");
> > >  	if (tlb_flag(TLB_V6_I_PAGE))
> > >  		asm("mcr p15, 0, %0, c8, c5, 1" : : "r" (kaddr) : "cc");
> > 
> > Aren't these mcr operations atomic?
> > 
> 
> Individually, yes.  But the point of the preempt_disable/enable is to
> make the whole sequence atomic.

In which case shouldn't it be at the end of the function so it includes
the write buffer handling as well?

However, I think I agree with Daniel on this one.  I don't see the point
of the preempt_disable() here.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
