Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbYJGOg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbYJGOg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbYJGOgQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:36:16 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37778 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbYJGOgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:36:15 -0400
Date: Tue, 7 Oct 2008 07:36:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>, dada1@cosmosbay.com, minyard@acm.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       shemminger@vyatta.com
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
Message-ID: <20081007143611.GB6384@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081006185026.GA10383@minyard.local> <48EA8197.6080502@cosmosbay.com> <20081006.144002.56418911.davem@davemloft.net> <1223368290.26330.10.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223368290.26330.10.camel@lappy.programming.kicks-ass.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 10:31:30AM +0200, Peter Zijlstra wrote:
> On Mon, 2008-10-06 at 14:40 -0700, David Miller wrote:
> > From: Eric Dumazet <dada1@cosmosbay.com>
> > Date: Mon, 06 Oct 2008 23:22:31 +0200
> > 
> > > Me wondering what impact this synchronize_rcu() can have on mono-threaded
> > > VOIP applications using lot of UDP sockets. What is the maximum delay of
> > > this function ?
> > 
> > The cost is enormous, we really can't use it here.
> > 
> > I have a patch that did top-level socket destruction using RCU,
> > and that didn't use synchronize_rcu(), and that killed connection
> > rates by up to %20.
> 
> Did you ever figure out why you lost those 20% ?
> 
> > I can only imagine what the cost would be if I had to add such a call
> > in there.
> 
> Yeah, sync_rcu() is rediculously expensive, at best 3 jiffies IIRC.

I could make it -much- faster, but at the expense of -serious- CPU
overhead.  Still, might be useful during boot time (when the system
can't do anything useful anyway) to accelerate getting data structures
initialized.

							Thanx, Paul
