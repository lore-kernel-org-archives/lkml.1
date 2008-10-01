Return-Path: <linux-kernel-owner+w=401wt.eu-S1753957AbYJAR4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbYJAR4x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 13:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYJAR4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 13:56:44 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51403 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbYJAR4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 13:56:44 -0400
Message-ID: <48E3B904.7020206@cs.helsinki.fi>
Date: Wed, 01 Oct 2008 20:53:08 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.17 (Macintosh/20080914)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org
Subject: Re: [patch 2/3] cpu alloc: Remove slub fields
References: <20080919203703.312007962@quilx.com> <20080919203724.240858174@quilx.com>
In-Reply-To: <20080919203724.240858174@quilx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

Christoph Lameter wrote:
> @@ -2196,8 +2163,11 @@
>  	if (!init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
>  		goto error;
>  
> -	if (alloc_kmem_cache_cpus(s, gfpflags & ~SLUB_DMA))
> +	s->cpu_slab = CPU_ALLOC(struct kmem_cache_cpu,
> +				(flags & ~SLUB_DMA) | __GFP_ZERO);
> +	if (!s->cpu_slab)
>  		return 1;

This should be s->cpu_slab, no?

> +
>  	free_kmem_cache_nodes(s);
>  error:
>  	if (flags & SLAB_PANIC)

