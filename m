Return-Path: <linux-kernel-owner+w=401wt.eu-S1756546AbYBVPwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbYBVPwR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 10:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754019AbYBVPwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 10:52:01 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:44180 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014AbYBVPwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 10:52:00 -0500
Message-ID: <47BEEE84.3070003@linux.vnet.ibm.com>
Date: Fri, 22 Feb 2008 21:17:16 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Nick Piggin <nickpiggin@yahoo.com.au>, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] Document huge memory/cache overhead of memory controller
 in Kconfig
References: <20080220122338.GA4352@basil.nowhere.org> <47BC2275.4060900@linux.vnet.ibm.com> <200802211535.38932.nickpiggin@yahoo.com.au> <47BD06C2.5030602@linux.vnet.ibm.com> <47BD55F6.5030203@firstfloor.org> <47BE527D.2070109@linux.vnet.ibm.com> <47BE9B11.7090809@firstfloor.org> <47BEBCB7.8000607@linux.vnet.ibm.com> <20080222130002.GA22369@one.firstfloor.org>
In-Reply-To: <20080222130002.GA22369@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Fri, Feb 22, 2008 at 05:44:47PM +0530, Balbir Singh wrote:
>> My concern with all the points you mentioned is that this solution might need to
>> change again,
> 
> No why would it need to change again?
> 
>> depending on the factors you've mentioned. vmalloc() is good and
>> straightforward, but it has these dependencies which could call for another
>> rewrite of the code.
> 
> The hotplug change would not need a rewrite of anything, just
> some additional code in the SRAT parser to increase __VMALLOC_RESERVE for
> each hotplug region. It's likely <= 3 additional lines.
> 

Yes, but that is hotplug changes only for i386/x86-64.

>>>>>> if we decided to use vmalloc space, we would need 64
>>>>>> MB of vmalloc'ed memory
>>>>> Yes and if you increase mem_map you need exactly the same space
>>>>> in lowmem too. So increasing the vmalloc reservation for this is
>>>>> equivalent. Just make sure you use highmem backed vmalloc.
>>>>>
>>>> I see two problems with using vmalloc. One, the reservation needs to be done
>>>> across architectures. 
>>> Only on 32bit. Ok hacking it into all 32bit architectures might be
>>> difficult, but I assume it would be ok to rely on the architecture
>>> maintainers for that and only enable it on some selected architectures
>>> using Kconfig for now.
>>>
>> Yes, but that's not such a good idea
> 
> Waiting for the maintainers? Why not? 

It limits the platforms the code can run on. A feature independent of the
architecture should if possible not depend on architecture specific support

> 
> I assume the memory controller would be primarily used on larger
> systems anyways and except for i386 these should be mostly 64bit
> these days anyways.
> 
>>> On 64bit vmalloc should be by default large enough so it could
>>> be enabled for all 64bit architectures.
>>>
>>>> Two, a big vmalloc chunk is not node aware, 
>>> vmalloc_node()
>>>
>> vmalloc_node() would need to work much the same way as mem_map does. I am
> 
> would? It already is implemented and works just fine AFAIK. 
> 
> I don't understand the rest of your point.
> 

Oh! I guess, it's the extra I am. The point I was trying to make was that we
would need to split up the cgroup map the same way as the per node mem_map.

> -Andi


-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
