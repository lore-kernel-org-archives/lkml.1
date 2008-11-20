Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbYKTMBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbYKTMBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 07:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754795AbYKTMBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 07:01:05 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53430 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754433AbYKTMBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 07:01:04 -0500
Date: Thu, 20 Nov 2008 13:00:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28-rc5 03/11] kmemleak: Add the memory
	allocation/freeing hooks
Message-ID: <20081120120054.GB20724@elte.hu>
References: <20081120112903.16607.68902.stgit@pc1117.cambridge.arm.com> <20081120113045.16607.7462.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120113045.16607.7462.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Catalin Marinas <catalin.marinas@arm.com> wrote:

> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -112,6 +112,7 @@
>  #include	<linux/rtmutex.h>
>  #include	<linux/reciprocal_div.h>
>  #include	<linux/debugobjects.h>
> +#include	<linux/memleak.h>

please move this line up 5-7 lines so that it auto-merges fine with 
the kmemcheck-next tree.

> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -24,6 +24,7 @@
>  #include <linux/kallsyms.h>
>  #include <linux/memory.h>
>  #include <linux/math64.h>
> +#include <linux/memleak.h>

ditto.

> -	return __vmalloc_area_node(area, gfp_mask, prot, -1,
> -					__builtin_return_address(0));
> +	void *addr = __vmalloc_area_node(area, gfp_mask, prot, -1,
> +					 __builtin_return_address(0));
> +
> +	/* this needs ref_count = 2 since vm_struct also contains a
> +	 * pointer to this address. The guard page is also subtracted
> +	 * from the size */
> +	memleak_alloc(addr, area->size - PAGE_SIZE, 2);

please use the customary comment style:

  /*
   * Comment .....
   * ...... goes here:
   */

Thanks,

        Ingo
