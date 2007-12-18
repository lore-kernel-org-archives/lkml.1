Return-Path: <linux-kernel-owner+w=401wt.eu-S1756060AbXLRMdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbXLRMdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:33:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755079AbXLRMdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:33:05 -0500
Received: from elvis.franken.de ([193.175.24.41]:41099 "EHLO elvis.franken.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909AbXLRMdC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:33:02 -0500
Date: Tue, 18 Dec 2007 13:31:52 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Bob Picco <bob.picco@hp.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, Andi Kleen <ak@muc.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Keith Mannthey <kmannth@gmail.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
Message-ID: <20071218123152.GA19536@alpha.franken.de>
References: <20071218120300.7565AE3030@solo.franken.de> <20071218042404.df5d459c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071218042404.df5d459c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 04:24:04AM -0800, Andrew Morton wrote:
> On Tue, 18 Dec 2007 13:03:00 +0100 (CET) Thomas Bogendoerfer <tsbogend@alpha.franken.de> wrote:
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -3427,7 +3427,7 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
> >  		mem_map = NODE_DATA(0)->node_mem_map;
> >  #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
> >  		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
> > -			mem_map -= pgdat->node_start_pfn;
> > +			mem_map -= (pgdat->node_start_pfn - ARCH_PFN_OFFSET);
> >  #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
> >  	}
> >  #endif
> 
> hm.  It's rather non-trivial to verify that this will compile OK on all
> architectures.

I grepped through include/asm-* and found:

#if defined(CONFIG_FLATMEM)

#ifndef ARCH_PFN_OFFSET
#define ARCH_PFN_OFFSET         (0UL)
#endif

in include/asm-generic/memory_model.h. So I'm still confident, that
this works on all architectures. It's tested on MIPS.

Thomas.

-- 
Crap can work. Given enough thrust pigs will fly, but it's not necessary a
good idea.                                                [ RFC1925, 2.3 ]
