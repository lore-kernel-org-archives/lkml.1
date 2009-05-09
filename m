Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZEIJYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZEIJYT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 05:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbZEIJYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 05:24:07 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:38099 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbZEIJYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 05:24:06 -0400
Message-ID: <4A054AB5.1000601@cs.helsinki.fi>
Date: Sat, 09 May 2009 12:19:49 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>, gorcunov@openvz.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, cl@linux-foundation.org,
       riel@redhat.com, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [PATCH 1/2] mm: Introduce GFP_PANIC for early-boot allocations
References: <1241795428.28600.60.camel@penberg-laptop> <20090508135632.9c041339.akpm@linux-foundation.org> <4A054156.60501@cs.helsinki.fi> <20090509091911.GA13784@elte.hu>
In-Reply-To: <20090509091911.GA13784@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> 
>> Hi Andrew,
>>
>> Andrew Morton wrote:
>>> On Fri, 08 May 2009 18:10:28 +0300
>>> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>>
>>>> +#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY)
>>> urgh, you have to be kidding me.  This significantly worsens complexity
>>> and risk in core MM and it's just yuk.
>>>
>>> I think we can justify pulling such dopey party tricks to save 
>>> pageframe space, or bits in page.flags and such.  But just to 
>>> save a scrap of memory which would have been released during boot 
>>> anwyay?  Don't think so.
>> No, I wasn't kidding and I don't agree that it "significantly 
>> worsens complexity". The point is not to save memory but to 
>> clearly annotate those special call-sites that really don't need 
>> to check for out-of-memory.
> 
> Frankly, i cannot believe that so many smart people dont see the 
> simple, universal, un-arguable truism in the following statement:
> 
>  it is shorter, tidier, more maintainable, more reviewable to write:
> 
> 	ptr = kmalloc(GFP_BOOT, size);
> 
>  than to write:
> 
> 	ptr = kmalloc(GFP_KERNEL, size);
> 	BUG_ON(!ptr);

Hey, that's a much better name! I guess we don't need to support 
GFP_ATOMIC? I'll repost the series with Peter's system_state != BOOTING 
warning. Lets see if that makes the patch more palatable to Andrew.

			Pekka
