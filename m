Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbYAaPgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbYAaPgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 10:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756717AbYAaPfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 10:35:53 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:60245 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878AbYAaPfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:35:52 -0500
Date: Thu, 31 Jan 2008 17:36:29 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-arch@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: asm-generic/tlb.h and check_pgt_cache()
Message-ID: <20080131153629.GB29209@cs181133002.pp.htv.fi>
References: <20080131125425.7e91b54d@dhcp-252-066.norway.atmel.com> <20080131130328.GA29209@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080131130328.GA29209@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 03:03:28PM +0200, Adrian Bunk wrote:
> On Thu, Jan 31, 2008 at 12:54:25PM +0100, Haavard Skinnemoen wrote:
> > Hi,
> > 
> > Commit a5a19c63f4e55e32dc0bc3d936d7f94793d8b380 from x86.git seems to
> > have broken several architectures, including alpha (fixed by
> > c18d1250c7425dddd2633ce4eaf03d5015e68a0f) and avr32 (not fixed yet).
> > 
> > The problem seems to be that asm-generic/tlb.h references
> > check_pgt_cache(), which is defined in asm/pgalloc.h on most
> > architectures, so removing that include seems like the wrong thing to
> > do. x86, however, defines it in asm/pgtable.h which is apparently
> > included indirectly through other headers.
> > 
> > One way to fix this would be to move the check_pgt_cache() definition
> > over to asm/pgtable.h, but I suspect this would complicate things a lot
> > on architectures that use quicklists since they need the QUICK_*
> > definitions from pgalloc.h in order to implement check_pgt_cache. I
> > have patches that make avr32 use quicklists as well, so I'm a bit
> > hesitant to do this.
> > 
> > Another way to fix it would be to include asm/pgalloc.h elsewhere, e.g.
> > from asm/tlb.h right before including asm-generic/tlb.h. Or perhaps we
> > should move check_pgt_cache() into asm/tlb.h on all architectures and
> > include asm/pgalloc.h as needed?
> > 
> > I don't know how many architectures are currently broken -- if it's
> > only avr32, I can probably come up with a way to fix it on my own. But
> > if there are others, I thought it might be a good idea to coordinate
> > things.
> 
> At least blackfin and m32r suffer from the same compile breakage.

And it seems also uml.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

