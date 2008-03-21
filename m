Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbYCUHzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbYCUHzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 03:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbYCUHzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 03:55:12 -0400
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:38029
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752369AbYCUHzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 03:55:11 -0400
Message-ID: <47E369D8.2010904@cosmosbay.com>
Date: Fri, 21 Mar 2008 08:55:04 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Christoph Lameter <clameter@sgi.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [03/14] vmallocinfo: Support display of vcompound for a virtual
 compound page
References: <20080321061703.921169367@sgi.com> <20080321061724.795229401@sgi.com>
In-Reply-To: <20080321061724.795229401@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter a écrit :
> Add another flag to the vmalloc subsystem to mark virtual compound pages.
> 
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
> 
> ---
>  include/linux/vmalloc.h |    1 +
>  mm/vmalloc.c            |    3 +++
>  2 files changed, 4 insertions(+)
> 
> Index: linux-2.6.25-rc5-mm1/include/linux/vmalloc.h
> ===================================================================
> --- linux-2.6.25-rc5-mm1.orig/include/linux/vmalloc.h	2008-03-19 18:17:42.093443900 -0700
> +++ linux-2.6.25-rc5-mm1/include/linux/vmalloc.h	2008-03-19 18:27:20.150422445 -0700
> @@ -12,6 +12,7 @@ struct vm_area_struct;
>  #define VM_MAP		0x00000004	/* vmap()ed pages */
>  #define VM_USERMAP	0x00000008	/* suitable for remap_vmalloc_range */
>  #define VM_VPAGES	0x00000010	/* buffer for pages was vmalloc'ed */
> +#define VM_VCOMPOUND	0x00000020	/* Page allocator fallback */
>  /* bits [20..32] reserved for arch specific ioremap internals */
>  
>  /*
> Index: linux-2.6.25-rc5-mm1/mm/vmalloc.c
> ===================================================================
> --- linux-2.6.25-rc5-mm1.orig/mm/vmalloc.c	2008-03-19 18:18:02.689633934 -0700
> +++ linux-2.6.25-rc5-mm1/mm/vmalloc.c	2008-03-19 18:27:20.150422445 -0700
> @@ -974,6 +974,9 @@ static int s_show(struct seq_file *m, vo
>  	if (v->flags & VM_VPAGES)
>  		seq_printf(m, " vpages");
>  
> +	if (v->flags & VM_VCOMPOUND)
> +		seq_printf(m, " vcompound");
> +
>  	seq_putc(m, '\n');
>  	return 0;
>  }
> 

I would love to see NUMA information as well on vmallocinfo, but have 
currently no available time to prepare a patch.

Counters with numbers of pages per node would be great.

(like in /proc/pid/numa_maps)

N0=2 N1=2 N2=2 N3=2


This way we could check hashdist is working or not, since it depends on 
various numa policies :)

