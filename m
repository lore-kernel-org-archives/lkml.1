Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZGJF5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZGJF5i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 01:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZGJF53
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 01:57:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:48808 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbZGJF52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 01:57:28 -0400
Subject: Re: [PATCH 00/11] swiotlb: Introduce architecture-specific APIs to
 replace __weak functions (v2)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ian Campbell <ian.campbell@citrix.com>
Cc: linux-kernel@vger.kernel.org, Becky Bruce <beckyb@kernel.crashing.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Kumar Gala <galak@kernel.crashing.org>, Olaf Kirch <okir@suse.de>,
       Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org,
       linuxppc-dev@ozlabs.org, x86@kernel.org
In-Reply-To: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
References: <1243870383-12954-1-git-send-email-ian.campbell@citrix.com>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 15:55:56 +1000
Message-Id: <1247205356.15530.18.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 16:32 +0100, Ian Campbell wrote:
> This series:
> * removes the swiotlb_(arch_)_phys_to_bus and bus_to_phys __weak
>   hooks, replacing them with an architecture-specific phys_to_dma and
>   dma_to_phys interface. These are used by both PowerPC and Xen to
>   provide the correct mapping from physical to DMA addresses.
> * removes the swiotlb_address_needs_mapping and
>   swiotlb_range_needs_mapping __weak functions as well as
>   is_buffer_dma_capable (which should never have been a generic
>   function). All three are replaced by a single architecture-specific
>   interface which meets the needs of both PowerPC and Xen.
> * removes the swiotlb_virt_to_bus __weak function and replaces it with
>   a CONFIG_HIGHMEM compatible version when high memory is in use. This
>   is needed for 32 bit PowerPC swiotlb support.
> * removes the swiotlb_alloc* __weak functions and replaces them with
>   swiotlb_init_with_buffer which allows the use of a caller allocated
>   buffer (and emergency pool).
> 
> I think these new interfaces are cleaner than the existing __weak
> functions and isolate the swiotlb code from architecture internals.
> 
> This series does not contain any Xen or PowerPC specific changes, those
> will follow in separate postings. The complete patchset has been boot
> tested under Xen and native-x86 and compiled for IA64 and PowerPC
> 
> Changes since v1: 
> - Fixed compile error in swiotlb_dma_to_virt highmem version. Moved
>   #ifdef into function to avoid prototype drift.
> - checkpatch fixes.
> - missed a swiotlb_arch_range_needs_mapping in swiotlb.h and x86
>   pci-swiotlb.c and swiotlb_bus_to_phys/phys_to_bus implementations in
>   x86.
> - additionally replaced __weak swiotlb_alloc* with
>   swiotlb_init_with_buffer.

Looks like I was only CCed on part of them... it's not very handy for me
as I end up having some of the patches in one folder and some
elsewhere :-)

I don't have a firm objection but they will have to go through Becky
and Kumar since they are the one who need swiotlb for their embedded
platforms.

Cheers,
Ben.


