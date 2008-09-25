Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYIYVyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYIYVyR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbYIYVyF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:54:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52447 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYIYVyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:54:04 -0400
Message-ID: <48DC0859.8010103@zytor.com>
Date: Thu, 25 Sep 2008 14:53:29 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.27-rc7: x86: #GP on panic?
References: <19f34abd0809241209l3a69d607v153549ee43e085e9@mail.gmail.com>	 <20080925080417.GB27048@elte.hu> <48DB5186.8060502@zytor.com>	 <19f34abd0809250707i18ded94aib177c884d4d6a3bd@mail.gmail.com>	 <19f34abd0809250820q2df15e93u43374b7317e2f7be@mail.gmail.com>	 <19f34abd0809251346r62cff1ck4730260f17e643b3@mail.gmail.com>	 <48DBF964.7070106@zytor.com> <19f34abd0809251402v13b926a1o2236ddb9e7517a65@mail.gmail.com>
In-Reply-To: <19f34abd0809251402v13b926a1o2236ddb9e7517a65@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> On Thu, Sep 25, 2008 at 10:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> Seems like an external interrupt happened and was delivered after the sti?
>>>
>>> Hm. I guess it smells like a qemu bug since it's rather easily
>>> reproducible here and sounds strange that nobody else saw it. Is qemu
>>> 0.9.1.
>>>
>> Yes, but there shouldn't be any external interrupts that could turn into  a
>> divide error.  It really smells like a Qemu problem -- possibly even a Qemu
>> miscompile -- to me.
>>
>> Does it reproduce in KVM?
> 
> I have no computer that can do KVM, sorry :-(
> 
> Stack trace contains IO_APIC functions, so it seems that maybe the
> emulated IOAPIC is trying to (erroneously) deliver an int 0 (for some
> reason)? But I don't know, that's just speculation which can be done
> better by others, so I will stop now :-)
> 

I suspect it's a problem in Qemu's IOAPIC model, but it's hard to know 
for sure.

	-hpa
