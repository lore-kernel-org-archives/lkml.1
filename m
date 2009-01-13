Return-Path: <linux-kernel-owner+w=401wt.eu-S1761021AbZAMOIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761021AbZAMOIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761221AbZAMOI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:08:26 -0500
Received: from brick.kernel.dk ([93.163.65.50]:4470 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761185AbZAMOIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:08:25 -0500
Date: Tue, 13 Jan 2009 15:07:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090113140706.GV30821@kernel.dk>
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk> <20090113140347.GD17664@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113140347.GD17664@mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13 2009, Theodore Tso wrote:
> Adding a barrier shouldn't be that hard; just a matter adding a call
> to blkdev_issue_flush() to ext2_sync_file() before it returns.
> 
> BTW, I think there's a stale documentation bug in in
> block/blk-barrier.c, around line 305:
> 
>   * Description:
>   *    Issue a flush for the block device in question. Caller can supply
>   *    room for storing the error offset in case of a flush error, if they
> - *    wish to.  Caller must run wait_for_completion() on its own.
> + *    wish to.
>   */
>  int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
>  {
> 
> Jens, is that right?

Yep, that is indeed stale!

-- 
Jens Axboe

