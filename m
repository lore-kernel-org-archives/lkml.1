Return-Path: <linux-kernel-owner+w=401wt.eu-S933591AbXDBLgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933591AbXDBLgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 07:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933942AbXDBLgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 07:36:50 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:50253 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933591AbXDBLgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 07:36:49 -0400
Date: Mon, 2 Apr 2007 17:06:39 +0530
From: Vivek Goyal <vgoyal@in.ibm.com>
To: thunder7@xs4all.nl
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Helge Hafting <helgehaf@aitel.hist.no>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm3 - no boot, "address not 2M aligned"
Message-ID: <20070402113639.GD13704@in.ibm.com>
Reply-To: vgoyal@in.ibm.com
References: <20070330010559.2a232d9a.akpm@linux-foundation.org> <20070331071220.GA26910@aitel.hist.no> <20070331005303.354411f0.akpm@linux-foundation.org> <20070401052932.GA9894@amd64.of.nowhere> <m1ircghb6w.fsf@ebiederm.dsl.xmission.com> <20070331232957.e1c93f19.akpm@linux-foundation.org> <20070402074159.GA13704@in.ibm.com> <20070402111745.GA9882@amd64.of.nowhere>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402111745.GA9882@amd64.of.nowhere>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2007 at 01:17:45PM +0200, thunder7@xs4all.nl wrote:
[..]
> > +	/*
> > +	 * Make sure kernel is aligned to 2MB address. Catching it at compile
> > +	 * time is better. Change your config file and compile the kernel
> > +	 * for a 2MB aligned address (CONFIG_PHYSICAL_START)
> > +	 */
> > +	BUILD_BUG_ON(ALIGN(CONFIG_PHYSICAL_START, __KERNEL_ALIGN)
> > +			!= CONFIG_PHYSICAL_START);
> > +
> >  	/* clear bss before set_intr_gate with early_idt_handler */
> >  	clear_bss();
> >  
> > diff -puN include/asm-x86_64/page.h~x86_64-check-for-config-physical-start-aligned-2M include/asm-x86_64/page.h
> > --- linux-2.6.21-rc5-mm3-vanilla/include/asm-x86_64/page.h~x86_64-check-for-config-physical-start-aligned-2M	2007-04-02 20:50:55.000000000 +0530
> > +++ linux-2.6.21-rc5-mm3-vanilla-root/include/asm-x86_64/page.h	2007-04-02 20:51:34.000000000 +0530
> > @@ -79,6 +79,7 @@ extern unsigned long phys_base;
> >  #endif /* !__ASSEMBLY__ */
> >  
> >  #define __PHYSICAL_START	CONFIG_PHYSICAL_START
> > +#define __KERNEL_ALIGN		0x200000
> >  #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
> >  #define __START_KERNEL_map	0xffffffff80000000
> >  #define __PAGE_OFFSET           0xffff810000000000
> > _
> 
> I'm only a user, so I'm not uptodate on these addresses and how they
> work. However, how does this solve the problem that running 
> 
> make oldconfig
> 
> on a working 2.6.21-rc3-mm2 .config gives an unbootable 2.6.21-rc5-mm3
> kernel? If I read things correctly, you now get a BUG, but the kernel
> still won't boot. If that is correct, than I, as a user, don't think
> that this is the solution that I feel comfortable with. 
> 

You will get a compile time error and your compilation will not be
through if your physical address is not 2MB aligned. Just give it a try.

Thanks
Vivek
