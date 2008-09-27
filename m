Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304AbYI0SoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304AbYI0SoJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 14:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYI0Sn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 14:43:57 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41880 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753328AbYI0Sn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 14:43:56 -0400
Date: Sat, 27 Sep 2008 20:43:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: v2.6.27-rc7: x86: #GP on panic?
Message-ID: <20080927184344.GA16926@elte.hu>
References: <19f34abd0809241209l3a69d607v153549ee43e085e9@mail.gmail.com> <20080925080417.GB27048@elte.hu> <48DB5186.8060502@zytor.com> <19f34abd0809250707i18ded94aib177c884d4d6a3bd@mail.gmail.com> <19f34abd0809250820q2df15e93u43374b7317e2f7be@mail.gmail.com> <19f34abd0809251346r62cff1ck4730260f17e643b3@mail.gmail.com> <48DBF964.7070106@zytor.com> <19f34abd0809251402v13b926a1o2236ddb9e7517a65@mail.gmail.com> <48DC0859.8010103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC0859.8010103@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> Vegard Nossum wrote:
>> On Thu, Sep 25, 2008 at 10:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> Seems like an external interrupt happened and was delivered after the sti?
>>>>
>>>> Hm. I guess it smells like a qemu bug since it's rather easily
>>>> reproducible here and sounds strange that nobody else saw it. Is qemu
>>>> 0.9.1.
>>>>
>>> Yes, but there shouldn't be any external interrupts that could turn into  a
>>> divide error.  It really smells like a Qemu problem -- possibly even a Qemu
>>> miscompile -- to me.
>>>
>>> Does it reproduce in KVM?
>>
>> I have no computer that can do KVM, sorry :-(
>>
>> Stack trace contains IO_APIC functions, so it seems that maybe the
>> emulated IOAPIC is trying to (erroneously) deliver an int 0 (for some
>> reason)? But I don't know, that's just speculation which can be done
>> better by others, so I will stop now :-)
>>
>
> I suspect it's a problem in Qemu's IOAPIC model, but it's hard to know  
> for sure.

yes - it smells like it tries to deliver vector 0, after the panic code 
has deinitialized the lapic / ioapic.

	Ingo
