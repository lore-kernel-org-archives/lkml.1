Return-Path: <linux-kernel-owner+w=401wt.eu-S1752828AbZHXQH6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbZHXQH6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 12:07:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZHXQH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 12:07:58 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35798 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbZHXQH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 12:07:57 -0400
Date: Mon, 24 Aug 2009 09:07:55 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Consolidate sparse and lockdep declarations
	in include/linux/rcupdate.h
Message-ID: <20090824160755.GH6677@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-bc33f24bdca8b6e97376e3a182ab69e6cdefa989@git.kernel.org> <20090823184202.GA20404@elte.hu> <20090823193356.GB6882@linux.vnet.ibm.com> <20090823225321.GA3976@linux.vnet.ibm.com> <20090824092836.GB25267@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824092836.GB25267@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 11:28:36AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Sun, Aug 23, 2009 at 12:33:56PM -0700, Paul E. McKenney wrote:
> > > On Sun, Aug 23, 2009 at 08:42:02PM +0200, Ingo Molnar wrote:
> > > > 
> > > > * tip-bot for Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > > 
> > > > > Commit-ID:  bc33f24bdca8b6e97376e3a182ab69e6cdefa989
> > > > > Gitweb:     http://git.kernel.org/tip/bc33f24bdca8b6e97376e3a182ab69e6cdefa989
> > > > > Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > > AuthorDate: Sat, 22 Aug 2009 13:56:47 -0700
> > > > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > > > CommitDate: Sun, 23 Aug 2009 10:32:37 +0200
> > > > > 
> > > > > rcu: Consolidate sparse and lockdep declarations in include/linux/rcupdate.h
> > > > 
> > > > -tip testing found a spontaneous reboot crash, which i 
> > > > bisected back to this commit:
> > > > 
> > > >   bc33f24bdca8b6e97376e3a182ab69e6cdefa989 is first bad commit
> > > > 
> > > > the reboot happens during the ftrace syscall tracepoints 
> > > > self-test:
> > > > 
> > > > [   34.618832] Testing event sys_exit_set_robust_list: OK
> > > > [   34.635511] Testing event sys_enter_get_robust_list: OK
> > > > [   34.652164] Testing event sys_exit_get_robust_list: OK
> > > > [   34.668844] Testing event sys_enter_futex: OK
> > > > [   34.685495] Testing event sys_exit_futex: OK
> > > > [   34.702170] Testing event lock_acquire: [instant reboot]
> > > > 
> > > > There's no log message - just a reboot - which signals some 
> > > > severe crash - perhaps some locking related infinite 
> > > > recursion or something like that?
> > > 
> > > Pretty impressive for having mostly moved RCU's lockdep-related
> > > declarations from one file to another...  :-/
> > > 
> > > Looking into it, probably a typo on my part.
> > 
> > I rechecked this several times, and don't see how anything else 
> > should have noticed this patch.  That said, that self-test is 
> > rather amazing code, so...
> 
> What do you think about the infinite recursion bug that Lai 
> Jiangshan's found in that patch? (sharp eyes really!) That might 
> explain the crash -tip testing found.

Indeed!!!

My thought is to send you a temporary patch stack fixing that bug
(and supplying a CPU-hotplug fix), allowing your testing to progress
(but defeating bisection if using ftrace).

Then I would create a new patch stack applying the fix to the bugs Lai
Jiangshan found to commit bc33f24, rebasing, retesting, and suppling a
this new stack to replace commit bc33f24 and later in tip/core/rcu.

Seem reasonable?

							Thanx, Paul
