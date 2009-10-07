Return-Path: <linux-kernel-owner+w=401wt.eu-S1758934AbZJGKxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934AbZJGKxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758879AbZJGKxg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:53:36 -0400
Received: from brick.kernel.dk ([93.163.65.50]:51070 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758033AbZJGKxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:53:36 -0400
Date: Wed, 7 Oct 2009 12:52:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: zach.brown@oracle.com, linux-aio <linux-aio@kvack.org>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch v4 0/3] aio: implement request batching [more
	performance numbers]
Message-ID: <20091007105259.GD8703@kernel.dk>
References: <x49zl8976g3.fsf@segfault.boston.devel.redhat.com> <x49eipga02o.fsf@segfault.boston.devel.redhat.com> <20091006180628.GB5216@kernel.dk> <x49y6no8jxw.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49y6no8jxw.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 06 2009, Jeff Moyer wrote:
> >> 40K
> >> -------------------------------------------------
> >> Kernel                              NOOP
> >> ------                              ----
> >> 2.6.30.5                            682
> >> 2.6.30.5 (w/o drop_caches)          718
> >> 2.6.30.5+patch_v4                   900
> >> 2.6.30.5+patch_v4 (w/o drop caches) 965
> >> 
> >> 
> >> 128K
> >> -------------------------------------------------
> >> Kernel                              NOOP
> >> ------                              ----
> >> 2.6.30.5                            242
> >> 2.6.30.5 (w/o drop_caches)          350
> >> 2.6.30.5+patch_v4                   292
> >> 2.6.30.5+patch_v4 (w/o drop caches) 420
> >
> > Nice numbers! The patch looks good to me from a quick look, if you want
> > I can throw it into the testing mix tomorrow and see what kind of
> > improvements I see here. With performance increase of that magnitude, we
> > should get it in sooner rather than later.
> 
> I'd love it if you could run some benchmarks, thank you!

So here's a pretty basic test. It does random reads from a bunch of
devices, I tested both 4kb and 64kb block sizes. Queue depth used is 32
for both cases, but note that this test uses a thread per device (so the
queue depth is 32 per device). Results are averaged over 3 runs.
slat/clat are the submission and completion latencies, they are in
microseconds here.

4kb random reads

kernel               sys     IOPS       slat    clat
----------------------------------------------------
2.6.32-rc3+patch    25.8%   192500      7.9     2606
2.6.32-rc3          27.4%   191300      8.4     2612



64kb random reads

kernel               sys     IOPS       slat    clat
----------------------------------------------------
2.6.32-rc3+patch     2.5%    24590      9.7     9681
2.6.32-rc3           2.5%    24580      9.4     9691

So pretty close, nothing earth shattering here. What the results above
do not show is that the 4kb test runs very stable with your patch.
Mainline fluctuates somewhat in the bandwidth, most likely due to the
varying depth.

-- 
Jens Axboe

