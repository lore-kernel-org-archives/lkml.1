Return-Path: <linux-kernel-owner+w=401wt.eu-S1751193AbZH0RKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751193AbZH0RKy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:10:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZH0RKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:10:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51293 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbZH0RKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:10:52 -0400
Date: Thu, 27 Aug 2009 13:10:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jamie Lokier <jamie@shareable.org>, Ulrich Drepper <drepper@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090827171044.GA5427@infradead.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090827143459.GB31453@shareable.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 03:34:59PM +0100, Jamie Lokier wrote:
> Christoph Hellwig wrote:
> > Then again they already don't get what they expect and never did,
> > so if we clear document and communicate the O_SYNC (that is Linux
> > O_SYNC) requirement we might be able to go with this.
> 
> I'm thinking, while we're looking at this, that now is a really good
> time to split up O_SYNC and O_DSYNC.
> 
> We have separate fsync and fdatasync, so it should be quite tidy now.
> 
> Then we can document using O_DSYNC on Linux, which is fine for older
> versions because it has the same value as O_SYNC at the moment.

Technically we could easily make O_SYNC really mean O_SYNC and implement
a seaprate O_DSYNC at the kernel level.

The question is how to handle this at the libc level.  Currently glibc
defines O_DSYNC to be O_SYNC.  We would need to update glibc to pass
through O_DSYNC for newer kernels and make sure it falls back to O_SYNC
for olders.  I'm not sure how feasible this is, but maybe Ulrich has
some better ideas.
