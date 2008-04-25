Return-Path: <linux-kernel-owner+w=401wt.eu-S1763321AbYDYQSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763321AbYDYQSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:18:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758618AbYDYQSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:18:37 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:41249 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909AbYDYQSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:18:36 -0400
Date: Fri, 25 Apr 2008 19:17:45 +0300
From: Adrian Bunk <bunk@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Starikovskiy <astarikovskiy@suse.de>,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: Voyager phys_cpu_present_map compile error
Message-ID: <20080425161745.GA21168@cs181133002.pp.htv.fi>
References: <20080421000238.GD26897@cs181133002.pp.htv.fi> <20080421085314.GI26897@cs181133002.pp.htv.fi> <20080421120054.GA6788@elte.hu> <20080421132705.GG6011@cs181133002.pp.htv.fi> <20080421201434.GN8770@elte.hu> <1209135044.3087.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1209135044.3087.3.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 09:50:43AM -0500, James Bottomley wrote:
> On Mon, 2008-04-21 at 22:14 +0200, Ingo Molnar wrote:
> > * Adrian Bunk <bunk@kernel.org> wrote:
> > 
> > > > +#ifndef CONFIG_X86_VOYAGER
> > > >  /* Bitmask of physically existing CPUs */
> > > >  physid_mask_t phys_cpu_present_map;
> > > > +#endif
> > > >...
> > > 
> > > Alexey noted that phys_cpu_present_map for Voyager and !Voyager also 
> > > have different types and suggested to make the Voyager one static 
> > > instead (additional renaming of the Voyager one also makes sense).
> > 
> > yep, done by the patch below.
> 
> Actually, this isn't the right patch.  The point is not to avoid the
> symbol clash, it's to let voyager identify correctly that you have a
> leaking symbol.  In this case phys_cpu_present_map is exposed outside of
> SMP.  The correct fix (and one which sweeps op other storage for
> unnecessary symbols is this):
> 
> James
> 
> ---
> 
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index c0c68c1..d68aa53 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -12,6 +12,7 @@
>  #include <asm/mpspec.h>
>  #include <asm/apicdef.h>
>  
> +#ifdef CONIFG_X86_SMP
>...

tpyo  ;)

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

