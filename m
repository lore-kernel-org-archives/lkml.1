Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbZFPEqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbZFPEqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 00:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbZFPEqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 00:46:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:59259 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbZFPEqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 00:46:00 -0400
Date: Tue, 16 Jun 2009 06:46:01 +0200
From: Nick Piggin <npiggin@suse.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, mingo@elte.hu,
       yinghai@kernel.org
Subject: Re: [GIT PULL v2] Early SLAB fixes for 2.6.31
Message-ID: <20090616044601.GB28596@wotan.suse.de>
References: <Pine.LNX.4.64.0906121859420.5963@melkki.cs.Helsinki.FI> <20090615081831.GA5411@osiris.boeblingen.de.ibm.com> <84144f020906150210w7fa29042xc12efb4a087e3d26@mail.gmail.com> <20090615094148.GC1314@wotan.suse.de> <1245059476.12400.7.camel@pasglop> <1245059859.23207.16.camel@penberg-laptop> <20090615102737.GA20461@wotan.suse.de> <1245062727.12400.23.camel@pasglop> <20090615112355.GB6012@wotan.suse.de> <1245101498.12400.37.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245101498.12400.37.camel@pasglop>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 16, 2009 at 07:31:38AM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2009-06-15 at 13:23 +0200, Nick Piggin wrote:
> > > I think the main problem isn't necessarily init code per se, but the
> > > pile of -common- code that can be called both at init time and
> > later.
> > 
> > Just seems bogus argument. Everwhere else that does this (ie.
> > allocations that are called from multiple allocation contexts)
> > passes correct gfp flags down.
> 
> So you say we should create new variants of all these APIs that take gfp
> flags as arguments just because they might be called early during boot :

No, just create the ones that actually are called in early boot.

 
>  - All the vmalloc interfaces (__get_vm_area() and it's 5 or 6 variants)
>  - Allocation of PCI host bridges data structures in the powerpc code
>  - Allocation of interrupt controller domains in the powerpc code
>  - Page table allocations (oops ... can't change that arch specific,
> would have to be a generic change)

No it would not. If an arch (eg s390) does this in early boot, then
it can create its own allocation function which takes a gfp mask, and
define the generic one to just pass it a GFP_KERNEL. generic code does
not call this in early boot of course.


>  - ioremap (which call both __get_vm_area() and page table allocs)
>  - ...
> 
> Are you just insane ? :-)

I think so, but that's besides the point ;)

