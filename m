Return-Path: <linux-kernel-owner+w=401wt.eu-S1758839AbZEFJim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839AbZEFJim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:38:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbZEFJiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:38:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34754 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757795AbZEFJiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:38:17 -0400
Date: Wed, 6 May 2009 11:37:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, jdike@addtoit.com,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
Message-ID: <20090506093740.GA7156@elte.hu>
References: <20090503185537.GA17071@redhat.com> <20090504184951.623CEFC32F@magilla.sf.frob.com> <20090504193016.GA17076@redhat.com> <20090504194348.BC0EBFC32F@magilla.sf.frob.com> <20090504163154.f3672a83.akpm@linux-foundation.org> <20090505230642.GA980@redhat.com> <20090506081225.GD8098@elte.hu> <20090506082300.GA16989@infradead.org> <20090506090512.GB24692@elte.hu> <20090506091115.GA24332@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506091115.GA24332@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Wed, May 06, 2009 at 11:05:12AM +0200, Ingo Molnar wrote:
> > It might be more effective if you also wrote patches and if you 
> > would shop for maintainer Acks, instead of just "pinging" people? 
> > ;-) We've already got enough would-be-managers on lkml really.
> 
> I have no interest touching tons of architectures where the 
> maintainers are much better of looking at those lowlevel bits. 
> [...]

That's a somewhat naive expectation. Currently ptrace has a low 
mindshare and an even lower know-how share, even amongst 
architecture maintainers. Much of the ptrace code has been many 
years ago and often it has been copied over from other architectures 
and has been hacked to work sort-of. There's positive exceptions for 
sure, but generally ptrace know-how is extremely limited and there's 
a lot of architectures with little proactivity.

It is far more efficient if Roland, Oleg (or you, if you are 
interested in this stuff - which you seem to be) did RFC patches and 
asked for maintainer acks, than to depend on maintainers to do it.

We have about a dozen core kernel features that still have not 
propagated to all architectures: irqflags-tracking (for lockdep), 
genirq, stacktrace support, latencytop support, and more. We are 
just getting around to make GENERIC_TIME the only option [maybe..] - 
after years of migration.

We've got 22 architectures and they tend to slow down certain types 
of core kernel changes significantly.

> [...] See the case where Roland tried to do ARM but still hasn't 
> gotten any feedback as a negative example.

That really reinforces my point: arch maintainers are even less 
inclined to do it proactively.

> > Really, the above isnt a blocker list, it's your personal 
> > wish-list for the future. Cleaning up ptrace itself is already 
> > an upstream advantage worth having - for years ptrace was barely 
> > maintained. It interfaces to enough critical projects (gdb, 
> > strace, UML, etc.) to be a realiable (and testable) basis for 
> > utrace.
> 
> The cleanups aren't there for cleanup purposes, but to actually 
> allow the utrace-based ptrace being used unconditionally.  There 
> is really no point in merging a second conditional ptrace 
> implementation that has to be maintained while we add another one 
> that doesn't add a single new feature.

I'm well aware of what these patches are trying to achieve.

We've got the main mass of architectures covered:

 arch/ia64/Kconfig:	select HAVE_ARCH_TRACEHOOK
 arch/powerpc/Kconfig:	select HAVE_ARCH_TRACEHOOK
 arch/s390/Kconfig:	select HAVE_ARCH_TRACEHOOK
 arch/sh/Kconfig:	select HAVE_ARCH_TRACEHOOK
 arch/sparc/Kconfig:	select HAVE_ARCH_TRACEHOOK
 arch/x86/Kconfig:	select HAVE_ARCH_TRACEHOOK

I'd expect the remaining arch conversion to tracehooks to be 
deterministically finished if done by the ptrace folks - i.e. Roland 
and Oleg. It will take forever if all that happens is a 'ping' from 
you ;-)

	Ingo
