Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbYFDNud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbYFDNud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 09:50:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752577AbYFDNuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 09:50:23 -0400
Received: from relay1.sgi.com ([192.48.171.29]:41205 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752564AbYFDNuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 09:50:22 -0400
Date: Wed, 4 Jun 2008 08:50:20 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Cliff Wickman <cpw@sgi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] hotplug cpus on ia64
Message-ID: <20080604135020.GB18993@sgi.com>
References: <E1K1l2y-0007bu-44@eag09.americas.sgi.com> <1212154614.12349.244.camel@twins> <20080603221759.GA19039@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080603221759.GA19039@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2008 at 05:17:59PM -0500, Cliff Wickman wrote:
> 
> On Fri, May 30, 2008 at 03:36:54PM +0200, Peter Zijlstra wrote:
> > On Thu, 2008-05-29 at 11:32 -0500, Cliff Wickman wrote:
> > > I put in counters and see that schedule() is never again entered by cpu 17
> > > after it is downed the 3rd time.
> > > (it is entered after being up'd the first two times)
> > > 
> > > The kstopmachine thread is bound to cpu 17 by __stop_machine_run()'s call
> > > to kthread_bind().
> > > 
> > > A cpu does not schedule after being downed, of course.  But it does again
> > > after being up'd.  
> > > Why would the second up be different?  Following it, if the cpu is
> > > downed it never schedules again.
> > > 
> > > If I always bind kstopmachine to cpu 0 the problem disappears.
> > 
> > does:
> > 
> > echo -1 > /proc/sys/kernel/sched_rt_runtime_us
> > 
> > fix the problem?
> 
> Yes! It does. 
> 
> Dimitri Sivanich has run into what looks like a similar problem.
> Hope the above workaround is a good clue to its solution.

This fixes the problem I was seeing as well.
