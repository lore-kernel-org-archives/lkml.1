Return-Path: <linux-kernel-owner+w=401wt.eu-S932080AbZEKXBN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080AbZEKXBN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 19:01:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760756AbZEKXAw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 19:00:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760409AbZEKXAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 19:00:51 -0400
Date: Mon, 11 May 2009 15:52:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: Masami Hiramatsu <mhiramat@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, systemtap@sources.redhat.com,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH -rc] [BUGFIX] x86: fix kernel_trap_sp()
In-Reply-To: <20090511224001.GA8198@elte.hu>
Message-ID: <alpine.LFD.2.01.0905111547000.3586@localhost.localdomain>
References: <20090511210300.17332.67549.stgit@localhost.localdomain> <alpine.LFD.2.01.0905111512240.3586@localhost.localdomain> <20090511224001.GA8198@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 12 May 2009, Ingo Molnar wrote:
> 
> yeah, this is cleaner and probably a tad faster.

Well, I don't care about the 'faster' part per se, but I could actually 
see some case where a kernel-only version did some pointer dereference 
that was invalid for the user version, and could oops, so putting it 
inside the code that explicitly tests that it's not user-or-vm seems like 
conceptually the right thing to do.

Of course, in this case it's the other way around - it's the non-kernel 
version that does a dereference, and it just so happens to be safe (but 
return an invalid pointer) when the trap was in kernel mode.  So the 
argument is pretty theoretical, but I think it's cleaner.

> One small detail:
> 
> > +	return (unsigned long)(&regs->sp);
> 
> the original commit had:
> 
> > +	return (unsigned long)&regs->sp;

Ok, that's just because I didn't actually apply the original patch, I 
just rewrote it entirely, and for some reason I put parenthesis around the 
expression. You're right that it doesn't matter, and either is fine.  I 
don't really care, I suspect I add the parenthesis just because I don't 
even want to have to think about the proper operator precedence rules.

So pick whichever version.

			Linus
