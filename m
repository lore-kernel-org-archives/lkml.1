Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYEHEga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYEHEga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 00:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYEHEgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 00:36:21 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:55049 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbYEHEgT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 00:36:19 -0400
Date: Wed, 7 May 2008 21:36:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       jeremy@goop.org, mingo@elte.hu
Subject: Re: [PATCH 1/10] Add generic helpers for arch IPI function calls
Message-ID: <20080508043613.GB20338@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20080502020241.GA26088@linux.vnet.ibm.com> <20080502021233.GC11844@wotan.suse.de> <20080502122955.GB15522@linux.vnet.ibm.com> <20080502124205.GA23680@linux.vnet.ibm.com> <1209733169.13978.157.camel@twins> <20080503054930.GA19664@wotan.suse.de> <20080503181148.GA16159@linux.vnet.ibm.com> <20080505041533.GA17640@wotan.suse.de> <20080505174312.GC7543@linux.vnet.ibm.com> <20080507204251.GO16217@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507204251.GO16217@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 10:42:52PM +0200, Jens Axboe wrote:
> On Mon, May 05 2008, Paul E. McKenney wrote:
> > OK.  The below still permits parallel smp_call_function()
> > and smp_call_function_mask() as well as permitting parallel
> > smp_call_function_single().  It prohibits the irq-disabled case.
> > 
> > Thoughts?
> 
> Sorry for the delayed response here. The below looks pretty good to me,
> though it'll require a few modifications to fixup smp_call_function()
> from irq disabled context.

Yep, easy fix, even if wait==1 needed.

> But that's doable, though I have to do a grep over the kernel to check
> everything (I remember CPU send_stop being one such path). Not a huge
> fan of such an interface, but hey...
> 
> Is everyone OK with going this route, initially at least? It's the
> lesser of all evils, I think.
> 
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index a5a0184..5ae9360 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -38,4 +38,4 @@ config HAVE_KRETPROBES
> >  	def_bool n
> >  
> >  config USE_GENERIC_SMP_HELPERS
> > -	def_bool n
> > +	def_bool y
> 
> This part puzzled me, why? We default to 'n' and let converted archs
> opt-in, so I don't get this part of your patch...

<red face>  I made that change to get it to compile, and forgot to
revert it when making the patch.  Please ignore that bit.

							Thanx, Paul
