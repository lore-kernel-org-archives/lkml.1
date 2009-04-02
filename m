Return-Path: <linux-kernel-owner+w=401wt.eu-S934627AbZDBR1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934627AbZDBR1y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934549AbZDBR0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:26:55 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38285 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934608AbZDBR0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:26:54 -0400
Date: Thu, 2 Apr 2009 19:26:52 +0200
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
       viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of data to an inode [ver #46]
Message-ID: <20090402172652.GE17275@atrey.karlin.mff.cuni.cz>
References: <200904030100.05741.nickpiggin@yahoo.com.au> <200904030347.21470.nickpiggin@yahoo.com.au> <20090402165505.GA21859@infradead.org> <200904030407.55471.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904030407.55471.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Friday 03 April 2009 03:55:05 Christoph Hellwig wrote:
> > On Fri, Apr 03, 2009 at 03:47:20AM +1100, Nick Piggin wrote:
> > > Well they now are quite well filesystem defined. We no longer take
> > > the page lock before calling them. Not saying it's perfect, but if
> > > the backing fs is just using a known subset of ones that work
> > > (like loop does).
> > 
> > The page lock doesn't matter.  What matters is locks protecting the
> > io.  Like the XFS iolock or cluster locks in the cluster filesystems,
> > and you will get silent data corruption that way.
> 
> Hmm, I can see i_mutex being a problem, but can't see how a filesystem
> takes any other locks down that chain?
  Yes, i_mutex is one problem. Then filesystems may take other locks
in their ->aio_write callbacks - as Christoph mentioned, for example
OCFS2 has to do some network messaging to synchronize nodes in the
cluster accessing the file. I could imagine some clever filesystem doing
more clever locking than just one i_mutex covering the whole file...

> Naturally a random in-kernel user misses other important things, so yes
> a simple write sounds like the best option.
  Definitely. IMO it's hard to get the locking right without calling
->aio_write callback.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
