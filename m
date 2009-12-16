Return-Path: <linux-kernel-owner+w=401wt.eu-S933273AbZLPBlW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933273AbZLPBlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 20:41:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754832AbZLPBlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 20:41:21 -0500
Received: from slow3-v.mail.gandi.net ([217.70.178.89]:49632 "EHLO
	slow3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZLPBlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 20:41:19 -0500
Date: Tue, 15 Dec 2009 17:04:39 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 18/18] rcu: add primitives to check
 for RCU read-side critical sections
Message-ID: <20091216010439.GD2408@feather>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
 <12609181613745-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12609181613745-git-send-email->
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 03:02:41PM -0800, Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Proposed for 2.6.34, not for inclusion.
> 
> Create rcu_read_lock_held(), rcu_read_lock_bh_held(),
> rcu_read_lock_sched_held(), and srcu_read_lock_held() primitives that
> return non-zero if there might be the corresponding type of RCU read-side
> critical section in effect at the time that they are invoked.  If there is
> doubt, they report being in the critical section.  They give exact
> answers if CONFIG_PROVE_LOCKING.
> 
> Also create rcu_dereference_check(), which takes a second boolean argument
> into which one puts rcu_read_lock_held() or similar.  For example:
> 
> 	rcu_dereference_check(gp, rcu_read_lock_held() ||
> 				  lockdep_is_held(my_lock));

Useful for the case where you do have an additional lock, but it seems
like it would help to have variants for the most common cases;
specifically:
rcu_dereference_check(thing, rcu_read_lock_held())
rcu_dereference_check(thing, rcu_read_lock_bh_held())
and so on.

Even then, it seems painful to have to annotate each rcu_dereference.
Ideally, I'd propose the reverse: annotate any rcu_dereference which
*can* occur outside an RCU read-side critical section.  (Variants of RCU
notwithstanding...)

- Josh Triplett
