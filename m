Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbXFTJVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbXFTJVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbXFTJVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:21:39 -0400
Received: from brick.kernel.dk ([80.160.20.94]:18117 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbXFTJVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:21:38 -0400
Date: Wed, 20 Jun 2007 11:20:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, davej@redhat.com,
       tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Change in default vm_dirty_ratio
Message-ID: <20070620092058.GP18863@kernel.dk>
References: <1182201271.4883.22.camel@localhost.localdomain> <20070618164711.9de1c38e.akpm@linux-foundation.org> <20070620042434.GC12096@redhat.com> <20070619214407.dfff0ca6.akpm@linux-foundation.org> <1182328536.21117.24.camel@twins> <20070620015826.03f1d71a.akpm@linux-foundation.org> <20070620091404.GO18863@kernel.dk> <1182331182.21117.39.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182331182.21117.39.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20 2007, Peter Zijlstra wrote:
> On Wed, 2007-06-20 at 11:14 +0200, Jens Axboe wrote:
> > On Wed, Jun 20 2007, Andrew Morton wrote:
> > > Perhaps our queues are too long - if the VFS _does_ back off, it'll take
> > > some time for that to have an effect.
> > > 
> > > Perhaps the fact that the queue size knows nothing about the _size_ of the
> > > requests in the queue is a problem.
> > 
> > It's complicated, the size may not matter a lot. 128 sequential 512kb IO
> > may complete faster than 128 random 4kb IO's.
> 
> Yes, is there any way a queue could be limited to a certain amount of
> 'completion time' ?

Not easily, we'd need some sort of disk profile for that to be remotely
reliable.

> > > Back away even further here.
> > > 
> > > What user-visible problem(s) are we attemping to fix?
> > 
> > I'd like innocent-app-doing-little-write-or-fsync not being stalled by
> > big-bad-app-doing-lots-of-dirtying.
> 
> Could you please try this per BDI dirty limit -v7 patch series, the very
> last patch tries to address this by taking the per task dirty rate into
> account.

Yeah, I've been watching your patchset with interesting. Hope it'll get
merged some time soon, I think it's a real problem.

> Although, on the fsync, ext3 seems to want to do a global fsync, which
> will still make the experience suck. :-(

Yeah well, extX sucks on many levels :-)

-- 
Jens Axboe

