Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbYKFCbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbYKFCbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 21:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYKFCbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 21:31:10 -0500
Received: from cmpxchg.org ([85.214.51.133]:33738 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbYKFCbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 21:31:09 -0500
Date: Thu, 6 Nov 2008 03:30:59 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Christoph Lameter <cl@linux-foundation.org>, rusty@rustcorp.com.au,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Broken "cpualloc: the allocator" patch
Message-ID: <20081106023059.GA3555@cmpxchg.org>
References: <20081104034237.GA15227@x200.localdomain> <Pine.LNX.4.64.0811040934180.12886@quilx.com> <20081105084254.GA3429@x200.localdomain> <Pine.LNX.4.64.0811051054430.22835@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811051054430.22835@melkki.cs.Helsinki.FI>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 10:57:11AM +0200, Pekka J Enberg wrote:
> Yup, makes sense. PERCPU_MODULE_RESERVE is set to zero if !CONFIG_MODULES. 
> Is there a reason we don't do something like this in bootmem allocator? 
> Hannes?
> 		Pekka
> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index ac5a891..ee6431f 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -435,7 +435,9 @@ static void * __init alloc_bootmem_core(struct bootmem_data *bdata,
>  	unsigned long fallback = 0;
>  	unsigned long min, max, start, sidx, midx, step;
>  
> -	BUG_ON(!size);
> +	if (!size)
> +		return NULL;
> +
>  	BUG_ON(align & (align - 1));
>  	BUG_ON(limit && goal + size > limit);

That comes from the original code, I have no strong opinion on it.

Christoph already fixed it up by making PERCPU_MODULE_RESERVE always
!0 and it looks like all other callsites are happy with the current
behaviour.

	Hannes
