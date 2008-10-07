Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYJGRW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYJGRW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 13:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYJGRWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 13:22:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:54000 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYJGRWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 13:22:46 -0400
Subject: Re: [PATCH, RFC] percpu_counters: make fbc->count read atomic on
	32 bit architecture
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: richard kennedy <richard@rsk.demon.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
In-Reply-To: <48EB97B2.3010406@rsk.demon.co.uk>
References: <E1KmetO-00053M-5u@closure.thunk.org>
	 <20081006232322.c383fac5.akpm@linux-foundation.org>
	 <1223373347.26330.19.camel@lappy.programming.kicks-ass.net>
	 <48EB97B2.3010406@rsk.demon.co.uk>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 19:22:20 +0200
Message-Id: <1223400140.26330.76.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-10-07 at 18:09 +0100, richard kennedy wrote:
> Peter Zijlstra wrote:
> .....
> > +static inline int atomic64_dec_and_test(atomic64_t *v)
> > +{
> > +	int ret;
> > +
> > +	write_seqlock(&v->slock);
> > +	v->counter--;
> > +	ret = !v->counter;
> > +	write_sequnlock(&v->slock);
> > +
> > +	return ret;
> > +}
> > +
> > +static inline int atomic64_add_and_test(atomic64_t *v)
> > +{
> > +	int ret;
> > +
> > +	write_seqlock(&v->slock);
> > +	v->counter++;
> > +	ret = !v->counter;
> > +	write_sequnlock(&v->slock);
> > +
> > +	return ret;
> > +}
> would it be more logical to call this atomic64_inc_and_test to match the
> above dec_and_test ?

Yeah, I know of at least 2 other bugs in here, but I wanted some real
early feedback :-)

