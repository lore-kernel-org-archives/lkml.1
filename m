Return-Path: <linux-kernel-owner+w=401wt.eu-S1761296AbZLJRcF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761296AbZLJRcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 12:32:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761285AbZLJRcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 12:32:03 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:51210 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761053AbZLJRcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 12:32:01 -0500
Date: Thu, 10 Dec 2009 11:30:46 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mingo@elte.hu
Subject: Re: [RFC mm][PATCH 1/5] mm counter cleanup
In-Reply-To: <20091210163326.28bb7eb8.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0912101126480.5481@router.home>
References: <20091210163115.463d96a3.kamezawa.hiroyu@jp.fujitsu.com> <20091210163326.28bb7eb8.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Dec 2009, KAMEZAWA Hiroyuki wrote:

> This patch modifies it to
>   - Define them in mm.h as inline functions
>   - Use array instead of macro's name creation. For making easier to add
>     new coutners.

Reviewed-by: Christoph Lameter <cl@linux-foundation.org>

> @@ -454,8 +456,8 @@ static struct mm_struct * mm_init(struct
>  		(current->mm->flags & MMF_INIT_MASK) : default_dump_filter;
>  	mm->core_state = NULL;
>  	mm->nr_ptes = 0;
> -	set_mm_counter(mm, file_rss, 0);
> -	set_mm_counter(mm, anon_rss, 0);
> +	for (i = 0; i < NR_MM_COUNTERS; i++)
> +		set_mm_counter(mm, i, 0);


memset? Or add a clear_mm_counter function? This also occurred earlier in
init_rss_vec().

