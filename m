Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYIHVZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYIHVZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 17:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYIHVZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 17:25:39 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:51955 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676AbYIHVZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 17:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fR93xHjQV6wkN5eQPlZAFYcoXoU9IgqDgOP0rjHI1cwks4Y1Q6ad2w5H6h+XJiOYB6
         k7WbQwiDVhvK/4PVM00wWQ7hBcIdImlKf6+oy4ANMXS4q0QskOvALY8TNyiyqcaUigPW
         9tS3Bi1syUEzjheIvNGlWKI6eAbBtEQyOMWUM=
Message-ID: <68676e00809081425r604baefaqd1ebb9502f5d9049@mail.gmail.com>
Date: Mon, 8 Sep 2008 23:25:36 +0200
From: "Luca Tettamanti" <kronos.it@gmail.com>
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [2.6.27] overlapping early reservations [was: early exception - lockdep related?]
Cc: "Ingo Molnar" <mingo@elte.hu>, "H. Peter Anvin" <hpa@kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <86802c440809081346i3fccea34u81f6b252b6c0c2a0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <68676e00809051217h3da02a6bld4412b4a2ee3b728@mail.gmail.com>
	 <68676e00809060620k35679302s42fc0a74aa1dc2d3@mail.gmail.com>
	 <20080906145122.GA7693@elte.hu>
	 <86802c440809060906h721d6243t4a3b5fb604a9d7b3@mail.gmail.com>
	 <68676e00809081054j3fb9c5bq76c9a6aceea35aa2@mail.gmail.com>
	 <86802c440809081104i23b477e1w62bd5967b79529cb@mail.gmail.com>
	 <68676e00809081214h49eb07d4tb6145e8b47b00768@mail.gmail.com>
	 <86802c440809081235q57470134t51c61e2a6b97dc87@mail.gmail.com>
	 <68676e00809081300h2c835a44h3d55d0794852d75@mail.gmail.com>
	 <86802c440809081346i3fccea34u81f6b252b6c0c2a0@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 8, 2008 at 10:46 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> On Mon, Sep 8, 2008 at 1:00 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>> On Mon, Sep 8, 2008 at 9:35 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>> On Mon, Sep 8, 2008 at 12:14 PM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>>>> On Mon, Sep 8, 2008 at 8:04 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>>> On Mon, Sep 8, 2008 at 10:54 AM, Luca Tettamanti <kronos.it@gmail.com> wrote:
>>>>>
>>>>> can you post boot log with working kernel + "debug"?
>>>>
>>>> This is the map of the early reservations (will send the dmesg + debug later):
>>>>
>>>> [    0.000000] (6 early reservations) ==> bootmem [0000000000 - 00bbf90000]
>>>> [    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
>>>> [0000000000 - 0000001000]
>>>> [    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==>
>>>> [0000006000 - 0000008000]
>>>> [    0.000000]   #2 [0000200000 - 0000d012b8]    TEXT DATA BSS ==>
>>>> [0000200000 - 0000d012b8]
>>>> [    0.000000]   #3 [00037dc000 - 00040fe2d9]          RAMDISK ==>
>>>> [00037dc000 - 00040fe2d9]
>>>> [    0.000000]   #4 [000009c800 - 0000100000]    BIOS reserved ==>
>>>> [000009c800 - 0000100000]
>>>> [    0.000000]   #5 [0000008000 - 000000b000]          PGTABLE ==>
>>>> [0000008000 - 000000b000]
>>>>
>>>> As a side note: I've bigger older (2.6.26) kernels that boots fine,
>>>> and smaller 2.6.27 kernels that do not work, e.g. this one:
>>>
>>> that could explain sth. big kernel use more,  and lilo put ramdisk
>>> high from 0x37dc000
>>>
>>>>
>>>> Overlapping early reservations b71000-effb43 RAMDISK to 200000-c84ecf
>>>> TEXT DATA BSS
>>>
>>> need to figure out, lilo put ramdisk so low...
>>>
>>> need to know e820 table layout...
>>
>>  BIOS-provided physical RAM map:
>>  BIOS-e820: 0000000000000000 - 000000000009c800 (usable)
>>  BIOS-e820: 000000000009c800 - 00000000000a0000 (reserved)
>>  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
>>  BIOS-e820: 0000000000100000 - 00000000bbf90000 (usable)
>>  BIOS-e820: 00000000bbf90000 - 00000000bbf9e000 (ACPI data)
>>  BIOS-e820: 00000000bbf9e000 - 00000000bbfe0000 (ACPI NVS)
>>  BIOS-e820: 00000000bbfe0000 - 00000000bc000000 (reserved)
>>  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
>>  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
>>  last_pfn = 0xbbf90 max_arch_pfn = 0x3ffffffff
>>
>> dmesg is attached, but I haven't rebooted yet.
>
> so some config works, others not?

Yes, that's correct, but it doesn't seem related to a particular
configuration item (moon phase maybe).
For example the kernel I'm using right now (-rc4-something) has the
same config as a non-working kernel minus LOCKDEP, but git-current
minus LOCKDEP does not work. On another kernel I got a working config
just enabling DEBUG_INFO, in another case I disabled MTD.

Luca
