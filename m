Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbYJVMmz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbYJVMmz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:42:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbYJVMmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:42:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39414 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbYJVMmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:42:47 -0400
Date: Wed, 22 Oct 2008 14:42:40 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] pending scheduler updates
Message-ID: <20081022124240.GD25536@elte.hu>
References: <20081017172701.047939625@chello.nl> <20081020120538.GD10594@elte.hu> <20081021173529.GG11679@linux.vnet.ibm.com> <20081022094019.GG12453@elte.hu> <1224669821.6871.16.camel@marge.simson.net> <1224671528.7511.11.camel@marge.simson.net> <20081022121007.GG8095@elte.hu> <1224679082.12294.15.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224679082.12294.15.camel@marge.simson.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> > > With that patch, pgsql+oltp scales perfectly.
> > 
> > hm, tempting.
> 
> I disagree.  Postgres's scaling problem is trivially corrected by 
> twiddling knobs (or whatnot). [...]

okay, then we need to document it a bit more: what knobs need twiddling 
to make it scale perfectly?

> [...]  With that patch, you can't twiddle mysql throughput back, or 
> disk intensive loads for that matter.  You can tweak the preempt 
> number, but it has nothing to do with lag, so anybody can preempt 
> anybody else as you turn the knob toward zero.  Chaos.

okay, convinced.

> > Have you tried to hack/fix pgsql to do proper wakeups?
> 
> No, I tried to build without spinlocks to verify, but build croaked. 
> Never went back to slogging through the code.

if it falls back to IPC semaphores that's a bad trade from a performance 
POV. The best would be if it used proper futexes (i.e. pthread_mutex() 
and friends) not some home-grown user-space spinlock thing.

	Ingo
