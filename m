Return-Path: <linux-kernel-owner+w=401wt.eu-S1754468AbZBURNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468AbZBURNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 12:13:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZBURNr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 12:13:47 -0500
Received: from mail-fx0-f167.google.com ([209.85.220.167]:38193 "EHLO
	mail-fx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbZBURNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 12:13:45 -0500
X-Greylist: delayed 94934 seconds by postgrey-1.27 at vger.kernel.org; Sat, 21 Feb 2009 12:13:44 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Cqy7duRjWpIe7jj4sehQVXcqQbA3nbKrA6etAGuPhEkESX2GPcoDJFAykH8P3g7M2X
         7RBQvJYj6JvAOLDRCSvun+9+XKLZLJfB08svqZhBFbVK1pKg18BBYrBRG5lLPhljSi1y
         ZAeOtE38lPE2z87OjN043oZaYICOoJ4vjXw6w=
MIME-Version: 1.0
In-Reply-To: <49A02A61.6060909@cs.helsinki.fi>
References: <1235223364-2097-1-git-send-email-vegard.nossum@gmail.com>
	 <1235223364-2097-4-git-send-email-vegard.nossum@gmail.com>
	 <49A02A61.6060909@cs.helsinki.fi>
Date: Sat, 21 Feb 2009 18:13:42 +0100
Message-ID: <19f34abd0902210913qe0539ebgf74c9b5e0b577786@mail.gmail.com>
Subject: Re: [PATCH] kmemcheck: add hooks for page- and sg-dma-mappings
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/21 Pekka Enberg <penberg@cs.helsinki.fi>:
> Vegard Nossum wrote:
>>
>> This is needed for page allocator support to prevent false positives
>> when accessing pages which are dma-mapped.
>>
>> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
>> ---
>>  arch/x86/include/asm/dma-mapping.h |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/dma-mapping.h
>> b/arch/x86/include/asm/dma-mapping.h
>> index 830bb0e..713a002 100644
>> --- a/arch/x86/include/asm/dma-mapping.h
>> +++ b/arch/x86/include/asm/dma-mapping.h
>> @@ -117,7 +117,12 @@ dma_map_sg(struct device *hwdev, struct scatterlist
>> *sg,
>>  {
>>        struct dma_mapping_ops *ops = get_dma_ops(hwdev);
>>  +       struct scatterlist *s;
>> +       int i;
>> +
>>        BUG_ON(!valid_dma_direction(direction));
>> +       for_each_sg(sg, s, nents, i)
>> +               kmemcheck_mark_initialized(sg_virt(s), s->length);
>>        return ops->map_sg(hwdev, sg, nents, direction);
>>  }
>>  @@ -215,6 +220,7 @@ static inline dma_addr_t dma_map_page(struct device
>> *dev, struct page *page,
>>        struct dma_mapping_ops *ops = get_dma_ops(dev);
>>          BUG_ON(!valid_dma_direction(direction));
>> +       kmemcheck_mark_initialized(page_address(page) + offset, size);
>>        return ops->map_single(dev, page_to_phys(page) + offset,
>>                               size, direction);
>>  }
>
> What's with the new BUG_ON() calls here?
>

What new BUG_ON calls? Do you need glasses?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
