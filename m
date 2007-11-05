Return-Path: <linux-kernel-owner+w=401wt.eu-S1761021AbXKERVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021AbXKERVc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:21:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbXKERJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:09:42 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:37763 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758115AbXKERJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:09:41 -0500
Date: Mon, 5 Nov 2007 08:12:03 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       SteveW@acm.org, dipankar@in.ibm.com
Subject: Re: dn_route.c momentarily exiting RCU read-side critical section
Message-ID: <20071105161203.GB9479@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071030151254.GA8285@linux.vnet.ibm.com> <E1Ip0Vs-0002zP-00@gondolin.me.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Ip0Vs-0002zP-00@gondolin.me.apana.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 07:53:04PM +0800, Herbert Xu wrote:
> Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> >> 
> >> > net/decnet/dn_route.c in dn_rt_cache_get_next() is as follows:
> >> > 
> >> > static struct dn_route *dn_rt_cache_get_next(struct seq_file *seq, struct dn_route *rt)
> >> > {
> >> >     struct dn_rt_cache_iter_state *s = rcu_dereference(seq->private);
> >> > 
> >> >     rt = rt->u.dst.dn_next;
> >> >     while(!rt) {
> >> >             rcu_read_unlock_bh();
> >> >             if (--s->bucket < 0)
> >> >                     break;
> >
> > OK, for my next stupid question: why is the rcu_dereference(seq->private)
> > required, as opposed to simply seq->private?
> 
> It was put there by someone who went through the code converting
> all occurances of smp_read_barrier_depends to rcu_dereference.
> In this instance the rcu_dereference conversion doesn't make much
> sense so we should probably just revert it.

Thank you for the info!  Stupid question #3: what sequence of events
would the smp_read_barrier_depends() be defending against?

							Thanx, Paul
