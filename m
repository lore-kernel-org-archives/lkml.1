Return-Path: <linux-kernel-owner+w=401wt.eu-S1755516AbZLLGSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516AbZLLGSW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 01:18:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754018AbZLLGSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 01:18:20 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:43701 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879AbZLLGST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 01:18:19 -0500
Date: Sat, 12 Dec 2009 07:16:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Arve Hj?nnev?g <arve@android.com>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, pwil3058@bigpond.net.au,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/urgent] sched: Set correct normal_prio and prio
 values  in sched_fork()
Message-ID: <20091212061613.GA2822@elte.hu>
References: <f8f46736fd4e7f090ac0.1253774830@mudlark.pw.nest>
 <tip-f83f9ac2632732bd1678150b5a03d152f912fe72@git.kernel.org>
 <d6200be20912112155w6eca7452x550bc77330f236b0@mail.gmail.com>
 <1260598055.6306.1.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260598055.6306.1.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Fri, 2009-12-11 at 21:55 -0800, Arve Hj??nnev??g wrote:
> > On Mon, Oct 5, 2009 at 3:47 AM, tip-bot for Peter Williams
> > <pwil3058@bigpond.net.au> wrote:
> > > Commit-ID:  f83f9ac2632732bd1678150b5a03d152f912fe72
> > > Gitweb:     http://git.kernel.org/tip/f83f9ac2632732bd1678150b5a03d152f912fe72
> > > Author:     Peter Williams <pwil3058@bigpond.net.au>
> > > AuthorDate: Thu, 24 Sep 2009 06:47:10 +0000
> > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > CommitDate: Mon, 5 Oct 2009 13:42:20 +0200
> > >
> > > sched: Set correct normal_prio and prio values in sched_fork()
> > >
> > > normal_prio should be updated if policy changes from RT to
> > > SCHED_MORMAL or if static_prio/nice is changed.
> > >
> > > Some paths through sched_fork() ignore this requirement and may
> > > result in normal_prio having an invalid value.
> > >
> > > Fixing this issue allows the call to effective_prio() in
> > > wake_up_new_task() to be removed.
> > >
> > 
> > This change causes a lot of threads with a 0 nice value to get a prio
> > value of 140 instead of 120 (at least on my android arm msm build). I
> > don't know if this has any impact on how they are scheduled since the
> > load weight is unaffected, but it at least makes the output of ps more
> > confusing.
> 
> There's a patch in tip to correct this, hasn't swam upstream yet.

just sent the pull request to Linus for the latest scheduler fixes. 
Meanwhile you can try latest -tip with the fix:

  http://people.redhat.com/mingo/tip.git/README

	Ingo
