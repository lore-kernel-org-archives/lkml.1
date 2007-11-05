Return-Path: <linux-kernel-owner+w=401wt.eu-S1755837AbXKEXwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837AbXKEXwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 18:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXKEXwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 18:52:15 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:1457 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750741AbXKEXwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 18:52:14 -0500
Date: Tue, 6 Nov 2007 07:51:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       SteveW@acm.org, dipankar@in.ibm.com
Subject: Re: dn_route.c momentarily exiting RCU read-side critical section
Message-ID: <20071105235117.GA18396@gondor.apana.org.au>
References: <20071030151254.GA8285@linux.vnet.ibm.com> <E1Ip0Vs-0002zP-00@gondolin.me.apana.org.au> <20071105161203.GB9479@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105161203.GB9479@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 08:12:03AM -0800, Paul E. McKenney wrote:
> > >> 
> > >> > net/decnet/dn_route.c in dn_rt_cache_get_next() is as follows:
> > >> > 
> > >> > static struct dn_route *dn_rt_cache_get_next(struct seq_file *seq, struct dn_route *rt)
> > >> > {
> > >> >     struct dn_rt_cache_iter_state *s = rcu_dereference(seq->private);
> > >> > 
> > >> >     rt = rt->u.dst.dn_next;
> > >> >     while(!rt) {
> > >> >             rcu_read_unlock_bh();
> > >> >             if (--s->bucket < 0)
> > >> >                     break;
>
> Thank you for the info!  Stupid question #3: what sequence of events
> would the smp_read_barrier_depends() be defending against?

The reading of rt from the hash bucket and the dereferencing above.
We need to make sure that we see the initialised rt.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
