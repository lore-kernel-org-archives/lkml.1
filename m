Return-Path: <linux-kernel-owner+w=401wt.eu-S1761225AbZDAJE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761225AbZDAJE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 05:04:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbZDAJEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 05:04:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:46234 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbZDAJEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 05:04:46 -0400
Date: Wed, 1 Apr 2009 11:04:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/15] perf_counter: unify and fix delayed counter
	wakeup
Message-ID: <20090401090433.GA27865@elte.hu>
References: <20090330170701.856843742@chello.nl> <20090330171023.153932974@chello.nl> <18897.44531.88862.844627@cargo.ozlabs.ibm.com> <1238481425.28248.1377.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238481425.28248.1377.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-03-31 at 16:45 +1100, Paul Mackerras wrote:
> > Peter Zijlstra writes:
> > 
> > > +void perf_counter_wakeup(struct perf_counter *counter)
> > > +{
> > > +	struct perf_mmap_data *data;
> > > +
> > > +	rcu_read_lock();
> > > +	data = rcu_dereference(counter->data);
> > > +	if (data) {
> > > +		(void)atomic_xchg(&data->wakeup, POLL_IN);
> > 
> > Really just a nit, but how is this atomic_xchg any different from
> > atomic_set(&data->wakeup, POLL_IN) aside from being slower?
> 
> Probably, I got my head in a twist, atomic_set() is simply an 
> unlocked assignment (although volatile), and I read the value 
> using a locked xchg().
> 
> I wasn't sure how these two would interact and so I chickened out 
> :-)

The fact that you needed to use an ugly cast to silence the compiler 
should have told you that we kernel developers never chicken out! :)

(And if we do, it's called an orderly tactical retreat.)

	Ingo
