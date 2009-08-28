Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZH1WJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZH1WJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 18:09:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbZH1WJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 18:09:34 -0400
Received: from mail-iw0-f204.google.com ([209.85.223.204]:50228 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbZH1WJd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 18:09:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HyjSSjh12+MUqtfMTyatKsTSDHS/rs8TCqwBsHo2o5weWxCI4DkaCr0RIoKVpMs/U9
         KwWpjHAbLoNqy/M0ogzUMn98o3iFiHLcjcmKPoCZLQn/uuVq5EEO5Ep9oX8W3gRmcO+Z
         91L6GwiNmFNGp/D9FcgLTNwZrNVh42Bz7LB68=
MIME-Version: 1.0
In-Reply-To: <43e72e890908281450k78cc1a2fmd4fd033ae0f4176f@mail.gmail.com>
References: <43e72e890908272225w79ec5bf6kc7ef1160e5a088ae@mail.gmail.com> 
	<tnxtyzr7vcl.fsf@pc1117.cambridge.arm.com> <43e72e890908280952j410293fbm47b4b9d566e26c14@mail.gmail.com> 
	<43e72e890908281450k78cc1a2fmd4fd033ae0f4176f@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 28 Aug 2009 15:09:15 -0700
Message-ID: <43e72e890908281509o44930348w581b865107ea3e98@mail.gmail.com>
Subject: Re: memleaks, acpi + ext4 + tty
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 2:50 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
> On Fri, Aug 28, 2009 at 9:52 AM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:
>> On Fri, Aug 28, 2009 at 9:32 AM, Catalin Marinas<catalin.marinas@arm.com> wrote:
>>> "Luis R. Rodriguez" <mcgrof@gmail.com> wrote:
>>>> I have an assorted collection of kmemleak reports for acpi, ext4 and
>>>> tty, not sure how to read these yet to fix so figure I'd at least post
>>>> them. To reproduce I can just dd=/dev/zero to some big file and played
>>>> some video.
>>>
>>> If you do a few echo scan > /sys/kernel/debug/kmemleak, do they
>>> disappear (i.e. transient false positives)?
>>
>> Sure, I will once on rc8.
>>
>>> Which kernel version is this?
>>
>> v2.6.31-rc7-33172-gf4a9f9a
>>
>> This is from wireless-testing, which has wireless patches on top of
>> rc7. John just rebased to rc8 so will give that a shot at work.
>>
>>>> unreferenced object 0xffff88003e0015c0 (size 64):
>>>>   comm "swapper", pid 1, jiffies 4294892352
>>>>   backtrace:
>>>>     [<ffffffff81121fad>] create_object+0x13d/0x2d0
>>>>     [<ffffffff81122265>] kmemleak_alloc+0x25/0x60
>>>>     [<ffffffff81118a03>] kmem_cache_alloc_node+0x193/0x200
>>>>     [<ffffffff8152509e>] process_zones+0x70/0x1cd
>>>>     [<ffffffff81525230>] pageset_cpuup_callback+0x35/0x92
>>>>     [<ffffffff8152c9b7>] notifier_call_chain+0x47/0x90
>>>>     [<ffffffff81078549>] __raw_notifier_call_chain+0x9/0x10
>>>>     [<ffffffff81523f25>] _cpu_up+0x75/0x130
>>>>     [<ffffffff8152403a>] cpu_up+0x5a/0x6a
>>>>     [<ffffffff8181969e>] kernel_init+0xcc/0x1ba
>>>>     [<ffffffff810130ca>] child_rip+0xa/0x20
>>>>     [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> Can't really tell. Maybe a false positive caused by kmemleak not
>>> scanning the pgdata node_zones. Can you post your .config file?
>>
>> Sure, attached.
>>
>>>> unreferenced object 0xffff88003cb5f700 (size 64):
>>>>   comm "swapper", pid 1, jiffies 4294892459
>>>>   backtrace:
>>>>     [<ffffffff81121fad>] create_object+0x13d/0x2d0
>>>>     [<ffffffff81122265>] kmemleak_alloc+0x25/0x60
>>>>     [<ffffffff81119f3b>] __kmalloc+0x16b/0x250
>>>>     [<ffffffff812bb549>] kzalloc+0xf/0x11
>>>>     [<ffffffff812bbb53>] acpi_add_single_object+0x58e/0xd3c
>>>>     [<ffffffff812bc51c>] acpi_bus_scan+0x125/0x1af
>>>>     [<ffffffff81842361>] acpi_scan_init+0xc8/0xe9
>>>>     [<ffffffff8184211c>] acpi_init+0x21f/0x265
>>>>     [<ffffffff8100a05b>] do_one_initcall+0x4b/0x1b0
>>>>     [<ffffffff81819736>] kernel_init+0x164/0x1ba
>>>>     [<ffffffff810130ca>] child_rip+0xa/0x20
>>>>     [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> I get ACPI reports as well and they may be real leaks. However, I
>>> didn't have time to analyse the code (pretty complicated reference
>>> counting).
>>
>> Heh OK thanks for reviewing them though.
>>
>>>> unreferenced object 0xffff880039571800 (size 1024):
>>>>   comm "exe", pid 1168, jiffies 4294893410
>>>>   backtrace:
>>>>     [<ffffffff81121fad>] create_object+0x13d/0x2d0
>>>>     [<ffffffff81122265>] kmemleak_alloc+0x25/0x60
>>>>     [<ffffffff81119f3b>] __kmalloc+0x16b/0x250
>>>>     [<ffffffff811e1d71>] ext4_mb_init+0x1a1/0x590
>>>>     [<ffffffff811d2da3>] ext4_fill_super+0x1df3/0x26c0
>>>>     [<ffffffff8112774f>] get_sb_bdev+0x16f/0x1b0
>>>>     [<ffffffff811c8fd3>] ext4_get_sb+0x13/0x20
>>>>     [<ffffffff81127216>] vfs_kern_mount+0x76/0x180
>>>>     [<ffffffff8112738d>] do_kern_mount+0x4d/0x130
>>>>     [<ffffffff8113fc57>] do_mount+0x307/0x8b0
>>>>     [<ffffffff8114028f>] sys_mount+0x8f/0xe0
>>>>     [<ffffffff81011f02>] system_call_fastpath+0x16/0x1b
>>>>     [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> The ext4 reports are real leaks and patch was posted here -
>>> http://lkml.org/lkml/2009/7/15/62. However, it hasn't been merged into
>>> mainline yet (I cc'ed Aneesh).
>>>
>>> The patch is merged in my "kmemleak-fixes" branch on
>>> git://linux-arm.org/linux-2.6.git.
>>
>> Will try to suck them out and try them.
>
> OK -- tested rc8 + a pull of your tree into mine. The bootup was
> really slow and something was just not going right. After a while
> memleak complained it had 8 kmemleak logs but I was not able to get my
> system usable enough to cat the file.
>
> In cases like these I wish I would hookup my ctrl-alt-del to kexec() a
> safe kernel.
>
> After a long period of time it seems X wished it would start, it tried
> and then flashed back to the tty. This kept repeating in a loop.
>
> I am not sure if the culprit was rc8 or the kmemleak branch merge --
> I'll find out after I boot into rc8 in a few.

rc8 busted my bootup, the issues are present with just
wireless-testing. I highly doubt the issues are wireless-testing
related so I will not bisect there. Since I am unable to get anything
useful from the kernel to determine what may have gone sour, any
suggestions on a path to bisect, or should I just do the whole tree?

  Luis
