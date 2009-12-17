Return-Path: <linux-kernel-owner+w=401wt.eu-S965541AbZLQTtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965541AbZLQTtm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 14:49:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965538AbZLQTti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 14:49:38 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45970 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965516AbZLQTte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 14:49:34 -0500
Date: Thu, 17 Dec 2009 11:49:31 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Teach might_sleep() about preemptible RCU
Message-ID: <20091217194931.GA13619@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091216142536.GA18091@elte.hu> <1260991265-8451-1-git-send-regression-fweisbec@gmail.com> <20091216192354.GC5211@nowhere> <20091217013700.GL6744@linux.vnet.ibm.com> <20091217084912.GB1901@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091217084912.GB1901@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 09:49:12AM +0100, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Wed, Dec 16, 2009 at 08:23:57PM +0100, Frederic Weisbecker wrote:
> > > On Wed, Dec 16, 2009 at 08:21:05PM +0100, Frederic Weisbecker wrote:
> > > > From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>
> > > 
> > > Crap... I think I'm really becoming this cyborg...
> > > 
> > > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > > Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > 
> > > Although I've happily put Paul's Reviewed-by tag in this v2,
> > > I'd feel more comfortable if he could confirm it :)
> > 
> > Given that I missed the TINY_RCU problem, I am not sure how much my 
> > Reviewed-by tag is worth, but I have no problem attaching it to this updated 
> > patch.  ;-)
> 
> Reviewed-by is valuable in terms of you both acking the patch and expressing 
> that you thought it through and like it. It does not mean you have done a 
> mental kernel build test of all 2^3000 kernel .config variants and have proven 
> the patch correct under circumstances! :-)
> 
> So yes, i've added it - thanks Paul!

The one misgiving I have is that addition of threaded interrupts and
sleeping spinlocks might break this, but those changes will be large
enough that this is the least of the worries.  We might then need to
split might_sleep() into might_sleep() and might_sleep_rt(), but hard
to say before the fact.  And this check will be very worthwhile as-is
in the meantime!  ;-)

							Thanx, Paul
