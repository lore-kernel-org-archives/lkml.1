Return-Path: <linux-kernel-owner+w=401wt.eu-S1765826AbYBMVup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765826AbYBMVup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:50:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764300AbYBMVbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:31:49 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:50888 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762545AbYBMVb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:31:28 -0500
Date: Wed, 13 Feb 2008 23:31:12 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: gfs2_fh_to_parent() array overflow
Message-ID: <20080213213112.GU3383@cs181133002.pp.htv.fi>
References: <20071024162626.GJ30533@stusta.de> <20071027210039.GA2688@lst.de> <1193649081.1068.462.camel@quoit>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1193649081.1068.462.camel@quoit>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 09:11:21AM +0000, Steven Whitehouse wrote:
> Hi,
> 
> On Sat, 2007-10-27 at 23:00 +0200, Christoph Hellwig wrote:
> > On Wed, Oct 24, 2007 at 06:26:26PM +0200, Adrian Bunk wrote:
> > > The Coverity checker spotted the following array overflow caused by
> > > commit 34c0d154243dd913c5690ae6ceb9557017429b9c:
> > 
> > The line is a left-over from times when gfs stored the mode of the
> > inode in the file handle.  It can simply be deleted.  Steve, do you
> > want a patch for that or could you commit that one-liner directly?
> > 
> 
> I'm just back from holiday this morning and this is looking a bit more
> complicated than that... give me a day or two and I'll try and come up
> with a solution,

This issue is still present in 2.6.25-rc1.

> Steve.
> 
> > > fs/gfs2/ops_export.c contains:
> > > 
> > > <--  snip  -->
> > > 
> > > ...
> > > static struct dentry *gfs2_fh_to_parent(struct super_block *sb, struct fid *fid,
> > >                 int fh_len, int fh_type)
> > > {
> > >         struct gfs2_inum_host parent;
> > >         __be32 *fh = (__force __be32 *)fid->raw;  <------------
> > > 
> > >         switch (fh_type) {
> > >         case GFS2_LARGE_FH_SIZE:
> > >         case GFS2_OLD_FH_SIZE:
> > >                 parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
> > >                 parent.no_formal_ino |= be32_to_cpu(fh[5]);
> > >                 parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;
> > >                                                    ^^^^^
> > >                 parent.no_addr |= be32_to_cpu(fh[7]);
> > > ...                                           ^^^^^
> > > 
> > > <--  snip  -->
> > > 
> > > 
> > > cu
> > > Adrian
> > > 

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

