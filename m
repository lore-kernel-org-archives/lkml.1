Return-Path: <linux-kernel-owner+w=401wt.eu-S933927AbZDBQzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927AbZDBQzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:55:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933022AbZDBQzM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:55:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40810 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765582AbZDBQzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:55:10 -0400
Date: Thu, 2 Apr 2009 12:55:05 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
       viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of
	data to an inode [ver #46]
Message-ID: <20090402165505.GA21859@infradead.org>
References: <200904030100.05741.nickpiggin@yahoo.com.au> <200904030232.59355.nickpiggin@yahoo.com.au> <20090402163712.GA25177@infradead.org> <200904030347.21470.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904030347.21470.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 03:47:20AM +1100, Nick Piggin wrote:
> Well they now are quite well filesystem defined. We no longer take
> the page lock before calling them. Not saying it's perfect, but if
> the backing fs is just using a known subset of ones that work
> (like loop does).

The page lock doesn't matter.  What matters is locks protecting the
io.  Like the XFS iolock or cluster locks in the cluster filesystems,
and you will get silent data corruption that way.

I would have sworn loop was fixed by now as gfs people were seeing
these issues and submitting patches, but it looks like we never sorted
this out upstream.

> Probably yes. But it seems like it should have more discussion IMO
> (unless it has already been had and I missed it).

This came up plenty of times.

> I don't think "write_one_page" sounds like a particularly good new
> API addition.

I also thing it's not a nice one.  I still haven't seen a really good
explanation of why it can't just use plain ->write

