Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbXKELyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbXKELyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 06:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbXKELyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 06:54:10 -0500
Received: from rhun.apana.org.au ([64.62.148.172]:3134 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750887AbXKELyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 06:54:09 -0500
From: Herbert Xu <herbert@gondor.apana.org.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: dn_route.c momentarily exiting RCU read-side critical section
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       SteveW@acm.org, dipankar@in.ibm.com
Organization: Core
In-Reply-To: <20071030151254.GA8285@linux.vnet.ibm.com>
X-Newsgroups: apana.lists.os.linux.kernel,apana.lists.os.linux.netdev
User-Agent: tin/1.7.4-20040225 ("Benbecula") (UNIX) (Linux/2.6.17-rc4 (i686))
Message-Id: <E1Ip0Vs-0002zP-00@gondolin.me.apana.org.au>
Date: Mon, 05 Nov 2007 19:53:04 +0800
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
>> 
>> > net/decnet/dn_route.c in dn_rt_cache_get_next() is as follows:
>> > 
>> > static struct dn_route *dn_rt_cache_get_next(struct seq_file *seq, struct dn_route *rt)
>> > {
>> >     struct dn_rt_cache_iter_state *s = rcu_dereference(seq->private);
>> > 
>> >     rt = rt->u.dst.dn_next;
>> >     while(!rt) {
>> >             rcu_read_unlock_bh();
>> >             if (--s->bucket < 0)
>> >                     break;
>
> OK, for my next stupid question: why is the rcu_dereference(seq->private)
> required, as opposed to simply seq->private?

It was put there by someone who went through the code converting
all occurances of smp_read_barrier_depends to rcu_dereference.
In this instance the rcu_dereference conversion doesn't make much
sense so we should probably just revert it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
