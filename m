Return-Path: <linux-kernel-owner+w=401wt.eu-S1758134AbZIPN3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134AbZIPN3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZIPN3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:29:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:49720 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZIPN3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:29:50 -0400
Date: Wed, 16 Sep 2009 15:29:52 +0200
From: Jan Kara <jack@suse.cz>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, tytso@mit.edu, akpm@linux-foundation.org,
       trond.myklebust@fys.uio.no
Subject: Re: [PATCH 10/11] writeback: splice dirty inode entries to default
	bdi on bdi_destroy()
Message-ID: <20090916132952.GI26030@duck.suse.cz>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com> <1253038617-30204-11-git-send-email-jens.axboe@oracle.com> <20090916131249.GG26030@duck.suse.cz> <20090916132108.GP23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916132108.GP23126@kernel.dk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 16-09-09 15:21:08, Jens Axboe wrote:
> On Wed, Sep 16 2009, Jan Kara wrote:
> > On Tue 15-09-09 20:16:56, Jens Axboe wrote:
> > > We cannot safely ensure that the inodes are all gone at this point
> > > in time, and we must not destroy this bdi with inodes having off it.
> >                                                         ^^^ hanging
> > 
> > > So just splice our entries to the default bdi since that one will
> > > always persist.
> >   BTW: Why can't we make sure all inodes on the BDI are clean when we
> > destroy it? Common sence would suggest that we better should be able to do
> > it :).
> >   Maybe it's because most users of private BDI do not call bdi_unregister
> > but rather directly bdi_destroy? Is this correct behavior?
> Not sure yet, it's on the TODO. This basically works around the problem
> for now at least. With dm at least, I'm seeing inodes still hanging off
> the bdi after we have done a sync_blockdev(bdev, 1);.
  Do you really mean sync_blockdev() or fsync_bdev()? Because the first one
just synces the blockdev's mapping not the filesystem...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
