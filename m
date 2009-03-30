Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZC3Pyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZC3Pyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 11:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbZC3Py0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 11:54:26 -0400
Received: from gir.skynet.ie ([193.1.99.77]:42052 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbZC3PyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 11:54:25 -0400
Date: Mon, 30 Mar 2009 16:54:19 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/3] slub: add per-cache slab thrash ratio
Message-ID: <20090330155419.GC27169@csn.ul.ie>
References: <alpine.DEB.2.00.0903292241300.15813@chino.kir.corp.google.com> <alpine.DEB.2.00.0903292242510.15813@chino.kir.corp.google.com> <1238397091.26742.35.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1238397091.26742.35.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 10:11:31AM +0300, Pekka Enberg wrote:
> On Sun, 2009-03-29 at 22:43 -0700, David Rientjes wrote:
> > The slab_thrash_ratio for each cache do not have non-zero defaults
> > (yet?).
> 
> If we're going to merge this code, I think it would be better to put a
> non-zero default there; otherwise we won't be able to hit potential
> performance regressions or bugs. Furthermore, the optimization is not
> very useful on large scale if people need to enable it themselves.
> 
> Maybe stick 20 there and run tbench, sysbench, et al to see if it makes
> a difference? I'm cc'ing Mel in case he has some suggestions how to test
> it.
> 

netperf and tbench will both pound the sl*b allocator far more than sysbench
will in my opinion although I don't have figures on-hand to back that up. In
the case of netperf, it might be particular obvious if the client is on one
CPU and the server on another because I believe that means all allocs happen
on one CPU and all frees on another.

I have a vague concern that such a tunable needs to exist at all though
and wonder what workloads it can hurt when set to 20 for example versus any
other value.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
