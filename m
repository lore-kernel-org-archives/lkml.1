Return-Path: <linux-kernel-owner+w=401wt.eu-S1759045AbZCXSqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759045AbZCXSqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 14:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754924AbZCXSpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 14:45:51 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41111 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbZCXSpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 14:45:50 -0400
Date: Tue, 24 Mar 2009 19:45:48 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, npiggin@suse.de
Subject: Re: [PATCH 1/7] writeback: move dirty inodes from super_block to
	backing_dev_info
Message-ID: <20090324184548.GY27476@kernel.dk>
References: <1236868428-20408-1-git-send-email-jens.axboe@oracle.com> <1236868428-20408-2-git-send-email-jens.axboe@oracle.com> <20090324161724.GA15524@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324161724.GA15524@atrey.karlin.mff.cuni.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 24 2009, Jan Kara wrote:
> > This is a first step at introducing per-bdi flusher threads. We should
> > have no change in behaviour, although sb_has_dirty_inodes() is now
> > ridiculously expensive, as there's no easy way to answer that question.
> > Not a huge problem, since it'll be deleted in subsequent patches.
>   Could you maybe expand the changelog a bit? If I read the patch right
> the only thing it does is that it moves from per-sb inode lists to
> per-bdi inode lists, right? Also sync_sb_inodes() now writes all the
> inodes in the system, not just the ones for that superblock, doesn't it?

That is correct, it just moves the dirty lists to the bdi instead of
keeping them in the superblock. It does appear that this intermediate
step doesn't honor the sb passed in, later in the series it works
though. I'll get that fixed up, as the changelog mentions we should not
have much change in behaviour at this point :-)

-- 
Jens Axboe

