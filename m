Return-Path: <linux-kernel-owner+w=401wt.eu-S1761168AbYJNA0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761168AbYJNA0c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 20:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbYJNA0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 20:26:21 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:55505 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757066AbYJNA0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 20:26:20 -0400
Date: Tue, 14 Oct 2008 01:25:43 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [mmotm 10 Oct][PATCH 2/2] fix build error of vmscan
In-Reply-To: <20081012223946.181A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0810140120280.29541@blonde.site>
References: <20081012223808.1817.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20081012223946.181A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Oct 2008, KOSAKI Motohiro wrote:
> 
> Patch against: mmotm 10 Oct
> Patch name: vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix-fix.patch
> Applied after: vmscan-fix-pagecache-reclaim-referenced-bit-check-fix-fix.patch
> 
> 
> --------
> vmscan-fix-pagecache-reclaim-referenced-bit-check-fix.patch introduce following build error.
> 
>   CC      mm/vmscan.o
> mm/vmscan.c: In function 'shrink_active_list':
> mm/vmscan.c:1248: error: too few arguments to function 'page_referenced'
> make[1]: *** [mm/vmscan.o] Error 1
> make: *** [mm] Error 2
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: Rik van Riel <riel@redhat.com>
> CC: Andrew Morton <akpm@linux-foundation.org>

Excellent though it is, I'd prefer Andrew to ignore your patch:
because it falls within an unbisectable extent of the mmotm series,
for which I've now prepared a metapatch including this fix,
following in a minute or two.

Thanks,
Hugh

> 
> ---
>  mm/vmscan.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> Index: b/mm/vmscan.c
> ===================================================================
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1245,7 +1245,8 @@ static void shrink_active_list(unsigned 
>  		}
>  
>  		/* page_referenced clears PageReferenced */
> -		if (page_mapping_inuse(page) && page_referenced(page))
> +		if (page_mapping_inuse(page) &&
> +		    page_referenced(page, 0, sc->mem_cgroup))
>  			pgmoved++;
>  
>  		list_add(&page->lru, &l_inactive);
