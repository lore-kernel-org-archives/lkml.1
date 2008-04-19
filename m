Return-Path: <linux-kernel-owner+w=401wt.eu-S1762310AbYDSSLw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762310AbYDSSLw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:11:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbYDSSLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:11:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343AbYDSSLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:11:44 -0400
Date: Sat, 19 Apr 2008 14:03:06 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: prasad@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu, mathieu.desnoyers@polymtl.ca
Subject: Re: [RFC PATCH 1/2] Marker probes in futex.c
Message-ID: <20080419180306.GA29968@redhat.com>
References: <20080415115058.GA6788@in.ibm.com> <20080415115314.GA6975@in.ibm.com> <1208260942.6395.6.camel@twins> <20080415155223.GA6935@in.ibm.com> <1208361092.6395.81.camel@twins> <y0m1w54cf82.fsf@ton.toronto.redhat.com> <1208501204.7115.60.camel@twins> <20080418142949.GB3922@redhat.com> <1208616747.6452.3.camel@lappy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1208616747.6452.3.camel@lappy>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, Apr 19, 2008 at 04:52:26PM +0200, Peter Zijlstra wrote:
> > It's not just that - it's a whole package including easy creation of
> > new markers, the code that manages their activation and deactivation,
> > the tool code that connects up to receive new events *and parameters*.
> > [...]
> I'm thinking the two use-cases are confused here. So we have
> 
>  a) permanent markers
>  b) ad-hoc debug markers

OTOH I think this is a false dichotomy.  Debugging is not only done by
a subsystem maintainer during the merge/rc period.  When something
goes wrong on a deployed machine, problem diagnosis requires data,
which ideally should be gathered as non-intrusively as possible - that
means no recompiling / rebooting, and ideally very little slowdown.

I bet that many of those markers you might consider "ad-hoc" would in
fact have some post-release diagnostic value.  Now, maybe in the case
of futexes, the kernel makes no sophisticated decisions that may need
subsequent review.  Maybe all the internals are directly calculable
from the results visible at the system call level (which threads block
and which return).  But this is certainly not so for many other parts
of the kernel.

With markers, you don't have to make this an agonizing decision.  You
just insert markers, regardless of whether it's high-level, universal,
"permanent"; or whether it's low-level, diagnostic, temporary.  The
same consumer tools will work for them all.

- FChE
