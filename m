Return-Path: <linux-kernel-owner+w=401wt.eu-S1755795AbXLRM00@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbXLRM00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 07:26:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbXLRM0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 07:26:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51762 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753731AbXLRM0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 07:26:16 -0500
Date: Tue, 18 Dec 2007 04:24:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Bob Picco <bob.picco@hp.com>, Dave Hansen <haveblue@us.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, Andi Kleen <ak@muc.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, "Keith Mannthey" <kmannth@gmail.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
Message-Id: <20071218042404.df5d459c.akpm@linux-foundation.org>
In-Reply-To: <20071218120300.7565AE3030@solo.franken.de>
References: <20071218120300.7565AE3030@solo.franken.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 13:03:00 +0100 (CET) Thomas Bogendoerfer <tsbogend@alpha.franken.de> wrote:

> When using FLAT_MEMORY and ARCH_PFN_OFFSET is not 0, the kernel
> crashes in memmap_init_zone(). This bug got introduced by
> commit c713216deebd95d2b0ab38fef8bb2361c0180c2d
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
> 
>  mm/page_alloc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index b5a58d4..496f7f3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3427,7 +3427,7 @@ static void __init_refok alloc_node_mem_map(struct pglist_data *pgdat)
>  		mem_map = NODE_DATA(0)->node_mem_map;
>  #ifdef CONFIG_ARCH_POPULATES_NODE_MAP
>  		if (page_to_pfn(mem_map) != pgdat->node_start_pfn)
> -			mem_map -= pgdat->node_start_pfn;
> +			mem_map -= (pgdat->node_start_pfn - ARCH_PFN_OFFSET);
>  #endif /* CONFIG_ARCH_POPULATES_NODE_MAP */
>  	}
>  #endif

hm.  It's rather non-trivial to verify that this will compile OK on all
architectures.

