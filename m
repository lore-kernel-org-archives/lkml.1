Return-Path: <linux-kernel-owner+w=401wt.eu-S1756577AbZEFJGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577AbZEFJGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 05:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZEFJF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 05:05:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55471 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940AbZEFJF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 05:05:58 -0400
Date: Wed, 6 May 2009 11:05:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, jdike@addtoit.com,
       utrace-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC, PATCH 0/2] utrace/ptrace: simplify/cleanup ptrace attach
Message-ID: <20090506090512.GB24692@elte.hu>
References: <20090503185537.GA17071@redhat.com> <20090504184951.623CEFC32F@magilla.sf.frob.com> <20090504193016.GA17076@redhat.com> <20090504194348.BC0EBFC32F@magilla.sf.frob.com> <20090504163154.f3672a83.akpm@linux-foundation.org> <20090505230642.GA980@redhat.com> <20090506081225.GD8098@elte.hu> <20090506082300.GA16989@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506082300.GA16989@infradead.org>
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

> On Wed, May 06, 2009 at 10:12:25AM +0200, Ingo Molnar wrote:
> > Yes. But realize the fundamental reason for that: _without_ 
> > ptrace-over-utrace the utrace core code is a big chunk of dead code 
> > only used on the fringes. I see and agree with all the future uses 
> > of utrace, but it's easy to be problem-free if a facility is not 
> > used by anything significant.
> 
> The ptrace cleanups might be required for utrace, but they by
> themselves don't make utrace any more useful without another
> user.
> 
> > So a clean ptrace-over-utrace plugin is absolutely needed for utrace 
> > to go upstream in v2.6.31. The ftrace plugin alone does not justify 
> > it. The real prize here is a (much!) cleaner ptrace code. Once 
> > ptrace is driven via utrace and it works, its value (and trust 
> > level) will skyrocket.
> 
> There are two blockers for utrace:
> 
>  - first all architectures need to be converted to the ptrace world
>    order with regsets, tracehooks and so on.  I hope we are on track
>    to get this done now after I've pinged all arch maintainers.

It might be more effective if you also wrote patches and if you 
would shop for maintainer Acks, instead of just "pinging" people? 
;-) We've already got enough would-be-managers on lkml really.

>  - we actually need a useful user of the utrace abstraction.  And just
>    converting ptrace to make it slightly more complicated by using
>    another abstraction just isn't it.  One useful bit that is in the
>    queue is a in-kernel gdbstub for user process which would allow
>    to get out of the ptrace and re-parenting mess for basic use
>    cases.  But a really convincing user would be even better.
> 
> I don't think 2.6.31 is a very realistic target.  While a lot of 
> arch maintainers are working on their ptrace code 2.6.31 is just a 
> too short deadline, and I'm also not sure we'll have the ptrace 
> code in shape by then.  2.6.32 is much more realistic.

Really, the above isnt a blocker list, it's your personal wish-list 
for the future. Cleaning up ptrace itself is already an upstream 
advantage worth having - for years ptrace was barely maintained. It 
interfaces to enough critical projects (gdb, strace, UML, etc.) to 
be a realiable (and testable) basis for utrace.

The new features you are suggesting look potentially interesting, 
but they have zero usage right now and they will take time to 
develop. So they should be decoupled, otherwise we will just have a 
huge and problematic change-the-world merge down the line, instead 
of a more manageable gradual approach.

	Ingo
