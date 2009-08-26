Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbZHZTLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbZHZTLG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 15:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750927AbZHZTLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 15:11:05 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33715 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbZHZTLE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 15:11:04 -0400
Date: Wed, 26 Aug 2009 12:11:05 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Remove lockdep annotations from RCU's
	_notrace() API members
Message-ID: <20090826191105.GD6752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090826015337.GA18904@linux.vnet.ibm.com> <tip-06e799764eb7c2e4640888d438c3524d756613e1@git.kernel.org> <20090826084938.GA5023@elte.hu> <20090826173318.GC6752@linux.vnet.ibm.com> <20090826183954.GE13632@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826183954.GE13632@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 08:39:54PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Wed, Aug 26, 2009 at 10:49:38AM +0200, Ingo Molnar wrote:
> > > 
> > > * tip-bot for Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> > > 
> > > > Commit-ID:  06e799764eb7c2e4640888d438c3524d756613e1
> > > > Gitweb:     http://git.kernel.org/tip/06e799764eb7c2e4640888d438c3524d756613e1
> > > > Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > > AuthorDate: Tue, 25 Aug 2009 18:53:37 -0700
> > > > Committer:  Ingo Molnar <mingo@elte.hu>
> > > > CommitDate: Wed, 26 Aug 2009 09:45:41 +0200
> > > > 
> > > > rcu: Remove lockdep annotations from RCU's _notrace() API members
> > > 
> > > I'm afraid this does not solve the problem either - the attached 
> > > config crashes too. Does it boot for you? It should boot fine on 
> > > most 64-bit x86 systems.
> > 
> > OK, got my hands on a 64-bit x86 system, building.  When I did 
> > "make oldconfig" on the attached config file, I ended up with the 
> > following diffs.  If there is some other command I should use, 
> > please let me know. Otherwise, will let you know how this goes.
> 
> Have you tried it on tip/master + tip/core/rcu? make oldconfig works 
> fine with that here.

Ah!!!  I have been running just tip/core/rcu.

> But ... here's something you wont like: just to make sure i sent you 
> the right config [i made mistakes there in the past] i picked a 
> 64-bit system (a different one from the one that triggered the 
> crash), built the config with latest tip/master (80c161b, using gcc 
> 4.3.2) plus tip/core/rcu (06e7997) git-merged in:
> 
>   git checkout -b tmp tip/master
>   git merge tip/core/rcu
> 
> and booted it - and that did not produce any lockups. So you might 
> not be able to reproduce it :-/ I've re-merged core/rcu into 
> tip/master, maybe my tests can find another config that reproduces 
> the crash better. Please disregard this bugreport until i've found 
> that one.

OK, I will give the x86_64 machine back and go back to making a
synchronize_rcu_expedited() that is integrated tightly into the tree-rcu
algorithm.  Looks to be pretty small and simple -- but then they always
do before you start debugging them...  ;-)

							Thanx, Paul
