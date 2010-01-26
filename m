Return-Path: <linux-kernel-owner+w=401wt.eu-S1753738Ab0AZXee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab0AZXee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:34:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610Ab0AZXed
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:34:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab0AZXec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:34:32 -0500
Date: Wed, 27 Jan 2010 00:32:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, tromey@redhat.com,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Kyle Moffett <kyle@moffetthome.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100126233242.GA25575@redhat.com>
References: <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <m33a1tnbd9.fsf@fleche.redhat.com> <877hr4g49l.fsf@basil.nowhere.org> <alpine.LFD.2.00.1001261038150.3574@localhost.localdomain> <20100126210232.GF6567@basil.fritz.box> <20100126215349.GB19146@redhat.com> <20100126220301.GG6567@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100126220301.GG6567@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26, Andi Kleen wrote:
>
> > Simple example. Try to debug/strace strace ot gdb itself. Not trivial,
> > you can't attach to strace's tracees. Recently I spent 2 days trying to
> > understand why strace -f hangs. I was able to attach to strace, but
> > I wasn't able to see what its tracees do.
>
> But what would the semantics be inside the tracees even if you could?

In this particular case, all I need was something like "gdb -p" to
attach to the tracee, see the backtrace and detach.

> > And, it was not possible to even trace strace until it hangs, with
> > ptrace the tracee (strace) must stop to report the event and this
> > shadowed the race.
>
> "Shadowing the race" was the second surname of strace I thought anyways @)
> Basically if you care about races never use strace in the first place.

Yes. And utrace doesn't require the tracee to be stopped to report the
event ;) Yes, yes, utrace can't "fix" strace in this sense automatically,
but still.

Oleg.

