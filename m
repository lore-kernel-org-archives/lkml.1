Return-Path: <linux-kernel-owner+w=401wt.eu-S934427AbXK2XBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934427AbXK2XBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 18:01:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762564AbXK2XBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 18:01:36 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759343AbXK2XBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 18:01:35 -0500
Message-ID: <474F449B.70603@redhat.com>
Date: Thu, 29 Nov 2007 18:00:43 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
References: <20071129003849.428E026F8E7@magilla.localdomain>	<20071129004222.E49AD26F8E7@magilla.localdomain>	<474EF824.3020806@redhat.com> <20071129222157.1120B26F8E7@magilla.localdomain>
In-Reply-To: <20071129222157.1120B26F8E7@magilla.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2007 05:21 PM, Roland McGrath wrote:
>>>  	case offsetof(struct user32, regs.gs):
>>>  		*val = child->thread.gsindex;
>>> +		if (child == current)
>>> +			asm("movl %%gs,%0" : "=r" (*val));
>> Won't this return the kernel's GS instead of the user's?
> [...]
>> But this is x86_64, where swapgs is done on kernel entry.
> 
> As I understand it, and from what the documentation I have says, swapgs has
> nothing to do with the %gs selector.  It affects the "GS base register",
> i.e. the MSR.
> 

Yep, I confused the GS selector with the base address in the descriptor.
