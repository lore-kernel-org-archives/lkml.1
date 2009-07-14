Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZGNDPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZGNDPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 23:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbZGNDPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 23:15:45 -0400
Received: from gate.crashing.org ([63.228.1.57]:60214 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbZGNDPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 23:15:35 -0400
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Ian Campbell <Ian.Campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, linuxppc-dev@ozlabs.org,
       benh@kernel.crashing.org, tony.luck@intel.com, x86@kernel.org,
       Joerg Roedel <joerg.roedel@amd.com>
Message-Id: <68EFFAF6-EF5B-4148-BC54-70BF2AF2456E@kernel.crashing.org>
From: Becky Bruce <beckyb@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20090710051236.GA22218@elte.hu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v935.3)
Subject: Re: [00/15] swiotlb cleanup
Date: Mon, 13 Jul 2009 22:13:56 -0500
References: <1247187904-31999-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <20090710051236.GA22218@elte.hu>
X-Mailer: Apple Mail (2.935.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 10, 2009, at 12:12 AM, Ingo Molnar wrote:

>
> * FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
>
>> - removes unused (and unnecessary) hooks in swiotlb.
>>
>> - adds dma_capable() and converts swiotlb to use it. It can be used  
>> to
>> know if a memory area is dma capable or not. I added
>> is_buffer_dma_capable() for the same purpose long ago but it turned
>> out that the function doesn't work on POWERPC.
>>
>> This can be applied cleanly to linux-next, -mm, and mainline. This
>> patchset touches multiple architectures (ia64, powerpc, x86) so I
>> guess that -mm is appropriate for this patchset (I don't care much
>> what tree would merge this though).
>>
>> This is tested on x86 but only compile tested on POWERPC and IA64.
>>
>> Thanks,
>>
>> =
>> arch/ia64/include/asm/dma-mapping.h    |   18 ++++++
>> arch/powerpc/include/asm/dma-mapping.h |   23 +++++++
>> arch/powerpc/kernel/dma-swiotlb.c      |   48 +---------------
>> arch/x86/include/asm/dma-mapping.h     |   18 ++++++
>> arch/x86/kernel/pci-dma.c              |    2 +-
>> arch/x86/kernel/pci-gart_64.c          |    5 +-
>> arch/x86/kernel/pci-nommu.c            |    2 +-
>> arch/x86/kernel/pci-swiotlb.c          |   25 --------
>> include/linux/dma-mapping.h            |    5 --
>> include/linux/swiotlb.h                |   11 ----
>> lib/swiotlb.c                          |  102 ++++++++ 
>> +-----------------------
>> 11 files changed, 92 insertions(+), 167 deletions(-)
>
> Hm, the functions and facilities you remove here were added as part
> of preparatory patches for Xen guest support. You were aware of
> them, you were involved in discussions about those aspects with Ian
> and Jeremy but still you chose not to Cc: either of them and you
> failed to address that aspect in the changelogs.
>
> I'd like the Xen code to become cleaner more than anyone else here i
> guess, but patch submission methods like this are not really
> helpful. A far better method is to be open about such disagreements,
> to declare them, to Cc: everyone who disagrees, and to line out the
> arguments in the changelogs as well - instead of just curtly
> declaring those APIs 'unused' and failing to Cc: involved parties.
>
> Alas, on the technical level the cleanups themselves look mostly
> fine to me. Ian, Jeremy, the changes will alter Xen's use of
> swiotlb, but can the Xen side still live with these new methods - in
> particular is dma_capable() sufficient as a mechanism and can the
> Xen side filter out DMA allocations to make them physically
> continuous?
>
> Ben, Tony, Becky, any objections wrt. the PowerPC / IA64 impact? If
> everyone agrees i can apply them to the IOMMU tree, test it and push
> it out to -next, etc.
>

Ingo,

With the exception of the patch I commented on, I think these look OK  
from the powerpc point of view.  I've successfully booted one of my  
test platforms with the entire series applied and will run some more  
extensive (i.e. not "Whee!  A prompt!") tests tomorrow.

-Becky

