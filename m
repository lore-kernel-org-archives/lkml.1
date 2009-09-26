Return-Path: <linux-kernel-owner+w=401wt.eu-S1752707AbZIZTr6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707AbZIZTr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 15:47:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbZIZTr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 15:47:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbZIZTr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 15:47:57 -0400
Date: Sat, 26 Sep 2009 15:47:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Jan Kara <jack@suse.cz>,
       Theodore Tso <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
       Chris Mason <chris.mason@oracle.com>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-fsdevel@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] writeback: don't delay inodes redirtied by a fast
	dirtier
Message-ID: <20090926194747.GA1593@infradead.org>
References: <20090923123337.990689487@intel.com> <20090923124028.060887241@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090923124028.060887241@intel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 23, 2009 at 08:33:43PM +0800, Wu Fengguang wrote:
> So let's distinguish between data redirty and metadata only redirty.
> The first one is caused by a busy dirtier, while the latter one could
> happen in XFS, NFS, etc. when they are doing delalloc or updating isize.

Btw, I'm not sure the existing and preserved behaviour for that case
is good.  In the worst case the inode writeout gets delayed by another
30 seconds, doubling the window until a file is on disk if it was
extended.

