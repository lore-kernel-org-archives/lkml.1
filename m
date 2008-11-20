Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbYKTLI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbYKTLI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:08:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbYKTLIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:08:12 -0500
Received: from ozlabs.org ([203.10.76.45]:48556 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754036AbYKTLIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:08:10 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/1] cpumask: smp_call_function_many()
Date: Thu, 20 Nov 2008 21:38:04 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, npiggin@suse.de, axboe@kernel.dk
References: <20081119144710.59CA1DDDDB@ozlabs.org> <200811201514.09511.rusty@rustcorp.com.au> <200811201757.07726.nickpiggin@yahoo.com.au>
In-Reply-To: <200811201757.07726.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811202138.05232.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 November 2008 17:27:07 Nick Piggin wrote:
> On Thursday 20 November 2008 15:44, Rusty Russell wrote:
> > I can prepare a separate patch which just changes this over, rather than
> > doing it as part of the smp_call_function_many() conversion, but I
> > couldn't stomach touching that quiescing code :(
>
> What's wrong with it? It's well commented and I would have thought pretty
> simple. A bit ugly, but straightforward. I still don't really see why it
> needs changing.

Ah, sorry if I was unclear.  The point of this 150+ patch series is to get 
cpumasks off the stack.

Here's the problem:

struct call_function_data {
	struct call_single_data csd;
	spinlock_t lock;
	unsigned int refs;
	cpumask_t cpumask;
	struct rcu_head rcu_head;
};
...

static void smp_call_function_mask_quiesce_stack(cpumask_t mask)
{
	struct call_single_data data;
...

So, it's far simpler just to fix the code to do the "dumb" thing.

Rusty.
