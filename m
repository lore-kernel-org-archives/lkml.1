Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZIKSM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZIKSM0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 14:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbZIKSMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 14:12:25 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33008 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940AbZIKSMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 14:12:24 -0400
Date: Fri, 11 Sep 2009 20:12:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, tytso@mit.edu, akpm@linux-foundation.org,
       jack@suse.cz, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 2/4] Assign bdi in super_block
Message-ID: <20090911181227.GM14984@kernel.dk>
References: <1252669832-13553-1-git-send-email-jens.axboe@oracle.com> <1252669832-13553-3-git-send-email-jens.axboe@oracle.com> <20090911180106.GB19598@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911180106.GB19598@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 11 2009, Christoph Hellwig wrote:
> On Fri, Sep 11, 2009 at 01:50:30PM +0200, Jens Axboe wrote:
> > We do this automatically in get_sb_bdev() from the set_bdev_super()
> > callback. Filesystems that have their own private backing_dev_info
> > must assign that in ->fill_super().
> > 
> > Note that ->s_bdi assignment is required for proper writeback!
> 
> Looks good to me.   Can we get rid of BDI_CAP_NO_WRITEBACK with this by
> simply not assigning a bdi?

Good question, I was indeed looking for an sb equivalent of that bdi
flag. And now ->s_bdi being set or not is indeed that. Some of our
generated writeback originates at the bdi level though, so we may or may
not have the sb. From a quick look at fs-writeback.c, it looks feasible
though. I'll try.

Can I take that as an acked-by?

-- 
Jens Axboe

