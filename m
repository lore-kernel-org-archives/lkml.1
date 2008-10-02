Return-Path: <linux-kernel-owner+w=401wt.eu-S1754622AbYJBN5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622AbYJBN5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbYJBN5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:57:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:60051 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbYJBN5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:57:08 -0400
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, neilb@suse.de,
       agk@sourceware.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: Block integrity patches for 2.6.28
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
	<20081002105632.GF19428@kernel.dk>
Date: Thu, 02 Oct 2008 09:54:31 -0400
In-Reply-To: <20081002105632.GF19428@kernel.dk> (Jens Axboe's message of "Thu\, 2 Oct 2008 12\:56\:32 +0200")
Message-ID: <yq1wsgrgl0o.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Jens" == Jens Axboe <jens.axboe@oracle.com> writes:

Jens> As far as I can tell, most of that commit is still fine. You
Jens> want bdev_get_integrity() in blkdev.h, the 3 other moves and the
Jens> unused bdev_get_tag_size() do not look like they are being used
Jens> by this patch set.

bdev_get_integrity() and bdev_get_tag_size() are being used by
stacking drivers and filesystems to prepare I/O.  It's correct that
none of the in-tree stuff currently uses bdev_get_tag_size().  That's
coming with the btrfs support.  If you want to pull that out for now
and have me put that back later in that's ok.  Just adds another
two-stage merge dependency for a later cycle.

bdev_integrity_enabled() and blk_integrity_tuple_size() are only being
used from within bio-integrity.c and can move there.  I originally put
them in blkdev.h because they are block device functions and not bio
ditto.

Want me to submit a new patch shuffling bdev_get_integrity() back
where it came from?

-- 
Martin K. Petersen	Oracle Linux Engineering
