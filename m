Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbYDOGQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbYDOGQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 02:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYDOGQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 02:16:23 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:55834 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750896AbYDOGQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 02:16:22 -0400
Message-ID: <48044787.9040909@bull.net>
Date: Tue, 15 Apr 2008 08:13:27 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Peter Zijlstra <peterz@infradead.org>, efault@gmx.de,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
References: <20080411161702.460410000@bull.net>	 <1207931235.7157.0.camel@twins>  <4802E93E.4090205@bull.net> <1208157359.7427.25.camel@twins> <480316D3.7070901@bull.net> <4803A85F.2080603@colorfullife.com>
In-Reply-To: <4803A85F.2080603@colorfullife.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> Nadia Derbey wrote:
> 
>>
>> Well, 1 interface changes, 1 is added and another one went away:
>>
>> 1) for the preload part (it becomes like the radix-tree preload part):
>>
>> int idr_pre_get(struct idr *, gfp_t);
>> would become
>> int idr_pre_get(gfp_t);
>>
> Btw, that's one point I didn't understand about the idr code:
> Is it interrupt-safe? It uses spin_lock_irqsave and gfp_t, this implies 
> that it could be called from all contexts.
> 
> But the prealloc made me a bit nervous: does it handle idr_pre_get(); 
> interrupt with another idr_pre_get(), add, pre_get_end, interrupt ends, 
> ... correctly?

I don't know if I'm answering your question, but after allocating, 
idr_pre_get() calls free_layer() which is the routine that inserts the 
allocated memory into the idr free list. And free_layer() calls 
spin_lock_ir_save() to protect this free list modification. So it should 
be safe?

> 
> If it's only intended to be called from process context I would remove 
> the _irqsave and perhaps add an assert(!in_interrupt())

Well, I guess it might be called from any context, since the 
kmem_cache_alloc is called with the gfp_mask routine's parameter?


Regards,
Nadia
