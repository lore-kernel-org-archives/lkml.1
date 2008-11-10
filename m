Return-Path: <linux-kernel-owner+w=401wt.eu-S1755143AbYKJKGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143AbYKJKGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 05:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbYKJKFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 05:05:54 -0500
Received: from hera.kernel.org ([140.211.167.34]:51648 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbYKJKFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 05:05:53 -0500
Message-ID: <49180771.1050106@kernel.org>
Date: Mon, 10 Nov 2008 02:05:37 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] sparse_irq aka dyn_irq
References: <4913F9AA.80500@kernel.org> <20081107084240.GG4435@elte.hu> <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu> <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu> <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com> <20081110094033.GL22392@elte.hu> <20081110015511.453a801e.akpm@linux-foundation.org> <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu>
In-Reply-To: <20081110100329.GA19970@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yinghai@kernel.org> wrote:
> 
>> Andrew Morton wrote:
>>> On Mon, 10 Nov 2008 10:40:33 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>>>
>>>>>>> @@ -987,6 +988,8 @@ void __init mem_init(void)
>>>>>>>
>>>>>>>       set_highmem_pages_init();
>>>>>>>
>>>>>>> +     after_bootmem = 1;
>>>>>> this hack can go away once we have a proper percpu_alloc() that can be
>>>>>> used early enough.
>>>>> where is that fancy patch? current percpu_alloc(), will keep big 
>>>>> pointer in array..., instead of put that pointer in percpu_area
>>>>>
>>>>> 64bit has that after_bootmem already.
>>>> or at least introduce a "bootmem agnostic" allocator instead of 
>>>> open-coding the after_bootmem flag.
>>>>
>>>> Something like:
>>>>
>>>>   early_kzalloc()
>>>>
>>>> ?
>>>>
>>>> Andrew, any preferences?
>>> My mind reading ain't what it was, and this after_bootmem flag is
>>> write-only in this patch.
>>>
>>> So what's all this about?
>> if i use alloc_bootmem to get some memory, and later after_bootmem, 
>> can I use kfree to free it?
> 
> hm, no. If we used alloc_bootmem(), then we must not free it after 
> after_bootmem has been set.

ok, let keep irq_desc for legacy irqs not movable...

YH
