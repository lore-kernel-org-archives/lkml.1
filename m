Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbZBXOus@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbZBXOus (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 09:50:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756634AbZBXOuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 09:50:40 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:47636 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622AbZBXOuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 09:50:39 -0500
Date: Tue, 24 Feb 2009 06:50:35 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: linux-kernel@vger.kernel.org, vegard.nossum@gmail.com, mingo@elte.hu,
       stable@kernel.org, akpm@linux-foundation.org, npiggin@suse.de,
       penberg@cs.helsinki.fi
Subject: Re: [PATCH] v2 Teach RCU that idle task is not quiscent state at
	boot
Message-ID: <20090224145035.GA12157@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090223161611.GA9563@linux.vnet.ibm.com> <20090223204332.GA19861@linux.vnet.ibm.com> <200902241502.57833.nickpiggin@yahoo.com.au> <20090224050854.GD7173@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224050854.GD7173@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 23, 2009 at 09:08:54PM -0800, Paul E. McKenney wrote:
> On Tue, Feb 24, 2009 at 03:02:56PM +1100, Nick Piggin wrote:
> > On Tuesday 24 February 2009 07:43:32 Paul E. McKenney wrote:
> > 
> > > @@ -80,6 +81,10 @@ void wakeme_after_rcu(struct rcu_head  *head)
> > >  void synchronize_rcu(void)
> > >  {
> > >  	struct rcu_synchronize rcu;
> > > +
> > > +	if (num_online_cpus() == 1)
> > > +		return;  /* If UP, synchronize_rcu() is a grace period! */
> > > +
> > 
> > Nice patch... May I just suggest a comment to say that this is
> > also a correctness requirement due to the grace period holdoff
> > for early boot?
> 
> Excellent point!  If Ingo reports that this actually fixes the hang that
> he saw, I will add such a comment.
> 
> (And glad you like the patch!)

Gah!!!  I forgot about preemptable RCU, which the previous patch breaks
completely on single-CPU systems.

A fix is in the works.

							Thanx, Paul
