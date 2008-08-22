Return-Path: <linux-kernel-owner+w=401wt.eu-S1753798AbYHVQmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798AbYHVQmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 12:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbYHVQmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 12:42:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39565 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYHVQmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 12:42:22 -0400
Message-ID: <48AEEC4F.3060003@zytor.com>
Date: Fri, 22 Aug 2008 09:41:51 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "H. Peter Anvin" <hpa@kernel.org>, Dave Jones <davej@redhat.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: latest -git: WARNING: at arch/x86/kernel/ipi.c:123	send_IPI_mask_bitmask+0xc3/0xe0()
References: <19f34abd0808191251x4eb61c50n13ecf7c90f0f3d9f@mail.gmail.com> <20080820013930.GN9807@one.firstfloor.org> <19f34abd0808192326jc10e758m99e76bbd5714c5b8@mail.gmail.com> <20080822003659.GA7581@redhat.com> <48AE20B8.9000204@kernel.org> <20080822022841.GG23334@one.firstfloor.org> <48AE5BB8.5080701@zytor.com> <20080822093518.GK23334@one.firstfloor.org>
In-Reply-To: <20080822093518.GK23334@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> We still need the equivalent functionality, though.  The midlayer 
>> (msr_on_cpu) may be pointless, but that doesn't change the fact that 
>> putting this functionality in the lower layer (smp_call_function_single) 
>> makes more sense.
> 
> Assuming you can actually have interrupts enabled at these point
> and be otherwise ready to do call_function_simple (e.g. cpu hotplug
> locking etc.) 
> 
> For a lot of MSR accesses in more complicated subsystems like cpufreq 
> that requires complications.  I would think for many circumstances it's 
> better to simply set affinity of the thread before at a higher level.
> 
> In hindsight I think it was my mistake to ever merge that.
> I admit I never liked it, but just merged it because I wasn't able
> to come up with a strong enough counter argument back then.

Well, smp_call_function_single already does all necessary locking; it 
makes more sense for it to check that what it's about to call still 
exists while inside the lock, instead of requiring the higher layers to 
guarantee that cannot happen on it.  This is simply a matter of the cost 
of checking at this point being quite low.

	-hpa
