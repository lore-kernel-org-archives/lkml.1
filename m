Return-Path: <linux-kernel-owner+w=401wt.eu-S1756309AbYEIUGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309AbYEIUGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 16:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYEIUGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 16:06:19 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:37260 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbYEIUGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 16:06:17 -0400
Date: Fri, 9 May 2008 16:02:27 -0400
Message-Id: <200805092002.m49K2R5p014283@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 6/9] fuse: add export operations 
In-reply-to: Your message of "Fri, 09 May 2008 15:40:30 EDT."
             <20080509194030.GA29118@infradead.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <20080509194030.GA29118@infradead.org>, Christoph Hellwig writes:
> > +struct fuse_inode_handle
> > +{
> > +	u64 nodeid;
> > +	u32 generation;
> > +};
> 
> This is the same filehandle type XFS uses for 64bit inode filesystems
> where the parent is not encoded.  I'll post a patch soon to move that
> 64bit inode handling to common code.  I don't think it's a good idea
> to delay your patch until that happens, but can you chose the fid
> types to be the same as XFS does currently so that a conversion is
> easily possible.  The fh_type should be 0x81 (fh type 1 order by 0x80
> to imply it's 64bit inodes)
> 
> In case you want to look at that patch I'v uploaded the current
> version at http://verein.lst.de/~hch/generic-64bit-inode-export
> 
> > +static struct dentry *fuse_get_dentry(struct super_block *sb,
> > +				      struct fuse_inode_handle *handle)
> > +{
> > +	struct inode *inode;
> > +	struct dentry *entry;
> > +	int err = -ESTALE;
> > +
> > +	if (handle->nodeid == 0)
> > +		goto out_err;
> > +
> > +	inode = ilookup5(sb, handle->nodeid, fuse_inode_eq, &handle->nodeid);
> > +	if (!inode)
> > +		goto out_err;
> 
> Only finding in-memory inodes for nfs export is quite dangerous.  I
> think it would be a much better idea to support whatever upcalls are
> needed to find the object if it's not in memory.  Without that the nfs
> exporting support is hardly useable.

In the ODF version of unionfs, we store the inode numbers persistently in a
small /odf partition, exactly for that reason.  It'd be wonderful if there
was kernel support for persistent inode numbers that could be used by
various virtual filesystems.

Erez.
