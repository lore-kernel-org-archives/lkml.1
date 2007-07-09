Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbXGIM1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbXGIM1m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 08:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbXGIM1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 08:27:30 -0400
Received: from brick.kernel.dk ([80.160.20.94]:18728 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbXGIM12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 08:27:28 -0400
Date: Mon, 9 Jul 2007 14:27:35 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>,
       Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems,
	and dm/md.
Message-ID: <20070709122735.GZ5267@kernel.dk>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown> <20070530093503.GA15559@kernel.dk> <468CE3E1.3000503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <468CE3E1.3000503@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05 2007, Tejun Heo wrote:
> Hello, Jens.
> 
> Jens Axboe wrote:
> > On Mon, May 28 2007, Neil Brown wrote:
> >> I think the implementation priorities here are:
> >>
> >> 1/ implement a zero-length BIO_RW_BARRIER option.
> >> 2/ Use it (or otherwise) to make all dm and md modules handle
> >>    barriers (and loop?).
> >> 3/ Devise and implement appropriate fall-backs with-in the block layer
> >>    so that  -EOPNOTSUP is never returned.
> >> 4/ Remove unneeded cruft from filesystems (and elsewhere).
> > 
> > This is the start of 1/ above. It's very lightly tested, it's verified
> > to DTRT here at least and not crash :-)
> > 
> > It gets rid of the ->issue_flush_fn() queue callback, all the driver
> > knowledge resides in ->prepare_flush_fn() anyways. blkdev_issue_flush()
> > then just reuses the empty-bio approach to queue an empty barrier, this
> > should work equally well for stacked and non-stacked devices.
> > 
> > While this patch isn't complete yet, it's clearly the right direction to
> > go.
> 
> Finally took a brief look. :-) I think the sequencing for zero-length
> barrier can be better done by pre-setting QUEUE_ORDSEQ_BAR in
> start_ordered() rather than short circuiting the request after it's
> issued.  What do you think?

Yeah, that might be cleaner and should achieve the same effect. I'll
test!

-- 
Jens Axboe

