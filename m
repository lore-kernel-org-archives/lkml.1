Return-Path: <linux-kernel-owner+w=401wt.eu-S1757398AbYFPBSa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398AbYFPBSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 21:18:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751891AbYFPBR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 21:17:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:29973 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbYFPBR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 21:17:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,649,1204531200"; 
   d="scan'208";a="396957145"
Subject: Re: [PATCH] x86: use add_highpages_with_active_regions for high
	pages init
From: "Huang, Ying" <ying.huang@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <86802c440806140205g3ff113ffq39272c18ef5b9654@mail.gmail.com>
References: <200806132005.45836.yhlu.kernel@gmail.com>
	 <200806140056.32601.yhlu.kernel@gmail.com> <20080614082343.GB11277@elte.hu>
	 <86802c440806140205g3ff113ffq39272c18ef5b9654@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 16 Jun 2008 09:20:41 +0800
Message-Id: <1213579241.2433.7.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
X-OriginalArrivalTime: 16 Jun 2008 01:17:45.0458 (UTC) FILETIME=[C8476520:01C8CF4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-14 at 02:05 -0700, Yinghai Lu wrote:
> On Sat, Jun 14, 2008 at 1:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> >
> >> use early_node_map to init high pages, so can remove page_is_ram and
> >> page_is_reserved_early in the big loop with add_one_highpage
> >>
> >> also remove the page_is_reserved_early that is not needed.
> >
> > applied to tip/x86/mpparse for testing, thanks.
> >
> > Andrew: mm/page_alloc.c modification.
> 
> Ying Huang,
> 
> I removed page_is_reserved_early....it cause init highmem take extra
> time on my big box.

OK.

> please check efi_reserve_early that is calling reserve_early. so need
> to make sure "EFI memmap" is reserved in itself...otherwise you may
> need to update e820 table by add_memory_region (....,
> E820_RESERVED)...

EFI memmap may be in highmem, it can not be reserved by bootmem
allocator on i386. So I think it is necessary to have an early highmem
allocator. It can be used for EFI memory map and linked list of setup
data which comes from boot-loader and may be located in highmem.

As for the implementation, what about adding a remove_active_range()
which operate on early_node_map and an early_res_to_early_node_map()?

Best Regards,
Huang Ying

