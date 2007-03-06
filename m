Return-Path: <linux-kernel-owner+w=401wt.eu-S1030269AbXCFWB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030269AbXCFWB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 17:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030289AbXCFWB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 17:01:27 -0500
Received: from 1wt.eu ([62.212.114.60]:4971 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030269AbXCFWB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 17:01:26 -0500
Date: Tue, 6 Mar 2007 22:54:51 +0100
From: Willy Tarreau <w@1wt.eu>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Con Kolivas <kernel@kolivas.org>, jos poortvliet <jos@mijnkamer.nl>,
       ck@vds.kolivas.org, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RSDL completely fair starvation free   interactive cpu scheduler
Message-ID: <20070306215451.GB256@1wt.eu>
References: <200703041800.53360.kernel@kolivas.org> <200703041708.54953.jos@mijnkamer.nl> <45ECA239.5000306@tmr.com> <200703061118.44616.kernel@kolivas.org> <20070306044112.GA10707@1wt.eu> <45EDDF21.7090602@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45EDDF21.7090602@tmr.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bill,

On Tue, Mar 06, 2007 at 04:37:37PM -0500, Bill Davidsen wrote:
(...)
> The point is that no one CPU scheduler will satisfy the policy needs of 
> all users, any more than one i/o scheduler does so. We have realtime 
> scheduling, preempt both voluntary and involuntary, why should we not 
> have multiple CPU schedulers. If Linus has an objection to plugable 
> schedulers, then let's identify what the problem is and address it. If 
> that means one scheduler or the other must be compiled in, or all 
> compiled in and selected, so be it.

I'm not in Linus' head, but I think that he wanted the recurrent scheduler
problems to be addressed first for most users before going further. Too
much choice is often dangerous for quality. For instance, look at all the
netfilter modules. Many of them were completely bogus in their early stages,
and some of them even do mostly the same jobs, and many of them have never
left the "extra" stage. Choice is good to detect users' needs, it's good
for global evolution, but it's not as good when you want to have something
good enough for most people.

> >Then, when we have a generic, good enough scheduler for most situations, I
> >think that it could be good to get the plugsched for very specific usages.
> >People working in HPC may prefer to allocate ressource differently for
> >instance. There may also be people refusing to mix tasks from different 
> >users
> >on two different siblings of one CPU for security reasons, etc... All those
> >would justify a plugable scheduler. But it should not be an excuse to 
> >provide
> >a set of bad schedulers and no good one.
> >
> >  
> Unless you force the the definition of "good" to "what the default 
> scheduler does," there can be no "one" good one. Choice is good, no one 
> is calling for bizarre niche implementations, but we have at minimum 
> three CPU schedulers which as "best" for a large number of users. 
> (current default, and Con's fair and interactive flavors, before you ask).

By "good", I mean a scheduler that is not trivially DoSable, and which
does not cause unexpected long pauses to some processes without any reason
(processes which cannot get any time slice for tens of seconds, or ssh
daemons which freeze under system load, to the point of totally preventing
remote administration past 50% CPU usage on some systems).

> >The CPU scheduler is often compared to the I/O schedulers while in fact 
> >this
> >is a completely different story. The I/O schedulers are needed because the
> >hardware and filesystems may lead to very different behaviours, and the
> >workload may vary a lot (eg: news server, ftp server, cache, desktop, real
> >time streaming, ...). But at least, the default I/O scheduler was good 
> >enough
> >for most usages, and alternative ones are here to provide optimal solutions
> >to specific needs.
> And multiple schedulers are needed because the type of load, mix of 
> loads, and admin preference all require decisions at the policy which 
> can't be covered by a single solution. Or at least none of the existing 
> solutions, and I think letting people tune the guts of scheduler policy 
> is more dangerous than giving a selection of solutions. Linux has been 
> about choice all along, I hope it's nearly time for a solution better 
> than patches to be presented.

There's a difference between CPU and I/O scheduler though. With the CPU
scheduler, you've always had the choice to assign per-process priorities 
with "nice". Don't get me wrong, I'm all for pluggable schedulers, as I'm
an ever unsatisfied optimizer. It's just that I think it has been good to
encourage people to focus on real issues before dispersing efforts on
different needs. I hope that Con's work will eventually get merged and
that the door will be opened towards pluggable schedulers.

Best regards,
Willy

