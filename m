Return-Path: <linux-kernel-owner+w=401wt.eu-S1757482AbYFQQ7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482AbYFQQ7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 12:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754775AbYFQQ7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 12:59:33 -0400
Received: from saeurebad.de ([85.214.36.134]:43607 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbYFQQ7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 12:59:32 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Yinghai Lu <yhlu.kernel@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix new alloc_bootmem_core (Re: [PATCH -mm 08/14] bootmem: clean up alloc_bootmem_core)
References: <20080605224940.434439989@saeurebad.de>
	<20080605225720.616014665@saeurebad.de>
	<20080617173021.C1FE.E1E9C6FF@jp.fujitsu.com>
Date: Tue, 17 Jun 2008 18:59:28 +0200
In-Reply-To: <20080617173021.C1FE.E1E9C6FF@jp.fujitsu.com> (Yasunori Goto's
	message of "Tue, 17 Jun 2008 18:34:09 +0900")
Message-ID: <87tzfs80b3.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yasunori Goto <y-goto@jp.fujitsu.com> writes:

> Hi Johannes-san.
>
> I found a bug in this patch.
>
>
>> -	eidx = end_pfn - PFN_DOWN(node_boot_start);
>> +	if (goal && goal < max)
>> +		start = ALIGN(goal, step);
>> +	else
>> +		start = ALIGN(min, step);
>
> Here should check (min < goal) too.
>
> If not, start can becomes smaller than min. and sidx doesn't point
> correct index.
> alloc_bootmem_node() almost allocates pages of other node,
> when node's min address is over MAX_DMA_ADDRESS.

Oh, good catch!

> Bye.
>
> ----
>
> Fix new alloc_bootmem_core() of bootmem-clean-up-alloc_bootmem_core.patch
> in 2.6.26-rc5-mm3.
>
> (min < goal) should be checked too.
>
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> CC: Johannes Weiner <hannes@saeurebad.de>
  Acked-by: Johannes Weiner <hannes@saeurebad.de>

> ---
>  mm/bootmem.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: current/mm/bootmem.c
> ===================================================================
> --- current.orig/mm/bootmem.c	2008-06-17 18:33:31.000000000 +0900
> +++ current/mm/bootmem.c	2008-06-17 18:34:27.000000000 +0900
> @@ -435,7 +435,7 @@
>  
>  	step = max(align >> PAGE_SHIFT, 1UL);
>  
> -	if (goal && goal < max)
> +	if (goal && min < goal && goal < max)
>  		start = ALIGN(goal, step);
>  	else
>  		start = ALIGN(min, step);

	Hannes
