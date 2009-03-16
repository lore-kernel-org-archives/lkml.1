Return-Path: <linux-kernel-owner+w=401wt.eu-S1762149AbZCPSCt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762149AbZCPSCt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:02:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761002AbZCPRzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 13:55:45 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:41402 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761102AbZCPRzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 13:55:44 -0400
Date: Mon, 16 Mar 2009 12:33:44 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@qirst.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 31/35] Optimistically check the first page on the PCP
 free list is suitable
In-Reply-To: <1237196790-7268-32-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0903161232130.32577@qirst.com>
References: <1237196790-7268-1-git-send-email-mel@csn.ul.ie> <1237196790-7268-32-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009, Mel Gorman wrote:

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index bb5bd5e..8568284 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1212,6 +1212,12 @@ again:
>  				if (pcp_page_suit(page, order))
>  					break;
>  		} else {
> +			/* Optimistic before we start a list search */
> +			page = list_entry(list->next, struct page, lru);
> +			if (pcp_page_suit(page, order))
> +				goto found;
> +
> +			/* Do the search */
>  			list_for_each_entry(page, list, lru)
>  				if (pcp_page_suit(page, order))
>  					break;

I am not convinced that this is beneficial. If it would then the compiler
would unroll the loop.


