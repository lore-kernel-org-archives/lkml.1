Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbZLHIZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbZLHIZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:25:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753839AbZLHIZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:25:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55812 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605AbZLHIZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:25:36 -0500
Date: Tue, 8 Dec 2009 09:24:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: percpu/tip tree build failure
Message-ID: <20091208082436.GA12761@elte.hu>
References: <20091208182515.bb6dda4a.sfr@canb.auug.org.au>
 <20091208080509.GD4989@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091208080509.GD4989@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> On Tue, Dec 08, 2009 at 06:25:15PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Today's linux-next build (x86_64 allmodconfig) failed like this:
> > 
> > kernel/hw_breakpoint.c:86: error: 'task_bp_pinned' redeclared as different kind of symbol
> > kernel/hw_breakpoint.c:55: note: previous declaration of 'task_bp_pinned' was here
> > kernel/hw_breakpoint.c: In function 'toggle_bp_task_slot':
> > kernel/hw_breakpoint.c:165: warning: assignment from incompatible pointer type
> > 
> > Caused by commit dd17c8f72993f9461e9c19250e3f155d6d99df22 ("percpu:
> > remove per_cpu__ prefix") from the percpu tree interacting with commit
> > 56053170ea2a2c0dc17420e9b94aa3ca51d80408 ("hw-breakpoints: Fix task-bound
> > breakpoint slot allocation") from the tip tree.
> > 
> > I have applied the following patch for today (and can carry it as
> > necessary:
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Tue, 8 Dec 2009 18:19:48 +1100
> > Subject: [PATCH] percpu: make per_cpu variable name unique in hw_breakpoint.c
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> 
> 
> Doh!
> 
> Thanks Stephen.
> 
> Ingo, can you queue up this patch?
> 
> Thanks.
> 
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

I have applied it - but really, the new percpu namespace changes headed 
towards upstream are quite a nuisance IMO. The 3-4 (trivial to solve) 
breakages i've seen so far affecting code i maintain give us an 
estimation about the ongoing maintainence cost - which wont be high but 
not zero either.

The change that was forced here:

 -static DEFINE_PER_CPU(unsigned int, task_bp_pinned[HBP_NUM]);
 +static DEFINE_PER_CPU(unsigned int, nr_task_bp_pinned[HBP_NUM]);

Is it really an improvement to the old code?

Dunno.

	Ingo
