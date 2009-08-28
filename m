Return-Path: <linux-kernel-owner+w=401wt.eu-S1753153AbZH1U3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153AbZH1U3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 16:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753065AbZH1U3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 16:29:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59146 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995AbZH1U3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 16:29:14 -0400
Date: Fri, 28 Aug 2009 16:29:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, akpm@linux-foundation.org, jack@suse.cz,
       yanmin_zhang@linux.intel.com, richard@rsk.demon.co.uk,
       damien.wyart@free.fr, fweisbec@gmail.com, Alan.Brunelle@hp.com
Subject: Re: [PATCH 1/9] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090828202913.GA18233@infradead.org>
References: <1248989044-21605-1-git-send-email-jens.axboe@oracle.com> <1248989044-21605-2-git-send-email-jens.axboe@oracle.com> <20090806213505.GB20538@infradead.org> <20090812161250.GK12579@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812161250.GK12579@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 06:12:50PM +0200, Jens Axboe wrote:
> OK, so you'd prefer leaving the super block lists in place and rather
> have the super blocks hanging off the bdi?

That would solve the above problem.  It would also implicitly provide
increased locality by always writing batches of dirty inodes per fs.

> What about file systems that
> support more than one block device per mount, like btrfs?

Or XFS :)

> Can we assume
> that they will forever provide a single bdi backing? btrfs currently has
> this, just wondering about future implications.

I don't see any point to assume things are forever.  For making progress
on this and getting it merged in .32 making that assumption is a good
one IMHO.

Now the question about that to do with a filesystem on multiple actual
backing device is an interesting one.  What about the case of having
btrfs just one half of two disks each?  Or same with a "normal" fs
ontop of LVM/MD?  Maybe in the end one thread(-pool) per filesystem
and not just per backing dev is the way forward, with the threads
schedule so that they don't interfer if they operate on the same
backing dev?


> 
> -- 
> Jens Axboe
> 
---end quoted text---
