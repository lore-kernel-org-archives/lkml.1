Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbZCYNFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbZCYNFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 09:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZCYNEw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 09:04:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:53512 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbZCYNEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 09:04:50 -0400
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, ian.campbell@citrix.com, jeremy@goop.org
Message-Id: <65B9DB8E-65E6-48AA-BC48-CC2083AD7F18@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090325124503.GD30755@elte.hu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 2/5] swiotlb: fix compile warning
Date: Wed, 25 Mar 2009 08:03:11 -0500
References: <1237930126-6741-3-git-send-email-beckyb@kernel.crashing.org> <20090325114023S.fujita.tomonori@lab.ntt.co.jp> <D375125B-E20E-47D9-87F5-EB9CBE927293@kernel.crashing.org> <20090325125227C.fujita.tomonori@lab.ntt.co.jp> <20090325124503.GD30755@elte.hu>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mar 25, 2009, at 7:45 AM, Ingo Molnar wrote:

>
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>
>> On Tue, 24 Mar 2009 22:42:33 -0500
>> Becky Bruce <beckyb@kernel.crashing.org> wrote:
>>
>>>
>>> On Mar 24, 2009, at 9:58 PM, FUJITA Tomonori wrote:
>>>
>>>> On Tue, 24 Mar 2009 16:28:43 -0500
>>>> Becky Bruce <beckyb@kernel.crashing.org> wrote:
>>>>
>>>>> Squash a build warning seen on 32-bit powerpc caused by calling  
>>>>> min()
>>>>> with 2 different types.  Cast the first arg to size_t, which is  
>>>>> the
>>>>> type of the second, and should be portable across architectures.
>>>>>
>>>>> Signed-off-by: Becky Bruce <beckyb@kernel.crashing.org>
>>>>> ---
>>>>> lib/swiotlb.c |    2 +-
>>>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
>>>>> index f59cf30..62f5f75 100644
>>>>> --- a/lib/swiotlb.c
>>>>> +++ b/lib/swiotlb.c
>>>>> @@ -341,7 +341,7 @@ static void swiotlb_bounce(phys_addr_t phys,
>>>>> char *dma_addr, size_t size,
>>>>> 		unsigned long flags;
>>>>>
>>>>> 		while (size) {
>>>>> -			sz = min(PAGE_SIZE - offset, size);
>>>>> +			sz = min((size_t)(PAGE_SIZE - offset), size);
>>>>>
>>>>> 			local_irq_save(flags);
>>>>> 			buffer = kmap_atomic(pfn_to_page(pfn),
>>>>
>>>> ?
>>>>
>>>> diff --git a/lib/swiotlb.c b/lib/swiotlb.c
>>>> index f59cf30..fa62498 100644
>>>> --- a/lib/swiotlb.c
>>>> +++ b/lib/swiotlb.c
>>>> @@ -341,7 +341,7 @@ static void swiotlb_bounce(phys_addr_t phys,
>>>> char *dma_addr, size_t size,
>>>> 		unsigned long flags;
>>>>
>>>> 		while (size) {
>>>> -			sz = min(PAGE_SIZE - offset, size);
>>>> +			sz = min_t(size_t, PAGE_SIZE - offset, size);
>>>>
>>>> 			local_irq_save(flags);
>>>> 			buffer = kmap_atomic(pfn_to_page(pfn),
>>>
>>> OK, we're clearly pointed at different trees here, and it looks like
>>> I'm behind - this patch is based on Ingo's master.  Which tree has
>>> this change?
>>
>> I also use tip/master. I think that we are on the same page. No
>> tree has this change. I just send it because I'm not sure why you
>> don't use min_t().
>
> yes, min_t() is safer and cleaner than min()+cast.

Ahh, then, that's just an oversight on my part, and I'll fix it.  I'll  
send out a respun set of patches as soon as I'm out of today's endless  
set of meetings.

Thanks,
Becky
