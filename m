Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758479Ab0BRPnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:43:11 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:1756 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab0BRPnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:43:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Xeyol9d4H8P/tR5m5HJzi/u9Nd6te30xuZ7fAu2jQFptQ282LdESapxU7QKEwTgazt
         FMIM3xgy1QIVp0BSzGj1a0mXbARC4j93J4T0TmgQ89A4ulO2ymvGhTUqcSzCvpFjlbTL
         iQk89Ww8qo1XweeETzEYaV4fWH/fwGHklLUzE=
Date: Thu, 18 Feb 2010 16:43:02 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
Message-ID: <20100218154259.GC855@nowhere>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com> <1266491616-6270-3-git-send-regression-fweisbec@gmail.com> <8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com> <20100218120944.GA2406@osiris.boeblingen.de.ibm.com> <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com> <20100218123453.GA5136@nowhere> <20100218132521.GB2406@osiris.boeblingen.de.ibm.com> <8bd0f97a1002180601i60c5eaa4p7639091c5b617702@mail.gmail.com> <20100218145055.GB855@nowhere> <8bd0f97a1002180702k12db615pa3096b273ce2c222@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a1002180702k12db615pa3096b273ce2c222@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 10:02:52AM -0500, Mike Frysinger wrote:
> On Thu, Feb 18, 2010 at 09:50, Frederic Weisbecker wrote:
> > On Thu, Feb 18, 2010 at 09:01:12AM -0500, Mike Frysinger wrote:
> >> > --- a/arch/Kconfig
> >> > +++ b/arch/Kconfig
> >> > @@ -123,6 +123,10 @@ config USE_GENERIC_SMP_HELPERS
> >> >
> >> >  config HAVE_REGS_AND_STACK_ACCESS_API
> >> >        bool
> >> > +       help
> >> > +         This symbol should be selected by an architecure if it supports
> >> > +         the API needed to access registers and stack entries from pt_regs.
> >> > +         For example the kprobes-based event tracer needs this API.
> >>
> >> a bit vague ... arent there headers/functions people could look at ?
> >> perhaps you're talking about the regset functions (which is an API to
> >> access registers in pt_regs) ?  or you're talking about asm/syscall.h
> >> (which is an API to access registers in pt_regs) ?
> >>
> >> i'm not asking to be a pain, i'm asking because i really havent a
> >> clue.  if i wanted to add support for this stuff to the Blackfin arch,
> >> i wouldnt know where to start.  even after reading this help i'd fall
> >> back to grepping arch/x86/ and trying to divine a starting point from
> >> there.
> >
> > If an arch support kprobes, it just needs to select
> > HAVE_REGS_AND_STACK_ACCESS_API to figure out quickly what is missing,
> > as gcc will barf every missing clues you need.
> 
> so should this new Kconfig option have an appropriate depends on
> KPROBES or something ?



No, kprobes events need KPROBES and the above one, but KPROBES
alone can perfectely work without HAVE_REGS_AND_STACK_ACCESS_API.


 
> > For now it is stored is asm/ptrace.h, but that might be split in
> > the future, especially as ptrace has initially nothing related to
> > that. A documentation that deals with filenames or API enumerations
> > tend to be incidentally async with API evolutions.
> 
> i dont expect there to be per-function documentation here ... such
> things below in the header files themselves (linux/regset.h is an
> example of how to approach this).  but having a tip of reading a file
> or two (like HAVE_ARCH_TRACEHOOK) doesnt bit rot nearly as often.  if
> the common API expected of headers hasnt yet been split, then i guess
> not much left to be done here.



Yeah. Once it's split up from ptrace, we can think about a more dedicated
header file and then it can be reasonable to put the header filename in the
documentation. But not for now IMHO.

