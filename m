Return-Path: <linux-kernel-owner+w=401wt.eu-S1755133AbZEZI7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755133AbZEZI7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 04:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbZEZI7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 04:59:08 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49725 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbZEZI7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 04:59:07 -0400
Date: Tue, 26 May 2009 04:59:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chris.mason@oracle.com,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 04/12] writeback: switch to per-bdi threads for
	flushing data
Message-ID: <20090526085905.GA5094@infradead.org>
References: <1243236887-3931-1-git-send-email-jens.axboe@oracle.com> <1243236887-3931-5-git-send-email-jens.axboe@oracle.com> <20090525095816.GC23546@duck.suse.cz> <20090526085648.GD11363@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090526085648.GD11363@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 10:56:48AM +0200, Jens Axboe wrote:
> >   Hmm, so each BDI flusher thread is going to sync all the superblocks?
> > Isn't there a better way? I suppose we *should* be able to somehow go
> > from a BDI to a superblock (or maybe a list of those) so that we can write
> > per-fs metadata not bound to inodes.
> 
> I just moved the sync_supers() to the bdi_forker_task(). That makes it
> global at the same interval of wakeups, instead of doing in the bdi
> threads. It would be nice to sync locally instead, but that's something
> that can wait for later (if ever).

For now it might be easier to just have a separate thread for calling
sync_supers instead of interwinding it with the data writeback.

Btw, XFS currently has a per-device thread for that, to avoid any global
contention.

