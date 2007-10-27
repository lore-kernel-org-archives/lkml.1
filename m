Return-Path: <linux-kernel-owner+w=401wt.eu-S1757973AbXJ0VBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbXJ0VBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 17:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbXJ0VBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 17:01:07 -0400
Received: from verein.lst.de ([213.95.11.210]:45366 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754105AbXJ0VBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 17:01:06 -0400
Date: Sat, 27 Oct 2007 23:00:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, swhiteho@redhat.com,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: gfs2_fh_to_parent() array overflow
Message-ID: <20071027210039.GA2688@lst.de>
References: <20071024162626.GJ30533@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024162626.GJ30533@stusta.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 06:26:26PM +0200, Adrian Bunk wrote:
> The Coverity checker spotted the following array overflow caused by
> commit 34c0d154243dd913c5690ae6ceb9557017429b9c:

The line is a left-over from times when gfs stored the mode of the
inode in the file handle.  It can simply be deleted.  Steve, do you
want a patch for that or could you commit that one-liner directly?

> fs/gfs2/ops_export.c contains:
> 
> <--  snip  -->
> 
> ...
> static struct dentry *gfs2_fh_to_parent(struct super_block *sb, struct fid *fid,
>                 int fh_len, int fh_type)
> {
>         struct gfs2_inum_host parent;
>         __be32 *fh = (__force __be32 *)fid->raw;  <------------
> 
>         switch (fh_type) {
>         case GFS2_LARGE_FH_SIZE:
>         case GFS2_OLD_FH_SIZE:
>                 parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
>                 parent.no_formal_ino |= be32_to_cpu(fh[5]);
>                 parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;
>                                                    ^^^^^
>                 parent.no_addr |= be32_to_cpu(fh[7]);
> ...                                           ^^^^^
> 
> <--  snip  -->
> 
> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
---end quoted text---
