Return-Path: <linux-kernel-owner+w=401wt.eu-S1756902AbZINTml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756902AbZINTml (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 15:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZINTml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 15:42:41 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44050 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756882AbZINTmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 15:42:40 -0400
Date: Mon, 14 Sep 2009 21:42:43 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, tytso@mit.edu,
       akpm@linux-foundation.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 6/7] writeback: separate starting of sync vs
	opportunistic writeback
Message-ID: <20090914194242.GM14984@kernel.dk>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com> <1252920994-11141-7-git-send-email-jens.axboe@oracle.com> <20090914133307.GJ24075@duck.suse.cz> <20090914134207.GA14830@infradead.org> <20090914192803.GL14984@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914192803.GL14984@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14 2009, Jens Axboe wrote:
> On Mon, Sep 14 2009, Christoph Hellwig wrote:
> > On Mon, Sep 14, 2009 at 03:33:07PM +0200, Jan Kara wrote:
> > > On Mon 14-09-09 11:36:33, Jens Axboe wrote:
> > > > bdi_start_writeback() is currently split into two paths, one for
> > > > WB_SYNC_NONE and one for WB_SYNC_ALL. Add bdi_sync_writeback()
> > > > for WB_SYNC_ALL writeback and let bdi_start_writeback() handle
> > > > only WB_SYNC_NONE.
> > >   What I don't like about this patch is that if somebody sets up
> > > writeback_control with WB_SYNC_ALL mode set and then submits it to disk via
> > > bdi_start_writeback() it will just silently convert his writeback to an
> > > asynchronous one.
> > >   So I'd maybe leave setting of sync_mode to the caller and just WARN_ON if
> > > it does not match the purpose of the function...
> > 
> > Or initialize the wb entirely inside these functions.  For the sync case
> > we really only need a superblock as argument, and for writeback it's
> > bdi + nr_pages.  And also make sure they consistenly return void as
> > no one cares about the return value.
> 
> Yes, I thought about doing that and like that better than the warning.
> Just pass in the needed args and allocate+fill the wbc on stack. I'll
> make that change.

That works out much better, imho:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=270c12655d7d11e234d335a8ab0540c02c034b66

-- 
Jens Axboe

