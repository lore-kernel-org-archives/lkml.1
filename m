Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab0BRPAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 10:00:20 -0500
Received: from mtagate4.de.ibm.com ([195.212.17.164]:47938 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab0BRPAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 10:00:17 -0500
Date: Thu, 18 Feb 2010 16:00:14 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "David S . Miller" <davem@davemloft.net>,
       Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 2/3] tracing/kprobes: Make Kconfig dependencies generic
Message-ID: <20100218150014.GA6593@osiris.boeblingen.de.ibm.com>
References: <1266491616-6270-1-git-send-regression-fweisbec@gmail.com>
 <1266491616-6270-3-git-send-regression-fweisbec@gmail.com>
 <8bd0f97a1002180318g6ce70480x571d7d332239d68b@mail.gmail.com>
 <20100218120944.GA2406@osiris.boeblingen.de.ibm.com>
 <8bd0f97a1002180412x6cc4f280u5444f013c6e3b670@mail.gmail.com>
 <20100218123453.GA5136@nowhere>
 <20100218132521.GB2406@osiris.boeblingen.de.ibm.com>
 <8bd0f97a1002180601i60c5eaa4p7639091c5b617702@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a1002180601i60c5eaa4p7639091c5b617702@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 09:01:12AM -0500, Mike Frysinger wrote:
> On Thu, Feb 18, 2010 at 08:25, Heiko Carstens wrote:
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -123,6 +123,10 @@ config USE_GENERIC_SMP_HELPERS
> >
> >  config HAVE_REGS_AND_STACK_ACCESS_API
> >        bool
> > +       help
> > +         This symbol should be selected by an architecure if it supports
> > +         the API needed to access registers and stack entries from pt_regs.
> > +         For example the kprobes-based event tracer needs this API.
> 
> a bit vague ... arent there headers/functions people could look at ?
> perhaps you're talking about the regset functions (which is an API to
> access registers in pt_regs) ?  or you're talking about asm/syscall.h
> (which is an API to access registers in pt_regs) ?
> 
> i'm not asking to be a pain, i'm asking because i really havent a
> clue.  if i wanted to add support for this stuff to the Blackfin arch,
> i wouldnt know where to start.  even after reading this help i'd fall
> back to grepping arch/x86/ and trying to divine a starting point from
> there.

git show b1cf540f would be your friend. That's why I pointed out the
id in the changelog.
I have no idea what your workflow is, but doing something like
gitk v2.6.32..v2.6.33-rc1 arch/<whatever>/
is what I do to figure out what other archs did during the merge
window and if there's something that needs an arch backend on s390.
This reveals also bug fixes that need to be ported from time to time.
That worked pretty well for me during the last few years.
