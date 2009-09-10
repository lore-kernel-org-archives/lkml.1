Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbZIJK2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbZIJK2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 06:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbZIJK2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 06:28:35 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60041 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358AbZIJK2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 06:28:35 -0400
Date: Thu, 10 Sep 2009 12:28:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Nikos Chantziaras <realnc@arcor.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910102837.GJ18599@kernel.dk>
References: <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <20090909180404.GA11027@elte.hu> <4AA80C1E.2080901@arcor.de> <20090910060824.GF1335@elte.hu> <20090910064059.GA22646@elte.hu> <20090910095457.GD18599@kernel.dk> <20090910100321.GA7922@elte.hu> <20090910101137.GH18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910101137.GH18599@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10 2009, Jens Axboe wrote:
> On Thu, Sep 10 2009, Ingo Molnar wrote:
> > 
> > * Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > On Thu, Sep 10 2009, Ingo Molnar wrote:
> > > > 
> > > > * Ingo Molnar <mingo@elte.hu> wrote:
> > > > 
> > > > > > However, the interactivity problems still remain.  Does that 
> > > > > > mean it's not a latency issue?
> > > > > 
> > > > > It means that Jens's test-app, which demonstrated and helped us 
> > > > > fix the issue for him does not help us fix it for you just yet.
> > > > 
> > > > Lemme qualify that by saying that Jens's issues are improved not 
> > > > fixed [he has not re-run with latest latt.c yet] but not all things 
> > > > are fully fixed yet. For example the xmodmap thing sounds 
> > > > interesting - could that be a child-runs-first effect?
> > > 
> > > I thought so too, so when -tip failed to boot I pulled the patches 
> > > from Mike into 2.6.31. It doesn't change anything for xmodmap, 
> > > though.
> > 
> > Note, you can access just the pristine scheduler patches by checking 
> > out and testing tip:sched/core - no need to pull them out and apply.
> > 
> > Your crash looks like clocksource related - that's in a separate 
> > topic which you can thus isolate if you use sched/core.
> 
> I'm building sched/core now and will run the xmodmap test there.

No difference. Then I tried switching NO_NEW_FAIR_SLEEPERS on, and then
I get:

 Performance counter stats for 'xmodmap .xmodmap-carl':

       9.009137  task-clock-msecs         #      0.447 CPUs 
             18  context-switches         #      0.002 M/sec
              1  CPU-migrations           #      0.000 M/sec
            315  page-faults              #      0.035 M/sec
  <not counted>  cycles                  
  <not counted>  instructions            
  <not counted>  cache-references        
  <not counted>  cache-misses            

    0.020167093  seconds time elapsed

Woot!

-- 
Jens Axboe

