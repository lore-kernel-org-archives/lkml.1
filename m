Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751786AbYLQQb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbYLQQb7 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 11:31:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754425AbYLQQbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 11:31:47 -0500
Received: from gw.goop.org ([64.81.55.164]:60752 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752805AbYLQQbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 11:31:46 -0500
Message-ID: <4949296F.7000701@goop.org>
Date: Wed, 17 Dec 2008 08:31:43 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        x86@kernel.org, ian.campbell@citrix.com, jbeulich@novell.com,
        joerg.roedel@amd.com
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
 of swiotlb
References: <patchbomb.1229458644@abulafia.goop.org>	<20081216203513.GA14787@elte.hu> <20081217142637V.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20081217142637V.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 16 Dec 2008 21:35:13 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
>
>   
>> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>>
>>     
>>> Hi Ingo,
>>>
>>> Here's some patches to clean up swiotlb to prepare for some Xen dom0 
>>> patches.  These have been posted before, but undergone a round of 
>>> cleanups to address various comments.
>>>       
>> applied to tip/core/iommu, thanks Jeremy.
>>
>> the only patch that seems to have the potential to break drivers is:
>>
>>   be4ac7b: swiotlb: consistently use address_needs_mapping everywhere
>>     
>
> Yeah, as I already wrote, this patch is wrong.
>   

I'll have a look.

> I think that the whole patchset is against the swiotlb design. swiotlb
> is designed to be used as a library. Each architecture implements the
> own swiotlb by using swiotlb library
> (e.g. arch/x86/kernel/pci-swiotlb_64.c).
>   

The whole patchset?  The bulk of the changes to lib/swiotlb.c are 
relatively minor to remove the unwarranted assumptions it is making in 
the face of a new user.  They will have no effect on other existing 
users, including non-Xen x86 builds.

If you have specific objections we can discuss those, but I don't think 
there's anything fundamentally wrong with making lib/swiotlb.c a bit 
more generically useful.

> For example, adding the following code (9/14) for just Xen that the
> majority of swiotbl users (x86_64 and IA64) don't need to the library
> is against the design.
>   

If the architecture doesn't support highmem then this code will compile 
to nothing - PageHighMem() will always evaluate to 0.  It will therefore 
have zero effect on the code generated for IA64 or x86-64.  This is not 
really a Xen-specific change, but a result of adding swiotlb support for 
i386.  Other architectures which support a notion of highmem would also 
need this code if they wanted to use swiotlb.

    J
