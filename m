Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZIIOAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZIIOAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 10:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752243AbZIIOAU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 10:00:20 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37953 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100AbZIIOAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 10:00:19 -0400
Date: Wed, 9 Sep 2009 09:38:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090909073851.GD1327@ucw.cz>
References: <20090906205952.GA6516@elte.hu> <20090907094953.GP18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907094953.GP18599@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > So ... to get to the numbers - i've tested both BFS and the tip of 
> > the latest upstream scheduler tree on a testbox of mine. I 
> > intentionally didnt test BFS on any really large box - because you 
> > described its upper limit like this in the announcement:
> 
> I ran a simple test as well, since I was curious to see how it performed
> wrt interactiveness. One of my pet peeves with the current scheduler is
> that I have to nice compile jobs, or my X experience is just awful while
> the compile is running.
> 
> Now, this test case is something that attempts to see what
> interactiveness would be like. It'll run a given command line while at
> the same time logging delays. The delays are measured as follows:
> 
> - The app creates a pipe, and forks a child that blocks on reading from
>   that pipe.
> - The app sleeps for a random period of time, anywhere between 100ms
>   and 2s. When it wakes up, it gets the current time and writes that to
>   the pipe.
> - The child then gets woken, checks the time on its own, and logs the
>   difference between the two.
> 
> The idea here being that the delay between writing to the pipe and the
> child reading the data and comparing should (in some way) be indicative
> of how responsive the system would seem to a user.
> 
> The test app was quickly hacked up, so don't put too much into it. The
> test run is a simple kernel compile, using -jX where X is the number of
> threads in the system. The files are cache hot, so little IO is done.
> The -x2 run is using the double number of processes as we have threads,
> eg -j128 on a 64 thread box.

Could you post the source? Someone else might get us
numbers... preferably on dualcore box or something...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
