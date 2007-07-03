Return-Path: <linux-kernel-owner+w=401wt.eu-S1758945AbXGCHMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945AbXGCHMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 03:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXGCHM2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 03:12:28 -0400
Received: from mail.gmx.net ([213.165.64.20]:33913 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753016AbXGCHM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 03:12:27 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/MC6FsTAvM36G9nF39VJzco0Hg39hEb7fT9i5Tbj
	vk4rK0JKYfGudq
Subject: Re: [patch] CFS scheduler, -v18
From: Mike Galbraith <efault@gmx.de>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0707020940r517cbe42sa443d191439e5f54@mail.gmail.com>
References: <20070622220202.GA16872@elte.hu>
	 <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
	 <b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com>
	 <19f34abd0707020643g6a274db5q1d25cabd85b9a25f@mail.gmail.com>
	 <20070702155029.GA13241@elte.hu>
	 <19f34abd0707020940r517cbe42sa443d191439e5f54@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 03 Jul 2007 09:12:23 +0200
Message-Id: <1183446743.7070.14.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-02 at 18:40 +0200, Vegard Nossum wrote:
> On 7/2/07, Ingo Molnar <mingo@elte.hu> wrote:
> > thx. As an initial matter, could you double-check whether your v18
> > kernel source has the patch below applied already?
> >
> >         Ingo
> >
> > Index: linux/kernel/sched_fair.c
> > ===================================================================
> > --- linux.orig/kernel/sched_fair.c
> > +++ linux/kernel/sched_fair.c
> > @@ -342,8 +342,9 @@ update_stats_enqueue(struct cfs_rq *cfs_
> >                 s64 tmp;
> >
> >                 if (se->wait_runtime < 0) {
> > -                       tmp = (0 - se->wait_runtime) << NICE_0_SHIFT;
> > -                       key += (tmp * se->load.inv_weight) >> WMULT_SHIFT;
> > +                       tmp = -se->wait_runtime;
> > +                       key += (tmp * se->load.inv_weight) >>
> > +                                       (WMULT_SHIFT - NICE_0_SHIFT);
> >                 } else {
> >                         tmp = se->wait_runtime * se->load.weight;
> >                         key -= tmp >> NICE_0_SHIFT;
> >
> >
> 
> It does.

Hi,

This doesn't appear to be a CFS problem.  I can reproduce the problem
easily in virgin 2.6.22-rc7 by starting xterm-spam at nice -1 or better.
As soon as xterm-spam can get enough CPU to keep the xterm fully busy,
it's game over, the xterm freezes.  The more accurate fairness of CFS to
sleepers just tips the balance quicker.  In mainline, the xterm has an
unfair advantage and maintains it indefinitely... until you tip the
scales just a wee bit, at which time it inverts.

	-Mike

