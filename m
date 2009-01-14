Return-Path: <linux-kernel-owner+w=401wt.eu-S1760012AbZANWF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760012AbZANWF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 17:05:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754634AbZANWFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 17:05:15 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:60376 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753632AbZANWFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 17:05:14 -0500
Date: Wed, 14 Jan 2009 17:04:18 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz
Subject: Re: [PATCH 2/2] ext2: Add blk_issue_flush() to syncing paths
Message-ID: <20090114220418.GN6222@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	pavel@suse.cz
References: <1231945948-23676-1-git-send-email-jack@suse.cz> <1231945948-23676-2-git-send-email-jack@suse.cz> <20090114101834.fbb9ea12.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114101834.fbb9ea12.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2009 at 10:18:34AM -0800, Andrew Morton wrote:
> /**
>  * blkdev_issue_flush - queue a flush
>  * @bdev:	blockdev to issue flush for
>  * @error_sector:	error sector
>  *
>  * Description:
>  *    Issue a flush for the block device in question. Caller can supply
>  *    room for storing the error offset in case of a flush error, if they
>  *    wish to.  Caller must run wait_for_completion() on its own.
>  */
> 
> So afaict the change you've made is incomplete.  We'll queue a
> writeback command to the disk but we won't wait for it to be sent down
> the wire.  

No, that last part of the comment is stale, and it's already been
confirmed by Jens.   He's queued in the block tree:

>From 801d773a6ff5dbb37c9eaa4b89ae3fc6574ba294 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Tue, 13 Jan 2009 09:25:08 -0500
Subject: [PATCH] block: Fix documentation for blkdev_issue_flush()

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 block/blk-barrier.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/block/blk-barrier.c b/block/blk-barrier.c
index 8eba4e4..f7dae57 100644
--- a/block/blk-barrier.c
+++ b/block/blk-barrier.c
@@ -302,7 +302,7 @@ static void bio_end_empty_barrier(struct bio *bio, int err)
  * Description:
  *    Issue a flush for the block device in question. Caller can supply
  *    room for storing the error offset in case of a flush error, if they
- *    wish to.  Caller must run wait_for_completion() on its own.
+ *    wish to.
  */
 int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 {
-- 
1.6.0.4.8.g36f27.dirty

						- Ted
