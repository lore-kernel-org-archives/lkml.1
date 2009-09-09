Return-Path: <linux-kernel-owner+w=401wt.eu-S1753903AbZIISJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbZIISJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 14:09:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607AbZIISJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 14:09:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56360 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753465AbZIISJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 14:09:09 -0400
Date: Wed, 9 Sep 2009 20:08:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Theodore Tso <tytso@mit.edu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched: Turn off child_runs_first
Message-ID: <20090909180856.GA7323@elte.hu>
References: <1252486344.28645.18.camel@marge.simson.net> <tip-2bba22c50b06abe9fd0d23933b1e64d35b419262@git.kernel.org> <20090909175724.GY22901@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090909175724.GY22901@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Theodore Tso <tytso@mit.edu> wrote:

> On Wed, Sep 09, 2009 at 03:37:07PM +0000, tip-bot for Mike Galbraith wrote:
> > Commit-ID:  2bba22c50b06abe9fd0d23933b1e64d35b419262
> > Gitweb:     http://git.kernel.org/tip/2bba22c50b06abe9fd0d23933b1e64d35b419262
> > Author:     Mike Galbraith <efault@gmx.de>
> > AuthorDate: Wed, 9 Sep 2009 15:41:37 +0200
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 9 Sep 2009 17:30:05 +0200
> > 
> > sched: Turn off child_runs_first
> > 
> > Set child_runs_first default to off.
> > 
> > It hurts 'optimal' make -j<NR_CPUS> workloads as make jobs
> > get preempted by child tasks, reducing parallelism.
> 
> Wasn't one of the reasons why we historically did child_runs_first 
> was so that for fork/exit workloads, the child has a chance to 
> exec the new process?  If the parent runs first, then more pages 
> will probably need to be COW'ed.

That kind of workload should be using vfork() anyway, and be even 
faster because it can avoid the fork overhead, right?

Also, on SMP we do that anyway - there's good likelyhood on an idle 
system that we wake the child on the other core straight away.

	Ingo
