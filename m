Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYFCNyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYFCNyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYFCNyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:54:44 -0400
Received: from www.tglx.de ([62.245.132.106]:35639 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535AbYFCNyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:54:44 -0400
Date: Tue, 3 Jun 2008 15:54:10 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org, mingo@elte.hu,
       davej@codemonkey.org.uk, andi@firstfloor.org
Subject: Re: aperture_64.c: corner case wrong
In-Reply-To: <20080602153033.2d1672f0.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0806031551330.3235@apollo.tec.linutronix.de>
References: <20080526191730.GA18425@elf.ucw.cz> <20080602153033.2d1672f0.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008, Andrew Morton wrote:
> On Mon, 26 May 2008 21:17:30 +0200
> Pavel Machek <pavel@suse.cz> wrote:
> > diff --git a/arch/x86/kernel/aperture_64.c b/arch/x86/kernel/aperture_64.c
> > index 02f4dba..aa4876a 100644
> > --- a/arch/x86/kernel/aperture_64.c
> > +++ b/arch/x86/kernel/aperture_64.c
> > @@ -344,14 +323,16 @@ out:
> >  	if (gart_fix_e820 && !fix && aper_enabled) {
> >  		if (!e820_all_mapped(aper_base, aper_base + aper_size,
> >  				    E820_RESERVED)) {
> >  			/* reserve it, so we can reuse it in second kernel */
> >  			printk(KERN_INFO "update e820 for GART\n");
> >  			add_memory_region(aper_base, aper_size, E820_RESERVED);
> >  			update_e820();
> >  		}
> > -		return;
> >  	}
> >  
> > +	if (!fix)
> > +		return;
> > +
> >  	/* different nodes have different setting, disable them all at first*/
> >  	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
> >  		int bus;
> > 
> 
> So what happened with this?  Thomas has merged an "x86: aperture_64.c:
> cleanups" from yourself but it appears that half of this bugfix got
> applied somewhere and the below part did not?

Err, no. I seem to have dropped the patch completely. I'm picking it
up again.

> diff -puN arch/x86/kernel/aperture_64.c~aperture_64c-corner-case-wrong arch/x86/kernel/aperture_64.c
> --- a/arch/x86/kernel/aperture_64.c~aperture_64c-corner-case-wrong
> +++ a/arch/x86/kernel/aperture_64.c
> @@ -331,6 +331,9 @@ out:
>  		return;

This should be:
-  		return;

right?

>  	}
>  
> +	if (!fix)
> +		return;
> +
>  	/* different nodes have different setting, disable them all at first*/
>  	for (i = 0; i < ARRAY_SIZE(bus_dev_ranges); i++) {
>  		int bus;
> _

Thanks,
	tglx

