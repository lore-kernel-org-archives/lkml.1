Return-Path: <linux-kernel-owner+w=401wt.eu-S1759502AbZGHKDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759502AbZGHKDI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 06:03:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757636AbZGHKC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 06:02:56 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:46612 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757339AbZGHKCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 06:02:55 -0400
Subject: Re: [RFC PATCH 2/3] kmemleak: Add callbacks to the bootmem
	allocator
From: Catalin Marinas <catalin.marinas@arm.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090708094643.GA1956@cmpxchg.org>
References: <20090706104654.16051.44029.stgit@pc1117.cambridge.arm.com>
	 <20090706105155.16051.59597.stgit@pc1117.cambridge.arm.com>
	 <1246950530.24285.7.camel@penberg-laptop>
	 <20090707165350.GA2782@cmpxchg.org>
	 <1247004586.5710.16.camel@pc1117.cambridge.arm.com>
	 <20090708094643.GA1956@cmpxchg.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 08 Jul 2009 11:02:35 +0100
Message-Id: <1247047355.6595.16.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2009 10:02:36.0341 (UTC) FILETIME=[382C0E50:01C9FFB3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 11:46 +0200, Johannes Weiner wrote:
> On Tue, Jul 07, 2009 at 11:09:46PM +0100, Catalin Marinas wrote:
> 
> > It seems that alloc_bootmem_core() is central to all the bootmem
> > allocations. Is it OK to place the kmemleak_alloc hook only in this
> > function?
> > 
> > diff --git a/mm/bootmem.c b/mm/bootmem.c
> > index 5a649a0..74cbb34 100644
> > --- a/mm/bootmem.c
> > +++ b/mm/bootmem.c
> > @@ -520,6 +520,7 @@ find_block:
> >  		region = phys_to_virt(PFN_PHYS(bdata->node_min_pfn) +
> >  				start_off);
> >  		memset(region, 0, size);
> > +		kmemleak_alloc(region, size, 1, 0);
> >  		return region;
> >  	}
> 
> Yes, that should work.

Thanks. May I add your Acked-by line to the final patch?

-- 
Catalin

