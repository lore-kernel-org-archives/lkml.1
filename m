Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbYKJTra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbYKJTra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 14:47:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751300AbYKJTrV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 14:47:21 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:45921 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbYKJTrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 14:47:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=dV9MG2zIi6gsjKJMZVtuc8J9mpkSjaFJmj7O+y/6K6Uio/gnwgX/WE+5Jnh55cNLe6
         /wyYPzrO0SBhii+MtyAItseKKRTQrWLFUKjKOPsZluHHOPbqVH2Na+LeeJLpgQyshhwR
         G7Q0LbLMCKQtGvtAIORMRN6cmoyy64fdsfr0c=
Message-ID: <86802c440811101147v329b8d92u6023c57ecf3a9da1@mail.gmail.com>
Date: Mon, 10 Nov 2008 11:47:20 -0800
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [RFC PATCH] sparse_irq aka dyn_irq
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20081110100959.GA22927@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <491434FB.2050904@kernel.org> <49168BD3.5010204@kernel.org>
	 <20081109073813.GA17180@elte.hu>
	 <86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>
	 <20081110094033.GL22392@elte.hu>
	 <20081110015511.453a801e.akpm@linux-foundation.org>
	 <4918065A.6050402@kernel.org> <20081110100329.GA19970@elte.hu>
	 <49180771.1050106@kernel.org> <20081110100959.GA22927@elte.hu>
X-Google-Sender-Auth: 26431a8e95691173
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2008 at 2:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> Ingo Molnar wrote:
>> > * Yinghai Lu <yinghai@kernel.org> wrote:
>> >
>> >> Andrew Morton wrote:
>> >>> On Mon, 10 Nov 2008 10:40:33 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>> >>>
>> >>>>>>> @@ -987,6 +988,8 @@ void __init mem_init(void)
>> >>>>>>>
>> >>>>>>>       set_highmem_pages_init();
>> >>>>>>>
>> >>>>>>> +     after_bootmem = 1;
>> >>>>>> this hack can go away once we have a proper percpu_alloc() that can be
>> >>>>>> used early enough.
>> >>>>> where is that fancy patch? current percpu_alloc(), will keep big
>> >>>>> pointer in array..., instead of put that pointer in percpu_area
>> >>>>>
>> >>>>> 64bit has that after_bootmem already.
>> >>>> or at least introduce a "bootmem agnostic" allocator instead of
>> >>>> open-coding the after_bootmem flag.
>> >>>>
>> >>>> Something like:
>> >>>>
>> >>>>   early_kzalloc()
>> >>>>
>> >>>> ?
>> >>>>
>> >>>> Andrew, any preferences?
>> >>> My mind reading ain't what it was, and this after_bootmem flag is
>> >>> write-only in this patch.
>> >>>
>> >>> So what's all this about?
>> >> if i use alloc_bootmem to get some memory, and later after_bootmem,
>> >> can I use kfree to free it?
>> >
>> > hm, no. If we used alloc_bootmem(), then we must not free it after
>> > after_bootmem has been set.
>>
>> ok, let keep irq_desc for legacy irqs not movable...
>
> most of them are movable right now, correct? If we restrict their
> movability now that might surprise existing usecases negatively.

i mean irq_desc will not be allocated one one on new cpus...

YH
