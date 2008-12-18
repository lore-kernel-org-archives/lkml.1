Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753331AbYLRUJ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbYLRUJ1 (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:09:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYLRUJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:09:17 -0500
Received: from gw.goop.org ([64.81.55.164]:46504 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbYLRUJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:09:16 -0500
Message-ID: <494AADE9.8040503@goop.org>
Date: Thu, 18 Dec 2008 12:09:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Becky Bruce <beckyb@kernel.crashing.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xensource.com, x86@kernel.org, ian.campbell@citrix.com,
        jbeulich@novell.com, joerg.roedel@amd.com,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 00 of 14] swiotlb/x86: lay groundwork for xen dom0 use
 of swiotlb
References: <20081216203513.GA14787@elte.hu> <20081217142637V.fujita.tomonori@lab.ntt.co.jp> <4949296F.7000701@goop.org> <20081218015705Z.fujita.tomonori@lab.ntt.co.jp> <E5300CC0-1D08-46F7-91F6-DEC36202F1DE@kernel.crashing.org>
In-Reply-To: <E5300CC0-1D08-46F7-91F6-DEC36202F1DE@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Becky Bruce wrote:
> 32-bit powerpc needs this support - I was actually about to push a 
> similar set of patches.  We have several processors that support 36 
> bits of physical address space and do not have any iommu capability.  
> The rest of the kernel support for those processors is now in place, 
> so swiotlb is the last piece of the puzzle for that to be fully 
> functional.  I need to take a closer look at this series to see 
> exactly what it's doing and how it differs from what I've been testing.
>
> So there is another immediate use case, and I'd really hate to see 
> this code duplicated.  It should be entirely possible to remove the 
> assumption that we can save off the VA of the original buffer, which 
> is the thing that precludes HIGHMEM support, and still have nice 
> readable, maintainable code.

Good, I'm glad I'm not just making things up ;)

The gist of the patch is to convert all the kernel virtual addresses 
into struct page+offset.  It's a fairly generic way to handle highmem 
systems, so it should work for you too.  Of course, if you have a 
cleaner patch to achieve the same result, then we evaluate that too.

    J

