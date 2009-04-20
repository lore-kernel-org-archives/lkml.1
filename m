Return-Path: <linux-kernel-owner+w=401wt.eu-S1757671AbZDTVkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbZDTVkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757778AbZDTVkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:40:22 -0400
Received: from cmpxchg.org ([85.214.51.133]:60908 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757309AbZDTVkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:40:21 -0400
Date: Mon, 20 Apr 2009 23:38:56 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, riel@redhat.com,
       hugh@veritas.com
Subject: Re: [patch 3/3][rfc] vmscan: batched swap slot allocation
Message-ID: <20090420213856.GA26266@cmpxchg.org>
References: <1240259085-25872-1-git-send-email-hannes@cmpxchg.org> <1240259085-25872-3-git-send-email-hannes@cmpxchg.org> <20090420203119.GA26066@cmpxchg.org> <20090420135303.75471bc1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090420135303.75471bc1.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 01:53:03PM -0700, Andrew Morton wrote:
> On Mon, 20 Apr 2009 22:31:19 +0200
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > A test program creates an anonymous memory mapping the size of the
> > system's RAM (2G).  It faults all pages of it linearly, then kicks off
> > 128 reclaimers (on 4 cores) that map, fault and unmap 2G in sum and
> > parallel, thereby evicting the first mapping onto swap.
> > 
> > The time is then taken for the initial mapping to get faulted in from
> > swap linearly again, thus measuring how bad the 128 reclaimers
> > distributed the pages on the swap space.
> > 
> >   Average over 5 runs, standard deviation in parens:
> > 
> >       swap-in          user            system            total
> > 
> > old:  74.97s (0.38s)   0.52s (0.02s)   291.07s (3.28s)   2m52.66s (0m1.32s)
> > new:  45.26s (0.68s)   0.53s (0.01s)   250.47s (5.17s)   2m45.93s (0m2.63s)
> > 
> > where old is current mmotm snapshot 2009-04-17-15-19 and new is these
> > three patches applied to it.
> > 
> > Test program attached.  Kernbench didn't show any differences on my
> > single core x86 laptop with 256mb ram (poor thing).
> 
> qsbench is pretty good at fragmenting swapspace.  It would be vaguely
> interesting to see what effect you've had on its runtime.
> 
> I've found that qsbench's runtimes are fairly chaotic when it's
> operating at the transition point between all-in-core and
> madly-swapping, so a bit of thought and caution is needed.
>
> I used to run it with
> 
> 	./qsbench -p 4 -m 96
> 
> on a 256MB machine and it had sufficiently repeatable runtimes to be
> useful.
> 
> There's a copy of qsbench in
> http://userweb.kernel.org/~akpm/stuff/ext3-tools.tar.gz

Thanks a lot.

> I wonder what effect this patch has upon hibernate/resume performance.

Good point, I will test this.
