Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbXFUWyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbXFUWyL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 18:54:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750804AbXFUWx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 18:53:57 -0400
Received: from waste.org ([66.93.16.53]:60875 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbXFUWx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 18:53:56 -0400
Date: Thu, 21 Jun 2007 17:53:20 -0500
From: Matt Mackall <mpm@selenic.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, davej@redhat.com,
       tim.c.chen@linux.intel.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: Change in default vm_dirty_ratio
Message-ID: <20070621225320.GP11166@waste.org>
References: <1182201271.4883.22.camel@localhost.localdomain> <20070618164711.9de1c38e.akpm@linux-foundation.org> <20070620042434.GC12096@redhat.com> <20070619214407.dfff0ca6.akpm@linux-foundation.org> <1182328536.21117.24.camel@twins> <20070620015826.03f1d71a.akpm@linux-foundation.org> <20070620091404.GO18863@kernel.dk> <1182331182.21117.39.camel@twins> <20070620092058.GP18863@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070620092058.GP18863@kernel.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 11:20:59AM +0200, Jens Axboe wrote:
> On Wed, Jun 20 2007, Peter Zijlstra wrote:
> > On Wed, 2007-06-20 at 11:14 +0200, Jens Axboe wrote:
> > > On Wed, Jun 20 2007, Andrew Morton wrote:
> > > > Perhaps our queues are too long - if the VFS _does_ back off, it'll take
> > > > some time for that to have an effect.
> > > > 
> > > > Perhaps the fact that the queue size knows nothing about the _size_ of the
> > > > requests in the queue is a problem.
> > > 
> > > It's complicated, the size may not matter a lot. 128 sequential 512kb IO
> > > may complete faster than 128 random 4kb IO's.
> > 
> > Yes, is there any way a queue could be limited to a certain amount of
> > 'completion time' ?
> 
> Not easily, we'd need some sort of disk profile for that to be remotely
> reliable.

Perhaps we want to throw some sliding window algorithms at it. We can
bound requests and total I/O and if requests get retired too slowly we
can shrink the windows. Alternately, we can grow the window if we're
retiring things within our desired timeframe.

-- 
Mathematics is the supreme nostalgia of our time.
