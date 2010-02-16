Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab0BPUp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 15:45:56 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45805 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933186Ab0BPUpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 15:45:55 -0500
Message-ID: <4B7B03E8.40903@cs.helsinki.fi>
Date: Tue, 16 Feb 2010 22:45:28 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, haicheng.li@intel.com
Subject: Re: [PATCH] [3/4] SLAB: Set up the l3 lists for the memory of freshly
 added memory v2
References: <20100211953.850854588@firstfloor.org> <20100211205403.05A8EB1978@basil.firstfloor.org> <alpine.DEB.2.00.1002111344130.8809@chino.kir.corp.google.com> <20100215060655.GH5723@laptop> <alpine.DEB.2.00.1002151344020.26927@chino.kir.corp.google.com> <20100216140447.GN5723@laptop>
In-Reply-To: <20100216140447.GN5723@laptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Mon, Feb 15, 2010 at 01:47:29PM -0800, David Rientjes wrote:
>> On Mon, 15 Feb 2010, Nick Piggin wrote:
>>
>>>>> @@ -1577,6 +1595,8 @@ void __init kmem_cache_init_late(void)
>>>>>  	 */
>>>>>  	register_cpu_notifier(&cpucache_notifier);
>>>>>  
>>>>> +	hotplug_memory_notifier(slab_memory_callback, SLAB_CALLBACK_PRI);
>>>>> +
>>>> Only needed for CONFIG_NUMA, but there's no side-effects for UMA kernels 
>>>> since status_change_nid will always be -1.
>>> Compiler doesn't know that, though.
>>>
>> Right, setting up a memory hotplug callback for UMA kernels here isn't 
>> necessary although slab_node_prepare() would have to be defined 
>> unconditionally.  I made this suggestion in my review of the patchset's 
>> initial version but it was left unchanged, so I'd rather see it included 
>> than otherwise stall out.  This could always be enclosed in
>> #ifdef CONFIG_NUMA later just like the callback in slub does.
> 
> It's not such a big burden to annotate critical core code with such
> things. Otherwise someone else ends up eventually doing it.

Yes, please.
