Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbXKMCUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbXKMCUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 21:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751718AbXKMCUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 21:20:40 -0500
Received: from mga10.intel.com ([192.55.52.92]:11317 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751029AbXKMCUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 21:20:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,408,1188802800"; 
   d="scan'208";a="380042365"
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Benny Halevy <bhalevy@panasas.com>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       aneesh.kumar@linux.vnet.ibm.com
In-Reply-To: <1194886100.9713.13.camel@twins>
References: <1194601672.20251.60.camel@ymzhang>
	 <1194602064.6289.157.camel@twins>  <1194833640.20251.80.camel@ymzhang>
	 <1194860728.7179.6.camel@twins>  <1194861112.20251.124.camel@ymzhang>
	 <1194873980.7179.31.camel@twins>  <47386BC4.3050403@panasas.com>
	 <1194886100.9713.13.camel@twins>
Content-Type: text/plain; charset=utf-8
Date: Tue, 13 Nov 2007 10:19:22 +0800
Message-Id: <1194920362.20251.161.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-11-12 at 17:48 +0100, Peter Zijlstra wrote:
> On Mon, 2007-11-12 at 17:05 +0200, Benny Halevy wrote:
> > On Nov. 12, 2007, 15:26 +0200, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > Single socket, dual core opteron, 2GB memory
> > > Single SATA disk, ext3
> > > 
> > > x86_64 kernel and userland
> > > 
> > > (dirty_background_ratio, dirty_ratio) tunables
> > > 
> > > ---- (5,10) - default
> > > 
> > > 2.6.23.1-42.fc8 #1 SMP
> > > 
> > >           524288       4   59580   60356
> > >           524288       4   59247   61101
> > >           524288       4   61030   62831
> > > 
> > > 2.6.24-rc2 #28 SMP PREEMPT
> > > 
> > >           524288       4   49277   56582
> > >           524288       4   50728   61056
> > >           524288       4   52027   59758
> > >           524288       4   51520   62426
> > > 
> > > 
> > > ---- (20,40) - similar to your 8GB
> > > 
> > > 2.6.23.1-42.fc8 #1 SMP
> > > 
> > >           524288       4  225977  447461
> > >           524288       4  232595  496848
> > >           524288       4  220608  478076
> > >           524288       4  203080  445230
> > > 
> > > 2.6.24-rc2 #28 SMP PREEMPT
> > > 
> > >           524288       4   54043   83585
> > >           524288       4   69949  516253
> > >           524288       4   72343  491416
> > >           524288       4   71775  492653
> > > 
> > > ---- (60,80) - overkill
> > > 
> > > 2.6.23.1-42.fc8 #1 SMP
> > > 
> > >           524288       4  208450  491892
> > >           524288       4  216262  481135
> > >           524288       4  221892  543608
> > >           524288       4  202209  574725
> > >           524288       4  231730  452482
> > > 
> > > 2.6.24-rc2 #28 SMP PREEMPT
> > > 
> > >           524288       4   49091   86471
> > >           524288       4   65071  217566
> > >           524288       4   72238  492172
> > >           524288       4   71818  492433
> > >           524288       4   71327  493954
> > > 
> > > 
> > > While I see that the write speed as reported under .24 ~70MB/s is much
> > > lower than the one reported under .23 ~200MB/s, I find it very hard to
> > > believe my poor single SATA disk could actually do the 200MB/s for
> > > longer than its cache 8/16 MB (not sure).
> > > 
> > > vmstat shows that actual IO is done, even though the whole 512MB could
> > > fit in cache, hence my suspicion that the ~70MB/s is the most realistic
> > > of the two.
> > 
> > Even 70 MB/s seems too high.  What throughput do you see for the
> > raw disk partition/
> > 
> > Also, are the numbers above for successive runs?
> > It seems like you're seeing some caching effects so
> > I'd recommend using a file larger than your cache size and
> > the -e and -c options (to include fsync and close in timings)
> > to try to eliminate them.
> 
> ------ iozone -i 0 -r 4k -s 512m -e -c
> 
> .23 (20,40)
> 
>           524288       4   31750   33560
>           524288       4   29786   32114
>           524288       4   29115   31476
> 
> .24 (20,40)
> 
>           524288       4   25022   32411
>           524288       4   25375   31662
>           524288       4   26407   33871
> 
> 
> ------ iozone -i 0 -r 4k -s 4g -e -c
> 
> .23 (20,40)
> 
>          4194304       4   39699   35550
>          4194304       4   40225   36099
> 
> 
> .24 (20,40)
> 
>          4194304       4   39961   41656
>          4194304       4   39244   39673
> 
> 
> Yanmin, for that benchmark you ran, what was it meant to measure?
> From what I can make of it its just write cache benching.
Yeah. It's quite related to cache. I did more testing on my stoakley machine (8 cores,
8GB mem). If I reduce the memory to 4GB, the speed will be far slower.

> 
> One thing I don't understand is how the write numbers are so much lower
> than the rewrite numbers. The iozone code (which gives me headaches,
> damn what a mess) seems to suggest that the only thing that is different
> is the lack of block allocation.
It might be a good direction.

> 
> Linus posted a patch yesterday fixing up a regression in the ext3 bitmap
> block allocator, /me goes apply that patch and rerun the tests.
> 
> > > ---- (20,40) - similar to your 8GB
> > > 
> > > 2.6.23.1-42.fc8 #1 SMP
> > > 
> > >           524288       4  225977  447461
> > >           524288       4  232595  496848
> > >           524288       4  220608  478076
> > >           524288       4  203080  445230
> > > 
> > > 2.6.24-rc2 #28 SMP PREEMPT
> > > 
> > >           524288       4   54043   83585
> > >           524288       4   69949  516253
> > >           524288       4   72343  491416
> > >           524288       4   71775  492653
> 
> 2.6.24-rc2 +
>         patches/wu-reiser.patch
>         patches/writeback-early.patch
>         patches/bdi-task-dirty.patch
>         patches/bdi-sysfs.patch
>         patches/sched-hrtick.patch
>         patches/sched-rt-entity.patch
>         patches/sched-watchdog.patch
>         patches/linus-ext3-blockalloc.patch
> 
>           524288       4  179657  487676
>           524288       4  173989  465682
>           524288       4  175842  489800
> 
> 
> Linus' patch is the one that makes the difference here. So I'm unsure
> how you bisected it down to:
> 
>   04fbfdc14e5f48463820d6b9807daa5e9c92c51f
Originally, my test suite is just to pick up the result of first run. Your prior
patch(speed up writeback ramp-up on clean systems) fixed an issue about first
run result regression. So my bisect captured it.

However, late on, I found following run have different results. A moment ago,
I retested 04fbfdc14e5f48463820d6b9807daa5e9c92c51f by:
#git checkout 04fbfdc14e5f48463820d6b9807daa5e9c92c51f
#make

Then, reverse your patch. It looks like 04fbfdc14e5f48463820d6b9807daa5e9c92c51f
is not the root cause of following run regression. I will change my test suite to
make it run for many times and do a new bisect.

> These results seem to point to
> 
>   7c9e69faa28027913ee059c285a5ea8382e24b5d
I tested 2.6.24-rc2 which already includes above patch. 2.6.24-rc2 has the same
regression like 2.6.24-rc1.

-yanmin
