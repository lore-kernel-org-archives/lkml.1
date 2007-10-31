Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbXJaLjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbXJaLjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 07:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbXJaLjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 07:39:45 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:38965 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbXJaLjo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 07:39:44 -0400
Date: Wed, 31 Oct 2007 07:39:05 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Andi Kleen <andi@firstfloor.org>
cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [PATCH] dump_stack on panic
In-Reply-To: <20071031111724.GB27084@one.firstfloor.org>
Message-ID: <Pine.LNX.4.58.0710310729130.13523@gandalf.stny.rr.com>
References: <1193788979.5623.43.camel@localhost.localdomain>
 <p73odeg2l9v.fsf@bingen.suse.de> <20071031081513.GB3810@infradead.org>
 <20071031104147.GA27084@one.firstfloor.org> <Pine.LNX.4.58.0710310653190.12724@gandalf.stny.rr.com>
 <20071031111724.GB27084@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--
On Wed, 31 Oct 2007, Andi Kleen wrote:

> > Thinking about this more. Of the Linux users I asked, they think a kernel
> > panic is a bug in the kernel anyway (or at least something in the kernel
> > went wrong).  So if panics will point users to the kernel anyway, then why
> > leave out possible vital information from those panics that were caused by
> > an actual kernel bug.
>
> On a no root found panic (which are likely the majority of all panics)
> the stack dump is about 100% useless.
>
> I also think it's a very bad idea to add them to machine checks again
> for psychological reasons.
>

I believe that kernel programmers are horrible psychologists.

Doing a quick search yields:

find .  -name "*.c" ! -type d  | xargs grep  "panic(" |wc -l
1143

So we have 1143 uses of panic. I'll grant you that the most common
occurrence is the unable to mount root. But I don't think users are less
likely to blame the kernel when they see a dump or just see a panic. A
panic usually implies (to me anyway) something went wrong and the kernel
can't cope.

But by not having a dump, we lose out on real bugs that are stopped by the
panics. The most common one that I come across is a fault in the interrupt
handler of some device. This produces a panic screaming killing an
interrupt. But without a trace, we have no idea where that bug occurred.

So do we really want to play shrink and say it's better to leave out the
back trace because we might scare users, or should we keep it for the few
times it really does help?

IMHO I believe we should do the dump_stack now, and come up with another
solution to the mount root panic.

-- Steve

