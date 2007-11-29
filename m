Return-Path: <linux-kernel-owner+w=401wt.eu-S932965AbXK2SSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbXK2SSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:18:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932766AbXK2SSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:18:03 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933074AbXK2SSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:18:00 -0500
Message-ID: <474F0243.1020103@redhat.com>
Date: Thu, 29 Nov 2007 13:17:39 -0500
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com> <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2007 01:09 PM, Linus Torvalds wrote:
>>>  	case offsetof(struct user32, regs.gs):
>>>  		*val = child->thread.gsindex;
>>> +		if (child == current)
>>> +			asm("movl %%gs,%0" : "=r" (*val));
>> Won't this return the kernel's GS instead of the user's?
> 
> No, %gs is untouched by the kernel, so it contains user space version, and 
> getting the value directly from %gs looks correct.
> 

But this is x86_64, where swapgs is done on kernel entry.

