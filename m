Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbXIRTny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbXIRTny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbXIRTnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:43:46 -0400
Received: from canuck.infradead.org ([209.217.80.40]:34629 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbXIRTnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:43:45 -0400
Date: Tue, 18 Sep 2007 21:41:52 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.23-rc6-mm1: IPC: sleeping function called ...
Message-ID: <20070918214152.3698a787@lappy>
In-Reply-To: <20070918182924.GF8665@linux.vnet.ibm.com>
References: <20070918091728.GA6766@localhost.sw.ru>
	<20070918031723.05689e92.akpm@linux-foundation.org>
	<46EFA8DC.2020909@bull.net>
	<20070918033400.495b02dd.akpm@linux-foundation.org>
	<20070918142451.418b3b51@twins>
	<20070918161337.GC8665@linux.vnet.ibm.com>
	<20070918095715.05899d12.akpm@linux-foundation.org>
	<20070918182924.GF8665@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.11.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 11:29:24 -0700 "Paul E. McKenney"
<paulmck@linux.vnet.ibm.com> wrote:

> On Tue, Sep 18, 2007 at 09:57:15AM -0700, Andrew Morton wrote:
> > On Tue, 18 Sep 2007 09:13:37 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > On Tue, Sep 18, 2007 at 02:24:51PM +0200, Peter Zijlstra wrote:
> > > > On Tue, 18 Sep 2007 03:34:00 -0700 Andrew Morton
> > > > <akpm@linux-foundation.org> wrote:
> > > > 
> > > > > Well, it was an optimisation.  spin_lock() implies rcu_read_lock().  That's
> > > > > a bit dirty and we might choose to not do that.
> > > > 
> > > > Not true for the preemptible-rcu work. All such sites should be fixed,
> > > > or at the very least heavily annotated.
> > > 
> > > What he said!!!
> > > 
> > 
> > What he said!
> > 
> > How are you going to find all such sites?
> 
> A first step would be to look for patches in -rt that add rcu_read_lock()
> or friends.  A second step would be to look for rcu_dereference() without
> an enclosing rcu_read_lock(), rcu_read_lock_bh(), or preempt_disable().

I could perhaps do that with that rcu_read_lock lockdep annotation. If
I add a check for holding rcu_read_lock in rcu_dereference().
