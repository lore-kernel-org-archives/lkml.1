Return-Path: <linux-kernel-owner+w=401wt.eu-S933179AbXK2TR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933179AbXK2TR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:17:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761678AbXK2TRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:17:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39389 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759973AbXK2TRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:17:51 -0500
Message-ID: <474F1027.2020801@zytor.com>
Date: Thu, 29 Nov 2007 11:16:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>, Andi Kleen <ak@suse.de>
CC: Chuck Ebbert <cebbert@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com> <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org> <474F01F6.2030509@zytor.com> <alpine.LFD.0.9999.0711291027070.8458@woody.linux-foundation.org> <474F08E1.2090806@zytor.com> <alpine.LFD.0.9999.0711291057320.8458@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711291057320.8458@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi, do you happen to remember the details on this?

	-hpa


Linus Torvalds wrote:
> 
> On Thu, 29 Nov 2007, H. Peter Anvin wrote:
>> Linus Torvalds wrote:
>>>> It is advantageous for user space to use the register the kernel typically
>>>> won't, in order to speed up system call entry/exit.
>>> but I'm not seeing the reason for that one. Care to comment more? (Yes,
>>> there is often a latency from segment reload to use, but the reload latency
>>> for system call exit *should* be entirely covered by the cost of doing the
>>> system call return itself, no?)
>> I do seem to recall that some processor implementations can load a NULL
>> segment faster than a non-NULL segment.  This was significant enough that we
>> wanted to use %fs in x86-64 userspace, as opposed to the original ABI which
>> used %gs both in userspace and in the kernel.
> 
> Ahh, I think you may be right for some CPUs. The zero selector is indeed 
> potentially faster to load, since it doesn't have to even bother looking 
> at the GDT/LDT.
> 
> That said, I doubt it's very noticeable. I just ran tests on both an old 
> P4 and on a more modern Core 2 machine, and for both of those the 
> performance was identical between loading a NUL selector and loading it 
> with a non-zero one.
> 
> But I could well imagine that it matters a few cycles on other CPU's. But 
> from my testing, it definitely isn't noticeable, and I think the 
> maintenance advantage of using the same segment setup would more than make 
> up for the fact that maybe some odd CPU can see a difference.
> 
> 			Linus
