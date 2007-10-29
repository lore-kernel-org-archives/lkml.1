Return-Path: <linux-kernel-owner+w=401wt.eu-S1756334AbXJ2JSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334AbXJ2JSA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 05:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbXJ2JRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 05:17:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbXJ2JRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 05:17:51 -0400
Subject: Re: gfs2_fh_to_parent() array overflow
From: Steven Whitehouse <swhiteho@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Adrian Bunk <bunk@kernel.org>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071027210039.GA2688@lst.de>
References: <20071024162626.GJ30533@stusta.de>
	 <20071027210039.GA2688@lst.de>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 29 Oct 2007 09:11:21 +0000
Message-Id: <1193649081.1068.462.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 2007-10-27 at 23:00 +0200, Christoph Hellwig wrote:
> On Wed, Oct 24, 2007 at 06:26:26PM +0200, Adrian Bunk wrote:
> > The Coverity checker spotted the following array overflow caused by
> > commit 34c0d154243dd913c5690ae6ceb9557017429b9c:
> 
> The line is a left-over from times when gfs stored the mode of the
> inode in the file handle.  It can simply be deleted.  Steve, do you
> want a patch for that or could you commit that one-liner directly?
> 

I'm just back from holiday this morning and this is looking a bit more
complicated than that... give me a day or two and I'll try and come up
with a solution,

Steve.

> > fs/gfs2/ops_export.c contains:
> > 
> > <--  snip  -->
> > 
> > ...
> > static struct dentry *gfs2_fh_to_parent(struct super_block *sb, struct fid *fid,
> >                 int fh_len, int fh_type)
> > {
> >         struct gfs2_inum_host parent;
> >         __be32 *fh = (__force __be32 *)fid->raw;  <------------
> > 
> >         switch (fh_type) {
> >         case GFS2_LARGE_FH_SIZE:
> >         case GFS2_OLD_FH_SIZE:
> >                 parent.no_formal_ino = ((u64)be32_to_cpu(fh[4])) << 32;
> >                 parent.no_formal_ino |= be32_to_cpu(fh[5]);
> >                 parent.no_addr = ((u64)be32_to_cpu(fh[6])) << 32;
> >                                                    ^^^^^
> >                 parent.no_addr |= be32_to_cpu(fh[7]);
> > ...                                           ^^^^^
> > 
> > <--  snip  -->
> > 
> > 
> > cu
> > Adrian
> > 
> > -- 
> > 
> >        "Is there not promise of rain?" Ling Tan asked suddenly out
> >         of the darkness. There had been need of rain for many days.
> >        "Only a promise," Lao Er said.
> >                                        Pearl S. Buck - Dragon Seed
> ---end quoted text---

