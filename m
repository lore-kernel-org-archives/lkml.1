Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbZETMQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbZETMQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 08:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755684AbZETMQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 08:16:29 -0400
Received: from brick.kernel.dk ([93.163.65.50]:41997 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745AbZETMQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 08:16:29 -0400
Date: Wed, 20 May 2009 14:16:30 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 02/11] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090520121629.GW11363@kernel.dk>
References: <1242649192-16263-1-git-send-email-jens.axboe@oracle.com> <1242649192-16263-3-git-send-email-jens.axboe@oracle.com> <20090520111850.GB3760@duck.suse.cz> <20090520113234.GT11363@kernel.dk> <20090520121111.GF3760@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090520121111.GF3760@duck.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 20 2009, Jan Kara wrote:
> On Wed 20-05-09 13:32:34, Jens Axboe wrote:
> > On Wed, May 20 2009, Jan Kara wrote:
> > >   Hi Jens,
> > > 
> > >   a few comments here. Mainly, I still don't think the sys_sync() is
> > > working right - see comments below.
> > 
> > Thanks! I took the liberty of killing some of the code in between, to
> > make it easier to see.
> > 
> > > > +void bdi_writeback_all(struct super_block *sb, long nr_pages)
> > > > +{
> > > > +	struct backing_dev_info *bdi;
> > > > +
> > > > +	rcu_read_lock();
> > > > +
> > > > +restart:
> > > > +	list_for_each_entry_rcu(bdi, &bdi_list, bdi_list) {
> > >   Isn't the RCU list here a bit overengineering? AFAICS we use the list
> > > only here and if I'm grepping right, generic_sync_sb_inodes() is currently
> > > only used for data integrity sync (after your patches) from fs-writeback.c
> > > and by UBIFS to do equivalent of writeback_inodes(). So simple spinlock
> > > guarding the list should be just fine. Or am I missing something?
> > 
> > Sure, we could. But it's really not that much of a difference,
> > implementation wise.
>   Yeah. It's just that when I see RCU, I'm a bit cautious what's going on.
> When I see spinlock, everything is simple and clear ;). And I'm in favor of
> using the simplest synchronization primitive that does it's work good
> enough ;).

It's a fine rule, I agree ;-)

I'll take another look at this when splitting the sync paths.

-- 
Jens Axboe

