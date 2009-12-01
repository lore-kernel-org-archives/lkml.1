Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbZLAVPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbZLAVPk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 16:15:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752340AbZLAVPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 16:15:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59072 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbZLAVPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 16:15:38 -0500
Date: Tue, 1 Dec 2009 22:15:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091201211518.GA32376@elte.hu>
References: <1259584907.20516.246.camel@laptop>
 <20091130131928.GC18879@linux.vnet.ibm.com>
 <1259588232.20516.307.camel@laptop>
 <20091130150314.GA10331@redhat.com>
 <20091130151650.GA24316@elte.hu>
 <20091130152910.GB10331@redhat.com>
 <20091201161132.GA24897@elte.hu>
 <20091201170002.GD10331@redhat.com>
 <20091201170954.GA4699@elte.hu>
 <20091201174534.GE10331@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201174534.GE10331@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frank Ch. Eigler <fche@redhat.com> wrote:

> Hi -  
> 
> > > Only in name.  One is highly invasive, for debugging the kernel across 
> > > serial consoles.  The other is highly noninvasive, for debugging user 
> > > processes across normal userspace channels.  They both happen to talk 
> > > to gdb, but that's the end of the natural "overlap".
> > [...]
> 
> > Well nothing that you mention here changes our obvious suggestion 
> > that an in-kernel gdb stub should obviously either be a kgdb 
> > extension, or a replacement of it.
> 
> Help me out here: by "kgdb extension" do you imagine "something new 
> that an unprivileged user can use to debug his own process"?  Or do 
> you imagine a new userspace facility that single-steps the kernel?

Is this a trick question? Single-stepping the kernel on the same system 
[especially if it's an UP system] would certainly be a challenge ;-)

What i mean is what i said: if you provide a new framework (especially 
if it's user visible - which both kgdb and the gdb stub is) you should 
either fully replace existing functionality or extend it. Overlapping it 
in an incomplete way is not useful to anyone.

Extending kgdb to allow the use of it as if we used gdb locally would 
certainly be interesting - and then you could drop into the kernel 
anytime as well. But i'm not siding with any particular solution - i'm 
just seconding Peter's point that there's very clear overlap and 
inconsistency, and that ought to be resolved one way or another.

> > We dont want to separate facilities for the same conceptual thing:
> > examining application state (be that in user-space and
> > kernel-space).
> 
> This seems like a shallow sort of consistency.  kgdb was added after 
> ptrace existed -- why not extend ptrace instead to target the kernel? 
> After all, it's "examining application state".  The answer is that it 
> doesn't make a heck of a lot of sense.

kgdb simply used gdb's preferred way of remote debugging. That's 
certainly the ugliest bit of it btw - but it's an externality to kgdb.

Had it extended ptrace it wouldnt have gdb compatibility.

So i think this example of yours is inapposite as well.

Having said all that, i certainly subscribe to the view that neither 
kgdb nor ptrace is particularly cleanly done. So i wouldnt mind if 
something new existed that had a modern, flexible, extensible and 
generally pleasant interface and implementation. If you are heading in 
that direction, please let me know.

> > > > Btw., perf does meet that definition: it functionally replaces all 
> > > > facilities that it overlaps/extends - such as Oprofile. [...]
> > > 
> > > (And they currently separately coexist.)
> > 
> > You didnt get my point apparently. Keeping the overlapped facility for 
> > compatibility (and general user inertia) is fine. Creating a new 
> > facility that doesnt do everything that the existing facility does, and 
> > not integrating it either, is not fine.
> 
> oprofile and perfctr are closer in concept than kgdb and ptrace, yet 
> AFAIK perfctr doesn't "interface" to oprofile, except perhaps to the 
> extent of resolving contention over the underlying physical resources. 
> In any case this is not a great analogy.

(FYI, 'perfctr' is a different project that has existed for years, i 
suspect you meant perf events?)

perf replaces oprofile functionally. If the in-kernel gdb stub replaced 
kgdb functionally you'd hear no complaints from me.

	Ingo
