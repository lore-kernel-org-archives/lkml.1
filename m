Return-Path: <linux-kernel-owner+w=401wt.eu-S1759759AbZGHKDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759759AbZGHKDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbZGHKDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:03:41 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60342 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339AbZGHKDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:03:40 -0400
Subject: Re: [RFC PATCH 2/3] kmemleak: Add callbacks to the bootmem
 allocator
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1247047355.6595.16.camel@pc1117.cambridge.arm.com>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
	 <20090706105155.16051.59597.stgit@pc1117.cambridge.arm.com>
	 <1246950530.24285.7.camel@penberg-laptop>
	 <20090707165350.GA2782@cmpxchg.org>
	 <1247004586.5710.16.camel@pc1117.cambridge.arm.com>
	 <20090708094643.GA1956@cmpxchg.org>
	 <1247047355.6595.16.camel@pc1117.cambridge.arm.com>
Date: Wed, 08 Jul 2009 13:03:38 +0300
Message-Id: <1247047418.15919.70.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 11:02 +0100, Catalin Marinas wrote:
> On Wed, 2009-07-08 at 11:46 +0200, Johannes Weiner wrote:
> > On Tue, Jul 07, 2009 at 11:09:46PM +0100, Catalin Marinas wrote:
> > 
> > > It seems that alloc_bootmem_core() is central to all the bootmem
> > > allocations. Is it OK to place the kmemleak_alloc hook only in this
> > > function?
> > > 
> > > diff --git a/mm/bootmem.c b/mm/bootmem.c
> > > index 5a649a0..74cbb34 100644
> > > --- a/mm/bootmem.c
> > > +++ b/mm/bootmem.c
> > > @@ -520,6 +520,7 @@ find_block:
> > >  		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
> > >  				start_off);
> > >  		memset(region, 0, size);
> > > +		kmemleak_alloc(region, size, 1, 0);
> > >  		return region;
> > >  	}
> > 
> > Yes, that should work.
> 
> Thanks. May I add your Acked-by line to the final patch?

I guess you mean Johannes but while we're at it:

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

