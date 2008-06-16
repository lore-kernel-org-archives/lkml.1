Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYFPDrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYFPDrF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 23:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752170AbYFPDqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 23:46:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:21089 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYFPDqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 23:46:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=eH5V0tQdnkHKRdMtVWHWtYKPrbv98t8/t/KGQvqo8mmbdtxYa/Bda6z9g42ccMTHZR
         j5HiJBVcnELRbJ12NH6dtaBj468QGYa7KiJYpPkK4FXL9pBYvCxcDuDevPA6SNdLWtgT
         bgT33QLP2ZVY7C1URYPihDQIEWrZ9TAw0y/QM=
Message-ID: <86802c440806152046s71916de8g6f8e3e8d272d336a@mail.gmail.com>
Date: Sun, 15 Jun 2008 20:46:50 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH] x86: use add_highpages_with_active_regions for high pages init
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1213579241.2433.7.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806132005.45836.yhlu.kernel@gmail.com>
	 <200806140056.32601.yhlu.kernel@gmail.com>
	 <20080614082343.GB11277@elte.hu>
	 <86802c440806140205g3ff113ffq39272c18ef5b9654@mail.gmail.com>
	 <1213579241.2433.7.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 15, 2008 at 6:20 PM, Huang, Ying <ying.huang@intel.com> wrote:
> On Sat, 2008-06-14 at 02:05 -0700, Yinghai Lu wrote:
>> On Sat, Jun 14, 2008 at 1:23 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> >
>> >> use early_node_map to init high pages, so can remove page_is_ram and
>> >> page_is_reserved_early in the big loop with add_one_highpage
>> >>
>> >> also remove the page_is_reserved_early that is not needed.
>> >
>> > applied to tip/x86/mpparse for testing, thanks.
>> >
>> > Andrew: mm/page_alloc.c modification.
>>
>> Ying Huang,
>>
>> I removed page_is_reserved_early....it cause init highmem take extra
>> time on my big box.
>
> OK.
>
>> please check efi_reserve_early that is calling reserve_early. so need
>> to make sure "EFI memmap" is reserved in itself...otherwise you may
>> need to update e820 table by add_memory_region (....,
>> E820_RESERVED)...
>
> EFI memmap may be in highmem, it can not be reserved by bootmem
> allocator on i386. So I think it is necessary to have an early highmem
> allocator. It can be used for EFI memory map and linked list of setup
> data which comes from boot-loader and may be located in highmem.
>
> As for the implementation, what about adding a remove_active_range()
> which operate on early_node_map and an early_res_to_early_node_map()?

don't need,
EFI memmap should be reserved in e820map, so it should not show up in
early_node_map.
if it is not reserved in e820map, you could use e820_add_region or
e820_update_range make it reserved

YH
