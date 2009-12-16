Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbZLPPSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbZLPPSz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758694AbZLPPSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:18:54 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:42078 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907AbZLPPSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:18:53 -0500
Date: Wed, 16 Dec 2009 07:18:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 18/18] rcu: add primitives to check
	for RCU read-side critical sections
Message-ID: <20091216151848.GC6744@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091215230213.GA9093@linux.vnet.ibm.com> <1260959494.17860.46.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260959494.17860.46.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 11:31:34AM +0100, Peter Zijlstra wrote:
> On Tue, 2009-12-15 at 15:02 -0800, Paul E. McKenney wrote:
> > 
> > Also create rcu_dereference_check(), which takes a second boolean argument
> > into which one puts rcu_read_lock_held() or similar.  For example:
> > 
> >         rcu_dereference_check(gp, rcu_read_lock_held() ||
> >                                   lockdep_is_held(my_lock));
> 
> Ah, so you're going to tackle this the other way around, interesting :-)

Still feeling my way around this one, but for the moment, yes.  ;-)

One potential issue is that for lockdep, avoiding false positives means
erring on the side of the lock -not- being held, while for this approach
to rcu_dereference() checking, avoiding false positives means erring on
the side of the lock being held.

I might need to create a CONFIG_PROVE_LOCKING_RCU to allow shutting off
the more-detailed RCU checking when people want to do partial deadlock
checking, but will see how it goes.

							Thanx, Paul
