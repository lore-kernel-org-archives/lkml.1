Return-Path: <linux-kernel-owner+w=401wt.eu-S1755921AbZENQ5D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbZENQ5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 12:57:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZENQ4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 12:56:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42244 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbZENQ4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 12:56:51 -0400
Date: Thu, 14 May 2009 09:54:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mel@csn.ul.ie, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       cl@linux-foundation.org, suresh.b.siddha@intel.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       rusty@rustcorp.com.au, steiner@sgi.com, rientjes@google.com
Subject: Re: [PATCH 5/5] mm: clear N_HIGH_MEMORY map before se set it again
 -v2
Message-Id: <20090514095414.ba8356e5.akpm@linux-foundation.org>
In-Reply-To: <4A0C4A2A.6080009@kernel.org>
References: <4A05269D.8000701@kernel.org>
	<20090512111623.GG25923@csn.ul.ie>
	<4A0A64FB.4080504@kernel.org>
	<20090513145950.GB28097@csn.ul.ie>
	<4A0C4910.7090508@kernel.org>
	<4A0C4A2A.6080009@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 09:43:22 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> incase some system strange SRAT table. some kind of small range.
> or with mem= etc
> 

That description is very hard to understand.  Please provide more details.

> 
> Signed-off-by: Yinghai Lu <Yinghai@kernel.org>
> Tested-by: Jack Steiner <steiner@sgi.com>

What reason did Jack have to test this?  Perhaps he hit some bug? 
If so, please fully describe that bug in the changelog.


> Index: linux-2.6/mm/page_alloc.c
> ===================================================================
> --- linux-2.6.orig/mm/page_alloc.c
> +++ linux-2.6/mm/page_alloc.c
> @@ -4041,6 +4047,11 @@ void __init free_area_init_nodes(unsigne
>  						early_node_map[i].start_pfn,
>  						early_node_map[i].end_pfn);
>  
> +	/*
> +	 * find_zone_movable_pfns_for_nodes/early_calculate_totalpages init
> +	 * that node_mask, clear it at first
> +	 */
> +	nodes_clear(node_states[N_HIGH_MEMORY]);
>  	/* Initialise every node */
>  	mminit_verify_pageflags_layout();
>  	setup_nr_node_ids();

If CONFIG_HIGHMEM=n, this will clear the N_NORMAL_MEMORY entry in
node_states[].  Why is this correct and desirable?

