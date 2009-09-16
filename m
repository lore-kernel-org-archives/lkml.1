Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbZIPNAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbZIPNAi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZIPNAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:00:38 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56171 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbZIPNAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:00:37 -0400
Date: Wed, 16 Sep 2009 15:00:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 05/11] Assign bdi in super_block
Message-ID: <20090916130040.GM23126@kernel.dk>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com> <1253038617-30204-6-git-send-email-jens.axboe@oracle.com> <20090916121620.GD26030@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916121620.GD26030@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16 2009, Jan Kara wrote:
> On Tue 15-09-09 20:16:51, Jens Axboe wrote:
> > We do this automatically in get_sb_bdev() from the set_bdev_super()
> > callback. Filesystems that have their own private backing_dev_info
> > must assign that in ->fill_super().
> > 
> > Note that ->s_bdi assignment is required for proper writeback!
> > 
> > Acked-by: Christoph Hellwig <hch@infradead.org>
> > Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
> > ---
> >  fs/btrfs/disk-io.c |    1 +
> >  fs/fuse/inode.c    |    2 ++
> >  fs/super.c         |    6 ++++++
> >  fs/sync.c          |    9 ++++++++-
> >  fs/ubifs/super.c   |    1 +
> >  include/linux/fs.h |    1 +
> >  6 files changed, 19 insertions(+), 1 deletions(-)
>   I think we agreed that NFS needs to assign it's private BDI to sb->s_bdi,
> didn't we? From Tronds comment, that should be enough.

Oops indeed, added that one-liner now.

-- 
Jens Axboe

