Return-Path: <linux-kernel-owner+w=401wt.eu-S1757793AbZLIV6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbZLIV6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 16:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757156AbZLIV6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 16:58:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757077AbZLIV6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 16:58:49 -0500
Date: Wed, 9 Dec 2009 13:58:33 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickens <hugh@veritas.com>
Subject: Re: [GIT PULL] x86/paravirt for v2.6.33
In-Reply-To: <4B1FE9FD.3030407@goop.org>
Message-ID: <alpine.LFD.2.00.0912091354190.3560@localhost.localdomain>
References: <20091203210913.GA24351@elte.hu> <alpine.LFD.2.00.0912081329460.3560@localhost.localdomain> <4B1FE9FD.3030407@goop.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 9 Dec 2009, Jeremy Fitzhardinge wrote:

> On 12/08/09 13:34, Linus Torvalds wrote:
> > I do _not_ want to add any more task_pt_regs() crap, please.
> > 
> > Why? It's wrong for at least vm86 mode (and from kernel system calls).
> >    
> 
> Would the stack frame version work in these cases?

It would "work" in the sense that at least it wouldn't corrupt the "outer" 
stack frame - it would only change the inner one. For vm86 mode, that 
would actually matter (iopl is meaningful), but as Peter also said, I 
don't think we actually allow direct system calls from vm86 mode.

For me it's actually more of a conceptual complaint: I really think 
'task_pt_regs()' is only reliable for ptrace and is simply _wrong_ in 
other situations. On other architectures, you literally need to set up the 
stack _differently_ on the signal handling path - which is what ptrace 
does - than on regular system call paths.

So conceptually, the system call stack layout is simply _different_ than 
the ptrace stack. And I'd hate to have x86 code that teaches people to do 
things that really don't work in general.

			Linus
