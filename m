Return-Path: <linux-kernel-owner+w=401wt.eu-S1761594AbYB2AXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594AbYB2AXa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 19:23:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYB2AXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 19:23:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:48399 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbYB2AXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 19:23:19 -0500
Date: Thu, 28 Feb 2008 19:23:12 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Dave Quigley <dpquigl@tycho.nsa.gov>
Cc: Christoph Hellwig <hch@infradead.org>, viro@ftp.linux.org.uk,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/11] VFS: Add security label support to *notify
Message-ID: <20080229002312.GA9198@infradead.org>
References: <1204150294-4678-1-git-send-email-dpquigl@tycho.nsa.gov> <1204150294-4678-4-git-send-email-dpquigl@tycho.nsa.gov> <20080228235427.GA17757@infradead.org> <1204242283.2715.9.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204242283.2715.9.camel@moss-terrapins.epoch.ncsc.mil>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 06:44:43PM -0500, Dave Quigley wrote:
> The main reason for this was the way that NFS passes information it
> receives around. If you look in patch 11 you will see that
> nfsd4_decode_fattr doesn't give us access to an inode to use for
> security_inode_setsecurity and it doesn't give us a dentry to use the
> xattr helpers with. The only thing we get here is an iattr structure
> which is then passed back up to fill in the inode fields. Also without
> functionality provided by patch 1 we don't even know where to put the
> security blob we are getting from the wire. 

Take a look at how ACLs are handled.  They're passed up from the _decode
operations into a small structure that is referenced by struct
nfsd4_<operation> and pass it up until the level where the dentry
is available.

> 
> > 
> > > +#define DN_LABEL        0x00000040      /* File (re)labeled */
> > 
> > An any inotify/dnotify additions should be separate from the vfs to
> > filesystem interface.  Please make it a separate patch and describe
> > properly why it's needed in it's description.
> 
> Will do. We added them to conform to the functionality provided for
> other elements in the iattr structure. We will add a more robust
> explanation in the patch.
> 
> > 
> > > index df6b95d..1169963 100644
> > > --- a/include/linux/xattr.h
> > > +++ b/include/linux/xattr.h
> > > @@ -50,6 +50,7 @@ ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
> > >  ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
> > >  ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
> > >  int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
> > > +int vfs_setxattr_locked(struct dentry *, char *, void *, size_t, int);
> > >  int vfs_removexattr(struct dentry *, char *);
> > >  
> > >  ssize_t generic_getxattr(struct dentry *dentry, const char *name, void *buffer, size_t size);
> > > -- 
> > > 1.5.3.8
> > > 
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > ---end quoted text---
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
