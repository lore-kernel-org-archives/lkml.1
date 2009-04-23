Return-Path: <linux-kernel-owner+w=401wt.eu-S1758382AbZDWNKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758382AbZDWNKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 09:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbZDWNJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 09:09:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37820 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZDWNJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 09:09:46 -0400
Date: Thu, 23 Apr 2009 09:09:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] vfs: Fix sys_sync() and fsync_super() reliability
Message-ID: <20090423130946.GA3695@infradead.org>
References: <1240415781-17834-1-git-send-email-jack@suse.cz> <1240415781-17834-2-git-send-email-jack@suse.cz> <20090423111040.GB4833@infradead.org> <20090423130724.GA20896@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423130724.GA20896@duck.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 03:07:24PM +0200, Jan Kara wrote:
> > Another thing I want to do in this area is sort out the meaning of
> > write_super.  I'd really prefer to have every filesystem implement
> > ->sync_fs for actual data-integerity syncs, and only leave ->write_super
> > for the periodic writeouts, as the current implementation is extrenly
> > confusing and causes a lot of trouble for filesystems doing their own
> > periodic sb writeback.
>   Yes, that would be nice but I guess it's a partly a separate issue
> (and has to touch a lot of filesystems). I'll keep write_supers() call in
> the next version of the patch so that this split isn't made harded by it.

Yeah, separate issue.  We need to do this sync massaging in a couple of
small steps..

