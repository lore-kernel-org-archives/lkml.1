Return-Path: <linux-kernel-owner+w=401wt.eu-S1764107AbZE1Ti7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764107AbZE1Ti7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 15:38:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756861AbZE1Tiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 15:38:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39364 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907AbZE1Tiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 15:38:50 -0400
Date: Thu, 28 May 2009 15:38:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Theodore Tso <tytso@mit.edu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Jan Kara <jack@suse.cz>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr,
       Alex Chiang <achiang@hp.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 0/11] Per-bdi writeback flusher threads v8
Message-ID: <20090528193822.GA30982@infradead.org>
References: <20090527144754.GD10842@mit.edu> <20090527175353.GE10842@mit.edu> <20090527175830.GF10842@mit.edu> <20090527181402.GP11363@kernel.dk> <20090527191524.GS11363@kernel.dk> <20090527194543.GT11363@kernel.dk> <20090528004959.GH26625@mit.edu> <20090528092803.GE29199@duck.suse.cz> <m1octdw8sv.fsf@fess.ebiederm.org> <20090528193246.GX26625@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090528193246.GX26625@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 03:32:46PM -0400, Theodore Tso wrote:
> 
> I'm pretty sure that after the first call to invalidate_inodes() in
> fs/super.c's generic_shutdown_super(), we really don't need to hold
> the BKL or the superblock lock (and let the filesystems' low-level
> write_super(0 and put_super() take the lock if they really need it),
> but we probably need to take a closer look at this to make sure it's
> true for all filesystems.  (IIRC, I think Christoph was looking to
> clean up lock_super(); at least with respect to the write_super call.
> I don't know what his plans regarding the BKL and put_super(),
> though.)

Both the BKL and lock_super are not held for ->put_super anymore in
the vfs tree.  In fact in the vfs tree there are no callers of
lock_super in the VFS anymore.

