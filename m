Return-Path: <linux-kernel-owner+w=401wt.eu-S1754058AbYJBQWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbYJBQWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYJBQWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:22:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155AbYJBQWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:22:31 -0400
Message-ID: <48E4F4EE.90608@linux-foundation.org>
Date: Thu, 02 Oct 2008 11:21:02 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org
Subject: Re: [patch 2/3] cpu alloc: Remove slub fields
References: <20080919203703.312007962@quilx.com> <20080919203724.240858174@quilx.com> <48E3B904.7020206@cs.helsinki.fi>
In-Reply-To: <48E3B904.7020206@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Christoph,
> 
> Christoph Lameter wrote:
>> @@ -2196,8 +2163,11 @@
>>      if (!init_kmem_cache_nodes(s, gfpflags & ~SLUB_DMA))
>>          goto error;
>>  
>> -    if (alloc_kmem_cache_cpus(s, gfpflags & ~SLUB_DMA))
>> +    s->cpu_slab = CPU_ALLOC(struct kmem_cache_cpu,
>> +                (flags & ~SLUB_DMA) | __GFP_ZERO);
>> +    if (!s->cpu_slab)
>>          return 1;
> 
> This should be s->cpu_slab, no?

Correct. Newer rev that will be based on cpu_alloc V6 will have that.
