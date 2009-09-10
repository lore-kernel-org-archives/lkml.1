Return-Path: <linux-kernel-owner+w=401wt.eu-S1755244AbZIJLme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244AbZIJLme (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 07:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752145AbZIJLme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 07:42:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:44123 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751510AbZIJLmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 07:42:33 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX191ONsERnh1XDEo0LgZDeqX2r6j+hwvGlkxhqvZK6
	YuxqNqLv2G+QdC
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nikos Chantziaras <realnc@arcor.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20090910113516.GP18599@kernel.dk>
References: <20090910064059.GA22646@elte.hu>
	 <20090910095457.GD18599@kernel.dk> <20090910100321.GA7922@elte.hu>
	 <20090910101137.GH18599@kernel.dk> <20090910102837.GJ18599@kernel.dk>
	 <1252580251.18659.10.camel@marge.simson.net>
	 <20090910110912.GL18599@kernel.dk>
	 <1252581670.18659.11.camel@marge.simson.net>
	 <20090910112443.GN18599@kernel.dk>
	 <1252582108.18659.12.camel@marge.simson.net>
	 <20090910113516.GP18599@kernel.dk>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 13:42:33 +0200
Message-Id: <1252582953.13128.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 13:35 +0200, Jens Axboe wrote:
> On Thu, Sep 10 2009, Mike Galbraith wrote:
> > On Thu, 2009-09-10 at 13:24 +0200, Jens Axboe wrote:
> > > On Thu, Sep 10 2009, Mike Galbraith wrote:
> > 
> > > > xmodmap doesn't seem to be running in this sample.
> > > 
> > > That's weird, it was definitely running. I did:
> > > 
> > > sleep 1; xmodmap .xmodmap-carl
> > > 
> > > in one xterm, and then switched to the other and ran the sched_debug
> > > dump. I have to do it this way, as X will not move focus once xmodmap
> > > starts running. It could be that xmodmap is mostly idle, and the real
> > > work is done by Xorg and/or xfwm4 (my window manager).
> > 
> > Hm.  Ok, I'll crawl over it, see if anything falls out.
> 
> That seems to be confirmed with the low context switch rate of the perf
> stat of xmodmap. If I run perf stat -a to get a system wide collection
> for xmodmap, I get:
> 
>  Performance counter stats for 'xmodmap .xmodmap-carl':
> 
>    20112.060925  task-clock-msecs         #      1.998 CPUs 
>          629360  context-switches         #      0.031 M/sec
>               8  CPU-migrations           #      0.000 M/sec
>           13489  page-faults              #      0.001 M/sec
>   <not counted>  cycles                  
>   <not counted>  instructions            
>   <not counted>  cache-references        
>   <not counted>  cache-misses            
> 
>    10.067532449  seconds time elapsed
> 
> And again, system is idle while this is happening. Can't rule out that
> this is some kind of user space bug of course.

All I'm seeing so far is massive CPU usage for dinky job.

	-Mike

