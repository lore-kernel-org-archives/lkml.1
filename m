Return-Path: <linux-kernel-owner+w=401wt.eu-S1752735AbZHITXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbZHITXq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 15:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbZHITXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 15:23:46 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34520 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbZHITXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 15:23:45 -0400
Date: Sun, 9 Aug 2009 12:23:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Add second diagnostic check for a possible
	CPU-hotplug race
Message-ID: <20090809192345.GA19433@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090806012645.GA24800@linux.vnet.ibm.com> <tip-86f044729ee3e4d8885c17371ce5a76f6f321dc7@git.kernel.org> <20090809110019.GA20236@elte.hu> <20090809111008.GA1829@elte.hu> <20090809183010.GF6866@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090809183010.GF6866@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 09, 2009 at 11:30:10AM -0700, Paul E. McKenney wrote:
> On Sun, Aug 09, 2009 at 01:10:08PM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > rcu: Add second diagnostic check for a possible CPU-hotplug race
> > > 
> > > has a build problem too:
> > > 
> > >  kernel/built-in.o: In function `rcu_cpu_notified':
> > >  (.text+0x1d787): undefined reference to `cpu_notified'
> > >  kernel/built-in.o: In function `rcu_init':
> > >  (.init.text+0x1174): undefined reference to `cpu_notified'
> > >  kernel/built-in.o: In function `rcu_init':
> > >  (.init.text+0x11a8): undefined reference to `cpu_notified'
> > > 
> > > Maybe we should simplify all those Kconfig rules? It's a maze.
> 
> Or I could fix up my scripts so that I once again test the relevant
> combinations -before- I submit the patch.  :-/

That said, I could imagine the following simplifications:

o	CONFIG_SMP always implies CONFIG_HOTPLUG_CPU, eliminating the
	need to test CONFIG_SMP&&!CONFIG_HOTPLUG_CPU.

o	Make CONFIG_NO_HZ unconditional.  (Now, -that- should get a
	reaction!  For one thing, I am not sure that all architectures
	support CONFIG_NO_HZ.)

o	Eliminate the combination CONFIG_PREEMPT && CONFIG_TREE_RCU.
	In other words, make a preemptable kernel imply preemptable RCU
	and vice versa.

o	After sufficient testing, eliminate CONFIG_PREEMPT_RCU in favor
	of CONFIG_TREE_PREEMPT_RCU (currently under development).

o	After sufficient testing, make !CONFIG_SMP imply
	CONFIG_TINY_RCU.  This might require a preemptable variant of
	CONFIG_TINY_RCU.

There are probably quite a few similar simplifications.

							Thanx, Paul
