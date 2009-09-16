Return-Path: <linux-kernel-owner+w=401wt.eu-S1759055AbZIPNHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759055AbZIPNHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 09:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbZIPNHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 09:07:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:56034 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbZIPNHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 09:07:03 -0400
Date: Wed, 16 Sep 2009 15:07:06 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, hch@infradead.org, tytso@mit.edu,
       akpm@linux-foundation.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 09/11] writeback: separate starting of sync vs
	opportunistic writeback
Message-ID: <20090916130705.GO23126@kernel.dk>
References: <1253038617-30204-1-git-send-email-jens.axboe@oracle.com> <1253038617-30204-10-git-send-email-jens.axboe@oracle.com> <20090916130506.GF26030@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090916130506.GF26030@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16 2009, Jan Kara wrote:
> On Tue 15-09-09 20:16:55, Jens Axboe wrote:
> > bdi_start_writeback() is currently split into two paths, one for
> > WB_SYNC_NONE and one for WB_SYNC_ALL. Add bdi_sync_writeback()
> > for WB_SYNC_ALL writeback and let bdi_start_writeback() handle
> > only WB_SYNC_NONE.
> > 
> > Push down the writeback_control allocation and only accept the
> > parameters that make sense for each function. This cleans up
> > the API considerably.
>   Nice cleanup!
> 
> > @@ -771,6 +798,8 @@ static long wb_check_old_data_flush(struct bdi_writeback *wb)
> >  		struct wb_writeback_args args = {
> >  			.nr_pages	= nr_pages,
> >  			.sync_mode	= WB_SYNC_NONE,
> > +			.for_kupdate	= 1,
> > +			.range_cyclic	= 1,
> >  		};
> >  
> >  		return wb_writeback(wb, &args);
>   This chunk should be in patch number 4.

Yeah, I wonder why that snuck into this one...

-- 
Jens Axboe

