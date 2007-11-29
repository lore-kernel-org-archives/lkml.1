Return-Path: <linux-kernel-owner+w=401wt.eu-S933725AbXK2WWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725AbXK2WWw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:22:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761548AbXK2WWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:22:40 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754753AbXK2WWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:22:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Chuck Ebbert <cebbert@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH x86/mm 6/6] x86-64 ia32 ptrace get/putreg32 current task
In-Reply-To: Chuck Ebbert's message of  Thursday, 29 November 2007 12:34:28 -0500 <474EF824.3020806@redhat.com>
References: <20071129003849.428E026F8E7@magilla.localdomain>
	<20071129004222.E49AD26F8E7@magilla.localdomain>
	<474EF824.3020806@redhat.com>
X-Zippy-Says: Now, my ENTIRE LIFE is flashing before my EYES as I park my DODGE
    DART in your EXXON service area for a COMPLETE LUBRICATION!!
Message-Id: <20071129222157.1120B26F8E7@magilla.localdomain>
Date: Thu, 29 Nov 2007 14:21:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >  	case offsetof(struct user32, regs.gs):
> >  		*val = child->thread.gsindex;
> > +		if (child == current)
> > +			asm("movl %%gs,%0" : "=r" (*val));
> 
> Won't this return the kernel's GS instead of the user's?
[...]
> But this is x86_64, where swapgs is done on kernel entry.

As I understand it, and from what the documentation I have says, swapgs has
nothing to do with the %gs selector.  It affects the "GS base register",
i.e. the MSR.


Thanks,
Roland
