Return-Path: <linux-kernel-owner+w=401wt.eu-S1753159AbZHaIia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159AbZHaIia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 04:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZHaIi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 04:38:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42390 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987AbZHaIi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 04:38:27 -0400
Date: Mon, 31 Aug 2009 10:38:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kmemleak: Ignore the aperture memory hole on x86_64
Message-ID: <20090831083813.GD15619@elte.hu>
References: <20090827165927.27901.97270.stgit@pc1117.cambridge.arm.com> <20090827170258.27901.83613.stgit@pc1117.cambridge.arm.com> <20090829133152.GC24123@elte.hu> <1251556208.5518.5.camel@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251556208.5518.5.camel@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> On Sat, 2009-08-29 at 15:31 +0200, Ingo Molnar wrote:
> > * Catalin Marinas <catalin.marinas@arm.com> wrote:
> > > --- a/arch/x86/kernel/aperture_64.c
> > > +++ b/arch/x86/kernel/aperture_64.c
> > > @@ -20,6 +20,7 @@
> > >  #include <linux/bitops.h>
> > >  #include <linux/ioport.h>
> > >  #include <linux/suspend.h>
> > > +#include <linux/kmemleak.h>
> > >  #include <asm/e820.h>
> > >  #include <asm/io.h>
> > >  #include <asm/iommu.h>
> > > @@ -94,6 +95,11 @@ static u32 __init allocate_aperture(void)
> > >  	 * code for safe
> > >  	 */
> > >  	p = __alloc_bootmem_nopanic(aper_size, aper_size, 512ULL<<20);
> > > +	/*
> > > +	 * Kmemleak should not scan this block as it may not be mapped via the
> > > +	 * kernel direct mapping.
> > > +	 */
> > > +	kmemleak_ignore(p);
> > >  	if (!p || __pa(p)+aper_size > 0xffffffff) {
> > >  		printk(KERN_ERR
> > >  			"Cannot allocate aperture memory hole (%p,%uK)\n",
> > 
> > This sure does not look right for the rare but theoretically 
> > possible !p case, does it?
> 
> All the kmemleak_* callbacks check for (p && !IS_ERR(p)), just to
> simplify the calling site.

Indeed, i see. It's OK this way then.

	Ingo
