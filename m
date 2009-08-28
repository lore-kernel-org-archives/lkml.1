Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbZH1V3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbZH1V3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 17:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751619AbZH1V3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 17:29:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48465 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZH1V3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 17:29:30 -0400
Date: Fri, 28 Aug 2009 17:29:21 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Christoph Hellwig <hch@infradead.org>, Ulrich Drepper <drepper@redhat.com>,
       Jamie Lokier <jamie@shareable.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090828212921.GA13662@infradead.org>
References: <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org> <4A98008B.6050503@redhat.com> <20090828161745.GA8755@infradead.org> <4A9806D9.5050409@redhat.com> <20090828164106.GA9951@infradead.org> <4A984337.7080009@redhat.com> <20090828210838.GA26799@infradead.org> <1251494174.5984.2.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1251494174.5984.2.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 05:16:14PM -0400, Trond Myklebust wrote:
> On Fri, 2009-08-28 at 17:08 -0400, Christoph Hellwig wrote:
> > #define O_SYNC	(O_FULLSYNC|O_DSYNC)
> > 
> >  - during the normal merge window I will add a real implementation for
> >    for O_FULLSYNC and O_RSYNC
> > 
> > P.S. better naming suggestions for O_FULLSYNC welcome
> 
> Basically you are just ensuring that the metadata changes are being
> synced together with the data changes, so how about O_ISYNC (inode
> sync)?

Yeah.  Thinking about this a bit more we should define this flag
much more clearly.  In the obvious implementation it would not actually
do anything if it's set on it's own.  We would only check it if O_DSYNC
is already set to decided if we want to set the datasync argument to
->fsync to 0 or 1 for the generic filesystems (and similar things for
filesystems not using the generic helper).

If we deem that this is too unsafe we could make sure O_DSYNC always
gets set on this fag in ->open, but if we make sure O_SYNC is defined
like the one above in the kernel headers and glibc we should be fine.

Although in that case a name that doesn't suggest that it actually does
something useful would be better.
