Return-Path: <linux-kernel-owner+w=401wt.eu-S1765126AbYEIRZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765126AbYEIRZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 13:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756949AbYEIRZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 13:25:19 -0400
Received: from brick.kernel.dk ([87.55.233.238]:24685 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756359AbYEIRZR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 13:25:17 -0400
Date: Fri, 9 May 2008 19:25:10 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: More io-cpu-affinity results: queue_affinity + rq_affinity
Message-ID: <20080509172510.GW16217@kernel.dk>
References: <481B38D8.7080905@hp.com> <481F0192.9080705@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481F0192.9080705@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05 2008, Alan D. Brunelle wrote:
> Alan D. Brunelle wrote:
> > Continuing to evaluate the potential benefits of the various I/O & CPU
> > affinity options proposed in Jens' origin/io-cpu-affinity branch...
> > 
> > Executive summary (due to the rather long-winded nature of this post):
> > 
> > We again see rq_affinity has positive potential, but not (yet) able to
> > see much benefit to adjusting queue_affinity.
> > 
> > ========================================================
> > 
> <snip>
> > 
> > =====================================================
> > 
> > As noted above, I'm going to do a series of runs to make sure this data
> > holds over a larger data set (in particular the case where I/O is far -
> > looking at QAF on & far to see if the 0.56% is truly representative).
> > Suggestions for other tests to try and show/determine queue_affinity
> > benefits are very welcome.
> 
> 
> The averages (+ min/max error bars) for the reads/second & p_system
> values when taken over 50 runs of the test can be seen at:
> 
> http://free.linux.hp.com/~adb/jens/r_s_50.png
> 
> and
> 
> http://free.linux.hp.com/~adb/jens/p_system_50.png
> 
> respectively. Still shows a potential big win w/ rq_affinity set to 1,
> not much difference at all w/ queue_affinity settings (in fact, not
> seeing any real movement at all when rq_affinity=1).
> 
> 
> 
> I'd still be willing to try other test scenarios to show how
> queue_affinity can really help, but as for now, I'd suggest removing
> that functionality for the present - getting rid of some code until such
> time as we can prove its worth.

Thanks again for doing these numbers Alan, much appreciated! I've had a
hard time finding a use case for moving queuers as well, it's quite
costly. Moving completions are much cheaper, and queuing can typically
be moved in other ways so doing that at the IO level just seems like the
completely wrong thing to do. For keeping things affine on the queuing
side I have some other ideas that don't involve moving tasks around,
perhaps that'll be a good complement for that.

-- 
Jens Axboe

