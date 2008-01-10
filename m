Return-Path: <linux-kernel-owner+w=401wt.eu-S1758367AbYAJXDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758367AbYAJXDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 18:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYAJXDO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 18:03:14 -0500
Received: from ms-smtp-05.nyroc.rr.com ([24.24.2.59]:63738 "EHLO
	ms-smtp-05.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802AbYAJXDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 18:03:13 -0500
Date: Thu, 10 Jan 2008 18:02:29 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jan Kiszka <jan.kiszka@siemens.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Philippe Gerum <rpm@xenomai.org>
Subject: Re: [RFC PATCH 01/22 -v2] Add basic support for gcc profiler
 instrumentation
In-Reply-To: <478661B9.7050406@siemens.com>
Message-ID: <Pine.LNX.4.58.0801101800520.27756@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org> <20080109233042.386384204@goodmis.org>
 <478661B9.7050406@siemens.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jan 2008, Jan Kiszka wrote:
> > ===================================================================
> > --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> > +++ linux-compile-i386.git/arch/x86/kernel/mcount-wrapper.S	2008-01-09 14:10:07.000000000 -0500
> > @@ -0,0 +1,25 @@
> > +/*
> > + *  linux/arch/x86/mcount-wrapper.S
> > + *
> > + *  Copyright (C) 2004 Ingo Molnar
> > + */
> > +
> > +.globl mcount
> > +mcount:
> > +	cmpl $0, mcount_enabled
> > +	jz out
> > +
> > +	push %ebp
> > +	mov %esp, %ebp
>
> What is the benefit of having a call frame in this trampoline? We used
> to carry this in the i386 mcount tracer for Adeos/I-pipe too (it was
> derived from the -rt code), but I just successfully tested a removal
> patch. Also glibc [1] doesn't include it.

OK, I just tried this out on i386, and it works fine.

>
> > +	pushl %eax
> > +	pushl %ecx
> > +	pushl %edx
> > +
> > +	call __mcount
>
> I think this indirection should be avoided, just like the 64-bit version
> and glibc do.

I also did this too.

>
> > +
> > +	popl %edx
> > +	popl %ecx
> > +	popl %eax
> > +	popl %ebp
> > +out:
> > +	ret
>

I'll go try the updates on x86_64 now.

Thanks for the tips!

-- Steve

