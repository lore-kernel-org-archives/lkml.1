Return-Path: <linux-kernel-owner+w=401wt.eu-S1764074AbYEGIAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074AbYEGIAo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 04:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753837AbYEGIAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 04:00:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50623 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642AbYEGIAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 04:00:33 -0400
Date: Wed, 7 May 2008 04:00:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [PATCH take 2 01/28] VFS: introduce writeback_inodes_sb()
Message-ID: <20080507080027.GA23621@infradead.org>
References: <1210070159-22794-1-git-send-email-Artem.Bityutskiy@nokia.com> <1210070159-22794-2-git-send-email-Artem.Bityutskiy@nokia.com> <20080507002345.831bc379.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080507002345.831bc379.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2008 at 12:23:45AM -0700, Andrew Morton wrote:
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -573,6 +573,14 @@ void sync_inodes_sb(struct super_block *sb, int wait)
> >  	spin_unlock(&inode_lock);
> >  }
> >  
> > +void writeback_inodes_sb(struct super_block *sb, struct writeback_control *wbc)
> > +{
> > +	spin_lock(&inode_lock);
> > +	sync_sb_inodes(sb, wbc);
> > +	spin_unlock(&inode_lock);
> > +}
> This looks rather similar to
> http://userweb.kernel.org/~akpm/mmotm/broken-out/reiser4-sb_sync_inodes.patch
> 
> Which is best?

I think sync_sb_inodes should just lock/unlock the inode_lock itself as
per the patch from the reiser4 queue.  But before we export it I'd like
to review what ubifs actually does with it.

Anyone care to submit a patch to just move the locking that we could
put in ASAP?
