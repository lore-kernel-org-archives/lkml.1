Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbXK2SX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbXK2SX6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757600AbXK2SXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:23:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54376 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbXK2SXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:23:50 -0500
Message-ID: <474F0389.5030003@zytor.com>
Date: Thu, 29 Nov 2007 10:23:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com> <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org> <474F0243.1020103@redhat.com>
In-Reply-To: <474F0243.1020103@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 11/29/2007 01:09 PM, Linus Torvalds wrote:
>>>>  	case offsetof(struct user32, regs.gs):
>>>>  		*val = child->thread.gsindex;
>>>> +		if (child == current)
>>>> +			asm("movl %%gs,%0" : "=r" (*val));
>>> Won't this return the kernel's GS instead of the user's?
>> No, %gs is untouched by the kernel, so it contains user space version, and 
>> getting the value directly from %gs looks correct.
>>
> 
> But this is x86_64, where swapgs is done on kernel entry.
> 

For i386-x86_64 sharing, getting to the user segments probably should be 
macroized.  I'm thinking something like 
get_user_[cs|ds|es|fs|gs|ss](thread) in <asm/processor.h> doing the 
appropriate thing for different configurations.

	-hpa
