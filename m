Return-Path: <linux-kernel-owner+w=401wt.eu-S1753145AbYFPK15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbYFPK15 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 06:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751141AbYFPK1u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 06:27:50 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2812 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbYFPK1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 06:27:49 -0400
Date: Mon, 16 Jun 2008 11:26:16 +0100
From: Andy Whitcroft <apw@shadowen.org>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel ML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [Patch 002/005](memory hotplug) align memmap to page size
Message-ID: <20080616102616.GE17016@shadowen.org>
References: <20080407213519.886E.E1E9C6FF@jp.fujitsu.com> <20080407214514.8872.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080407214514.8872.E1E9C6FF@jp.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2008 at 09:46:19PM +0900, Yasunori Goto wrote:
> To free memmap easier, this patch aligns it to page size.
> Bootmem allocater may mix some objects in one pages.
> It's not good for freeing memmap of memory hot-remove.
> 
> 
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> 
> ---
>  mm/sparse.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: current/mm/sparse.c
> ===================================================================
> --- current.orig/mm/sparse.c	2008-04-07 19:18:50.000000000 +0900
> +++ current/mm/sparse.c	2008-04-07 20:08:13.000000000 +0900
> @@ -265,8 +265,8 @@
>  	if (map)
>  		return map;
>  
> -	map = alloc_bootmem_node(NODE_DATA(nid),
> -			sizeof(struct page) * PAGES_PER_SECTION);
> +	map = alloc_bootmem_pages_node(NODE_DATA(nid),
> +		       PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION));
>  	return map;
>  }
>  #endif /* !CONFIG_SPARSEMEM_VMEMMAP */

Ahh ok, we do makes sure the mmap uses up the rest of the space.  That
though is a shame as we cannot slip the usemap in the end of the space
any more (assuming we could).

-apw
