Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab0BKPKl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 10:10:41 -0500
Received: from mojo.mkp.net ([70.38.64.14]:51762 "EHLO mojo.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab0BKPKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 10:10:40 -0500
X-Greylist: delayed 1835 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Feb 2010 10:10:40 EST
To: Christoph Hellwig <hch@infradead.org>
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH 1/4] block: implement compatible DISCARD support
From: "Martin K. Petersen" <mkp@mkp.net>
References: <1265885625-21608-1-git-send-email-dmonakhov@openvz.org>
	<20100211122154.GA12417@infradead.org>
Date: Thu, 11 Feb 2010 09:40:05 -0500
In-Reply-To: <20100211122154.GA12417@infradead.org> (Christoph Hellwig's
	message of "Thu, 11 Feb 2010 07:21:54 -0500")
Message-ID: <yq1eikrzvi2.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@infradead.org> writes:
>> 5) It use allocated_page instead of ZERO_PAGE.

Christoph> That's incorrect - both the scsi WRITE SAME and ATA UNMAP
Christoph> implementations write to the payload.  I have some plans to
Christoph> change that an get rid of the payload entirely, but I need to
Christoph> get back to the discard work and look at it in more detail.

I've been away for a couple of weeks (got back yesterday).  Just a heads
up that I've been working on block layer support for WRITE SAME as well
as a discard revamp the last little while.  I'll try to post those
patches today or tomorrow.

Just to give you an idea: I distinguish between discarding, clearing,
and filling a block range.

blkdev_issue_clear() is used for explicitly zeroing a region.  If the
target supports RZAT/TPRZ, discard will be used instead of zero filling.

blkdev_issue_discard() is for trimming without caring about what's left
in the blocks.  And blkdev_issue_fill() can be used to do a write same
pass on a range (for bulk initializing RAID blocks, for instance).

-- 
Martin K. Petersen	Oracle Linux Engineering

