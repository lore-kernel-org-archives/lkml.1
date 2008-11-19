Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbYKSUVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbYKSUVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYKSUVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:21:11 -0500
Received: from relay1.sgi.com ([192.48.179.29]:45824 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752343AbYKSUVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:21:10 -0500
Date: Wed, 19 Nov 2008 14:21:09 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and no load balance
Message-ID: <20081119202109.GA2383@sgi.com>
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com> <20081119195517.GB662@sgi.com> <49247462.4030101@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49247462.4030101@qualcomm.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 12:17:38PM -0800, Max Krasnyansky wrote:
> 
> 
> Dimitri Sivanich wrote:
> > On Wed, Nov 19, 2008 at 11:49:36AM -0800, Max Krasnyansky wrote:
> >> I think the idea is that we want to make balancer a noop on those processors.
> > 
> > Ultimately, making the balancer a noop on processors with load balancing turned off would be the best solution.
> Yes. I forgot to point out that if we do change cpusets to generate sched
> domain per cpu we want to make sure that balancer is still a noop just like it
> is today with the null sched domain.

Sorry, I meant root_domain per cpu, not sched domain.  Having NULL sched domains for these cpus is fine.

> 
> >> We could change cpusets code to create a root sched domain for each cpu I
> >> guess. But can we maybe scale cpupri some other way ?
> > 
> > It doesn't make sense to me that they'd have a root domain attached that spans more of the the system than that cpu.
> I think 'root' in this case is a bit of a misnomer. What I meant is that each
> non-balanced cpu would be in a separate sched domain.

I think a NULL sched domain, as it is now, is fine.
