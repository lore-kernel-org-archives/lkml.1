Return-Path: <linux-kernel-owner+w=401wt.eu-S1757126AbYFZJnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126AbYFZJnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753389AbYFZJnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:43:41 -0400
Received: from po-out-1718.google.com ([72.14.252.153]:6143 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbYFZJnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:43:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=PDjvBNEj2dpr7alDZRPcDkJaRK0G5SKGZ2aJdEhUldBRT26iyj/aKqTls1jN8VnLbn
         imdjO7xpoZN/wfojrMjTVBsJ+w8Su1fdHA5cgnsyymr36Xwjmq5ATu0MJXUjAONBldHd
         GVFGBgw0iixcKRODFwYafbe9FO3P8oZSagvLA=
Message-ID: <86802c440806260243m5fe9fff2r3fc3cdeb7090eabf@mail.gmail.com>
Date: Thu, 26 Jun 2008 02:43:40 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 2/2] x86 boot: early_res_to_e820
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1214467411.11346.34.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214461980.10809.7.camel@caritas-dev.intel.com>
	 <86802c440806260013u447d15d8v94df7bb7bd00da19@mail.gmail.com>
	 <1214465232.11346.18.camel@caritas-dev.intel.com>
	 <86802c440806260029l35b68e4fh89264e1796e7863b@mail.gmail.com>
	 <1214467411.11346.34.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 1:03 AM, Huang, Ying <ying.huang@intel.com> wrote:
> On Thu, 2008-06-26 at 00:29 -0700, Yinghai Lu wrote:
> [...]
>> >
>> > For example, if EFI memory map is allocated in highmem area by
>> > boot-loader, it need to be reserved in kernel. But on i386, bootmem can
>> > only reserve memory area below max_low_pfn. So I think this is needed.
>> >
>> > In general, I think it is needed to provide a reservation mechanism for
>> > highmem area on i386. Because some memory area from BIOS or boot-loader
>> > may in highmem area.
>>
>> I mean call reserve_setup_data right after finish_e820_parsing,  and
>> it could call e820_update_range directly.
>
> e820_update_range() can only be used after finish_e820_parsing()?

you could call that just after setup_memory_map

>
> parse_setup_data() should be called before parse_early_param() to let
> early_param override settings in setup_data. Which is before
> finish_e820_parsing(). It seems a little wired to use the data before
> reserve it.

that is ok, because no one use find_e820_area yet and e820 is a static
array. so it is safe.

>
> And this means find_e820_area() should not be called before
> e820_update_range()?

Yes.. no one use it....first user is supposed for bootmap?

YH
