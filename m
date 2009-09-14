Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZINNmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZINNmJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:42:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751665AbZINNmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:42:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32970 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbZINNmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:42:06 -0400
Date: Mon, 14 Sep 2009 09:42:07 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       hch@infradead.org, tytso@mit.edu, akpm@linux-foundation.org,
       trond.myklebust@fys.uio.no
Subject: Re: [PATCH 6/7] writeback: separate starting of sync vs
	opportunistic writeback
Message-ID: <20090914134207.GA14830@infradead.org>
References: <1252920994-11141-1-git-send-email-jens.axboe@oracle.com> <1252920994-11141-7-git-send-email-jens.axboe@oracle.com> <20090914133307.GJ24075@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914133307.GJ24075@duck.suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 03:33:07PM +0200, Jan Kara wrote:
> On Mon 14-09-09 11:36:33, Jens Axboe wrote:
> > bdi_start_writeback() is currently split into two paths, one for
> > WB_SYNC_NONE and one for WB_SYNC_ALL. Add bdi_sync_writeback()
> > for WB_SYNC_ALL writeback and let bdi_start_writeback() handle
> > only WB_SYNC_NONE.
>   What I don't like about this patch is that if somebody sets up
> writeback_control with WB_SYNC_ALL mode set and then submits it to disk via
> bdi_start_writeback() it will just silently convert his writeback to an
> asynchronous one.
>   So I'd maybe leave setting of sync_mode to the caller and just WARN_ON if
> it does not match the purpose of the function...

Or initialize the wb entirely inside these functions.  For the sync case
we really only need a superblock as argument, and for writeback it's
bdi + nr_pages.  And also make sure they consistenly return void as
no one cares about the return value.

