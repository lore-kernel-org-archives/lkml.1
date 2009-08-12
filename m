Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZHLQMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZHLQMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 12:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754108AbZHLQMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 12:12:50 -0400
Received: from brick.kernel.dk ([93.163.65.50]:37283 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbZHLQMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 12:12:49 -0400
Date: Wed, 12 Aug 2009 18:12:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 1/9] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090812161250.GK12579@kernel.dk>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-2-git-send-email-jens.axboe@oracle.com> <20090806213505.GB20538@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806213505.GB20538@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06 2009, Christoph Hellwig wrote:
> On Thu, Jul 30, 2009 at 11:23:56PM +0200, Jens Axboe wrote:
> > This is a first step at introducing per-bdi flusher threads. We should
> > have no change in behaviour, although sb_has_dirty_inodes() is now
> > ridiculously expensive, as there's no easy way to answer that question.
> > Not a huge problem, since it'll be deleted in subsequent patches.
> 
> Looking at this again and again I don't really like this at all. What
> is the problem with having per-bdi flushing threads that just iterate
> a list of superblocks per-bdi and then the inodes from there?  That
> would keep a lot of the calling conventions much more logical, as we
> have to writeback data per-sb for all data integrity and some other
> writes.

OK, so you'd prefer leaving the super block lists in place and rather
have the super blocks hanging off the bdi? What about file systems that
support more than one block device per mount, like btrfs? Can we assume
that they will forever provide a single bdi backing? btrfs currently has
this, just wondering about future implications.

-- 
Jens Axboe

