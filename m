Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbZDWVwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbZDWVwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 17:52:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755777AbZDWVwa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 17:52:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59508 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251AbZDWVw3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 17:52:29 -0400
Date: Thu, 23 Apr 2009 23:52:25 +0200
From: Jan Kara <jack@suse.cz>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] vfs: Make __fsync_super() a static function
	(version 3)
Message-ID: <20090423215225.GD31584@duck.suse.cz>
References: <1240522536-2994-1-git-send-email-jack@suse.cz> <1240522536-2994-4-git-send-email-jack@suse.cz> <1240522790.8583.0.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1240522790.8583.0.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-04-09 17:39:50, Trond Myklebust wrote:
> On Thu, 2009-04-23 at 23:35 +0200, Jan Kara wrote:
> > __fsync_super() does the same thing as fsync_super(). So change the only
> > caller to use fsync_super() and make __fsync_super() static. This removes
> > unnecessarily duplicated call to sync_blockdev() and prepares ground
> > for the changes to __fsync_super() in the following patches.
> > 
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---
> >  fs/block_dev.c     |    2 +-
> >  fs/super.c         |    5 ++---
> >  include/linux/fs.h |    1 -
> >  3 files changed, 3 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/block_dev.c b/fs/block_dev.c
> > index f45dbc1..48d1290 100644
> > --- a/fs/block_dev.c
> > +++ b/fs/block_dev.c
> > @@ -240,7 +240,7 @@ struct super_block *freeze_bdev(struct block_device *bdev)
> >  		sb->s_frozen = SB_FREEZE_WRITE;
> >  		smp_wmb();
> >  
> > -		__fsync_super(sb);
> > +		fsync_super(sb);
> >  
> >  		sb->s_frozen = SB_FREEZE_TRANS;
> >  		smp_wmb();
> > diff --git a/fs/super.c b/fs/super.c
> > index d9759e0..4c92068 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> > @@ -263,7 +263,7 @@ EXPORT_SYMBOL(unlock_super);
> >   * device.  Takes the superblock lock.  Requires a second blkdev
> >   * flush by the caller to complete the operation.
> >   */
> > -void __fsync_super(struct super_block *sb)
> > +static int __fsync_super(struct super_block *sb)
> >  {
> >  	sync_inodes_sb(sb, 0);
> >  	vfs_dq_sync(sb);
> 
> Still missing the return value here :-)
  Ah, OK, but it's fixed in the last patch. I'll fix it in this one as well
for next time. Thanks.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
