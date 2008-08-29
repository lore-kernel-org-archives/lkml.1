Return-Path: <linux-kernel-owner+w=401wt.eu-S1754992AbYH2LIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992AbYH2LIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 07:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbYH2LIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 07:08:06 -0400
Received: from hosted06.westnet.com.au ([203.10.1.221]:54147 "EHLO
	hosted06.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbYH2LIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 07:08:04 -0400
Message-ID: <48B7D88C.2070804@snapgear.com>
Date: Fri, 29 Aug 2008 21:07:56 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, geert@linux-m68k.org
Subject: Re: [RFC: 2.6 patch] m68knommu: remove the broken COMEMPCI code
References: <20080819134718.GH8852@cs181140183.pp.htv.fi> <48B24E2C.9060703@snapgear.com> <20080825204333.GA13027@cs181140183.pp.htv.fi> <48B77764.6060607@snapgear.com> <20080829070103.GD16462@cs181140183.pp.htv.fi>
In-Reply-To: <20080829070103.GD16462@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Adrian,

Adrian Bunk wrote:
> On Fri, Aug 29, 2008 at 02:13:24PM +1000, Greg Ungerer wrote:
>> Hi Adrian,
>>
>> Adrian Bunk wrote:
>>> On Mon, Aug 25, 2008 at 04:16:12PM +1000, Greg Ungerer wrote:
>>>> Hi Adrian,
>>>>
>>>> Adrian Bunk wrote:
>>>>> There exists blackfin hardware with PCI support, but the support
>>>>> currently in the kernel fails to build starting with:
>>>>>
>>>>> <--  snip  -->
>>>>>
>>>>> ...
>>>>>   CC      init/main.o
>>>>> In file included from dma-mapping.h:5,
>>>>>                  from dma-mapping.h:52,
>>>>>                  from dmaengine.h:29,
>>>>>                  from skbuff.h:29,
>>>>>                  from netlink.h:155,
>>>>>                  from genetlink.h:4,
>>>>>                  from genetlink.h:4,
>>>>>                  from taskstats_kern.h:12,
>>>>>                  from main.c:46:
>>>>> dma-mapping.h: In function 'dma_supported': ma-mapping.h:24: error: 
>>>>> implicit declaration of function 'pci_dma_supported'
>>>>> ...
>>>>> make[2]: *** [init/main.o] Error 1
>>>> I think we should just remove the underlying comempci access
>>>> code which is the only user of this (arch/m68knommu/kernel/comempci.c).
>>>> Nobody has used it in a very long time. And the hardware itself is
>>>> old, and completely brain-damaged by design.
>>> A patch for removing the comempci code is below.
>>>
>>> It's a bit suspicious that asm/elia.h is now removed since comempci.c  
>>> was the only user. What's the sttus of the eLIA platform?
>> Only ever a handful where made, and that was in 1999.
>> I doubt anyone could ever use the PCI interface on it
>> in any useful way.
> 
> So I can send a patch to remove the platform?

Yeah, I guess we can add in back in of anyone complains.
I don't know of any users of it anymore.


>>> But COMEMPCI fails with a different error - this init/main.o build 
>>> error is present for CONFIG_PCI=y, CONFIG_COMEMPCI=n, so the dependency 
>>> of PCI on BROKEN is still required (unless it gets fixed).
>> Unless I am mistaken there is now no need for the CONFIG_PCI option
>> if selecting m68knommu. The only m68knommu platforms that had PCI
>> as far as I know where those that use the comempci part.
> 
> That implies I can also kill the m68k PCI code since m68knommu will 
> never use it?

Yep.

Regards
Greg


>> The patch looks ok to me too (acked below).
> 
> Thanks.
> 
>> Regards
>> Greg
>> ...
> 
> cu
> Adrian
> 


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
