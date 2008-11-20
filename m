Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYKTLNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYKTLNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:13:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbYKTLM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:12:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:51873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbYKTLMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:12:55 -0500
Date: Thu, 20 Nov 2008 12:12:53 +0100
From: Nick Piggin <npiggin@suse.de>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, axboe@kernel.dk
Subject: Re: [PATCH 1/1] cpumask: smp_call_function_many()
Message-ID: <20081120111253.GA3288@wotan.suse.de>
References: <20081119144710.59CA1DDDDB@ozlabs.org> <200811201514.09511.rusty@rustcorp.com.au> <200811201757.07726.nickpiggin@yahoo.com.au> <200811202138.05232.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811202138.05232.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2008 at 09:38:04PM +1030, Rusty Russell wrote:
> On Thursday 20 November 2008 17:27:07 Nick Piggin wrote:
> > On Thursday 20 November 2008 15:44, Rusty Russell wrote:
> > > I can prepare a separate patch which just changes this over, rather than
> > > doing it as part of the smp_call_function_many() conversion, but I
> > > couldn't stomach touching that quiescing code :(
> >
> > What's wrong with it? It's well commented and I would have thought pretty
> > simple. A bit ugly, but straightforward. I still don't really see why it
> > needs changing.
> 
> Ah, sorry if I was unclear.  The point of this 150+ patch series is to get 
> cpumasks off the stack.
> 
> Here's the problem:
> 
> struct call_function_data {
> 	struct call_single_data csd;
> 	spinlock_t lock;
> 	unsigned int refs;
> 	cpumask_t cpumask;
> 	struct rcu_head rcu_head;
> };
> ...
> 
> static void smp_call_function_mask_quiesce_stack(cpumask_t mask)
> {
> 	struct call_single_data data;
> ...
> 
> So, it's far simpler just to fix the code to do the "dumb" thing.

Ah, OK. That's a pretty good reason, so fine by me then.

