Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947Ab0ALJpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947Ab0ALJpQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 04:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753863Ab0ALJpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 04:45:15 -0500
Received: from outbound-mail04.westnet.com.au ([203.10.1.245]:58268 "EHLO
	outbound-mail04.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751456Ab0ALJpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 04:45:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqMBAGrTS0t8lZfV/2dsb2JhbAAI1gYChC4E
X-IronPort-AV: E=Sophos;i="4.49,261,1262534400"; 
   d="scan'208";a="14244358"
Message-ID: <4B4C449E.5020207@snapgear.com>
Date: Tue, 12 Jan 2010 19:45:02 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: gerg@uclinux.org, linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: change definitions of __pa() and __va()
References: <201001120039.o0C0dboQ031390@goober.internal.moreton.com.au> <alpine.LFD.2.00.1001111652500.17145@localhost.localdomain> <4B4C1E82.7000907@snapgear.com>
In-Reply-To: <4B4C1E82.7000907@snapgear.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 01/12/2010 05:02 PM, Greg Ungerer wrote:
> Linus Torvalds wrote:
>> On Tue, 12 Jan 2010, Greg Ungerer wrote:
>>> +#else
>>> +#define page_to_phys(page) ((page - mem_map) << PAGE_SHIFT)
>>> +#define page_to_bus(page) ((page - mem_map) << PAGE_SHIFT)
>>> +#endif
>>
>> Ok, so the old ones were total crap too, but when moving things
>> around, don't just copy the crap like this.
>>
>> Look at those two #define's for five seconds, and ask yourself what is
>> wrong with them. Those macros are not good.
>
> Ok. Easily fixed.
>
> page_to_bus() doesn't even look like it is used anywhere (and m68k
> itself doesn't define it). So I'll remove it.
>
> I propose changing page_to_phys() to be:
>
> #define page_to_phys(page) (page_to_pfn(page) << PAGE_SHIFT)

Hmmm, on second thoughts maybe that change is better left
for the next merge window. Perhaps best to just fix that
arg bracketization now?


> Which seems consistent with many other arches. (And it works on
> m68knommu too :-)
>
> I'll generate a new patch with that changed.
>
> A quick grep shows page_to_phys() defined this way in a couple of
> other places too:
>
> h8300/include/asm/io.h
> sparc/include/asm/io_32.h

Strike that, only the h8300 one needs arg fixing.

Regards
Greg


------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear Group, McAfee                      PHONE:       +61 7 3435 2888
8 Gardner Close,                            FAX:         +61 7 3891 3630
Milton, QLD, 4064, Australia                WEB: http://www.SnapGear.com
