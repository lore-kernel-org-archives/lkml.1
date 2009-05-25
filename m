Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbZEYHq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbZEYHq7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752824AbZEYHqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:46:47 -0400
Received: from brick.kernel.dk ([93.163.65.50]:60301 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752017AbZEYHqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:46:46 -0400
Date: Mon, 25 May 2009 09:46:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, akpm@linux-foundation.org,
       jack@suse.cz, yanmin_zhang@linux.intel.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/13] scsi: unify allocation of scsi command and sense
	buffer
Message-ID: <20090525074647.GK11363@kernel.dk>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com> <1243236668-3398-6-git-send-email-jens.axboe@oracle.com> <20090525074124.GA31746@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090525074124.GA31746@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25 2009, Christoph Hellwig wrote:
> On Mon, May 25, 2009 at 09:30:48AM +0200, Jens Axboe wrote:
> > Fold the sense buffer into the command, thereby eliminating a slab
> > allocation and free per command.
> 
> Might help to send it to linux-scsi to get people to review and apply it
> :)

yeah, as I later posted, this wasn't meant to be sent out as part of
the writeback series :-)

> But that patch looks good to me, avoiding one allocation for each
> command and simplifying the code.  I try to remember why these were
> two slabs to start with but can't find any reason.
> 
> Btw, we might just want to declare the sense buffer directly as a sized
> array in the scsi command as there really doesn't seem to be a reason
> not to allocate it.

That is also a workable solution. I've been trying to cut down on the
number of allocations required per-IO, and there's definitely still some
low hanging fruit there. Some of it is already included, like the inline
io_vecs in the bio.

-- 
Jens Axboe

