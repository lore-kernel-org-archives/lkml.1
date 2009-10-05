Return-Path: <linux-kernel-owner+w=401wt.eu-S1752948AbZJEOt7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbZJEOt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 10:49:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbZJEOt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 10:49:58 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:49396 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752525AbZJEOt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 10:49:58 -0400
Date: Mon, 5 Oct 2009 10:43:12 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mel@csn.ul.ie>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, mingo@elte.hu, rusty@rustcorp.com.au,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 13/20] this_cpu_ops: page allocator conversion
In-Reply-To: <20091005094527.GB12681@csn.ul.ie>
Message-ID: <alpine.DEB.1.10.0910051040270.16359@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <20091001212600.068637154@gentwo.org> <20091002151437.GP21906@csn.ul.ie> <alpine.DEB.1.10.0910021331020.26189@gentwo.org> <20091005094527.GB12681@csn.ul.ie>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Oct 2009, Mel Gorman wrote:

> > Right. WE need to move the local_irq_save() up two lines.
>
> Just so I'm 100% clear, IRQ disabling is considered a preemption point?

Yes.

> > Move disable interrupts before the this_cpu_ptr?
> >
>
> In this case, why not move this_cpu_ptr() down until its first use just
> before the if (cold) check? It'll still be within the IRQ disabling but
> without significantly increasing the amount of time the IRQ is disabled.

Good idea. Ill put that into the next release.

> > > > + * Before this call only boot pagesets were available.
> > > > + * Boot pagesets will no longer be used after this call is complete.
> > >
> > > If they are no longer used, do we get the memory back?
> >
> > No we need to keep them for onlining new processors.
> >
>
> That comment would appear to disagree.

The comment is accurate for a processor. Once the pagesets are allocated
for a processor then the boot pageset is no longer used.
