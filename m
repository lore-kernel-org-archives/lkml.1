Return-Path: <linux-kernel-owner+w=401wt.eu-S1756098AbYAITTQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098AbYAITTQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 14:19:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbYAITTF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 14:19:05 -0500
Received: from relay2.sgi.com ([192.48.171.30]:43460 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753957AbYAITTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 14:19:04 -0500
Date: Wed, 9 Jan 2008 11:19:01 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: cleanup setup_node_zones called by paging_init
 v2
In-Reply-To: <200801091030.40545.yinghai.lu@sun.com>
Message-ID: <Pine.LNX.4.64.0801091117430.11317@schroedinger.engr.sgi.com>
References: <200801081934.33964.yinghai.lu@sun.com>
 <Pine.LNX.4.64.0801090947570.10163@schroedinger.engr.sgi.com>
 <200801091030.40545.yinghai.lu@sun.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jan 2008, Yinghai Lu wrote:

> +#ifdef CONFIG_FLAT_NODE_MEM_MAP
>  /* Initialize final allocator for a zone */
> -void __init setup_node_zones(int nodeid)
> +static void __init setup_node_zones(int nodeid)
>  { 
>  	unsigned long start_pfn, end_pfn, memmapsize, limit;
>  
> @@ -244,14 +245,14 @@ void __init setup_node_zones(int nodeid)
>  	   memory. */
>  	memmapsize = sizeof(struct page) * (end_pfn-start_pfn);
>  	limit = end_pfn << PAGE_SHIFT;
> -#ifdef CONFIG_FLAT_NODE_MEM_MAP
> +
>  	NODE_DATA(nodeid)->node_mem_map = 
>  		__alloc_bootmem_core(NODE_DATA(nodeid)->bdata, 
>  				memmapsize, SMP_CACHE_BYTES, 
>  				round_down(limit - memmapsize, PAGE_SIZE), 
>  				limit);
> -#endif
>  } 

Here you could do an 

#else

<empty def of setup_node_zones>

which would avoid the additional #ifdef later.

Also move the for_each statement into that function. 

The current version will have an unused variable i if 
CONFIG_FLAG_NODE_MEM_MAP is not set.
