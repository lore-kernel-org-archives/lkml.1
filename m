Return-Path: <linux-kernel-owner+w=401wt.eu-S1754613AbYL0O0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbYL0O0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 09:26:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbYL0O0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 09:26:17 -0500
Received: from cmpxchg.org ([85.214.51.133]:36012 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951AbYL0O0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 09:26:17 -0500
Date: Sat, 27 Dec 2008 15:25:54 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Adam Lackorzynski <adam@os.inf.tu-dresden.de>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] 2.6.28, vmalloc.c, vmap_page_range
Message-ID: <20081227142554.GA2505@cmpxchg.org>
References: <20081225210235.GC5431@os.inf.tu-dresden.de> <20081226163946.6d38e919.akpm@linux-foundation.org> <20081227033610.GA1750@cmpxchg.org> <20081227090221.GD16077@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081227090221.GD16077@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 27, 2008 at 10:02:21AM +0100, Ingo Molnar wrote:
> > > --- a/mm/vmalloc.c~vmallocc-fix-flushing-in-vmap_page_range
> > > +++ a/mm/vmalloc.c
> > > @@ -151,11 +151,12 @@ static int vmap_pud_range(pgd_t *pgd, un
> > >   *
> > >   * Ie. pte at addr+N*PAGE_SIZE shall point to pfn corresponding to pages[N]
> > >   */
> > > -static int vmap_page_range(unsigned long addr, unsigned long end,
> > > +static int vmap_page_range(unsigned long start_addr, unsigned long end,
> > >  				pgprot_t prot, struct page **pages)
> > >  {
> > >  	pgd_t *pgd;
> > >  	unsigned long next;
> > > +	unsigned long addr = start_addr;
> > 
> > Ugh, start_addr is an awful name.  How about start?  I know it doesn't 
> > hold the same amount of information but it's a local API, the 
> > pgd_offset_k() should make the unit unambiguous, it goes better with the 
> > end parameter and it's unique enough for this short function.
> 
> i'd like to observe that there's 449 start_addr instances in the kernel 
> source, 17 of them in mm/*.c alone. So if it's 'ugly' (it isnt to me), 
> this patch is not the place to start worrying about it. If you feel 
> strongly about it then prepare a cleanup patch that eradicates them all, 
> put your justification for why it's bad into the changelog and post it to 
> lkml.

It would surely not justify such a big change.

And at least in mm/* you have them paired with `end_addr' if they
denote range start and end.

	Hannes
