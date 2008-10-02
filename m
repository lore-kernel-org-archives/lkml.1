Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbYJBQa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbYJBQa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753856AbYJBQaR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:30:17 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:54827 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849AbYJBQaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:30:16 -0400
Date: Thu, 2 Oct 2008 18:29:56 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: neilb@suse.de, agk@sourceware.org, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: Block integrity patches for 2.6.28
Message-ID: <20081002162955.GI19428@kernel.dk>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com> <20081002105632.GF19428@kernel.dk> <yq1wsgrgl0o.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1wsgrgl0o.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02 2008, Martin K. Petersen wrote:
> >>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:
> 
> Jens> As far as I can tell, most of that commit is still fine. You
> Jens> want bdev_get_integrity() in blkdev.h, the 3 other moves and the
> Jens> unused bdev_get_tag_size() do not look like they are being used
> Jens> by this patch set.
> 
> bdev_get_integrity() and bdev_get_tag_size() are being used by
> stacking drivers and filesystems to prepare I/O.  It's correct that
> none of the in-tree stuff currently uses bdev_get_tag_size().  That's
> coming with the btrfs support.  If you want to pull that out for now
> and have me put that back later in that's ok.  Just adds another
> two-stage merge dependency for a later cycle.

Well, I would not have added it in the first place, but it was there. I
already did the bdev_get_integrity() addon instead of the revert, so
lets please just keep it at that.

> bdev_integrity_enabled() and blk_integrity_tuple_size() are only being
> used from within bio-integrity.c and can move there.  I originally put
> them in blkdev.h because they are block device functions and not bio
> ditto.
> 
> Want me to submit a new patch shuffling bdev_get_integrity() back
> where it came from?

Do we need any on top of current for-2.6.28?

I'll apply your series with the modified patch #5, it'll probably need a
hand edit or two since I didn't revert the commit in question, but
should be trivial to resolve.


-- 
Jens Axboe

