Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbZJIKsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbZJIKsr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 06:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760767AbZJIKsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 06:48:46 -0400
Received: from brick.kernel.dk ([93.163.65.50]:36424 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760760AbZJIKsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 06:48:45 -0400
Date: Fri, 9 Oct 2009 12:48:09 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Nick Piggin <npiggin@suse.de>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       kiran@scalex86.org, peterz@infradead.org
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091009104808.GZ9228@kernel.dk>
References: <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <20091008123622.GA30316@wotan.suse.de> <20091009035050.GC4287@wotan.suse.de> <20091008.231527.251721755.davem@davemloft.net> <20091009104400.GG17818@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009104400.GG17818@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 09 2009, Nick Piggin wrote:
> On Thu, Oct 08, 2009 at 11:15:27PM -0700, David Miller wrote:
> > From: Nick Piggin <npiggin@suse.de>
> > Date: Fri, 9 Oct 2009 05:50:50 +0200
> > 
> > > OK, I got rid of this guy from the RCU walk. Basically now hold
> > > vfsmount_lock over the entire RCU path walk (which also pins the mnt)
> > > and use a seqlock in the fs struct to get a consistent mnt,dentry
> > > pair. This also simplifies the walk because we don't need the
> > > complexity to avoid mntget/mntput (just do one final mntget on the
> > > resulting mnt before dropping vfsmount_lock).
> > > 
> > > vfsmount_lock adds one per-cpu atomic for the spinlock, and we
> > > remove two thread-shared atomics for fs->lock so a net win for
> > > both single threaded performance and thread-shared scalability.
> > > Latency is no problem because we hold rcu_read_lock for the same
> > > length of time anyway.
> > > 
> > > The parallel git diff workload is improved by serveral percent.
> > 
> > Sounds sweet Nick, can't wait to play with your next set of
> > patches here.
> 
> Oh and the RCU patch there just in case you want to try some file
> open/close benchmarks. Turns out I broke Paul's new scalable RCU ;)

In that case, you may want to fix the permissions on that file :-)

I'll try the new rolled up patch.

-- 
Jens Axboe

