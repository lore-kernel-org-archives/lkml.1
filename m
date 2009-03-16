Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbZCPU7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbZCPU7W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 16:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbZCPU7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 16:59:10 -0400
Received: from gw.goop.org ([64.81.55.164]:39254 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494AbZCPU7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 16:59:09 -0400
Message-ID: <49BEBD98.3090905@goop.org>
Date: Mon, 16 Mar 2009 13:59:04 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [crash] Re: Latest brk patchset
References: <49BC413B.5020104@zytor.com> <49BC4CAC.202@goop.org> <49BC4DB6.9070403@zytor.com> <49BCA03D.3020605@goop.org> <20090315203802.GA14625@elte.hu> <49BD70EF.7010204@goop.org> <20090315212854.GA23960@elte.hu> <49BD8F15.4020301@goop.org> <20090316085402.GC1062@elte.hu> <49BE7A84.2030503@goop.org> <49BE84D6.3010006@kernel.org> <49BE9248.6050707@goop.org> <49BE97D5.4010002@zytor.com> <49BEA7BE.6050400@goop.org> <49BEAD27.3050801@kernel.org> <49BEAFEC.7020400@goop.org> <49BEB5FE.7050601@zytor.com>
In-Reply-To: <49BEB5FE.7050601@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jeremy Fitzhardinge wrote:
>> Yinghai Lu wrote:
>>>> -INIT_MAP_SIZE = (PAGE_TABLE_SIZE + ALLOCATOR_SLOP) * PAGE_SIZE_asm
>>>> -RESERVE_BRK(pagetables, INIT_MAP_SIZE)
>>>> +/* Enough space to fit pagetables for the low memory linear map */
>>>> +MAPPING_BEYOND_END = (PAGE_TABLE_SIZE(1 << (32 - PAGE_SHIFT)) * 
>>>> PAGE_SIZE)
>>>>     
>>>
>>> that is for 4g?
>>>   
>>
>> Yes, I suppose it only needs to be 1G.  But it doesn't make much 
>> difference in practice.
>>
>
> A tighter bound would probably be nice, if nothing else because 
> tighter bounds tend to catch more bugs.

Well, its a bit more complex than that; we'd need to make it conditional 
on the user/kernel split, which seems all a bit fiddly.  I guess it 
could be something like:

MAPPING_BEYOND_END = PAGE_TABLE_SIZE((1<<(32-PAGE_SHIFT)) - (PAGE_OFFSET / PAGE_SIZE)) * PAGE_SIZE

    J
