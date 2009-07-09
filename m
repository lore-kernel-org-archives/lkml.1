Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbZGICNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbZGICNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 22:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbZGICNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 22:13:30 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58489 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903AbZGICNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 22:13:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 3/5] Show kernel stack usage to /proc/meminfo and OOM log
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>,
       David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0907071234070.5124@gentwo.org>
References: <20090705182409.08FC.A69D9226@jp.fujitsu.com> <alpine.DEB.1.10.0907071234070.5124@gentwo.org>
Message-Id: <20090709110952.2389.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  9 Jul 2009 11:13:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, 5 Jul 2009, KOSAKI Motohiro wrote:
> 
> > Subject: [PATCH] Show kernel stack usage to /proc/meminfo and OOM log
> >
> > if the system have a lot of thread, kernel stack consume unignorable large size
> > memory. IOW, it make a lot of unaccountable memory.
> > Tons unaccountable memory bring to harder analyse memory related trouble.
> >
> > Then, kernel stack account is useful.
> 
> The amount of memory allocated to kernel stacks can become significant and
> cause OOM conditions. However, we do not display the amount of memory
> consumed by stacks.'
> 
> Add code to display the amount of memory used for stacks in /proc/meminfo.
> 
> Reviewed-by: <cl@linux-foundation.org>

Thanks.
I'll fix the description.


> (It may be useful to also include the stack sizes in the per zone
> information displayed when an OOM occurs).

following code in this patch mean display per-zone stack size, no?



> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2158,6 +2158,7 @@ void show_free_areas(void)
>  			" mapped:%lukB"
>  			" slab_reclaimable:%lukB"
>  			" slab_unreclaimable:%lukB"
> +			" kernel_stack:%lukB"
>  			" pagetables:%lukB"
>  			" unstable:%lukB"
>  			" bounce:%lukB"
> @@ -2182,6 +2183,8 @@ void show_free_areas(void)
>  			K(zone_page_state(zone, NR_FILE_MAPPED)),
>  			K(zone_page_state(zone, NR_SLAB_RECLAIMABLE)),
>  			K(zone_page_state(zone, NR_SLAB_UNRECLAIMABLE)),
> +			zone_page_state(zone, NR_KERNEL_STACK) *
> +				THREAD_SIZE / 1024,
>  			K(zone_page_state(zone, NR_PAGETABLE)),
>  			K(zone_page_state(zone, NR_UNSTABLE_NFS)),
>  			K(zone_page_state(zone, NR_BOUNCE)),

