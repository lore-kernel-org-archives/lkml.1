Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZIJHtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZIJHtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 03:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZIJHtL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 03:49:11 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33701 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751916AbZIJHtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 03:49:10 -0400
Date: Thu, 10 Sep 2009 09:49:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910074902.GA10634@elte.hu>
References: <1252423398.7746.97.camel@twins> <20090908203409.GJ18599@kernel.dk> <20090909061308.GA28109@elte.hu> <1252486344.28645.18.camel@marge.simson.net> <20090909091009.GR18599@kernel.dk> <20090909115429.GY18599@kernel.dk> <20090909122006.GA18599@kernel.dk> <1252565738.7205.29.camel@laptop> <20090910065856.GL18599@kernel.dk> <20090910073317.GP18599@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090910073317.GP18599@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> On Thu, Sep 10 2009, Jens Axboe wrote:
> > On Thu, Sep 10 2009, Peter Zijlstra wrote:
> > > On Wed, 2009-09-09 at 14:20 +0200, Jens Axboe wrote:
> > > > 
> > > > One thing I also noticed is that when I have logged in, I 
> > > > run xmodmap manually to load some keymappings (I always tell 
> > > > myself to add this to the log in scripts, but I 
> > > > suspend/resume this laptop for weeks at the time and forget 
> > > > before the next boot). With the stock kernel, xmodmap will 
> > > > halt X updates and take forever to run. With BFS, it 
> > > > returned instantly. As I would expect.
> > > 
> > > Can you provide a little more detail (I'm a xmodmap n00b), how does one
> > > run xmodmap and maybe provide your xmodmap config?
> > 
> > Will do, let me get the notebook and strace time it on both bfs and
> > mainline.
> 
> Here's the result of running perf stat xmodmap .xmodmap-carl on 
> the notebook. I have attached the .xmodmap-carl file, it's pretty 
> simple. I have also attached the output of strace -o foo -f -tt 
> xmodmap .xmodmap-carl when run on 2.6.31-rc9.
> 
> 2.6.31-rc9-bfs210
> 
>  Performance counter stats for 'xmodmap .xmodmap-carl':
> 
>      153.994976  task-clock-msecs         #      0.990 CPUs   (scaled from 99.86%)
>               0  context-switches         #      0.000 M/sec  (scaled from 99.86%)
>               0  CPU-migrations           #      0.000 M/sec  (scaled from 99.86%)
>             315  page-faults              #      0.002 M/sec  (scaled from 99.86%)
>   <not counted>  cycles                  
>   <not counted>  instructions            
>   <not counted>  cache-references        
>   <not counted>  cache-misses            
> 
>     0.155573406  seconds time elapsed

(Side question: what hardware is this - why are there no hw 
counters? Could you post the /proc/cpuinfo?)

> 2.6.31-rc9
> 
>  Performance counter stats for 'xmodmap .xmodmap-carl':
> 
>        8.529265  task-clock-msecs         #      0.001 CPUs 
>              23  context-switches         #      0.003 M/sec
>               1  CPU-migrations           #      0.000 M/sec
>             315  page-faults              #      0.037 M/sec
>   <not counted>  cycles                  
>   <not counted>  instructions            
>   <not counted>  cache-references        
>   <not counted>  cache-misses            
> 
>    11.804293482  seconds time elapsed

Thanks - so we context-switch 23 times - possibly to Xorg. But 11 
seconds is extremely long. Will try to reproduce it.

	Ingo
