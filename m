Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbZEHLMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbZEHLMi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 07:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753229AbZEHLM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 07:12:28 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:43810 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbZEHLM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 07:12:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WpwVEIlbrpGLvqCeQ4I2NW6QvESo0iRHXWm/Zo7Hb4WkApussaEgcKyFZdshxdIjPk
         d5lspUL1GJM2x6Rk01jQrZ4iwa7vPo0L/N6mbn9AgRoslIR7u6Hp2FfAvHQ3Y+rb2XF5
         P/Ko43edrkNTapdylXcHqaJzGwbIdwJj1sbR8=
Date: Fri, 8 May 2009 13:12:23 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: Adam Langley <agl@google.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, markus@google.com
Subject: Re: [RFC 1/1] seccomp: Add bitmask of allowed system calls.
Message-ID: <20090508111222.GC6417@nowhere>
References: <396556a20805301217k293e5718h6bbf02b234897235@europa> <20090507221447.GE28770@elte.hu> <a84d7bc60905071534l1e65f216mfd9330e93e4da4e2@mail.gmail.com> <20090507230021.GC6472@nowhere> <1241760745.9416.37.camel@tropicana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241760745.9416.37.camel@tropicana>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 12:32:25AM -0500, Tom Zanussi wrote:
> On Fri, 2009-05-08 at 01:00 +0200, Frederic Weisbecker wrote:
> > On Thu, May 07, 2009 at 03:34:58PM -0700, Adam Langley wrote:
> > > > That assessment is incorrect, there's no difference between safety
> > > > here really.
> > > >
> > > > LSM cannot magically inspect user-space memory either when multiple
> > > > threads may access it. The point would be to define filters for
> > > > system call _arguments_, which are inherently thread-local and safe.
> > > 
> > > If I hook security_operations.socket_connect, I can validate the struct
> > > sockaddr after the final copy_from_user. However, since the sockaddr lives in
> > > userspace memory, if I try and validate it from ftrace SYSCALL_ENTER, I can't
> > > know that it won't change before sys_connect reads it again.
> > > 
> > > Because of that, there are system calls which an LSM hook can safely accept
> > > that an ftrace hook cannot. However, as you point out, any arguments passed in
> > > registers are inheriently safe and these may be sufficiently powerful.
> > > 
> > > > There are two problems with the bitmap scheme, which i also
> > > > suggested in a previous thread but then found it to be lacking:
> > > >
> > > > 1) enumeration: you define a bitmap. That will be problematic
> > > >   between compat and native 64-bit (both have different syscall
> > > >   vectors).
> > > 
> > > I /think/ it works out, but I've been bitten before with subtle 32/64 bit
> > > compat issues and accept that it's a bit ugly.
> > > 
> > > > 2) flexibility. It's an on/off selection per syscall. With the
> > > >   filter we have on, off, or filtered. That's a _whole_ lot more
> > > >   flexible.
> > > 
> > > Absolutely.
> > > 
> > > Is there a git tree that I can pull this parsing code from?
> > > (git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> > > maybe?). I can patch in the seccomp-on-ftrace work and try building the
> > > filtering on top of that. I'll see how it turns out anyway.
> > 
> > 
> > Hi,
> > 
> > The most uptodate one is:
> > git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> > on the tracing/filters topic.
> > 
> > See kernel/trace/trace_events_filter.c
> > 
> > You might want to reuse some current syscall tracing facility.
> > An automated resolution table is built on bootime, you can look
> > at the end of arch/x86/kernel/ftrace.c
> > 
> > This table links each syscalls nr to the matching attribute entry of syscall
> > in which you can find:
> > 
> > - parameters names
> > - parameters types
> > - syscall name
> > 
>  
> I guess it would be easier for seccomp to make use of the filtering and
> reuse the syscall tracing facility if we added filtering to the syscall
> tracer first.  It would be useful to do for the syscall tracer anyway,
> regardless of whether it (or something similar) ended up being used by
> seccomp.
> 
> Frederic, did you have any plans for that?  If not, I can take a look
> when I get the chance...
> 
> Tom



You're totally right!
Well, I will not have enough time for that until next week-end. So
if you have free slots for that, don't hesitate :)

Thanks!

Frederic.


> 
> > You can look at the hooks in include/linux/syscall.h:
> > The sections inside
> > #ifdef CONFIG_FTRACE_SYSCALLS
> > 
> > Well, it's a bit insane to read, so you can also look
> > at include/trace/syscall.h and kernel/trace/trace_syscalls.c and
> > see how it is used and how it could be reused.
> > 
> > 
> > Thanks,
> > Frederic.
> > 
> 

