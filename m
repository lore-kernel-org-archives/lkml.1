Return-Path: <linux-kernel-owner+w=401wt.eu-S1758753AbZAMOEA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758753AbZAMOEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 09:04:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZAMODv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 09:03:51 -0500
Received: from THUNK.ORG ([69.25.196.29]:47565 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZAMODu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 09:03:50 -0500
Date: Tue, 13 Jan 2009 09:03:47 -0500
From: Theodore Tso <tytso@mit.edu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@suse.cz>, kernel list <linux-kernel@vger.kernel.org>,
       jack@suse.cz, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: ext2 + -osync: not as easy as it seems
Message-ID: <20090113140347.GD17664@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Pavel Machek <pavel@suse.cz>,
	kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz,
	Jens Axboe <jens.axboe@oracle.com>
References: <20090113131418.GD30352@atrey.karlin.mff.cuni.cz> <20090113134503.41318144@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090113134503.41318144@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a barrier shouldn't be that hard; just a matter adding a call
to blkdev_issue_flush() to ext2_sync_file() before it returns.

BTW, I think there's a stale documentation bug in in
block/blk-barrier.c, around line 305:

  * Description:
  *    Issue a flush for the block device in question. Caller can supply
  *    room for storing the error offset in case of a flush error, if they
- *    wish to.  Caller must run wait_for_completion() on its own.
+ *    wish to.
  */
 int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 {

Jens, is that right?

						- Ted
