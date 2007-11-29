Return-Path: <linux-kernel-owner+w=401wt.eu-S932788AbXK2Sdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788AbXK2Sdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757721AbXK2SdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:33:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42753 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759614AbXK2SdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:33:24 -0500
Date: Thu, 29 Nov 2007 10:31:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Chuck Ebbert <cebbert@redhat.com>, Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current
 task
In-Reply-To: <474F01F6.2030509@zytor.com>
Message-ID: <alpine.LFD.0.9999.0711291027070.8458@woody.linux-foundation.org>
References: <20071129003849.428E026F8E7@magilla.localdomain> <20071129004222.E49AD26F8E7@magilla.localdomain> <474EF824.3020806@redhat.com> <alpine.LFD.0.9999.0711290958110.8458@woody.linux-foundation.org> <474F01F6.2030509@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 Nov 2007, H. Peter Anvin wrote:
> 
> The kernel uses %fs in 32-bit mode and %gs in 64-bit mode.

Yeah, thanks for reminding me about this particular insanity.

We should just make the kernel always use %gs for the percpu data. On 
32-bit x86 there really is no reason to use %fs over %gs, other than the 
purely historical one, and the fact that "f" is alphabetically before "g", 
so it's the one you use first if you have no other preferences.

That way we can more easily share code, if the rules for fs/gs are the 
same for 32-bit/64-bit code.

However, you also say:

> It is advantageous for user space to use the register the kernel 
> typically won't, in order to speed up system call entry/exit.

but I'm not seeing the reason for that one. Care to comment more? (Yes, 
there is often a latency from segment reload to use, but the reload 
latency for system call exit *should* be entirely covered by the cost of 
doing the system call return itself, no?)

			Linus
