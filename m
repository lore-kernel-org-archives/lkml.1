Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbZIONIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbZIONIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbZIONI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:08:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49185 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZIONI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:08:29 -0400
Date: Tue, 15 Sep 2009 09:08:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, tytso@mit.edu, akpm@linux-foundation.org,
       trond.myklebust@fys.uio.no
Subject: Re: [PATCH 6/7] writeback: separate starting of sync vs
	opportunistic writeback
Message-ID: <20090915130829.GA7507@infradead.org>
References: <1252920994-11141-7-git-send-email-jens.axboe@oracle.com> <20090914133307.GJ24075@duck.suse.cz> <20090914134207.GA14830@infradead.org> <20090914192803.GL14984@kernel.dk> <20090914194242.GM14984@kernel.dk> <20090915090847.GA12169@duck.suse.cz> <20090915091402.GG23126@kernel.dk> <20090915114426.GJ23126@kernel.dk> <20090915125855.GF12169@duck.suse.cz> <20090915130419.GL23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915130419.GL23126@kernel.dk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 03:04:19PM +0200, Jens Axboe wrote:
> 
> >   Let's have a look at the flags in wbc:
> >   nonblocking - Currently only set by direct callers of ->writepage() BUT
> >                 originally wb_kupdate() and background_writeout() also
> >                 set this flag. Since filesystems and write_cache_pages()
> > 		use the flag we should set it for equivalent writeouts as
> >                 well. This should be fixed...
> 
> Since this is all handled by the dedicated thread now, dropping the
> nonblocking bit was on purpose. What would the point be, except for
> stopping pdflush being blocked on request allocation?

Note that this flag just caused utter mess traditionally.  btrfs decided
to ignore it completely and ext4 partially.  Removing this check in
XFS increases large bufferd write loads massively.

Just half-removing it is a bad idea, though - if you don't set it
anymore please kill it entirely.

