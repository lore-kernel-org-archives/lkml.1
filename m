Return-Path: <linux-kernel-owner+w=401wt.eu-S1754532AbZGELGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbZGELGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 07:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZGELF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 07:05:56 -0400
Received: from mga14.intel.com ([143.182.124.37]:46404 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbZGELF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 07:05:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,351,1243839600"; 
   d="scan'208";a="161634739"
Date: Sun, 5 Jul 2009 19:05:48 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 1/5] add per-zone statistics to show_free_areas()
Message-ID: <20090705110548.GA1898@localhost>
References: <20090705181400.08F1.A69D9226@jp.fujitsu.com> <20090705182259.08F6.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705182259.08F6.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 05:23:35PM +0800, KOSAKI Motohiro wrote:
> Subject: [PATCH] add per-zone statistics to show_free_areas()
> 
> Currently, show_free_area() mainly display system memory usage. but it
> doesn't display per-zone memory usage information.
> 
> However, if DMA zone OOM occur, Administrator definitely need to know
> per-zone memory usage information.

DMA zone is normally lowmem-reserved. But I think the numbers still
make sense for DMA32.

Acked-by: Wu Fengguang <fengguang.wu@intel.com>

> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/page_alloc.c |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2151,6 +2151,16 @@ void show_free_areas(void)
>  			" inactive_file:%lukB"
>  			" unevictable:%lukB"
>  			" present:%lukB"
> +			" mlocked:%lukB"
> +			" dirty:%lukB"
> +			" writeback:%lukB"
> +			" mapped:%lukB"
> +			" slab_reclaimable:%lukB"
> +			" slab_unreclaimable:%lukB"
> +			" pagetables:%lukB"
> +			" unstable:%lukB"
> +			" bounce:%lukB"
> +			" writeback_tmp:%lukB"
>  			" pages_scanned:%lu"
>  			" all_unreclaimable? %s"
>  			"\n",
> @@ -2165,6 +2175,16 @@ void show_free_areas(void)
>  			K(zone_page_state(zone, NR_INACTIVE_FILE)),
>  			K(zone_page_state(zone, NR_UNEVICTABLE)),
>  			K(zone->present_pages),
> +			K(zone_page_state(zone, NR_MLOCK)),
> +			K(zone_page_state(zone, NR_FILE_DIRTY)),
> +			K(zone_page_state(zone, NR_WRITEBACK)),
> +			K(zone_page_state(zone, NR_FILE_MAPPED)),
> +			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
> +			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
> +			K(zone_page_state(zone, NR_PAGETABLE)),
> +			K(zone_page_state(zone, NR_UNSTABLE_NFS)),
> +			K(zone_page_state(zone, NR_BOUNCE)),
> +			K(zone_page_state(zone, NR_WRITEBACK_TEMP)),
>  			zone->pages_scanned,
>  			(zone_is_all_unreclaimable(zone) ? "yes" : "no")
>  			);
> 
