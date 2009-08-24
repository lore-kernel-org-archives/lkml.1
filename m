Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbZHXJ2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbZHXJ2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 05:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751286AbZHXJ2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 05:28:49 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39201 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZHXJ2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 05:28:48 -0400
Date: Mon, 24 Aug 2009 11:28:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Consolidate sparse and lockdep
	declarations in include/linux/rcupdate.h
Message-ID: <20090824092836.GB25267@elte.hu>
References: <tip-bc33f24bdca8b6e97376e3a182ab69e6cdefa989@git.kernel.org> <20090823184202.GA20404@elte.hu> <20090823193356.GB6882@linux.vnet.ibm.com> <20090823225321.GA3976@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090823225321.GA3976@linux.vnet.ibm.com>
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


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> On Sun, Aug 23, 2009 at 12:33:56PM -0700, Paul E. McKenney wrote:
> > On Sun, Aug 23, 2009 at 08:42:02PM +0200, Ingo Molnar wrote:
> > > 
> > > * tip-bot for Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > Commit-ID:  bc33f24bdca8b6e97376e3a182ab69e6cdefa989
> > > > Gitweb:     http://git.kernel.org/tip/bc33f24bdca8b6e97376e3a182ab69e6cdefa989
> > > > Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > AuthorDate: Sat, 22 Aug 2009 13:56:47 -0700
> > > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > > CommitDate: Sun, 23 Aug 2009 10:32:37 +0200
> > > > 
> > > > rcu: Consolidate sparse and lockdep declarations in include/linux/rcupdate.h
> > > 
> > > -tip testing found a spontaneous reboot crash, which i 
> > > bisected back to this commit:
> > > 
> > >   bc33f24bdca8b6e97376e3a182ab69e6cdefa989 is first bad commit
> > > 
> > > the reboot happens during the ftrace syscall tracepoints 
> > > self-test:
> > > 
> > > [   34.618832] Testing event sys_exit_set_robust_list: OK
> > > [   34.635511] Testing event sys_enter_get_robust_list: OK
> > > [   34.652164] Testing event sys_exit_get_robust_list: OK
> > > [   34.668844] Testing event sys_enter_futex: OK
> > > [   34.685495] Testing event sys_exit_futex: OK
> > > [   34.702170] Testing event lock_acquire: [instant reboot]
> > > 
> > > There's no log message - just a reboot - which signals some 
> > > severe crash - perhaps some locking related infinite 
> > > recursion or something like that?
> > 
> > Pretty impressive for having mostly moved RCU's lockdep-related
> > declarations from one file to another...  :-/
> > 
> > Looking into it, probably a typo on my part.
> 
> I rechecked this several times, and don't see how anything else 
> should have noticed this patch.  That said, that self-test is 
> rather amazing code, so...

What do you think about the infinite recursion bug that Lai 
Jiangshan's found in that patch? (sharp eyes really!) That might 
explain the crash -tip testing found.

	Ingo
