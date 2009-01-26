Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbZAZDRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbZAZDRZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 22:17:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751231AbZAZDRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 22:17:17 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:31339 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZAZDRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 22:17:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=AC3HQdWzA12fNIYDCfY5MPqzd5lR93NLPz9nM2OQ7sl4c7OpkKhiuQhCn2tAQGHaCK
         WGjLGjFjujfg3NBXd3gUuXev/xk28Pxk5PvdJNqNT8Au6e7BO9VmbtN3CzYO87KIWR+t
         btf3t2bhoWbmVjcgeLst4v22M8dE9ucBHZoAY=
MIME-Version: 1.0
In-Reply-To: <8e2adebc0901251915r7dc19c6bn1c9c8ad737039894@mail.gmail.com>
References: <8e2adebc0901250211m218b5c35i7153b0a6548c2079@mail.gmail.com>
	 <8e2adebc0901250218o67fcaa41s872e302e9d6516b4@mail.gmail.com>
	 <1232906526.5424.1.camel@laptop>
	 <8e2adebc0901251915r7dc19c6bn1c9c8ad737039894@mail.gmail.com>
Date: Mon, 26 Jan 2009 08:47:16 +0530
Message-ID: <8e2adebc0901251917q2b84dd2ag17254a92bd526262@mail.gmail.com>
Subject: Re: NULL ptr dereference in __remove_hrtimer()
From: Mandar Thite <mandarthite@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I am really very sorry, I forgot to say, my kernel version is 2.6.26,
and patched with ADEOS ipipe. I know, I should put this query in ADEOS
mailing list, but I think, here I may get some good kickstart.

On Sun, Jan 25, 2009 at 11:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Sun, 2009-01-25 at 15:48 +0530, Mandar Thite wrote:
>> Hello everyone,
>>
>> I am trying to boot Linux kernel on OMAP5912 CPU(arch/arm/mach-omap1)
>> containing ARM926 core.
>> I have configured my Linux kernel to run in tickless mode. In the
>> final steps of booting, kernel is encountering " NULL pointer
>> dereference " in the function " rb_erase() " called from " __remove_hrtimer() ".
>> Following is the backtrace log emitted by the kernel.
>>
>> Backtrace:

>> [<c012ed1c>] (rb_erase+0x0/0x358) from [<c0053f48>] (__remove_hrtimer+0x88/0x94)
>>  r9:00000080 r8:c0285530 r7:00000000 r6:00000001 r5:c0285530
>> r4:c02a6298

>> [<c0053ec0>] (__remove_hrtimer+0x0/0x94) from [<c00548a8>] (hrtimer_start+0x74/0x108)
r7:00000006 r6:02625a00 r5:00000000 r4:2d4cae00

>> [<c0054834>] (hrtimer_start+0x0/0x108) from [<c005af18>](tick_nohz_stop_sched_tick+0x2bc/0x3a4)

>> [<c005ac5c>] (tick_nohz_stop_sched_tick+0x0/0x3a4) from [<c0023318>](cpu_idle+0x38/0x60)

>> [<c00232e0>] (cpu_idle+0x0/0x60) from [<c01f7d58>] (rest_init+0x58/0x6c)
r5:c001cdc4 r4:c02bc754

>> [<c01f7d00>] (rest_init+0x0/0x6c) from [<c0008ad0>] (start_kernel+0x244/0x290)

>>[<c000888c>] (start_kernel+0x0/0x290) from [<10008034>] (0x10008034)
r6:c001cdc0 r5:c029af88 r4:00053175

>> Code: e3580001 01a04005 189dabf0 ea000082 (e5941008)

>> ---[ end trace b0a66fe3e48abdda ]---

>> Kernel panic - not syncing: Attempted to kill the idle task!
>>
>> What I understand is, address of nonexistent node is passed to rb_erase()?
>> Can anybody please direct me, how to investigate further into this problem?
>
> For one, provide the kernel version you're trying to boot. Secondly,
> it's much easier to read backtraces when they're not mangled.
>
>
