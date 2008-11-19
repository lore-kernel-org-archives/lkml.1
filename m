Return-Path: <linux-kernel-owner+w=401wt.eu-S1752645AbYKSVsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbYKSVsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:48:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYKSVr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:47:57 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35917 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750695AbYKSVr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:47:57 -0500
Date: Wed, 19 Nov 2008 15:47:56 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Max Krasnyansky <maxk@qualcomm.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and no load balance
Message-ID: <20081119214756.GA3582@sgi.com>
References: <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com> <4924762B.8000108@novell.com> <20081119203340.GC2383@sgi.com> <49248560.1020501@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49248560.1020501@novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 04:30:08PM -0500, Gregory Haskins wrote:
> Dimitri Sivanich wrote:
> > On Wed, Nov 19, 2008 at 03:25:15PM -0500, Gregory Haskins wrote:
> >   
> >> It sounds like the problem with my code is that "null sched domain"
> >> translates into "default root-domain" which is understandably unexpected
> >> by Dimitri (and myself).  Really I intended root-domains to become
> >> associated with each exclusive/disjoint cpuset that is created.  In a
> >> way, non-balanced/isolated cpus could be modeled as an exclusive cpuset
> >> with one member, but that is somewhat beyond the scope of the
> >>     
> >
> > Actually, at one time, that is how things were setup.  Setting the
> > cpu_exclusive bit on a single cpu cpuset would isolate that cpu from
> > load balancing.
> >   
> Do you know if this was pre or post the root-domain code?  Here is a
> reference to the commit:

It was pre root-domain.  That behavior was replaced by addition of the sched_load_balance flag with the following commit (though it was actually removed even earlier):

http://git2.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=029190c515f15f512ac85de8fc686d4dbd0ae731

> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57d885fea0da0e9541d7730a9e1dcf734981a173
> 
> A bisection that shows when this last worked for you would be very
> appreciated if you have the time, Dimitri.
> 
> Regards,
> -Greg
> 
> 


