Return-Path: <linux-kernel-owner+w=401wt.eu-S1763950AbYF3TFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763950AbYF3TFW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 15:05:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbYF3TFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 15:05:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:51953 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbYF3TFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 15:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=uMHt4OtIQ9fmlQy6W8TwToG+KzuWMvK1tJAFS7mRE176AGwnWopB1JTi8NGwvIa712
         2Ono+ypfaYYg3giXLMUj9QcQ2/PXi2OryGAV+uAUcJ9YpitX5kEXsR3DcOoJTV/bSxu8
         ootx+llAGRUUUNA+7bgREK1Q0UQa8+jvOO/9Y=
Message-ID: <86802c440806301205y35563326rd2ada495a0024441@mail.gmail.com>
Date: Mon, 30 Jun 2008 12:05:06 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH 1/2] x86 boot: add E820_RESVD_KERN
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, linux-kernel@vger.kernel.org
In-Reply-To: <1214818706.23677.8.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1214461978.10809.6.camel@caritas-dev.intel.com>
	 <86802c440806260247p19f5b850r8757c51280912ae9@mail.gmail.com>
	 <86802c440806261922n3f13b454o5e543e28d9a34e8e@mail.gmail.com>
	 <1214534894.10865.6.camel@caritas-dev.intel.com>
	 <86802c440806271505n78275758re235ef6616d95b3d@mail.gmail.com>
	 <1214809434.2887.8.camel@caritas-dev.intel.com>
	 <86802c440806300034x5bb9b7a1s168bbeaee17e5124@mail.gmail.com>
	 <1214812303.3187.10.camel@caritas-dev.intel.com>
	 <86802c440806300215w31abbcb3h6a42395e11701713@mail.gmail.com>
	 <1214818706.23677.8.camel@caritas-dev.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2008 at 2:38 AM, Huang, Ying <ying.huang@intel.com> wrote:
> On Mon, 2008-06-30 at 02:15 -0700, Yinghai Lu wrote:
> [...]
>> >
>> > I mean memory area reserved with reserved_early() or e820_update_range()
>> > before reserve_setup_data() is called.
>>
>> before parse_setup_data, reserve_early is called for
>> 1. kernel text/data/bss + initial pgt
>> 2. ramdisk
>> 3. ebda
>> e820_update_range is not called.
>> at this time early_res have RAM reserved by kernel.
>>
>> then setup_memory_map is called, so e820 have some ranges...directly
>> from e820 table
>>
>> next need to call parse_setup_data
>> it will add some entries in e820
>>
>> then reserve_setup_data is called, it will use e820_update_range to
>> reserve setup_data itself directly in e820
>>
>> ...
>
> Yes. There is no real conflict now. I think a better rule is:
>
> - Reserve memory area (directly from BIOS or boot-loader, not from
> find_e820_area) needed as early as possible.
> - Don't touch reserved area until all possible reservation is made, that
> is, before conflict check is done.
no one touch the reserved area. before all reserved in early_res or e820.
>
>> >
>> > And because there is no conflict check in e820_update_range(), what to
>> > deal with potential conflict between setup_data and other memory area
>> > regardless which one is reserved earlier?
>>
>> find_e820_area will make sure it only find ram from e820 and it is not
>> conflict with early_res
>
> For find_e820_area, this is safe enough. But what about conflict between
> setup_data and ebda or ramdisk?

can you have setup_data and ebda at the same time?

setup_data and ramdisk should be ok, because bootloader is supposed to
make them not to be conflicts.

YH
