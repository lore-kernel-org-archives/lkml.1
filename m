Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbYFGBH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbYFGBH6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756181AbYFGBFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:05:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48638 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755929AbYFGBFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:05:18 -0400
Date: Fri, 6 Jun 2008 18:04:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 10/25] add newly swapped in pages to the inactive
 list
Message-Id: <20080606180456.8139c57d.akpm@linux-foundation.org>
In-Reply-To: <20080606202858.927526002@redhat.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.927526002@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 16:28:48 -0400
Rik van Riel <riel@redhat.com> wrote:

> From: Rik van Riel <riel@redhat.com>
> 
> Swapin_readahead can read in a lot of data that the processes in
> memory never need.  Adding swap cache pages to the inactive list
> prevents them from putting too much pressure on the working set.
> 
> This has the potential to help the programs that are already in
> memory, but it could also be a disadvantage to processes that
> are trying to get swapped in.
> 
> In short, this patch needs testing.
> 

<hopes that the changelog is out of date>

> 
> ---
>  mm/swap_state.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.26-rc2-mm1/mm/swap_state.c
> ===================================================================
> --- linux-2.6.26-rc2-mm1.orig/mm/swap_state.c	2008-05-28 09:40:59.000000000 -0400
> +++ linux-2.6.26-rc2-mm1/mm/swap_state.c	2008-05-28 09:42:26.000000000 -0400
> @@ -302,7 +302,7 @@ struct page *read_swap_cache_async(swp_e
>  			/*
>  			 * Initiate read into locked page and return.
>  			 */
> -			lru_cache_add_active_anon(new_page);
> +			lru_cache_add_anon(new_page);
>  			swap_readpage(NULL, new_page);
>  			return new_page;
>  		}

