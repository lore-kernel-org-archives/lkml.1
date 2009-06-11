Return-Path: <linux-kernel-owner+w=401wt.eu-S1758846AbZFKHfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbZFKHfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 03:35:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZFKHfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 03:35:37 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58609 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbZFKHfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 03:35:37 -0400
Message-ID: <4A30B422.8080109@cn.fujitsu.com>
Date: Thu, 11 Jun 2009 15:37:06 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, torvalds@linux-foundation.org,
       yinghai@kernel.org
Subject: Re: [PATCH 2/2] sched: use slab in cpupri_init()
References: <Pine.LNX.4.64.0906110846330.2617@melkki.cs.Helsinki.FI>	 <4A309FDD.4030804@cn.fujitsu.com> <1244705062.17483.9.camel@penberg-laptop>
In-Reply-To: <1244705062.17483.9.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> Hi Li!
> 
> On Thu, 2009-06-11 at 14:10 +0800, Li Zefan wrote:
>>> @@ -163,9 +167,7 @@ int __init_refok cpupri_init(struct cpupri *cp, bool bootmem)
>> so the __init_refok tag can be removed, no?
> 
> I am not sure how this is related to my patch but as long as
> init_rootdomain() has it, cpupri_init() should too AFAICT.
> 

cpupri_init() is marked as __init_refok, because it calls
alloc_bootmem_cpumask_var() not because init_rootdomain()
has the tag. Now this patch removes this function call,
so the tag is no long needed.

> 
>>>  
>>>  		spin_lock_init(&vec->lock);
>>>  		vec->count = 0;
>>> -		if (bootmem)
>>> -			alloc_bootmem_cpumask_var(&vec->mask);
>>> -		else if (!zalloc_cpumask_var(&vec->mask, GFP_KERNEL))
>>> +		if (!zalloc_cpumask_var(&vec->mask, gfp))
>>>  			goto cleanup;
>>>  	}
>>>  
> 
