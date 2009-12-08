Return-Path: <linux-kernel-owner+w=401wt.eu-S966577AbZLHWAN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966577AbZLHWAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 17:00:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966584AbZLHV7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 16:59:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966533AbZLHV6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 16:58:49 -0500
Date: Tue, 8 Dec 2009 16:58:29 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, utrace-devel <utrace-devel@redhat.com>,
       Roland McGrath <roland@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC] [PATCH] In-kernel gdbstub based on utrace Infrastructure.
Message-ID: <20091208215829.GA19793@redhat.com>
References: <20091130131928.GC18879@linux.vnet.ibm.com> <1259588232.20516.307.camel@laptop> <20091130150314.GA10331@redhat.com> <20091130151650.GA24316@elte.hu> <20091130152910.GB10331@redhat.com> <20091201161132.GA24897@elte.hu> <20091201170002.GD10331@redhat.com> <20091201170954.GA4699@elte.hu> <20091201174534.GE10331@redhat.com> <20091201211518.GA32376@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091201211518.GA32376@elte.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -


> > Help me out here: by "kgdb extension" do you imagine "something new 
> > that an unprivileged user can use to debug his own process"?  Or do 
> > you imagine a new userspace facility that single-steps the kernel?
> 
> Is this a trick question? Single-stepping the kernel on the same system 
> [especially if it's an UP system] would certainly be a challenge ;-)
> 
> What i mean is what i said: if you provide a new framework (especially 
> if it's user visible - which both kgdb and the gdb stub is) you should 
> either fully replace existing functionality or extend it. Overlapping it 
> in an incomplete way is not useful to anyone.

But there is no "overlap" beyond the name.  The functional scope of
the two interfaces is totally non-overlapping, and are consistent with
the current chasms between kernel- and user-side debugging.

Sure, in the future, it may make sense to teach the kernel-side (kgdb
serial console) interface to manipulate userspace.  But that will
require a gdb extension.  And it would not satisfy an unprivileged
user's need to debug pure userspace (in a better way than current
ptrace can).

This is why I keep asking for specificity as to this "new framework"
you imagine.  Just sharing definitions such as kgdb_arch/kgdb_io but
otherwise completely disconnected (separate channels)?


> Extending kgdb to allow the use of it as if we used gdb locally would 
> certainly be interesting - and then you could drop into the kernel 
> anytime as well.

(Is this a restatement of the "trick question" idea?)


> > > We dont want to separate facilities for the same conceptual thing:
> > > examining application state (be that in user-space and
> > > kernel-space).

> > This seems like a shallow sort of consistency.  kgdb was added after 
> > ptrace existed -- why not extend ptrace instead to target the kernel? 
> > After all, it's "examining application state".  The answer is that it 
> > doesn't make a heck of a lot of sense.
> 
> kgdb simply used gdb's preferred way of remote debugging. That's 
> certainly the ugliest bit of it btw - but it's an externality to kgdb.
> Had it extended ptrace it wouldnt have gdb compatibility.

So, because of a constraint for gdb compatibility, you built a
separate interface for kgdb vs.  ptrace.  Fine.  Do you accept that,
even if a hypothetical single channel existed for which kernel- and
user-space debugging could occur, current gdb is not compatible with
this?  So by your own reasoning, such a facility should not be
mandated as a "necessary first step".


> [...]  perf replaces oprofile functionally.

(I'm told that it's not a strict superset from a functional point of
view, FWIW, something about a larger selection of low level hardware
counters.)

> If the in-kernel gdb stub replaced kgdb functionally you'd hear no
> complaints from me.

Let's leave it as an idea for the future.


- FChE
