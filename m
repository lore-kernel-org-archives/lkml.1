Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbZJLJab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbZJLJab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbZJLJaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:30:30 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:26669 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbZJLJa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:30:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pT3tauK+VhuZJQFdZX+1VQc01zRRr87DL/kdJEhSm4xkNyY9hB3WPwSCoJQV6IrxgF
         krYFr+YVoBCWa3lMjhhBV6KO0Wcq6eZaedQfkQMrxVBBG4KfVKEZcuMF60lWQU5h9hDt
         +KXI7LC5B7tXlBaq2XBzEJf1VVTfcj9ndKaOY=
Date: Mon, 12 Oct 2009 17:29:18 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.32-rc4
Message-ID: <20091012132917.GA4900@x200>
References: <alpine.LFD.2.01.0910111446410.3438@localhost.localdomain>
 <20091012082950.GA2270@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091012082950.GA2270@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 10:29:50AM +0200, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Alexey Dobriyan (2):
> >       headers: remove sched.h from interrupt.h
> 
> This commit broke the -rc4 build in numerous ways on x86:
> 
>   drivers/pci/hotplug/cpqphp.h: In function ???wait_for_ctrl_irq???:
>   drivers/pci/hotplug/cpqphp.h:730: error: implicit declaration of function ???signal_pending???
> 
>   drivers/char/rtc.c: In function 'rtc_interrupt':
>   drivers/char/rtc.c:271: error: 'TASK_INTERRUPTIBLE' undeclared (first use in this function)
>   drivers/char/rtc.c:271: error: (Each undeclared identifier is reported only once
> 
> (I'll send fixes for the build failures as followups to this mail.)
> 
> Beyond being buggy there's two workflow problems with the commit.
> 
> Firstly, the commit log concentrates on the m68k situation while in 
> reality more testing on x86 would have been much more important to the 
> end result. If we break m68k with a header cleanup it's far less of a 
> practical problem than if we break thousands of x86 boxes. I find this 
> kind of artificially inflated focus on cross-testing (without properly 
> weighting platforms) harmful.
> 
> Secondly, i'm wondering why the original mail to lkml:
> 
>   Date: Wed, 7 Oct 2009 17:09:06 +0400
>   From: Alexey Dobriyan <adobriyan@gmail.com>
>   To: torvalds@linux-foundation.org
>   Subject: [PATCH] headers: remove sched.h from interrupt.h
>   Cc: linux-kernel@vger.kernel.org
> 
> Wasnt Cc:-ed to the affected maintainers?

To whom? All 42 of them?

> As a result the patch wasnt 
> tested by any maintainer tree before it was sent to Linus. The change is 
> good but obviously needs to be done more carefully, there are a _lot_ of 
> hidden header dependencies in the kernel, especially related to sched.h.
> 
> We are doing regular header cleanup patches in -tip and have the 
> infrastructure to test them properly as well, so this change could have 
> been done via either the scheduler tree and the interrupt tree. We also 
> cross-test to all other architectures.

Me too.

This patch was tested on ~300 configs (allmodconfigs and defconfigs) _and_
randconfigs on i386 and x86_64. I'm sorry I don't have more compile time.

> Alexey, could you please Cc: affected maintainers in the future, so that 
> we can avoid such problems?

Probably.

The problem I have with -tip is that god knows what's in there,
so any header dependency removed might very well be unrelated to mainline.
