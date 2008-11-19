Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYKSUdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYKSUdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:33:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYKSUdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:33:41 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33880 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752773AbYKSUdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:33:41 -0500
Date: Wed, 19 Nov 2008 14:33:40 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and no load balance
Message-ID: <20081119203340.GC2383@sgi.com>
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com> <4924762B.8000108@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4924762B.8000108@novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 03:25:15PM -0500, Gregory Haskins wrote:
> It sounds like the problem with my code is that "null sched domain"
> translates into "default root-domain" which is understandably unexpected
> by Dimitri (and myself).  Really I intended root-domains to become
> associated with each exclusive/disjoint cpuset that is created.  In a
> way, non-balanced/isolated cpus could be modeled as an exclusive cpuset
> with one member, but that is somewhat beyond the scope of the

Actually, at one time, that is how things were setup.  Setting the
cpu_exclusive bit on a single cpu cpuset would isolate that cpu from
load balancing.

> root-domain code as it stands today.  My primary concern was that
> Dimitri reports that even creating a disjoint cpuset per cpu does not
> yield an isolated root-domain per cpu.  Rather they all end up in the
> default root-domain, and this is not what I intended at all.
> 
> However, as a secondary goal it would be nice to somehow directly
> support the "no-load-balance" option without requiring explicit
> exclusive per-cpu cpusets to do it.  The proper mechanism (IMHO) to
> scope the scheduler to a subset of cpus (including only "self") is
> root-domains so I would prefer to see the solution based on that. 
> However, today there is a rather tight coupling of root-domains and
> cpusets, so this coupling would likely have to be relaxed a little bit
> to get there.
> 
> There are certainly other ways to solve the problem as well.  But seeing
> as how I intended root-domains to represent the effective partition
> scope of the scheduler, this seems like a natural fit in my mind until
> its proven to me otherwise.
>

Agreed. 
