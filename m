Return-Path: <linux-kernel-owner+w=401wt.eu-S1754104Ab0ADVCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab0ADVCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 16:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754084Ab0ADVCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 16:02:30 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21540 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0ADVC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 16:02:29 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=GiRsjKaZqP8Ak3qDcH2jPiNb9LgRtux1MwK+H04zk1DEmiaUp5H13dPgfjNFSngBS
	yUTqOVJQZQmBtL5jJjjMw==
Date: Mon, 4 Jan 2010 13:02:17 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
       Kazuhisa Ichikawa <ki@epsilou.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: fix the range check for backward
 merging
In-Reply-To: <20100103120435.GA3576@epsilou.com>
Message-ID: <alpine.DEB.2.00.1001041302130.20593@chino.kir.corp.google.com>
References: <20100103120435.GA3576@epsilou.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jan 2010, Kazuhisa Ichikawa wrote:

> From: Kazuhisa Ichikawa <ki@epsilou.com>
> 
> The current check for 'backward merging' within add_active_range()
> does not seem correct.  start_pfn must be compared against
> early_node_map[i].start_pfn (and NOT against .end_pfn) to find out
> whether the new region is backward-mergeable with the existing range.
> 
> Signed-off-by: Kazuhisa Ichikawa <ki@epsilou.com>
> ---
>  (This patch applies to linux-2.6.33-rc2)
> 
> --- a/mm/page_alloc.c	2009-12-25 06:09:41.000000000 +0900
> +++ b/mm/page_alloc.c	2010-01-03 19:20:36.000000000 +0900
> @@ -3998,7 +3998,7 @@ void __init add_active_range(unsigned in
>  		}
>  
>  		/* Merge backward if suitable */
> -		if (start_pfn < early_node_map[i].end_pfn &&
> +		if (start_pfn < early_node_map[i].start_pfn &&
>  				end_pfn >= early_node_map[i].start_pfn) {
>  			early_node_map[i].start_pfn = start_pfn;
>  			return;

Acked-by: David Rientjes <rientjes@google.com>
