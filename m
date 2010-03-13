Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933657Ab0CMDJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 22:09:47 -0500
Received: from mga07.intel.com ([143.182.124.22]:21365 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757945Ab0CMDJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 22:09:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,629,1262592000"; 
   d="scan'208";a="254220832"
Message-ID: <4B9B01F5.3000807@linux.intel.com>
Date: Fri, 12 Mar 2010 19:09:41 -0800
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: akataria@vmware.com
CC: Len Brown <lenb@kernel.org>, the arch/x86 maintainers <x86@kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Petr Vandrovec <petr@vmware.com>
Subject: Re: swiotlb detection should be memory hotplug aware ?
References: <1268446032.13691.69.camel@ank32>
In-Reply-To: <1268446032.13691.69.camel@ank32>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

, Alok Kataria wrote:

Hi Alok,

> Hi,
>
> Looking at the current code swiotlb is initialized for 64bit kernels
> only when the max_pfn value is greater than 4G (MAX_DMA32_PFN value).
> So in cases when the initial memory is less than 4GB the kernel boots
> without enabling swiotlb, when we hotadd memory to such a kernel and go
> beyond the 4G limit, swiotlb is still disabled. As a result when any
> 32bit devices start using this newly added memory beyond 4G, the kernel
> starts spitting error messages like below or in some cases it causes
> kernel panics.

Yes seems like a real problem.

>
> 1. Enable swiotlb for all 64bit kernels which have memory hot-add
> support.

I don't think that's a good idea. It would enable it everywhere on
distributions which compile with hotadd. Need (2)

> 2. Instead of checking the max_pfn value in pci_swiotlb_detect, check
> for max_hotpluggable_pfn (or some such) value. Though I don't see such a
> value readily available. I could parse the SRAT and get hotplug memory
> information but that will make swiotlb detection logic a little too
> complex. A quick look around srat_xx.c files and the acpi_memhotplug
> module didn't find any useful API that could be used directly either.
> So was wondering if any of you are aware of an easy way to get such
> information ?

I have a patchkit to revamp the SRAT parsing to store the hotadd information
more efficiently (the current way is pretty dumb)  I need to repost that.

With that it would be relatively easy to do I think.

-Andi
