Return-Path: <linux-kernel-owner+w=401wt.eu-S1759330AbXLLPy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330AbXLLPy3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 10:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758703AbXLLPyK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 10:54:10 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:47802 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665AbXLLPyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 10:54:08 -0500
Date: Wed, 12 Dec 2007 08:54:07 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gabriel C <nix.or.die@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] REQ-flags to/from BIO-flags bugfix
Message-ID: <20071212155407.GK26334@parisc-linux.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <47462F3C.3040700@googlemail.com> <20071122201250.f957e280.akpm@linux-foundation.org> <47466B5D.90607@googlemail.com> <20071126221509.8f437b61.akpm@linux-foundation.org> <1197390783.3812.19.camel@localhost.localdomain> <475FB316.6040804@panasas.com> <475FBFEE.9010009@panasas.com> <20071212151813.GJ26334@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071212151813.GJ26334@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 08:18:14AM -0700, Matthew Wilcox wrote:
> I don't know whether BIO_RW_BARRIER is __REQ_SOFTBARRIER or
> __REQ_HARDBARRIER, so I didn't include that in this patch.  There also
> doesn't seem to be a __REQ equivalent to BIO_RW_AHEAD, but we can do
> the other four bits (and leave gaps for those two).

Hm.  BIO_RW_AHEAD seems unused:

willy@honeydew:~/kernel/linux-2.6$ grep -r BIO_RW_AHEAD *
block/blktrace.c:       (((rw) & (1 << BIO_RW_AHEAD)) << (2 - BIO_RW_AHEAD))
include/linux/bio.h:#define BIO_RW_AHEAD        1
include/linux/bio.h:#define bio_rw_ahead(bio)   ((bio)->bi_rw & (1 << BIO_RW_AHEAD))
willy@honeydew:~/kernel/linux-2.6$ grep -r bio_rw_ahead *
block/ll_rw_blk.c:      if (bio_rw_ahead(bio) || bio_failfast(bio))
drivers/md/dm-mpath.c:  if ((error == -EWOULDBLOCK) && bio_rw_ahead(bio))
drivers/md/multipath.c: else if (!bio_rw_ahead(bio)) {
include/linux/bio.h:#define bio_rw_ahead(bio)   ((bio)->bi_rw & (1 << BIO_RW_AHEAD))

BIO_RW_BARRIER seems to be __REQ_HARDBARRIER, but we set it
explicitly in init_request_from_bio().  We could probably simplify
init_request_from_bio() with the patch in the previous message.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
