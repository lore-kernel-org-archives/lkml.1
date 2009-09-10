Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbZIJLYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbZIJLYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 07:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbZIJLYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 07:24:42 -0400
Received: from brick.kernel.dk ([93.163.65.50]:32930 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbZIJLYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 07:24:41 -0400
Date: Thu, 10 Sep 2009 13:24:44 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Nikos Chantziaras <realnc@arcor.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910112443.GN18599@kernel.dk>
References: <4AA80C1E.2080901@arcor.de> <20090910060824.GF1335@elte.hu> <20090910064059.GA22646@elte.hu> <20090910095457.GD18599@kernel.dk> <20090910100321.GA7922@elte.hu> <20090910101137.GH18599@kernel.dk> <20090910102837.GJ18599@kernel.dk> <1252580251.18659.10.camel@marge.simson.net> <20090910110912.GL18599@kernel.dk> <1252581670.18659.11.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252581670.18659.11.camel@marge.simson.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10 2009, Mike Galbraith wrote:
> On Thu, 2009-09-10 at 13:09 +0200, Jens Axboe wrote:
> > On Thu, Sep 10 2009, Mike Galbraith wrote:
> > > On Thu, 2009-09-10 at 12:28 +0200, Jens Axboe wrote:
> > > 
> > > > No difference. Then I tried switching NO_NEW_FAIR_SLEEPERS on, and then
> > > > I get:
> > > > 
> > > >  Performance counter stats for 'xmodmap .xmodmap-carl':
> > > > 
> > > >        9.009137  task-clock-msecs         #      0.447 CPUs 
> > > >              18  context-switches         #      0.002 M/sec
> > > >               1  CPU-migrations           #      0.000 M/sec
> > > >             315  page-faults              #      0.035 M/sec
> > > >   <not counted>  cycles                  
> > > >   <not counted>  instructions            
> > > >   <not counted>  cache-references        
> > > >   <not counted>  cache-misses            
> > > > 
> > > >     0.020167093  seconds time elapsed
> > > > 
> > > > Woot!
> > > 
> > > Something is very seriously hosed on that box... clock?
> > 
> > model name      : Genuine Intel(R) CPU           T2400  @ 1.83GHz
> > 
> > Throttles down to 1.00GHz when idle.
> > 
> > > Can you turn it back on, and do..
> > 
> > I guess you mean turn NEW_FAIR_SLEEPERS back on, correct?
> > 
> > > 	while sleep .1; do cat /proc/sched_debug >> foo; done 
> > > ..on one core, and (quickly;) xmodmap .xmodmap-carl, then send me a few
> > > seconds worth (gzipped up) to eyeball?
> > 
> > Attached.
> 
> xmodmap doesn't seem to be running in this sample.

That's weird, it was definitely running. I did:

sleep 1; xmodmap .xmodmap-carl

in one xterm, and then switched to the other and ran the sched_debug
dump. I have to do it this way, as X will not move focus once xmodmap
starts running. It could be that xmodmap is mostly idle, and the real
work is done by Xorg and/or xfwm4 (my window manager).

-- 
Jens Axboe

