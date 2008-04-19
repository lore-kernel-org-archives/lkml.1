Return-Path: <linux-kernel-owner+w=401wt.eu-S1762201AbYDSSau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762201AbYDSSau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbYDSSak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:30:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39323 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbYDSSak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:30:40 -0400
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, mathieu.desnoyers@polymtl.ca
In-Reply-To: <20080419180306.GA29968@redhat.com>
References: <20080415115058.GA6788@in.ibm.com>
	 <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins>
	 <20080415155223.GA6935@in.ibm.com> <1208361092.6395.81.camel@twins>
	 <y0m1w54cf82.fsf@ton.toronto.redhat.com> <1208501204.7115.60.camel@twins>
	 <20080418142949.GB3922@redhat.com> <1208616747.6452.3.camel@lappy>
	 <20080419180306.GA29968@redhat.com>
Content-Type: text/plain
Date: Sat, 19 Apr 2008 20:29:27 +0200
Message-Id: <1208629769.6452.23.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-04-19 at 14:03 -0400, Frank Ch. Eigler wrote:
> Hi -
> 
> On Sat, Apr 19, 2008 at 04:52:26PM +0200, Peter Zijlstra wrote:
> > > It's not just that - it's a whole package including easy creation of
> > > new markers, the code that manages their activation and deactivation,
> > > the tool code that connects up to receive new events *and parameters*.
> > > [...]
> > I'm thinking the two use-cases are confused here. So we have
> > 
> >  a) permanent markers
> >  b) ad-hoc debug markers
> 
> OTOH I think this is a false dichotomy.  Debugging is not only done by
> a subsystem maintainer during the merge/rc period.  When something
> goes wrong on a deployed machine, problem diagnosis requires data,
> which ideally should be gathered as non-intrusively as possible - that
> means no recompiling / rebooting, and ideally very little slowdown.
> 
> I bet that many of those markers you might consider "ad-hoc" would in
> fact have some post-release diagnostic value.  Now, maybe in the case
> of futexes, the kernel makes no sophisticated decisions that may need
> subsequent review.  Maybe all the internals are directly calculable
> from the results visible at the system call level (which threads block
> and which return).  But this is certainly not so for many other parts
> of the kernel.
> 
> With markers, you don't have to make this an agonizing decision.  You
> just insert markers, regardless of whether it's high-level, universal,
> "permanent"; or whether it's low-level, diagnostic, temporary.  The
> same consumer tools will work for them all.

This again tries into the argument about not making markers depend on
the code structure or implementation details.

I'm really wanting to avoid ever having to be obstructed by a marker. So
any marker that does not represent a solid high level event (to take
Mathieu's example: a context switch is a context switch, and we'll
always have one) I'm not comfortable with merging that upstream.

So even though these ad-hoc markers might have some diagnostic value -
I'll never support merging them. If a customer might have some issue I
can hand him a custom kernel with these markers added in - I see
absolutely no reason to burden upstream with these.

So we _do_ have to make this decision; some shite should just not be
merged but be kept separate.

