Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbXCRB3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbXCRB3C (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2007 21:29:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbXCRB2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Mar 2007 21:28:38 -0400
Received: from holomorphy.com ([66.93.40.71]:60829 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbXCRBZz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2007 21:25:55 -0400
Date: Sat, 17 Mar 2007 18:25:33 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Avi Kivity <avi@argo.co.il>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       ck@vds.kolivas.org, Serge Belyshev <belyshev@depni.sinp.msu.ru>,
       Al Boldi <a1426z@gawab.com>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Nicholas Miell <nmiell@comcast.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: is RSDL an "unfair" scheduler too?
Message-ID: <20070318012533.GB2986@holomorphy.com>
References: <200703042335.26785.a1426z@gawab.com> <20070317074506.GA13685@elte.hu> <87fy84i7nn.fsf@depni.sinp.msu.ru> <200703172048.46267.kernel@kolivas.org> <20070317114903.GA20673@elte.hu> <45FC525D.5000708@argo.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45FC525D.5000708@argo.co.il>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 17, 2007 at 10:41:01PM +0200, Avi Kivity wrote:
> Well, the heuristic here is that process == job.  I'm not sure heuristic 
> is the right name for it, but it does point out a deficieny.
> A cpu-bound process with many threads will overwhelm a cpu-bound single 
> threaded threaded process.
> A job with many processes will overwhelm a job with a single process.
> A user with many jobs can starve a user with a single job.
> I don't think the problem here is heuristics, rather that the 
> scheduler's manages cpu quotas at the task level rather than at the user 
> visible level.  If scheduling were managed at all three hierarchies I 
> mentioned ('job' is a bit artificial, but process and user are not) then:
> - if N users are contending for the cpu on a multiuser machine, each 
> should get just 1/N of available cpu power.  As it is, a user can run a 
> few of your #1 workloads (or a make -j 20) and slow every other user down
> - your example would work perfectly (if we can communicate to the kernel 
> what a job is)
> - multi-threaded processes would not get an unfair advantage

I like this notion very much. I should probably mention pgrp's' typical
association with the notion of "job," at least as far as shells go.

One issue this raises is prioritizing users on a system, threads within
processes, jobs within users, etc. Maybe sessions would make sense, too,
and classes of users, and maybe whatever they call the affairs that pid
namespaces are a part of (someone will doubtless choke on the hierarchy
depth implied here but it doesn't bother me in the least). It's not a
deep or difficult issue. There just needs to be some user API to set the
relative scheduling priorities of all these affairs within the next higher
level of hierarchy, regardless of how many levels of hierarchy (aleph_0?).


-- wli
