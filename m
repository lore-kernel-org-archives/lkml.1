Return-Path: <linux-kernel-owner+w=401wt.eu-S1761772AbXF0Qaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761772AbXF0Qaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753192AbXF0Qac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:30:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:47950 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752209AbXF0Qab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:30:31 -0400
Date: Wed, 27 Jun 2007 09:30:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       josh@freedesktop.org, dipankar@in.ibm.com
Subject: Re: [PATCH] Force rcutorture tasks to spread over CPUs
Message-ID: <20070627163025.GB8604@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070613042804.GA6132@linux.vnet.ibm.com> <20070626161317.767d5ec0.akpm@linux-foundation.org> <20070627063055.GB3186@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627063055.GB3186@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 08:30:55AM +0200, Ingo Molnar wrote:
> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 12 Jun 2007 21:28:04 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > +	while (!startwriters)
> > > +		barrier();	/* Force scheduler to spread over CPUs. */
> > 
> > one wonders whether a cpu_relax() would be a bit nicer here.  That 
> > implicitly does a barrier().
> > 
> > This patch doesn't make much sense for non-SMP builds?
> 
> i think this patch should be unnecessary because we found the real SMP 
> balancing bug in the upstream scheduler causing this rcu problem, see:
> 
>  commit 92c4ca5c3a5e180e9762438db235f41d192cb955
>  Author: Christoph Lameter <clameter@sgi.com>
>  Date:   Sat Jun 23 17:16:33 2007 -0700
> 
>      sched: fix next_interval determination in idle_balance()

Ingo is correct -- applying the above patch caused the scheduler to
correctly balance the rcutorture tasks, so that my patch to rcutorture
is no longer needed.  Which is a very good thing!  ;-)

							Thanx, Paul
