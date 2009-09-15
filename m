Return-Path: <linux-kernel-owner+w=401wt.eu-S1753834AbZIONRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbZIONRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753598AbZIONRG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:17:06 -0400
Received: from brick.kernel.dk ([93.163.65.50]:48099 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZIONRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:17:05 -0400
Date: Tue, 15 Sep 2009 15:17:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com, tytso@mit.edu,
       akpm@linux-foundation.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 6/7] writeback: separate starting of sync vs
	opportunistic writeback
Message-ID: <20090915131707.GM23126@kernel.dk>
References: <20090914133307.GJ24075@duck.suse.cz> <20090914134207.GA14830@infradead.org> <20090914192803.GL14984@kernel.dk> <20090914194242.GM14984@kernel.dk> <20090915090847.GA12169@duck.suse.cz> <20090915091402.GG23126@kernel.dk> <20090915114426.GJ23126@kernel.dk> <20090915125855.GF12169@duck.suse.cz> <20090915130419.GL23126@kernel.dk> <20090915130829.GA7507@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915130829.GA7507@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15 2009, Christoph Hellwig wrote:
> On Tue, Sep 15, 2009 at 03:04:19PM +0200, Jens Axboe wrote:
> > 
> > >   Let's have a look at the flags in wbc:
> > >   nonblocking - Currently only set by direct callers of ->writepage() BUT
> > >                 originally wb_kupdate() and background_writeout() also
> > >                 set this flag. Since filesystems and write_cache_pages()
> > > 		use the flag we should set it for equivalent writeouts as
> > >                 well. This should be fixed...
> > 
> > Since this is all handled by the dedicated thread now, dropping the
> > nonblocking bit was on purpose. What would the point be, except for
> > stopping pdflush being blocked on request allocation?
> 
> Note that this flag just caused utter mess traditionally.  btrfs decided
> to ignore it completely and ext4 partially.  Removing this check in
> XFS increases large bufferd write loads massively.
> 
> Just half-removing it is a bad idea, though - if you don't set it
> anymore please kill it entirely.

I haven't touched it, except removing it from the caller where it
doesn't make sense anymore. If you think we should kill it completely,
then lets look at that in a few days. I've got more than enough stuff
queued up for inclusion now that I need to test and verify before doing
even more cleanups/changes :-)

-- 
Jens Axboe

