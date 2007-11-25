Return-Path: <linux-kernel-owner+w=401wt.eu-S1757481AbXKYW7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbXKYW7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2007 17:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756040AbXKYW7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Nov 2007 17:59:12 -0500
Received: from mx1.redhat.com ([66.187.233.31]:38298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755790AbXKYW7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2007 17:59:11 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 01/27] ptrace: arch_has_single_step
In-Reply-To: Christoph Hellwig's message of  Sunday, 25 November 2007 22:22:05 +0000 <20071125222205.GA1597@infradead.org>
References: <20071125215507.4B89226F8C5@magilla.localdomain>
	<20071125222205.GA1597@infradead.org>
X-Zippy-Says: I hope you millionaires are having fun!  I just invested half your
    life savings in yeast!!
Message-Id: <20071125225903.9A3AA26F8C5@magilla.localdomain>
Date: Sun, 25 Nov 2007 14:59:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Why should arch_has_single_step be a function-like macro?  I can't thing
> of a case were this wouln't be a compile-time constant.  And given that
> this is hopefully a transitionary ifdef because eventually all architectures
> would use the generic code I'd prefer ifdefs in the code that clearly mark
> this as transitional in this case.

I'm not sure it's true that there is no machine where some chips support
single-step and others don't, though I do think it's true that no arch code
has a conditional like this now.  In the case of block-step (in later
patches), is is the case that a run-time check for availability of the
hardware feature comes up (on some x86 configurations).  So a main reason
is to keep the two parallel macros with the same style and semantics.

> > +static inline void user_enable_single_step(struct task_struct *task)
> 
> > +static inline void user_disable_single_step(struct task_struct *task)
> 
> And I don't think these should be provided at all as generic stubs. If
> an arch doesn't use the generic code it simply shouldn't compile the
> code using this.

The code compiles away completely with if (0)'s.  I did it this way to
avoid more #ifdef's in the generic ptrace code.  Previous patch reviews
I've read (including ones from you) have said to use header-defined stubs
in #ifdef and unconditional calls in the code.  Please be explicit in
proposing the specific alternatives you would prefer.

> Whats the reason for the user_ prefix btw, most architectures seems to
> have these functions already anyway, just without the user_ prefix.

The arch's are not consistent now, so I chose a new scheme to harmonize
on.  I think the "set_foo" names are a bit too nonspecific-sounding,
especially given that we do have other things kicking around that use
single-step functionality in kernel mode.  Also, I plan to submit some
more work harmonizing the arch-specific access to the user-mode view of
machine state, and a uniform prefix for the new, reliably coherent,
documented set of internal interfaces just seems like the right thing to
do.  (I don't really care enough to argue about the names for functions.
Anyone who, for some reason I cannot fathom, cares enough to be contrary
about the subject, is welcome to set the standard.)


Thanks,
Roland
