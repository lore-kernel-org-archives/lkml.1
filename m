Return-Path: <linux-kernel-owner+w=401wt.eu-S1751485AbZFRU0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbZFRU0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 16:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZFRUZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 16:25:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752167AbZFRUZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 16:25:58 -0400
Date: Thu, 18 Jun 2009 13:24:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] bootmem.c: Avoid c90 declaration warning
Message-Id: <20090618132410.0b55cd90.akpm@linux-foundation.org>
In-Reply-To: <1245355633.29927.16.camel@Joe-Laptop.home>
References: <1245355633.29927.16.camel@Joe-Laptop.home>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Jun 2009 13:07:13 -0700
Joe Perches <joe@perches.com> wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index 282df0a..09d9c98 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -536,11 +536,13 @@ static void * __init alloc_arch_preferred_bootmem(bootmem_data_t *bdata,
>  		return kzalloc(size, GFP_NOWAIT);
>  
>  #ifdef CONFIG_HAVE_ARCH_BOOTMEM
> +	{
>  	bootmem_data_t *p_bdata;
>  
>  	p_bdata = bootmem_arch_preferred_node(bdata, size, align, goal, limit);
>  	if (p_bdata)
>  		return alloc_bootmem_core(p_bdata, size, align, goal, limit);
> +	}
>  #endif
>  	return NULL;
>  }

Well yes.

We'll be needing some tabs there.

Unrelatedly, I'm struggling a bit with bootmem_arch_preferred_node(). 
It's only defined if CONFIG_X86_32=y && CONFIG_NEED_MULTIPLE_NODES=y,
but it gets called if CONFIG_HAVE_ARCH_BOOTMEM=y.

Is this correct, logical and as simple as we can make it??
