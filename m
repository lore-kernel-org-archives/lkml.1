Return-Path: <linux-kernel-owner+w=401wt.eu-S1754860AbYHZHBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbYHZHBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 03:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYHZHB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 03:01:28 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:20822 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbYHZHB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 03:01:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LVUWDuCjOhNOOPMS0wm3Nonc81ygPz9U9aTY75CEedSn03zA17Qasc+fb1qK3yQaDY
         0EmUtyp7t5dDXleUQ2KgheKzBYs4vi4Cjann1smF1tg5evU4we1ynDBU3BfhrOwvHp2m
         EaRKy9cZT9LLvOH2y8dTH939XfNGu3/OMcFOk=
Message-ID: <19f34abd0808260001h58077b04j4b174eeba184d70f@mail.gmail.com>
Date: Tue, 26 Aug 2008 09:01:26 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [-mmotm] BUG: scheduling while atomic: swapper
Cc: "Ryan Hope" <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Mike Travis" <travis@sgi.com>
In-Reply-To: <20080825233729.816cf182.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48f7fe350808251909g26207e7agdda6408c0b46a1ed@mail.gmail.com>
	 <20080825233729.816cf182.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 8:37 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 25 Aug 2008 22:09:25 -0400 "Ryan Hope" <rmh3093@gmail.com> wrote:
>
>> BUG: scheduling while atomic: swapper/1/0x00000002
>> Modules linked in:
>> Pid: 1, comm: swapper Tainted: G        W 2.6.27-rc4-zenmmotm1 #4
>>  [<c057a0c7>] schedule+0x287/0x6d0
>>  [<c03672e6>] vsnprintf+0x3a6/0x6c0
>>  [<c057a92d>] schedule_timeout+0x7d/0xb0
>>  [<c021e0c8>] __wake_up+0x38/0x50
>>  [<c057a74a>] wait_for_common+0x8a/0x130
>>  [<c0220ab0>] default_wake_function+0x0/0x10
>>  [<c0237743>] call_usermodehelper_exec+0xc3/0xf0
>>  [<c0362ede>] kobject_uevent_env+0x37e/0x3a0
>>  [<c03d5921>] device_add+0x551/0x630
>>  [<c03d5ac3>] device_create_vargs+0xb3/0xd0
>>  [<c06ccc47>] microcode_intel_module_init+0x0/0x39
>>  [<c03d5b0b>] device_create+0x2b/0x30
>>  [<c0385f2e>] misc_register+0xbe/0x170
>>  [<c02137d1>] microcode_init+0x21/0xf0
>>  [<c0201336>] do_one_initcall+0x26/0x170
>>  [<c021e0c8>] __wake_up+0x38/0x50
>>  [<c0237c98>] insert_work+0x48/0x50
>>  [<c02380a5>] __queue_work+0x25/0x40
>>  [<c023812a>] queue_work_on+0x3a/0x50
>>  [<c06c29bf>] kernel_init+0x170/0x251
>>  [<c06c284f>] kernel_init+0x0/0x251
>>  [<c0204157>] kernel_thread_helper+0x7/0x10
>>  =======================
>
> As a mad guess, I'd guess that someone changed get_online_cpus() so
> that disables preemption (with a suitable config combination, perhaps).
> Which would cause microcode_init()'s sysdev_driver_register() to run
> in atomic context.
>
> But that's just a guess - I can't immediately see any change in there
> which does this.  Ingo, any theories?

Looks like the kernel was W-tainted already... so likely there was a
BUG or a WARNING even before this. And I think this sort of warning
can happen if a(nother) process was killed while preemption was off
(e.g. a BUG() at the wrong moment). Ryan?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
