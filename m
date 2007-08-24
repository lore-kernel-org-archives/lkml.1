Return-Path: <linux-kernel-owner+w=401wt.eu-S1762446AbXHXQrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762446AbXHXQrG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 12:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757620AbXHXQqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 12:46:51 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:43870 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761698AbXHXQqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 12:46:49 -0400
Message-ID: <46CF0B70.1050302@linux.vnet.ibm.com>
Date: Fri, 24 Aug 2007 22:16:40 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Yasunori Goto <y-goto@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@skynet.ie>,
       "Luck, Tony" <tony.luck@intel.com>, Jeremy Higdon <jeremy@sgi.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linux-ia64@vger.kernel.org,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org
Subject: Re: [PATCH] Fix find_next_best_node (Re: [BUG] 2.6.23-rc3-mm1 Kernel
 panic - not syncing: DMA: Memory would be corrupted)
References: <617E1C2C70743745A92448908E030B2A023EB020@scsmsx411.amr.corp.intel.com> <20070823142133.9359a1ce.akpm@linux-foundation.org> <20070824153945.3C75.Y-GOTO@jp.fujitsu.com>
In-Reply-To: <20070824153945.3C75.Y-GOTO@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yasunori Goto wrote:
> I found find_next_best_node() was wrong.
> I confirmed boot up by the following patch.
> Mel-san, Kamalesh-san, could you try this?
>
> Bye.
> ---
>
> Fix decision of memoryless node in find_next_best_node().
> This can be cause of SW-IOMMU's allocation failure.
>
> This patch is for 2.6.23-rc3-mm1.
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
>
> ---
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: current/mm/page_alloc.c
> ===================================================================
> --- current.orig/mm/page_alloc.c	2007-08-24 16:03:17.000000000 +0900
> +++ current/mm/page_alloc.c	2007-08-24 16:04:06.000000000 +0900
> @@ -2136,7 +2136,7 @@ static int find_next_best_node(int node,
>  		 * Note:  N_HIGH_MEMORY state not guaranteed to be
>  		 *        populated yet.
>  		 */
> -		if (pgdat->node_present_pages)
> +		if (!pgdat->node_present_pages)
>  			continue;
>
>  		/* Don't want a node to appear more than once */
>
>   
This patch resolves the kernel panic problem.

-
Kamalesh Babulal.
