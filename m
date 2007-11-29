Return-Path: <linux-kernel-owner+w=401wt.eu-S933002AbXK2SRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933002AbXK2SRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:17:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbXK2SRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:17:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36021 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932953AbXK2SRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:17:06 -0500
Message-ID: <474F01F6.2030509@zytor.com>
Date: Thu, 29 Nov 2007 10:16:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Chuck Ebbert <cebbert@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com> <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> But this one is correct:
> 
>>>  	case offsetof(struct user32, regs.gs):
>>>  		*val = child->thread.gsindex;
>>> +		if (child == current)
>>> +			asm("movl %%gs,%0" : "=r" (*val));
>> Won't this return the kernel's GS instead of the user's?
> 
> No, %gs is untouched by the kernel, so it contains user space version, and 
> getting the value directly from %gs looks correct.
> 

Brief summary/reminder:

The kernel uses %fs in 32-bit mode and %gs in 64-bit mode.
User space TLS uses %gs in 32-bit mode and %fs in 64-bit mode.

The 64-bit kernel has to use %gs in order for SWAPGS to be available to 
it (by which time the 32-bit ABI was already fixed.)  It is advantageous 
for user space to use the register the kernel typically won't, in order 
to speed up system call entry/exit.

	-hpa
