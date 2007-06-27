Return-Path: <linux-kernel-owner+w=401wt.eu-S1759992AbXF0FvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759992AbXF0FvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 01:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbXF0FvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 01:51:09 -0400
Received: from rex.snapgear.com ([203.143.235.140]:36489 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754793AbXF0FvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 01:51:08 -0400
Message-ID: <4681FAC2.2030800@snapgear.com>
Date: Wed, 27 Jun 2007 15:50:58 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: bryan.wu@analog.com
CC: Paul Mundt <lethal@linux-sh.org>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFD]: Unbreak no-mmu mmap
References: <46695F6D.5050600@t-online.de>	 <200706191926.20210.rgetz@blackfin.uclinux.org>	 <46695F6D.5050600@t-online.de>  <20070620030052.GA29161@linux-sh.org> <1182309524.31771.15.camel@roc-desktop>
In-Reply-To: <1182309524.31771.15.camel@roc-desktop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Bryan Wu wrote:
> On Wed, 2007-06-20 at 12:00 +0900, Paul Mundt wrote:
>> On Fri, Jun 08, 2007 at 03:53:49PM +0200, Bernd Schmidt wrote:
>>> diff --git a/mm/nommu.c b/mm/nommu.c
>>> index 2b16b00..7480a95 100644
>>> --- a/mm/nommu.c
>>> +++ b/mm/nommu.c
>> [snip]
>>> +	/*
>>> +	 * Must always set the VM_SPLIT_PAGES flag for single-page allocations,
>>> +	 * to avoid trying to get the order of the compound page later on.
>>> +	 */
>>> +	if (len == PAGE_SIZE)
>>> +		vma->vm_flags |= VM_SPLIT_PAGES;
>>> +	else if (flags & MAP_SPLIT_PAGES
>> And now you've just broken every non-blackfin nommu platform, as you've
>> only defined MAP_SPLIT_PAGES in asm-blackfin/mman.h.
>>
>>> +#ifdef CONFIG_NP2
>>> +	    || len < total_len
>>> +#endif
>> And what is this? It only shows up in the blackfin defconfig. This is not
>> the place to be putting board-specific hacks.
> 
> Yes, it is our own NP2 memory allocator option. I think Bernd will fix
> it.

Theres no reason you can't add the MAP_SPLIT_PAGES define in
all the necessary places too.


>> On Tue, Jun 19, 2007 at 07:26:19PM -0400, Robin Getz wrote:
>>> I'm assuming that since no one had any large objections, that this is OK, and 
>>> we should send to Andrew to live in -mm for awhile?
>>>
>> No real objections to the approach, but it would be nice if these sorts
>> of things were test compiled for at least one platform that isn't yours,
>> so the obviously broken stuff is fixed before it's posted and someone
>> else has to find out about it later.
> 
> Exactly, Could please do some simple test on your SH-NOMMU platform? And
> we are waiting for some feedback from other nommu arch maintainers.
> 
> David and Grep could you please help on this? Maybe Robin got some m68k
> nommu by hand which can be used for testing, I only have Blackfin, -:))

I have compiled the patch on m68knommu (after adding a MAP_SPLIT_PAGES
define). And it seems to work ok with simple testing.

I don't have a problem with the change, though please do add that
MAP_SPLIT_PAGES define in the appropriate mman.h includes. And like Paul
said there is no place for CONFIG_NP2 in it currently. Please take
that out.

Regards
Greg




------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
