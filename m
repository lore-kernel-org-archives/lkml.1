Return-Path: <linux-kernel-owner+w=401wt.eu-S1761426AbZLLGHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761426AbZLLGHe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 01:07:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761361AbZLLGHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 01:07:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:46282 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761274AbZLLGHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 01:07:32 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/8n/pAkSz8mzIE7LZPdwmsCYlbM2jKpr1VcxdY5a
	VT676GlnIAw2l9
Subject: Re: [tip:sched/urgent] sched: Set correct normal_prio and prio
 values  in sched_fork()
From: Mike Galbraith <efault@gmx.de>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, pwil3058@bigpond.net.au,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <d6200be20912112155w6eca7452x550bc77330f236b0@mail.gmail.com>
References: <f8f46736fd4e7f090ac0.1253774830@mudlark.pw.nest>
	 <tip-f83f9ac2632732bd1678150b5a03d152f912fe72@git.kernel.org>
	 <d6200be20912112155w6eca7452x550bc77330f236b0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Dec 2009 07:07:35 +0100
Message-Id: <1260598055.6306.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 21:55 -0800, Arve Hjønnevåg wrote:
> On Mon, Oct 5, 2009 at 3:47 AM, tip-bot for Peter Williams
> <pwil3058@bigpond.net.au> wrote:
> > Commit-ID:  f83f9ac2632732bd1678150b5a03d152f912fe72
> > Gitweb:     http://git.kernel.org/tip/f83f9ac2632732bd1678150b5a03d152f912fe72
> > Author:     Peter Williams <pwil3058@bigpond.net.au>
> > AuthorDate: Thu, 24 Sep 2009 06:47:10 +0000
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Mon, 5 Oct 2009 13:42:20 +0200
> >
> > sched: Set correct normal_prio and prio values in sched_fork()
> >
> > normal_prio should be updated if policy changes from RT to
> > SCHED_MORMAL or if static_prio/nice is changed.
> >
> > Some paths through sched_fork() ignore this requirement and may
> > result in normal_prio having an invalid value.
> >
> > Fixing this issue allows the call to effective_prio() in
> > wake_up_new_task() to be removed.
> >
> 
> This change causes a lot of threads with a 0 nice value to get a prio
> value of 140 instead of 120 (at least on my android arm msm build). I
> don't know if this has any impact on how they are scheduled since the
> load weight is unaffected, but it at least makes the output of ps more
> confusing.

There's a patch in tip to correct this, hasn't swam upstream yet.

	-Mike

