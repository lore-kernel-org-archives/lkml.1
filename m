Return-Path: <linux-kernel-owner+w=401wt.eu-S935204AbYBVOAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935204AbYBVOAW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 09:00:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760599AbYBVOAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 09:00:10 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47291 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbYBVOAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 09:00:08 -0500
Subject: Re: [PATCH sched-devel 0/7] CPU isolation extensions
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: markh@compro.net
Cc: Max Krasnyanskiy <maxk@qualcomm.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul Jackson <pj@sgi.com>
In-Reply-To: <47BED03A.5070707@compro.net>
References: <47BE35B7.2070104@qualcomm.com> <1203680600.6242.20.camel@lappy>
	 <47BED03A.5070707@compro.net>
Content-Type: text/plain
Date: Fri, 22 Feb 2008 14:59:46 +0100
Message-Id: <1203688786.6242.27.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-22 at 08:38 -0500, Mark Hounschell wrote:

> >> List of commits
> >>    cpuisol: Make cpu isolation configrable and export isolated map
> >  
> > cpu_isolated_map was a bad hack when it was introduced, I feel we should
> > deprecate it and fully integrate the functionality into cpusets. That would
> > give a much more flexible end-result.
> > 
> > CPU-sets can already isolate cpus by either creating a cpu outside of any set,
> > or a set with a single cpu not shared by any other sets.
> > 
> 
> Peter, what about when I am NOT using cpusets and are disabled in my config but
> I still want to use this?

Then you enable it?

> >>    cpuisol: Do not schedule workqueues on the isolated CPUs
> >  
> > (per-cpu workqueues, the single ones are treated in the previous section)
> > 
> > I still strongly disagree with this approach. Workqueues are passive, they
> > don't do anything unless work is provided to them. By blindly not starting them
> > you handicap the system and services that rely on them.
> > 
> 
> Have things changed since since my first bad encounter with Workqueues.
> I am referring to this thread. 
> 
> http://kerneltrap.org/mailarchive/linux-kernel/2007/5/29/97039 

Just means you get to fix those problems. By blindly not starting them
you introduce others.

